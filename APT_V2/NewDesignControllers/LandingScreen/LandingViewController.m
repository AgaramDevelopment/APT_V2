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
#import "TrainingLoadVC.h"
#import "CoachBowlingLoad.h"
@import Charts;
#import "WebService.h"
#import "HorizontalXLblFormatter.h"
#import "FoodDiaryUpdateVC.h"
#import "PlannerVC.h"
#import "TabbarVC.h"
#import "VideoGalleryUploadCell.h"
#import "VideoPlayerViewController.h"
#import "NewVideoDocumentVC.h"
#import "VideoGalleryVC.h"
#import "ResultsVc.h"
#import "ScoreCardVideoPlayer.h"

typedef enum : NSUInteger {
    Events,
    Teams,
    Fixtures,
    Results,
    Food
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
    TrainingLoadVC *Training_object;
    WebService *objWebservice;
    NSMutableArray *foodDiaryArray;
    NewVideoDocumentVC *documentObject;
}

@property (nonatomic, strong)  NSMutableArray *BowlingloadXArray;
@property (nonatomic, strong)  NSMutableArray *BowlingloadYArray;

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;
@property (nonatomic, strong)  NSMutableArray *fetchedArray;

@end

@implementation LandingViewController

@synthesize LandingTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //    [cell.collection registerNib:[UINib nibWithNibName:@"collection" bundle:nil] forCellWithReuseIdentifier:@"collection"];
    //    [cell.collection registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    //    [cell.collection registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    
    //  [self.LandingTable registerNib:@"LandingTableViewCell" forCellReuseIdentifier:@"LandingTableViewCell"];
    
    [self.foodDiaryCollectionView registerNib:[UINib nibWithNibName:@"FoodDiaryCell" bundle:nil] forCellWithReuseIdentifier:@"foodCell"];
    
    [self.ResultsCollectionView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    
    [self.VideosCollectionView registerNib:[UINib nibWithNibName:@"VideoGalleryUploadCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
    [self.DocumentsCollectionView registerNib:[UINib nibWithNibName:@"VideoGalleryUploadCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
    [self.EventsCollectionView registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
    [self.FixturesCollectionView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    
    [self.TeamsCollectionView registerNib:[UINib nibWithNibName:@"TeamCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TeamCollectionViewCell"];
    
    
    
    
    WTB_object = [WellnessTrainingBowlingVC new];
    Training_object = [TrainingLoadVC new];
    //    SectionNameArray = @[@{@"Title":@"Events"},
    //                         @{@"Title":@"Teams"},
    //                         @{@"Title":@"Fixtures"},
    //                         @{@"Title":@"Results"},
    //                         @{@"Title":@"Videos"},
    //                         @{@"Title":@"Documents"}];
    //
    //
    //    NSArray* arr = @[@{@"Title":@"Events"},
    //                     @{@"Title":@"Wellness"},
    //                     @{@"Title":@"Training Load"},
    //                     @{@"Title":@"Food"},
    //                     @{@"Title":@"Bowling Graph"},
    //                     @{@"Title":@"Fixtures"},
    //                     @{@"Title":@"Results"},
    //                     @{@"Title":@"Videos"},
    //                     @{@"Title":@"Documents"}];
    
    
    SectionNameArray = @[@{@"Title":@"Events",@"image":@""},
                         @{@"Title":@"Teams",@"image":@"APT_Team"},
                         @{@"Title":@"Fixtures",@"image":@""},
                         @{@"Title":@"Results",@"image":@"More"},
                         @{@"Title":@"Videos",@"image":@"More"},
                         @{@"Title":@"Documents",@"image":@"More"}];
    
    
    NSArray* arr = @[@{@"Title":@"Events",@"image":@""},
                     @{@"Title":@"Wellness",@"image":@""},
                     @{@"Title":@"Training Load",@"image":@""},
                     @{@"Title":@"Food",@"image":@""},
                     @{@"Title":@"Bowling Graph",@"image":@""},
                     @{@"Title":@"Fixtures",@"image":@""},
                     @{@"Title":@"Results",@"image":@"More"},
                     @{@"Title":@"Videos",@"image":@"More"},
                     @{@"Title":@"Documents",@"image":@"More"}];
    
    
    
    ResponseArray = [NSMutableArray new];
    TableListDict = [NSMutableDictionary new];
    
    if (![AppCommon isCoach]) {
        SectionNameArray = arr;
    }
    
    [TableListDict setValue:@[] forKey:@"Events"];
    [TableListDict setValue:@[] forKey:@"Teams"];
    [TableListDict setValue:@[] forKey:@"Fixtures"];
    [TableListDict setValue:@[] forKey:@"Results"];
    //    [TableListDict setValue:@[] forKey:@"Food"];
    //    [TableListDict setValue:@[] forKey:@"Wellness"];
    [TableListDict setValue:@[] forKey:@"Videos"];
    [TableListDict setValue:@[] forKey:@"Documents"];
    
    [self customnavigationmethod];
    [self EventsAndResultsWebservice];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationCount) name:@"updateNotificationCount" object:nil];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateNotificationCount) userInfo:nil repeats:YES];
    
    [self.BowlingDailyBtn sendActionsForControlEvents:UIControlEventTouchUpInside];

    
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
    UIImage* image = [UIImage imageNamed:[[SectionNameArray objectAtIndex:section]valueForKey:@"image"]];
    [cell.imgSectionHead setImage:image];
    //    [cell.btnSectionHead setImage:image forState:UIControlStateNormal];
    cell.Morebtn.tag = section;
    [cell.Morebtn addTarget:self action:@selector(HeaderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

-(void)HeaderBtnAction:(UIButton *)button{
    
    if(button.tag == 0){
        
    }
    else if(button.tag == 1){
        
    }
    else if(button.tag == 2){
        
    }
    else if(button.tag == 3){
        
    }
    else if(button.tag == 4){
        
    }
    else if(button.tag == 5){
        
    }
    else if(button.tag == 6){
         ResultsVc *objresu = [ResultsVc new];
         objresu = (ResultsVc *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ResultsVc"];
        [appDel.frontNavigationController pushViewController:objresu animated:YES];
    }
    else if(button.tag == 7){
        VideoGalleryVC *objVideo = [VideoGalleryVC new];
        objVideo.isBack = @"yes";
        [appDel.frontNavigationController pushViewController:objVideo animated:YES];
    }
    else if(button.tag == 8){
        documentObject = [NewVideoDocumentVC new];
        documentObject.isBack = @"yes";
        [appDel.frontNavigationController pushViewController:documentObject animated:YES];
    }
    
    
    
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

//    LandingTableViewCell* Tablecell = (LandingTableViewCell *)cell;
//    NSString* title = [[SectionNameArray objectAtIndex:indexPath.section] valueForKey:@"Title"];
//
//    if ([title isEqualToString:@"Events"]) {
//        [Tablecell configureCell:self andIndex:1 andTitile:title];
//    }
//    else if ([title isEqualToString:@"Teams"]) {
//        [Tablecell configureCell:self andIndex:2 andTitile:title];
//    }
//    else if ([title isEqualToString:@"Fixtures"]) {
//        [Tablecell configureCell:self andIndex:3 andTitile:title];
//    }
//    else if ([title isEqualToString:@"Results"]) {
//        [Tablecell configureCell:self andIndex:4 andTitile:title];
//    }
////    else if ([title isEqualToString:@"Food"]) {
////        [Tablecell configureCell:self andIndex:5 andTitile:title];
////    }
//    else if ([title isEqualToString:@"Videos"]) {
//        [Tablecell configureCell:self andIndex:6 andTitile:title];
//    }
//    else if ([title isEqualToString:@"Documents"]) {
//        [Tablecell configureCell:self andIndex:7 andTitile:title];
//    }
    
    CGRect frame = cell.frame;
    [cell setFrame:CGRectMake(0, self.LandingTable.frame.size.height, frame.size.width, frame.size.height)];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
        [cell setFrame:frame];
    } completion:^(BOOL finished) {
    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"LandingTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"LandingTableViewCell" owner:self options:nil];
    
    if(cell == nil)
    {
        cell = array[1];
        
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* title = [[SectionNameArray objectAtIndex:indexPath.section] valueForKey:@"Title"];
    
    if ([title isEqualToString:@"Wellness"]){
        self.WellnessUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        
        
        [cell.customView addSubview:self.WellnessUIView];
        
        [cell.collection setHidden:YES];
        
    }
    else if ([title isEqualToString:@"Training Load"]){
        
        Training_object.view.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        [cell.customView addSubview:Training_object.view];
        [cell.collection setHidden:YES];
        
        
    }
    else if([title isEqualToString:@"Bowling Graph"])
    {
        
        self.BowlingUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        [cell.customView addSubview:self.BowlingUIView];
        
        [cell.collection setHidden:YES];
        
    }
    else if ([title isEqualToString:@"Food"]) {
        [cell.collection setHidden:YES];
        self.FoodDiaryUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        [cell.customView addSubview:self.FoodDiaryUIView];
        
        [cell.collection setHidden:YES];
    }
    else if ([title isEqualToString:@"Events"]) {
        self.EventsUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        [cell.customView addSubview:self.EventsUIView];
        [cell.collection setHidden:YES];
    }
    else if ([title isEqualToString:@"Videos"]) {
        self.VideosUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        [cell.customView addSubview:self.VideosUIView];
        [cell.collection setHidden:YES];
    }
    else if ([title isEqualToString:@"Documents"]) {
        self.DocumentsUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        [cell.customView addSubview:self.DocumentsUIView];
        [cell.collection setHidden:YES];
    }
    else if ([title isEqualToString:@"Teams"]) {
        self.TeamsUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        [cell.customView addSubview:self.TeamsUIView];
        [cell.collection setHidden:YES];
    }
    else if ([title isEqualToString:@"Fixtures"]) {
        self.FixturesUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        [cell.customView addSubview:self.FixturesUIView];
        [cell.collection setHidden:YES];
    }
    else if ([title isEqualToString:@"Results"]) {
        self.ResultsUIView.frame = CGRectMake(0,0, cell.customView.bounds.size.width, cell.customView.bounds.size.height);
        
        [cell.customView addSubview:self.ResultsUIView];
        [cell.collection setHidden:YES];
    }
    //    else
    //    {
    //        [cell.customView removeFromSuperview];
    //        [cell.customView setBackgroundColor:[UIColor clearColor]];
    //        [cell.collection setHidden:NO];
    //    }
    
    
    
    return cell;
}

#pragma mark - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = collectionView.frame.size.width;
    CGFloat height = collectionView.frame.size.height;
    
    if(collectionView  == self.EventsCollectionView)
    {
        if(!IS_IPAD && !IS_IPHONE5)
        {
            width = width/2;
        }
        else if(IS_IPAD)
        {
            width = width/3;
        }
        
        return CGSizeMake(width-20, height-50);
    }
    else
    {
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
    
    
    //    if (collectionView.tag == 1) {
    //        return  [[TableListDict valueForKey:@"Events"] count];
    //    }
    //    else if (collectionView.tag == 2){
    //        return [[TableListDict valueForKey:@"Teams"] count];
    //    }
    //    else if (collectionView.tag == 3){
    //        return  [[TableListDict valueForKey:@"Fixtures"] count];
    //    }
    //    else if (collectionView.tag == 4){
    //        return  [[TableListDict valueForKey:@"Results"] count];
    //    }
    ////    else if (collectionView.tag == 5){
    ////        return  [[TableListDict valueForKey:@"Food"] count];
    ////    }
    //    else if (collectionView.tag == 6){
    //        return  [[TableListDict valueForKey:@"Videos"] count];
    //    }
    //    else if (collectionView.tag == 7){
    //        return  [[TableListDict valueForKey:@"Documents"] count];
    //    }
    
    if (collectionView == self.foodDiaryCollectionView) {
        [self.lblNoData setHidden:foodDiaryArray.count];
        return foodDiaryArray.count;
    }
    else if (collectionView == self.EventsCollectionView) {
        return  [[TableListDict valueForKey:@"Events"] count];
    }
    else if (collectionView == self.TeamsCollectionView){
        return [[TableListDict valueForKey:@"Teams"] count];
    }
    else if (collectionView == self.FixturesCollectionView){
        return  [[TableListDict valueForKey:@"Fixtures"] count];
    }
    else if (collectionView == self.ResultsCollectionView){
        return  [[TableListDict valueForKey:@"Results"] count];
    }
    //    else if (collectionView.tag == 5){
    //        return  [[TableListDict valueForKey:@"Food"] count];
    //    }
    else if (collectionView == self.VideosCollectionView){
        return  [[TableListDict valueForKey:@"Videos"] count];
    }
    else if (collectionView == self.DocumentsCollectionView){
        return  [[TableListDict valueForKey:@"Documents"] count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.EventsCollectionView) { // Events
        
        ScheduleCell* cell = (ScheduleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        //        cell.eventNamelbl.text = @"ScheduleCell";
        
        [self setupEventCell:cell andINdex:indexPath];
        
        return  cell;
    }
    else if (collectionView == self.TeamsCollectionView){ // Teams
        
        NSArray* teamlist = [TableListDict valueForKey:@"Teams"];
        
        if (teamlist.count) {
            TeamCollectionViewCell* cell = (TeamCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TeamCollectionViewCell" forIndexPath:indexPath];
            NSString * imgStr1 = [[teamlist valueForKey:@"TeamPhotoLink"] objectAtIndex:indexPath.row];
            [cell.imgTeam sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
            return cell;
        }
    }
    else if (collectionView == self.FixturesCollectionView){ // Fixtures
        
        NSArray* FixturesArray =  [TableListDict valueForKey:@"Fixtures"];
        if (FixturesArray.count) {
            ResultCell* cell = (ResultCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
            cell.resultlbl.text = @"FixturesCell";
            
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
    }
    else if (collectionView == self.ResultsCollectionView){ // Results
        
        ResultCell* cell = (ResultCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
        cell.resultlbl.text = @"ResultCell";
        
        [self setUpResultCell:cell andINdex:indexPath];
        
        
        return cell;
        
    }
    /*
     else if (collectionView.tag == 5){ // Food
     
     FoodDiaryCell *cell = (FoodDiaryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
     //        cell.mealNameLbl.text = @"Foodcell";
     [self setupFoodCell:cell andIndex:indexPath];
     
     
     return cell;
     
     }
     */
    else if (collectionView == self.foodDiaryCollectionView) { // Food
        
        FoodDiaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
        
        cell.layer.masksToBounds = NO;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        cell.layer.shadowRadius = 3;
        cell.layer.shadowOpacity = 0.8f;
        
        if (foodDiaryArray.count) {
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
        return cell;
    }
    
    else if (collectionView == self.VideosCollectionView){ //Videos
        
        VideoGalleryUploadCell* cell = [self.VideosCollectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        NSArray* videosArray = [TableListDict valueForKey:@"Videos"];
        
        cell.contentView.layer.cornerRadius = 2.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
       // NSString * videoDetailStr = [[self.objFirstGalleryArray valueForKey:@"videoFile"] objectAtIndex:indexPath.row];
        //        NSArray *component3 = [videoDetailStr componentsSeparatedByString:@" "];
        
        //        cell.playername_lbl.text =  [NSString stringWithFormat:@"%@",component3[0]];
        //        if ([[AppCommon checkNull:[[self.objFirstGalleryArray valueForKey:@"videoFile"] objectAtIndex:indexPath.row]] isEqualToString:@""]) {
        //
        //
        //        }
        
        cell.batting_lbl.text = [[videosArray valueForKey:@"videoName"] objectAtIndex:indexPath.row];
        cell.fileImg.image = [UIImage imageNamed:@"Video-Icon-crop"];
        //[cell.fileImg setImage:@"Video-Icon-crop"];
        //        cell.date_lbl.text =  [NSString stringWithFormat:@"%@",component3[2]];
        
        //        if (indexPath.row % 2 == 1) {
        //
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        //        }
        //        else {
        //            cell.layer.shadowColor = [UIColor redColor].CGColor;
        //        }
        
        
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        
        return cell;
    }
    else if (collectionView == self.DocumentsCollectionView){ //Videos
        
        VideoGalleryUploadCell* cell = [self.DocumentsCollectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        NSArray* videosArray = [TableListDict valueForKey:@"Documents"];
        
        cell.contentView.layer.cornerRadius = 2.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        // NSString * videoDetailStr = [[self.objFirstGalleryArray valueForKey:@"videoFile"] objectAtIndex:indexPath.row];
        //        NSArray *component3 = [videoDetailStr componentsSeparatedByString:@" "];
        
        //        cell.playername_lbl.text =  [NSString stringWithFormat:@"%@",component3[0]];
        //        if ([[AppCommon checkNull:[[self.objFirstGalleryArray valueForKey:@"videoFile"] objectAtIndex:indexPath.row]] isEqualToString:@""]) {
        //
        //
        //        }
        
        cell.batting_lbl.text = [[videosArray valueForKey:@"documentFileName"] objectAtIndex:indexPath.row];
        cell.fileImg.image = [UIImage imageNamed:@"pdf"];
       // [cell.fileImg setImage:@"pdf"];
        //        cell.date_lbl.text =  [NSString stringWithFormat:@"%@",component3[2]];
        
        //        if (indexPath.row % 2 == 1) {
        //
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        //        }
        //        else {
        //            cell.layer.shadowColor = [UIColor redColor].CGColor;
        //        }
        
        
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        
        return cell;
    }
    
    return  nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (collectionView.tag == 5){ // Food
     [self selectedFoodCell:cell andIndex:indexPath];
     }
     */
    if(collectionView == self.foodDiaryCollectionView)
    {
        FoodDiaryUpdateVC *objresult = [FoodDiaryUpdateVC new];
        objresult.foodDiaryType = @"Update";
        objresult.selectedIndexPath = indexPath;
        objresult.foodDiaryArray = foodDiaryArray;
        [self.navigationController pushViewController:objresult animated:YES];
    }
    else if(collectionView == self.EventsCollectionView)
    {
        [self selectedEventCell:cell andIndex:indexPath];
    }
    else if(collectionView == self.ResultsCollectionView)
    {
        [self selectedResultsCell:cell andIndex:indexPath];
    }
    else if(collectionView == self.VideosCollectionView)
    {
        [self selectedVideoCell:cell andIndex:indexPath];
    }
    else if (collectionView == self.DocumentsCollectionView) {
        NSArray* videosArray = [TableListDict valueForKey:@"Documents"];
        NSString *documentFile = [[videosArray valueForKey:@"documentFile"] objectAtIndex:indexPath.row];
        
        documentObject = [[NewVideoDocumentVC alloc] initWithNibName:@"NewVideoDocumentVC" bundle:nil];
        
         //To Display Document PDFView
        documentObject.documentLink = documentFile;
//        documentObject.documentLink = @"https://www.example.com/document.pdf";
        documentObject.titleString = @"Documents";
      //  documentObject.pdfView;
        [appDel.frontNavigationController presentViewController:documentObject animated:YES completion:nil];
        
//        documentObject.pdfView;
//         [documentObject loadWebView:@"https://www.example.com/document.pdf"];
//        [appDel.frontNavigationController presentViewController:documentObject.pdfView animated:YES completion:nil];
        
    }
    
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



-(void)selectedFoodCell:(FoodDiaryCell *)cell andIndex:(NSIndexPath *)indexPath{
    
    NSMutableArray *foodDiaryArray = [TableListDict valueForKey:@"Food"];
    
    FoodDiaryUpdateVC *objresult = [FoodDiaryUpdateVC new];
    objresult.foodDiaryType = @"Update";
    objresult.selectedIndexPath = indexPath;
    objresult.foodDiaryArray = foodDiaryArray;
    [self.navigationController pushViewController:objresult animated:YES];
    
}

-(void)selectedEventCell:(ScheduleCell *)cell andIndex:(NSIndexPath *)indexPath{
    
    //NSMutableArray *foodDiaryArray = [TableListDict valueForKey:@"Events"];
    
    PlannerVC *objresult = [PlannerVC new];
    objresult.checkBacknavi = @"yes";
    
    [self.navigationController pushViewController:objresult animated:YES];
    
}

-(void)selectedResultsCell:(ResultCell *)cell andIndex:(NSIndexPath *)indexPath{
    
    NSMutableArray *resultsArray = [TableListDict valueForKey:@"Results"];
    
   NSString * displayMatchCode = [[resultsArray valueForKey:@"MATCHCODE"] objectAtIndex:indexPath.row];
    
   TabbarVC * objtab = (TabbarVC *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"TabbarVC"];
    appDel.Currentmatchcode = displayMatchCode;
    //appDel.Scorearray = scoreArray;
    //objtab.backkey = @"yes";
    //[self.navigationController pushViewController:objFix animated:YES];
    [appDel.frontNavigationController pushViewController:objtab animated:YES];
    
}

-(void)selectedVideoCell:(ResultCell *)cell andIndex:(NSIndexPath *)indexPath{

   NSMutableArray *VideosArray = [TableListDict valueForKey:@"Videos"];
   NSString * selectvideoStr = [[VideosArray valueForKey:@"videoFile"]objectAtIndex:indexPath.row];
    
//    VideoPlayerViewController *videoPlayerVC = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" bundle:nil];
//    videoPlayerVC.objSelectVideoLink = selectvideoStr;
//    [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];
    
    ScoreCardVideoPlayer * videoPlayerVC = (ScoreCardVideoPlayer *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
    videoPlayerVC.isFromHome = YES;
    videoPlayerVC.HomeVideoStr = selectvideoStr;
    NSLog(@"appDel.frontNavigationController.topViewController %@",appDel.frontNavigationController.topViewController);
    [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];
}

- (IBAction)addFoodDiaryButtonTapped:(id)sender {
    
    FoodDiaryUpdateVC *objresult = [FoodDiaryUpdateVC new];
    objresult.foodDiaryType = @"Save";
    [self.navigationController pushViewController:objresult animated:YES];
}

#pragma mark- Webservice

-(void)EventsAndResultsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
    
    
//    [AppCommon showLoading];
    
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.EventsCollectionView reloadData];
                [self.ResultsCollectionView reloadData];
            });
            
            
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

//        dispatch_async(dispatch_get_main_queue(), ^{
            [self FixturesWebservice];
//        });

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];

//        dispatch_async(dispatch_get_main_queue(), ^{
            [self FixturesWebservice];
//        });

    }];
    
}


-(void)FixturesWebservice
{
    if(![COMMON isInternetReachable])
        return;
    
//    [AppCommon showLoading];
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
                [self.FixturesCollectionView reloadData];
            });
        }
        [AppCommon hideLoading];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self TeamsWebservice];
        });

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];

        NSLog(@"failed");
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self TeamsWebservice];
//        });

    }];
    
}

-(void)TeamsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
    
    
//    [AppCommon showLoading];
    
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

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.TeamsCollectionView reloadData];

        });
        
        [self FoodDiaryWebservice];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];

