//
//  CoachBowlingLoad.m
//  APT_V2
//
//  Created by Apple on 22/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "CoachBowlingLoad.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "HorizontalXLblFormatter.h"
#import "HorizontalXLblFormatter.h"

@interface CoachBowlingLoad () <ChartViewDelegate>
{
    WebService *objWebservice;
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (nonatomic, strong)  NSMutableArray *ChartValuesArray;
@property (nonatomic, strong)  NSMutableArray *ChartXaxisValuesArray;

@end

@implementation CoachBowlingLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.DailyBtn.layer.cornerRadius = 5;
    self.DailyBtn.clipsToBounds = YES;
    
    self.WeeklyBtn.layer.cornerRadius = 5;
    self.WeeklyBtn.clipsToBounds = YES;
    
    self.MonthlyBtn.layer.cornerRadius = 5;
    self.MonthlyBtn.clipsToBounds = YES;
    [self.DailyBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)sethartData
{
    self.title = @"Line Chart 2";
    
    _chartView.delegate = self;
    
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = YES;
    
    //  _chartView.backgroundColor = [UIColor colorWithWhite:204/255.f alpha:1.f];
    _chartView.backgroundColor = [UIColor whiteColor];
    
    ChartLegend *l = _chartView.legend;
    l.form = ChartLegendFormLine;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    l.textColor = UIColor.whiteColor;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:7.f];
    xAxis.labelTextColor = UIColor.blackColor;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawAxisLineEnabled = NO;
    xAxis.labelPosition = UIBarPositionBottom;
    
    //NSArray *array = @[@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun",@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun",@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun"];
    xAxis.valueFormatter = [[HorizontalXLblFormatter alloc] initForChart: self.ChartXaxisValuesArray];
    
    
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelTextColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    
    
    NSMutableArray *values = self.ChartValuesArray;
    NSNumber *reqnum = [values objectAtIndex:0];
    for (int i = 1; i < values.count; i++) {
        reqnum = ([[values objectAtIndex:i] floatValue] > [reqnum floatValue] ? [values objectAtIndex:i]:reqnum);
    }
    NSLog(@"Largest = %@\n",l);
    // _minY = 0;
    int roundedUp = ceil([reqnum floatValue]);
    
    leftAxis.axisMaximum = roundedUp+10;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.granularityEnabled = YES;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.labelTextColor = UIColor.redColor;
    rightAxis.axisMaximum = 0;
    rightAxis.axisMinimum = 0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.granularityEnabled = NO;
    
    
    _sliderX.value = 14;
    _sliderY.value = 14;
    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2.5];
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
    
    [self setDataCount:_sliderX.value+1 range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    double spaceforbar = 10.0;
    
    //NSArray *array = @[@"10",@"20",@"30",@"20",@"40",@"60",@"20",@"70",@"20",@"30",@"20",@"40",@"60",@"20",@"70",@"20",@"30",@"20",@"40",@"60",@"20"];
    //NSArray *array1 = @[@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun",@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun"];
    //NSArray *array1 = @[@"mon",@"tue",@"wed",@"thursday",@"friday"];
    for (int i = 0; i < self.ChartValuesArray.count; i++)
    {
        //        double mult = range / 2.0;
        //        double val = (double) (arc4random_uniform(mult)) + 50;
        
        double val = [[self.ChartValuesArray objectAtIndex:i] doubleValue];
        //double val1 = [array1[i] doubleValue];
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i*spaceforbar y:val]];
    }
    
    
    
    LineChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet 1"];
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        set1.fillAlpha = 65/255.0;
        set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = NO;
        
        
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.blackColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        
        _chartView.data = data;
    }
}




#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    _sliderTextX.text = [@((int)_sliderX.value) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    
    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


