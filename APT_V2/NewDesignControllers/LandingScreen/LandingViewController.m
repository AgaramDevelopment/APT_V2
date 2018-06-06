//
//  LandingViewController.m
//  APT_V2
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "LandingViewController.h"
#import "Config.h"
#import "LandingTableViewCell.h"
#import "AppCommon.h"
#import "ScheduleCell.h"
#import "ResultCell.h"
#import "FoodDiaryCell.h"
#import "TeamCollectionViewCell.h"
#import "CustomNavigation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WellnessTrainingBowlingVC.h"

typedef enum : NSUInteger {
    Events,
    Teams,
    Fixtures,
    Results,
    Foods
} CollectionTitle;

@interface LandingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray* SectionNameArray;
    NSMutableArray* ResponseArray;
    NSMutableDictionary* TableListDict;
    LandingTableViewCell *cell;
    CustomNavigation * objCustomNavigation;
    NSMutableArray *notificationArray;
    NSTimer* myTimer;
    WellnessTrainingBowlingVC* WTB_object;
}

@end

@implementation LandingViewController

@synthesize LandingTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [cell.collection registerNib:[UINib nibWithNibName:@"collection" bundle:nil] forCellWithReuseIdentifier:@"collection"];
//    [cell.collection registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
//    [cell.collection registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    WTB_object = [WellnessTrainingBowlingVC new];
    SectionNameArray = @[@{@"Title":@"Events"},
                         @{@"Title":@"Teams"},
                         @{@"Title":@"Fixtures"},
                         @{@"Title":@"Results"},
                         @{@"Title":@"Videos"},
                         @{@"Title":@"Documents"}];
    
    
    NSArray* arr = @[@{@"Title":@"Events"},
                     @{@"Title":@"wellness"},
                     @{@"Title":@"Training Load"},
                     @{@"Title":@"Food"},
                     @{@"Title":@"Bowling Graph"},
                     @{@"Title":@"Fixtures"},
                     @{@"Title":@"Results"},
                     @{@"Title":@"Videos"},
                     @{@"Title":@"Documents"}];
    
    
    
    ResponseArray = [NSMutableArray new];
    TableListDict = [NSMutableDictionary new];
    
    if (![AppCommon isCoach]) {
        SectionNameArray = arr;
    }
    
    [TableListDict setValue:@[] forKey:@"Events"];
    [TableListDict setValue:@[] forKey:@"Teams"];
    [TableListDict setValue:@[] forKey:@"Fixtures"];
    [TableListDict setValue:@[] forKey:@"Results"];
    [TableListDict setValue:@[] forKey:@"Food"];

    [self customnavigationmethod];
    [self EventsAndResultsWebservice];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationCount) name:@"updateNotificationCount" object:nil];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateNotificationCount) userInfo:nil repeats:YES];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getNotificationsPostService];
    if (!appDel.MainArray.count) {
        [COMMON getIPLteams];
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //    [self.view addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
    //UIView* view= self.navigation_view.subviews.firstObject;
    [self.navView addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden =YES;
    objCustomNavigation.menu_btn.hidden =NO;
    //        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //        [objCustomNavigation.home_btn addTarget:self action:@selector(HomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //Notification Method
    
    
    [objCustomNavigation.notificationView setHidden:![AppCommon isKXIP]];
    
    [objCustomNavigation.notificationBtn addTarget:self action:@selector(didClickNotificationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateNotificationCount
{
    NSLog(@"updateNotificationCount method called");
    [self getNotificationsPostService];
    
}

-(void)getNotificationsPostService
{
    /*
     API URL    :   http://192.168.0.154:8029/AGAPTService.svc/APT_GETNOTIFICATIONS
     METHOD     :   POST
     PARAMETER  :   {Clientcode}/{ParticipantCode}
     */
    /*
     {
     "Clientcode" : "CLI0000002",
     "ParticipantCode" : "AMR0000031"
     }
     
     */
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString *userRefcode = [AppCommon GetuserReference];
    
    
    if(![COMMON isInternetReachable])
        return;
    
    NSString *URLString =  URL_FOR_RESOURCE(GetNotifications);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
    if(userRefcode)   [dic    setObject:userRefcode     forKey:@"ParticipantCode"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            notificationArray = [NSMutableArray new];
            notificationArray = [responseObject valueForKey:@"NotificationsList"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                objCustomNavigation.notificationCountLbl.text = [self checkNSNumber:[responseObject valueForKey:@"count"]];
                NSNumber* number = [NSNumber numberWithInt:[objCustomNavigation.notificationCountLbl.text intValue]];
                [[NSUserDefaults standardUserDefaults] setValue:number forKey:@"badgeCount"];
                
                if(notificationArray.count > 0){
                    
                    NSMutableArray* oldCount = [[NSUserDefaults standardUserDefaults] arrayForKey:@"NotificationArray"];
                    if (notificationArray.count > oldCount.count || (notificationArray.count == 1 && oldCount.count == 0)) {
                        
                        [appDel scheduleLocalNotifications:notificationArray];
                        [[NSUserDefaults standardUserDefaults] setValue:notificationArray forKey:@"NotificationArray"];
                        
                    }
                    
                }
                else
                {
                    NSLog(@"NO NEW DATA");
                    [[NSUserDefaults standardUserDefaults] setValue:notificationArray forKey:@"NotificationArray"];
                    
                }
                
            });
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed %@",error.description);
        //        [COMMON webServiceFailureError:error];
        
    }];
}


#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return TableListDict.count > 0 ?  SectionNameArray.count : 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return IS_IPAD ? 50 : 44;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *cellIdentifier = @"Header";
    LandingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"LandingTableViewCell" owner:self options:nil];
    if (cell == nil)
    {
        cell = array[0];
    }
    
    cell.lblSectionTitle.text = [[SectionNameArray objectAtIndex:section] valueForKey:@"Title"];
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  IS_IPAD ? 250 : 150;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    LandingTableViewCell* Tablecell = (LandingTableViewCell *)cell;
    NSString* title = [[SectionNameArray objectAtIndex:indexPath.section] valueForKey:@"Title"];
    
    if ([title isEqualToString:@"Events"]) {
        [Tablecell configureCell:self andIndex:1 andTitile:title];
    }
    else if ([title isEqualToString:@"Teams"]) {
        [Tablecell configureCell:self andIndex:2 andTitile:title];
    }
    else if ([title isEqualToString:@"Fixtures"]) {
        [Tablecell configureCell:self andIndex:3 andTitile:title];
    }
    else if ([title isEqualToString:@"Results"]) {
        [Tablecell configureCell:self andIndex:4 andTitile:title];
    }
    else if ([title isEqualToString:@"Food"]) {
        [Tablecell configureCell:self andIndex:5 andTitile:title];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"LandingTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"LandingTableViewCell" owner:self options:nil];
    
    if(cell == nil)
    {
        cell = array[1];
    }
    
    NSString* title = [[SectionNameArray objectAtIndex:indexPath.section] valueForKey:@"Title"];
    
    if ([title isEqualToString:@"Wellness"]){
        [cell.customView addSubview:WTB_object.topView];
        
    
        [cell.collection setHidden:YES];
        [cell.customView setBackgroundColor:[UIColor orangeColor]];
    }
    else if ([title isEqualToString:@"Wellness"]){
        
        [cell.collection setHidden:YES];
        [cell.customView setBackgroundColor:[UIColor orangeColor]];

    }
    else if([title isEqualToString:@"Bowling Graph"])
    {
        
        [cell.collection setHidden:YES];
        [cell.customView setBackgroundColor:[UIColor orangeColor]];

    }
    else
    {
        [cell.customView setBackgroundColor:[UIColor clearColor]];
        [cell.collection setHidden:NO];
    }
    
    return cell;
}

#pragma mark - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = collectionView.frame.size.width;
    CGFloat height = collectionView.frame.size.height;
    
    if(!IS_IPAD && !IS_IPHONE5)
    {
        width = width/2;
    }
    else if(IS_IPAD)
    {
        width = width/3;
    }
    
    return CGSizeMake(width-20, height-20);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 10.0;
    
}


