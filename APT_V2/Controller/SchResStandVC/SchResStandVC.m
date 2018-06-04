//
//  SchResStandVC.m
//  APT_V2
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "SchResStandVC.h"
#import "Config.h"
#import "HomeScreenStandingsVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "WebService.h"
#import "AppCommon.h"
#import "VideoGalleryVC.h"
#import "ScoreCardVC.h"
#import "VideoPlayerViewController.h"
#import "HomeScreenStandingsVC.h"
#import "TabbarVC.h"
#import "ResultsVc.h"
#import "DocumentViewController.h"
#import "VideoDocumentVC.h"
#import "PlannerAddEvent.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SchResStandVC ()<openUploadDelegate,openUploadDocumentDelegate>
{
    VideoGalleryVC *objVideo;
    NSString *displayMatchCode;
    VideoPlayerViewController * videoPlayerVC;
    HomeScreenStandingsVC *objStands;
    TabbarVC *objtab;
    SWRevealViewController *revealController;
    NSMutableArray *objarray;
    ResultsVc *objresult;
    DocumentViewController* docVC;
    VideoDocumentVC *objVDocut;
    
}

@property (strong, nonatomic)  NSMutableArray *commonArray;
@property (strong, nonatomic)  NSMutableArray *commonArray2;

@property (nonatomic,strong) NSMutableArray * AllEventListArray;
@property (nonatomic,strong) NSMutableArray * AllEventDetailListArray;
@property (nonatomic,strong) NSMutableArray * ParticipantsTypeArray;
@property (nonatomic,strong) NSMutableArray * PlayerTeamArray;
@property (nonatomic,strong) NSMutableArray * EventStatusArray;
@property (nonatomic,strong) NSMutableArray * EventTypeArray;

@end

@implementation SchResStandVC

@synthesize documentView,videoViewHeight;

@synthesize eventViewHeight,eventCollectionHeight,ScrollcontentHeight;


@synthesize Delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ScheduleWebservice];

    // Do any additional setup after loading the view from its nib.
    
    //[self customnavigationmethod];
    
    [self.eventsCollectionView registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    [self.scheduleCollectionView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    
    self.Nodatalbl.hidden = YES;
    self.scroll.contentSize =  self.commonView.frame.size;
    
    objVideo = [[VideoGalleryVC alloc] initWithNibName:@"VideoGalleryVC" bundle:nil];
    objVideo.view.frame = CGRectMake(0, 0, self.videoView.bounds.size.width, self.videoView.bounds.size.height);
    [self.videoView addSubview:objVideo.view];
    
    /*
    objVDocut = [[VideoDocumentVC alloc] initWithNibName:@"VideoDocumentVC" bundle:nil];
    objVDocut.protocolUpload = self;
    objVDocut.view.frame = CGRectMake(0, 0, self.videoView.bounds.size.width, self.videoView.bounds.size.height);
    [self.videoView addSubview:objVDocut.view];
    */
    docVC = [DocumentViewController new];
    docVC.protocolUpload = self;
    [docVC.view setFrame:CGRectMake(0, 0, documentView.frame.size.width, documentView.frame.size.height)];
    [documentView addSubview:docVC.view];

//    objStands = [[HomeScreenStandingsVC alloc] initWithNibName:@"HomeScreenStandingsVC" bundle:nil];
//    objStands.view.frame = CGRectMake(0, 0, self.standingsView.bounds.size.width, self.standingsView.bounds.size.height);
//    [self.standingsView addSubview:objStands.view];
    [self changeFormat];
    
    if ([AppCommon isKXIP]) {
        
        [self.Nodatalbl setHidden:NO];
        eventViewHeight.constant = 30;
        eventCollectionHeight.constant = 175;
        self.eventsCollectionView.delegate = self;
        self.eventsCollectionView.dataSource = self;
        //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 1310);
        //        ScrollcontentHeight.constant = 1290;
    }
    else
    {
        self.eventsCollectionView.delegate = nil;
        self.eventsCollectionView.dataSource = nil;
        
        [self.Nodatalbl setHidden:YES];
        eventViewHeight.constant = 0;
        eventCollectionHeight.constant = 0;
        //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 1105);
        //        ScrollcontentHeight.constant = 1085;
        
    }
    
    [self.eventsCollectionView layoutIfNeeded];
    [self.eventsCollectionView updateConstraintsIfNeeded];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)changeFormat
{
    /*
     NSString *finalDate = @"2014-10-15";
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *date = [dateFormatter dateFromString:dateStr];
     [dateFormatter setDateFormat:@"EE, d MMM, YYYY"];
     return [dateFormatter stringFromDate:date];
     */
    
//    NSString* str =@"21 May'17 12:00AM (IST)";
    NSString* str =@"21 May'17";

    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd MMM''yy"];
    NSDate* date = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"d MMM''yy HH:mma (zzz)"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    
}

- (IBAction)onClickMoreMatches:(id)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    objresult = (ResultsVc *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ResultsVc"];
    //[self.navigationController pushViewController:objFix animated:YES];
    [appDel.frontNavigationController pushViewController:objresult animated:YES];
    
}



-(void)ScheduleWebservice
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",ScheduleKey]];
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
                NSMutableArray *scheduleArray = [responseObject valueForKey:@"EventDetails"];
                NSMutableArray *resultArray = [responseObject valueForKey:@"ResultsValues"];
                
                self.commonArray = [[NSMutableArray alloc]init];
                self.commonArray2 = [[NSMutableArray alloc]init];
                
                self.commonArray = scheduleArray;
                self.commonArray2 = resultArray;
            
                [self.eventsCollectionView reloadData];
                [self.resultCollectionView reloadData];
                
                BOOL iftheyClickedLater = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLater"];
                
                if (!iftheyClickedLater) { // New version update alert if they click later, we dont show that alert again and again
                    
                    NSInteger* isLatestVersion = [[responseObject valueForKey:@"isLatestVersion"] integerValue];
                    NSLog(@"isLatestVersion %@",[responseObject valueForKey:@"isLatestVersion"] );
                    if (!isLatestVersion) {
                        NSLog(@"canUpdate TRUE ");
                        [AppCommon newVersionUpdateAlert];
                    }

                }
                

            }
            
            
            
            [AppCommon hideLoading];
            [self FixturesWebservice];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
        }];
    }
    
}

