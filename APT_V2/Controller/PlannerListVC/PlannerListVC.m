//
//  PlannerListVC.m
//  AlphaProTracker
//
//  Created by Mac on 14/09/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "PlannerListVC.h"
#import "PlannerCell.h"
#import "CustomNavigation.h"
#import "PlannerAddEvent.h"
#import "WebService.h"
#import "AppCommon.h"
#import "Config.h"
//#import "HomeVC.h"


@interface PlannerListVC ()
{
    NSString *usercode;
    NSString *cliendcode;
    NSString *userref;
    
}
@property (nonatomic,strong) IBOutlet UIButton * addBtn;
@property (nonatomic,strong) WebService * objWebservice;

@property (nonatomic,strong) NSMutableArray * AllEventListArray;
@property (nonatomic,strong) NSMutableArray * AllEventDetailListArray;
@property (nonatomic,strong) NSMutableArray * ParticipantsTypeArray;
@property (nonatomic,strong) NSMutableArray * PlayerTeamArray;
@property (nonatomic,strong) NSMutableArray * EventStatusArray;
@property (nonatomic,strong) NSMutableArray * EventTypeArray;

@end

@implementation PlannerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addBtn.layer.cornerRadius = 20;
    self.addBtn.layer.masksToBounds = YES;
    self.objWebservice =[[WebService alloc]init];
    
    
    float headerWidth = self.view.frame.size.width;
    
    float headerWidthHalf = headerWidth/2;
    
    self.EventWidth.constant = headerWidthHalf/3;
    self.stWidth.constant = headerWidthHalf/3;
    self.etWidth.constant = headerWidthHalf/3;
    self.CmtsWidth.constant = headerWidth/2;
    
    if([AppCommon isCoach])
    {
        self.addBtn.hidden = NO;
    }
    else
    {
        self.addBtn.hidden = YES;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *actualdate = [dateFormatter dateFromString:self.DateSelected];
    
    
    NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
    [dfs setDateFormat:@"dd-MMM-yyyy"];
    NSString * actualdate1 = [dfs stringFromDate:actualdate];
    
    self.Datelbl.text = actualdate1;
    
    usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    userref = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    [self EventTypeWebservice :usercode:cliendcode:userref];
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];


}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navi_View addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
}
-(void)EventTypeWebservice:(NSString *) usercode :(NSString*) cliendcode:(NSString *)userreference
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",PlannerEventKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(usercode)   [dic    setObject:usercode     forKey:@"CreatedBy"];
        if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
        if(userreference)   [dic    setObject:userreference     forKey:@"Userreferencecode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                self.AllEventListArray = [[NSMutableArray alloc]init];
                
                NSMutableArray * objAlleventArray= [responseObject valueForKey:@"ListEventTypeDetails"];
                
                
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
                [mutableDict setObject:@"" forKey:@"EventTypeColor"];
                [mutableDict setObject:@"" forKey:@"EventTypeCode"];
                [mutableDict setObject:@"All EVENT" forKey:@"EventTypename"];
                
                [self.AllEventListArray addObject:mutableDict];
                for(int i=0; objAlleventArray.count>i;i++)
                {
                    NSMutableDictionary * objDic =[objAlleventArray objectAtIndex:i];
                    [self.AllEventListArray addObject:objDic];
                }
                
                self.ParticipantsTypeArray =[[NSMutableArray alloc]init];
                self.ParticipantsTypeArray=[responseObject valueForKey:@"ListParticipantsTypeDetails"];
                
                self.PlayerTeamArray =[[NSMutableArray alloc]init];
                self.PlayerTeamArray =[responseObject valueForKey:@"ListPlayerTeamDetails"];
                
                self.EventTypeArray  =[[NSMutableArray alloc]init];
                self.EventTypeArray =[responseObject valueForKey:@"ListEventTypeDetails"];
                
                self.EventStatusArray =[[NSMutableArray alloc]init];
                self.EventStatusArray =[responseObject valueForKey:@"ListEventStatusDetails"];
            
                [self.PlannerListTbl reloadData];
                
            }
            
            
            
            [AppCommon hideLoading];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
        }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.objPlannerArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Plannerlistcell";
    
    
    PlannerCell * objCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (objCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PlannerCell" owner:self options:nil];
        objCell = self.objPlannercell;
    }
    
