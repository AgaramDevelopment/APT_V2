//
//  TeamHeadToHead.m
//  APT_V2
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TeamHeadToHead.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "Config.h"
#import "WebService.h"


@interface TeamHeadToHead ()
{
    BOOL isteam1;
    BOOL isteam2;
    BOOL isGround;
    BOOL isCompetition;
    
    //Service Call Properties
    NSString *team1Code;
    NSString *team2Code;
    NSString *groundCode;
    NSString *competitionCode;
    NSString *team1InnsNum;
    NSString *team2InnsNum;
    NSString *fromOver;
    NSString *toOver;
}

@property (nonatomic, strong) IBOutlet NSMutableArray *commonArray;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableYposition;

@end

@implementation TeamHeadToHead

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groundTF.delegate = self;
    self.Poptable.hidden = YES;
    [self customnavigationmethod];
    [self setBorderForButtons];
    [self headToHeadPageLoadGetService];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headerView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Head To Head";
    objCustomNavigation.btn_back.hidden = YES;
    objCustomNavigation.home_btn.hidden = YES;
    objCustomNavigation.menu_btn.hidden =NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBorderForButtons {
    self.firstInn.layer.borderWidth = 1.0f;
    self.firstInn.layer.borderColor = [UIColor blackColor].CGColor;
    self.firstInn.layer.cornerRadius = 2.0f;
    
    self.secondInn.layer.borderWidth = 1.0f;
    self.secondInn.layer.borderColor = [UIColor blackColor].CGColor;
    self.secondInn.layer.cornerRadius = 2.0f;
    
    self.team1win.layer.borderWidth = 1.0f;
    self.team1win.layer.borderColor = [UIColor blackColor].CGColor;
    self.team1win.layer.cornerRadius = 2.0f;
    
    self.team2win.layer.borderWidth = 1.0f;
    self.team2win.layer.borderColor = [UIColor blackColor].CGColor;
    self.team2win.layer.cornerRadius = 2.0f;
    
    self.spell1Inn.layer.borderWidth = 1.0f;
    self.spell1Inn.layer.borderColor = [UIColor blackColor].CGColor;
    self.spell1Inn.layer.cornerRadius = 2.0f;
    
    self.spell2Inn.layer.borderWidth = 1.0f;
    self.spell2Inn.layer.borderColor = [UIColor blackColor].CGColor;
    self.spell2Inn.layer.cornerRadius = 2.0f;
    
    self.spell3Inn.layer.borderWidth = 1.0f;
    self.spell3Inn.layer.borderColor = [UIColor blackColor].CGColor;
    self.spell3Inn.layer.cornerRadius = 2.0f;
}

- (IBAction)GroundBtnAction:(id)sender
{
    isteam1 = NO;
    isteam2 = NO;
    isGround = YES;
    isCompetition = NO;
    self.Poptable.hidden = NO;
    self.tableWidth.constant = self.groundView.frame.size.width;
    self.tableXposition.constant = self.groundView.frame.origin.x+5;
    self.tableYposition.constant = self.groundView.frame.origin.y+self.groundView.frame.size.height+20;
    //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Poptable reloadData];
    });
}

- (IBAction)CompetitionBtnAction:(id)sender {
    isteam1 = NO;
    isteam2 = NO;
    isGround = NO;
    isCompetition = YES;
    self.Poptable.hidden = NO;
    self.tableWidth.constant = self.competitionView.frame.size.width;
    self.tableXposition.constant = self.competitionView.frame.origin.x+5;
    self.tableYposition.constant = self.competitionView.frame.origin.y+self.competitionView.frame.size.height+20;
        //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Poptable reloadData];
    });
}


- (IBAction)Team1BtnAction:(id)sender
{
    isteam1 = YES;
    isteam2 = NO;
    isGround = NO;
    isCompetition = NO;
    self.Poptable.hidden = NO;
    
    
    self.tableWidth.constant = self.team1View.frame.size.width;
    self.tableXposition.constant = self.team1View.frame.origin.x+5;
    self.tableYposition.constant = self.team1View.frame.origin.y+5;
        //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Poptable reloadData];
    });
}