//        dispatch_async(dispatch_get_main_queue(), ^{
            [self FoodDiaryWebservice];
            
//        });

        
        
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
    
//    [AppCommon showLoading];
    
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
            
            foodDiaryArray = [NSMutableArray new];
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
            
            //            if (foodDiaryArray.count) {
            //                [TableListDict setValue:foodDiaryArray forKey:@"Food"];
            //            }
            
            NSLog(@"Count:%ld", foodDiaryArray.count);
            //            [self setClearBorderForMealTypeAndLocation];
            
        }
        [AppCommon hideLoading];

//        dispatch_async(dispatch_get_main_queue(), ^{
            [self FetchWebservice];
            
//        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];

//        dispatch_async(dispatch_get_main_queue(), ^{
            [self FetchWebservice];
            
//        });

    }];
}

//For Wellness

- (void)FetchWebservice
{
    
    if(![COMMON isInternetReachable])
        return;

//    [AppCommon showLoading];
    
    NSString *playerCode;
    if([AppCommon isCoach])
    {
        
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    // NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString * actualDate = [dateFormat stringFromDate:matchdate];
    // NSString *urinecolor= @"0";
    
    [objWebservice fetchWellness :FetchrecordWellness : playerCode :actualDate success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        self.NoDataView.hidden = YES;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr = responseObject;
        if(arr.count >0)
        {
            self.NoDataView.hidden = YES;
            if( ![[[responseObject valueForKey:@"BodyWeight"] objectAtIndex:0] isEqual:[NSNull null]])
            {
                self.bodyWeightlbl.text = [[responseObject valueForKey:@"BodyWeight"] objectAtIndex:0];
                
                //[self.fetchButton setTag:1];
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
        else
        {
            self.NoDataView.hidden = NO;
        }
        
        [AppCommon hideLoading];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.foodDiaryCollectionView reloadData];
            [self.LandingTable reloadData];
            NSLog(@"Countt:%ld", TableListDict.count);
            
        });
        [self.BowlingDailyBtn sendActionsForControlEvents:UIControlEventTouchUpInside]; // This will call BowlingLoadWebservice

        
    }
      failure:^(AFHTTPRequestOperation *operation, id error) {
          NSLog(@"failed");
          [COMMON webServiceFailureError:error];
          [AppCommon hideLoading];
          [self.BowlingDailyBtn sendActionsForControlEvents:UIControlEventTouchUpInside]; // This will call BowlingLoadWebservice

      }];
}

