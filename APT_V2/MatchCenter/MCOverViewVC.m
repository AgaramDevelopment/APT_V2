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

@interface MCOverViewVC ()
{
    WebService *objWebservice;
    NSMutableArray *recentMatchesArray;
    
    NSMutableArray *CommonArray;
    NSMutableArray *BatsmenArray;
    NSMutableArray *BowlersArray;
    NSMutableArray *FieldersArray;
}

@end

@implementation MCOverViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customnavigationmethod];
    
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"MCOverViewResultCVC" bundle:nil] forCellWithReuseIdentifier:@"mcResultCVC"];
    
   // [_scrollView contentSize ]
   // _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 3000);

    _scrollView.contentSize = _contentView.frame.size;
//    [self.nextBtn setTag:0];
//    self.prevBtn.hidden = YES;
//    [self.nextBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self OverviewWebservice];
}

-(void)customnavigationmethod
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
        return 3;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(collectionView == self.resultCollectionView){
        
        
        
        MCOverViewResultCVC* cell = [self.resultCollectionView dequeueReusableCellWithReuseIdentifier:@"mcResultCVC" forIndexPath:indexPath];
        
        cell.Teamname1lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.Teamname2lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.runs1lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.runs2lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.TeamOvers1lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.TeamOver2lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.runrate1lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.runrate2lbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        cell.Datelbl.text = [[recentMatchesArray valueForKey:@""] objectAtIndex:indexPath.row];
        
        
        NSString * photourl = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[recentMatchesArray valueForKey:@"TeamPhotoLink"] objectAtIndex:0]];
        [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.team1Img.image = image;
                
                // cache the image for use later (when scrolling up)
                cell.team1Img.image = image;
            }
            else
            {
                cell.team1Img.image = [UIImage imageNamed:@"no-image"];
            }
        }];
        
        
        NSString * photourl2 = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[recentMatchesArray valueForKey:@"TeamPhotoLink"] objectAtIndex:0]];
        [self downloadImageWithURL:[NSURL URLWithString:photourl2] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.team2Img.image = image;
                
                // cache the image for use later (when scrolling up)
                cell.team2Img.image = image;
            }
            else
            {
                cell.team2Img.image = [UIImage imageNamed:@"no-image"];
            }
        }];
        
        
        return cell;
        
    }
    return nil;
    
}

-(void)OverviewWebservice
{
    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    //NSString *clientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    
    
    NSString *CompetitionCode = @"UCC0000115";
    NSString *teamcode = @"TEA0000001";
    objWebservice = [[WebService alloc]init];
    
    
    [objWebservice Overview:OverviewKey :CompetitionCode : teamcode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            NSMutableArray *teamDetailsArray = [[NSMutableArray alloc]init];
            teamDetailsArray = [responseObject valueForKey:@"Overview"];
            
            
            self.Teamnamelbl.text = [[teamDetailsArray valueForKey:@"TeamName"] objectAtIndex:0];
            
            NSString *groundDetails = [NSString stringWithFormat:@"%@,%@",[[teamDetailsArray valueForKey:@"GroundName"] objectAtIndex:0], [[teamDetailsArray valueForKey:@"Venue"] objectAtIndex:0]];
            self.Groundmnamelbl.text = [[teamDetailsArray valueForKey:@"GroundName"] objectAtIndex:0];
            self.Captainnamelbl.text = [NSString stringWithFormat:@"Captain :%@",[[teamDetailsArray valueForKey:@"PlayerName"] objectAtIndex:0]];
            [[teamDetailsArray valueForKey:@"PlayerName"] objectAtIndex:0];
            
            
            NSString * photourl = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[teamDetailsArray valueForKey:@"TeamPhotoLink"] objectAtIndex:0]];
            [self downloadImageWithURL:[NSURL URLWithString:photourl] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    // change the image in the cell
                    self.TeamImgView.image = image;
                    
                    // cache the image for use later (when scrolling up)
                    self.TeamImgView.image = image;
                }
                else
                {
                    self.TeamImgView.image = [UIImage imageNamed:@"no-image"];
                }
            }];
            
            
            recentMatchesArray = [[NSMutableArray alloc]init];
            recentMatchesArray = [responseObject valueForKey:@"OvBatRecentmatch"];
            
            BatsmenArray = [[NSMutableArray alloc]init];
            BatsmenArray = [responseObject valueForKey:@"BatsmenOV"];
            
            BowlersArray = [[NSMutableArray alloc]init];
            BowlersArray = [responseObject valueForKey:@"BowlersOV"];
            
            FieldersArray = [[NSMutableArray alloc]init];
            FieldersArray = [responseObject valueForKey:@"FieldOV"];
            
           // [self.resultCollectionView reloadData];
            
            [self.nextBtn setTag:0];
            self.prevBtn.hidden = YES;
            [self.nextBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
           
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
    if(self.nextBtn.tag==0)
    {
        self.PlayerTypelbl.text = @"Top Batsmens";
        self.prevBtn.hidden = YES;
        [self.nextBtn setTag:1];
        
        CommonArray =[[NSMutableArray alloc]init];
        CommonArray = BatsmenArray;
        [self SetValuesOfTopPlayers:CommonArray];
    }
    else if(self.nextBtn.tag==1)
    {
        self.prevBtn.hidden = NO;
        self.PlayerTypelbl.text = @"Top Bowlers";
        [self.nextBtn setTag:2];
        [self.prevBtn setTag:1];
        
        CommonArray =[[NSMutableArray alloc]init];
        CommonArray = BowlersArray;
        [self SetValuesOfTopPlayers:CommonArray];
    }
    else if(self.nextBtn.tag==2)
    {
        self.PlayerTypelbl.text = @"Top Fielders";
        self.nextBtn.hidden = YES;
        [self.prevBtn setTag:2];
        
        CommonArray =[[NSMutableArray alloc]init];
        CommonArray = FieldersArray;
        [self SetValuesOfTopPlayers:CommonArray];
    }
    
    
    
}

- (IBAction)onClickPrevBtn:(id)sender
{
   if(self.prevBtn.tag==1)
   {
       self.PlayerTypelbl.text = @"Top Batsmens";
       self.prevBtn.hidden = YES;
       [self.nextBtn setTag:1];
       
       CommonArray =[[NSMutableArray alloc]init];
       CommonArray = BatsmenArray;
       [self SetValuesOfTopPlayers:CommonArray];
   }
   else if(self.prevBtn.tag==2)
   {
       self.PlayerTypelbl.text = @"Top Bowlers";
       [self.nextBtn setTag:2];
       [self.prevBtn setTag:1];
       self.nextBtn.hidden = NO;
       
       CommonArray =[[NSMutableArray alloc]init];
       CommonArray = BowlersArray;
       [self SetValuesOfTopPlayers:CommonArray];
   }
   
}

-(void)SetValuesOfTopPlayers :(NSMutableArray *)ReqArray
{
   if([self.PlayerTypelbl.text isEqualToString:@"Top Batsmens"])
   {
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
   else if([self.PlayerTypelbl.text isEqualToString:@"Top Bowlers"])
   {
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
   else if([self.PlayerTypelbl.text isEqualToString:@"Top Fielders"])
   {
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
    
    
    
}



@end