#pragma mark - UICollectionView view DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSLog(@"collectionView.tag %ld",(long)collectionView.tag);
    
    
    if (collectionView.tag == 1) {
        return  [[TableListDict valueForKey:@"Events"] count];
    }
    else if (collectionView.tag == 2){
        return [[TableListDict valueForKey:@"Teams"] count];
    }
    else if (collectionView.tag == 3){
        return  [[TableListDict valueForKey:@"Fixtures"] count];
    }
    else if (collectionView.tag == 4){
        return  [[TableListDict valueForKey:@"Results"] count];
    }
    else if (collectionView.tag == 5){
        return  [[TableListDict valueForKey:@"Food"] count];
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 1) { // Events

        ScheduleCell* cell = (ScheduleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//        cell.eventNamelbl.text = @"ScheduleCell";
        
        [self setupEventCell:cell andINdex:indexPath];
        
        return  cell;
    }
    else if (collectionView.tag == 2){ // Teams

        TeamCollectionViewCell* cell = (TeamCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TeamCollectionViewCell" forIndexPath:indexPath];
//        cell.lblTeamName.text = @"TeamsCell";
        
        NSArray* teamlist = [TableListDict valueForKey:@"Teams"];
        
        NSString * imgStr1 = [[teamlist valueForKey:@"TeamPhotoLink"] objectAtIndex:indexPath.row];
        
        [cell.imgTeam sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];

        
        return cell;

    }
    else if (collectionView.tag == 3){ // Fixtures

        ResultCell* cell = (ResultCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
        cell.resultlbl.text = @"FixturesCell";
        
        NSArray* FixturesArray =  [TableListDict valueForKey:@"Fixtures"];
        
        NSLog(@"DATE FORMAT %@ ",[[FixturesArray valueForKey:@"date"] objectAtIndex:indexPath.row]);
        cell.datelbl.text = [[FixturesArray valueForKey:@"date"] objectAtIndex:indexPath.row];
        // cell.resultlbl.text = [[objarray valueForKey:@"time"] objectAtIndex:indexPath.row];
        cell.resultlbl.text = [[FixturesArray valueForKey:@"ground"] objectAtIndex:indexPath.row];
        cell.FirstInnScorelbl.text = [[FixturesArray valueForKey:@"team1"] objectAtIndex:indexPath.row];
        cell.SecondInnScorelbl.text = [[FixturesArray valueForKey:@"team2"] objectAtIndex:indexPath.row];
        cell.competitionNamelbl.text = [[FixturesArray valueForKey:@"CompetitionName"] objectAtIndex:indexPath.row];
        
        cell.teamAlogo.image = [UIImage imageNamed:@"no-image"];
        cell.teamBlogo.image = [UIImage imageNamed:@"no-image"];
        
        NSString * imgStr1 = ([[FixturesArray objectAtIndex:indexPath.row] valueForKey:@"team1Img"]==[NSNull null])?@"":[[FixturesArray objectAtIndex:indexPath.row] valueForKey:@"team1Img"];
        
        NSString * imgStr2 = ([[FixturesArray objectAtIndex:indexPath.row] valueForKey:@"team2Img"]==[NSNull null])?@"":[[FixturesArray objectAtIndex:indexPath.row] valueForKey:@"team2Img"];
        [cell.teamAlogo sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
        [cell.teamBlogo sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        return cell;
    }
    else if (collectionView.tag == 4){ // Results

        ResultCell* cell = (ResultCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
        cell.resultlbl.text = @"ResultCell";
        
        [self setUpResultCell:cell andINdex:indexPath];
        
        
        return cell;

    }
    else if (collectionView.tag == 5){ // Food
        
        FoodDiaryCell *cell = (FoodDiaryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
//        cell.mealNameLbl.text = @"Foodcell";
        [self setupFoodCell:cell andIndex:indexPath];
        
        
        return cell;

    }

    
    return  nil;
}

-(void)setupEventCell:(ScheduleCell *)cell andINdex:(NSIndexPath *)indexPath{
    
    NSArray* commonArray = [TableListDict valueForKey:@"Events"];
    
    cell.eventNamelbl.text = [[commonArray valueForKey:@"EventName"] objectAtIndex:indexPath.row];
    
    cell.eventTypelbl.text = [[commonArray valueForKey:@"EventTypeDesc"] objectAtIndex:indexPath.row];
    NSArray *arr = [cell.eventTypelbl.text componentsSeparatedByString:@""];
    
    unichar firstChar = [[cell.eventTypelbl.text uppercaseString] characterAtIndex:0];
    unichar secondChar = [[cell.eventTypelbl.text uppercaseString] characterAtIndex:1];
    unichar thirdChar = [[cell.eventTypelbl.text uppercaseString] characterAtIndex:2];
    unichar fourthChar = [[cell.eventTypelbl.text uppercaseString] characterAtIndex:3];
    //cell.eventTypeLetterlbl.text = [NSString stringWithFormat:@"%c",firstChar];
    
    if( [[NSString stringWithFormat:@"%c",firstChar] isEqualToString:@"M"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Match_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c",firstChar,secondChar] isEqualToString:@"PR"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Practice_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c",firstChar,secondChar] isEqualToString:@"PH"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Physio_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c%c%c",firstChar,secondChar,thirdChar,fourthChar] isEqualToString:@"TRAV"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Travel_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c%c%c",firstChar,secondChar,thirdChar,fourthChar] isEqualToString:@"TRAI"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Training_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c",firstChar,secondChar] isEqualToString:@"TE"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Team_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c",firstChar] isEqualToString:@"C"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Competition_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c",firstChar] isEqualToString:@"O"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Others_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c",firstChar] isEqualToString:@"F"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Fitness_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c",firstChar] isEqualToString:@"N"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Net_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c",firstChar,secondChar] isEqualToString:@"ST"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Strength_Icon"];
    }
    else if( [[NSString stringWithFormat:@"%c%c",firstChar,secondChar] isEqualToString:@"SE"])
    {
        cell.ImgEvent.image = [UIImage imageNamed:@"Season_Icon"];
    }
    
    
    
    NSString *starttime = [[commonArray valueForKey:@"EventStartTime"] objectAtIndex:indexPath.row];
    NSString *endtime = [[commonArray valueForKey:@"EventEndTime"] objectAtIndex:indexPath.row];
    cell.venuelbl.text = [[commonArray valueForKey:@"EventVenue"] objectAtIndex:indexPath.row];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date  = [dateFormatter dateFromString:starttime];
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *newtime1 = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    NSDate *date2  = [dateFormatter2 dateFromString:endtime];
    // Convert to new Date Format
    [dateFormatter2 setDateFormat:@"hh:mm a"];
    NSString *newtime2 = [dateFormatter2 stringFromDate:date2];
    
    cell.timelbl.text = [NSString stringWithFormat:@"%@ to %@",newtime1,newtime2];
    
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
    cell.layer.shadowOffset = CGSizeZero;
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;

}

-(void)setUpResultCell:(ResultCell *)cell andINdex:(NSIndexPath *)indexPath {
    
    NSArray* resultArray = [TableListDict valueForKey:@"Results"];

    cell.competitionNamelbl.text = [[resultArray valueForKey:@"COMPETITIONNAME"]objectAtIndex:indexPath.row];
    
    NSString *curdate = [[resultArray valueForKey:@"DateTime"]objectAtIndex:indexPath.row];
    NSArray *arr = [curdate componentsSeparatedByString:@" "];
    
    cell.datelbl.text = [NSString stringWithFormat:@"%@ %@",arr[0],arr[1]];
    cell.resultlbl.text = [[resultArray valueForKey:@"MATCHRESULTORRUNSREQURED"]objectAtIndex:indexPath.row];
    
    cell.teamAlbl.text = [[resultArray valueForKey:@"TeamA"]objectAtIndex:indexPath.row];
    cell.teamBlbl.text = [[resultArray valueForKey:@"TeamB"]objectAtIndex:indexPath.row];
    
    NSString *first = [self checkNull:[[resultArray valueForKey:@"FIRSTINNINGSSCORE"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    if( [first isEqualToString:@"0 /0 (0.0 Ov)"])
    {
        cell.FirstInnScorelbl.text = @"";
    }
    else
    {
        cell.FirstInnScorelbl.text = first;
    }
    
    
    NSString *second = [self checkNull:[[resultArray valueForKey:@"SECONDINNINGSSCORE"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    
    if( [second isEqualToString:@"0 /0 (0.0 Ov)"])
    {
        cell.SecondInnScorelbl.text = @"";
    }
    else
    {
        cell.SecondInnScorelbl.text = second;
    }
    
    
    NSString *third = [self checkNull:[[resultArray valueForKey:@"THIRDINNINGSSCORE"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    
    if( [third isEqualToString:@"0 /0 (0.0 Ov)"])
    {
        cell.ThirdInnScorelbl.text = @"";
    }
    else
    {
        cell.ThirdInnScorelbl.text = third;
    }
    
    
    
    NSString *fourth = [self checkNull:[[resultArray valueForKey:@"FOURTHINNINGSSCORE"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    
    if( [fourth isEqualToString:@"0 /0 (0.0 Ov)"])
    {
        cell.FouthInnScorelbl.text = @"";
    }
    else
    {
        cell.FouthInnScorelbl.text = fourth;
    }
    
    
    
    
    NSString * imgStr1 = ([[resultArray objectAtIndex:indexPath.row] valueForKey:@"TeamALogo"]==[NSNull null])?@"":[[resultArray objectAtIndex:indexPath.row] valueForKey:@"TeamALogo"];
    
    NSString * imgStr2 = ([[resultArray objectAtIndex:indexPath.row] valueForKey:@"TeamBLogo"]==[NSNull null])?@"":[[resultArray objectAtIndex:indexPath.row] valueForKey:@"TeamBLogo"];
    [cell.teamAlogo sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
    [cell.teamBlogo sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:[UIImage imageNamed:@"no-image"]];
    
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
    cell.layer.shadowOffset = CGSizeZero;
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;

}

-(void)setupFoodCell:(FoodDiaryCell *)cell andIndex:(NSIndexPath *)indexPath{
    
    NSMutableArray *foodDiaryArray = [TableListDict valueForKey:@"Food"];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 3;
    cell.layer.shadowOpacity = 0.8f;
    
        NSMutableArray *foodListArray = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"FOODLIST"];
        
        cell.timeLbl.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"STARTTIME"];
        cell.mealNameLbl.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"MEALNAME"];
        
        if (foodListArray.count == 1) {
            cell.food1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
            cell.food2Lbl.text = @"";
            cell.food3Lbl.text = @"";
        } else if (foodListArray.count == 2) {
            cell.food1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
            cell.food2Lbl.text = [[foodListArray objectAtIndex:1] valueForKey:@"FOOD"];
            cell.food3Lbl.text = @"";
        } else {
            cell.food1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
            cell.food2Lbl.text = [[foodListArray objectAtIndex:1] valueForKey:@"FOOD"];
            cell.food3Lbl.text = [[foodListArray objectAtIndex:2] valueForKey:@"FOOD"];
        }
        

}

#pragma mark- Webservice


-(void)EventsAndResultsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
    
    
        [AppCommon showLoading];
        
        NSString *URLString =  URL_FOR_RESOURCE(ScheduleKey);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
        NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"ClientCode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"UserrefCode"];
        if(playerCode)   [dic    setObject:playerCode     forKey:@"PlayerCode"];
        [dic    setObject:[AppCommon getAppVersion]     forKey:@"version"];
        [dic    setObject:@"ios"     forKey:@"platform"];
        
        NSLog(@"ScheduleKey URL : %@",URLString);
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
//                NSMutableArray *scheduleArray = [responseObject valueForKey:@"EventDetails"];
//                NSMutableArray *resultArray = [responseObject valueForKey:@"ResultsValues"];
                
//                self.commonArray = [[NSMutableArray alloc]init];
//                self.commonArray2 = [[NSMutableArray alloc]init];
                
                if ([responseObject valueForKey:@"EventDetails"] != nil) {
                    [TableListDict setValue:[responseObject valueForKey:@"EventDetails"] forKey:@"Events"];
                }
                
                if ([responseObject valueForKey:@"ResultsValues"] != nil) {
                    [TableListDict setValue:[responseObject valueForKey:@"ResultsValues"] forKey:@"Results"];
                }

                
//                self.commonArray = scheduleArray;
//                self.commonArray2 = resultArray;
                
//                [self.eventsCollectionView reloadData];
//                [self.resultCollectionView reloadData];
//
//                BOOL iftheyClickedLater = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLater"];
                
//                if (!iftheyClickedLater) { // New version update alert if they click later, we dont show that alert again and again
//
//                    NSInteger* isLatestVersion = [[responseObject valueForKey:@"isLatestVersion"] integerValue];
//                    NSLog(@"isLatestVersion %@",[responseObject valueForKey:@"isLatestVersion"] );
//                    if (!isLatestVersion) {
//                        NSLog(@"canUpdate TRUE ");
//                        [AppCommon newVersionUpdateAlert];
//                    }
//
//                }
                
                
            }
            
            
            
            [AppCommon hideLoading];
            [self FixturesWebservice];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
        }];
    
}


-(void)FixturesWebservice
{
    if(![COMMON isInternetReachable])
        return;
    
        NSString *URLString =  URL_FOR_RESOURCE(FixturesKey);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        //        NSString *competition = @"";
        //        NSString *teamcode = [AppCommon getCurrentTeamCode];
        
        NSString *teamcode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"CAPTeamcode"];
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        //        if(competition)   [dic    setObject:competition     forKey:@"Competitioncode"];
        if(teamcode)   [dic    setObject:teamcode     forKey:@"TeamCode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSMutableArray *objarray = [[NSMutableArray alloc]init];
                NSMutableArray * fixArr = [[NSMutableArray alloc]init];
                fixArr = [responseObject valueForKey:@"lstFixturesGridValues"];
                
                if([[responseObject valueForKey:@"lstFixturesGridValues"] count])
                {
                    //self.competitionLbl.text = [[fixArr valueForKey:@"COMPETITIONNAME"] objectAtIndex:0];
                    
                    NSMutableArray * sepArray = [[NSMutableArray alloc]init];
                    
                    for(int i=0;i<fixArr.count;i++)
                    {
                        sepArray = [fixArr objectAtIndex:i];
                        NSString *dttime = [sepArray valueForKey:@"DateTime"];
                        
                        NSArray *components = [dttime componentsSeparatedByString:@" "];
                        NSString *day = components[0];
                        NSString *monthyear = components[1];
                        NSString *time = components[2];
                        NSString *local = components[3];
                        
                        NSString *realdate = [NSString stringWithFormat:@"%@ %@",day,monthyear];
                        NSString *realtime = [NSString stringWithFormat:@"%@ %@",time,local];
                        
                        NSString *ground = [sepArray valueForKey:@"Ground"];
                        NSString *place = [sepArray valueForKey:@"GroundCode"];
                        NSString *realGroundname = [NSString stringWithFormat:@"%@,%@",ground,place];
                        
                        NSString *team1 = [sepArray valueForKey:@"TeamA"];
                        NSString *team2 = [sepArray valueForKey:@"TeamB"];
                        NSString *team1Image = [sepArray valueForKey:@"TeamALogo"];
                        NSString *team2Image = [sepArray valueForKey:@"TeamBLogo"];
                        NSString *CompetitionName = [sepArray valueForKey:@"COMPETITIONNAME"];
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                        
                        NSLog(@"SET DATE FORMAT %@ ",realdate);
                        [dic setValue:realdate forKey:@"date"];
                        [dic setValue:realtime forKey:@"time"];
                        [dic setValue:realGroundname forKey:@"ground"];
                        // [dic setValue:realdate forKey:@"date"];
                        [dic setValue:team1 forKey:@"team1"];
                        [dic setValue:team2 forKey:@"team2"];
                        [dic setValue:team1Image forKey:@"team1Img"];
                        [dic setValue:team2Image forKey:@"team2Img"];
                        [dic setValue:CompetitionName forKey:@"CompetitionName"];
                        
                        [objarray addObject:dic];
                        
                    }
                    
                }
                
                if (objarray != nil) {
                    [TableListDict setValue:objarray forKey:@"Fixtures"];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.LandingTable reloadData];
                });
                
                [self TeamsWebservice];
                [AppCommon hideLoading];

            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [COMMON webServiceFailureError:error];
            NSLog(@"failed");
            [AppCommon hideLoading];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.LandingTable reloadData];
            });
            
        }];
    
}

-(void)TeamsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
    
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(TeamsKey);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
    if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"Userreferencecode"];
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            NSMutableArray* teamslist = [[NSMutableArray alloc]init];
            teamslist = responseObject;
            
            
            if (teamslist != nil) {
                [TableListDict setValue:teamslist forKey:@"Teams"];
            }

        }
        
        [AppCommon hideLoading];
        [self FoodDiaryWebservice];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [AppCommon hideLoading];
        [COMMON webServiceFailureError:error];
        
        
    }];
    
}


