//
//  MCTeamCompVC.m
//  APT_V2
//
//  Created by apple on 14/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "MCTeamCompVC.h"
#import "MCTeamCompCVC.h"
#import "CustomNavigation.h"
//#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "MCTeamPlayersCompCell.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MCTeamCompVC () <selectedDropDown>
{
    //    NSString *BatsmenCount;
    //    NSString *BowlerCount;
    //    NSString *AllroundCount;
    
    BOOL isComp;
    BOOL isTeam;
    WebService *objWebservice;
    
    
}


@property (strong, nonatomic)  NSMutableArray *BowlersArray;
@property (strong, nonatomic)  NSMutableArray *BatsmenArray;
@property (strong, nonatomic)  NSMutableArray *AllrounderArray;


@property (strong, nonatomic)  NSMutableArray *TeamPlayersArray1;
@property (strong, nonatomic)  NSMutableArray *TeamPlayersArray2;
@property (strong, nonatomic)  NSMutableArray *TeamPlayersArray3;
@property (strong, nonatomic)  NSMutableArray *TeamPlayersArray4;
@property (strong, nonatomic)  NSMutableArray *TeamPlayersArray5;

@property (strong, nonatomic)  NSMutableArray *MatchResultsArray1;
@property (strong, nonatomic)  NSMutableArray *MatchResultsArray2;
@property (strong, nonatomic)  NSMutableArray *MatchResultsArray3;
@property (strong, nonatomic)  NSMutableArray *MatchResultsArray4;
@property (strong, nonatomic)  NSMutableArray *MatchResultsArray5;

@property (strong, nonatomic)  NSMutableArray *replaceArray1;
@property (strong, nonatomic)  NSMutableArray *replaceArray2;
@property (strong, nonatomic)  NSMutableArray *replaceArray3;
@property (strong, nonatomic)  NSMutableArray *replaceArray4;
@property (strong, nonatomic)  NSMutableArray *replaceArray5;

@property (strong, nonatomic)  NSMutableArray *outPlayersArray;


@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;


@end

@implementation MCTeamCompVC
@synthesize Teamnamelbl,Competitionlbl;

@synthesize dropviewComp1,dropviewComp2;


