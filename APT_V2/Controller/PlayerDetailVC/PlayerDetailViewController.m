//
//  PlayerDetailViewController.m
//  APT_V2
//
//  Created by user on 21/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Header.h"
#import "InjuryAndIllnessVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DropDownTableViewController.h"
#import "ReportsVC.h"


@interface PlayerDetailViewController () <ChartViewDelegate, IChartAxisValueFormatter, selectedDropDown>
{
    NSMutableArray* TableArray;
    NSMutableArray<NSString *> *activities;
    UIColor *originalBarBgColor;
    UIColor *originalBarTintColor;
    UIBarStyle originalBarStyle;
    NSMutableDictionary* graphDict;
    BOOL isPOP;
    ReportsVC *objrep;

}

@end

@implementation PlayerDetailViewController
@synthesize scrollView,contentView,tblDateDropDown;

@synthesize spiderChartView,TeamCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    scrollView.contentSize = contentView.frame.size;
//    [scrollView addSubview:contentView];
//    [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor];
//    [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor];
//    [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor];
//    [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor];
//    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self customnavigationmethod];

//    [self.txtTestDate setup];
      isPOP = YES;
    
     self.tblDateDropDown.hidden = YES;
    
    [self playerDetailWebservice];
    
//    activities = @[ @"Burger", @"Steak", @"Salad", @"Pasta", @"Pizza" ];
    graphDict = [NSMutableDictionary new];
    //[self chartConfiguration];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.lblAvailability.backgroundColor = self.availableColor;
   // self.lblTeamName.text = [self TeamName];
    
    NSString* age = [NSString stringWithFormat:@"%@ Years Old",[self.selectedPlayerArray valueForKey:@"Age"]];
    
    self.lblTeamName.text = [self checkNull:[self.selectedPlayerArray valueForKey:@"AthleteName"]];
    
    
    [self.imgViewPlayer sd_setImageWithURL:[NSURL URLWithString: [self checkNull:[self.selectedPlayerArray  valueForKey:@"AthletePhoto"]]] placeholderImage:[UIImage imageNamed:@"no-image"]];
    
    self.lblPlayerAge.text = age;
    
    NSString *available = [self.selectedPlayerArray valueForKey:@"PlayerAvailability"];
    
    if([available isEqualToString:@"Available"])
    {
        _lblAvailability.backgroundColor = avail;
    }
    else if([available isEqualToString:@"Not Available"])
    {
        _lblAvailability.backgroundColor = notavail;
    }
    else if([available isEqualToString:@"Rehab"])
    {
        _lblAvailability.backgroundColor = rehab;
    }

    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:NO];
    [revealController.tapGestureRecognizer setEnabled:NO];
}

