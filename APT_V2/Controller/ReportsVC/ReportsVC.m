//
//  ReportsVC.m
//  APT_V2
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "ReportsVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "HorizontalXLblFormatter.h"
#import "CoachTraingLoad.h"
#import "CoachBowlingLoad.h"
#import "RecentFitnessGraph.h"


@interface ReportsVC () <ChartViewDelegate>
{
    WebService *objWebservice;
    CoachTraingLoad *objtraing;
    CoachBowlingLoad *objBowling;
    RecentFitnessGraph *objRecent;
}

@property (nonatomic, strong) IBOutlet BarChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (nonatomic, strong)  NSMutableArray *chartValuesArray;
@property (nonatomic, strong)  NSMutableArray *chartXvaluesArray;

@end

@implementation ReportsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    [self customnavigationmethod];
    //[self chartWebservice];
    
    self.DailyBtn.layer.cornerRadius = 5;
    self.DailyBtn.clipsToBounds = YES;
    
    self.WeeklyBtn.layer.cornerRadius = 5;
    self.WeeklyBtn.clipsToBounds = YES;
    
    self.MonthlyBtn.layer.cornerRadius = 5;
    self.MonthlyBtn.clipsToBounds = YES;
    
    objtraing = [[CoachTraingLoad alloc] initWithNibName:@"CoachTraingLoad" bundle:nil];
    objtraing.view.frame = CGRectMake(0,0, self.TraingLoadView.bounds.size.width, self.TraingLoadView.bounds.size.height);
    [self.TraingLoadView addSubview:objtraing.view];
    
    objBowling = [[CoachBowlingLoad alloc] initWithNibName:@"CoachBowlingLoad" bundle:nil];
    objBowling.view.frame = CGRectMake(0,0, self.BowlingLoadView.bounds.size.width, self.BowlingLoadView.bounds.size.height);
    [self.BowlingLoadView addSubview:objBowling.view];
    
    objRecent = [[RecentFitnessGraph alloc] initWithNibName:@"RecentFitnessGraph" bundle:nil];
    objRecent.view.frame = CGRectMake(0,0, self.RecentFitnessView.bounds.size.width, self.RecentFitnessView.bounds.size.height);
    [self.RecentFitnessView addSubview:objRecent.view];
    
    [self.DailyBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
   // [self customnavigationmethod];
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
}

-(void)customnavigationmethod
{
    CustomNavigation *objCustomNavigation=[CustomNavigation new];
    [self.navi_View addSubview:objCustomNavigation.view];
        //    objCustomNavigation.tittle_lbl.text=@"";
    objCustomNavigation.btn_back.hidden =NO;
    objCustomNavigation.menu_btn.hidden =YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)customnavigationmethod
//{
//    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
//
//    SWRevealViewController *revealController = [self revealViewController];
//    [revealController panGestureRecognizer];
//    [revealController tapGestureRecognizer];
//
//
//    UIView* view= self.view.subviews.firstObject;
//   // [view addSubview:objCustomNavigation.view];
//
//    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
//
//    isBackEnable = YES;
//
//    objCustomNavigation.menu_btn.hidden =YES;
//    objCustomNavigation.btn_back.hidden =NO;
//    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
//
//    if (isBackEnable) {
//        objCustomNavigation.menu_btn.hidden =YES;
//        objCustomNavigation.btn_back.hidden =NO;
//        [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        objCustomNavigation.menu_btn.hidden =NO;
//        objCustomNavigation.btn_back.hidden =YES;
//        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    [self.navi_View addSubview:objCustomNavigation.view];
//    //    objCustomNavigation.tittle_lbl.text=@"";
//}

