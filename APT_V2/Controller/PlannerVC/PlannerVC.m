//
//  PlannerVC.m
//  AlphaProTracker
//
//  Created by Mac on 28/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "PlannerVC.h"
#import "CustomNavigation.h"
#import "SACalendar.h"
#import "DateUtil.h"
#import "PlannerAddEvent.h"
#import "AppCommon.h"
#import "Config.h"
#import "WebService.h"
#import "PlannerListVC.h"
//#import "HomeVC.h"

#import "FFCalendarViewController.h"
#import "FFCalendar.h"

#import "EventRecord.h"
#import "FFBlueButton.h"
#import "FFMonthCollectionView.h"


@interface PlannerVC ()<FFMonthCalendarViewProtocol, FFWeekCalendarViewProtocol, FFDayCalendarViewProtocol,DateProtocol>
{
    BOOL isEvent;
    SACalendar *saCalendar;
    NSString *usercode;
    NSString *cliendcode;
    NSString *userreference;
    NSDate *date1;
    NSDate *dateFromString;
    NSInteger loadedCalendrType;
    NSString *EventBgcolor;
}

@property (nonatomic) BOOL boolDidLoad;
@property (nonatomic) BOOL boolYearViewIsShowing;


@property (nonatomic, strong) UILabel *labelWithMonthAndYear;
@property (nonatomic,strong) IBOutlet UIButton * selectTitleBtn;
@property (nonatomic,strong) IBOutlet UILabel * Tabbar;
@property (nonatomic,strong) IBOutlet UIView * titleview;
@property (nonatomic,strong) IBOutlet UIView * eventview;
@property (nonatomic,strong) IBOutlet UITableView * eventTbl;
@property (nonatomic,strong) IBOutlet UILabel * eventLbl;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * TabbarPosition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * TabbarWidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * tableHeight;

@property (nonatomic, strong) FFEditEventPopoverController *popoverControllerEditar;
@property (nonatomic, strong) FFYearCalendarView *viewCalendarYear;
@property (nonatomic, strong) FFMonthCalendarView *viewCalendarMonth;
@property (nonatomic, strong) FFWeekCalendarView *viewCalendarWeek;
@property (nonatomic, strong) FFDayCalendarView *viewCalendarDay;
@property (nonatomic,strong) FFMonthCollectionView * monthCollect;

@property (nonatomic,strong) WebService * objWebservice;

@property (nonatomic, strong) NSMutableDictionary *dictEvents;
@property (nonatomic, strong) NSArray *arrayButtons;
@property (nonatomic, strong) NSArray *arrayCalendars;
@property (nonatomic,strong) NSMutableArray * AllEventListArray;
@property (nonatomic,strong) NSMutableArray * AllEventDetailListArray;
@property (nonatomic,strong) NSMutableArray * PlannerResponseArray;
@property (nonatomic,strong) NSMutableArray * eventArray;

@end

@implementation PlannerVC
@synthesize boolDidLoad;
@synthesize boolYearViewIsShowing;
@synthesize protocol;
@synthesize arrayWithEvents;
@synthesize dictEvents;
@synthesize labelWithMonthAndYear;
@synthesize arrayButtons;
@synthesize arrayCalendars;
@synthesize popoverControllerEditar;
@synthesize viewCalendarYear;
@synthesize viewCalendarMonth;
@synthesize viewCalendarWeek;
@synthesize viewCalendarDay;
@synthesize calendarView,tapview;

@synthesize plannerTblHeight;

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.TabbarPosition.constant = self.MONTH.frame.origin.x;
        self.TabbarWidth.constant = self.MONTH.frame.size.width;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameOfMonth.text = @"";
//    self.eventTbl.hidden =YES;
    
    self.objWebservice =[[WebService alloc]init];
    
    usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    userreference = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    viewCalendarMonth = [[FFMonthCalendarView alloc] initWithFrame:calendarView.frame];
    
    [viewCalendarMonth setCollectionDidSelectDelegate:self];
    viewCalendarWeek = [[FFWeekCalendarView alloc] initWithFrame:calendarView.frame];
    [viewCalendarWeek setCollectionDidSelectDelegate:self];
    viewCalendarDay = [[FFDayCalendarView alloc] initWithFrame:calendarView.frame];
    [viewCalendarDay setCollectionDidSelectDelegate:self];
    loadedCalendrType = 0;
    arrayButtons = @[self.MONTH, self.WEEK, self.DAY];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!boolDidLoad) {
        boolDidLoad = YES;
        [self buttonTodayAction:nil];
    }
    
    [self EventTypeWebservice];
    self.TabbarPosition.constant = self.MONTH.frame.origin.x + self.MONTH.frame.size.width/4;
    self.TabbarWidth.constant = self.MONTH.frame.size.width/2;
   // [COMMON AddMenuView:self.view];
    
}