- (void)FoodDiaryWebservice {
    
        // Get current datetime
    NSDate *currentDateTime = [NSDate date];
    
        // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
        // Set the dateFormatter format
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
        // Get the date time in NSString
    NSString *date = [dateFormatter stringFromDate:currentDateTime];
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryFetch);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
        //CLIENTCODE, PLAYERCODE, DATE
    NSString *clientCode = [AppCommon GetClientCode];
    NSString *userRefCode = [AppCommon GetuserReference];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    [dic setObject:date forKey:@"DATE"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            
            NSMutableArray *foodDiaryArray = [NSMutableArray new];
            NSMutableArray *FOODDIARYSArray = [NSMutableArray new];
            FOODDIARYSArray = [responseObject objectForKey:@"FOODDIARYS"];
            
            if (FOODDIARYSArray.count) {
                for (id key in FOODDIARYSArray) {
                    
                    if ([[key valueForKey:@"FOODLIST"] count]) {
                        if ([date isEqualToString:[key valueForKey:@"DATE"]]) {
                            [foodDiaryArray addObject:key];
                        }
                    }
                }
            }
            
            if (foodDiaryArray.count) {
                [TableListDict setValue:foodDiaryArray forKey:@"Food"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.LandingTable reloadData];
            });
            
            NSLog(@"Count:%ld", foodDiaryArray.count);
