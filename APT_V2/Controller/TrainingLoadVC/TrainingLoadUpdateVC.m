//
//  TrainingLoadUpdateVC.m
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TrainingLoadUpdateVC.h"
#import "TrainingLoadUpdateCell.h"
#import "Config.h"
#import "XYPieChart.h"
#import "PieChartView.h"
#import "WebService.h"
#import "AppCommon.h"
#import "CategoryTableCell.h"
#import "WellnessTrainingBowlingVC.h"
#import "TrainingLoadVC.h"
@import drCharts;

@interface TrainingLoadUpdateVC ()<PieChartViewDelegate,PieChartViewDataSource>
{
    UIDatePicker *datePicker;
    float num1;
    float num2;
    float num3;
    float num4;
    
    BOOL isActivity;
    BOOL isRpe;
    
    int selectedActivity;
    
    //PieChartView *pieChartView;
    
    WebService *objWebservice;
    
    NSString *ActivityCode;
    NSString *rpeCode;
    NSString *TotalCount;
    
    CircularChart *circleChart;
    
    
    NSString *WorkloadCode;
    
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *poptableXposition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *poptableyposition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *poptableWidth;

@property (strong, nonatomic) IBOutlet PieChartView *pieChartView;;

@property (strong, nonatomic)  NSMutableArray *DropdownDataArray;
@property (strong, nonatomic)  NSMutableArray *RpeDataArray;
@property (strong, nonatomic)  NSMutableArray *ActivityDataArray;
@end


@implementation TrainingLoadUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"%@",self.YesterdayLoadArray);

    self.view_datepicker.hidden=YES;
    sessionArray = [[NSMutableArray alloc]init];
    objWebservice = [[WebService alloc]init];
    //self.markers = [[NSMutableArray alloc] initWithObjects:@"50.343", @"84.43", @"63.22", @"31.43", nil];
    
    [self customnavigationmethod];
    self.sessionBtn.hidden = NO;
    self.UpdateBtn.hidden = YES;
    
    self.SaveBtn.hidden = NO;
    self.FetchedUpdateBtn.hidden = YES;
    
    _pieChartView.delegate = self;
     _pieChartView.datasource = self;
    self.RpeFilterviewWidth.constant = self.ActivityFilterview.frame.size.width;
    
   // rpeCode = @"MSC062";
    
    //sessionArray = [[NSMutableArray alloc] initWithObjects:@"Session 1", @"Session 2", @"Session 3", nil];
    //activityArray = [[NSMutableArray alloc] initWithObjects:@"Cardio", @"Strengthening", @"Bowling", nil];
   // valueArray = [[NSMutableArray alloc] initWithObjects:@"245", @"124", @"342", nil];
    self.popViewtable.hidden = YES;
    self.tapView.hidden = YES;
    [self samplePieChart];
    [self DropDownWebservice];
    
   if(![_isToday isEqualToString:@"yes"] && ![_isYesterday isEqualToString:@"yes"] )
   {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];

    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"MM-dd-yyyy"];
   // SelectedDate = [dateFormat1 stringFromDate:matchdate];

    NSString * actualDate = [dateFormat stringFromDate:matchdate];
    self.datelbl.text = [dateFormat1 stringFromDate:matchdate];
    [self DateWebservice];
   }
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (IS_IPAD) {
        self.countViewWidth.constant = 100;
        self.countViewHeight.constant = 100;
    } else {
        self.countViewWidth.constant = 70;
        self.countViewHeight.constant = 70;
    }
    self.countview.layer.cornerRadius = self.countViewWidth.constant/2;
    self.countview.layer.borderWidth = 1;
    self.countview.layer.borderColor =[UIColor whiteColor].CGColor;
    self.countview.clipsToBounds = true;
    
    self.RpeFilterviewWidth.constant = self.ActivityFilterview.frame.size.width;

    
}