-(IBAction)MonthAction:(id)sender
{
    self.Tabbar.hidden = NO;
    self.nameOfMonth.text = @"";
    
    self.TabbarPosition.constant = self.MONTH.frame.origin.x + [sender frame].size.width/4;
    self.TabbarWidth.constant = self.MONTH.frame.size.width/2;
    [UIView animateWithDuration:0.1 animations:^{
        [sender layoutIfNeeded];
    }];

    loadedCalendrType = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChanged:) name:DATE_MANAGER_DATE_CHANGED object:nil];

    [viewCalendarMonth removeFromSuperview];
    [viewCalendarWeek removeFromSuperview];
    [viewCalendarDay removeFromSuperview];
    [self addMonthCalendar];
    
}

-(IBAction)WeekAction:(id)sender
{
    loadedCalendrType = 1;
    self.Tabbar.hidden = NO;
    
//    self.TabbarPosition.constant = self.WEEK.frame.origin.x + [sender frame].size.width/4;
//    self.TabbarWidth.constant = self.WEEK.frame.size.width/2;
    
    self.TabbarPosition.constant = self.WEEK.frame.origin.x + [sender frame].size.width/4;
    self.TabbarWidth.constant = self.WEEK.frame.size.width/2;
    [UIView animateWithDuration:0.1 animations:^{
        [sender layoutIfNeeded];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChanged:) name:DATE_MANAGER_DATE_CHANGED object:nil];
    [viewCalendarMonth removeFromSuperview];
    [viewCalendarWeek removeFromSuperview];
    [viewCalendarDay removeFromSuperview];
    
    [self addCalendarWeek];
//    [self setArrayWithEvents:[self arrayWithEvents]];
    
}

-(IBAction)DayAction:(id)sender
{
    loadedCalendrType = 2;
    self.Tabbar.hidden = NO;
//    self.TabbarPosition.constant = self.DAY.frame.origin.x + [sender frame].size.width/4;
//    self.TabbarWidth.constant = self.DAY.frame.size.width/2;
    
    self.TabbarPosition.constant = self.DAY.frame.origin.x + [sender frame].size.width/4;
    self.TabbarWidth.constant = self.DAY.frame.size.width/2;
    [UIView animateWithDuration:0.1 animations:^{
        [sender layoutIfNeeded];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChanged:) name:DATE_MANAGER_DATE_CHANGED object:nil];
    [viewCalendarMonth removeFromSuperview];
    [viewCalendarWeek removeFromSuperview];
    [viewCalendarDay removeFromSuperview];

    [self addCalendarDay];
    [self setArrayWithEvents:[self arrayWithEvents]];
    
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
    
    if([self.checkBacknavi isEqualToString:@"yes"])
    {
    isBackEnable =YES;
    }
    else
    {
        isBackEnable =NO;
    }
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
    [self.navi_View addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
}
-(void)actionBack
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDel.frontNavigationController popViewControllerAnimated:YES];
}

