//
//  WellnessTrainingBowlingVC.m
//  APT_V2
//
//  Created by Apple on 07/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "WellnessTrainingBowlingVC.h"
#import "AddWellnessRatingVC.h"
#import "HorizontalXLblFormatter.h"
#import "TrainingLoadVC.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "TrainingLoadUpdateVC.h"
#import "TrainingLoadGraphVC.h"
#import "SWRevealViewController.h"
#import "TrainingLoadUpdateVC.h"
#import "TrainingPiechart.h"

@interface WellnessTrainingBowlingVC ()<ChartViewDelegate,AddWelnessDelegate,AddTraingDelegate>
{
    AddWellnessRatingVC * objWell;
    TrainingLoadVC * objtraing;
    WebService *objWebservice;
    TrainingLoadUpdateVC *objUpdate;
    
    TrainingLoadGraphVC *objTrGraph;
    TrainingPiechart *objpie;
    
//    float num1;
//    float num2;
//    float num3;
//    float num4;
    
    NSString *metaSubCode1;
    NSString *metaSubCode2;
    NSString *metaSubCode3;
    NSString *metaSubCode4;
    
    //training load
    float num1;
    float num2;
    float num3;
    float num4;
    
    BOOL isToday;
    BOOL isYesterday;
    
    BOOL isWellnessExpand;
    BOOL isTraingLoadExpand;
    
  
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@property (nonatomic, strong) IBOutlet PieChartView *PiechartView;


@property (nonatomic, strong) IBOutlet UISlider *sliderPieX;
@property (nonatomic, strong) IBOutlet UISlider *sliderPieY;

@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;
@property (nonatomic, strong)  NSMutableArray *fetchedArray;

@property (nonatomic, strong)  NSMutableArray *BowlingloadXArray;
@property (nonatomic, strong)  NSMutableArray *BowlingloadYArray;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *CommonViewHeight;


//training Load

@property (strong, nonatomic) IBOutlet NSMutableArray *metaSubcodeArray;
@property (strong, nonatomic) IBOutlet NSMutableArray *todaysLoadArray;
@property (strong, nonatomic) IBOutlet NSMutableArray *yesterdayLoadArray;

@end

@implementation WellnessTrainingBowlingVC

@synthesize navView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.topviewHeight.constant = 270;
    self.traingViewHeight.constant = 350;
    
    objWebservice = [[WebService alloc]init];
    objtraing = [[TrainingLoadVC alloc] initWithNibName:@"TrainingLoadVC" bundle:nil];
    objtraing.view.frame = CGRectMake(0,10, self.trainingview.bounds.size.width, self.trainingview.bounds.size.height);
    [self.trainingview addSubview:objtraing.view];
    
//        objpie = [[TrainingPiechart alloc] initWithNibName:@"TrainingPiechart" bundle:nil];
//        objpie.view.frame = CGRectMake(0,10, self.trainingview.bounds.size.width, self.trainingview.bounds.size.height);
//        [self.trainingview addSubview:objpie.view];
    
    [self.fetchButton setTag:0];
    [self FetchWebservice];
    [self FetchTrainingWebservice];
    //[self trainingloadTodayChart];
   // [self BowlingLoadWebservice];
    