//    objCell.objEventName_lbl.text =[[self.objPlannerArray valueForKey:@"title"] objectAtIndex:indexPath.row];
//
//    NSString * startdate =[[self.objPlannerArray valueForKey:@"startdatetime"] objectAtIndex:indexPath.row];
//    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
//    [dateFormatters setDateFormat:@"dd/MM/yyyy hh:mm a"];
//    NSDate *dates = [dateFormatters dateFromString:startdate];
//
//    NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
//    [dfs setDateFormat:@"hh:mma"];
//    NSString * endDateStr = [dfs stringFromDate:dates];
//
//
//    NSString * endtime =[[self.objPlannerArray valueForKey:@"enddatetime"] objectAtIndex:indexPath.row];
//    NSDateFormatter *dateFormatterss = [[NSDateFormatter alloc] init];
//    [dateFormatterss setDateFormat:@"dd/MM/yyyy hh:mm a"];
//    NSDate *date = [dateFormatters dateFromString:endtime];
//
//    NSDateFormatter* df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"hh:mma"];
//    NSString * endtimeStr = [df stringFromDate:date];
//
//    objCell.objStartTime_lbl.text = endDateStr;
//    objCell.objendTime_lbl.text = endtimeStr;
//    objCell.Commentslbl.text = [[self.objPlannerArray valueForKey:@"comments"] objectAtIndex:indexPath.row];
    
    
    
//    EventRecord * objRecord    = [[EventRecord alloc]init];
//    objRecord.numCustomerID    = @1;
//    objRecord.stringCustomerName  = [temp valueForKey:@"title"];
//    objRecord.dateDay          = ssdate;
//    objRecord.EnddateDay          =  ssdate;
//    objRecord.dateTimeBegin  = [NSDate dateWithHour:00 min:01];
//    objRecord.dateTimeEnd    = [NSDate dateWithHour:23 min:59];
//    objRecord.color         = [temp valueForKey:@"backgroundColor"];
//    [allCompetitionArray addObject:objRecord];
//    ssdate = [ssdate dateByAddingTimeInterval:24*60*60];
    
    
    NSDate *starttime = [self checkNull:[[self.objPlannerArray valueForKey:@"dateTimeBegin"] objectAtIndex:indexPath.row]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *formattedDateStringStart = [dateFormatter stringFromDate:starttime];
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:starttime];
//    NSInteger hour = [components hour];
//    NSInteger minute = [components minute];
//
    
    NSDate *endtime = [self checkNull:[[self.objPlannerArray valueForKey:@"dateTimeEnd"] objectAtIndex:indexPath.row]];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    NSString *formattedDateStringEnd = [dateFormatter1 stringFromDate:endtime];
    