-(IBAction)didClickevent:(id)sender
{
    if(isEvent==NO)
    {
        [tapview setHidden:NO];

//        self.eventTbl.hidden =NO;
        isEvent=YES;
        
//        CGFloat height = MIN(self.view.bounds.size.height, self.eventTbl.contentSize.height);
//        self.tableHeight.constant = height-100;
//        [self.view layoutIfNeeded];
       // [self EventTypeWebservice :usercode:cliendcode:userref];
        NSIndexSet* set = [NSIndexSet indexSetWithIndex:0];
        [self.eventTbl reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        
//        constraint.constant = someValue //change constraint's property
//        UIView.animateWithDuration(0.3){
//            self.view.layoutIfNeeded() //tell the view to layout again
//        }
        
    }
    else{
//        self.plannerTblHeight.constant = 0;
//        [UIView animateWithDuration:0.3 animations:^{
////            self.plannerTblHeight.constant = 0;
//            self.view.layoutIfNeeded;
//        }];

//        self.eventTbl.hidden =YES;
        isEvent =NO;
        [tapview setHidden:YES];

    }
    [self tblShowHideAnimation];
}


-(void)tblShowHideAnimation{
    // initially 0 to 175
    
    self.plannerTblHeight.constant = (self.plannerTblHeight.constant == 0 ? 175 : 0);
    [UIView animateWithDuration:0.3 animations:^{
        [self.eventTbl layoutIfNeeded];
    }];

}




-(void)EventTypeWebservice
{
    if(![COMMON isInternetReachable])
        return;
    
        [AppCommon showLoading];
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",PlannerEventKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = requestSerializer;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(usercode)   [dic setObject:usercode forKey:@"CreatedBy"];
        if(cliendcode)   [dic setObject:cliendcode forKey:@"ClientCode"];
        if(userreference)   [dic setObject:userreference forKey:@"Userreferencecode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                self.AllEventListArray = [[NSMutableArray alloc]init];
                self.PlannerResponseArray = [[NSMutableArray alloc]init];
                self.PlannerResponseArray = responseObject;
                NSMutableArray * objAlleventArray= [responseObject valueForKey:@"ListEventTypeDetails"];
                
                
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
                [mutableDict setObject:@"" forKey:@"EventTypeColor"];
                [mutableDict setObject:@"" forKey:@"EventTypeCode"];
                [mutableDict setObject:@"All EVENT" forKey:@"EventTypename"];
                
                [self.AllEventListArray insertObject:mutableDict atIndex:0];
                [self.AllEventListArray addObjectsFromArray:objAlleventArray];
            }
            
            [AppCommon hideLoading];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.eventTbl reloadData];
//            });
//
            NSDate *now = [NSDate date]; //2018-03-31 09:22:11 +0000

            NSDate *startDate = [now dateByAddingTimeInterval:-30*24*60*60];//2018-03-01 09:22:11 +0000
            

            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"MM-dd-YYYY hh:mm:ss a"];
            NSString *startDateStr = [df stringFromDate:startDate];//03-01-2018 02:52:11 PM

            
            
            NSDate *enddate = [now dateByAddingTimeInterval:30*24*60*60]; //2018-04-30 09:22:11 +0000

            NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
            [dfs setDateFormat:@"MM-dd-YYYY hh:mm:ss a"];
            NSString * endDateStr = [dfs stringFromDate:enddate];//04-30-2018 02:52:11 PM

            
            NSString *usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
            
            NSString *cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
            
            [self EventDateFetchMethod :startDateStr:endDateStr:cliendcode:usercode];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            [AppCommon hideLoading];
        }];
    
}