-(void)addShadows:(CALayer *)layer
{
//    float shadowSize = 10.0f;
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.avatarImageView.frame.origin.x - shadowSize / 2,
//                                                                           self.avatarImageView.frame.origin.y - shadowSize / 2,
//                                                                           self.avatarImageView.frame.size.width + shadowSize,
//                                                                           self.avatarImageView.frame.size.height + shadowSize)];
//    self.avatarImageView.layer.masksToBounds = NO;
//    self.avatarImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.avatarImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    self.avatarImageView.layer.shadowOpacity = 0.8f;
//    self.avatarImageView.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:layer.visibleRect];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.8f;
    layer.shadowPath = path.CGPath;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.commonArray.count;
    
    if(collectionView == self.scheduleCollectionView)
    {
        return objarray.count;
    }
    else if(collectionView==self.eventsCollectionView)
    {
        
        self.Nodatalbl.hidden = self.commonArray.count;
        if(!self.Nodatalbl.isHidden)
        {
            self.eventCollectionHeight.constant = 50;
        }
        else
        {
            self.eventCollectionHeight.constant = 175;
        }
        
        return self.commonArray.count;
    }
    else
    {
        return self.commonArray2.count;
    }
}

#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = collectionView.frame.size.width;
    CGFloat height = collectionView.frame.size.height;
    
    if(!IS_IPAD && !IS_IPHONE5)
    {
        width = width/2;
        
        if(collectionView == self.scheduleCollectionView)
        {
//            appDel.window.bounds.size.width > 224
            
        }
        
    }
    else if(IS_IPAD)
    {
       width = width/3;
    
    }
    
    return CGSizeMake(width-20, height-20);
    
    
//    if(IS_IPHONE_DEVICE)
//    {
//        if(!IS_IPHONE5)
//        {
//            return CGSizeMake(50, 50);
//        }
//        else
//        {
//            if(collectionView == self.scheduleCollectionView)
//            {
//                return CGSizeMake(310, 182);
//            }
//            else
//            {
//                return CGSizeMake(310, 182);
//            }
//        }
//    }
//    else
//    {
//        //return CGSizeMake(160, 140);
//
//        if(collectionView == self.scheduleCollectionView)
//        {
//            return CGSizeMake(310, 170);
//        }
//        else
//        {
//            return CGSizeMake(310, 170);
//        }
//    }
}
#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if(!IS_IPHONE_DEVICE)
//    {
//        return UIEdgeInsetsMake(20, 20, 30, 20); // top, left, bottom, right
//    }
//    else{
//        return UIEdgeInsetsMake(10, 10, 10, 10);
//    }
    
    return UIEdgeInsetsMake(10, 10, 10, 10);

}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if(!IS_IPHONE_DEVICE)
//    {
//        return 20.0;
//    }
//    else{
//        return 10.0;
//    }
    
    return 10.0;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if(!IS_IPHONE_DEVICE)