//    NSCalendar *calendar1 = [NSCalendar currentCalendar];
//    NSDateComponents *components1 = [calendar1 components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endtime];
//    NSInteger endhour = [components1 hour];
//    NSInteger endminute = [components1 minute];
    
    objCell.objEventName_lbl.text = [self checkNull:[[self.objPlannerArray valueForKey:@"stringCustomerName"] objectAtIndex:indexPath.row]];
    objCell.objStartTime_lbl.text = formattedDateStringStart;
    objCell.objendTime_lbl.text = formattedDateStringEnd;
    objCell.Commentslbl.text = [self checkNull:[[self.objPlannerArray valueForKey:@"comments"] objectAtIndex:indexPath.row]];
    
    objCell.selectionStyle =UITableViewCellSelectionStyleNone;
    objCell.objEventName_lbl.textColor = [self colorWithHexString:[self checkNull:[[self.objPlannerArray valueForKey:@"color"] objectAtIndex:indexPath.row]]] ;
    objCell.objStartTime_lbl.textColor = [self colorWithHexString:[self checkNull:[[self.objPlannerArray valueForKey:@"color"] objectAtIndex:indexPath.row]]] ;
    objCell.objendTime_lbl.textColor = [self colorWithHexString:[self checkNull:[[self.objPlannerArray valueForKey:@"color"] objectAtIndex:indexPath.row]]] ;
    objCell.Commentslbl.textColor = [self colorWithHexString:[self checkNull:[[self.objPlannerArray valueForKey:@"color"] objectAtIndex:indexPath.row]]] ;
    objCell.contentView.backgroundColor = [UIColor whiteColor];
    
    float cellWidth = objCell.frame.size.width;
    
    float cellWidthHalf = cellWidth/2;
    
    objCell.EventWidth.constant = cellWidthHalf/3;
    objCell.stWidth.constant = cellWidthHalf/3;
    objCell.etWidth.constant = cellWidthHalf/3;
    objCell.CmtsWidth.constant = cellWidthHalf;
    
    return objCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}
-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if( [AppCommon isCoach])
    {
    
    NSDictionary * selectDic = [self.objPlannerArray objectAtIndex:indexPath.row];
    PlannerAddEvent  * objaddEvent=[[PlannerAddEvent alloc]init];
    objaddEvent = (PlannerAddEvent *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
    objaddEvent.isEdit =YES;
    objaddEvent.objSelectEditDic =selectDic;
    objaddEvent.ListeventTypeArray = self.EventTypeArray;
    objaddEvent.ListeventStatusArray =self.EventStatusArray;
    objaddEvent.ListparticipantTypeArray =self.ParticipantsTypeArray;

    [self.navigationController pushViewController:objaddEvent animated:YES];
    }
    
    
    
//    PlannerAddEvent *objaddEvent = [[PlannerAddEvent alloc] initWithNibName:@"PlannerAddEvent" bundle:nil];
//    objaddEvent.isEdit =YES;
//    objaddEvent.objSelectEditDic =selectDic;
//    objaddEvent.ListeventTypeArray = self.EventTypeArray;
//    objaddEvent.ListeventStatusArray =self.EventStatusArray;
//    objaddEvent.ListparticipantTypeArray =self.ParticipantsTypeArray;
//    [self.view addSubview:objaddEvent.view];

}

-(IBAction)didClickAddBtn:(id)sender
{
    PlannerAddEvent  * objaddEvent=[[PlannerAddEvent alloc]init];
    objaddEvent = (PlannerAddEvent *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
    objaddEvent.selectDateStr =self.DateSelected;
    objaddEvent.isEdit =NO;
    objaddEvent.ListeventTypeArray = self.EventTypeArray;
    objaddEvent.ListeventStatusArray =self.EventStatusArray;
    objaddEvent.ListparticipantTypeArray =self.ParticipantsTypeArray;
    [self.navigationController pushViewController:objaddEvent animated:YES];
    
//    PlannerAddEvent *objaddEvent = [[PlannerAddEvent alloc] initWithNibName:@"PlannerAddEvent" bundle:nil];
//    objaddEvent.isEdit =NO;
//    objaddEvent.ListeventTypeArray = self.EventTypeArray;
//    objaddEvent.ListeventStatusArray =self.EventStatusArray;
//    objaddEvent.ListparticipantTypeArray =self.ParticipantsTypeArray;
//    [self.view addSubview:objaddEvent.view];
}

-(IBAction)didClickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)HomeBtnAction:(id)sender
{
//    HomeVC  * objTabVC=[[HomeVC alloc]init];
//    objTabVC = (HomeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    [self.navigationController pushViewController:objTabVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