-(void)chartConfiguration
{
    spiderChartView.delegate = self;
    
    spiderChartView.chartDescription.enabled = NO;
    spiderChartView.webLineWidth = 1.0;
    spiderChartView.innerWebLineWidth = 1.0;
    spiderChartView.webColor = UIColor.lightGrayColor;
    spiderChartView.innerWebColor = UIColor.lightGrayColor;
    spiderChartView.webAlpha = 1.0;
    spiderChartView.backgroundColor = UIColor.whiteColor;
    spiderChartView.sizeToFit;
    
//    RadarMarkerView *marker = (RadarMarkerView *)[RadarMarkerView viewFromXibIn:nil];
//    marker.chartView = spiderChartView;
//    spiderChartView.marker = marker;
    
    
    
    ChartXAxis *xAxis = spiderChartView.xAxis;
    xAxis.labelFont = [UIFont fontWithName:@"Montserrat-Light" size:9.f];
   // xAxis.xOffset = 0.0;
    //xAxis.yOffset = 0.0;
    xAxis.labelCount = 4;
    xAxis.axisMinimum = 0.0;
    xAxis.axisMaximum = 1.0;
    xAxis.valueFormatter = self;
    xAxis.labelTextColor = UIColor.blackColor;
    xAxis.drawLabelsEnabled = TRUE;
    
    
    
    NSMutableArray *values = [graphDict valueForKey:@"set1"];
    NSNumber *number1 = [[values objectAtIndex:0] valueForKey:@"value"];
    for (int i = 1; i < values.count; i++) {
        number1 = ([[[values objectAtIndex:i] valueForKey:@"value"]floatValue] > [number1 floatValue] ? [[values objectAtIndex:i] valueForKey:@"value"]:number1);
    }
    int roundedUp = ceil([number1 floatValue]);
    
    
    NSMutableArray *values1 = [graphDict valueForKey:@"set2"];
    NSNumber *number2 = [[values1 objectAtIndex:0] valueForKey:@"value"];
    for (int i = 1; i < values1.count; i++) {
        number2 = ([[[values1 objectAtIndex:i] valueForKey:@"value"]floatValue] > [number2 floatValue] ? [[values1 objectAtIndex:i] valueForKey:@"value"]:number2);
    }
    int roundedUp1 = ceil([number2 floatValue]);
    
    
    
    
    
    ChartYAxis *yAxis = spiderChartView.yAxis;
    yAxis.labelFont = [UIFont fontWithName:@"Montserrat-Light" size:9.f];
    yAxis.labelCount = 4;
    yAxis.axisMinimum = 0.0;
    yAxis.axisMaximum = MAX(roundedUp, roundedUp1);
    yAxis.labelTextColor = UIColor.blackColor;
    yAxis.drawLabelsEnabled = true;
    yAxis.valueFormatter = self;
    spiderChartView.setNeedsDisplay;
//    chartView.setNeedsDisplay()

    ChartLegend *l = spiderChartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.font = [UIFont fontWithName:@"Montserrat-Light" size:10.f];
//    l.xEntrySpace = 7.0;
//    l.yEntrySpace = 5.0;
    l.textColor = UIColor.blackColor;
    
//    [self updateChartData];
    
    [spiderChartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

}
#pragma mark - IAxisValueFormatter

//-(void)setlabelco

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    int tempValue = (int)value;
    int count = activities.count;
//    int str = tempValue % count;
//    return activities[(int)value % activities.count];
    return  activities.count > 0 ? activities[(int)value % activities.count] : @"0" ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setChartData:(NSDictionary *)DictValue
{
    
    NSMutableArray *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray *entries2 = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary* dict in [DictValue valueForKey:@"set1"]) {
        
        NSNumber* data1 = [dict valueForKey:@"value"];
        [entries1 addObject:[[RadarChartDataEntry alloc]initWithValue:[data1 doubleValue]]];
    }
    
    for (NSDictionary* dict in [DictValue valueForKey:@"set2"]) {

        NSNumber* data2 = [dict valueForKey:@"value"];
        [entries2 addObject:[[RadarChartDataEntry alloc]initWithValue:[data2 doubleValue]]];
    }
    
    NSString* set1Name = [[[DictValue valueForKey:@"set1"] firstObject] valueForKey:@"testDate"];
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithValues:entries1 label:set1Name];
    [set1 setColor:[UIColor colorWithRed:193/255.0 green:255/255.0 blue:130/255.0 alpha:1.0]];
    set1.fillColor = [UIColor colorWithRed:230/255.0 green:255/255.0 blue:214/255.0 alpha:1.0];

    set1.drawFilledEnabled = YES;
    set1.fillAlpha = 0.7;
    set1.lineWidth = 2.0;
    set1.drawHighlightCircleEnabled = YES;
    [set1 setDrawHighlightIndicators:NO];
    
    NSString* set2Name = [[[DictValue valueForKey:@"set2"] firstObject] valueForKey:@"testDate"];

    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithValues:entries2 label:set2Name];
    [set2 setColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:159/255.0 alpha:1.0]];
    set2.fillColor = [UIColor colorWithRed:251/255.0 green:217/255.0 blue:220/255.0 alpha:1.0];
    set2.drawFilledEnabled = YES;
    set2.fillAlpha = 0.7;
    set2.lineWidth = 2.0;
    set2.drawHighlightCircleEnabled = YES;
    [set2 setDrawHighlightIndicators:NO];
    
    RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set1, set2]];
    [data setValueFont:[UIFont fontWithName:@"Montserrat-Regular" size:8.f]];
    [data setDrawValues:YES];
    data.valueTextColor = UIColor.blackColor;
    
    spiderChartView.data = data;
    spiderChartView.notifyDataSetChanged;
}

