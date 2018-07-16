//
//  MCOverViewVC.m
//  APT_V2
//
//  Created by apple on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "MCOverViewVC.h"
#import "MCOverViewResultCVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "Config.h"
#import "WebService.h"
#import "ResultsVc.h"
#import "TabbarVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import UIView_AnimationExtensions;

@interface MCOverViewVC ()
{
    WebService *objWebservice;
    ResultsVc *objresult;
    NSMutableArray *recentMatchesArray;
    NSMutableArray *resultsArray;
    NSMutableArray *CommonArray;
    NSMutableArray *BatsmenArray;
    NSMutableArray *BowlersArray;
    NSMutableArray *FieldersArray;
    NSArray* competetinArray;
    
    TabbarVC *objtab;
    
    NSString *CompetitionCode;
    NSString *teamcode;
    NSString *displayMatchCode;
    
    BOOL isComp;
    BOOL isTeam;
}

@end

@implementation MCOverViewVC

@synthesize competitionlbl,dropviewComp;

@synthesize viewCompetetion,viewTeam;

@synthesize lblCompetetion,lblTeamName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
//    NSString *plyRolecode = @"ROL0000002";
//
//    if([rolecode isEqualToString:plyRolecode])
//    {
//        self.viewTeam.hidden = YES;
//    }
//    else
//    {
//        self.viewTeam.hidden = NO;
//    }
    
   // [self.viewTeam setHidden:![AppCommon isCoach]];

    
    
//    self.CompetitionListtbl.hidden = YES;
    //self.popTableView.hidden = YES;
    self.prevBtn.hidden = YES;
    self.NodataView.hidden = YES;
    
    
    
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"MCOverViewResultCVC" bundle:nil] forCellWithReuseIdentifier:@"mcResultCVC"];
    
   // [_scrollView contentSize ]
   // _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 3000);

    _scrollView.contentSize = _contentView.frame.size;
//    [self.nextBtn setTag:0];
//    self.prevBtn.hidden = YES;
//    [self.nextBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    competitionlbl.text = @"";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    lblCompetetion.text = [AppCommon getCurrentCompetitionName];
    lblTeamName.text = [AppCommon getCurrentTeamName];
    
    CompetitionCode = [AppCommon getCurrentCompetitionCode];
    teamcode = [AppCommon getCurrentTeamCode];
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];

