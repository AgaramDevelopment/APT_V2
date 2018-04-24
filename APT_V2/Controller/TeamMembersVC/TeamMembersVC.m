//
//  TeamMembersVC.m
//  APT_V2
//
//  Created by MAC on 12/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TeamMembersVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "AppCommon.h"
#import "Config.h"
#import "WebService.h"
#import "TeamMemebersCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyStatsBattingVC.h"

@interface TeamMembersVC ()
{
    UIRefreshControl *refreshControl;
}

@property (strong, nonatomic)  NSMutableArray *PlayersArray;
@property (strong, nonatomic)  NSMutableArray *PlayerRoleArray;
@property (strong, nonatomic)  NSMutableArray *CommonArray;

@end

@implementation TeamMembersVC

@synthesize AllrounderBtn,WktKeeperBtn;

@synthesize navView,filterContainerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    refreshControl = [[UIRefreshControl alloc] init];

      [self.playesTable registerNib:[UINib nibWithNibName:@"TeamMemebersCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    self.TeamNamelbl.text = _teamname;
    
    self.AllBtn.layer.cornerRadius = 5;
    self.AllBtn.clipsToBounds = YES;
    
    self.BatsmanBtn.layer.cornerRadius = 5;
    self.BatsmanBtn.clipsToBounds = YES;
    
    self.WktKeeperBtn.layer.cornerRadius = 5;
    self.WktKeeperBtn.clipsToBounds = YES;
    
    self.AllrounderBtn.layer.cornerRadius = 5;
    self.AllrounderBtn.clipsToBounds = YES;
    
    self.BowlerBtn.layer.cornerRadius = 5;
    self.BowlerBtn.clipsToBounds = YES;
    
    [self addRefreshControl];

//    AllrounderBtn.align
    
    NSString* str_wkt_keeper = [NSString stringWithFormat:@"Wkt\n Keeper"];
    NSString* str_all_rounder = [NSString stringWithFormat:@"All\n Rounder"];
    [AllrounderBtn setTitle:str_all_rounder forState:UIControlStateNormal];
    [WktKeeperBtn setTitle:str_wkt_keeper forState:UIControlStateNormal];
    AllrounderBtn.titleLabel.numberOfLines = 2;
    WktKeeperBtn.titleLabel.numberOfLines = 2;
    AllrounderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    WktKeeperBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self TeamsWebservice];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)addRefreshControl
{
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.playesTable addSubview:refreshControl];
    self.playesTable.alwaysBounceVertical = YES;
}


-(void)refershControlAction
{
    [self TeamsWebservice];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [navView addSubview:objCustomNavigation.view];
    
    objCustomNavigation.menu_btn.hidden =YES;
                objCustomNavigation.btn_back.hidden =NO;
                [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
}

-(IBAction)didClickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.commonArray.count;
    
    [self.lblNoData setHidden:_CommonArray.count];
    return _CommonArray.count;
}
#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat widthF = self.playesTable.superview.frame.size.width/2;

    if(IS_IPHONE5)
    {
         widthF = self.playesTable.superview.frame.size.width/2;
    }
    else if (IS_IPAD)
    {
        widthF = self.playesTable.superview.frame.size.width/4;
    }
    
    return CGSizeMake(widthF-20, widthF);
    
//    return UICollectionViewFlowLayoutAutomaticSize;
    
//    if(IS_IPHONE_DEVICE)
//    {
//        if(!IS_IPHONE5)
//        {
//            return CGSizeMake(50, 50);
//        }
//        else
//        {
//                return CGSizeMake(130, 178);
//        }
//    }
//    else
//    {
//
//            return CGSizeMake(210, 178);
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
////    if(!IS_IPHONE_DEVICE)
////    {
////        return 20.0;
////    }
////    else{
////        return 10.0;
////    }
    return 10.0;
//
}
//
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
////    if(!IS_IPHONE_DEVICE)
////    {
////        return 23.0;
////    }
////    else{
////        return 10.0;
////    }
//
    return 10.0;