-(void)customnavigationmethod
{
    CustomNavigation *objCustomNavigation=[CustomNavigation new];
    [self.navBarView addSubview:objCustomNavigation.view];
//    objCustomNavigation.tittle_lbl.text=@"";
    objCustomNavigation.btn_back.hidden =NO;
    objCustomNavigation.menu_btn.hidden =YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionBack
{
    [appDel.frontNavigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tblDateDropDown) {
        return 0;
    }


    return (IS_IPAD ? 40 : 35);
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tblDateDropDown) {
        return nil;
        
    }
    
    
    PlayerDetailTableViewCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"PlayerDetailTableViewCell" owner:self options:nil];
    if (!tableView.tag) {
        cell = array[0];
    }
    else
    {
        cell = array[2];
    }
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger* cellCount = 0;
    if (tableView == tblDateDropDown) {
        cellCount = [[TableArray valueForKey:@"testDates"] count];
        
        CGRect tblFrame = tblDateDropDown.frame;
        tblFrame.size.height = cellCount > 5 ? 45 * 5 : 45 * [[TableArray valueForKey:@"testDates"] count];
        
        tblDateDropDown.frame = tblFrame;
        return cellCount;
    }
    
    if (!tableView.tag) {
        cellCount = [[TableArray valueForKey:@"homeRecentForm"] count];
        [self.lblNoRecentPerformance setHidden:cellCount];
    }
    else
    {
        cellCount = [[TableArray valueForKey:@"homeHistory"] count];
        [self.lblNoHistory setHidden:cellCount];
    }
    
    return  cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (IS_IPAD ? 35 : 30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblDateDropDown) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DropDown"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DropDown"];
        }
        cell.textLabel.text =  [[[TableArray valueForKey:@"testDates"] objectAtIndex:indexPath.row] valueForKey:@"testDate"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
    
    PlayerDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Content"];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"PlayerDetailTableViewCell" owner:self options:nil];
    if (!tableView.tag) {
        cell = array[1];
        cell.lblTournamentName.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"competitionName"];
        cell.lblFormat.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"format"];
        cell.lblMat.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"matches"];
        cell.lblBat.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"bats"];
        cell.lblBowl.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"bowls"];
        cell.lblCat.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"catches"];
        cell.lblStump.text = [[[TableArray valueForKey:@"homeRecentForm"] objectAtIndex:indexPath.row] valueForKey:@"stumpings"];
    }
    else
    {
        cell = array[3];
        cell.lblModuleName.text = [[[TableArray valueForKey:@"homeHistory"] objectAtIndex:indexPath.row] valueForKey:@"ModuleName"];
        cell.lblAssessmentName.text = [[[TableArray valueForKey:@"homeHistory"] objectAtIndex:indexPath.row] valueForKey:@"AssessmentName"];
        cell.lblDate.text = [[[TableArray valueForKey:@"homeHistory"] objectAtIndex:indexPath.row] valueForKey:@"AssessmentDate"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblDateDropDown) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        spiderChartView.data = nil;
        [self chartConfiguration];
        
        self.txtTestDate.text = cell.textLabel.text;
        [self fitnessGraphWebservicebyDate:cell.textLabel.text];
        [tblDateDropDown setHidden:YES];
    }
    [scrollView setScrollEnabled:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if (!tblDateDropDown.isHidden && scrollView == self.scrollView) {
//        [tblDateDropDown setHidden:YES];
//        [scrollView setScrollEnabled:NO];
//    }else
//    {
//        [scrollView setScrollEnabled:YES];
//    }
    
    if (tblDateDropDown.tag != 4) {
        [tblDateDropDown setHidden:YES];
    }
    
}


-(void)playerDetailWebservice
{
    
    /*
     API URL        :
     API NAME       : MOBILE_RECENTDETAILS
     METHOD         : POST
     INPUT FORMAT   : JSON
     INPUT PARAMS   :
                     {
                     "ClientCode":"CLI0000001",
                     "UserrefCode":"AMR0000016",
                     "PlayerCode": "PYC0000002"
                     }
     */
    
    
    if(![COMMON isInternetReachable])
        return;
        
        [AppCommon showLoading];
    
        NSString *URLString =  URL_FOR_RESOURCE(RecentplayerDetailsKey);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
        manager.requestSerializer = requestSerializer;
    
        NSString *ClientCode = [AppCommon GetClientCode];
        NSString *UserrefCode =[AppCommon GetuserReference];
//    NSString *UserrefCode = @"AMR0000016";

       // NSString *PlayerCode = [self.selectedPlayerArray valueForKey:@"Playercode"];
       NSString *PlayerCode = [self.selectedPlayerArray valueForKey:@"AthleteCode"];
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"ClientCode"];
//        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"UserrefCode"];
        if(PlayerCode)   [dic    setObject:PlayerCode     forKey:@"UserrefCode"];
        if(PlayerCode)   [dic    setObject:PlayerCode     forKey:@"PlayerCode"];
    
        NSLog(@"USED API URL %@ \n parameters %@",URLString,dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                TableArray = [NSMutableArray new];
                TableArray = responseObject;

                [graphDict setValue:[TableArray valueForKey:@"homeFitness"] forKey:@"set1"];
                
                if ([[TableArray valueForKey:@"homeFitness"] count]) {
                    
                   NSArray* reduce = [self reduceTestName:[[TableArray valueForKey:@"homeFitness"] valueForKey:@"testName"]];
                    activities = reduce;
                    //[self setChartData:graphDict];
                    //[self.spiderChartView notifyDataSetChanged];

                    NSString* strDate = [[[TableArray valueForKey:@"testDates"] firstObject] valueForKey:@"testDate"];
                    [self fitnessGraphWebservicebyDate:strDate];
                    self.txtTestDate.text = strDate;
                }
                
        }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tblHistory reloadData];
                [self.tblRecentPerformance reloadData];
                [self.tblDateDropDown reloadData];
            });
            
            [AppCommon hideLoading];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
        }];
    
    
}