- (void)viewDidLoad {
    [super viewDidLoad];
    objWebservice = [[WebService alloc]init];
    
    
    //    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
    //    NSString *plyRolecode = @"ROL0000002";
    //
    //    if([rolecode isEqualToString:plyRolecode])
    //    {
    //        self.dropviewComp2.hidden = YES;
    //    }
    //    else
    //    {
    //        self.dropviewComp2.hidden = NO;
    //    }
    
    // [self.dropviewComp2 setHidden:![AppCommon isCoach]];
    
    [self.teamCompCollectionView registerNib:[UINib nibWithNibName:@"MCTeamCompCVC" bundle:nil] forCellWithReuseIdentifier:@"mcTeamCompCVC"];
    
    [self.BowlerCollectionView registerNib:[UINib nibWithNibName:@"MCTeamPlayersCompCell" bundle:nil] forCellWithReuseIdentifier:@"CompCell"];
    [self.BatsmenCollectionView
     registerNib:[UINib nibWithNibName:@"MCTeamPlayersCompCell" bundle:nil] forCellWithReuseIdentifier:@"CompCell"];
    [self.AllrounderCollectionView registerNib:[UINib nibWithNibName:@"MCTeamPlayersCompCell" bundle:nil] forCellWithReuseIdentifier:@"CompCell"];
    
    self.PopTableView.hidden = YES;
    
    Competitionlbl.text = [AppCommon getCurrentCompetitionName];
    Teamnamelbl.text = [AppCommon getCurrentTeamName];
    
    //    CompetitionCode = [AppCommon getCurrentCompetitionCode];
    //    teamcode = [AppCommon getCurrentTeamCode];
    
    [self TeamWebservice];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headerView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Team Comp";
    objCustomNavigation.btn_back.hidden = YES;
    objCustomNavigation.home_btn.hidden = YES;
    objCustomNavigation.menu_btn.hidden =NO;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.teamCompCollectionView){
        return self.TeamPlayersArray1.count;
    }
    else if(collectionView == self.BowlerCollectionView)
    {
        return self.BowlersArray.count;
    }
    else if(collectionView == self.BatsmenCollectionView)
    {
        return self.BatsmenArray.count;
    }
    else if(collectionView == self.AllrounderCollectionView)
    {
        return self.AllrounderArray.count;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CGFloat widthF = (self.BowlerCollectionView.superview.frame.size.width/3) - 20;
    CGFloat HeightF = self.BowlerCollectionView.superview.frame.size.height-20;
    
    
    //    if(IS_IPHONE_DEVICE)
    //    {
    //        if(!IS_IPHONE5)
    //        {
    //            return CGSizeMake(50, 50);
    //        }
    //        else
    //        {
    //            if(collectionView == self.teamCompCollectionView)
    //            {
    //                return CGSizeMake(290, 825);
    //            }
    //            else
    //            {
    //                return CGSizeMake(250, 130);
    //            }
    //        }
    //    }
    //    else
    //    {
    //        //return CGSizeMake(160, 140);
    //
    //        if(collectionView == self.teamCompCollectionView)
    //        {
    //            return CGSizeMake(404, 825);
    //        }
    //        else
    //        {
    //            return CGSizeMake(250, 130);
    //        }
    //    }
    
    
    if(collectionView == self.teamCompCollectionView)
    {
        CGFloat widthF = self.teamCompCollectionView.frame.size.width;
        
        if(self.TeamPlayersArray1.count ==1)
        {
            return CGSizeMake(widthF, 785);
        }
        return (IS_IPAD ? CGSizeMake(300, 785) : CGSizeMake(290, 785) );
    }
    else
    {
        return  CGSizeMake(widthF, HeightF);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    //    if(collectionView == self.teamCompCollectionView)
    //    {
    //        if(!IS_IPHONE_DEVICE)
    //        {
    //            return UIEdgeInsetsMake(10, 20, 10, 20); // top, left, bottom, right
    //        }
    //        else{
    //            return UIEdgeInsetsMake(10, 10, 10, 10);
    //        }
    //
    //    }
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(collectionView == self.teamCompCollectionView){
        
        
        
        MCTeamCompCVC * cell = [self.teamCompCollectionView dequeueReusableCellWithReuseIdentifier:@"mcTeamCompCVC" forIndexPath:indexPath];
        
        NSMutableArray *reqArray = [[NSMutableArray alloc]init];
        [reqArray addObjectsFromArray:[[self.TeamPlayersArray1 valueForKey:@"MatchTeamPlayers"]objectAtIndex:indexPath.row]];
        
        if(reqArray.count>0 && ![reqArray isEqual:[NSNull null]])
        {
            cell.datelbl.text = [[reqArray valueForKey:@"MatchDate"]objectAtIndex:0];
            NSString *team =[[reqArray valueForKey:@"TeamName"]objectAtIndex:0];
            NSString *venue =[[reqArray valueForKey:@"Venue"]objectAtIndex:0];
            cell.TeamVenuelbl.text = [NSString stringWithFormat:@"%@(%@)",team,venue];
            
            
            //NSString *wonstatus =[[self.TeamPlayersArray1 valueForKey:@"Comments"]objectAtIndex:0];
            //NSString *WonTeamname =[[self.TeamPlayersArray1 valueForKey:@"MatchWon"]objectAtIndex:0];
            //cell.WonStatuslbl.text = [NSString stringWithFormat:@"%@ %@",WonTeamname,wonstatus];
            
            cell.WonStatuslbl.text = [[self.MatchResultsArray1 valueForKey:@"MatchResult"]objectAtIndex:indexPath.row];
            NSString *  BowlerCount ;
            if([[[self.MatchResultsArray1 valueForKey:@"Bowlingcount"]objectAtIndex:indexPath.row] isKindOfClass:[NSNumber class]])
            {
                NSNumber *vv = [[self.MatchResultsArray1 valueForKey:@"Bowlingcount"]objectAtIndex:indexPath.row];
                BowlerCount = [vv stringValue];
            }
            else
            {
                BowlerCount = [[self.MatchResultsArray1 valueForKey:@"Bowlingcount"]objectAtIndex:indexPath.row];
            }
            
            
            NSString * BatsmenCount;
            if([[[self.MatchResultsArray1 valueForKey:@"Battingcount"]objectAtIndex:indexPath.row] isKindOfClass:[NSNumber class]])
            {
                NSNumber *vv = [[self.MatchResultsArray1 valueForKey:@"Battingcount"]objectAtIndex:indexPath.row];
                BatsmenCount = [vv stringValue];
            }
            else
            {
                BatsmenCount = [[self.MatchResultsArray1 valueForKey:@"Battingcount"]objectAtIndex:indexPath.row];
            }
            
            
            NSString * AllroundCount;
            if([[[self.MatchResultsArray1 valueForKey:@"Allroundercount"]objectAtIndex:indexPath.row] isKindOfClass:[NSNumber class]])
            {
                NSNumber *vv = [[self.MatchResultsArray1 valueForKey:@"Allroundercount"]objectAtIndex:indexPath.row];
                AllroundCount = [vv stringValue];
            }
            else
            {
                AllroundCount = [[self.MatchResultsArray1 valueForKey:@"Allroundercount"]objectAtIndex:indexPath.row];
            }
            
            cell.PlayerRoleCountlbl.text = [NSString stringWithFormat:@"Batsmen-%@ Bowlers-%@ AllRounders-%@",BatsmenCount,BowlerCount,AllroundCount];
            
            NSMutableArray *placedArray = [[NSMutableArray alloc]init];
            NSMutableArray *replacedArr = [[NSMutableArray alloc]init];
            replacedArr = [[self.replaceArray1 objectAtIndex:indexPath.row]valueForKey:@"lstplayerstoreplace"];
            for(int i=0;i<replacedArr.count;i++)
            {
                NSString *str = [[replacedArr objectAtIndex:i] valueForKey:@"PlayerName"];
                [placedArray addObject:str];
            }
            
            
            NSMutableArray *outArray = [[NSMutableArray alloc]init];
            NSMutableArray *outplayer = [[NSMutableArray alloc]init];
            outplayer = [[self.replaceArray1 objectAtIndex:indexPath.row]valueForKey:@"lstplayerstoOut"];
            for(int i=0;i<outplayer.count;i++)
            {
                NSString *str = [[outplayer objectAtIndex:i] valueForKey:@"PlayerName"];
                [outArray addObject:str];
            }
            
            if(placedArray.count>0)
            {
                NSString *players = [placedArray componentsJoinedByString:@","];
                cell.replacePlayerslbl.text =[NSString stringWithFormat:@"IN: %@", players];
                cell.replacePlayersCountlbl.text = [NSString stringWithFormat:@"%d",placedArray.count];
            }
            else
            {
                
                cell.replacePlayerslbl.text = @"";
                cell.replacePlayersCountlbl.text = @"-";
            }
            
            if(outArray.count>0)
            {
                NSString *players = [outArray componentsJoinedByString:@","];
                cell.outPlayerslbl.text = [NSString stringWithFormat:@"OUT: %@", players];
            }
            else
            {
                cell.outPlayerslbl.text = @"";
            }
            
            cell.Player1.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:0];
            cell.Player2.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:1];
            cell.Player3.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:2];
            cell.Player4.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:3];
            cell.Player5.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:4];
            cell.Player6.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:5];
            cell.Player7.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:6];
            cell.Player8.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:7];
            cell.Player9.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:8];
            cell.Player10.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:9];
            cell.Player11.text = [[reqArray valueForKey:@"PlayerName"]objectAtIndex:10];
            
            
            
            
            //            NSMutableArray *arr = [[NSMutableArray alloc]init];
            //            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
            //            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            //            for(int i=0;i<self.TeamPlayersArray1.count;i++)
            //            {
            //                NSString *playerrole = [[self.TeamPlayersArray1 valueForKey:@"PlayerRole"]objectAtIndex:i];
            //                if( [playerrole isEqualToString:@"Bowler"])
            //                {
            //                    [arr addObject:[self.TeamPlayersArray1 objectAtIndex:i]];
            //                }
            //                else if( [playerrole isEqualToString:@"Batsman"])
            //                {
            //                    [arr1 addObject:[self.TeamPlayersArray1 objectAtIndex:i]];
            //                }
            //                else if( [playerrole isEqualToString:@"All Rounder"])
            //                {
            //                    [arr2 addObject:[self.TeamPlayersArray1 objectAtIndex:i]];
            //                }
            //            }
            //            NSString *  BowlerCount = [NSString stringWithFormat:@"%d",arr.count];
            //            NSString * BatsmenCount = [NSString stringWithFormat:@"%d",arr1.count];
            //            NSString * AllroundCount = [NSString stringWithFormat:@"%d",arr2.count];
            
            
            
            
            
            
            NSString *playerRole1 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:0];
            if( [playerRole1 isEqualToString:@"Batsman"])
            {
                cell.Player1Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole1 isEqualToString:@"Bowler"])
            {
                cell.Player1Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole1 isEqualToString:@"All Rounder"])
            {
                cell.Player1Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole1 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player1Img.image = [UIImage imageNamed:@"glove"];
            }
            
            
            NSString *playerRole2 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:1];
            if( [playerRole2 isEqualToString:@"Batsman"])
            {
                cell.Player2Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole2 isEqualToString:@"Bowler"])
            {
                cell.Player2Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole2 isEqualToString:@"All Rounder"])
            {
                cell.Player2Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole2 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player2Img.image = [UIImage imageNamed:@"glove"];
            }
            
            
            NSString *playerRole3 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:2];
            if( [playerRole3 isEqualToString:@"Batsman"])
            {
                cell.Player3Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole3 isEqualToString:@"Bowler"])
            {
                cell.Player3Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole3 isEqualToString:@"All Rounder"])
            {
                cell.Player3Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole3 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player3Img.image = [UIImage imageNamed:@"glove"];
            }
            
            
            NSString *playerRole4 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:3];
            if( [playerRole4 isEqualToString:@"Batsman"])
            {
                cell.Player4Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole4 isEqualToString:@"Bowler"])
            {
                cell.Player4Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole4 isEqualToString:@"All Rounder"])
            {
                cell.Player4Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole4 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player4Img.image = [UIImage imageNamed:@"glove"];
            }
            
            NSString *playerRole5 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:4];
            if( [playerRole5 isEqualToString:@"Batsman"])
            {
                cell.Player5Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole5 isEqualToString:@"Bowler"])
            {
                cell.Player5Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole5 isEqualToString:@"All Rounder"])
            {
                cell.Player5Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole5 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player5Img.image = [UIImage imageNamed:@"glove"];
            }
            
            
            NSString *playerRole6 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:5];
            if( [playerRole6 isEqualToString:@"Batsman"])
            {
                cell.Player6Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole6 isEqualToString:@"Bowler"])
            {
                cell.Player6Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole6 isEqualToString:@"All Rounder"])
            {
                cell.Player6Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole6 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player6Img.image = [UIImage imageNamed:@"glove"];
            }
            
            
            NSString *playerRole7 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:6];
            if( [playerRole7 isEqualToString:@"Batsman"])
            {
                cell.Player7Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole7 isEqualToString:@"Bowler"])
            {
                cell.Player7Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole7 isEqualToString:@"All Rounder"])
            {
                cell.Player7Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole7 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player7Img.image = [UIImage imageNamed:@"glove"];
            }
            
            NSString *playerRole8 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:7];
            if( [playerRole8 isEqualToString:@"Batsman"])
            {
                cell.Player8Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole8 isEqualToString:@"Bowler"])
            {
                cell.Player8Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole8 isEqualToString:@"All Rounder"])
            {
                cell.Player8Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole8 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player8Img.image = [UIImage imageNamed:@"glove"];
            }
            
            NSString *playerRole9 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:8];
            if( [playerRole9 isEqualToString:@"Batsman"])
            {
                cell.Player9Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole9 isEqualToString:@"Bowler"])
            {
                cell.Player9Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole9 isEqualToString:@"All Rounder"])
            {
                cell.Player9Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole9 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player9Img.image = [UIImage imageNamed:@"glove"];
            }
            
            NSString *playerRole10 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:9];
            if( [playerRole10 isEqualToString:@"Batsman"])
            {
                cell.Player10Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole10 isEqualToString:@"Bowler"])
            {
                cell.Player10Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole10 isEqualToString:@"All Rounder"])
            {
                cell.Player10Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole10 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player10Img.image = [UIImage imageNamed:@"glove"];
            }
            
            NSString *playerRole11 = [[reqArray valueForKey:@"PlayerRole"]objectAtIndex:10];
            if( [playerRole11 isEqualToString:@"Batsman"])
            {
                cell.Player11Img.image = [UIImage imageNamed:@"bat"];
            }
            else if( [playerRole11 isEqualToString:@"Bowler"])
            {
                cell.Player11Img.image = [UIImage imageNamed:@"ball"];
            }
            else if( [playerRole11 isEqualToString:@"All Rounder"])
            {
                cell.Player11Img.image = [UIImage imageNamed:@"batball"];
            }
            else if( [playerRole11 isEqualToString:@"Wicket Keeper"])
            {
                cell.Player11Img.image = [UIImage imageNamed:@"glove"];
            }
            
        }
        return cell;
        
        //        else if(indexPath.row==1)
        //        {
        //            if(self.TeamPlayersArray2.count>0 && ![self.TeamPlayersArray2 isEqual:[NSNull null]])
        //            {
        //            cell.datelbl.text = [[self.TeamPlayersArray2 valueForKey:@"MatchDate"]objectAtIndex:0];
        //            NSString *team =[[self.TeamPlayersArray2 valueForKey:@"TeamName"]objectAtIndex:0];
        //            NSString *venue =[[self.TeamPlayersArray2 valueForKey:@"Venue"]objectAtIndex:0];
        //            cell.TeamVenuelbl.text = [NSString stringWithFormat:@"%@(%@)",team,venue];
        //
        ////            NSString *wonstatus =[[self.TeamPlayersArray2 valueForKey:@"Comments"]objectAtIndex:0];
        ////            NSString *WonTeamname =[[self.TeamPlayersArray2 valueForKey:@"MatchWon"]objectAtIndex:0];
        ////            cell.WonStatuslbl.text = [NSString stringWithFormat:@"%@ %@",WonTeamname,wonstatus];
        //
        //                cell.WonStatuslbl.text = [self.MatchResultsArray2 valueForKey:@"MatchResult"];
        //                NSString *  BowlerCount ;
        //                if([[self.MatchResultsArray2 valueForKey:@"Bowlingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray2 valueForKey:@"Bowlingcount"];
        //                    BowlerCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BowlerCount = [self.MatchResultsArray2 valueForKey:@"Bowlingcount"];
        //                }
        //
        //
        //                NSString * BatsmenCount;
        //                if([[self.MatchResultsArray2 valueForKey:@"Battingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray2 valueForKey:@"Battingcount"];
        //                    BatsmenCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BatsmenCount = [self.MatchResultsArray2 valueForKey:@"Battingcount"];
        //                }
        //
        //
        //                NSString * AllroundCount;
        //                if([[self.MatchResultsArray2 valueForKey:@"Allroundercount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray2 valueForKey:@"Allroundercount"];
        //                    AllroundCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    AllroundCount = [self.MatchResultsArray2 valueForKey:@"Allroundercount"];
        //                }
        //
        //                cell.PlayerRoleCountlbl.text = [NSString stringWithFormat:@"Batsmen-%@ Bowlers-%@ AllRounders-%@",BatsmenCount,BowlerCount,AllroundCount];
        //
        //                NSMutableArray *placedArray = [[NSMutableArray alloc]init];
        //                for(int i=0;i<self.replaceArray2.count;i++)
        //                {
        //                    NSString *str = [[self.replaceArray2 objectAtIndex:i] valueForKey:@"PlayerName"];
        //                    [placedArray addObject:str];
        //                }
        //                if(placedArray.count>0)
        //                {
        //                NSString *players = [placedArray componentsJoinedByString:@","];
        //                cell.replacePlayerslbl.text = players;
        //                }
        //                else
        //                {
        //                    cell.replacePlayerslbl.text = @"";
        //                }
        //
        //            cell.Player1.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:0];
        //            cell.Player2.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:1];
        //            cell.Player3.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:2];
        //            cell.Player4.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:3];
        //            cell.Player5.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:4];
        //            cell.Player6.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:5];
        //            cell.Player7.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:6];
        //            cell.Player8.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:7];
        //            cell.Player9.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:8];
        //            cell.Player10.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:9];
        //            cell.Player11.text = [[self.TeamPlayersArray2 valueForKey:@"PlayerName"]objectAtIndex:10];
        //
        //
        //
        ////            NSMutableArray *arr = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        ////            for(int i=0;i<self.TeamPlayersArray2.count;i++)
        ////            {
        ////                NSString *playerrole = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:i];
        ////                if( [playerrole isEqualToString:@"Bowler"])
        ////                {
        ////                    [arr addObject:[self.TeamPlayersArray2 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"Batsman"])
        ////                {
        ////                    [arr1 addObject:[self.TeamPlayersArray2 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"All Rounder"])
        ////                {
        ////                    [arr2 addObject:[self.TeamPlayersArray2 objectAtIndex:i]];
        ////                }
        ////            }
        ////            NSString *  BowlerCount = [NSString stringWithFormat:@"%d",arr.count];
        ////            NSString * BatsmenCount = [NSString stringWithFormat:@"%d",arr1.count];
        ////            NSString * AllroundCount = [NSString stringWithFormat:@"%d",arr2.count];
        //
        //
        //
        //
        //
        //            NSString *playerRole1 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:0];
        //            if( [playerRole1 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole2 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:1];
        //            if( [playerRole2 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole3 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:2];
        //            if( [playerRole3 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole4 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:3];
        //            if( [playerRole4 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole5 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:4];
        //            if( [playerRole5 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole6 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:5];
        //            if( [playerRole6 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole7 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:6];
        //            if( [playerRole7 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole8 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:7];
        //            if( [playerRole8 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole9 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:8];
        //            if( [playerRole9 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole10 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:9];
        //            if( [playerRole10 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole11 = [[self.TeamPlayersArray2 valueForKey:@"PlayerRole"]objectAtIndex:10];
        //            if( [playerRole11 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //        }
        //            return cell;
        //        }
        //        else if(indexPath.row==2)
        //        {
        //            if(self.TeamPlayersArray3.count>0 && ![self.TeamPlayersArray3 isEqual:[NSNull null]])
        //            {
        //
        //            cell.datelbl.text = [[self.TeamPlayersArray3 valueForKey:@"MatchDate"]objectAtIndex:0];
        //            NSString *team =[[self.TeamPlayersArray3 valueForKey:@"TeamName"]objectAtIndex:0];
        //            NSString *venue =[[self.TeamPlayersArray3 valueForKey:@"Venue"]objectAtIndex:0];
        //            cell.TeamVenuelbl.text = [NSString stringWithFormat:@"%@(%@)",team,venue];
        //
        ////            NSString *wonstatus =[[self.TeamPlayersArray3 valueForKey:@"Comments"]objectAtIndex:0];
        ////            NSString *WonTeamname =[[self.TeamPlayersArray3 valueForKey:@"MatchWon"]objectAtIndex:0];
        ////            cell.WonStatuslbl.text = [NSString stringWithFormat:@"%@ %@",WonTeamname,wonstatus];
        //
        //                cell.WonStatuslbl.text = [self.MatchResultsArray3 valueForKey:@"MatchResult"];
        //                NSString *  BowlerCount ;
        //                if([[self.MatchResultsArray3 valueForKey:@"Bowlingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray3 valueForKey:@"Bowlingcount"];
        //                    BowlerCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BowlerCount = [self.MatchResultsArray3 valueForKey:@"Bowlingcount"];
        //                }
        //
        //
        //                NSString * BatsmenCount;
        //                if([[self.MatchResultsArray3 valueForKey:@"Battingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray3 valueForKey:@"Battingcount"];
        //                    BatsmenCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BatsmenCount = [self.MatchResultsArray3 valueForKey:@"Battingcount"];
        //                }
        //
        //
        //                NSString * AllroundCount;
        //                if([[self.MatchResultsArray3 valueForKey:@"Allroundercount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray3 valueForKey:@"Allroundercount"];
        //                    AllroundCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    AllroundCount = [self.MatchResultsArray3 valueForKey:@"Allroundercount"];
        //                }
        //
        //
        //                NSMutableArray *placedArray = [[NSMutableArray alloc]init];
        //                for(int i=0;i<self.replaceArray3.count;i++)
        //                {
        //                    NSString *str = [[self.replaceArray3 objectAtIndex:i] valueForKey:@"PlayerName"];
        //                    [placedArray addObject:str];
        //                }
        //                if(placedArray.count>0)
        //                {
        //                    NSString *players = [placedArray componentsJoinedByString:@","];
        //                    cell.replacePlayerslbl.text = players;
        //                }
        //                else
        //                {
        //                    cell.replacePlayerslbl.text = @"";
        //                }
        //
        //            cell.Player1.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:0];
        //            cell.Player2.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:1];
        //            cell.Player3.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:2];
        //            cell.Player4.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:3];
        //            cell.Player5.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:4];
        //            cell.Player6.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:5];
        //            cell.Player7.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:6];
        //            cell.Player8.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:7];
        //            cell.Player9.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:8];
        //            cell.Player10.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:9];
        //            cell.Player11.text = [[self.TeamPlayersArray3 valueForKey:@"PlayerName"]objectAtIndex:10];
        //
        //
        //
        //
        ////            NSMutableArray *arr = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        ////            for(int i=0;i<self.TeamPlayersArray3.count;i++)
        ////            {
        ////                NSString *playerrole = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:i];
        ////                if( [playerrole isEqualToString:@"Bowler"])
        ////                {
        ////                    [arr addObject:[self.TeamPlayersArray3 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"Batsman"])
        ////                {
        ////                    [arr1 addObject:[self.TeamPlayersArray3 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"All Rounder"])
        ////                {
        ////                    [arr2 addObject:[self.TeamPlayersArray3 objectAtIndex:i]];
        ////                }
        ////            }
        ////          NSString *  BowlerCount = [NSString stringWithFormat:@"%d",arr.count];
        ////           NSString * BatsmenCount = [NSString stringWithFormat:@"%d",arr1.count];
        ////           NSString * AllroundCount = [NSString stringWithFormat:@"%d",arr2.count];
        //
        //            cell.PlayerRoleCountlbl.text = [NSString stringWithFormat:@"Batsmen-%@ Bowlers-%@ AllRounders-%@",BatsmenCount,BowlerCount,AllroundCount];
        //
        //
        //
        //            NSString *playerRole1 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:0];
        //            if( [playerRole1 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole2 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:1];
        //            if( [playerRole2 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole3 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:2];
        //            if( [playerRole3 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole4 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:3];
        //            if( [playerRole4 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole5 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:4];
        //            if( [playerRole5 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole6 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:5];
        //            if( [playerRole6 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole7 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:6];
        //            if( [playerRole7 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole8 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:7];
        //            if( [playerRole8 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole9 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:8];
        //            if( [playerRole9 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole10 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:9];
        //            if( [playerRole10 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole11 = [[self.TeamPlayersArray3 valueForKey:@"PlayerRole"]objectAtIndex:10];
        //            if( [playerRole11 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //        }
        //            return cell;
        //        }
        //       else if(indexPath.row==3)
        //        {
        //            if(self.TeamPlayersArray4.count>0 && ![self.TeamPlayersArray4 isEqual:[NSNull null]])
        //            {
        //            cell.datelbl.text = [[self.TeamPlayersArray4 valueForKey:@"MatchDate"]objectAtIndex:0];
        //            NSString *team =[[self.TeamPlayersArray4 valueForKey:@"TeamName"]objectAtIndex:0];
        //            NSString *venue =[[self.TeamPlayersArray4 valueForKey:@"Venue"]objectAtIndex:0];
        //            cell.TeamVenuelbl.text = [NSString stringWithFormat:@"%@(%@)",team,venue];
        //
        ////            NSString *wonstatus =[[self.TeamPlayersArray4 valueForKey:@"Comments"]objectAtIndex:0];
        ////            NSString *WonTeamname =[[self.TeamPlayersArray4 valueForKey:@"MatchWon"]objectAtIndex:0];
        ////            cell.WonStatuslbl.text = [NSString stringWithFormat:@"%@ %@",WonTeamname,wonstatus];
        //
        //
        //                cell.WonStatuslbl.text = [self.MatchResultsArray4 valueForKey:@"MatchResult"];
        //                NSString *  BowlerCount ;
        //                if([[self.MatchResultsArray4 valueForKey:@"Bowlingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray4 valueForKey:@"Bowlingcount"];
        //                    BowlerCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BowlerCount = [self.MatchResultsArray4 valueForKey:@"Bowlingcount"];
        //                }
        //
        //
        //                NSString * BatsmenCount;
        //                if([[self.MatchResultsArray4 valueForKey:@"Battingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray4 valueForKey:@"Battingcount"];
        //                    BatsmenCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BatsmenCount = [self.MatchResultsArray4 valueForKey:@"Battingcount"];
        //                }
        //
        //
        //                NSString * AllroundCount;
        //                if([[self.MatchResultsArray4 valueForKey:@"Allroundercount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray4 valueForKey:@"Allroundercount"];
        //                    AllroundCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    AllroundCount = [self.MatchResultsArray4 valueForKey:@"Allroundercount"];
        //                }
        //
        //                cell.PlayerRoleCountlbl.text = [NSString stringWithFormat:@"Batsmen-%@ Bowlers-%@ AllRounders-%@",BatsmenCount,BowlerCount,AllroundCount];
        //
        //
        //
        //                NSMutableArray *placedArray = [[NSMutableArray alloc]init];
        //                for(int i=0;i<self.replaceArray4.count;i++)
        //                {
        //                    NSString *str = [[self.replaceArray4 objectAtIndex:i] valueForKey:@"PlayerName"];
        //                    [placedArray addObject:str];
        //                }
        //                if(placedArray.count>0)
        //                {
        //                    NSString *players = [placedArray componentsJoinedByString:@","];
        //                    cell.replacePlayerslbl.text = players;
        //                }
        //                else
        //                {
        //                    cell.replacePlayerslbl.text = @"";
        //                }
        //
        //            cell.Player1.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:0];
        //            cell.Player2.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:1];
        //            cell.Player3.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:2];
        //            cell.Player4.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:3];
        //            cell.Player5.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:4];
        //            cell.Player6.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:5];
        //            cell.Player7.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:6];
        //            cell.Player8.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:7];
        //            cell.Player9.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:8];
        //            cell.Player10.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:9];
        //            cell.Player11.text = [[self.TeamPlayersArray4 valueForKey:@"PlayerName"]objectAtIndex:10];
        //
        //
        ////            NSMutableArray *arr = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        ////            for(int i=0;i<self.TeamPlayersArray4.count;i++)
        ////            {
        ////                NSString *playerrole = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:i];
        ////                if( [playerrole isEqualToString:@"Bowler"])
        ////                {
        ////                    [arr addObject:[self.TeamPlayersArray4 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"Batsman"])
        ////                {
        ////                    [arr1 addObject:[self.TeamPlayersArray4 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"All Rounder"])
        ////                {
        ////                    [arr2 addObject:[self.TeamPlayersArray4 objectAtIndex:i]];
        ////                }
        ////            }
        ////            NSString *  BowlerCount = [NSString stringWithFormat:@"%d",arr.count];
        ////            NSString * BatsmenCount = [NSString stringWithFormat:@"%d",arr1.count];
        ////            NSString * AllroundCount = [NSString stringWithFormat:@"%d",arr2.count];
        //
        //
        //
        //
        //            NSString *playerRole1 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:0];
        //            if( [playerRole1 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole2 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:1];
        //            if( [playerRole2 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole3 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:2];
        //            if( [playerRole3 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole4 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:3];
        //            if( [playerRole4 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole5 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:4];
        //            if( [playerRole5 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole6 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:5];
        //            if( [playerRole6 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole7 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:6];
        //            if( [playerRole7 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole8 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:7];
        //            if( [playerRole8 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole9 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:8];
        //            if( [playerRole9 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole10 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:9];
        //            if( [playerRole10 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole11 = [[self.TeamPlayersArray4 valueForKey:@"PlayerRole"]objectAtIndex:10];
        //            if( [playerRole11 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //        }
        //            return cell;
        //        }
        //        else if(indexPath.row==4)
        //        {
        //            if(self.TeamPlayersArray5.count>0 && ![self.TeamPlayersArray5 isEqual:[NSNull null]])
        //            {
        //
        //            cell.datelbl.text = [[self.TeamPlayersArray5 valueForKey:@"MatchDate"]objectAtIndex:0];
        //            NSString *team =[[self.TeamPlayersArray5 valueForKey:@"TeamName"]objectAtIndex:0];
        //            NSString *venue =[[self.TeamPlayersArray5 valueForKey:@"Venue"]objectAtIndex:0];
        //            cell.TeamVenuelbl.text = [NSString stringWithFormat:@"%@(%@)",team,venue];
        //
        //                cell.WonStatuslbl.text = [self.MatchResultsArray5 valueForKey:@"MatchResult"];
        //
        //
        //                NSString *  BowlerCount ;
        //                if([[self.MatchResultsArray5 valueForKey:@"Bowlingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray5 valueForKey:@"Bowlingcount"];
        //                    BowlerCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BowlerCount = [self.MatchResultsArray5 valueForKey:@"Bowlingcount"];
        //                }
        //
        //
        //                NSString * BatsmenCount;
        //                if([[self.MatchResultsArray5 valueForKey:@"Battingcount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray5 valueForKey:@"Battingcount"];
        //                    BatsmenCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    BatsmenCount = [self.MatchResultsArray5 valueForKey:@"Battingcount"];
        //                }
        //
        //
        //                NSString * AllroundCount;
        //                if([[self.MatchResultsArray5 valueForKey:@"Allroundercount"] isKindOfClass:[NSNumber class]])
        //                {
        //                    NSNumber *vv = [self.MatchResultsArray5 valueForKey:@"Allroundercount"];
        //                    AllroundCount = [vv stringValue];
        //                }
        //                else
        //                {
        //                    AllroundCount = [self.MatchResultsArray5 valueForKey:@"Allroundercount"];
        //                }
        //
        //                cell.PlayerRoleCountlbl.text = [NSString stringWithFormat:@"Batsmen-%@ Bowlers-%@ AllRounders-%@",BatsmenCount,BowlerCount,AllroundCount];
        //
        //
        //
        //                NSMutableArray *placedArray = [[NSMutableArray alloc]init];
        //                for(int i=0;i<self.replaceArray4.count;i++)
        //                {
        //                    NSString *str = [[self.replaceArray4 objectAtIndex:i] valueForKey:@"PlayerName"];
        //                    [placedArray addObject:str];
        //                }
        //                if(placedArray.count>0)
        //                {
        //                    NSString *players = [placedArray componentsJoinedByString:@","];
        //                    cell.replacePlayerslbl.text = players;
        //                }
        //                else
        //                {
        //                    cell.replacePlayerslbl.text = @"";
        //                }
        //
        ////            NSString *wonstatus =[[self.TeamPlayersArray5 valueForKey:@"Comments"]objectAtIndex:0];
        ////            NSString *WonTeamname =[[self.TeamPlayersArray5 valueForKey:@"MatchWon"]objectAtIndex:0];
        ////            cell.WonStatuslbl.text = [NSString stringWithFormat:@"%@ %@",WonTeamname,wonstatus];
        //
        //            cell.Player1.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:0];
        //            cell.Player2.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:1];
        //            cell.Player3.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:2];
        //            cell.Player4.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:3];
        //            cell.Player5.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:4];
        //            cell.Player6.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:5];
        //            cell.Player7.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:6];
        //            cell.Player8.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:7];
        //            cell.Player9.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:8];
        //            cell.Player10.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:9];
        //            cell.Player11.text = [[self.TeamPlayersArray5 valueForKey:@"PlayerName"]objectAtIndex:10];
        //
        //
        ////            NSMutableArray *arr = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
        ////            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        ////            for(int i=0;i<self.TeamPlayersArray5.count;i++)
        ////            {
        ////                NSString *playerrole = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:i];
        ////                if( [playerrole isEqualToString:@"Bowler"])
        ////                {
        ////                    [arr addObject:[self.TeamPlayersArray5 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"Batsman"])
        ////                {
        ////                    [arr1 addObject:[self.TeamPlayersArray5 objectAtIndex:i]];
        ////                }
        ////                else if( [playerrole isEqualToString:@"All Rounder"])
        ////                {
        ////                    [arr2 addObject:[self.TeamPlayersArray5 objectAtIndex:i]];
        ////                }
        ////            }
        ////            NSString *  BowlerCount = [NSString stringWithFormat:@"%d",arr.count];
        ////            NSString * BatsmenCount = [NSString stringWithFormat:@"%d",arr1.count];
        ////            NSString * AllroundCount = [NSString stringWithFormat:@"%d",arr2.count];
        ////
        //
        //
        //
        //            NSString *playerRole1 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:0];
        //            if( [playerRole1 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole1 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player1Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole2 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:1];
        //            if( [playerRole2 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole2 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player2Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole3 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:2];
        //            if( [playerRole3 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole3 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player3Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole4 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:3];
        //            if( [playerRole4 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole4 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player4Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole5 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:4];
        //            if( [playerRole5 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole5 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player5Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole6 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:5];
        //            if( [playerRole6 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole6 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player6Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //
        //            NSString *playerRole7 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:6];
        //            if( [playerRole7 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole7 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player7Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole8 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:7];
        //            if( [playerRole8 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole8 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player8Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole9 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:8];
        //            if( [playerRole9 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole9 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player9Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole10 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:9];
        //            if( [playerRole10 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole10 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player10Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //
        //            NSString *playerRole11 = [[self.TeamPlayersArray5 valueForKey:@"PlayerRole"]objectAtIndex:10];
        //            if( [playerRole11 isEqualToString:@"Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"bat"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Bowler"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"ball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"All Rounder"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"batball"];
        //            }
        //            else if( [playerRole11 isEqualToString:@"Wicket Keeper Batsman"])
        //            {
        //                cell.Player11Img.image = [UIImage imageNamed:@"glove"];
        //            }
        //        }
        //            return cell;
        //        }
        
        
    }
    
    else if(collectionView == self.BowlerCollectionView){
        
        
        
        MCTeamPlayersCompCell * cell = [self.BowlerCollectionView dequeueReusableCellWithReuseIdentifier:@"CompCell" forIndexPath:indexPath];
        
        cell.PlayerRole.text = [[self.BowlersArray valueForKey:@"BowlingType"]objectAtIndex:indexPath.row];
        if( [cell.PlayerRole.text isEqualToString:@"Spin"])
        {
            cell.colorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(177/255.0f) blue:(234/255.0f) alpha:1.0f];
        }
        else
        {
            cell.colorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(215/255.0f) blue:(120/255.0f) alpha:1.0f];
        }
        
        cell.PlayerName.text = [[self.BowlersArray valueForKey:@"PlayerName"]objectAtIndex:indexPath.row];
        
        cell.PlayerStyle.text = [[self.BowlersArray valueForKey:@"BowlingStyle"]objectAtIndex:indexPath.row];
        
        NSString * photourl = [NSString stringWithFormat:@"%@",[[self.BowlersArray valueForKey:@"PlayerPhoto"]objectAtIndex:indexPath.row]];
        
        //        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
        //            if (succeeded) {
        //                // change the image in the cell
        //                cell.PlayerImg.image = image;
        //
        //                // cache the image for use later (when scrolling up)
        //                cell.PlayerImg.image = image;
        //            }
        //            else
        //            {
        //                cell.PlayerImg.image = [UIImage imageNamed:@"no-image"];
        //            }
        //        }];
        [cell.PlayerImg sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
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
        
        return cell;
        
    }
    
    else if(collectionView == self.BatsmenCollectionView){
        
        
        
        MCTeamPlayersCompCell * cell = [self.BatsmenCollectionView dequeueReusableCellWithReuseIdentifier:@"CompCell" forIndexPath:indexPath];
        
        
        cell.PlayerRole.text = [[self.BatsmenArray valueForKey:@"BattingOrder"]objectAtIndex:indexPath.row];
        
        if( [cell.PlayerRole.text isEqualToString:@"Top"])
        {
            cell.colorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(177/255.0f) blue:(234/255.0f) alpha:1.0f];
        }
        else
        {
            cell.colorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(215/255.0f) blue:(120/255.0f) alpha:1.0f];
        }
        
        cell.PlayerName.text = [[self.BatsmenArray valueForKey:@"PlayerName"]objectAtIndex:indexPath.row];
        
        cell.PlayerStyle.text = [[self.BatsmenArray valueForKey:@"BattingStyle"]objectAtIndex:indexPath.row];
        
        NSString * photourl = [NSString stringWithFormat:@"%@",[[self.BatsmenArray valueForKey:@"PlayerPhoto"]objectAtIndex:indexPath.row]];
        
        //        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
        //            if (succeeded) {
        //                // change the image in the cell
        //                cell.PlayerImg.image = image;
        //
        //                // cache the image for use later (when scrolling up)
        //                cell.PlayerImg.image = image;
        //            }
        //            else
        //            {
        //                cell.PlayerImg.image = [UIImage imageNamed:@"no-image"];
        //            }
        //        }];
        [cell.PlayerImg sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
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
        
        return cell;
        
    }
    else if(collectionView == self.AllrounderCollectionView){
        
        
        
        MCTeamPlayersCompCell * cell = [self.AllrounderCollectionView dequeueReusableCellWithReuseIdentifier:@"CompCell" forIndexPath:indexPath];
        
        
        
        
        NSString *value1 = [[self.AllrounderArray valueForKey:@"BattingOrder"]objectAtIndex:indexPath.row];
        if( [value1 isEqualToString:@"Top"])
        {
            cell.colorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(177/255.0f) blue:(234/255.0f) alpha:1.0f];
        }
        else
        {
            cell.colorView.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(215/255.0f) blue:(120/255.0f) alpha:1.0f];
        }
        NSString *value2 = [[self.AllrounderArray valueForKey:@"BowlingType"]objectAtIndex:indexPath.row];
        cell.PlayerRole.text = [NSString stringWithFormat:@"%@-%@",value1,value2];
        
        cell.PlayerName.text = [[self.AllrounderArray valueForKey:@"PlayerName"]objectAtIndex:indexPath.row];
        
        NSString *value3 = [[self.AllrounderArray valueForKey:@"BattingStyle"]objectAtIndex:indexPath.row];
        NSString *value4 = [[self.AllrounderArray valueForKey:@"BowlingStyle"]objectAtIndex:indexPath.row];
        
        cell.PlayerStyle.text = [NSString stringWithFormat:@"%@/%@",value3,value4];
        
        NSString * photourl = [NSString stringWithFormat:@"%@",[[self.AllrounderArray valueForKey:@"PlayerPhoto"]objectAtIndex:indexPath.row]];
        
        //        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
        //            if (succeeded) {
        //                // change the image in the cell
        //                cell.PlayerImg.image = image;
        //
        //                // cache the image for use later (when scrolling up)
        //                cell.PlayerImg.image = image;
        //            }
        //            else
        //            {
        //                cell.PlayerImg.image = [UIImage imageNamed:@"no-image"];
        //            }
        //        }];
        [cell.PlayerImg sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        
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
        
        return cell;
        
    }
    return nil;
    
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