    [self.BowlingDailyBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    //traing load
    
    isToday =NO;
    isYesterday = NO;
    
    isWellnessExpand =NO;
    isTraingLoadExpand = NO;
    [self customnavigationmethod];
    
}

-(void)reloaddataVC
{
   // [self viewDidLoad];
    
    self.topviewHeight.constant = 270;
    self.traingViewHeight.constant = 350;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
    self.topviewHeight.constant = 270;
    self.traingViewHeight.constant = 350;
    
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //    [self.view addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //    objCustomNavigation.btn_back.hidden =isBackEnable;
    //
    //    objCustomNavigation.menu_btn.hidden = objCustomNavigation.btn_back.isHidden;
    //    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)actionBack
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    
}

- (IBAction)TodayBtnAction:(id)sender {
    
    if(isToday == YES)
    {
        
        isTraingLoadExpand = YES;
        objUpdate = [[TrainingLoadUpdateVC alloc] initWithNibName:@"TrainingLoadUpdateVC" bundle:nil];
        objUpdate.TodayLoadArray = self.todaysLoadArray;
        objUpdate.isToday = @"yes";
        objUpdate.Delegate = self;
        objUpdate.view.frame = CGRectMake(0,0, self.RootTrainingView.bounds.size.width, self.RootTrainingView.bounds.size.height);
        [self.RootTrainingView addSubview:objUpdate.view];
        self.traingViewHeight.constant = 600;
        [self setTotalScroll];
        
    }
}

- (IBAction)YesterdayBtnAction:(id)sender {
    
    if(isYesterday == YES)
    {
        
        //[objWell.AddTrainingBtn addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //WellnessTrainingBowlingVC *objWell = [[WellnessTrainingBowlingVC alloc] initWithNibName:@"WellnessTrainingBowlingVC" bundle:nil];
        //[objWell.AddTrainingBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        isTraingLoadExpand = YES;
        
        objUpdate = [[TrainingLoadUpdateVC alloc] initWithNibName:@"TrainingLoadUpdateVC" bundle:nil];
        objUpdate.YesterdayLoadArray = self.yesterdayLoadArray;
        objUpdate.Delegate = self;
        objUpdate.isYesterday = @"yes";
        objUpdate.view.frame = CGRectMake(0,0, self.RootTrainingView.bounds.size.width, self.RootTrainingView.bounds.size.height);
        [self.RootTrainingView addSubview:objUpdate.view];
        self.traingViewHeight.constant = 600;
        [self setTotalScroll];
    }
}

- (IBAction)AddtrainingBtnAction:(id)sender {
    
    isTraingLoadExpand = YES;
    objUpdate = [[TrainingLoadUpdateVC alloc] initWithNibName:@"TrainingLoadUpdateVC" bundle:nil];
    objUpdate.view.frame = CGRectMake(0,0, self.RootTrainingView.bounds.size.width, self.RootTrainingView.bounds.size.height);
    objUpdate.Delegate = self;
    [self.RootTrainingView addSubview:objUpdate.view];
    self.traingViewHeight.constant = 600;
    [self setTotalScroll];
}
- (IBAction)AddBtnAction:(id)sender {
    
    isWellnessExpand = YES;
    
    objWell = [[AddWellnessRatingVC alloc] initWithNibName:@"AddWellnessRatingVC" bundle:nil];
    objWell.Delegate = self;
    objWell.view.frame = CGRectMake(0,0, self.topView.bounds.size.width, self.topView.bounds.size.height);
    [self.topView addSubview:objWell.view];
    self.topviewHeight.constant = 578;
    [self setTotalScroll];
    
}

-(void)setTotalScroll
{
    if(isWellnessExpand == YES && isTraingLoadExpand == YES)
    {
        self.CommonViewHeight.constant = 1500;
    }
    else if(isWellnessExpand == YES || isTraingLoadExpand == YES)
    {
        self.CommonViewHeight.constant = 1350;
    }
    else if(isWellnessExpand == NO && isTraingLoadExpand == NO)
    {
        self.CommonViewHeight.constant = 1070;
    }
    
}
- (IBAction)FetchBtnAction:(id)sender {
    
    
    if(self.fetchButton.tag == 1)
    {
    
    objWell = [[AddWellnessRatingVC alloc] initWithNibName:@"AddWellnessRatingVC" bundle:nil];
    objWell.isFetch= @"yes";
    isWellnessExpand = YES;
    objWell.Delegate = self;
    objWell.fetchArray = self.fetchedArray;
    objWell.view.frame = CGRectMake(0,0, self.topView.bounds.size.width, self.topView.bounds.size.height);
    [self.topView addSubview:objWell.view];
    self.topviewHeight.constant = 578;
        [self setTotalScroll];
    }
    
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
    [self BowlingLoadWebservice:firstDayDate:@"MONTHLY"];
}

- (IBAction)WeeklyAction:(id)sender
{
    [self setInningsBySelection:@"2"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    [self BowlingLoadWebservice:newDateString:@"WEEKLY"];
}
- (IBAction)DailyAction:(id)sender
{
    [self setInningsBySelection:@"1"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *CurrentDate = [NSDate date];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:CurrentDate];
    [self BowlingLoadWebservice:newDateString:@"DAILY"];
}


-(BOOL)setHeight
{
    self.topviewHeight.constant = 280;
    return NO;
}

- (IBAction)TraingLoadGraohBtnAction:(id)sender {
    
    objTrGraph = [[TrainingLoadGraphVC alloc] initWithNibName:@"TrainingLoadGraphVC" bundle:nil];
    objTrGraph.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:objTrGraph.view];
}



-(void)FetchWebservice
{
    [AppCommon showLoading ];
    
    NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString * actualDate = [dateFormat stringFromDate:matchdate];
   // NSString *urinecolor= @"0";
    
    [objWebservice fetchWellness :FetchrecordWellness : playerCode :actualDate success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = responseObject;
        if(arr.count >0)
        {
            if( ![[[responseObject valueForKey:@"BodyWeight"] objectAtIndex:0] isEqual:[NSNull null]])
            {
                self.bodyWeightlbl.text = [[responseObject valueForKey:@"BodyWeight"] objectAtIndex:0];
                
                [self.fetchButton setTag:1];
                self.fetchedArray = [[NSMutableArray alloc]init];
                self.fetchedArray = [responseObject objectAtIndex:0];
            }
            if(! [[[responseObject valueForKey:@"SleepHours"] objectAtIndex:0] isEqual:[NSNull null]])
            {
                self.sleepHrlbl.text = [[responseObject valueForKey:@"SleepHours"] objectAtIndex:0];
            }
            if( ![[[responseObject valueForKey:@"SleepRatingDescription"] objectAtIndex:0] isEqual:[NSNull null]])
            {
                NSString *sleepValue = [[responseObject valueForKey:@"SleepRatingDescription"] objectAtIndex:0];
                NSArray *component = [sleepValue componentsSeparatedByString:@" "];
                self.sleeplbl.text = [NSString stringWithFormat:@"%@/7",component[0]];
            
            
                if([component[0] isEqualToString:@"1"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(24/255.0f) alpha:1.0f];
                }
                if([component[0] isEqualToString:@"2"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(102/255.0f) blue:(39/255.0f) alpha:1.0f];
                }
                if([component[0] isEqualToString:@"3"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(187/255.0f) blue:(64/255.0f) alpha:1.0f];
                }
                if([component[0] isEqualToString:@"4"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(249/255.0f) blue:(82/255.0f) alpha:1.0f];
                }
                if([component[0] isEqualToString:@"5"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(167/255.0f) green:(229/255.0f) blue:(79/255.0f) alpha:1.0f];
                }
                if([component[0] isEqualToString:@"6"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(96/255.0f) green:(208/255.0f) blue:(80/255.0f) alpha:1.0f];
                }
                if([component[0] isEqualToString:@"7"])
                {
                    self.SleepColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(179/255.0f) blue:(88/255.0f) alpha:1.0f];
                }
            }

        if( ![[[responseObject valueForKey:@"FatigueRatingDescription"] objectAtIndex:0] isEqual:[NSNull null]])
        {
                NSString *fatiqueValue = [[responseObject valueForKey:@"FatigueRatingDescription"] objectAtIndex:0];
                NSArray *component1 = [fatiqueValue componentsSeparatedByString:@" "];
                self.fatiquelbl.text = [NSString stringWithFormat:@"%@/7",component1[0]];
            
            if([component1[0] isEqualToString:@"1"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(24/255.0f) alpha:1.0f];
            }
            if([component1[0] isEqualToString:@"2"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(102/255.0f) blue:(39/255.0f) alpha:1.0f];
            }
            if([component1[0] isEqualToString:@"3"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(187/255.0f) blue:(64/255.0f) alpha:1.0f];
            }
            if([component1[0] isEqualToString:@"4"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(249/255.0f) blue:(82/255.0f) alpha:1.0f];
            }
            if([component1[0] isEqualToString:@"5"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(167/255.0f) green:(229/255.0f) blue:(79/255.0f) alpha:1.0f];
            }
            if([component1[0] isEqualToString:@"6"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(96/255.0f) green:(208/255.0f) blue:(80/255.0f) alpha:1.0f];
            }
            if([component1[0] isEqualToString:@"7"])
            {
                self.FatiqueColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(179/255.0f) blue:(88/255.0f) alpha:1.0f];
            }
        }
            
        if( ![[[responseObject valueForKey:@"SoreNessRatingDescription"] objectAtIndex:0] isEqual:[NSNull null]])
        {
                
                NSString *muscleValue = [[responseObject valueForKey:@"SoreNessRatingDescription"] objectAtIndex:0];
                NSArray *component2 = [muscleValue componentsSeparatedByString:@" "];
                self.musclelbl.text = [NSString stringWithFormat:@"%@/7",component2[0]];
            
            if([component2[0] isEqualToString:@"1"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(24/255.0f) alpha:1.0f];
            }
            if([component2[0] isEqualToString:@"2"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(102/255.0f) blue:(39/255.0f) alpha:1.0f];
            }
            if([component2[0] isEqualToString:@"3"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(187/255.0f) blue:(64/255.0f) alpha:1.0f];
            }
            if([component2[0] isEqualToString:@"4"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(249/255.0f) blue:(82/255.0f) alpha:1.0f];
            }
            if([component2[0] isEqualToString:@"5"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(167/255.0f) green:(229/255.0f) blue:(79/255.0f) alpha:1.0f];
            }
            if([component2[0] isEqualToString:@"6"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(96/255.0f) green:(208/255.0f) blue:(80/255.0f) alpha:1.0f];
            }
            if([component2[0] isEqualToString:@"7"])
            {
                self.MuscleColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(179/255.0f) blue:(88/255.0f) alpha:1.0f];
            }
        }