-(void)fitnessGraphWebservicebyDate:(NSString *)strDate
{
    
    /*
     API NAME       : MOBILE_RECENTDETAILSFITNESS
     METHOD         : POST
     INPUT FORMAT   : JSON
     INPUT PARAMS   :
     {
     "ClientCode":"CLI0000001",
     "UserrefCode":"AMR0000016",
     "PlayerCode": "PYC0000002",
     "AssessmentEntryDate":"07-04-2017"
     }
    
     */
    
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(RecentplayerFitnessKey);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString *UserrefCode =[AppCommon GetuserReference];
    //    NSString *UserrefCode = @"AMR0000016";
    
   // NSString *PlayerCode = [self.selectedPlayerArray valueForKey:@"Playercode"];//AthleteCode
    NSString *PlayerCode = [self.selectedPlayerArray valueForKey:@"AthleteCode"];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"ClientCode"];
//    if(UserrefCode)  [dic    setObject:UserrefCode     forKey:@"UserrefCode"];
    if(PlayerCode)  [dic    setObject:PlayerCode     forKey:@"UserrefCode"];
    if(strDate)   [dic    setObject:strDate     forKey:@"AssessmentEntryDate"];
    
    NSLog(@"USED API URL %@ \n parameters %@",URLString,dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            if ([[responseObject valueForKey:@"homeFitness"] count]) {
                NSArray* reduce = [self reduceTestName:[[responseObject valueForKey:@"homeFitness"] valueForKey:@"testName"]];
                //activities = reduce;
                
                for (NSString* temp in reduce) {
                    [activities addObject:temp];
                }
                
                [graphDict setValue:[responseObject valueForKey:@"homeFitness"] forKey:@"set2"];
                
                [self chartConfiguration];
                [self setChartData:graphDict];
                [self.spiderChartView notifyDataSetChanged];
                
            }
            
        }
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [AppCommon hideLoading];
        [COMMON webServiceFailureError:error];
        
    }];
   
}