-(void)TeamWebservice
{
    
    if(![COMMON isInternetReachable]) {
        return;
        
    }
    else if ([Competitionlbl.text isEqualToString:@"Competetion Name"]) {
        
        return;
    }
    else if([AppCommon isCoach] && [Teamnamelbl.text isEqualToString:@"Team Name"])
    {
        return;
    }
    
    
    
    [AppCommon showLoading ];
    
    
    NSString *teamcode = [AppCommon getCurrentTeamCode];
    
    NSString *CompetitionCode = [AppCommon getCurrentCompetitionCode];
    
    
    
    [objWebservice TeamComposition :TeamCompoKey :CompetitionCode :teamcode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            
            NSMutableArray *arrayFromResponse = [[NSMutableArray alloc]init];
            arrayFromResponse = [responseObject valueForKey:@"lstplayercomp1"];
            
            self.BowlersArray = [[NSMutableArray alloc]init];
            self.BatsmenArray = [[NSMutableArray alloc]init];
            self.AllrounderArray = [[NSMutableArray alloc]init];
            
            for(int i=0;i<arrayFromResponse.count;i++)
            {
                NSString *playerrole = [[arrayFromResponse valueForKey:@"PlayerRole"]objectAtIndex:i];
                
                if([playerrole isEqualToString:@"Bowler"])
                {
                    [self.BowlersArray addObject:[arrayFromResponse objectAtIndex:i]];
                }
                else if([playerrole isEqualToString:@"Batsman"])
                {
                    [self.BatsmenArray addObject:[arrayFromResponse objectAtIndex:i]];
                }
                else if([playerrole isEqualToString:@"All Rounder"])
                {
                    [self.AllrounderArray addObject:[arrayFromResponse objectAtIndex:i]];
                }
                
            }
            
            self.TeamPlayersArray1 = [[NSMutableArray alloc]init];
            self.TeamPlayersArray2 = [[NSMutableArray alloc]init];
            self.TeamPlayersArray3 = [[NSMutableArray alloc]init];
            self.TeamPlayersArray4 = [[NSMutableArray alloc]init];
            self.TeamPlayersArray5 = [[NSMutableArray alloc]init];
            // lstplayerMatchComp
            
            NSMutableArray *teamArray = [[NSMutableArray alloc]init];
            
            if(![[responseObject valueForKey:@"lstplayerMatchComp"] isKindOfClass:NULL])
            {
                teamArray = [responseObject valueForKey:@"lstplayerMatchComp"];
                if(![teamArray isKindOfClass:NULL] && teamArray.count>0)
                {
                    
                    for(int i =0;i<teamArray.count;i++)
                    {
                        if(![[teamArray  objectAtIndex:i] isKindOfClass:NULL])
                        {
                            NSMutableArray *checkValues = [[NSMutableArray alloc]init];
                            if(![[[teamArray  objectAtIndex:i] valueForKey:@"MatchTeamPlayers"] isKindOfClass:NULL])
                            {
                                checkValues = [[teamArray  objectAtIndex:i] valueForKey:@"MatchTeamPlayers"];
                                if(checkValues.count>0)
                                {
                                    [self.TeamPlayersArray1 addObject:[teamArray  objectAtIndex:i]];
                                }
                            }
                        }
                    }
                    
                    
                }
                
            }
            //[self.teamCompCollectionView reloadData];
            
            self.MatchResultsArray1 = [[NSMutableArray alloc]init];
            self.MatchResultsArray2 = [[NSMutableArray alloc]init];
            self.MatchResultsArray3 = [[NSMutableArray alloc]init];
            self.MatchResultsArray4 = [[NSMutableArray alloc]init];
            self.MatchResultsArray5 = [[NSMutableArray alloc]init];
            if(![[responseObject valueForKey:@"lstTeamCompResults"] isKindOfClass:NULL])
            {
                
                
                NSMutableArray *arrayResults = [[NSMutableArray alloc]init];
                arrayResults = [responseObject valueForKey:@"lstTeamCompResults"];
                
                for(int i =0;i<arrayResults.count;i++)
                {
                    if(![[arrayResults objectAtIndex:i] isKindOfClass:NULL])
                    {
                        [self.MatchResultsArray1 addObject:[arrayResults objectAtIndex:i]];
                    }
                }
                
                
            }
            
            self.replaceArray1 = [[NSMutableArray alloc]init];
            self.replaceArray2 = [[NSMutableArray alloc]init];
            self.replaceArray3 = [[NSMutableArray alloc]init];
            self.replaceArray4 = [[NSMutableArray alloc]init];
            self.replaceArray5 = [[NSMutableArray alloc]init];
            if(![[responseObject valueForKey:@"lstTeamplayercompReplaces"] isKindOfClass:NULL])
            {
                NSMutableArray *replArray = [[NSMutableArray alloc]init];
                replArray = [responseObject valueForKey:@"lstTeamplayercompReplaces"];
                
                
                for(int i =0;i<replArray.count;i++)
                {
                    if(![[replArray objectAtIndex:i] isKindOfClass:NULL])
                    {
                        [self.replaceArray1 addObject:[replArray objectAtIndex:i]];
                    }
                }
            }
            
            //[self.teamCompCollectionView reloadData];
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [self.teamCompCollectionView reloadData];
            //            });
            
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            [self.BowlerCollectionView reloadData];
            [self.BatsmenCollectionView reloadData];
            [self.AllrounderCollectionView reloadData];
            [self.teamCompCollectionView reloadData];
            // });
        }
        [AppCommon hideLoading];
        
    }
                            failure:^(AFHTTPRequestOperation *operation, id error) {
                                NSLog(@"failed");
                                [COMMON webServiceFailureError:error];
                            }];
    
}
- (IBAction)onClickCompetitionBtn:(id)sender
{
    isComp = YES;
    isTeam = NO;
    self.PopTableView.hidden = NO;
    
    self.tableWidth.constant = self.dropviewComp1.frame.size.width;
    self.tableXposition.constant = self.dropviewComp1.frame.origin.x;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = appDel.ArrayCompetition;
    
    [self.PopTableView reloadData];
   
}