        if( ![[[responseObject valueForKey:@"StressRatingDescription"] objectAtIndex:0] isEqual:[NSNull null]])
        {
                NSString *stressValue = [[responseObject valueForKey:@"StressRatingDescription"] objectAtIndex:0];
                NSArray *component3 = [stressValue componentsSeparatedByString:@" "];
                self.stresslbl.text = [NSString stringWithFormat:@"%@/7",component3[0]];
            
            if([component3[0] isEqualToString:@"1"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(24/255.0f) alpha:1.0f];
            }
            if([component3[0] isEqualToString:@"2"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(102/255.0f) blue:(39/255.0f) alpha:1.0f];
            }
            if([component3[0] isEqualToString:@"3"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(187/255.0f) blue:(64/255.0f) alpha:1.0f];
            }
            if([component3[0] isEqualToString:@"4"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(249/255.0f) blue:(82/255.0f) alpha:1.0f];
            }
            if([component3[0] isEqualToString:@"5"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(167/255.0f) green:(229/255.0f) blue:(79/255.0f) alpha:1.0f];
            }
            if([component3[0] isEqualToString:@"6"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(96/255.0f) green:(208/255.0f) blue:(80/255.0f) alpha:1.0f];
            }
            if([component3[0] isEqualToString:@"7"])
            {
                self.StressColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(179/255.0f) blue:(88/255.0f) alpha:1.0f];
            }
        }
           
            
        }
        [AppCommon hideLoading];
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
    NSLog(@"failed");
    [COMMON webServiceFailureError:error];
    }];
    
}