-(void)actionBack
{
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setChartData
{
    self.title = @"Stacked Bar Chart";
    
    //    self.options = @[
    //                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
    //                     @{@"key": @"toggleIcons", @"label": @"Toggle Icons"},
    //                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
    //                     @{@"key": @"animateX", @"label": @"Animate X"},
    //                     @{@"key": @"animateY", @"label": @"Animate Y"},
    //                     @{@"key": @"animateXY", @"label": @"Animate XY"},
    //                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
    //                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
    //                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
    //                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
    //                     @{@"key": @"toggleBarBorders", @"label": @"Show Bar Borders"},
    //                     ];
    
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.maxVisibleCount = 40;
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = NO;
    _chartView.highlightFullBarEnabled = NO;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.maximumFractionDigits = 1;
    leftAxisFormatter.negativeSuffix = @"";
    leftAxisFormatter.positiveSuffix = @"";
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    _chartView.rightAxis.enabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.valueFormatter = [[HorizontalXLblFormatter alloc] initForChart: self.chartXvaluesArray];
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 8.0;
    l.formToTextSpace = 4.0;
    l.xEntrySpace = 6.0;
    l.enabled = NO;
    
    
    _sliderX.value = 20.0;
    _sliderY.value = 100.0;
    [self slidersValueChanged:nil];
}

- (void)updateChartData
{
//    if (self.shouldHideData)
//    {
//        _chartView.data = nil;
//        return;
//    }
    
    [self setDataCount:_sliderX.value + 1 range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    double spaceforbar = 10.0;
    
    for (int i = 0; i < self.chartValuesArray.count; i++)
    {
//        double mult = (range + 1);
//        double val1 = (double) (arc4random_uniform(mult) + mult / 3);
//        double val2 = (double) (arc4random_uniform(mult) + mult / 3);
//        double val3 = (double) (arc4random_uniform(mult) + mult / 3);
        
        double val1 = [[[self.chartValuesArray valueForKey:@"SleepRating"]objectAtIndex:i] doubleValue];
        double val2 = [[[self.chartValuesArray valueForKey:@"FatigueRating"]objectAtIndex:i] doubleValue];
        double val3 = [[[self.chartValuesArray valueForKey:@"SoreNessRating"]objectAtIndex:i] doubleValue];
        
        double val4 = [[[self.chartValuesArray valueForKey:@"StreeRating"]objectAtIndex:i] doubleValue];
        
       // double val5 = [[[self.chartValuesArray valueForKey:@"URINECOLOUR"]objectAtIndex:i] doubleValue];
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i*spaceforbar yValues:@[@(val1), @(val2), @(val3),@(val4)] icon: [UIImage imageNamed:@"icon"]]];
    }
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        for(int i=0;i<yVals.count;i++)
        {
            NSMutableArray *dic =[[NSMutableArray alloc]init];
            [dic addObject:[yVals objectAtIndex:i]];
        
        set1 = [[BarChartDataSet alloc] initWithValues:dic label:@""];
        
        set1.drawIconsEnabled = NO;
        
        set1.colors = @[ChartColorTemplates.material[0], ChartColorTemplates.material[1], ChartColorTemplates.material[2],ChartColorTemplates.material[3],ChartColorTemplates.material[4]];
        set1.stackLabels = @[@"", @"", @""];
        [dataSets addObject:set1];
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 1;
        formatter.negativeSuffix = @"";
        formatter.positiveSuffix = @"";
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
        [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]];
        [data setValueTextColor:UIColor.whiteColor];
        [data setBarWidth:5];
        
        _chartView.fitBars = YES;
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
    NSLog(@"chartValueSelected, stack-index %ld", (long)highlight.stackIndex);
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
    [self chartWebservice:firstDayDate:@"MONTHLY"];
}

- (IBAction)WeeklyAction:(id)sender
{
    [self setInningsBySelection:@"2"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    [self chartWebservice:newDateString:@"WEEKLY"];
}
- (IBAction)DailyAction:(id)sender
{
    [self setInningsBySelection:@"1"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    [self chartWebservice:newDateString:@"DAILY"];
}


-(void)chartWebservice :(NSString *)date :(NSString *)type
{
    [AppCommon showLoading ];
    
   // NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
        NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    //NSString *clientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    //NSString *date = @"02-21-2018";
    objWebservice = [[WebService alloc]init];
    
    //NSString *dateString = self.datelbl.text;
    
    
    
    [objWebservice CoachWellnessGraph:coachWellnessKey :playerCode : date :type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            NSMutableArray *reArray = [[NSMutableArray alloc]init];
            self.chartValuesArray = [[NSMutableArray alloc]init];
            self.chartXvaluesArray = [[NSMutableArray alloc]init];
            if(![[responseObject valueForKey:@"WellnessChart"] isEqual:[NSNull null]])
            {
                self.chartValuesArray = [responseObject valueForKey:@"WellnessChart"];
                
                for(int i=0;i<self.chartValuesArray.count;i++)
                {
                NSString *xvalue = [[self.chartValuesArray valueForKey:@"WorkLoadDate"] objectAtIndex:i];
                    [self.chartXvaluesArray addObject:xvalue];
                }
                
                [self setChartData];
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

