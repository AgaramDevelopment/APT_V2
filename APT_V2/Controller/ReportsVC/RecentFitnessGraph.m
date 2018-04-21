//
//  RecentFitnessGraph.m
//  APT_V2
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "RecentFitnessGraph.h"
#import "AppCommon.h"
#import "Config.h"
#import "WebService.h"

#define ITEM_COUNT 12

@interface RecentFitnessGraph () <ChartViewDelegate, IChartAxisValueFormatter>
{
    NSMutableArray  *months;
    
    BOOL isBar;
    BOOL isLine;
    BOOL isDate;
    
    NSString *barValue;
    NSString *lineValue;
    NSString *type;
    NSString * actualDate;
}

@property (nonatomic, strong) IBOutlet CombinedChartView *chartView;

@property (nonatomic, strong) IBOutlet NSMutableArray *testArray;

@property (nonatomic, strong) IBOutlet NSMutableArray *commonArray;
@property (nonatomic, strong)  NSMutableArray *lineValuesArray;
@property (nonatomic, strong)  NSMutableArray *BarValuesArray;

@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;


@end

@implementation RecentFitnessGraph

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Combined Chart";
    self.Poptable.hidden = YES;
    [self ChartWebservice];
    
//    self.options = @[
//                     @{@"key": @"toggleLineValues", @"label": @"Toggle Line Values"},
//                     @{@"key": @"toggleBarValues", @"label": @"Toggle Bar Values"},
//                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
//                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
//                     @{@"key": @"toggleBarBorders", @"label": @"Show Bar Borders"},
//                     @{@"key": @"removeDataSet", @"label": @"Remove random set"},
//                     ];
    
    
}
-(void)chartCombined
{
//    months = @[
//               @"Jan", @"Feb", @"Mar",
//               @"Apr", @"May", @"Jun",
//               @"Jul", @"Aug", @"Sep",
//               @"Oct", @"Nov", @"Dec"
//               ];
    
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.drawBarShadowEnabled = NO;
    _chartView.highlightFullBarEnabled = NO;
    
    _chartView.drawOrder = @[
                             @(CombinedChartDrawOrderBar),
                             @(CombinedChartDrawOrderBubble),
                             @(CombinedChartDrawOrderCandle),
                             @(CombinedChartDrawOrderLine),
                             @(CombinedChartDrawOrderScatter)
                             ];
    
    ChartLegend *l = _chartView.legend;
    l.wordWrapEnabled = YES;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBothSided;
    xAxis.axisMinimum = 0.0;
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;
    
    [self updateChartData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateChartData
{
//    if (self.shouldHideData)
//    {
//        _chartView.data = nil;
//        return;
//    }
    
    [self setChartData];
}

- (void)setChartData
{
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [self generateLineData];
    data.barData = [self generateBarData];
    //data.bubbleData = [self generateBubbleData];
    //data.scatterData = [self generateScatterData];
    //data.candleData = [self generateCandleData];
    
    _chartView.xAxis.axisMaximum = data.xMax + 0.25;
    
    _chartView.data = data;
}



- (LineChartData *)generateLineData
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < self.lineValuesArray.count; index++)
    {
        
        int value = [[self.lineValuesArray objectAtIndex:index] intValue];
        [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:value]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:self.linelbl.text];
    [set setColor:[UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.fillColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

- (BarChartData *)generateBarData
{
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *entries2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < self.BarValuesArray.count; index++)
    {
        
        int value = [[self.BarValuesArray objectAtIndex:index] intValue];
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:0.0 y:value]];
        
        // stacked
        
        //[entries2 addObject:[[BarChartDataEntry alloc] initWithX:0.0 yValues:@[@(arc4random_uniform(13) + 12), @(arc4random_uniform(13) + 12)]]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:entries1 label:self.barlbl.text];
    [set1 setColor:[UIColor colorWithRed:60/255.f green:220/255.f blue:78/255.f alpha:1.f]];
    set1.valueTextColor = [UIColor colorWithRed:60/255.f green:220/255.f blue:78/255.f alpha:1.f];
    set1.valueFont = [UIFont systemFontOfSize:10.f];
    set1.axisDependency = AxisDependencyRight;
    
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries2 label:@""];
    set2.stackLabels = @[@"Stack 1", @"Stack 2"];
    set2.colors = @[
                    [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f],
                    [UIColor colorWithRed:23/255.f green:197/255.f blue:255/255.f alpha:1.f]
                    ];
    set2.valueTextColor = [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f];
    set2.valueFont = [UIFont systemFontOfSize:10.f];
    set2.axisDependency = AxisDependencyRight;
    
    float groupSpace = 0.06f;
    float barSpace = 0.02f; // x2 dataset
    float barWidth = 0.45f; // x2 dataset
    // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
    
    BarChartData *d = [[BarChartData alloc] initWithDataSets:@[set1,set2]];
    d.barWidth = barWidth;
    
    // make this BarData object grouped
    [d groupBarsFromX:0.0 groupSpace:groupSpace barSpace:barSpace]; // start at x = 0
    
    return d;
}





#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return months[(int)value % months.count];
}

-(void)ChartWebservice
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",recentFitnessKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
        NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
        NSString *barTestCode = @"";
        NSString *lineTestCode = @"";
        NSString *Years = @"1";
        
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"ClientCode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"UserrefCode"];
        if(barTestCode)   [dic    setObject:barTestCode     forKey:@"barTestCode"];
        if(lineTestCode)   [dic    setObject:lineTestCode     forKey:@"lineTestCode"];
        if(Years)   [dic    setObject:Years     forKey:@"Years"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                self.testArray = [[NSMutableArray alloc]init];
                self.testArray = [responseObject valueForKey:@"testsList"];
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
             
            
        }];
    }
    
}