-(void)VideosWebservice
{
    if(![COMMON isInternetReachable])
        return;
    
//    [AppCommon showLoading];
    
    NSLog(@"Videos Webservice called ");
    NSString *URLString =  URL_FOR_RESOURCE(@"MOBILE_APT_VIDEOGALLERY");
//    NSString *URLString = @"http://192.168.0.154:8029/AGAPTService.svc/MOBILE_APT_VIDEOGALLERY";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    //        NSString *competition = @"";
    //        NSString *teamcode = [AppCommon getCurrentTeamCode];
    
    NSString *usercode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    // NSString *usercode = @"USM0000107";
    NSString *clientcode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //        if(competition)   [dic    setObject:competition     forKey:@"Competitioncode"];
    if(usercode)   [dic    setObject:usercode     forKey:@"Usercode"];
    if(clientcode)   [dic    setObject:clientcode     forKey:@"clientCode"];
    [dic setObject:@"10" forKey:@"Count"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            //            self.objFirstGalleryArray =[[NSMutableArray alloc]init];
            //            self.objFirstGalleryArray = [responseObject valueForKey:@"Secondlist"];
            //            self.mainGalleryArray = self.objFirstGalleryArray;
            
            if ([responseObject valueForKey:@"Secondlist"] != nil) {
                [TableListDict setValue:[responseObject valueForKey:@"Secondlist"] forKey:@"Videos"];
            }
            
            
        }
        
        [AppCommon hideLoading];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.VideosCollectionView reloadData];
        });
        [self videoDocumentWebservice];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [COMMON webServiceFailureError:error];
        NSLog(@"failed");
        [AppCommon hideLoading];
    }];
    
}