//    {
//        return 23.0;
//    }
//    else{
//        return 10.0;
//    }
    return 10.0;

}

-(NSString* )getRequireddate:(NSString *)dateString
{
  
    NSString* str = @"";
    
    return str;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView==self.eventsCollectionView)
    {
        
        ScheduleCell* cell = [self.eventsCollectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        //Practice_Icon
        cell.eventNamelbl.text = [[self.commonArray valueForKey:@"EventName"] objectAtIndex:indexPath.row];
        
        cell.eventTypelbl.text = [[self.commonArray valueForKey:@"EventTypeDesc"] objectAtIndex:indexPath.row];
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

        
        
        NSString *starttime = [[self.commonArray valueForKey:@"EventStartTime"] objectAtIndex:indexPath.row];
        NSString *endtime = [[self.commonArray valueForKey:@"EventEndTime"] objectAtIndex:indexPath.row];
        cell.venuelbl.text = [[self.commonArray valueForKey:@"EventVenue"] objectAtIndex:indexPath.row];
        
        
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
        
        return cell;
    }
    if(collectionView==self.scheduleCollectionView)
    {
        
        ResultCell* cell = [self.scheduleCollectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
        
        
        NSLog(@"DATE FORMAT %@ ",[[objarray valueForKey:@"date"] objectAtIndex:indexPath.row]);
        cell.datelbl.text = [[objarray valueForKey:@"date"] objectAtIndex:indexPath.row];
        // cell.resultlbl.text = [[objarray valueForKey:@"time"] objectAtIndex:indexPath.row];
        cell.resultlbl.text = [[objarray valueForKey:@"ground"] objectAtIndex:indexPath.row];
        cell.FirstInnScorelbl.text = [[objarray valueForKey:@"team1"] objectAtIndex:indexPath.row];
        cell.SecondInnScorelbl.text = [[objarray valueForKey:@"team2"] objectAtIndex:indexPath.row];
        cell.competitionNamelbl.text = [[objarray valueForKey:@"CompetitionName"] objectAtIndex:indexPath.row];
        
        cell.teamAlogo.image = [UIImage imageNamed:@"no-image"];
        cell.teamBlogo.image = [UIImage imageNamed:@"no-image"];
        
                NSString * imgStr1 = ([[objarray objectAtIndex:indexPath.row] valueForKey:@"team1Img"]==[NSNull null])?@"":[[objarray objectAtIndex:indexPath.row] valueForKey:@"team1Img"];
//                NSString *teamAString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imgStr1];
        
                NSString * imgStr2 = ([[objarray objectAtIndex:indexPath.row] valueForKey:@"team2Img"]==[NSNull null])?@"":[[objarray objectAtIndex:indexPath.row] valueForKey:@"team2Img"];
//                NSString *teamBString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imgStr2];
        
//                [self downloadImageWithURL:[NSURL URLWithString:imgStr1] completionBlock:^(BOOL succeeded, UIImage *image) {
//                    if (succeeded) {
//                        // change the image in the cell
//                        cell.teamAlogo.image = image;
//
//                        // cache the image for use later (when scrolling up)
//                        cell.teamAlogo.image = image;
//                    }
//                    else
//                    {
//                        cell.teamAlogo.image = [UIImage imageNamed:@"no-image"];
//                    }
//                }];
                [cell.teamAlogo sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
//                [self downloadImageWithURL:[NSURL URLWithString:imgStr2] completionBlock:^(BOOL succeeded, UIImage *image) {
//                    if (succeeded) {
//                        // change the image in the cell
//                        cell.teamBlogo.image = image;
//
//                        // cache the image for use later (when scrolling up)
//                        cell.teamBlogo.image = image;
//                    }
//                    else
//                    {
//                        cell.teamBlogo.image = [UIImage imageNamed:@"no-image"];
//                    }
//                }];
                [cell.teamBlogo sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        //        NSString *key = [[objarray valueForKey:@"team1"] objectAtIndex:indexPath.row];
        //
        //        if([ key isEqualToString:@"India"])
        //        {
        //            cell.team1Img.image = [UIImage imageNamed:@"Indialogo"];
        //            cell.team2Img.image = [UIImage imageNamed:@"Srilankalogo"];
        //
        //        }
        //        else
        //        {
        //            cell.team1Img.image = [UIImage imageNamed:@"Srilankalogo"];
        //            cell.team2Img.image = [UIImage imageNamed:@"Indialogo"];
        //        }
        
        
//        cell.contentView.layer.cornerRadius = 2.0f;
//        cell.contentView.layer.borderWidth = 1.0f;
//        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
//        cell.contentView.layer.masksToBounds = YES;
        
//        if (indexPath.row % 2 == 1) {
        
            cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//        }
//        else {
//            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        }
        
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        return cell;
    }
    if(collectionView==self.resultCollectionView)
    {
        
        ResultCell* cell = [self.resultCollectionView dequeueReusableCellWithReuseIdentifier:@"cellno" forIndexPath:indexPath];
        
        
        cell.competitionNamelbl.text = [[self.commonArray2 valueForKey:@"COMPETITIONNAME"]objectAtIndex:indexPath.row];
        
        NSString *curdate = [[self.commonArray2 valueForKey:@"DateTime"]objectAtIndex:indexPath.row];
        NSArray *arr = [curdate componentsSeparatedByString:@" "];
        
        cell.datelbl.text = [NSString stringWithFormat:@"%@ %@",arr[0],arr[1]];
//        cell.teamAlbl.text = [[self.commonArray2 valueForKey:@"TeamA"]objectAtIndex:indexPath.row];
//        cell.teamBlbl.text = [[self.commonArray2 valueForKey:@"TeamB"]objectAtIndex:indexPath.row];
        cell.resultlbl.text = [[self.commonArray2 valueForKey:@"MATCHRESULTORRUNSREQURED"]objectAtIndex:indexPath.row];
        
        cell.teamAlbl.text = [[self.commonArray2 valueForKey:@"TeamA"]objectAtIndex:indexPath.row];
        cell.teamBlbl.text = [[self.commonArray2 valueForKey:@"TeamB"]objectAtIndex:indexPath.row];
        
        NSString *first = [self checkNull:[[self.commonArray2 valueForKey:@"FIRSTINNINGSSCORE"]objectAtIndex:indexPath.row]];
        NSLog(@"%ld",(long)indexPath.row);
        if( [first isEqualToString:@"0 /0 (0.0 Ov)"])
        {
            cell.FirstInnScorelbl.text = @"";
        }
        else
        {
            cell.FirstInnScorelbl.text = first;
        }
        
        
        NSString *second = [self checkNull:[[self.commonArray2 valueForKey:@"SECONDINNINGSSCORE"]objectAtIndex:indexPath.row]];
        NSLog(@"%ld",(long)indexPath.row);
        
        if( [second isEqualToString:@"0 /0 (0.0 Ov)"])
        {
            cell.SecondInnScorelbl.text = @"";
        }
        else
        {
            cell.SecondInnScorelbl.text = second;
        }
        
        
        NSString *third = [self checkNull:[[self.commonArray2 valueForKey:@"THIRDINNINGSSCORE"]objectAtIndex:indexPath.row]];
        NSLog(@"%ld",(long)indexPath.row);
        
        if( [third isEqualToString:@"0 /0 (0.0 Ov)"])
        {
            cell.ThirdInnScorelbl.text = @"";
        }
        else
        {
            cell.ThirdInnScorelbl.text = third;
        }
        
        
        
        NSString *fourth = [self checkNull:[[self.commonArray2 valueForKey:@"FOURTHINNINGSSCORE"]objectAtIndex:indexPath.row]];
        NSLog(@"%ld",(long)indexPath.row);
        
        if( [fourth isEqualToString:@"0 /0 (0.0 Ov)"])
        {
            cell.FouthInnScorelbl.text = @"";
        }
        else
        {
            cell.FouthInnScorelbl.text = fourth;
        }
        
        
        
        
        NSString * imgStr1 = ([[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamALogo"]==[NSNull null])?@"":[[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamALogo"];
//        NSString *teamAString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imgStr1];
        
        NSString * imgStr2 = ([[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamBLogo"]==[NSNull null])?@"":[[self.commonArray2 objectAtIndex:indexPath.row] valueForKey:@"TeamBLogo"];
//        NSString *teamBString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imgStr2];
        
//        [self downloadImageWithURL:[NSURL URLWithString:imgStr1] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.teamAlogo.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.teamAlogo.image = image;
//            }
//            else
//            {
//                cell.teamAlogo.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.teamAlogo sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
//        [self downloadImageWithURL:[NSURL URLWithString:imgStr2] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.teamBlogo.image = image;
//                
//                // cache the image for use later (when scrolling up)
//                cell.teamBlogo.image = image;
//            }
//            else
//            {
//                cell.teamBlogo.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.teamBlogo sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
//        cell.contentView.layer.cornerRadius = 2.0f;
//        cell.contentView.layer.borderWidth = 1.0f;
//        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
//        cell.contentView.layer.masksToBounds = YES;
        
//        if (indexPath.row % 2 == 0) {
        
            cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//        }
        
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(collectionView == self.eventsCollectionView)
    {
        PlannerAddEvent  * objaddEvent=[[PlannerAddEvent alloc]init];
        //objaddEvent = (PlannerAddEvent *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
        
        objaddEvent = (PlannerAddEvent *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"AddEvent"];
        objaddEvent.isEdit =YES;
        objaddEvent.isNotification = @"yes";
        objaddEvent.eventType = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"EventCode"];
        objaddEvent.ListeventTypeArray = self.EventTypeArray;
        objaddEvent.ListeventStatusArray =self.EventStatusArray;
        objaddEvent.ListparticipantTypeArray =self.ParticipantsTypeArray;
        [appDel.frontNavigationController pushViewController:objaddEvent animated:YES];
    }
    else if(collectionView == self.resultCollectionView)
    {
        displayMatchCode = [[self.commonArray2 valueForKey:@"MATCHCODE"] objectAtIndex:indexPath.row];
        NSMutableArray *scoreArray = [[NSMutableArray alloc]init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        NSString *ground = [[self.commonArray2 valueForKey:@"Ground"]objectAtIndex:indexPath.row];
        NSString *place = [[self.commonArray2 valueForKey:@"GroundCode"]objectAtIndex:indexPath.row];
        
        [dic setValue:[NSString stringWithFormat:@"%@,%@",ground,place] forKey:@"ground"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamA"] objectAtIndex:indexPath.row] forKey:@"team1"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamB"]objectAtIndex:indexPath.row] forKey:@"team2"];
        [dic setValue:[[self.commonArray2 valueForKey:@"FIRSTINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn1Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"SECONDINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn2Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"THIRDINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn3Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"FOURTHINNINGSSCORE"]objectAtIndex:indexPath.row] forKey:@"Inn4Score"];
        [dic setValue:[[self.commonArray2 valueForKey:@"MATCHRESULTORRUNSREQURED"]objectAtIndex:indexPath.row] forKey:@"result"];
        [dic setValue:[[self.commonArray2 valueForKey:@"COMPETITIONNAME"]objectAtIndex:indexPath.row] forKey:@"Competition"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamALogo"]objectAtIndex:indexPath.row] forKey:@"TeamALogo"];
        [dic setValue:[[self.commonArray2 valueForKey:@"TeamBLogo"]objectAtIndex:indexPath.row] forKey:@"TeamBLogo"];
        
        [scoreArray addObject:dic];
        
        objtab = (TabbarVC *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"TabbarVC"];
        appDel.Currentmatchcode = displayMatchCode;
        appDel.Scorearray = scoreArray;
        [appDel.frontNavigationController pushViewController:objtab animated:YES];
        
        
    }
    
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];                 // 1
    content.view.bounds = self.view.bounds;                 //2
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


-(void)FixturesWebservice
{
    if([COMMON isInternetReachable])
    {
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",FixturesKey]];
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
                objarray = [[NSMutableArray alloc]init];
                NSMutableArray * fixArr = [[NSMutableArray alloc]init];
                fixArr = [responseObject valueForKey:@"lstFixturesGridValues"];
                if(fixArr.count >0)
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
                        
                        
                       NSString * usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
                        
                       NSString * cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
                        
                        NSString *userref = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
                        
                        [self EventTypeWebservice :usercode:cliendcode:userref];
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.scheduleCollectionView reloadData];
                    });
                }
            }
            
            [AppCommon hideLoading];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [COMMON webServiceFailureError:error];
            NSLog(@"failed");
            
        }];
    }
    
}

-(void)videoGallery
{
    objVideo = [[VideoGalleryVC alloc] initWithNibName:@"VideoGalleryVC" bundle:nil];
    objVideo.view.frame = CGRectMake(0, 0, self.videoView.bounds.size.width, self.videoView.bounds.size.height);
    [self.videoView addSubview:objVideo.view];

}

-(void)openVideoUploadView
{
    NSLog(@"openVideoUploadView called");

    [Delegate openVideoUploadViewInTabHomeVC:@"video"];
}

-(void)openDocumentUploadView
{
    NSLog(@"openVideoUploadView called");
    
    [Delegate openVideoUploadViewInTabHomeVC:@"document"];

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
                
            }
            
            [AppCommon hideLoading];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
        }];
    }
    
}

-(void)updateVideoCollectionCount:(NSDictionary *)info
{
    NSLog(@"updateVideoCollectionCount %@",info);
    
//    if(Value)
//    {
//        videoViewHeight.constant = 300;
//
//    }
//    else
//    {
//        videoViewHeight.constant = 300;
//    }
}


@end