- (IBAction)DateBtnAction:(id)sender
{
    isDate = YES;
    isBar = NO;
    isLine = NO;
    self.Poptable.hidden = NO;
    self.tableWidth.constant = self.dateView.frame.size.width;
    self.tableXposition.constant = self.dateView.frame.origin.x+5;
    self.commonArray = [[NSMutableArray alloc]init];
    self.commonArray = @[@"1",@"2",@"3"];
    [self.Poptable reloadData];
    
}

- (IBAction)barValueBtnAction:(id)sender
{
    isBar = YES;
    isLine = NO;
    isDate = NO;
    
    self.Poptable.hidden = NO;
    
    self.tableWidth.constant = self.barView.frame.size.width;
    self.tableXposition.constant = self.barView.frame.origin.x+5;
    
    self.commonArray = [[NSMutableArray alloc]init];
    self.commonArray = self.testArray;
    [self.Poptable reloadData];
    
}

- (IBAction)LineValueBtnAction:(id)sender
{
    isBar = NO;
    isLine = YES;
    isDate = NO;
    self.Poptable.hidden = NO;
    self.tableWidth.constant = self.lineView.frame.size.width;
    self.tableXposition.constant = self.lineView.frame.origin.x+5;
    self.commonArray = [[NSMutableArray alloc]init];
    self.commonArray = self.testArray;
    [self.Poptable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.commonArray.count;
}
// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *MyIdentifier = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    if(isDate==YES)
    {
        cell.textLabel.text = [self.commonArray objectAtIndex:indexPath.row];
    }
    else if(isBar==YES)
    {
    cell.textLabel.text = [[self.commonArray valueForKey:@"testName"] objectAtIndex:indexPath.row];
    }
    else if(isLine==YES)
    {
        cell.textLabel.text = [[self.commonArray valueForKey:@"testName"] objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isBar==YES)
    {
        if(![lineValue isEqualToString:[[self.commonArray valueForKey:@"testCode"] objectAtIndex:indexPath.row]])
        {
            self.barlbl.text = [[self.commonArray valueForKey:@"testName"] objectAtIndex:indexPath.row];
            barValue = [[self.commonArray valueForKey:@"testCode"] objectAtIndex:indexPath.row];
            self.Poptable.hidden = YES;
        }
        else
        {
            [AppCommon showAlertWithMessage:@"Please Select Another Activity"];
        }
    }
    if(isLine==YES)
    {
        if(![barValue isEqualToString:[[self.commonArray valueForKey:@"testCode"] objectAtIndex:indexPath.row]])
        {
            self.linelbl.text = [[self.commonArray valueForKey:@"testName"] objectAtIndex:indexPath.row];
            lineValue = [[self.commonArray valueForKey:@"testCode"] objectAtIndex:indexPath.row];

            self.Poptable.hidden = YES;
        }
        else
        {
            [AppCommon showAlertWithMessage:@"Please Select Another Activity"];
        }
    }
    
    if(isDate==YES)
    {
        
        self.datelbl.text = [self.commonArray  objectAtIndex:indexPath.row];
        self.Poptable.hidden = YES;

    }

    if(![self.barlbl.text isEqualToString:@""] && ![self.linelbl.text isEqualToString:@""] && ![self.datelbl.text isEqualToString:@""] )
    {
        [self chartGetValues];
    }
    
    
    
    
}

-(void)chartGetValues
{
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",recentFitnessKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
        NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
        NSString *Years = @"1";
        
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"ClientCode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"UserrefCode"];
        if(barValue)   [dic    setObject:barValue     forKey:@"barTestCode"];
        if(lineValue)   [dic    setObject:lineValue     forKey:@"lineTestCode"];
        if(Years)   [dic    setObject:Years     forKey:@"Years"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                months = [[NSMutableArray alloc]init];
                self.BarValuesArray = [[NSMutableArray alloc]init];
                self.lineValuesArray = [[NSMutableArray alloc]init];
              
                if(![[responseObject valueForKey:@"homeFitnessBars"] isEqual:[NSNull null]])
                {
                    NSMutableArray *arr = [responseObject valueForKey:@"homeFitnessBars"];
                    for(int i =0;i<arr.count;i++)
                    {
                        [months addObject:[[arr valueForKey:@"testDate"] objectAtIndex:i]];
                    }
                    for(int i=0;i<arr.count;i++)
                    {
                        NSString * value = [[arr valueForKey:@"value"] objectAtIndex:i];
                        [self.BarValuesArray addObject:value];
                    }
                }
                
                if(![[responseObject valueForKey:@"homeFitnessLines"] isEqual:[NSNull null]])
                {
                    NSMutableArray *arr1 = [responseObject valueForKey:@"homeFitnessLines"];
                    
                    for(int i =0;i<arr1.count;i++)
                    {
                        [months addObject:[[arr1 valueForKey:@"testDate"] objectAtIndex:i]];
                    }
                    
                    for(int i=0;i<arr1.count;i++)
                    {
                        NSString * value = [[arr1 valueForKey:@"value"] objectAtIndex:i];
                        [self.lineValuesArray addObject:value];
                    }
                }
                [self chartCombined];
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
             
            
        }];
    }
}

@end