-(void)EventDateFetchMethod :(NSString *)startDate :(NSString *) endDate :(NSString *)cliendCode :(NSString *)createdby
{
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",EventDateFetch]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = requestSerializer;
    
    //startDate = @"01-03-2018 12:14:01 PM";
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(startDate)   [dic    setObject:startDate     forKey:@"start"];
        if(endDate)   [dic    setObject:endDate     forKey:@"end"];
        if(cliendCode)   [dic    setObject:cliendCode     forKey:@"Clientcode"];
        if(createdby)   [dic    setObject:createdby     forKey:@"CreatedBy"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                self.AllEventDetailListArray = [[NSMutableArray alloc]init];
            
                [self.AllEventDetailListArray addObjectsFromArray:[responseObject valueForKey:@"lstEventDetailsEntity"]];
                self.eventArray = self.AllEventDetailListArray;
                [self setArrayWithEvents:[self arrayWithEvents]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIButton* button = [arrayButtons objectAtIndex:loadedCalendrType];
                    [button sendActionsForControlEvents:UIControlEventTouchUpInside];

                });

                [AppCommon hideLoading];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            [AppCommon hideLoading];
        }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.AllEventListArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    if(indexPath.row ==0)
    {
        cell.backgroundColor=[UIColor colorWithRed:(37/255.0f) green:(187/255.0f) blue:(151/255.0f) alpha:1.0f];
        self.eventview.backgroundColor =[UIColor colorWithRed:(37/255.0f) green:(187/255.0f) blue:(151/255.0f) alpha:1.0f];
    }
    else if(indexPath.row ==1)
    {
        cell.backgroundColor=[UIColor colorWithRed:(42/255.0f) green:(151/255.0f) blue:(243/255.0f) alpha:1.0f];
        //self.eventview.backgroundColor = [UIColor colorWithRed:(42/255.0f) green:(151/255.0f) blue:(243/255.0f) alpha:1.0f];
    }
    else if(indexPath.row ==2)
    {
        cell.backgroundColor=[UIColor colorWithRed:(247/255.0f) green:(116/255.0f) blue:(159/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==3)
    {
        cell.backgroundColor=[UIColor colorWithRed:(215/255.0f) green:(163/255.0f) blue:(69/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==4)
    {
        cell.backgroundColor=[UIColor colorWithRed:(162/255.0f) green:(99/255.0f) blue:(28/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==5)
    {
        cell.backgroundColor=[UIColor colorWithRed:(90/255.0f) green:(181/255.0f) blue:(96/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==6)
    {
        cell.backgroundColor=[UIColor colorWithRed:(60/255.0f) green:(172/255.0f) blue:(206/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==7)
    {
        cell.backgroundColor=[UIColor colorWithRed:(207/255.0f) green:(134/255.0f) blue:(46/255.0f) alpha:1.0f];
        
    }
    else if (indexPath.row ==8)
    {
        cell.backgroundColor=[UIColor colorWithRed:(71/255.0f) green:(30/255.0f) blue:(102/255.0f) alpha:1.0f];
        
    }
    else if (indexPath.row ==9)
    {
        cell.backgroundColor=[UIColor colorWithRed:(193/255.0f) green:(73/255.0f) blue:(74/255.0f) alpha:1.0f];
        
    }
    else
    {
        cell.backgroundColor=[UIColor colorWithRed:(97/255.0f) green:(50/255.0f) blue:(139/255.0f) alpha:1.0f];
        
    }
    
    
    cell.textLabel.text = [[self.AllEventListArray valueForKey:@"EventTypename"] objectAtIndex:indexPath.row];
    cell.textLabel.textColor =[UIColor whiteColor];
    self.eventLbl.text = [[self.AllEventListArray valueForKey:@"EventTypename"] objectAtIndex:0];
    
    //cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0)
    {
        NSString * selectStr = [[self.AllEventListArray valueForKey:@"EventTypename"] objectAtIndex:indexPath.row];
        NSString * eventTypeCode =[[self.AllEventListArray valueForKey:@"EventTypeCode"] objectAtIndex:indexPath.row];
        self.eventLbl.text = selectStr;
//        self.eventTbl.hidden =YES;
        isEvent =NO;
        
        self.AllEventDetailListArray = [[NSMutableArray alloc]init];
        self.AllEventDetailListArray = self.eventArray;
        
        [self setArrayWithEvents:[self arrayWithEvents]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton* button = [arrayButtons objectAtIndex:loadedCalendrType];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        });
        
    }
    else
    {
        NSString * selectStr = [[self.AllEventListArray valueForKey:@"EventTypename"] objectAtIndex:indexPath.row];
        NSString * eventTypeCode =[[self.AllEventListArray valueForKey:@"EventTypeCode"] objectAtIndex:indexPath.row];
        self.eventLbl.text = selectStr;
//        self.eventTbl.hidden =YES;
        isEvent =NO;
    
        self.AllEventDetailListArray = [[NSMutableArray alloc]init];
        for(int i=0;self.eventArray.count>i;i++)
        {
            NSDictionary * objDic =[self.eventArray objectAtIndex:i];
            NSString * eventType = [objDic valueForKey:@"eventtype"];
            if([eventTypeCode isEqualToString:eventType])
            {
                [self.AllEventDetailListArray addObject:objDic];
            }
        }
    
        [self setArrayWithEvents:[self arrayWithEvents]];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton* button = [arrayButtons objectAtIndex:loadedCalendrType];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        });
    }
    
    
    if(indexPath.row ==0)
    {
        //self.eventview.backgroundColor=[UIColor colorWithRed:(37/255.0f) green:(187/255.0f) blue:(151/255.0f) alpha:1.0f];
    }
    else if(indexPath.row ==1)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(42/255.0f) green:(151/255.0f) blue:(243/255.0f) alpha:1.0f];
    }
    else if(indexPath.row ==2)
    {
       self.eventview.backgroundColor=[UIColor colorWithRed:(247/255.0f) green:(116/255.0f) blue:(159/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==3)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(215/255.0f) green:(163/255.0f) blue:(69/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==4)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(162/255.0f) green:(99/255.0f) blue:(28/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==5)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(90/255.0f) green:(181/255.0f) blue:(96/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==6)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(60/255.0f) green:(172/255.0f) blue:(206/255.0f) alpha:1.0f];
        
    }
    else if(indexPath.row ==7)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(207/255.0f) green:(134/255.0f) blue:(46/255.0f) alpha:1.0f];
        
    }
    else if (indexPath.row ==8)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(71/255.0f) green:(30/255.0f) blue:(102/255.0f) alpha:1.0f];
        
    }
    else if (indexPath.row ==9)
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(193/255.0f) green:(73/255.0f) blue:(74/255.0f) alpha:1.0f];
        
    }
    else
    {
        self.eventview.backgroundColor=[UIColor colorWithRed:(97/255.0f) green:(50/255.0f) blue:(139/255.0f) alpha:1.0f];
    }
    
//    [self tblShowHideAnimation];
    [self closeView:nil];

}