- (IBAction)Team2BtnAction:(id)sender {
    isteam1 = NO;
    isteam2 = YES;
    isGround = NO;
    isCompetition = NO;
    
    self.Poptable.hidden = NO;
    self.tableWidth.constant = self.team2View.frame.size.width;
    self.tableXposition.constant = self.InsideTeam2View.frame.origin.x+self.team2View.frame.origin.x;
    self.tableYposition.constant = self.InsideTeam2View.frame.origin.y+5;
        //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Poptable reloadData];
    });
}

- (IBAction)firstInningsButtonTapped:(id)sender {
    
//    check = [UIImage imageNamed:@"check"];
//    uncheck = [UIImage imageNamed:@"uncheck"];
    
    if([self.firstInn.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
    {
        [self.firstInn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        team1InnsNum = @"1";
    
    } else {
        [self.firstInn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        team1InnsNum = @"";
    }
}

- (IBAction)secondInningsButtonTapped:(id)sender {
    
    if([self.secondInn.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
        {
        [self.secondInn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        team2InnsNum = @"2";
        
        } else {
            [self.secondInn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            team2InnsNum = @"";
        }
}
- (IBAction)CSKWinButtonTapped:(id)sender {
    
    if([self.team1win.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
        {
        [self.team1win setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        } else {
            [self.team1win setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        }
}
- (IBAction)MIWinButtonTapped:(id)sender {
    
    if([self.team2win.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
        {
        [self.team2win setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        } else {
            [self.team2win setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        }
}


- (IBAction)oneToSixOversButtonTapped:(id)sender {
    
    if([self.spell1Inn.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
    {
        [self.spell1Inn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        fromOver = @"0";
        toOver = @"5";
        [self checkValidations];
    } else {
            [self.spell1Inn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            fromOver = @"";
            toOver = @"";
    }
}

- (IBAction)sevenToFifteenOversButtonTapped:(id)sender {
    
    if([self.spell2Inn.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
    {
        [self.spell2Inn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        fromOver = @"6";
        toOver = @"14";
        [self checkValidations];
    } else {
            [self.spell2Inn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            fromOver = @"";
            toOver = @"";
    }
}

- (IBAction)sixteenToTwentyOversButtonTapped:(id)sender {
    
    if([self.spell3Inn.currentImage isEqual:[UIImage imageNamed:@"uncheck"]])
        {
        [self.spell3Inn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        fromOver = @"15";
        toOver = @"19";
        [self checkValidations];
        } else {
            [self.spell3Inn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            fromOver = @"";
            toOver = @"";
        }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.commonArray.count;
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
    
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
    if(isteam1 == YES) {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBName"];
    }
    
     if(isteam2 == YES) {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBName"];
    }
    
    if(isCompetition == YES) {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"];
    }
  
    if(isGround == YES) {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"Ground"];
    }
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isteam1==YES)
    {
        self.team1TF.text = @"Chennai Super Kings";
        team1Code = @"TEA0000021";
        self.Poptable.hidden = YES;
    }
    
    if(isteam2==YES)
    {
        self.team2TF.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBName"];
        team2Code = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBcode"];
         self.Poptable.hidden = YES;
    }
    
    if(isCompetition == YES)
    {
        self.competitionTF.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"];
    competitionCode = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"CompetitionCode"];
        self.Poptable.hidden = YES;
    }
    
    if(isGround==YES)
    {
        self.groundTF.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"Ground"];
        groundCode = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"Groundcode"];
        self.Poptable.hidden = YES;
//        [self checkValidations];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (void)headToHeadPageLoadGetService {
    /*
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/FETCH_SCORECARD_PITCHMAP/
     METHOD     :   GET
     PARAMETER  :   {PLAYERCODE}/{MATCHCODE}/{INNGS}
     */
    
    if(![COMMON isInternetReachable])
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@/%@/%@",URL_FOR_RESOURCE(@""),HTHPageLoad, @"TEA0000001"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        self.commonArray = [[NSMutableArray alloc] init];
        self.commonArray = responseObject;
        [AppCommon hideLoading];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
    }];
}

- (void)checkValidations {
    
    if ([self.team1TF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Team1"];
    } else if ([self.team2TF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Team2"];
    } else if ([self.competitionTF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Competition"];
    } else if ([self.groundTF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Ground"];
    } else if ([team1InnsNum isEqualToString:@""] || team1InnsNum == (id)[NSNull null] || team1InnsNum.length == 0) {
        [self altermsg:@"Please Select 1st Innings"];
    } else if ([team1InnsNum isEqualToString:@""] || team1InnsNum == (id)[NSNull null] || team1InnsNum.length == 0) {
        [self altermsg:@"Please Select 2st Innings"];
    } else if ([fromOver isEqualToString:@""] || [toOver isEqualToString:@""] || team1InnsNum == (id)[NSNull null] || team1InnsNum.length == 0) {
        [self altermsg:@"Please Select Spell(From Overs and To Overs)"];
    } else {
        [self headToHeadResultsPostService];
    }
}

- (void)headToHeadResultsPostService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
        //** http://192.168.0.151:8044/AGAPTService.svc/APT_HTHRESULTS **//
    NSString *URLString =  URL_FOR_RESOURCE(HTHResults);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    /*
     "CompetitionCode":"UCC0000015",
     "TeamACode":"TEA0000021",
     "TeamBCode":"TEA0000028",
     "GroundCode":"GRD0000073",
     "ATInnsNum":"1",
     "BTInnsNum":"2",
     "FromOver":"1",
     "ToOver":"5"
     */
    
    /*
     "CompetitionCode":"UCC0000115",
     "TeamACode":"TEA0000001",
     "TeamBCode":"TEA0000009",
     "GroundCode":"",
     "ATInnsNum":"",
     "BTInnsNum":"2",
     "FromOver":"1",
     "ToOver":"5"
     */
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
//    [dic setObject:team1Code forKey:@"TeamACode"];
//    [dic setObject:team2Code forKey:@"TeamBCode"];
//    [dic setObject:competitionCode forKey:@"CompetitionCode"];
//    [dic setObject:groundCode forKey:@"GroundCode"];
//    [dic setObject:team1InnsNum forKey:@"ATInnsNum"];
//    [dic setObject:team2InnsNum forKey:@"BTInnsNum"];
//    [dic setObject:fromOver forKey:@"FromOver"];
//    [dic setObject:toOver forKey:@"ToOver"];
    
    [dic setObject:@"TEA0000001" forKey:@"TeamACode"];
    [dic setObject:@"TEA0000009" forKey:@"TeamBCode"];
    [dic setObject:@"UCC0000115" forKey:@"CompetitionCode"];
    [dic setObject:@"" forKey:@"GroundCode"];
    [dic setObject:@"" forKey:@"ATInnsNum"];
    [dic setObject:@"" forKey:@"BTInnsNum"];
    [dic setObject:@"1" forKey:@"FromOver"];
    [dic setObject:@"5" forKey:@"ToOver"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        NSMutableDictionary *h2hResultsDict = [[NSMutableDictionary alloc] init];
        h2hResultsDict = responseObject;
        [self assignH2HResultsArrayValuesToView:h2hResultsDict];
        
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
    
}

- (void)assignH2HResultsArrayValuesToView:(NSMutableDictionary *)h2hResultsDict {
    
    //Matches Win/Loss
    NSMutableArray *matchResultsArray = [h2hResultsDict valueForKey:@"Matchresults"];
    NSLog(@"matchResultsDict:%@", matchResultsArray);
    for (id key in matchResultsArray) {
        //Team-1
        self.playedT1Lbl.text = [self checkNSNumber:[key valueForKey:@"TeamA"]];
        self.playedT1PV.progress = 1 - [self.playedT1Lbl.text floatValue]/100;
        
        self.homeT1Lbl.text = [self checkNSNumber:[key valueForKey:@"HomeAT"]];
        self.homeT1PV.progress = 1 - [self.homeT1Lbl.text floatValue]/100;
        
        self.awayT1Lbl.text = [self checkNSNumber:[key valueForKey:@"AwayAT"]];
        self.awayT1PV.progress = 1 - [self.awayT1Lbl.text floatValue]/100;
        
        self.playOffsT1Lbl.text = [self checkNSNumber:[key valueForKey:@"PlayOffAT"]];
        self.playOffsT1PV.progress = 1 - [self.playOffsT1Lbl.text floatValue]/100;
        
        //Team-2
        self.playedT2Lbl.text = [self checkNSNumber:[key valueForKey:@"TeamB"]];
        self.playedT2PV.progress = [self.playedT2Lbl.text floatValue]/100;
        
        self.homeT2Lbl.text = [self checkNSNumber:[key valueForKey:@"HomeBT"]];
        self.homeT2PV.progress = [self.homeT2Lbl.text floatValue]/100;
        
        self.awayT2Lbl.text = [self checkNSNumber:[key valueForKey:@"AwayBT"]];
        self.awayT2PV.progress = [self.awayT2Lbl.text floatValue]/100;
        
        self.playOffsT2Lbl.text = [self checkNSNumber:[key valueForKey:@"PlayOffBT"]];
        self.playOffsT2PV.progress = [self.playOffsT2Lbl.text floatValue]/100;
    }
    
    //Team1 & Team2 Score Card and Progress View
    NSMutableArray *teamWideResultArray = [h2hResultsDict valueForKey:@"Teamwideresult"];
    NSLog(@"teamWideResultDict:%@", teamWideResultArray);
    for (id key in teamWideResultArray) {
        //Team1
        self.avgRunsT1Lbl.text = [self checkNSNumber:[key valueForKey:@"AAvgRuns"]];
        self.avgWicketsT1Lbl.text = [self checkNSNumber:[key valueForKey:@"AAvgwkts"]];
        self.avgRunsOrWicketsT1Lbl.text = [self checkNull:[key valueForKey:@"AAVGRW"]];
        self.highScoreT1Lbl.text = [self checkNull:[key valueForKey:@"ATHighscore"]];
        self.lowScoreT1Lbl.text = [self checkNull:[key valueForKey:@"ATLowscore"]];
        
        //Team1 Progress View
        int ATRuns = [[key valueForKey:@"ATRuns"] intValue];
        int BTRuns = [[key valueForKey:@"BTRuns"] intValue];
        int sum = ATRuns + BTRuns;
        self.runsScoredT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATRuns"]];
        self.runsScoredT1PV.progress = 1 - ATRuns/sum;
        
        self.runsScoredT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTRuns"]];
        int progress =  BTRuns/sum;
        //In Progress
        if (progress > 0.0 && progress <= 1.0) {
            self.runsScoredT2PV.progress = progress;
        }
        
        self.runsPerOverT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATOvers"]];
        self.runsPerOverT1PV.progress = 1 - [self.runsPerOverT1Lbl.text floatValue]/100;
        
        self.wicketsLostT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATWkts"]];
        self.wicketsLostT1PV.progress = 1 - [self.wicketsLostT1Lbl.text floatValue]/100;
        
        self.battingSRT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATBATSR"]];
        self.battingSRT1PV.progress = 1 - [self.battingSRT1Lbl.text floatValue]/100;
        
        self.dotBallPercentT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ADotBall"]];
        self.dotBallPercentT1PV.progress = 1 - [self.dotBallPercentT1Lbl.text floatValue]/100;
        
        self.boundariesPercentT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATBound"]];
        self.boundariesPercentT1PV.progress = 1 - [self.dotBallPercentT1Lbl.text floatValue]/100;
        
        self.bowlingSRT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ABowlingSR"]];
        self.bowlingSRT1PV.progress = 1 - [self.bowlingSRT1Lbl.text floatValue]/100;
        
        self.bowlingAvgT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ABowlingAvg"]];
        self.bowlingAvgT1PV.progress = 1 - [self.bowlingAvgT1Lbl.text floatValue]/100;
        
        //Team2
        self.avgRunsT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BAvgRuns"]];
        self.avgWicketsT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BAvgwkts"]];
        self.avgRunsOrWicketsT1Lbl.text = [self checkNull:[key valueForKey:@"BAVGRW"]];
        self.highScoreT2Lbl.text = [self checkNull:[key valueForKey:@"BTHighscore"]];
        self.lowScoreT2Lbl.text = [self checkNull:[key valueForKey:@"BTLowscore"]];
        
        //Team2 Progress View
        self.runsPerOverT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTOvers"]];
        self.runsPerOverT2PV.progress = [self.runsPerOverT2Lbl.text floatValue]/100;
        
        self.wicketsLostT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTWkts"]];
        self.wicketsLostT2PV.progress = [self.wicketsLostT2Lbl.text floatValue]/100;
        
        self.battingSRT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTBATSR"]];
        self.battingSRT2PV.progress = [self.battingSRT2Lbl.text floatValue]/100;
        
        self.dotBallPercentT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BDotBall"]];
        self.dotBallPercentT2PV.progress = [self.dotBallPercentT2Lbl.text floatValue]/100;
        
        self.boundariesPercentT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTBound"]];
        self.boundariesPercentT2PV.progress = [self.dotBallPercentT2Lbl.text floatValue]/100;
        
        self.bowlingSRT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BBowlingSR"]];
        self.bowlingSRT2PV.progress = [self.bowlingSRT2Lbl.text floatValue]/100;
        
        self.bowlingAvgT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BBowlingAvg"]];
        self.bowlingAvgT2PV.progress = [self.bowlingAvgT2Lbl.text floatValue]/100;
    }
    
    //Toss Decision
    NSMutableArray *tossResultsArray = [h2hResultsDict valueForKey:@"Tossresults"];
    NSLog(@"tossResults:%@", tossResultsArray);
    //Team-1
    for (id key in tossResultsArray) {
        self.tossWonT1Lbl.text = [self checkNSNumber:[key valueForKey:@"TosswonTeamA"]];
        self.tossWonT1PV.progress = 1 - [self.tossWonT1Lbl.text floatValue]/100;
        
        self.decisionBatT1Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBattingA"]];
        self.decisionBatT1PV.progress = 1 - [self.decisionBatT1Lbl.text floatValue]/100;
        
        self.decisionBowlT1Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBowlingA"]];
        self.decisionBowlT1PV.progress = 1 - [self.decisionBowlT1Lbl.text floatValue]/100;
        
        self.battingFirstInnWinT1Lbl.text = [self checkNSNumber:[key valueForKey:@"BatFirstInnsTeamA"]];
        self.battingFirstInnWinT1PV.progress = 1 - [self.battingFirstInnWinT1Lbl.text floatValue]/100;
        
        self.battingSecondInnWinT1Lbl.text = [self checkNSNumber:[key valueForKey:@"BatSecondInnsTeamA"]];
        self.battingSecondInnWinT1PV.progress = 1 - [self.battingSecondInnWinT1Lbl.text floatValue]/100;
        
        //Team-2
        self.tossWonT2Lbl.text = [self checkNSNumber:[key valueForKey:@"TosswonTeamB"]];
        self.tossWonT2PV.progress = [self.tossWonT2Lbl.text floatValue]/100;
        
        self.decisionBatT2Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBattingB"]];
        self.decisionBatT2PV.progress = [self.decisionBatT2Lbl.text floatValue]/100;
        
        self.decisionBowlT2Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBowlingB"]];
        self.decisionBowlT2PV.progress = [self.decisionBowlT2Lbl.text floatValue]/100;
        
        self.battingFirstInnWinT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BatFirstInnsTeamB"]];
        self.battingFirstInnWinT2PV.progress = [self.battingFirstInnWinT2Lbl.text floatValue]/100;
        
        self.battingSecondInnWinT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BatSecondInnsTeamB"]];
        self.battingSecondInnWinT2PV.progress = [self.battingSecondInnWinT2Lbl.text floatValue]/100;
    }
}

-(void)altermsg:(NSString *) message
{
    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Add Illness" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objaltert show];
}

- (NSString *)checkNSNumber:(id)unknownTypeParameter {
    
    NSString *str;
    if([unknownTypeParameter isKindOfClass:[NSNumber class]])
        {
        
        NSNumber *vv = [self checkNull:unknownTypeParameter];
        str = [vv stringValue];
        }
    else
        {
        str = [self checkNull:unknownTypeParameter];
        }
    return str;
}

- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

@end