-(NSArray *)reduceTestName:(NSArray *)testArray{
    
    NSMutableArray* tempArray = [NSMutableArray new];
    
//    NSArray *new = [testArray map:^id(NSString *obj) {
//        return [obj stringByAppendingString:@".png"];
//    }];
    
//    NSArray * newArray = [testArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj count] > 10) {
//            [obj substringToIndex:10];
//        }
//    }];
    
    for (NSString* temp in testArray) {
        NSString* str = temp;
        if (str.length > 10) {
            str = [str substringToIndex:10];
        }
        [tempArray addObject:str];
    }
    
    return tempArray;
}

- (IBAction)actionpopup:(id)sender {
  
    [tblDateDropDown setHidden:NO];
    [self.contentView bringSubviewToFront:tblDateDropDown];
    [tblDateDropDown reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)playerMultiActions:(id)sender {
    UIViewController* selectedVC;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *athletCode = [self.selectedPlayerArray valueForKey:@"AthleteCode"];
    [[NSUserDefaults standardUserDefaults] setObject:athletCode forKey:@"SelectedPlayerCode"];
    NSString *userRefCode =  [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedPlayerCode"];
    NSLog(@"userRefCode:%@", userRefCode);
    [[NSUserDefaults standardUserDefaults] synchronize];

    if ([sender tag] == 0) { // Assessment
        
        selectedVC = [ViewController new];
        ViewController* VC = selectedVC;
        VC.selectedPlayerCode = athletCode;
    }
    else if ([sender tag] == 1) // Illness
    {
        selectedVC = [InjuryAndIllnessVC new];
        InjuryAndIllnessVC* VC = selectedVC;
        VC.TeamCode = self.TeamCode;
    }
    else if ([sender tag] == 2)  // Nutrition
    {
        selectedVC = [NutritionVC new];
    }
    else if ([sender tag] == 3) // Reports
    {
        selectedVC = [ReportsVC new];
    }
    else if ([sender tag] == 4) // Wellness
    {
        selectedVC = [WellnessTrainingBowlingVC new];
    }
    
    [appDel.frontNavigationController pushViewController:selectedVC animated:YES];
}

-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}


//-(IBAction)openDropDown:(id)sender
//{
//    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
//    dropVC.protocol = self;
//    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [dropVC.view setBackgroundColor:[UIColor clearColor]];
//
//
//    dropVC.array = [TableArray valueForKey:@"testDates"];
//    dropVC.key = @"ModuleName";
//    [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX([sender superview].frame), CGRectGetMaxY([sender superview].frame)+170, CGRectGetWidth([sender frame]), 200)];
//
//    [self presentViewController:dropVC animated:YES completion:nil];
//
//}
//
//-(void)selectedValue:(NSMutableArray *)array andKey:(NSString *)key andIndex:(NSIndexPath *)Index
//{
//    NSLog(@"Selected Date %@ ",[[array objectAtIndex:Index.row]valueForKey:key]);
//    [self fitnessGraphWebservicebyDate:[[array objectAtIndex:Index.row]valueForKey:key]];
//
//}

-(IBAction)openDropDown:(id)sender
{
    if(isPOP)
    {
    self.tblDateDropDown.hidden = NO;
    self.TableWidth.constant = self.txtTestDate.frame.size.width;
        isPOP = NO;
    }
    else
    {
        self.tblDateDropDown.hidden = YES;
        isPOP = YES;
    }
}
@end