- (IBAction)MonthlyAction:(id)sender
{
    [self setInningsBySelection:@"3"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    NSArray *components = [newDateString componentsSeparatedByString:@"-"];
    NSString *month = components[0];
    NSString *year = components[2];
    NSString *day = @"01";
    
    NSString *firstDayDate = [NSString stringWithFormat:@"%@-%@-%@",month,day,year];
    
    if( [self.selectionBaseKey isEqualToString:@"reportselected"])
    {
        [self chartWebserviceCoachTeam:firstDayDate:@"MONTHLY"];
    }
    else
    {
    [self chartWebservice:firstDayDate:@"MONTHLY"];
    }
}

- (IBAction)WeeklyAction:(id)sender
{
    [self setInningsBySelection:@"2"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    
    
    if( [self.selectionBaseKey isEqualToString:@"reportselected"])
    {
        [self chartWebserviceCoachTeam:newDateString:@"WEEKLY"];
    }
    else
    {
       [self chartWebservice:newDateString:@"WEEKLY"];
    }
}
- (IBAction)DailyAction:(id)sender
{
    [self setInningsBySelection:@"1"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    
    
    if( [self.selectionBaseKey isEqualToString:@"reportselected"])
    {
        [self chartWebserviceCoachTeam:newDateString:@"DAILY"];
    }
    else
    {
        [self chartWebservice:newDateString:@"DAILY"];
    }
}

-(void)chartWebservice :(NSString *)date :(NSString *)type
{
    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    NSString *playerCode;
    if( [AppCommon isCoach])
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    objWebservice = [[WebService alloc]init];
    
    //NSString *dateString = self.datelbl.text;
    
    
    
    [objWebservice BowlingLoad :BowlingLoadKey:ClientCode : playerCode :date :type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            
            NSMutableArray *reqArray = [[NSMutableArray alloc]init];
            reqArray = responseObject;
            if(reqArray.count>0)
            {
                self.ChartValuesArray = [[NSMutableArray alloc]init];
                self.ChartXaxisValuesArray = [[NSMutableArray alloc]init];
                
                for(int i=0;i<reqArray.count;i++)
                {
                    //                int timecount = [[[reqArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
                    //                int rpecount = [[[reqArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
                    //                int total = timecount * rpecount;
                    [self.ChartValuesArray addObject:[[reqArray valueForKey:@"BALL"] objectAtIndex:i]];
                    [self.ChartXaxisValuesArray addObject:[[reqArray valueForKey:@"WORKLOADDATE"] objectAtIndex:i]];
                }
                
                [self sethartData];
            }
        }
        [AppCommon hideLoading];
        
    }
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            NSLog(@"failed");
                            [COMMON webServiceFailureError:error];
                        }];
    
}

-(void)chartWebserviceCoachTeam :(NSString *)date :(NSString *)type
{
    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    NSString *playerCode;
//    if( [AppCommon isCoach])
//    {
//        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
//    }
//    else
//    {
//        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
//    }
    playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginedTeamCode"];
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    objWebservice = [[WebService alloc]init];
    
    //NSString *dateString = self.datelbl.text;
    
    
    
    [objWebservice BowlingLoad :@"MOBILE_BOWLINGLOADCHART_TEAM":ClientCode : playerCode :date :type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            
            NSMutableArray *reqArray = [[NSMutableArray alloc]init];
            reqArray = responseObject;
            if(reqArray.count>0)
            {
                self.ChartValuesArray = [[NSMutableArray alloc]init];
                self.ChartXaxisValuesArray = [[NSMutableArray alloc]init];
                
                for(int i=0;i<reqArray.count;i++)
                {
                    //                int timecount = [[[reqArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
                    //                int rpecount = [[[reqArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
                    //                int total = timecount * rpecount;
                    [self.ChartValuesArray addObject:[[reqArray valueForKey:@"BALL"] objectAtIndex:i]];
                    [self.ChartXaxisValuesArray addObject:[[reqArray valueForKey:@"PLAYERNAME"] objectAtIndex:i]];
                }
                
                [self sethartData];
            }
        }
        [AppCommon hideLoading];
        
    }
                        failure:^(AFHTTPRequestOperation *operation, id error) {
                            NSLog(@"failed");
                            [COMMON webServiceFailureError:error];
                        }];
    
}



-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.DailyBtn];
    [self setInningsButtonUnselect:self.WeeklyBtn];
    [self setInningsButtonUnselect:self.MonthlyBtn];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.DailyBtn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.WeeklyBtn];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.MonthlyBtn];
    }
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}

-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#1C1A44"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#C8C8C8"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

@end