-(void)BowlingLoadWebservice : (NSString *)date : (NSString *)type
{
    [AppCommon showLoading ];
    
    NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
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
            self.BowlingloadXArray= [[NSMutableArray alloc]init];
            self.BowlingloadYArray = [[NSMutableArray alloc]init];
            
            for(int i=0;i<reqArray.count;i++)
            {
//                int timecount = [[[reqArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
//                int rpecount = [[[reqArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
//                int total = timecount * rpecount;
                [self.BowlingloadYArray addObject:[[reqArray valueForKey:@"BALL"] objectAtIndex:i]];
                [self.BowlingloadXArray addObject:[[reqArray valueForKey:@"WORKLOADDATE"] objectAtIndex:i]];
            }
            
            [self BowlingLoadChart];
          }
        }
        [AppCommon hideLoading];
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
    NSLog(@"failed");
    [COMMON webServiceFailureError:error];
    }];
    
}

-(void)BowlingLoadChart
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
    l.enabled = NO;
    
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
    xAxis.labelTextColor = UIColor.blackColor;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawAxisLineEnabled = NO;
    xAxis.labelPosition = UIBarPositionBottom;
    
    //NSArray *array = @[@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun",@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun",@"mon",@"tue",@"wed",@"thurs",@"friday",@"sat",@"sun"];
    xAxis.valueFormatter = [[HorizontalXLblFormatter alloc] initForChart: self.BowlingloadXArray];
    
    
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelTextColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    
    
    
    NSMutableArray *TotalValuesArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.BowlingloadYArray.count; i++)
    {
        //        double mult = range / 2.0;
        //        double val = (double) (arc4random_uniform(mult)) + 50;
        
        int val = [self.BowlingloadYArray[i] intValue];
        [TotalValuesArr addObject:[NSNumber numberWithInt:val]];
    }
    
    NSNumber *maxNumber = [TotalValuesArr valueForKeyPath:@"@max.self"];
    NSLog(@"%@", maxNumber);
    
    leftAxis.axisMaximum = [maxNumber floatValue]+1;
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
    for (int i = 0; i < self.BowlingloadYArray.count; i++)
    {
        //        double mult = range / 2.0;
        //        double val = (double) (arc4random_uniform(mult)) + 50;
        
        double val = [self.BowlingloadYArray[i] doubleValue];
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



-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.BowlingDailyBtn];
    [self setInningsButtonUnselect:self.BowlingWeeklyBtn];
    [self setInningsButtonUnselect:self.BowlingMonthlyBtn];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.BowlingDailyBtn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.BowlingWeeklyBtn];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.BowlingMonthlyBtn];
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