- (void) videoDocumentWebservice {
    
    
    if(![COMMON isInternetReachable])
        return;
    
    NSString *URLString =  URL_FOR_RESOURCE(@"MOBILE_DOCUMENTFILEGALLERY");
    // NSString *URLString = @"http://192.168.0.154:8029/AGAPTService.svc/MOBILE_DOCUMENTFILEGALLERY";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    // NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    //    selectedTeamCode = [AppCommon getCurrentTeamCode];
    //    selectedPlayerCode = [AppCommon GetuserReference];
    //
    //    if(selectedTeamCode)   [dic    setObject:selectedTeamCode     forKey:@"TeamCode"];
    //    if(selectedPlayerCode)   [dic    setObject:selectedPlayerCode     forKey:@"PlayerCode"];
    ////    if(lblType.text)   [dic    setObject:lblType.text     forKey:@"keyWords"];
    //    if(lblcategory.text )   [dic    setObject:lblcategory.text     forKey:@"CategoryCode"];
    //    [dic    setObject:@""  forKey:@"keyWords"];
    
    
    NSString *usercode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    // NSString *usercode = @"USM0000107";
    NSString *clientcode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString *count =  @"10";
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //        if(competition)   [dic    setObject:competition     forKey:@"Competitioncode"];
    if(usercode)   [dic    setObject:usercode     forKey:@"Usercode"];
    if(clientcode)   [dic    setObject:clientcode     forKey:@"clientCode"];
    if(count)   [dic    setObject:count     forKey:@"Count"];
    
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            if ([responseObject valueForKey:@"Secondlist"] != nil) {
                [TableListDict setValue:[responseObject valueForKey:@"Secondlist"] forKey:@"Documents"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.DocumentsCollectionView reloadData];
        });
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}

-(void)BowlingLoadWebservice : (NSString *)date : (NSString *)type
{
    
    if(![COMMON isInternetReachable])
        return;

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

        dispatch_async(dispatch_get_main_queue(), ^{
            [self VideosWebservice];
        });
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];

//        dispatch_async(dispatch_get_main_queue(), ^{
            [self VideosWebservice];
//        });
        
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
//              [AppCommon hideLoading];
//        }];
//    }
//
//}

#pragma mark - Custom Methods


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


//for bowling
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

- (IBAction)AddWellnessAction:(id)sender {
    
    AddWellnessRatingVC *VC = [AddWellnessRatingVC new];
    [appDel.frontNavigationController pushViewController:VC animated:YES];
}

- (IBAction)didClickWellnessAction:(id)sender {
    
    AddWellnessRatingVC *VC = [AddWellnessRatingVC new];
    [appDel.frontNavigationController pushViewController:VC animated:YES];
}







@end