-(IBAction)didClickBackBtn:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
//    HomeVC  * objTabVC=[[HomeVC alloc]init];
//    objTabVC = (HomeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    [self.navigationController pushViewController:objTabVC animated:YES];
}
-(IBAction)HomeBtnAction:(id)sender
{
//    HomeVC  * objTabVC=[[HomeVC alloc]init];
//    objTabVC = (HomeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    [self.navigationController pushViewController:objTabVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - FFDateManager Notification

- (void)dateChanged:(NSNotification *)notification {
    
    [self updateLabelWithMonthAndYear];
}

- (void)updateLabelWithMonthAndYear {
    
    NSDateComponents *comp = [NSDate componentsOfDate:[[FFDateManager sharedManager] currentDate]];
    NSString *string = boolYearViewIsShowing ? [NSString stringWithFormat:@"%li", (long)comp.year] : [NSString stringWithFormat:@"%@ %li", [arrayMonthName objectAtIndex:comp.month], (long)comp.year];
    //[self.nameOfMonth setText:string];
    
    self.nameOfMonth.text = [NSString stringWithFormat:@"%@ %ld",[arrayMonthName objectAtIndex:comp.month-1],(long)comp.year];
    [labelWithMonthAndYear setText:string];
}

#pragma mark - Init dictEvents

- (void)setArrayWithEvents:(NSMutableArray *)_arrayWithEvents {
    
    arrayWithEvents = _arrayWithEvents;
    
    dictEvents = [NSMutableDictionary new];
    
    for (EventRecord *event in _arrayWithEvents) {
        NSDateComponents *comp = [NSDate componentsOfDate:event.dateDay];
        NSDate *newDate = [NSDate dateWithYear:comp.year month:comp.month day:comp.day];
        NSMutableArray *array = [dictEvents objectForKey:newDate];
        if (!array) {
            array = [NSMutableArray new];
            [dictEvents setObject:array forKey:newDate];
        }
        [array addObject:event];
    }
}

#pragma mark - Add Calendars

-(void)addMonthCalendar
{
    [self updateLabelWithMonthAndYear];
    [viewCalendarMonth setFrame:CGRectMake(0,0,calendarView.frame.size.width,calendarView.frame.size.height)];
    [viewCalendarMonth setProtocol:self];
    [viewCalendarMonth setDictEvents:dictEvents];
    [calendarView addSubview:viewCalendarMonth];
    
}

- (void)addCalendarWeek {
    
    
    [viewCalendarWeek setFrame:CGRectMake(0,0,calendarView.frame.size.width,calendarView.frame.size.height)];
    [viewCalendarWeek setProtocol:self];
    [viewCalendarWeek setDictEvents:dictEvents];
    [calendarView addSubview:viewCalendarWeek];
}

- (void)addCalendarDay {
    
    [viewCalendarDay setFrame:CGRectMake(0,0,calendarView.frame.size.width,calendarView.frame.size.height)];
    [viewCalendarDay setProtocol:self];
    [viewCalendarDay setDictEvents:dictEvents];
    [calendarView addSubview:viewCalendarDay];
    
}


#pragma mark - Button Action

- (IBAction)buttonTodayAction:(id)sender {
    
    [[FFDateManager sharedManager] setCurrentDate:[NSDate dateWithYear:[NSDate componentsOfCurrentDate].year
                                                                 month:[NSDate componentsOfCurrentDate].month
                                                                   day:[NSDate componentsOfCurrentDate].day]];
}

#pragma mark - Interface Rotation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [viewCalendarYear invalidateLayout];
    [viewCalendarMonth invalidateLayout];
    [viewCalendarWeek invalidateLayout];
    [viewCalendarDay invalidateLayout];
}

#pragma mark - FFButtonAddEventWithPopover Protocol

- (void)addNewEvent:(EventRecord *)eventNew {
    
    NSMutableArray *arrayNew = [dictEvents objectForKey:eventNew.dateDay];
    if (!arrayNew) {
        arrayNew = [NSMutableArray new];
        [dictEvents setObject:arrayNew forKey:eventNew.dateDay];
    }
    [arrayNew addObject:eventNew];
    
    [self setNewDictionary:dictEvents];
}

#pragma mark - FFMonthCalendarView, FFWeekCalendarView and FFDayCalendarView Protocols

- (void)setNewDictionary:(NSDictionary *)dict {
    
    dictEvents = (NSMutableDictionary *)dict;
    
    [viewCalendarMonth setDictEvents:dictEvents];
    [viewCalendarWeek setDictEvents:dictEvents];
    [viewCalendarDay setDictEvents:dictEvents];
    
    [self arrayUpdatedWithAllEvents];
}

#pragma mark - Sending Updated Array to FFCalendarViewController Protocol

- (void)arrayUpdatedWithAllEvents {
    
    NSMutableArray *arrayNew = [NSMutableArray new];
    
    NSArray *arrayKeys = dictEvents.allKeys;
    for (NSDate *date in arrayKeys) {
        NSArray *arrayOfDate = [dictEvents objectForKey:date];
        for (EventRecord *event in arrayOfDate) {
            [arrayNew addObject:event];
        }
    }
    
    if (protocol != nil && [protocol respondsToSelector:@selector(arrayUpdatedWithAllEvents:)]) {
        [protocol arrayUpdatedWithAllEvents:arrayNew];
    }
}