//    [self OverviewWebservice:CompetitionCode :teamcode];
    [self OverviewWebservice];


}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
//{
//    CustomNavigation * objCustomNavigation;
//
//    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
//    [objCustomNavigation.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
//    [objCustomNavigation.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
//    [objCustomNavigation.view.heightAnchor constraintEqualToAnchor:self.headerView.heightAnchor];
//    [objCustomNavigation.view.topAnchor constraintEqualToAnchor:self.view.topAnchor];
//    [objCustomNavigation.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//    [self.headerView addSubview:objCustomNavigation.view];
//    objCustomNavigation.tittle_lbl.text=@"Overview";
//    objCustomNavigation.btn_back.hidden = YES;
//    objCustomNavigation.home_btn.hidden = YES;
//    objCustomNavigation.menu_btn.hidden =NO;
//
//
//    SWRevealViewController *revealController = [self revealViewController];
//    [revealController panGestureRecognizer];
//    [revealController tapGestureRecognizer];
//
//
//    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//
//}
{
    CustomNavigation * objCustomNavigation;
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headerView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Overview";
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
    
    if(collectionView == _resultCollectionView){
        return recentMatchesArray.count;
    }else{
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat widthF = self.resultCollectionView.superview.frame.size.width-20;
    CGFloat HeightF = self.resultCollectionView.superview.frame.size.height-20;
    
    if (IS_IPHONE5) {
        widthF = widthF;
    }
    else if(IS_IPAD)
    {
        widthF = widthF/2;
    }
    return CGSizeMake(widthF, HeightF);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(collectionView == self.resultCollectionView){
        
        
        MCOverViewResultCVC* cell = [self.resultCollectionView dequeueReusableCellWithReuseIdentifier:@"mcResultCVC" forIndexPath:indexPath];
        
        cell.Teamname1lbl.text = [[recentMatchesArray valueForKey:@"ATName"] objectAtIndex:indexPath.row];
        cell.Teamname2lbl.text = [[recentMatchesArray valueForKey:@"BTName"] objectAtIndex:indexPath.row];
        
        NSString * team1Score = [NSString stringWithFormat:@"%@/%@",[[recentMatchesArray valueForKey:@"ATMaxInnsTotal"] objectAtIndex:indexPath.row],[[recentMatchesArray valueForKey:@"ATMaxInnsWckts"] objectAtIndex:indexPath.row]];
        cell.runs1lbl.text = team1Score;
        
        NSString * team2Score = [NSString stringWithFormat:@"%@/%@",[[recentMatchesArray valueForKey:@"BTMaxInnsTotal"] objectAtIndex:indexPath.row],[[recentMatchesArray valueForKey:@"BTMaxInnsWckts"] objectAtIndex:indexPath.row]];
        cell.runs2lbl.text = team2Score;
        
        NSString *ATOvers = [NSString stringWithFormat:@"%@ Overs", [[recentMatchesArray valueForKey:@"ATOvers"] objectAtIndex:indexPath.row]];
        cell.TeamOvers1lbl.text = ATOvers;
         NSString *BTOvers = [NSString stringWithFormat:@"%@ Overs", [[recentMatchesArray valueForKey:@"BTOvers"] objectAtIndex:indexPath.row]];
        cell.TeamOver2lbl.text = BTOvers;
        NSString *ATRR = [NSString stringWithFormat:@"%@ RR", [[recentMatchesArray valueForKey:@"ATRR"] objectAtIndex:indexPath.row]];
        cell.runrate1lbl.text = ATRR;
        NSString *BTRR = [NSString stringWithFormat:@"%@ RR", [[recentMatchesArray valueForKey:@"BTRR"] objectAtIndex:indexPath.row]];
        cell.runrate2lbl.text = BTRR;
        
        NSString *matchdate = [[recentMatchesArray valueForKey:@"ATMatchDate"] objectAtIndex:indexPath.row];
//        NSArray *arr = [matchdate componentsSeparatedByString:@" "];
        cell.Datelbl.text = matchdate;
        
//        MatchResult
        if ([[[recentMatchesArray objectAtIndex:indexPath.row] allKeys] containsObject:@"MatchResult"]) {
            cell.lblOwnStats.text = [[recentMatchesArray valueForKey:@"MatchResult"] objectAtIndex:indexPath.row];
        }
        
//        NSString * photourl = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[recentMatchesArray valueForKey:@"ATPhoto"] objectAtIndex:0]];
        NSString * photourl = [NSString stringWithFormat:@"%@",[[recentMatchesArray valueForKey:@"ATPhoto"] objectAtIndex:indexPath.row]];

//        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.team1Img.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.team1Img.image = image;
//            }
//            else
//            {
//                cell.team1Img.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.team1Img sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
//        NSString * photourl2 = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[recentMatchesArray valueForKey:@"BTPhoto"] objectAtIndex:0]];
        NSString * photourl2 = [NSString stringWithFormat:@"%@",[[recentMatchesArray valueForKey:@"BTPhoto"] objectAtIndex:indexPath.row]];

//        [self downloadImageWithURL:[NSURL URLWithString:photourl2] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.team2Img.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.team2Img.image = image;
//            }
//            else
//            {
//                cell.team2Img.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.team2Img sd_setImageWithURL:[NSURL URLWithString:photourl2] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
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
        displayMatchCode = [[recentMatchesArray valueForKey:@"ATMatchCode"] objectAtIndex:indexPath.row];
        NSMutableArray *scoreArray = [[NSMutableArray alloc]init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        NSString *ground = @"";
        NSString *place = [[recentMatchesArray valueForKey:@"Venue"]objectAtIndex:indexPath.row];
        
        [dic setValue:[NSString stringWithFormat:@"%@,%@",ground,place] forKey:@"ground"];
        [dic setValue:[[recentMatchesArray valueForKey:@"ATName"] objectAtIndex:indexPath.row] forKey:@"team1"];
        [dic setValue:[[recentMatchesArray valueForKey:@"BTName"] objectAtIndex:indexPath.row] forKey:@"team2"];
    
    NSString * team1Score = [NSString stringWithFormat:@"%@/%@(%@)",[[recentMatchesArray valueForKey:@"ATMaxInnsTotal"] objectAtIndex:indexPath.row],[[recentMatchesArray valueForKey:@"ATMaxInnsWckts"] objectAtIndex:indexPath.row],[[recentMatchesArray valueForKey:@"ATOvers"] objectAtIndex:indexPath.row]];
        [dic setValue:team1Score forKey:@"Inn1Score"];
    
    NSString * team2Score = [NSString stringWithFormat:@"%@/%@(%@)",[[recentMatchesArray valueForKey:@"BTMaxInnsTotal"] objectAtIndex:indexPath.row],[[recentMatchesArray valueForKey:@"BTMaxInnsWckts"] objectAtIndex:indexPath.row],[[recentMatchesArray valueForKey:@"BTOvers"] objectAtIndex:indexPath.row]];
        [dic setValue:team2Score forKey:@"Inn2Score"];
    
        [dic setValue:@"" forKey:@"Inn3Score"];
        [dic setValue:@"" forKey:@"Inn4Score"];
        [dic setValue:@"" forKey:@"result"];
        [dic setValue:@"" forKey:@"Competition"];
        [dic setValue:[[recentMatchesArray valueForKey:@"ATPhoto"] objectAtIndex:indexPath.row] forKey:@"TeamALogo"];
        [dic setValue:[[recentMatchesArray valueForKey:@"ATPhoto"] objectAtIndex:indexPath.row] forKey:@"TeamBLogo"];
        
        [scoreArray addObject:dic];
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        objtab = (TabbarVC *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"TabbarVC"];
        appDel.Currentmatchcode = displayMatchCode;
        appDel.Scorearray = scoreArray;
        //objtab.backkey = @"yes";
        //[self.navigationController pushViewController:objFix animated:YES];
        [appDel.frontNavigationController pushViewController:objtab animated:YES];
    
}




-(void)OverviewWebservice
{
    
    if (![COMMON isInternetReachable]) {
        return;
    }
    
    if ([lblCompetetion.text isEqualToString:@"Competetion Name"]) {
        
        return;
    }
    else if([AppCommon isCoach] && [lblTeamName.text isEqualToString:@"Team Name"])
    {
        return;
    }

    
    [AppCommon showLoading ];
    NSLog(@"TEAM CODE %@",appDel.ArrayTeam);
    self.moreBtn.hidden = YES;
    
//    self.competitionlbl.text = [AppCommon getCurrentCompetitionName];
//     self.teamlbl.text = [AppCommon getCurrentTeamName];
    
    NSString *compCode = [AppCommon getCurrentCompetitionCode];
    NSString *temCode = [AppCommon getCurrentTeamCode];
    objWebservice = [[WebService alloc]init];
    NSLog(@"OverviewKey:%@", OverviewKey);
    
    [objWebservice Overview:OverviewKey :compCode : temCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        NSMutableArray *teamDetailsArray = [[NSMutableArray alloc]init];
        teamDetailsArray = [responseObject valueForKey:@"Overview"];

        if(teamDetailsArray.count >0)
        {
            
                self.Teamnamelbl.text = [[teamDetailsArray valueForKey:@"TeamName"] objectAtIndex:0];
            
                NSString *groundDetails = [NSString stringWithFormat:@"%@,%@",[[teamDetailsArray valueForKey:@"GroundName"] objectAtIndex:0], [[teamDetailsArray valueForKey:@"Venue"] objectAtIndex:0]];
                self.Groundmnamelbl.text = [[teamDetailsArray valueForKey:@"GroundName"] objectAtIndex:0];
                self.Captainnamelbl.text = [NSString stringWithFormat:@"Captain : %@",[[teamDetailsArray valueForKey:@"PlayerName"] objectAtIndex:0]];
            
//                [[teamDetailsArray valueForKey:@"PlayerName"] objectAtIndex:0];
            
            
                NSString * photourl = [NSString stringWithFormat:@"%@",[[teamDetailsArray valueForKey:@"TeamPhotoLink"] objectAtIndex:0]];

//            [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//                if (succeeded) {
//                    // change the image in the cell
//                    self.TeamImgView.image = image;
//
//                    // cache the image for use later (when scrolling up)
//                    self.TeamImgView.image = image;
//                }
//                else
//                {
//                    self.TeamImgView.image = [UIImage imageNamed:@"no-image"];
//                }
//            }];
            [self.TeamImgView sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
            
            recentMatchesArray = [[NSMutableArray alloc]init];
            
            if(![[responseObject valueForKey:@"OvBatRecentmatch"] isEqual:[NSNull null]])
            {
                recentMatchesArray = [responseObject valueForKey:@"OvBatRecentmatch"];
                
                if(recentMatchesArray.count>0)
                {
                    self.moreBtn.hidden = NO;
                }
                else
                {
                    self.moreBtn.hidden = YES;
                }
            }
            else
            {
                self.moreBtn.hidden = YES;
            }
            
            
            resultsArray = [[NSMutableArray alloc]init];
            if(![[responseObject valueForKey:@"OvATResults"] isEqual:[NSNull null]])
            {
                resultsArray = [responseObject valueForKey:@"OvATResults"];
                
                if(resultsArray.count>0)
                {
                
                self.TotalMatcheslbl.text =  [self checkNull:[resultsArray valueForKey:@"ATMatches"]];
                
                self.winLosslbl.text = [self checkNull:[resultsArray valueForKey:@"ATWinper"]];
                NSString *wincount = [NSString stringWithFormat:@"%@/%@",[resultsArray valueForKey:@"ATWon"],[resultsArray valueForKey:@"ATMatches"]];
                self.winLossCountlbl.text =wincount;
                
                self.Forlbl.text = [self checkNull:[resultsArray valueForKey:@"For"]];
                NSString *forcount = [NSString stringWithFormat:@"%@/%@",[resultsArray valueForKey:@"ATRuns"],[resultsArray valueForKey:@"ATOvers"]];
                self.ForCountlbl.text =forcount;
                
                
                self.Againstlbl.text = [self checkNull:[resultsArray valueForKey:@"Against"]];
                NSString *Againstcount = [NSString stringWithFormat:@"%@/%@",[resultsArray valueForKey:@"BTRuns"],[resultsArray valueForKey:@"BTOvers"]];
                self.AgainstCountlbl.text =Againstcount;
                
                self.nrrlbl.text = [self checkNull:[resultsArray valueForKey:@"NetRR"]];
                
                NSString *wkts = [NSString stringWithFormat:@"%@/%@",[resultsArray valueForKey:@"BTWcktsTkn"],[resultsArray valueForKey:@"ATWcktsGvn"]];
                self.Wktslbl.text = wkts;
                }
                else
                {
                    self.TotalMatcheslbl.text = @"";
                    
                    self.winLosslbl.text = @"";
                    
                    self.winLossCountlbl.text = @"";
                    
                    self.Forlbl.text = @"";
                    
                    self.ForCountlbl.text =@"";
                    
                    
                    self.Againstlbl.text = @"";
                    
                    self.AgainstCountlbl.text = @"";
                    
                    self.nrrlbl.text = @"";
                    
                    self.Wktslbl.text = @"";
                }
            }
            else
            {
                self.TotalMatcheslbl.text = @"";
                
                self.winLosslbl.text = @"";
                
                self.winLossCountlbl.text = @"";
                
                self.Forlbl.text = @"";
                
                self.ForCountlbl.text =@"";
                
                
                self.Againstlbl.text = @"";
                
                self.AgainstCountlbl.text = @"";
                
                self.nrrlbl.text = @"";
                
                self.Wktslbl.text = @"";
            }
            
            BatsmenArray = [[NSMutableArray alloc]init];
            
            if(![[responseObject valueForKey:@"BatsmenOV"] isEqual:[NSNull null]])
            {
                
                BatsmenArray = [responseObject valueForKey:@"BatsmenOV"];
                
                if(BatsmenArray.count>0)
                {
                    
                [self.Player1Img pulseToSize:1.1f
                                    duration:0.3f
                                      repeat:YES];
                }
                else
                {
                    [self.Player1Img pulseToSize:0.0f
                                        duration:0.3f
                                          repeat:YES];
                }

                
            }
            else
            {
                [self.Player1Img pulseToSize:0.0f
                                    duration:0.3f
                                      repeat:YES];
            }

                
                BowlersArray = [[NSMutableArray alloc]init];
            if(![[responseObject valueForKey:@"BowlersOV"] isEqual:[NSNull null]])
            {
                BowlersArray = [responseObject valueForKey:@"BowlersOV"];
                if(BowlersArray.count>0)
                {
                    
                    [self.Player1Img pulseToSize:1.1f
                                        duration:0.3f
                                          repeat:YES];
                }
                else
                {
                    [self.Player1Img pulseToSize:0.0f
                                        duration:0.3f
                                          repeat:YES];
                }
            }
            else
            {
                [self.Player1Img pulseToSize:0.0f
                                    duration:0.3f
                                      repeat:YES];
            }
                
                FieldersArray = [[NSMutableArray alloc]init];
            if(![[responseObject valueForKey:@"FieldOV"] isEqual:[NSNull null]])
            {
                FieldersArray = [responseObject valueForKey:@"FieldOV"];
                
                if(FieldersArray.count>0)
                {
                    
                    [self.Player1Img pulseToSize:1.1f
                                        duration:0.3f
                                          repeat:YES];
                }
                else
                {
                    [self.Player1Img pulseToSize:0.0f
                                        duration:0.3f
                                          repeat:YES];
                }
            }
            else
            {
                [self.Player1Img pulseToSize:0.0f
                                    duration:0.3f
                                      repeat:YES];
            }
                
                [self.resultCollectionView reloadData];
                
                [self.nextBtn setTag:0];
                self.nextBtn.hidden = NO;
                self.prevBtn.hidden = YES;
                [self.nextBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
           
        }
        else{
            
            self.Teamnamelbl.text = @"";
            
            NSString *groundDetails = @"";
            self.Groundmnamelbl.text = @"";
            self.Captainnamelbl.text = @"";
            
            
            
            NSString * photourl = @"";
            
//            [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//                if (succeeded) {
//                    // change the image in the cell
//                    self.TeamImgView.image = image;
//
//                    // cache the image for use later (when scrolling up)
//                    self.TeamImgView.image = image;
//                }
//                else
//                {
//                    self.TeamImgView.image = [UIImage imageNamed:@"no-image"];
//                }
//            }];
            
            [self.TeamImgView sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
            
            self.moreBtn.hidden = YES;
            
            
            
            
            self.TotalMatcheslbl.text =  @"";
            
            self.winLosslbl.text = @"";
            NSString *wincount = @"";
            self.winLossCountlbl.text =@"";
            
            self.Forlbl.text = @"";
            NSString *forcount = @"";
            self.ForCountlbl.text =@"";
            
            
            self.Againstlbl.text = @"";
            NSString *Againstcount = @"";
            self.AgainstCountlbl.text =@"";
            
            self.nrrlbl.text = @"";
            
            NSString *wkts = @"";
            self.Wktslbl.text = @"";
            
            BatsmenArray = [[NSMutableArray alloc]init];
            
            
            BowlersArray = [[NSMutableArray alloc]init];
            
            
            FieldersArray = [[NSMutableArray alloc]init];
            
            recentMatchesArray =[[NSMutableArray alloc]init];
            
            [self.resultCollectionView reloadData];
            
//            [self.nextBtn setTag:0];
//            self.prevBtn.hidden = NO;
//            self.prevBtn.hidden = YES;
//            [self.nextBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //CommonArray = [[NSMutableArray alloc]init];
            //[self SetValuesOfTopPlayers:CommonArray];
            
            
        }
        [AppCommon hideLoading];
        
    }
                         failure:^(AFHTTPRequestOperation *operation, id error) {
                             NSLog(@"failed");
                             [COMMON webServiceFailureError:error];
                         }];
    
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


- (IBAction)onClickNextBtn:(id)sender
{
    self.NodataView.hidden = YES;
    if(self.nextBtn.tag==0)
    {
        self.PlayerTypelbl.text = @"Top Batsmens";
        self.prevBtn.hidden = YES;
        [self.nextBtn setTag:1];
        CommonArray =[[NSMutableArray alloc]init];
        CommonArray = BatsmenArray;
    if(CommonArray.count>0 || ![CommonArray isEqual:[NSNull null]])
        {
        if(CommonArray.count>0)
        {
            self.NodataView.hidden = YES;
            [self SetValuesOfTopPlayers:CommonArray];
            
        }
        else
        {
            self.NodataView.hidden = NO;
        }
        }
    }
    else if(self.nextBtn.tag==1)
    {
        self.prevBtn.hidden = NO;
        self.PlayerTypelbl.text = @"Top Bowlers";
        [self.nextBtn setTag:2];
        [self.prevBtn setTag:1];
        
        CommonArray =[[NSMutableArray alloc]init];
        CommonArray = BowlersArray;
        if(CommonArray.count>0)
        {
            self.NodataView.hidden = YES;
            [self SetValuesOfTopPlayers:CommonArray];
            
        }
        else
        {
            self.NodataView.hidden = NO;
        }
    }
    else if(self.nextBtn.tag==2)
    {
        self.NodataView.hidden = YES;
        self.PlayerTypelbl.text = @"Top Fielders";
        self.nextBtn.hidden = YES;
        [self.prevBtn setTag:2];
        
        CommonArray =[[NSMutableArray alloc]init];
        CommonArray = FieldersArray;
        if(CommonArray.count>0)
        {
            self.NodataView.hidden = YES;
            [self SetValuesOfTopPlayers:CommonArray];
        }
        else
        {
            self.NodataView.hidden = NO;
        }
    }
    
    
    
}


- (IBAction)onClickMoreMatches:(id)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    objresult = (ResultsVc *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ResultsVc"];
    //[self.navigationController pushViewController:objFix animated:YES];
    [appDel.frontNavigationController pushViewController:objresult animated:YES];
    
}




//- (IBAction)onClickCompetitionBtn:(id)sender
//{
//    isComp = YES;
//    isTeam = NO;
//    self.CompetitionListtbl.hidden = NO;
//
//    self.tableWidth.constant = self.competView.frame.size.width;
//    self.tableXposition.constant = self.competView.frame.origin.x;
//
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    arr = appDel.ArrayCompetition;
//    [self.CompetitionListtbl reloadData];
//
//}
//
//- (IBAction)onClickTeamBtn:(id)sender
//{
//    isComp = NO;
//    isTeam = YES;
//    self.CompetitionListtbl.hidden = NO;
//    self.tableWidth.constant = self.teamView.frame.size.width;
//    self.tableXposition.constant = self.teamView.frame.origin.x;
//
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    arr = appDel.ArrayTeam;
//
//    [self.CompetitionListtbl reloadData];
//
//}


- (IBAction)actionCompetetionTeam:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    
    if ([sender tag] == 1) { // TEAM
        
        
        dropVC.array = [COMMON getCorrespondingTeamName:lblCompetetion.text];
        dropVC.key = @"TeamName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(viewTeam.frame), CGRectGetMaxY(viewTeam.superview.frame)+70, CGRectGetWidth(viewTeam.frame), 300)];
        
    }
    else // COMPETETION
    {
        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(viewCompetetion.frame), CGRectGetMaxY(viewCompetetion.superview.frame)+70, CGRectGetWidth(viewCompetetion.frame), 300)];
        
    }
    
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];
    
}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    
    if ([key  isEqualToString: @"CompetitionName"]) {
        
        lblCompetetion.text = [[array objectAtIndex:Index.row] valueForKey:key];
        CompetitionCode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:CompetitionCode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        lblTeamName.text = @"Team Name";
        
        
        
    }
    else
    {
        lblTeamName.text = [[array objectAtIndex:Index.row] valueForKey:key];
        teamcode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];

        [[NSUserDefaults standardUserDefaults] setValue:lblTeamName.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
//    [self OverviewWebservice:CompetitionCode :teamcode];
    [self OverviewWebservice];

    
}

- (IBAction)onClickPrevBtn:(id)sender
{
   if(self.prevBtn.tag==1)
   {
       self.NodataView.hidden = YES;
       self.PlayerTypelbl.text = @"Top Batsmens";
       self.prevBtn.hidden = YES;
       [self.nextBtn setTag:1];
       
       CommonArray =[[NSMutableArray alloc]init];
       CommonArray = BatsmenArray;
       if(CommonArray.count>0)
       {
           self.NodataView.hidden = YES;
           [self SetValuesOfTopPlayers:CommonArray];
           
       }
       else
       {
           self.NodataView.hidden = NO;
       }
   }
   else if(self.prevBtn.tag==2)
   {
       self.NodataView.hidden = YES;
       self.PlayerTypelbl.text = @"Top Bowlers";
       [self.nextBtn setTag:2];
       [self.prevBtn setTag:1];
       self.nextBtn.hidden = NO;
       
       CommonArray =[[NSMutableArray alloc]init];
       CommonArray = BowlersArray;
       if(CommonArray.count>0)
       {
           self.NodataView.hidden = YES;
           [self SetValuesOfTopPlayers:CommonArray];
           
       }
       else
       {
           self.NodataView.hidden = NO;
       }
   }
   
}

-(void)SetValuesOfTopPlayers :(NSMutableArray *)ReqArray
{
    if([self.PlayerTypelbl.text isEqualToString:@"Top Batsmens"])
    {
        if(ReqArray.count>0)
        {
            self.NodataView.hidden = YES;
            NSString * photourl = [NSString stringWithFormat:@"%@",[[ReqArray valueForKey:@"PlayerPhotoLink"] objectAtIndex:0]];
            
//            [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//                if (succeeded) {
//                    // change the image in the cell
//                    self.Player1Img.image = image;
//
//                    // cache the image for use later (when scrolling up)
//                }
//                else
//                {
//                    self.Player1Img.image = [UIImage imageNamed:@"no-image"];
//                }
//            }];
            [self.Player1Img sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
          
            
            self.Player1Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:0];
            self.Player2Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:1];
            self.Player3Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:2];
            self.Player4Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:3];
            self.Player5Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:4];
            
            self.Player1Countlbl.text = [[ReqArray valueForKey:@"Runs"] objectAtIndex:0];
            self.Player2Countlbl.text = [[ReqArray valueForKey:@"Runs"] objectAtIndex:1];
            self.Player3Countlbl.text = [[ReqArray valueForKey:@"Runs"] objectAtIndex:2];
            self.Player4Countlbl.text = [[ReqArray valueForKey:@"Runs"] objectAtIndex:3];
            self.Player5Countlbl.text = [[ReqArray valueForKey:@"Runs"] objectAtIndex:4];
            
            self.Player1SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:0];
            self.Player2SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:1];
            self.Player3SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:2];
            self.Player4SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:3];
            self.Player5SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:4];
            
            
            
        }
        else
        {
            self.NodataView.hidden = NO;
        }
        
    }
    else if([self.PlayerTypelbl.text isEqualToString:@"Top Bowlers"])
    {
        if(ReqArray.count>0)
        {
            self.NodataView.hidden = YES;
            
            NSString * photourl = [NSString stringWithFormat:@"%@",[[ReqArray valueForKey:@"PlayerPhotoLink"] objectAtIndex:0]];
            
//            [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//                if (succeeded) {
//                    // change the image in the cell
//                    self.Player1Img.image = image;
//
//                    // cache the image for use later (when scrolling up)
//                }
//                else
//                {
//                    self.Player1Img.image = [UIImage imageNamed:@"no-image"];
//                }
//            }];
            [self.Player1Img sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
            
            self.Player1Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:0];
            self.Player2Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:1];
            self.Player3Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:2];
            self.Player4Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:3];
            self.Player5Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:4];
            
            self.Player1Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:0];
            self.Player2Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:1];
            self.Player3Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:2];
            self.Player4Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:3];
            self.Player5Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:4];
            
            self.Player1SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:0];
            self.Player2SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:1];
            self.Player3SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:2];
            self.Player4SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:3];
            self.Player5SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:4];
        }
        else
        {
            self.NodataView.hidden = NO;
        }
    }
    else if([self.PlayerTypelbl.text isEqualToString:@"Top Fielders"])
    {
        if(ReqArray.count>0)
        {
            self.NodataView.hidden = YES;
            NSString * photourl = [NSString stringWithFormat:@"%@",[[ReqArray valueForKey:@"PlayerPhotoLink"] objectAtIndex:0]];
            
//            [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
//                if (succeeded) {
//                    // change the image in the cell
//                    self.Player1Img.image = image;
//                    
//                    // cache the image for use later (when scrolling up)
//                }
//                else
//                {
//                    self.Player1Img.image = [UIImage imageNamed:@"no-image"];
//                }
//            }];
            [self.Player1Img sd_setImageWithURL:[NSURL URLWithString:photourl] placeholderImage:[UIImage imageNamed:@"no-image"]];
            
            self.Player1Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:0];
            self.Player2Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:1];
            self.Player3Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:2];
            self.Player4Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:3];
            self.Player5Namelbl.text = [[ReqArray valueForKey:@"PlayerName"] objectAtIndex:4];
            
            self.Player1Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:0];
            self.Player2Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:1];
            self.Player3Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:2];
            self.Player4Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:3];
            self.Player5Countlbl.text = [[ReqArray valueForKey:@"Wickets"] objectAtIndex:4];
            
            self.Player1SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:0];
            self.Player2SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:1];
            self.Player3SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:2];
            self.Player4SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:3];
            self.Player5SRlbl.text = [[ReqArray valueForKey:@"SR"] objectAtIndex:4];
        }
        else
        {
            self.NodataView.hidden = NO;
        }
        
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
    
    if(isComp ==YES)
    {
        cell.textLabel.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];
    }
    else if(isTeam == YES)
    {
        cell.textLabel.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        
    }
    

    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isComp == YES)
    {
        //        cell..text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];

        self.competitionlbl.text = [[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetetionName"];
       CompetitionCode = [[appDel.ArrayCompetition objectAtIndex:indexPath.row] valueForKey:@"CompetitionCode"];

        [[NSUserDefaults standardUserDefaults] setValue:self.competitionlbl.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:CompetitionCode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(isTeam == YES)
    {
        //        cell..text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"]objectAtIndex:indexPath.row];

        // SelectedTeamCode
        self.teamlbl.text = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        teamcode = [[appDel.ArrayTeam objectAtIndex:indexPath.row] valueForKey:@"TeamCode"];
        [[NSUserDefaults standardUserDefaults] setValue:self.teamlbl.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
//    self.CompetitionListtbl.hidden = YES;
    
//    [self OverviewWebservice:CompetitionCode :teamcode];
    
}

- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}


@end