- (void)showAnimate
{
    self.popViewtable.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.popViewtable.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.popViewtable.alpha = 1;
        self.popViewtable.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.popViewtable.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.popViewtable.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            // [self.popTblView removeFromSuperview];
            self.popViewtable.hidden = YES;
        }
    }];
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
    [self.navView addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    isBackEnable=YES;
    
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

- (IBAction)ActivityAction:(id)sender {
    
    
    isActivity = YES;
    isRpe = NO;
    self.popViewtable.hidden = NO;
    self.tapView.hidden = NO;
    self.poptableWidth.constant = self.ActivityFilterview.frame.size.width;
    self.poptableXposition.constant = self.ActivityFilterview.frame.origin.x;
    self.poptableyposition.constant = self.ActivityFilterview.frame.origin.y;
    
    self.DropdownDataArray = [[NSMutableArray alloc]init];
    self.DropdownDataArray = self.ActivityDataArray;
    [self showAnimate];
    [self.popViewtable reloadData];
    
}

- (IBAction)RpeAction:(id)sender {
    
    isActivity = NO;
    isRpe = YES;
    self.popViewtable.hidden = NO;
    self.tapView.hidden = NO;
    self.poptableWidth.constant = self.RpeFilterview.frame.size.width;
    self.poptableXposition.constant = self.RpeFilterview.frame.origin.x;
    self.poptableyposition.constant = self.RpeFilterview.frame.origin.y;
    self.DropdownDataArray = [[NSMutableArray alloc]init];
    self.DropdownDataArray = self.RpeDataArray;
    [self showAnimate];
    [self.popViewtable reloadData];
}


- (IBAction)UpdateSessionAction:(id)sender {
    
    
    int timecount = [self.timelbl.text intValue];
    int rpecount =  [self.rpelbl.text intValue];
    int total = timecount * rpecount;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.activitylbl.text forKey:@"ActivityName"];
    [dic setObject:ActivityCode forKey:@"ActivityCode"];
    [dic setObject:[NSString stringWithFormat:@"%d",total] forKey:@"Value"];
    [dic setObject:[NSString stringWithFormat:@"%d",rpecount] forKey:@"rpeValue"];
    [dic setObject:rpeCode forKey:@"RpeCode"];
    [dic setObject:WorkloadCode forKey:@"WorkloadCode"];
    [dic setObject:[NSString stringWithFormat:@"%d",timecount] forKey:@"timeValue"];
    //[dic setObject:self.ballslbl.text forKey:@"ballsValue"];
    if(![self.ballslbl.text isEqualToString:@""] && ![self.ballslbl.text isEqual:[NSNull null]])
    {
        [dic setObject:self.ballslbl.text forKey:@"ballsValue"];
    }
    else{
        [dic setObject:@"0" forKey:@"ballsValue"];
    }
    
    [sessionArray replaceObjectAtIndex:selectedActivity withObject:dic];
    
    [self.SessionTable reloadData];
    
    if(sessionArray.count >0)
    {
        self.markers = [[NSMutableArray alloc]init];
        for(int i=0;i<sessionArray.count;i++)
        {
            [self.markers addObject:[[sessionArray valueForKey:@"Value"] objectAtIndex:i]];
        }
        //[self samplePieChart];
       // [_pieChartView reloadData];
        
        int total=0;
        for(int i=0;i<self.markers.count;i++)
        {
            NSString *reqValue = [self.markers objectAtIndex:i];
            int value = [reqValue intValue];
            total=total+value;
        }
        self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
        
        [circleChart removeFromSuperview];
        [self TodayCircularChart];
        //[circleChart reloadCircularChart];
    }
    
    self.activitylbl.text = @"";
    self.timelbl.text =@"";
    self.rpelbl.text = @"";
    self.ballslbl.text = @"";
    self.UpdateBtn.hidden = YES;
    self.sessionBtn.hidden = NO;
    
}

- (IBAction)AddSessionAction:(id)sender {
    
    
    
    int timecount = [self.timelbl.text intValue];
    int rpecount =  [self.rpelbl.text intValue];
    int total = timecount * rpecount;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.activitylbl.text forKey:@"ActivityName"];
    [dic setObject:ActivityCode forKey:@"ActivityCode"];
    [dic setObject:[NSString stringWithFormat:@"%d",total] forKey:@"Value"];
    [dic setObject:[NSString stringWithFormat:@"%d",rpecount] forKey:@"rpeValue"];
    [dic setObject:rpeCode forKey:@"RpeCode"];
    [dic setObject:[NSString stringWithFormat:@"%d",timecount] forKey:@"timeValue"];
    
    if([self.activitylbl.text isEqualToString:@"Bowling"])
    {
    [dic setObject:self.ballslbl.text forKey:@"ballsValue"];
    }
    else{
        [dic setObject:@"0" forKey:@"ballsValue"];
    }
   if(sessionArray.count >0)
   {
       BOOL keyValue1=NO;
    for(int i = 0;i<sessionArray.count;i++)
    {
        if([[[sessionArray valueForKey:@"ActivityName"]objectAtIndex:i] isEqualToString:self.activitylbl.text])
        {
            keyValue1 =YES;
            break;
        }
        
    }
       [sessionArray addObject:dic];
//       if(!keyValue1)
//       {
//           [sessionArray addObject:dic];
//       }
//       else
//       {
//           [self ShowAlterMsg:@"Activity Already Exists"];
//       }
   }
    else
    {
        [sessionArray addObject:dic];
    }
    [self.SessionTable reloadData];
    
    if(sessionArray.count >0)
    {
        self.markers = [[NSMutableArray alloc]init];
        for(int i=0;i<sessionArray.count;i++)
        {
            [self.markers addObject:[[sessionArray valueForKey:@"Value"] objectAtIndex:i]];
        }
        //[self samplePieChart];
         //[_pieChartView reloadData];
        
        int total=0;
        for(int i=0;i<self.markers.count;i++)
        {
            NSString *reqValue = [self.markers objectAtIndex:i];
            int value = [reqValue intValue];
            total=total+value;
        }
        self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
        
        [circleChart removeFromSuperview];
        [self TodayCircularChart];
        //[circleChart reloadCircularChart];
    }
    
    self.activitylbl.text = @"";
    self.timelbl.text =@"";
    self.rpelbl.text = @"";
    self.ballslbl.text = @"";
    
}
- (IBAction)SaveAction:(id)sender {
    
    [self SaveWebservice];
}