- (NSMutableArray *)arrayWithEvents {
    
    NSMutableArray *allCompetitionArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *temp in self.AllEventDetailListArray) {
        ///STARTDATETIME  START
        NSString *dateString = [temp valueForKey:@"startdatetime"];
        NSString *res= [self changeformate_string24hr:dateString];
        
        NSArray *components = [res componentsSeparatedByString:@" "];
        NSString *datee = components[0];
        NSString *timee = components[1];
        
        NSArray *componentsSTART = [timee componentsSeparatedByString:@":"];
        NSString *STARThrs = componentsSTART[0];
        NSString *STARTmnts = componentsSTART[1];
        
        //date
//        NSString *dddd=@"7-11-2017";
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        [arr addObject:dddd];
//        [arr replaceObjectAtIndex:0 withObject:datee];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString1 = [dateFormatter1 dateFromString:datee];
        self.reqDate = [dateFromString1 copy];
//        NSDate *dateFromString1 = [dateFormatter1 dateFromString:datee];
//        self.reqDate = [dateFromString1 copy];

        //time
        
        NSString *tH=@"15";
        NSMutableArray *arr1 = [[NSMutableArray alloc]init];
        [arr1 addObject:tH];
        [arr1 replaceObjectAtIndex:0 withObject:STARThrs];
        int startH = [[arr1 objectAtIndex:0] intValue];
        
        NSString *tM=@"15";
        NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        [arr2 addObject:tM];
        [arr2 replaceObjectAtIndex:0 withObject:STARTmnts];
        int startM = [[arr2 objectAtIndex:0] intValue];
        
        NSString *dateString1 = [temp valueForKey:@"enddatetime"];
        NSString *res1= [self changeformate_string24hr:dateString1];
        
        NSArray *components1 = [res1 componentsSeparatedByString:@" "];
        NSString *datee1 = components1[0];
        NSString *timee1 = components1[1];
        
        NSArray *componentsEND = [timee1 componentsSeparatedByString:@":"];
        NSString *ENDhrs = componentsEND[0];
        NSString *ENDmnts = componentsEND[1];
        
        //time
        
        NSString *tH1=@"15";
        NSMutableArray *ar = [[NSMutableArray alloc]init];
        [ar addObject:tH1];
        [ar replaceObjectAtIndex:0 withObject:ENDhrs];
        int endH = [[ar objectAtIndex:0] intValue];
        
        NSString *tM1=@"15";
        NSMutableArray *ar1 = [[NSMutableArray alloc]init];
        [ar1 addObject:tM1];
        [ar1 replaceObjectAtIndex:0 withObject:ENDmnts];
        int endM = [[ar1 objectAtIndex:0] intValue];
        
        EventRecord * objRecord    = [[EventRecord alloc]init];
        objRecord.numCustomerID    = @1;
        objRecord.stringCustomerName  = [temp valueForKey:@"title"];
        objRecord.dateDay          = self.reqDate;
        objRecord.dateTimeBegin  = [NSDate dateWithHour:startH min:startM];
        objRecord.dateTimeEnd         = [NSDate dateWithHour:endH min:endM];
        objRecord.color         = [temp valueForKey:@"backgroundColor"];
        
        [allCompetitionArray addObject:objRecord];
        
    }

    
    return allCompetitionArray;
}

-(NSString *)changeformate_string24hr:(NSString *)date
{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    [df setDateFormat:@"dd/MM/yyyy hh:mm a"];
    
    NSDate* wakeTime = [df dateFromString:date];
    
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    
    return [df stringFromDate:wakeTime];
    
}