-(void)FetchTrainingWebservice
{
    [AppCommon showLoading ];
    
    NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString * actualDate = [dateFormat stringFromDate:matchdate];
    
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSString * yesterdayDate = [dateFormat1 stringFromDate:yesterday];
    
    
    [objWebservice fetchTrainingLoad :fetchTrainingLoadKey : playerCode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = responseObject;
        if(arr.count >0)
        {
            if(![[responseObject valueForKey:@"WorkloadTraingDetails"] isEqual:[NSNull null]])
            {
                NSMutableArray *reqArray = [[NSMutableArray alloc]init];
                reqArray = [responseObject valueForKey:@"WorkloadTraingDetails"];
                
                self.todaysLoadArray = [[NSMutableArray alloc]init];
                self.yesterdayLoadArray = [[NSMutableArray alloc]init];
                //[self samplePieChart];
                for(int i=0;i<reqArray.count;i++)
                {
                    
                    if([[[reqArray valueForKey:@"WORKLOADDATE"] objectAtIndex:i] isEqualToString:actualDate] )
                    {
                        
                        [self.todaysLoadArray addObject:[reqArray  objectAtIndex:i]];
                    }
                    if([[[reqArray valueForKey:@"WORKLOADDATE"] objectAtIndex:i] isEqualToString:yesterdayDate] )
                    {
                        
                        [self.yesterdayLoadArray addObject:[reqArray objectAtIndex:i]];
                    }
                    
                }
                
                if(self.todaysLoadArray.count>0)
                {
                    self.markers = [[NSMutableArray alloc]init];
                    isToday = YES;
                    for(int i=0;i<self.todaysLoadArray.count;i++)
                    {
                        //today view
                        NSString *ActivityName;
                        NSString *ActivityNameCode = [[self.todaysLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i];
                        if([ActivityNameCode isEqualToString:@"MSC053"])
                        {
                            ActivityName = @"Match";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC054"])
                        {
                            ActivityName = @"Strengthening";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC055"])
                        {
                            ActivityName = @"Conditioning";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC056"])
                        {
                            ActivityName = @"Cardio";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC057"])
                        {
                            ActivityName = @"Net Session";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC058"])
                        {
                            ActivityName = @"Recovery";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC059"])
                        {
                            ActivityName = @"Bowling";
                        }
                        
                        if(i==0)
                        {
                            self.todayActivitynamelbl1.text = ActivityName;
                        }
                        if(i==1)
                        {
                            self.todayActivitynamelbl2.text = ActivityName;
                        }
                        if(i==2)
                        {
                            self.todayActivitynamelbl3.text = ActivityName;
                        }
                        if(i==3)
                        {
                            self.todayActivitynamelbl4.text = ActivityName;
                        }
                        if(i==4)
                        {
                            self.todayActivitynamelbl5.text = ActivityName;
                        }
                        if(i==5)
                        {
                            self.todayActivitynamelbl6.text = ActivityName;
                        }
                        if(i==6)
                        {
                            self.todayActivitynamelbl7.text = ActivityName;
                        }
                        
                        
                        int RpeCount = 0;
                        NSString *RpeCode = [[self.todaysLoadArray valueForKey:@"RATEPERCEIVEDEXERTION"] objectAtIndex:i];
                        if([RpeCode isEqualToString:@"MSC060"])
                        {
                            RpeCount = 0;
                        }
                        else if([RpeCode isEqualToString:@"MSC061"])
                        {
                            RpeCount = 0.5;
                        }
                        else if([RpeCode isEqualToString:@"MSC062"])
                        {
                            RpeCount = 1;
                        }
                        else if([RpeCode isEqualToString:@"MSC063"])
                        {
                            RpeCount = 2;
                        }
                        else if([RpeCode isEqualToString:@"MSC064"])
                        {
                            RpeCount = 3;
                        }
                        else if([RpeCode isEqualToString:@"MSC065"])
                        {
                            RpeCount = 4;
                        }
                        else if([RpeCode isEqualToString:@"MSC066"])
                        {
                            RpeCount = 5;
                        }
                        else if([RpeCode isEqualToString:@"MSC067"])
                        {
                            RpeCount = 6;
                        }
                        else if([RpeCode isEqualToString:@"MSC068"])
                        {
                            RpeCount = 7;
                        }
                        else if([RpeCode isEqualToString:@"MSC069"])
                        {
                            RpeCount = 8;
                        }
                        else if([RpeCode isEqualToString:@"MSC070"])
                        {
                            RpeCount = 9;
                        }
                        else if([RpeCode isEqualToString:@"MSC071"])
                        {
                            RpeCount = 10;
                        }
                        
                        NSString *timeDuration = [[self.todaysLoadArray valueForKey:@"DURATION"] objectAtIndex:i];
                        int timecount = [timeDuration intValue];
                        
                        int totalCout = RpeCount * timecount;
                        [self.markers addObject:[NSString stringWithFormat:@"%d",totalCout]];
                        
                    }
                    
                    
                    
                }
                
                if(self.yesterdayLoadArray.count>0)
                {
                    self.markers = [[NSMutableArray alloc]init];
                    isYesterday = YES;
                    
                    for(int i=0;i<self.yesterdayLoadArray.count;i++)
                    {
                        //today view
                        NSString *ActivityName;
                        NSString *ActivityNameCode = [[self.yesterdayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i];
                        if([ActivityNameCode isEqualToString:@"MSC053"])
                        {
                            ActivityName = @"Match";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC054"])
                        {
                            ActivityName = @"Strengthening";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC055"])
                        {
                            ActivityName = @"Conditioning";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC056"])
                        {
                            ActivityName = @"Cardio";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC057"])
                        {
                            ActivityName = @"Net Session";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC058"])
                        {
                            ActivityName = @"Recovery";
                        }
                        else if([ActivityNameCode isEqualToString:@"MSC059"])
                        {
                            ActivityName = @"Bowling";
                        }
                        
                        if(i==0)
                        {
                            self.yesterdayActivitynamelbl1.text = ActivityName;
                        }
                        if(i==1)
                        {
                            self.yesterdayActivitynamelbl2.text = ActivityName;
                        }
                        if(i==2)
                        {
                            self.yesterdayActivitynamelbl3.text = ActivityName;
                        }
                        if(i==3)
                        {
                            self.yesterdayActivitynamelbl4.text = ActivityName;
                        }
                        if(i==4)
                        {
                            self.yesterdayActivitynamelbl5.text = ActivityName;
                        }
                        if(i==5)
                        {
                            self.yesterdayActivitynamelbl6.text = ActivityName;
                        }
                        if(i==6)
                        {
                            self.yesterdayActivitynamelbl7.text = ActivityName;
                        }
                        
                        
                        int RpeCount = 0;
                        NSString *RpeCode = [[self.yesterdayLoadArray valueForKey:@"RATEPERCEIVEDEXERTION"] objectAtIndex:i];
                        if([RpeCode isEqualToString:@"MSC060"])
                        {
                            RpeCount = 0;
                        }
                        else if([RpeCode isEqualToString:@"MSC061"])
                        {
                            RpeCount = 0.5;
                        }
                        else if([RpeCode isEqualToString:@"MSC062"])
                        {
                            RpeCount = 1;
                        }
                        else if([RpeCode isEqualToString:@"MSC063"])
                        {
                            RpeCount = 2;
                        }
                        else if([RpeCode isEqualToString:@"MSC064"])
                        {
                            RpeCount = 3;
                        }
                        else if([RpeCode isEqualToString:@"MSC065"])
                        {
                            RpeCount = 4;
                        }
                        else if([RpeCode isEqualToString:@"MSC066"])
                        {
                            RpeCount = 5;
                        }
                        else if([RpeCode isEqualToString:@"MSC067"])
                        {
                            RpeCount = 6;
                        }
                        else if([RpeCode isEqualToString:@"MSC068"])
                        {
                            RpeCount = 7;
                        }
                        else if([RpeCode isEqualToString:@"MSC069"])
                        {
                            RpeCount = 8;
                        }
                        else if([RpeCode isEqualToString:@"MSC070"])
                        {
                            RpeCount = 9;
                        }
                        else if([RpeCode isEqualToString:@"MSC071"])
                        {
                            RpeCount = 10;
                        }
                        
                        NSString *timeDuration = [[self.yesterdayLoadArray valueForKey:@"DURATION"] objectAtIndex:i];
                        int timecount = [timeDuration intValue];
                        
                        int totalCout = RpeCount * timecount;
                        [self.markers addObject:[NSString stringWithFormat:@"%d",totalCout]];
                        
                    }
                    
                    
                }
                //[self trainingloadTodayChart];
            }
        }
        [AppCommon hideLoading];
        
    }
                              failure:^(AFHTTPRequestOperation *operation, id error) {
                                  NSLog(@"failed");
                                  [COMMON webServiceFailureError:error];
                              }];
    
}

-(void)closeWellnessSource
{
    self.topviewHeight.constant = 270;
    isWellnessExpand = NO;
    [self setTotalScroll];
    [self.topView updateConstraintsIfNeeded];
}

-(void)closeUpdateTrainingSource
{
    self.traingViewHeight.constant = 350;
    isTraingLoadExpand = NO;
    [self setTotalScroll];
    [self.RootTrainingView updateConstraintsIfNeeded];
}









@end