//
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamMemebersCell* cell = [self.playesTable dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    
    NSString *playername = [self checkNull:[[self.CommonArray valueForKey:@"AthleteName"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    
    cell.playernamelbl.text = playername;
    
    NSString *bowlingStyle = [self checkNull:[[self.CommonArray valueForKey:@"BowlingStyle"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    if ([bowlingStyle isEqualToString:@""]) {
        cell.BowlingStylelbl.text = @"";
    } else {
        cell.BowlingStylelbl.text = [NSString stringWithFormat:@"/ %@", bowlingStyle];
    }
    
    NSString *battingStyle = [self checkNull:[[self.CommonArray valueForKey:@"BattingStyle"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    cell.BattingStylelbl.text = battingStyle;
    
    NSString *age = [self checkNull:[[self.CommonArray valueForKey:@"Age"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    cell.agelbl.text = [NSString stringWithFormat:@"%@ Years old",age] ;
    
    NSString *availability = [self checkNull:[[self.CommonArray valueForKey:@"PlayerAvailability"]objectAtIndex:indexPath.row]];
    NSLog(@"%ld",(long)indexPath.row);
    
    [cell.playerImg sd_setImageWithURL:[NSURL URLWithString: [self checkNull:[[self.CommonArray objectAtIndex:indexPath.row] valueForKey:@"AthletePhoto"]]] placeholderImage:[UIImage imageNamed:@"no-image"]];
    
    if([availability isEqualToString:@"Available"])
    {
//       cell.availabilityView.backgroundColor = [UIColor colorWithRed:(142/255.0f) green:(207/255.0f) blue:(100/255.0f) alpha:1.0f] ;
        
        cell.availabilityView.backgroundColor = avail;
    }
    else if([availability isEqualToString:@"Not Available"])
    {
//        cell.availabilityView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(23/255.0f) alpha:1.0f] ;
        
        cell.availabilityView.backgroundColor = notavail;

    }
    else if([availability isEqualToString:@"Rehab"])
    {
//        cell.availabilityView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(190/255.0f) blue:(65/255.0f) alpha:1.0f] ;
        
        cell.availabilityView.backgroundColor = rehab;

    }
    
    cell.availabilityView.layer.cornerRadius = 5;
    cell.availabilityView.clipsToBounds = YES;

    
        cell.contentView.layer.cornerRadius = 2.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;

        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0,0);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
        return cell;
    }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyStatsBattingVC* objStats = [MyStatsBattingVC new];
    objStats.selectedPlayerCode = [[self.CommonArray objectAtIndex:indexPath.item] valueForKey:@"AthleteCode"];
    objStats.selectedPlayerName = [[self.CommonArray objectAtIndex:indexPath.item] valueForKey:@"AthleteName"];
//    [objStats viewDidLoad];
//    objStats.myStatsViewHeight.constant = 60;
//    objStats.navViewHeight.constant = 35;
//    objStats.view.frame = CGRectMake(0, 0, objStats.view.frame.size.width, objStats.view.frame.size.height);
    [appDel.frontNavigationController pushViewController:objStats animated:YES];
    
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


-(void)TeamsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
    
    [refreshControl endRefreshing];
        [AppCommon showLoading];
        
        NSString *URLString =  URL_FOR_RESOURCE(playersKey);
                                

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
    
        NSString *ClientCode = [AppCommon GetClientCode];
        NSString *UserrefCode = [AppCommon GetuserReference];
//        NSString *TeamCode = [AppCommon getCurrentTeamCode]; // APT teamcode

        NSString *TeamCode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"APTTeamcode"];

        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"Userreferencecode"];
        if(TeamCode)   [dic    setObject:TeamCode     forKey:@"Teamcode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                self.PlayersArray = [[NSMutableArray alloc]init];
                self.PlayersArray = [responseObject valueForKey:@"lstPlayerDetails"];
                
                self.PlayerRoleArray = [[NSMutableArray alloc]init];
                self.PlayerRoleArray = [responseObject valueForKey:@"lstPlayerRoles"];
            
                [self.playesTable reloadData];
                [self.AllBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            }
            
            [AppCommon hideLoading];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [refreshControl endRefreshing];
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
        }];
    
}

- (IBAction)backBtnAction:(id)sender
{
    [self.view removeFromSuperview];
}

- (IBAction)AllBtnAction:(id)sender
{
    [self setInningsBySelection:@"1"];
    
    self.CommonArray = [[NSMutableArray alloc]init];
    self.CommonArray = self.PlayersArray;
    
    [self.playesTable reloadData];
    
}

- (IBAction)BatsmanBtnAction:(id)sender
{
    [self setInningsBySelection:@"2"];
    self.CommonArray = [[NSMutableArray alloc]init];
    NSString *playerRole = @"MSC007";
    
    for(int i=0;i<self.PlayersArray.count;i++)
    {
        if([playerRole isEqualToString:[[self.PlayersArray valueForKey:@"PlayerRole"]objectAtIndex:i]])
        {
            [self.CommonArray addObject:[self.PlayersArray objectAtIndex:i]];
        }
    }
    
    [self.playesTable reloadData];
    
}

- (IBAction)WktKeeperBtnAction:(id)sender
{
    [self setInningsBySelection:@"3"];
    self.CommonArray = [[NSMutableArray alloc]init];
    
    NSString *playerRole = @"MSC010";
    for(int i=0;i<self.PlayersArray.count;i++)
    {
        if([playerRole isEqualToString:[[self.PlayersArray valueForKey:@"PlayerRole"]objectAtIndex:i]])
        {
            [self.CommonArray addObject:[self.PlayersArray objectAtIndex:i]];
        }
    }
    
    
    [self.playesTable reloadData];
    
}

- (IBAction)AllrounderBtnAction:(id)sender
{
    [self setInningsBySelection:@"4"];
    self.CommonArray = [[NSMutableArray alloc]init];
    NSString *playerRole = @"MSC009";
    for(int i=0;i<self.PlayersArray.count;i++)
    {
        if([playerRole isEqualToString:[[self.PlayersArray valueForKey:@"PlayerRole"]objectAtIndex:i]])
        {
            [self.CommonArray addObject:[self.PlayersArray objectAtIndex:i]];
        }
    }
    
    [self.playesTable reloadData];
    
}

- (IBAction)BowlerBtnAction:(id)sender
{
   [self setInningsBySelection:@"5"];
    self.CommonArray = [[NSMutableArray alloc]init];
    
    NSString *playerRole = @"MSC008";
    for(int i=0;i<self.PlayersArray.count;i++)
    {
        if([playerRole isEqualToString:[[self.PlayersArray valueForKey:@"PlayerRole"]objectAtIndex:i]])
        {
            [self.CommonArray addObject:[self.PlayersArray objectAtIndex:i]];
        }
    }
    
    [self.playesTable reloadData];
    
}

-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.AllBtn];
    [self setInningsButtonUnselect:self.BatsmanBtn];
    [self setInningsButtonUnselect:self.WktKeeperBtn];
    [self setInningsButtonUnselect:self.AllrounderBtn];
    [self setInningsButtonUnselect:self.BowlerBtn];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.AllBtn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.BatsmanBtn];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.WktKeeperBtn];
    }
    else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.AllrounderBtn];
    }
    else if([innsNo isEqualToString:@"5"]){
        
        [self setInningsButtonSelect:self.BowlerBtn];
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