-(IBAction)MenuBtnAction:(id)sender
{
  // [COMMON ShowsideMenuView];
}
-(void)didSelectEventOfCell:(NSDate *)selectedDate
{
    NSLog(@"FINAL DATE %@",selectedDate);
  // if([AppCommon isCoach])
   //{
    if(![selectedDate isEqual:[NSNull null]])
    {
        
        //selected date
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
        NSLog(@"%ld ",[components day]);
       
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
       
        NSString * selectdate1 =[NSString stringWithFormat:@"%02ld/%02ld/%ld",(long)[components day],(long)[components month],(long)[components year]];
        NSDate *datess = [dateFormatter dateFromString:selectdate1];
        
        
        
        //today
        NSDate *today = [NSDate date];
        
        NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd/MM/yyyy"];
        
        NSString * selectdate2 =[NSString stringWithFormat:@"%02ld/%02ld/%ld",(long)[components1 day],(long)[components1 month],(long)[components1 year]];
       
    
    
    if([selectdate2 isEqualToString:selectdate1])
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
        NSLog(@"%ld ",[components day]);
        
        NSString * selectdate =[NSString stringWithFormat:@"%02ld/%02ld/%ld",(long)[components day],(long)[components month],(long)[components year]];
        
        //NSString *finalDate = @"2017-10-15";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        //NSDate *datess = [dateFormatter dateFromString:selectdate];
        
        //    NSString * selectdate1 =[NSString stringWithFormat:@"%02d/%02d/%d",day+1,month,year];
        NSString * selectdate1 =[NSString stringWithFormat:@"%02ld/%02ld/%ld",(long)[components day]+1,(long)[components month],(long)[components year]];
        
        NSDate *datess = [dateFormatter dateFromString:selectdate1];
        
        NSDate *today = [NSDate date]; // it will give you current date
        
        NSMutableArray * ojAddPlannerArray =[[NSMutableArray alloc]init];
        for(int i=0; self.AllEventDetailListArray.count>i;i++)
        {
            NSDictionary * objDic =[self.AllEventDetailListArray objectAtIndex:i];
            NSString * startdate =[objDic valueForKey:@"startdatetime"];
            NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
            [dateFormatters setDateFormat:@"dd/MM/yyyy hh:mm a"];
            NSDate *dates = [dateFormatters dateFromString:startdate];
            
            NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
            [dfs setDateFormat:@"dd/MM/yyyy"];
            NSString * endDateStr = [dfs stringFromDate:dates];
            
            if([endDateStr isEqualToString:selectdate])
            {
                [ojAddPlannerArray addObject:objDic];
            }
        }
        
        NSComparisonResult result;
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        
        result = [today compare:datess]; // comparing two dates
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"today is less");
            
            if(ojAddPlannerArray.count>0)
            {
                PlannerListVC  * objPlannerlist=[[PlannerListVC alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                objPlannerlist = (PlannerListVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlannerList"];
                objPlannerlist.objPlannerArray =ojAddPlannerArray;
                [self.navigationController pushViewController:objPlannerlist animated:YES];
                
                
                //           PlannerListVC *objPlannerlist = [[PlannerListVC alloc] initWithNibName:@"PlannerListVC" bundle:nil];
                //            objPlannerlist.objPlannerArray =ojAddPlannerArray;
                //            objPlannerlist.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
                //            [self.view addSubview:objPlannerlist.view];
            }
            
            else
            {
                // if([AppCommon isCoach])
                //{
                PlannerAddEvent  * objaddEvent=[[PlannerAddEvent alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                objaddEvent = (PlannerAddEvent *)[storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
                objaddEvent.selectDateStr =selectdate;
                objaddEvent.isEdit =NO;
                objaddEvent.ListeventTypeArray = [self.PlannerResponseArray valueForKey:@"ListEventTypeDetails"];
                objaddEvent.ListeventStatusArray = [self.PlannerResponseArray valueForKey:@"ListEventStatusDetails"];
                objaddEvent.ListparticipantTypeArray = [self.PlannerResponseArray valueForKey:@"ListParticipantsTypeDetails"];
                
                [self.navigationController pushViewController:objaddEvent animated:YES];
                //}
                
                //            PlannerAddEvent *objaddEvent = [[PlannerAddEvent alloc] initWithNibName:@"PlannerAddEvent" bundle:nil];
                //            objaddEvent.selectDateStr =selectdate;
                //            objaddEvent.isEdit =NO;
                //            objaddEvent.ListeventTypeArray = [self.PlannerResponseArray valueForKey:@"ListEventTypeDetails"];
                //            objaddEvent.ListeventStatusArray = [self.PlannerResponseArray valueForKey:@"ListEventStatusDetails"];
                //            objaddEvent.ListparticipantTypeArray = [self.PlannerResponseArray valueForKey:@"ListParticipantsTypeDetails"];
                //            objaddEvent.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
                //            [self.view addSubview:objaddEvent.view];
            }
        }
        else if(result==NSOrderedDescending)
        {
            if(ojAddPlannerArray.count>0)
            {
                PlannerListVC  * objPlannerlist=[[PlannerListVC alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                objPlannerlist = (PlannerListVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlannerList"];
                objPlannerlist.objPlannerArray =ojAddPlannerArray;
                [self.navigationController pushViewController:objPlannerlist animated:YES];
            }
            else{
                
                [AppCommon showAlertWithMessage:@"Past date not allowed!!"];
            }
        }
        else
            NSLog(@"Both dates are same");
    }
   else
    {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
    NSLog(@"%ld ",[components day]);
    
    NSString * selectdate =[NSString stringWithFormat:@"%02ld/%02ld/%ld",(long)[components day],(long)[components month],(long)[components year]];
    
    //NSString *finalDate = @"2017-10-15";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    //NSDate *datess = [dateFormatter dateFromString:selectdate];
    
//    NSString * selectdate1 =[NSString stringWithFormat:@"%02d/%02d/%d",day+1,month,year];
    NSString * selectdate1 =[NSString stringWithFormat:@"%02ld/%02ld/%ld",(long)[components day],(long)[components month],(long)[components year]];

    NSDate *datess = [dateFormatter dateFromString:selectdate1];
       
    NSDate *today = [NSDate date]; // it will give you current date
    
    NSMutableArray * ojAddPlannerArray =[[NSMutableArray alloc]init];
    for(int i=0; self.AllEventDetailListArray.count>i;i++)
    {
        NSDictionary * objDic =[self.AllEventDetailListArray objectAtIndex:i];
        NSString * startdate =[objDic valueForKey:@"startdatetime"];
        NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
        [dateFormatters setDateFormat:@"dd/MM/yyyy hh:mm a"];
        NSDate *dates = [dateFormatters dateFromString:startdate];
        
        NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
        [dfs setDateFormat:@"dd/MM/yyyy"];
        NSString * endDateStr = [dfs stringFromDate:dates];
        
        if([endDateStr isEqualToString:selectdate])
        {
            [ojAddPlannerArray addObject:objDic];
        }
    }
        
        NSComparisonResult result;
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        
        result = [today compare:datess]; // comparing two dates
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"today is less");
            
            if(ojAddPlannerArray.count>0)
            {
                PlannerListVC  * objPlannerlist=[[PlannerListVC alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                objPlannerlist = (PlannerListVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlannerList"];
                objPlannerlist.objPlannerArray =ojAddPlannerArray;
                [self.navigationController pushViewController:objPlannerlist animated:YES];
                
                
                //           PlannerListVC *objPlannerlist = [[PlannerListVC alloc] initWithNibName:@"PlannerListVC" bundle:nil];
                //            objPlannerlist.objPlannerArray =ojAddPlannerArray;
                //            objPlannerlist.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
                //            [self.view addSubview:objPlannerlist.view];
            }
            
            else
            {
                // if([AppCommon isCoach])
                //{
                PlannerAddEvent  * objaddEvent=[[PlannerAddEvent alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                objaddEvent = (PlannerAddEvent *)[storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
                objaddEvent.selectDateStr =selectdate;
                objaddEvent.isEdit =NO;
                objaddEvent.ListeventTypeArray = [self.PlannerResponseArray valueForKey:@"ListEventTypeDetails"];
                objaddEvent.ListeventStatusArray = [self.PlannerResponseArray valueForKey:@"ListEventStatusDetails"];
                objaddEvent.ListparticipantTypeArray = [self.PlannerResponseArray valueForKey:@"ListParticipantsTypeDetails"];
                
                [self.navigationController pushViewController:objaddEvent animated:YES];
                //}
                
                //            PlannerAddEvent *objaddEvent = [[PlannerAddEvent alloc] initWithNibName:@"PlannerAddEvent" bundle:nil];
                //            objaddEvent.selectDateStr =selectdate;
                //            objaddEvent.isEdit =NO;
                //            objaddEvent.ListeventTypeArray = [self.PlannerResponseArray valueForKey:@"ListEventTypeDetails"];
                //            objaddEvent.ListeventStatusArray = [self.PlannerResponseArray valueForKey:@"ListEventStatusDetails"];
                //            objaddEvent.ListparticipantTypeArray = [self.PlannerResponseArray valueForKey:@"ListParticipantsTypeDetails"];
                //            objaddEvent.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
                //            [self.view addSubview:objaddEvent.view];
            }
        }
        else if(result==NSOrderedDescending)
        {
            if(ojAddPlannerArray.count>0)
            {
                PlannerListVC  * objPlannerlist=[[PlannerListVC alloc]init];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                objPlannerlist = (PlannerListVC *)[storyboard instantiateViewControllerWithIdentifier:@"PlannerList"];
                objPlannerlist.objPlannerArray =ojAddPlannerArray;
                [self.navigationController pushViewController:objPlannerlist animated:YES];
            }
            else{
                
                [AppCommon showAlertWithMessage:@"Past date not allowed!!"];
            }
        }
        else
            NSLog(@"Both dates are same");
    }
    }
  // }
    
}

///yes

-(IBAction)closeView:(id)sender
{
//    self.eventTbl.hidden =YES;
    [tapview setHidden:YES];
    isEvent =NO;
    [self tblShowHideAnimation];

}

@end