- (IBAction)onClickTeamBtn:(id)sender
{
    isComp = NO;
    isTeam = YES;
    self.PopTableView.hidden = NO;
    self.tableWidth.constant = self.dropviewComp2.frame.size.width;
    self.tableXposition.constant = self.dropviewComp2.frame.origin.x;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = appDel.ArrayTeam;
    
    [self.PopTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isComp==YES)
    {
        return appDel.ArrayCompetition.count;
    }
    else if(isTeam==YES)
    {
        return appDel.ArrayTeam.count;
    }
    return nil;
}
// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *MyIdentifier = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    if(isComp==YES)
    {
        cell.textLabel.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
    }
    else if(isTeam==YES)
    {
        cell.textLabel.text = [[appDel.ArrayTeam valueForKey:@"TeamName"]objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.contentView.backgroundColor = [UIColor lightTextColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isComp==YES)
    {
        
        self.PopTableView.hidden = YES;
        self.Competitionlbl.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
        NSString *selectedCode = [[appDel.ArrayCompetition valueForKey:@"CompetitionCode"]objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setValue:Competitionlbl.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:selectedCode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self TeamWebservice];
    }
    else if(isTeam==YES)
    {
        
        self.PopTableView.hidden = YES;
        self.Teamnamelbl.text = [[appDel.ArrayTeam valueForKey:@"TeamName"]objectAtIndex:indexPath.row];
        NSString *selectedCode = [[appDel.ArrayTeam valueForKey:@"TeamCode"]objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setValue:Teamnamelbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:selectedCode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self TeamWebservice];
    }
    
    
}



- (IBAction)actionCompetetionTeam:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    if ([sender tag] == 1) { // TEAM
        
        dropVC.array = [COMMON getCorrespondingTeamName:Competitionlbl.text];
        dropVC.key = @"TeamName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(dropviewComp2.frame), CGRectGetMaxY(dropviewComp2.superview.frame)+60, CGRectGetWidth(dropviewComp2.frame), 300)];
        
        
    }
    else // COMPETETION
    {
        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(dropviewComp1.frame), CGRectGetMaxY(dropviewComp1.superview.frame)+60, CGRectGetWidth(dropviewComp1.frame), 300)];
        
    }
    
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];
    
}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    if ([key isEqualToString: @"CompetitionName"]) {
        
        NSLog(@"%@",array[Index.row]);
        NSLog(@"selected value %@",key);
        Competitionlbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Competetioncode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:Competitionlbl.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        Teamnamelbl.text = @"Team Name";
        
    }
    else
    {
        Teamnamelbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Teamcode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:Teamnamelbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:Teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [self TeamWebservice];
    
    
}

@end

