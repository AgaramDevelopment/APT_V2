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
//#import "WellnessTrainingBowlingVC.h"

@interface TrainingLoadUpdateVC ()<PieChartViewDelegate,PieChartViewDataSource>
{
    UIDatePicker *datePicker;
    float num1;
    float num2;
    float num3;
    float num4;
    
    BOOL isActivity;
    BOOL isRpe;
    
    PieChartView *pieChartView;
    
    WebService *objWebservice;
    
    NSString *ActivityCode;
    NSString *rpeCode;
    
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *poptableXposition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *poptableyposition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *poptableWidth;

@property (strong, nonatomic)  NSMutableArray *DropdownDataArray;
@property (strong, nonatomic)  NSMutableArray *RpeDataArray;
@property (strong, nonatomic)  NSMutableArray *ActivityDataArray;
@end


@implementation TrainingLoadUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view_datepicker.hidden=YES;
    sessionArray = [[NSMutableArray alloc]init];
    objWebservice = [[WebService alloc]init];
    //self.markers = [[NSMutableArray alloc] initWithObjects:@"50.343", @"84.43", @"63.22", @"31.43", nil];
    
    self.sessionBtn.hidden = NO;
    self.UpdateBtn.hidden = YES;
    
    self.SaveBtn.hidden = NO;
    self.FetchedUpdateBtn.hidden = YES;
    
   // rpeCode = @"MSC062";
    
    //sessionArray = [[NSMutableArray alloc] initWithObjects:@"Session 1", @"Session 2", @"Session 3", nil];
    //activityArray = [[NSMutableArray alloc] initWithObjects:@"Cardio", @"Strengthening", @"Bowling", nil];
   // valueArray = [[NSMutableArray alloc] initWithObjects:@"245", @"124", @"342", nil];
     self.popViewtable.hidden = YES;
    [self DropDownWebservice];
    
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActivityAction:(id)sender {
    
    
    isActivity = YES;
    isRpe = NO;
    self.popViewtable.hidden = NO;
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
    self.poptableWidth.constant = self.RpeFilterview.frame.size.width;
    self.poptableXposition.constant = self.RpeFilterview.frame.origin.x;
    self.poptableyposition.constant = self.RpeFilterview.frame.origin.y;
    self.DropdownDataArray = [[NSMutableArray alloc]init];
    self.DropdownDataArray = self.RpeDataArray;
    [self showAnimate];
    [self.popViewtable reloadData];
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
    [dic setObject:self.ballslbl.text forKey:@"ballsValue"];
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
       if(!keyValue1)
       {
           [sessionArray addObject:dic];
       }
       else
       {
           [self ShowAlterMsg:@"Activity Already Exists"];
       }
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
        [self samplePieChart];
         [pieChartView reloadData];
        
        int total=0;
        for(int i=0;i<self.markers.count;i++)
        {
            NSString *reqValue = [self.markers objectAtIndex:i];
            int value = [reqValue intValue];
            total=total+value;
        }
        self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
    }
    
    self.activitylbl.text = @"";
    self.timelbl.text =@"";
    self.rpelbl.text = @"";
    
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
        
        pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(self.countview.frame.origin.x,self.countview.frame.origin.y,self.countview.frame.size.width,self.countview.frame.size.width)];
        pieChartView.delegate = self;
        pieChartView.datasource = self;
        [self.todayMainView addSubview:pieChartView];
        
    } else {
        
        pieChartView = [[PieChartView alloc] initWithFrame:CGRectMake(self.countview.frame.origin.x,self.countview.frame.origin.y,self.countview.frame.size.width,self.countview.frame.size.width)];
        pieChartView.delegate = self;
        pieChartView.datasource = self;
        [self.todayMainView addSubview:pieChartView];
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
        self.activitylbl.text = [[self.DropdownDataArray valueForKey:@"MetaSubcodeDescription"] objectAtIndex:indexPath.row];
        ActivityCode = [[self.DropdownDataArray valueForKey:@"MetaSubCode"] objectAtIndex:indexPath.row];
        //self.popViewtable.hidden = YES;
            [self removeAnimate];
        }
        
        if(isRpe==YES)
        {
            self.rpelbl.text = [[self.DropdownDataArray valueForKey:@"MetaSubcodeDescription"] objectAtIndex:indexPath.row];
            rpeCode = [[self.DropdownDataArray valueForKey:@"MetaSubCode"] objectAtIndex:indexPath.row];
            //self.popViewtable.hidden = YES;
            [self removeAnimate];
        }
    }
    if(tableView == self.SessionTable)
    {
        self.sessionBtn.hidden = YES;
        self.UpdateBtn.hidden = NO;
        
        self.activitylbl.text = [[sessionArray valueForKey:@"ActivityName"] objectAtIndex:indexPath.row];
        self.rpelbl.text = [[sessionArray valueForKey:@"rpeValue"] objectAtIndex:indexPath.row];
        self.timelbl.text = [[sessionArray valueForKey:@"timeValue"] objectAtIndex:indexPath.row];
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

-(void)DropDownWebservice
{
    [AppCommon showLoading ];
    
    NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
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
        [dic setObject:[[self.TodayLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:i] forKey:@"ActivityName"];
        [dic setObject:[[self.TodayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i] forKey:@"ActivityCode"];
        [dic setObject:[[self.TodayLoadArray valueForKey:@"RATEPERCEIVEDEXERTION"] objectAtIndex:i] forKey:@"RpeCode"];
        int timecount = [[[self.TodayLoadArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
        int rpecount =  [[[self.TodayLoadArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
        int total = timecount * rpecount;
        [dic setObject:[NSString stringWithFormat:@"%d",total] forKey:@"Value"];
        [dic setObject:[NSString stringWithFormat:@"%d",rpecount] forKey:@"rpeValue"];
        [dic setObject:[NSString stringWithFormat:@"%d",timecount] forKey:@"timeValue"];
        [dic setObject:[[self.TodayLoadArray valueForKey:@"BALL"] objectAtIndex:i] forKey:@"ballsValue"];
        
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
        [self samplePieChart];
        [pieChartView reloadData];
        
        int total=0;
        for(int i=0;i<self.markers.count;i++)
        {
            NSString *reqValue = [self.markers objectAtIndex:i];
            int value = [reqValue intValue];
            total=total+value;
        }
        self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
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
            [dic setObject:[[self.YesterdayLoadArray valueForKey:@"ACTIVITYTYPENAME"] objectAtIndex:i] forKey:@"ActivityName"];
            [dic setObject:[[self.YesterdayLoadArray valueForKey:@"ACTIVITYTYPECODE"] objectAtIndex:i] forKey:@"ActivityCode"];
            
            int timecount = [[[self.YesterdayLoadArray valueForKey:@"DURATION"] objectAtIndex:i] intValue];
            int rpecount =  [[[self.YesterdayLoadArray valueForKey:@"RPE"] objectAtIndex:i] intValue];
            int total = timecount * rpecount;
            [dic setObject:[NSString stringWithFormat:@"%d",total] forKey:@"Value"];
            [dic setObject:[NSString stringWithFormat:@"%d",rpecount] forKey:@"rpeValue"];
            [dic setObject:[NSString stringWithFormat:@"%d",timecount] forKey:@"timeValue"];
            [dic setObject:[[self.YesterdayLoadArray valueForKey:@"BALL"] objectAtIndex:i] forKey:@"ballsValue"];
            
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
            [self samplePieChart];
            [pieChartView reloadData];
            
            int total=0;
            for(int i=0;i<self.markers.count;i++)
            {
                NSString *reqValue = [self.markers objectAtIndex:i];
                int value = [reqValue intValue];
                total=total+value;
            }
            self.totalCountlbl.text = [NSString stringWithFormat:@"%d",total];
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
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.view_datepicker.frame.origin.y-180,self.view.frame.size.width,100)];
    
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
        NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        
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
                    [self.view removeFromSuperview];
                    
                    // [self.pieChartRight reloadData];
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
        NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        
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
        
        NSString *WorkloadCode = [[sessionArray valueForKey:@"WorkloadCode"] objectAtIndex:0];
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
                    [self.view removeFromSuperview];
                    
                    // [self.pieChartRight reloadData];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)DateWebservice
{
    [AppCommon showLoading ];
    
    NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    
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
    
    
    [objWebservice fetchTrainingLoad :fetchTrainingLoadKey : playerCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = responseObject;
        if(arr.count >0)
        {
            if(![[responseObject valueForKey:@"WorkloadTraingDetails"] isEqual:[NSNull null]])
            {
                
                NSMutableArray *reqArray = [[NSMutableArray alloc]init];
                reqArray = [responseObject valueForKey:@"WorkloadTraingDetails"];
                
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
                        [self setValuesUpdate];
                    }

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
