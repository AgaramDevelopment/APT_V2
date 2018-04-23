//
//  TrainingLoadVC.m
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TrainingLoadVC.h"
#import "Config.h"
#import "XYPieChart.h"
#import "PieChartView.h"
#import "TrainingLoadUpdateVC.h"
#import "AppCommon.h"
#import "WebService.h"
//#import "WellnessTrainingBowlingVC.h"
@import Charts;


@interface TrainingLoadVC ()<PieChartViewDelegate,PieChartViewDataSource>
{
    WebService *objWebservice;
    TrainingLoadUpdateVC *objUpdate;
    float num1;
    float num2;
    float num3;
    float num4;
    
    BOOL isToday;
    BOOL isYesterday;
    
    // PieChartView *pieChartView1, *pieChartView2;
}

@property (strong, nonatomic) IBOutlet NSMutableArray *metaSubcodeArray;
@property (strong, nonatomic) IBOutlet NSMutableArray *todaysLoadArray;
@property (strong, nonatomic) IBOutlet NSMutableArray *yesterdayLoadArray;

@property (strong, nonatomic) IBOutlet PieChartView *pieChartView1;
@property (strong, nonatomic) IBOutlet PieChartView *pieChartView2;



@end

@implementation TrainingLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    
   // self.markers = [[NSMutableArray alloc] initWithObjects:@"50.343", @"84.43", @"63.22", @"31.43", nil];
    objWebservice=[[WebService alloc]init];
    
    
    _pieChartView1.delegate = self;
    _pieChartView1.datasource = self;
    
    _pieChartView2.delegate = self;
    _pieChartView2.datasource = self;
    
   // isToday =NO;
   // isYesterday = NO;

}