- (IBAction)UpdateAction:(id)sender {
    
    [self UpdateWebservice];
}
-(void)ShowAlterMsg:(NSString*) MsgStr
{
    UIAlertView *objAlter =[[UIAlertView alloc]initWithTitle:@"" message:MsgStr delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [objAlter show];
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [UITextField resignFirstResponder];
//}

-(void)samplePieChart
{
    if(IS_IPHONE_DEVICE) {
        
        //pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(self.countview.frame.origin.x,self.countview.frame.origin.y,self.countview.frame.size.width,self.countview.frame.size.width)];
        _pieChartView.delegate = self;
        _pieChartView.datasource = self;
        //[self.todayMainView addSubview:pieChartView];
        
    } else {
        
        //pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(self.countview.frame.origin.x,self.countview.frame.origin.y,self.countview.frame.size.width,self.countview.frame.size.width)];
        _pieChartView.delegate = self;
        _pieChartView.datasource = self;
        //[self.todayMainView addSubview:pieChartView];
    }
}

#pragma mark - UITableViewDataSource
    // number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    // number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.popViewtable)
    {
        return self.DropdownDataArray.count;
    }
    else
    {
    return sessionArray.count;
    }
    return nil;
}
    // the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.popViewtable)
    {
        static NSString *MyIdentifier = @"cellid";
        
        CategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableCell" owner:self options:nil];
        cell = arr[0];
        
        cell.textLabel.text = [[self.DropdownDataArray valueForKey:@"MetaSubcodeDescription"] objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
    static NSString *cellIdentifier = @"updateCell";
    
    TrainingLoadUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TrainingLoadUpdateCell" owner:self options:nil];
    cell = arr[0];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.sessionLbl.text = [NSString stringWithFormat:@"Session%ld",(long)indexPath.row+1];
    cell.activityTypeLbl.text = [[sessionArray valueForKey:@"ActivityName"] objectAtIndex:indexPath.row];
    cell.sessionValueLbl.text = [[sessionArray valueForKey:@"Value"] objectAtIndex:indexPath.row];
    return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.popViewtable)
    {
        if(isActivity==YES)
        {
            if(indexPath.row == 6)
            {
                self.bowledlblname.hidden = NO;
                self.ballsView.hidden = NO;
                self.activitylbl.text = [[self.DropdownDataArray valueForKey:@"MetaSubcodeDescription"] objectAtIndex:indexPath.row];
                ActivityCode = [[self.DropdownDataArray valueForKey:@"MetaSubCode"] objectAtIndex:indexPath.row];
                self.tapView.hidden = YES;
                [self removeAnimate];
            }
            else
            {
                self.bowledlblname.hidden = YES;
                self.ballsView.hidden = YES;
        self.activitylbl.text = [[self.DropdownDataArray valueForKey:@"MetaSubcodeDescription"] objectAtIndex:indexPath.row];
        ActivityCode = [[self.DropdownDataArray valueForKey:@"MetaSubCode"] objectAtIndex:indexPath.row];
        self.tapView.hidden = YES;
            [self removeAnimate];
            }
        }
        
        if(isRpe==YES)
        {
            self.rpelbl.text = [[self.DropdownDataArray valueForKey:@"MetaSubcodeDescription"] objectAtIndex:indexPath.row];
            rpeCode = [[self.DropdownDataArray valueForKey:@"MetaSubCode"] objectAtIndex:indexPath.row];
            self.tapView.hidden = YES;
            [self removeAnimate];
        }
    }
    if(tableView == self.SessionTable)
    {
        self.sessionBtn.hidden = YES;
        self.UpdateBtn.hidden = NO;
        
        selectedActivity = indexPath.row;
        
        self.activitylbl.text = [[sessionArray valueForKey:@"ActivityName"] objectAtIndex:indexPath.row];
        
        self.rpelbl.text = [[sessionArray valueForKey:@"rpeValue"] objectAtIndex:indexPath.row];
        self.timelbl.text = [[sessionArray valueForKey:@"timeValue"] objectAtIndex:indexPath.row];
        if([self.activitylbl.text isEqualToString:@"Bowling"])
        {
            self.bowledlblname.hidden = NO;
            self.ballsView.hidden = NO;
        self.ballslbl.text = [[sessionArray valueForKey:@"ballsValue"] objectAtIndex:indexPath.row];
        }
        else
        {
            self.bowledlblname.hidden = YES;
            self.ballsView.hidden = YES;
        }
        
        ActivityCode = [[sessionArray valueForKey:@"ActivityCode"] objectAtIndex:indexPath.row];
        rpeCode = [[sessionArray valueForKey:@"RpeCode"] objectAtIndex:indexPath.row];
        WorkloadCode = [[sessionArray valueForKey:@"WorkloadCode"] objectAtIndex:indexPath.row];
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
    NSUInteger  obj =  self.markers.count;
    return (int)obj;
}
-(UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    UIColor * color;
    if(index==0)
    {
        color = [UIColor colorWithRed:(210/255.0f) green:(105/255.0f) blue:(30/255.0f) alpha:0.5f];
        
    }
    if(index==1)
    {
        color = [UIColor colorWithRed:(0/255.0f) green:(100/255.0f) blue:(0/255.0f) alpha:0.5f];
        
    }
    if(index==2)
    {
        color = [UIColor colorWithRed:(0/255.0f) green:(139/255.0f) blue:(139/255.0f) alpha:0.5f];
       
    }
    if(index==3)
    {
        color = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(42/255.0f) alpha:0.5f];
        
    }
    if(index==4)
    {
        color = [UIColor colorWithRed:(255/255.0f) green:(42/255.0f) blue:(42/255.0f) alpha:0.5f];
       
    }
    if(index==5)
    {
        color = [UIColor colorWithRed:(255/255.0f) green:(165/255.0f) blue:(42/255.0f) alpha:0.5f];
        
    }
    if(index==6)
    {
        color = [UIColor colorWithRed:(255/255.0f) green:(42/255.0f) blue:(255/255.0f) alpha:0.5f];
        
    }
    return color;
        //return GetRandomUIColor();
}

-(double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
        //        NSUInteger  obj = [self.markers objectAtIndex:index];
        //        NSString *s= [self.markers objectAtIndex:index];
    float  obj = [[NSDecimalNumber decimalNumberWithString:[self.markers objectAtIndex:index]]floatValue] ;
    
    
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
            if(index ==4)
            {
                return 100/obj;
            }
            if(index ==5)
            {
                return 100/obj;
            }
            if(index ==6)
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

-(IBAction)closeView:(id)sender
{
    self.popViewtable.hidden = YES;
    self.tapView.hidden = YES;
    
}

-(void)DropDownWebservice
{
    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    NSString *playerCode;
    if([AppCommon isCoach])
    {
        
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString * actualDate = [dateFormat stringFromDate:matchdate];
    
    [objWebservice trainingLoadDropDown :TraingLoadDropKey : playerCode  :actualDate  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            self.ActivityDataArray = [[NSMutableArray alloc]init];
            self.ActivityDataArray = [responseObject valueForKey:@"ActivityTypes"];
            
            self.RpeDataArray = [[NSMutableArray alloc]init];
            self.RpeDataArray = [responseObject valueForKey:@"Rpes"];
            
            
            [self.popViewtable reloadData];
            
            [self setValuesUpdate];
        }
        [AppCommon hideLoading];
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
    NSLog(@"failed");
    [COMMON webServiceFailureError:error];
    }];
    
}
-(void)setValuesUpdate
{
if([_isToday isEqualToString:@"yes"])
{
    
    self.SaveBtn.hidden = YES;
    self.FetchedUpdateBtn.hidden = NO;
    sessionArray = [[NSMutableArray alloc]init];
    self.datelbl.text = [[self.TodayLoadArray valueForKey:@"WORKLOADDATE"] objectAtIndex:0];
    
    for(int i=0;i<self.TodayLoadArray.count;i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[[self.TodayLoadArray valueForKey:@"WORKLOADCODE"] objectAtIndex:i] forKey:@"WorkloadCode"];
       // [dic setObject:[[self.TodayLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:i] forKey:@"ActivityName"];
        [dic setObject:[[self.TodayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i] forKey:@"ActivityCode"];
        NSString *actCode = [[self.TodayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i];
        if([actCode isEqualToString:@"MSC053"])
        {
            [dic setObject:@"Match" forKey:@"ActivityName"];
        }
        else if([actCode isEqualToString:@"MSC054"])
        {
            [dic setObject:@"Strengthening" forKey:@"ActivityName"];
        }
        else if([actCode isEqualToString:@"MSC055"])
        {
            [dic setObject:@"Conditioning" forKey:@"ActivityName"];
        }
        else if([actCode isEqualToString:@"MSC056"])
        {
            [dic setObject:@"Cardio" forKey:@"ActivityName"];
        }
        else if([actCode isEqualToString:@"MSC057"])
        {
            [dic setObject:@"Net Session" forKey:@"ActivityName"];
        }
        else if([actCode isEqualToString:@"MSC058"])
        {
            [dic setObject:@"Recovery" forKey:@"ActivityName"];
        }
        else if([actCode isEqualToString:@"MSC059"])
        {
            [dic setObject:@"Bowling" forKey:@"ActivityName"];
        }
        
        [dic setObject:[[self.TodayLoadArray valueForKey:@"RATEPERCEIVEDEXERTION"] objectAtIndex:i] forKey:@"RpeCode"];
        int timecount = [[[self.TodayLoadArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
        int rpecount =  [[[self.TodayLoadArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
        int total = timecount * rpecount;
        [dic setObject:[NSString stringWithFormat:@"%d",total] forKey:@"Value"];
        [dic setObject:[NSString stringWithFormat:@"%d",rpecount] forKey:@"rpeValue"];
        [dic setObject:[NSString stringWithFormat:@"%d",timecount] forKey:@"timeValue"];
        
        
        if( ![[[self.TodayLoadArray valueForKey:@"BALL"] objectAtIndex:i] isEqualToString:@""] && ![[[self.TodayLoadArray valueForKey:@"BALL"] objectAtIndex:i] isEqual:[NSNull null]] )
        {
        
        NSString *ball = [[self.TodayLoadArray valueForKey:@"BALL"] objectAtIndex:i];
        NSArray *arr = [ball componentsSeparatedByString:@"."];
        [dic setObject:arr[0] forKey:@"ballsValue"];
        }
        else
        {
            [dic setObject:@"0" forKey:@"ballsValue"];
        }
        
       // [dic setObject:[[self.TodayLoadArray valueForKey:@"BALL"] objectAtIndex:i] forKey:@"ballsValue"];
        
        [sessionArray addObject:dic];
    }
    [self.SessionTable reloadData];
    if(sessionArray.count >0)
    {
        self.markers = [[NSMutableArray alloc]init];
        for(int i=0;i<sessionArray.count;i++)
        {
            [self.markers addObject:[[sessionArray valueForKey:@"Value"] objectAtIndex:i]];
        }
        //[self samplePieChart];
        //[_pieChartView reloadData];
        
        int total=0;
        for(int i=0;i<self.markers.count;i++)
        {
            NSString *reqValue = [self.markers objectAtIndex:i];
            int value = [reqValue intValue];
            total=total+value;
        }
        self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
        TotalCount = [NSString stringWithFormat:@"%d",total];
        [circleChart removeFromSuperview];
        [self TodayCircularChart];
        //[circleChart reloadCircularChart];
    }
    
    
}
    
    if([_isYesterday isEqualToString:@"yes"])
    {
        self.SaveBtn.hidden = YES;
        self.FetchedUpdateBtn.hidden = NO;
        sessionArray = [[NSMutableArray alloc]init];
        self.datelbl.text = [[self.YesterdayLoadArray valueForKey:@"WORKLOADDATE"] objectAtIndex:0];
        
        for(int i=0;i<self.YesterdayLoadArray.count;i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            //[dic setObject:[[self.YesterdayLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:i] forKey:@"ActivityName"];
            [dic setObject:[[self.YesterdayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i] forKey:@"ActivityCode"];
            NSString *actCode = [[self.YesterdayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i];
            if([actCode isEqualToString:@"MSC053"])
            {
                [dic setObject:@"Match" forKey:@"ActivityName"];
            }
            else if([actCode isEqualToString:@"MSC054"])
            {
                [dic setObject:@"Strengthening" forKey:@"ActivityName"];
            }
            else if([actCode isEqualToString:@"MSC055"])
            {
                [dic setObject:@"Conditioning" forKey:@"ActivityName"];
            }
            else if([actCode isEqualToString:@"MSC056"])
            {
                [dic setObject:@"Cardio" forKey:@"ActivityName"];
            }
            else if([actCode isEqualToString:@"MSC057"])
            {
                [dic setObject:@"Net Session" forKey:@"ActivityName"];
            }
            else if([actCode isEqualToString:@"MSC058"])
            {
                [dic setObject:@"Recovery" forKey:@"ActivityName"];
            }
            else if([actCode isEqualToString:@"MSC059"])
            {
                [dic setObject:@"Bowling" forKey:@"ActivityName"];
            }
            
           [dic setObject:[[self.YesterdayLoadArray valueForKey:@"WORKLOADCODE"] objectAtIndex:i] forKey:@"WorkloadCode"];
            [dic setObject:[[self.YesterdayLoadArray valueForKey:@"RATEPERCEIVEDEXERTION"] objectAtIndex:i] forKey:@"RpeCode"];
            
            int timecount = [[[self.YesterdayLoadArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
            int rpecount =  [[[self.YesterdayLoadArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
            int total = timecount * rpecount;
            [dic setObject:[NSString stringWithFormat:@"%d",total] forKey:@"Value"];
            [dic setObject:[NSString stringWithFormat:@"%d",rpecount] forKey:@"rpeValue"];
            [dic setObject:[NSString stringWithFormat:@"%d",timecount] forKey:@"timeValue"];
           
            
            if( ![[[self.YesterdayLoadArray valueForKey:@"BALL"] objectAtIndex:i] isEqualToString:@""] && ![[[self.YesterdayLoadArray valueForKey:@"BALL"] objectAtIndex:i] isEqual:[NSNull null]] )
            {
            NSString *ball = [[self.YesterdayLoadArray valueForKey:@"BALL"] objectAtIndex:i];
            NSArray *arr = [ball componentsSeparatedByString:@"."];
            [dic setObject:arr[0] forKey:@"ballsValue"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"ballsValue"];
            }
            
            //[dic setObject:[[self.YesterdayLoadArray valueForKey:@"BALL"] objectAtIndex:i] forKey:@"ballsValue"];
            
            [sessionArray addObject:dic];
        }
        [self.SessionTable reloadData];
        
        if(sessionArray.count >0)
        {
            self.markers = [[NSMutableArray alloc]init];
            for(int i=0;i<sessionArray.count;i++)
            {
                [self.markers addObject:[[sessionArray valueForKey:@"Value"] objectAtIndex:i]];
            }
            //[self samplePieChart];
            //[_pieChartView reloadData];
            
            int total=0;
            for(int i=0;i<self.markers.count;i++)
            {
                NSString *reqValue = [self.markers objectAtIndex:i];
                int value = [reqValue intValue];
                total=total+value;
            }
            self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
            [circleChart removeFromSuperview];
            [self TodayCircularChart];
            //[circleChart reloadCircularChart];
        }
    }
}

- (IBAction)DateBtnAction:(id)sender {
    
    [self DisplaydatePicker];
    
}


-(void)DisplaydatePicker
{
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    self.view_datepicker.hidden=NO;
    //isStartDate =YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,20,self.view_datepicker.frame.size.width,100)];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    
    // [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker reloadInputViews];
    [self.view_datepicker addSubview:datePicker];
    
}
-(IBAction)showSelecteddate:(id)sender{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
 
    //self.datelbl.text=[dateFormat stringFromDate:datePicker.date];
    NSString * actualDate = [dateFormat stringFromDate:datePicker.date];
    
    
    self.datelbl.text = actualDate;
    
    //NSLog(@"%@", actualDate);
    
    [self.view_datepicker setHidden:YES];
    // [self dateWebservice];
    
    [self DateWebservice];
    
}


-(void)SaveWebservice
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",trainingSaveKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
       
        NSString *usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
        //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        NSString *playerCode;
        if([AppCommon isCoach])
        {
            
            playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
        }
        else
        {
            playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        }
        
        NSMutableArray *traininglist = [[NSMutableArray alloc]init];
        for(int i=0;i<sessionArray.count;i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[[sessionArray valueForKey:@"ActivityCode"] objectAtIndex:i] forKey:@"ACTIVITYTYPECODE"];
            [dic setObject:rpeCode forKey:@"RATEPERCEIVEDEXERTION"];
            [dic setObject:[[sessionArray valueForKey:@"timeValue"] objectAtIndex:i] forKey:@"DURATION"];
            [dic setObject:[[sessionArray valueForKey:@"ballsValue"] objectAtIndex:i] forKey:@"BALL"];
            [traininglist addObject:dic];
        }
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(usercode)   [dic    setObject:usercode     forKey:@"USERCODE"];
        if(playerCode)   [dic    setObject:playerCode     forKey:@"PLAYERCODE"];
        if(self.datelbl.text )   [dic    setObject:self.datelbl.text     forKey:@"WORKLOADDATE"];
        if(traininglist)   [dic    setObject:traininglist     forKey:@"Trainingloadlist"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                BOOL Status = [responseObject valueForKey:@"Status"];
                if(Status == YES)
                {
                    NSLog(@"success");
                    [self ShowAlterMsg:@"Training Load Inserted Successfully"];
                   // [self.view removeFromSuperview];
                    //[self.Delegate closeUpdateTrainingSource];
                    //[appDel.frontNavigationController popViewControllerAnimated:YES];
                    
                    // [self.pieChartRight reloadData];
                
                
                if([self.isfromHome isEqualToString:@"NO"])
                    {
                    [self.view removeFromSuperview];
                    [self.Delegate closeUpdateTrainingSource];
                    }
                else
                    {
                    [appDel.frontNavigationController popViewControllerAnimated:YES];
                    }
                }
                
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
             
            
        }];
    }
    
}

-(void)UpdateWebservice
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",trainingUpdateKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        
        NSString *usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
       // NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        NSString *playerCode;
        if([AppCommon isCoach])
        {
            
            playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
        }
        else
        {
            playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        }
        
        NSMutableArray *traininglist = [[NSMutableArray alloc]init];
        for(int i=0;i<sessionArray.count;i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[[sessionArray valueForKey:@"ActivityCode"] objectAtIndex:i] forKey:@"ACTIVITYTYPECODE"];
            [dic setObject:[[sessionArray valueForKey:@"RpeCode"] objectAtIndex:i] forKey:@"RATEPERCEIVEDEXERTION"];
            [dic setObject:[[sessionArray valueForKey:@"timeValue"] objectAtIndex:i] forKey:@"DURATION"];
            [dic setObject:[[sessionArray valueForKey:@"ballsValue"] objectAtIndex:i] forKey:@"BALL"];
            [traininglist addObject:dic];
        }
        
        WorkloadCode = [[sessionArray valueForKey:@"WorkloadCode"] objectAtIndex:0];
        NSString *datee = self.datelbl.text;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *matchdate = [dateFormat dateFromString:datee];
        
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"MM-dd-yyyy"];
        NSString *actualdate = [dateFormat1 stringFromDate:matchdate];
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(usercode)   [dic    setObject:usercode     forKey:@"USERCODE"];
        if(playerCode)   [dic    setObject:playerCode     forKey:@"PLAYERCODE"];
        if(WorkloadCode )   [dic    setObject:WorkloadCode     forKey:@"WORKLOADCODE"];
        if(actualdate )   [dic    setObject:actualdate     forKey:@"WORKLOADDATE"];
        if(traininglist)   [dic    setObject:traininglist     forKey:@"Trainingloadlist"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                BOOL Status = [responseObject valueForKey:@"Status"];
                if(Status == YES)
                {
                    NSLog(@"success");
                    [self ShowAlterMsg:@"Training Load Updated Successfully"];
                
                if([self.isfromHome isEqualToString:@"NO"])
                    {
                    [self.view removeFromSuperview];
                    [self.Delegate closeUpdateTrainingSource];
                    }
                else
                    {
                    [appDel.frontNavigationController popViewControllerAnimated:YES];
                    }
                  
                }
                
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
             
            
        }];
    }
    
}

- (IBAction)CancelAction:(id)sender {
    [self.view removeFromSuperview];
    [self.Delegate closeUpdateTrainingSource];
}



-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
     if(textField == self.timelbl || textField == self.ballslbl)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength>3)
        {
            [AppCommon showAlertWithMessage:@"Maximum length should be 3 only"];
        }
        return newLength <= 3;
    }
    
    return nil;
}

-(void)DateWebservice
{
    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    NSString *playerCode;
    if([AppCommon isCoach])
    {
        
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    
    
//    NSString *selectedDate = self.datelbl.text;
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    NSDate *matchdate = [dateFormat dateFromString:selectedDate];
//    [dateFormat setDateFormat:@"dd/MM/yyyy"];
//    //NSString * actualDate = [dateFormat stringFromDate:matchdate];
//
//
//    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
//    [dateFormat1 setDateFormat:@"MM-dd-yyyy"];
//    NSDate *matchdate1 = [dateFormat dateFromString:selectedDate];
//    NSString * actualDate = [dateFormat stringFromDate:matchdate1];
    
    
    NSString *dateString = self.datelbl.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    
    
    [objWebservice fetchTrainingLoadDate :fetchTrainingLoadDateKey : playerCode :dateString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = responseObject;
        if(arr.count >0)
        {
            if(![[responseObject valueForKey:@"WorkloadTrainingDetails"] isEqual:[NSNull null]])
            {
                
                NSMutableArray *reqArray = [[NSMutableArray alloc]init];
                reqArray = [responseObject valueForKey:@"WorkloadTrainingDetails"];
                
                self.TodayLoadArray = [[NSMutableArray alloc]init];
                self.YesterdayLoadArray = [[NSMutableArray alloc]init];
                
                
                //[self samplePieChart];
                for(int i=0;i<reqArray.count;i++)
                {

                    if([[[reqArray valueForKey:@"WORKLOADDATE"] objectAtIndex:i] isEqualToString:newDateString] )
                    {

                        [self.TodayLoadArray addObject:[reqArray  objectAtIndex:i]];

                        self.SaveBtn.hidden = YES;
                        self.FetchedUpdateBtn.hidden = NO;
                        _isToday = @"yes";
                        
                    }

                }
                if(self.TodayLoadArray.count>0)
                {
                [self setValuesUpdate];
                }
                else
                {
                    [sessionArray removeAllObjects];
                    self.SaveBtn.hidden = NO;
                    self.FetchedUpdateBtn.hidden = YES;
                    [self.SessionTable reloadData];
                    [self.markers removeAllObjects];
                    [circleChart removeFromSuperview];
                    [self TodayCircularChart];
                    
                }
     
                [AppCommon hideLoading];
            }
            else
            {
                [sessionArray removeAllObjects];
                self.SaveBtn.hidden = NO;
                self.FetchedUpdateBtn.hidden = YES;
                [self.SessionTable reloadData];
                [self.markers removeAllObjects];
                [circleChart removeFromSuperview];
                [self TodayCircularChart];
                
            }
        }
        [AppCommon hideLoading];
        
    }
  failure:^(AFHTTPRequestOperation *operation, id error) {
    NSLog(@"failed");
    [COMMON webServiceFailureError:error];
     }];
    
}


-(void)TodayCircularChart
{
    circleChart = [[CircularChart alloc] initWithFrame:CGRectMake(0,0,self.todayMainView.frame.size.width+20,self.todayMainView.frame.size.height+20)];
    //yesterdayChart = [[CircularChart alloc] initWithFrame:CGRectMake(0,0,self.yesterdayMainView.frame.size.width,self.yesterdayMainView.frame.size.height)];
    
    [circleChart setDataSource:self];
    [circleChart setDelegate:self];
    [circleChart setLegendViewType:LegendTypeHorizontal];
    [circleChart setShowCustomMarkerView:TRUE];
    [circleChart drawCircularChart];
    [self.todayMainView addSubview:circleChart];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:TotalCount];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [label setAdjustsFontSizeToFitWidth:TRUE];
    [label setCenter:circleChart.center];
    [circleChart addSubview:label];
    
    
    

}

#pragma mark CircularChartDataSource
- (CGFloat)strokeWidthForCircularChart{
    return 20;
}

- (NSInteger)numberOfValuesForCircularChart{
    
        return self.markers.count;
}

- (UIColor *)colorForValueInCircularChartWithIndex:(NSInteger)lineNumber{
//    NSInteger aRedValue = arc4random()%255;
//    NSInteger aGreenValue = arc4random()%255;
//    NSInteger aBlueValue = arc4random()%255;
//    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    
    UIColor *randColor;
    if(lineNumber == 0)
    {
        randColor = [UIColor colorWithRed:235/255.0f green:62/255.0f blue:114/255.0f alpha:1.0f];
    }
    else if(lineNumber == 1)
    {
        randColor = [UIColor colorWithRed:45/255.0f green:176/255.0f blue:216/255.0f alpha:1.0f];
    }
    else if(lineNumber == 2)
    {
        randColor = [UIColor colorWithRed:126/255.0f green:196/255.0f blue:68/255.0f alpha:1.0f];
    }
    else if(lineNumber == 3)
    {
        randColor = [UIColor colorWithRed:250/255.0f green:155/255.0f blue:54/255.0f alpha:1.0f];
    }
    else if(lineNumber == 4)
    {
        randColor = [UIColor colorWithRed:75/255.0f green:116/255.0f blue:216/255.0f alpha:1.0f];
    }
    else if(lineNumber == 5)
    {
        randColor = [UIColor colorWithRed:40/255.0f green:110/255.0f blue:60/255.0f alpha:1.0f];
    }
    else if(lineNumber == 6)
    {
        randColor = [UIColor lightGrayColor];
    }
    else if(lineNumber == 7)
    {
        randColor = [UIColor yellowColor];
    }
    else
    {
        randColor = [UIColor darkGrayColor];
    }
    
    return randColor;
}

- (NSString *)titleForValueInCircularChartWithIndex:(NSInteger)index{
    //return [NSString stringWithFormat:@"",[[self.todaysLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:index]];
   
//    if(_isToday)
//    {
//        return [[self.TodayLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:index];
//    }
//    else
//    {
//        return [[self.YesterdayLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:index];
//    }
    
     return [[sessionArray valueForKey:@"ActivityName"] objectAtIndex:index];
}

- (NSNumber *)valueInCircularChartWithIndex:(NSInteger)index{
        int value = [[self.markers objectAtIndex:index] intValue];
        return [NSNumber numberWithInt:value];
}

- (UIView *)customViewForCircularChartTouchWithValue:(NSNumber *)value{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:4.0F];
    [view.layer setBorderWidth:1.0F];
    [view.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:2.0F];
    [view.layer setShadowOpacity:0.3F];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"Circular Data: %@", value]];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [label setAdjustsFontSizeToFitWidth:TRUE];
    [view addSubview:label];
    
    [view setFrame:label.frame];
    return view;
}

#pragma mark CircularChartDelegate
- (void)didTapOnCircularChartWithValue:(NSString *)value{
    NSLog(@"Circular Chart: %@",value);
}





@end