//            [self setClearBorderForMealTypeAndLocation];
        }
        
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

//-(void)EventTypeWebservice:(NSString *) usercode :(NSString*) cliendcode:(NSString *)userreference
//{
//
//    if([COMMON isInternetReachable])
//    {
//        [AppCommon showLoading];
//
//        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",PlannerEventKey]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//        manager.requestSerializer = requestSerializer;
//
//
//
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        if(usercode)   [dic    setObject:usercode     forKey:@"CreatedBy"];
//        if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
//        if(userreference)   [dic    setObject:userreference     forKey:@"Userreferencecode"];
//
//
//        NSLog(@"parameters : %@",dic);
//        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"response ; %@",responseObject);
//
//            if(responseObject >0)
//            {
//                NSLog(@"%@",responseObject);
//                self.AllEventListArray = [[NSMutableArray alloc]init];
//
//                NSMutableArray * objAlleventArray= [responseObject valueForKey:@"ListEventTypeDetails"];
//
//
//                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//                [mutableDict setObject:@"" forKey:@"EventTypeColor"];
//                [mutableDict setObject:@"" forKey:@"EventTypeCode"];
//                [mutableDict setObject:@"All EVENT" forKey:@"EventTypename"];
//
//                [self.AllEventListArray addObject:mutableDict];
//                for(int i=0; objAlleventArray.count>i;i++)
//                {
//                    NSMutableDictionary * objDic =[objAlleventArray objectAtIndex:i];
//                    [self.AllEventListArray addObject:objDic];
//                }
//
//                self.ParticipantsTypeArray =[[NSMutableArray alloc]init];
//                self.ParticipantsTypeArray=[responseObject valueForKey:@"ListParticipantsTypeDetails"];
//
//                self.PlayerTeamArray =[[NSMutableArray alloc]init];
//                self.PlayerTeamArray =[responseObject valueForKey:@"ListPlayerTeamDetails"];
//
//                self.EventTypeArray  =[[NSMutableArray alloc]init];
//                self.EventTypeArray =[responseObject valueForKey:@"ListEventTypeDetails"];
//
//                self.EventStatusArray =[[NSMutableArray alloc]init];
//                self.EventStatusArray =[responseObject valueForKey:@"ListEventStatusDetails"];
//
//            }
//
//            [AppCommon hideLoading];
//
//
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"failed");
//            [COMMON webServiceFailureError:error];
//        }];
//    }
//
//}

- (NSString *)checkNSNumber:(id)unknownTypeParameter {
    
    NSString *str;
    if([unknownTypeParameter isKindOfClass:[NSNumber class]])
    {
        
        NSNumber *vv = unknownTypeParameter;
        str = [vv stringValue];
    }
    else
    {
        str = unknownTypeParameter;
    }
    return str;
}

-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}


@end