-(void)reloadPiechartData
{
    [_pieChartView1 reloadData];
    [_pieChartView2 reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (IS_IPAD) {
        self.yesterdayViewWidth.constant = 100;
        self.yesterdayViewHeight.constant = 100;
        
        self.todayViewWidth.constant = 100;
        self.todayViewHeight.constant = 100;
    } else {
        self.yesterdayViewWidth.constant = 70;
        self.yesterdayViewHeight.constant = 70;
        
        self.todayViewWidth.constant = 70;
        self.todayViewHeight.constant = 70;
    }
    self.yesterdayView.layer.cornerRadius = self.yesterdayViewWidth.constant/2;
    self.yesterdayView.layer.borderWidth = 1;
    self.yesterdayView.layer.borderColor =[UIColor whiteColor].CGColor;
    self.yesterdayView.clipsToBounds = true;
    
    self.todayView.layer.cornerRadius = self.todayViewWidth.constant/2;
    self.todayView.layer.borderWidth = 1;
    self.todayView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.todayView.clipsToBounds = true;
    
    [self samplePieChart];
    [self FetchWebservice];
    
}

-(void)samplePieChart
{
    if(IS_IPHONE_DEVICE) {
        //_pieChartView1 = [[PieChartView alloc] initWithFrame:CGRectMake(self.yesterdayView.frame.origin.x,self.yesterdayView.frame.origin.y,self.yesterdayView.frame.size.width,self.yesterdayView.frame.size.width)];
        _pieChartView1.delegate = self;
        _pieChartView1.datasource = self;
        //[self.yesterdayMainView addSubview:_pieChartView1];
        
       // _pieChartView2 = [[PieChartView alloc] initWithFrame:CGRectMake(self.todayView.frame.origin.x,self.todayView.frame.origin.y,self.todayView.frame.size.width,self.todayView.frame.size.width)];
        _pieChartView2.delegate = self;
        _pieChartView2.datasource = self;
        //[self.todayMainView addSubview:_pieChartView2];
        
    } else {
        //pieChartView1 = [[PieChartView alloc] initWithFrame:CGRectMake(self.yesterdayView.frame.origin.x,self.yesterdayView.frame.origin.y,self.yesterdayView.frame.size.width,self.yesterdayView.frame.size.width)];
        _pieChartView1.delegate = self;
        _pieChartView1.datasource = self;
       // [self.yesterdayMainView addSubview:pieChartView1];
        
        //pieChartView2 = [[PieChartView alloc] initWithFrame:CGRectMake(self.todayView.frame.origin.x,self.todayView.frame.origin.y,self.todayView.frame.size.width,self.todayView.frame.size.width)];
        _pieChartView2.delegate = self;
        _pieChartView2.datasource = self;
        //[self.todayMainView addSubview:pieChartView2];
    }
}
- (IBAction)AddtrainingBtnAction:(id)sender {
    
    objUpdate = [[TrainingLoadUpdateVC alloc] initWithNibName:@"TrainingLoadUpdateVC" bundle:nil];
    objUpdate.view.frame = CGRectMake(0,0, self.traingView.bounds.size.width, self.traingView.bounds.size.height);
     [self.traingView addSubview:objUpdate.view];
    
//        WellnessTrainingBowlingVC *objWell = [[WellnessTrainingBowlingVC alloc]init];
//        objWell.traingViewHeight.constant = objWell.traingViewHeight.constant+300;
}

- (IBAction)TodayBtnAction:(id)sender {
    
    if(isToday == YES)
    {
        
        
    objUpdate = [[TrainingLoadUpdateVC alloc] initWithNibName:@"TrainingLoadUpdateVC" bundle:nil];
    objUpdate.TodayLoadArray = self.todaysLoadArray;
    objUpdate.isToday = @"yes";
    objUpdate.view.frame = CGRectMake(0,0, self.traingView.bounds.size.width, self.traingView.bounds.size.height);
    [self.traingView addSubview:objUpdate.view];
    
    }
}

- (IBAction)YesterdayBtnAction:(id)sender {
    
    if(isYesterday == YES)
    {
        
        //[objWell.AddTrainingBtn addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //WellnessTrainingBowlingVC *objWell = [[WellnessTrainingBowlingVC alloc] initWithNibName:@"WellnessTrainingBowlingVC" bundle:nil];
    //[objWell.AddTrainingBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    objUpdate = [[TrainingLoadUpdateVC alloc] initWithNibName:@"TrainingLoadUpdateVC" bundle:nil];
    objUpdate.YesterdayLoadArray = self.yesterdayLoadArray;
    objUpdate.isYesterday = @"yes";
    objUpdate.view.frame = CGRectMake(0,0, self.traingView.bounds.size.width, self.traingView.bounds.size.height);
    [self.traingView addSubview:objUpdate.view];
    }
}

#pragma mark -    PieChartViewDelegate
-(CGFloat)centerCircleRadius
{
    if(IS_IPHONE_DEVICE)
        {
        return 30;
        }
    else
        {
        return 30;
        }
    
}

#pragma mark - PieChartViewDataSource
-(int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    if(pieChartView == _pieChartView1)
    {
    NSUInteger  obj =  self.markers2.count;
        return (int)obj;
    }
    else if(pieChartView == _pieChartView2)
    {
        NSUInteger  obj =  self.markers.count;
        return (int)obj;
    }
    return nil;
}
-(UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    UIColor * color;
    if(index==0)
        {
        color = [UIColor colorWithRed:(210/255.0f) green:(105/255.0f) blue:(30/255.0f) alpha:1.0f];
        }
    if(index==1)
        {
        color = [UIColor colorWithRed:(0/255.0f) green:(100/255.0f) blue:(0/255.0f) alpha:1.0f];
        }
    if(index==2)
        {
        color = [UIColor colorWithRed:(0/255.0f) green:(139/255.0f) blue:(139/255.0f) alpha:1.0f];
        }
    if(index==3)
        {
        color = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(42/255.0f) alpha:1.0f];
        }
    
//    if(pieChartView == pieChartView1)
//    {
//    for(int i=0;i<self.yesterdayLoadArray.count;i++)
//    {
//        if(i==0)
//        {
//        self.yesterdayActivitynamelbl1.backgroundColor = color;
//        }
//        else if(i==1)
//        {
//            self.yesterdayActivitynamelbl2.backgroundColor = color;
//        }
//        else if(i==2)
//        {
//            self.yesterdayActivitynamelbl3.backgroundColor = color;
//        }
//        else if(i==3)
//        {
//            self.yesterdayActivitynamelbl4.backgroundColor = color;
//        }
//        else if(i==4)
//        {
//            self.yesterdayActivitynamelbl5.backgroundColor = color;
//        }
//        else if(i==5)
//        {
//            self.yesterdayActivitynamelbl6.backgroundColor = color;
//        }
//        else if(i==6)
//        {
//            self.yesterdayActivitynamelbl7.backgroundColor = color;
//        }
//    }
//    }

//    if(pieChartView == pieChartView2)
//    {
//    for(int i=0;i<self.todaysLoadArray.count;i++)
//    {
//        if(i==0)
//        {
//            self.todayActivitynamelbl1.backgroundColor = color;
//        }
//        else if(i==1)
//        {
//            self.todayActivitynamelbl2.backgroundColor = color;
//        }
//        else if(i==2)
//        {
//            self.todayActivitynamelbl3.backgroundColor = color;
//        }
//        else if(i==3)
//        {
//            self.todayActivitynamelbl4.backgroundColor = color;
//        }
//        else if(i==4)
//        {
//            self.todayActivitynamelbl5.backgroundColor = color;
//        }
//        else if(i==5)
//        {
//            self.todayActivitynamelbl6.backgroundColor = color;
//        }
//        else if(i==6)
//        {
//            self.todayActivitynamelbl7.backgroundColor = color;
//        }
//    }
//    }
    return color;
        //return GetRandomUIColor();
}
-(double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    //        NSUInteger  obj = [self.markers objectAtIndex:index];
    //        NSString *s= [self.markers objectAtIndex:index];
    
    float  obj;
    if(pieChartView == _pieChartView1)
    {
        obj = [[NSDecimalNumber decimalNumberWithString:[self.markers2 objectAtIndex:index]]floatValue];
        
    }
    else if(pieChartView == _pieChartView2)
    {
        obj = [[NSDecimalNumber decimalNumberWithString:[self.markers objectAtIndex:index]]floatValue] ;
        
    }
    
    
    if(obj==0)
    {
        return 0;
    }
    else
    {
        
        if(index ==0)
        {
            return 100/obj;
        }
        if(index ==1)
        {
            return 100/obj;
        }
        if(index ==2)
        {
            return 100/obj;
        }
        if(index ==3)
        {
            return 100/obj;
        }
    }
    
    return 0;
}



-(NSString *)percentagevalue
{
    float a = num1;
    float b = num2;
    float c = num3;
    float d = num4;
    
    float Total = a+b+c+d;
    
    float per = (Total *100/28);
    
    NSString * obj;
    if(per == 0)
        {
        obj = @"";
        }
    else
        {
        
        obj =[NSString stringWithFormat:@"%f",per];
        
        }
    
    return obj;
}


-(void)FetchWebservice
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
                isYesterday = NO;
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
            [_pieChartView2 reloadData];
                
                int total=0;
                for(int i=0;i<self.markers.count;i++)
                {
                    NSString *reqValue = [self.markers objectAtIndex:i];
                    int value = [reqValue intValue];
                    total=total+value;
                }
                self.totalCountToday.text = [NSString stringWithFormat:@"%d",total];
            }
           
            if(self.yesterdayLoadArray.count>0)
            {
            self.markers2 = [[NSMutableArray alloc]init];
                isYesterday = YES;
                isToday = NO;
            
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
                [self.markers2 addObject:[NSString stringWithFormat:@"%d",totalCout]];
                
            }
            
            [_pieChartView1 reloadData];
                //[self setPiechartFromiosCharts];
             
                int total=0;
                for(int i=0;i<self.markers2.count;i++)
                {
                    NSString *reqValue = [self.markers2 objectAtIndex:i];
                    int value = [reqValue intValue];
                    total=total+value;
                }
                self.totalCountYesterday.text = [NSString stringWithFormat:@"%d",total];
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








@end
