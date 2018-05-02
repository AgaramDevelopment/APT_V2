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
#import "AppCommon.h"
#import "Header.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TeamHeadToHead () <selectedDropDown>
{
    BOOL isteam1;
    BOOL isteam2;
    BOOL isGround;
    BOOL isCompetition;
    
    NSString *team1Code;
    NSString *team2Code;
    NSString *groundCode;
    NSString *competitionCode;
    
    NSString *team1InnsNum, *team2InnsNum, *tossWonTeamCode, *fromOver, *toOver;
    NSString *teamName, *competitionName;
    NSInteger teamCount;
}

@property (nonatomic, strong) IBOutlet NSMutableArray *commonArray;
@property (nonatomic, strong) IBOutlet NSMutableArray *commonArray1;
//@property (nonatomic, strong) IBOutlet NSMutableArray *h2hResultsArray;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableYposition;

@end

@implementation TeamHeadToHead

@synthesize competitionTF,team1TF,team2TF,groundTF;

@synthesize competitionView,team1View,team2View,groundView;

@synthesize firstInn,secondInn;

@synthesize team1win,team2win;

@synthesize spell1Inn,spell2Inn,spell3Inn;

@synthesize viewTeamOvers,viewTeamWin,btnInnsAll;

@synthesize btnAllOvers,btnAllWinTeams,viewTeamWidth;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Hide navigationController
    self.navigationController.navigationBarHidden = YES;
    // For initial API call no need any below values
    groundCode = @"";
    team1InnsNum = @"" ;
    team2InnsNum = @"";
    tossWonTeamCode = @"";
    fromOver = @"";
    toOver = @"";
    
    team1Code = [[NSUserDefaults standardUserDefaults] stringForKey:@"CAPTeamcode"];
    team1TF.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedTeamName"];
    NSString *team1Win = [NSString stringWithFormat:@"%@ Win", team1TF.text];
    self.team1Win.text = team1Win;
    groundTF.text = @"All";
    self.Poptable.hidden = YES;
    
    [btnInnsAll setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [btnAllWinTeams setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [btnAllOvers setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];

    [self headToHeadPageLoadGetService];
    
    if (IS_IPHONE4 || IS_IPHONE5) {
        viewTeamWidth.constant = 50;
        [self.view layoutIfNeeded];
    }
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
    self.commonArray = [NSMutableArray new];
    NSArray* temparray = [self getCorrespondingGrounds];
    
    for (NSDictionary* temp1 in temparray) {
        if (![[self.commonArray valueForKey:@"Groundcode"] containsObject:[temp1 valueForKey:@"Groundcode"]]) {
            [self.commonArray addObject:temp1];
        }
    }
    
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
    self.commonArray = [NSMutableArray new];
    NSLog(@"%@", appDel.ArrayCompetition);
    self.commonArray = appDel.ArrayCompetition;
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
    
    self.commonArray = [NSMutableArray new];
    self.commonArray = self.commonArray1;
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
    self.commonArray = [NSMutableArray new];
    self.commonArray = self.commonArray1;
    self.tableWidth.constant = self.team2View.frame.size.width;
    self.tableXposition.constant = self.InsideTeam2View.frame.origin.x+self.team2View.frame.origin.x;
    self.tableYposition.constant = self.InsideTeam2View.frame.origin.y+5;
    //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Poptable reloadData];
    });
}

- (IBAction)firstInningsAction:(id)sender {
    team1InnsNum = @"1";
    [self headToHeadResultsPostService];
}
- (IBAction)secondInningsAction:(id)sender {
    team2InnsNum = @"2";
    [self headToHeadResultsPostService];
}

- (IBAction)CSKWinAction:(id)sender {
    tossWonTeamCode = @"TEA0000010";
    [self headToHeadResultsPostService];
}
- (IBAction)MIWinAction:(id)sender {
    tossWonTeamCode = @"TEA0000008";
    [self headToHeadResultsPostService];
}
- (IBAction)oneToSixOversAction:(id)sender {
    fromOver = @"0";
    toOver = @"5";
    [self headToHeadResultsPostService];
}
- (IBAction)sevenToFifteenOversAction:(id)sender {
    fromOver = @"6";
    toOver = @"14";
    [self headToHeadResultsPostService];
}
- (IBAction)sixteenToTwentyOversAction:(id)sender {
    fromOver = @"15";
    toOver = @"19";
    [self headToHeadResultsPostService];
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
        self.team1TF.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBName"];
        team1Code = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBcode"];
        
        if ([self.team1TF.text isEqualToString:self.team2TF.text]) {
            [self altermsg:@"Please Select different Team for Team-A"];
            self.team1TF.text = @"";
            team1Code = @"";
        }
        self.Poptable.hidden = YES;
    }
    
    if(isteam2==YES)
    {
        self.team2TF.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBName"];
        team2Code = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamBcode"];
        
        if ([self.team1TF.text isEqualToString:self.team2TF.text]) {
            [self altermsg:@"Please Select different Team for Team-B"];
            self.team2TF.text = @"";
            team2Code = @"";
        }
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
        [self checkValidations];
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
        return;
    
    [AppCommon showLoading];
    
    NSString* CAP_teamcode = [[NSUserDefaults standardUserDefaults] stringForKey:@"CAPTeamcode"];
    NSString *API_URL = [NSString stringWithFormat:@"%@%@/%@",URL_FOR_RESOURCE(@""),HTHPageLoad, CAP_teamcode];
    NSLog(@"API URL %@ ",API_URL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        
        if (responseObject) {
            self.commonArray1 = [[NSMutableArray alloc] init];
            /*
            NSMutableArray *responseArray = [NSMutableArray new];
            responseArray = [responseObject mutableCopy];
            NSLog(@"responseArray1:%@", responseArray);
            [responseArray addObject:
             @{
               @"CompetitionCode": @"",
               @"CompetitionName": @"All",
               @"Groundcode": @"",
               @"Ground": @"All"
               }];
            NSLog(@"responseArray2:%@", responseArray);
            
            self.commonArray1 = responseArray;
            */
            
            self.commonArray1 = responseObject;
            
            if (self.commonArray1.count) {
                
                // To get team name by logined team code
                
                team2TF.text = [[self.commonArray1 firstObject] valueForKey:@"TeamBName"];
                team2Code = [[self.commonArray1 firstObject] valueForKey:@"TeamBcode"];
                NSString *team2Win = [NSString stringWithFormat:@"%@ Win", [[self.commonArray1 firstObject] valueForKey:@"TeamBName"]];
                self.team2Win.text = team2Win;
                
                competitionTF.text = [[self.commonArray1 firstObject] valueForKey:@"CompetitionName"];
                competitionCode = [[self.commonArray1 firstObject] valueForKey:@"CompetitionCode"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self headToHeadResultsPostService];
                });
            }
        }
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
    }];
}

-(NSArray *)getCorrespondingOppenentTeams
{

//    NSString* loginTeamCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"CAPTeamcode"];
    NSPredicate* predicate;
//
    if ([competitionTF.text isEqualToString:@"All"] || [groundTF.text isEqualToString:@"All"]) {
//        return  appDel.ArrayTeam;

        predicate = [NSPredicate predicateWithFormat:@"CompetitionCode != %@",@""];
        

    }
    else{

        predicate = [NSPredicate predicateWithFormat:@"CompetitionCode == %@",competitionCode];
    }

//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"CompetitionCode == %@",competitionCode];

    NSArray* temparray = [self.commonArray1 filteredArrayUsingPredicate:predicate];
    
    NSMutableArray* resultedArray = [NSMutableArray new];
    for (NSDictionary* dict in temparray) {
        if (![[resultedArray valueForKey:@"TeamBcode"] containsObject:[dict valueForKey:@"TeamBcode"]]) {
            [resultedArray addObject:dict];
        }
    }
    return resultedArray;
}

-(NSArray *)getCorrespondingGrounds
{
    // based on competetion code and logined team code
    
    NSPredicate* predicate;
    
    if ([competitionTF.text isEqualToString:@"All"]) {
        
        predicate = [NSPredicate predicateWithFormat:@"CompetitionCode != %@",@""];

    }
//    else if ([competitionTF.text isEqualToString:@"All"]) {
//
//        predicate = [NSPredicate predicateWithFormat:@"CompetitionCode != %@ AND TeamBcode == %@",competitionCode,team2Code];
//
//    }
//    else if ([team2TF.text isEqualToString:@"All"]) {
//
//        predicate = [NSPredicate predicateWithFormat:@"CompetitionCode == %@ AND TeamBcode != %@",competitionCode,team2Code];
//
//    }
    else{
        
        predicate = [NSPredicate predicateWithFormat:@"CompetitionCode == %@",competitionCode];
    }
    
    NSArray* result = [appDel.MainArray filteredArrayUsingPredicate:predicate];
    
    return result;
}

- (void)checkValidations {
    
    if ([self.team1TF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Team1"];
    } else if ([self.team2TF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Team2"];
    } else if ([self.competitionTF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Competition"];
    }
 /*   else if ([self.groundTF.text isEqualToString:@""])
    {
        [self altermsg:@"Please Select Ground"];
    } */
    else {
         [self headToHeadResultsPostService];
    }
}

- (void)headToHeadResultsPostService {
    
    /*
     http://localhost:58774/AGAPTService.svc/APT_HTHRESULTS
     {"CompetitionCode":"UCC0000008",
     "TeamACode":"TEA0000008",
     "TeamBCode":"TEA0000010",
     "GroundCode":"",
     "ATInnsNum":"",
     "BTInnsNum":"",
     "TossWonTeamCode":"TEA0000010",
     "FromOver":"0",
     "ToOver":"19"
     }
     */
    
    if(![COMMON isInternetReachable])
        return;
    
    else if (!team1TF.hasText || !team2TF.hasText)
    {
        return;
    }
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(HTHResults);
    
    
    NSLog(@"URL %@ ",URLString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic    setObject:competitionCode     forKey:@"CompetitionCode"];
    [dic    setObject:team1Code     forKey:@"TeamACode"];
    [dic    setObject:team2Code     forKey:@"TeamBCode"];
    [dic    setObject:groundCode     forKey:@"GroundCode"];
    [dic    setObject:team1InnsNum     forKey:@"ATInnsNum"];
    [dic    setObject:team2InnsNum     forKey:@"BTInnsNum"];
    [dic    setObject:tossWonTeamCode     forKey:@"TossWonTeamCode"];
    [dic    setObject:fromOver     forKey:@"FromOver"];
    [dic    setObject:toOver     forKey:@"ToOver"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if (responseObject) {
            NSMutableDictionary *h2hResultsDict = [[NSMutableDictionary alloc] init];
            h2hResultsDict = responseObject;
            [self assignH2HResultsArrayValuesToView:h2hResultsDict];
        }
        
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
        
        self.playedLbl.text = [self checkNSNumber:[key valueForKey:@"Matches"]];
        self.nrORtieLbl.text = [NSString stringWithFormat:@"No Results %@", [self checkNSNumber:[key valueForKey:@"NR"]]];
        
        //Team-1
        self.playedT1Lbl.text = [self checkNSNumber:[key valueForKey:@"TeamA"]];
//        self.playedT1PV.progress = 1 - [self.playedT1Lbl.text floatValue]/100;
         self.playedT2Lbl.text = [self checkNSNumber:[key valueForKey:@"TeamB"]];
        float playedTotal = [self.playedT1Lbl.text floatValue] + [self.playedT2Lbl.text floatValue];
        self.playedT1PV.progress = 1 - [self.playedT1Lbl.text floatValue]/playedTotal;
        
        self.homeT1Lbl.text = [self checkNSNumber:[key valueForKey:@"HomeAT"]];
//        self.homeT1PV.progress = 1 - [self.homeT1Lbl.text floatValue]/100;
        self.homeT2Lbl.text = [self checkNSNumber:[key valueForKey:@"HomeBT"]];
        float homeTotal = [self.homeT1Lbl.text floatValue] + [self.homeT2Lbl.text floatValue];
        self.homeT1PV.progress = 1 - [self.homeT1Lbl.text floatValue]/homeTotal;
        
        self.awayT1Lbl.text = [self checkNSNumber:[key valueForKey:@"AwayAT"]];
//        self.awayT1PV.progress = 1 - [self.awayT1Lbl.text floatValue]/100;
        self.awayT2Lbl.text = [self checkNSNumber:[key valueForKey:@"AwayBT"]];
        float awayTotal = [self.awayT1Lbl.text floatValue] + [self.awayT2Lbl.text floatValue];
        self.awayT1PV.progress = 1 - [self.awayT1Lbl.text floatValue]/awayTotal;
        
        self.playOffsT1Lbl.text = [self checkNSNumber:[key valueForKey:@"PlayOffAT"]];
//        self.playOffsT1PV.progress = 1 - [self.playOffsT1Lbl.text floatValue]/100;
        self.playOffsT2Lbl.text = [self checkNSNumber:[key valueForKey:@"PlayOffBT"]];
        float playOffsTotal = [self.playOffsT1Lbl.text floatValue] + [self.playOffsT2Lbl.text floatValue];
        self.playOffsT1PV.progress = 1 - [self.playOffsT1Lbl.text floatValue]/playOffsTotal;
        
        //Team-2
//        self.playedT2PV.progress = [self.playedT2Lbl.text floatValue]/100;
        if (playedTotal > 0) {
            self.playedT2PV.progress = [self.playedT2Lbl.text floatValue]/playedTotal;
        } else {
            self.playedT2PV.progress = 0;
        }
        
//        self.homeT2PV.progress = [self.homeT2Lbl.text floatValue]/100;
        if (homeTotal > 0) {
            self.homeT2PV.progress = [self.homeT2Lbl.text floatValue]/homeTotal;
        } else {
            self.homeT2PV.progress = 0;
        }
        
//        self.awayT2PV.progress = [self.awayT2Lbl.text floatValue]/100;
        if (awayTotal > 0) {
            self.awayT2PV.progress = [self.awayT2Lbl.text floatValue]/awayTotal;
        } else {
            self.awayT2PV.progress = 0;
        }
        
//        self.playOffsT2PV.progress = [self.playOffsT2Lbl.text floatValue]/100;
        if (playOffsTotal > 0) {
            self.playOffsT2PV.progress = [self.playOffsT2Lbl.text floatValue]/playOffsTotal;
        } else {
            self.playOffsT2PV.progress = 0;
        }
        
    }
    
    //Team1 & Team2 Score Card and Progress View
    NSMutableArray *teamWideResultArray = [h2hResultsDict valueForKey:@"Teamwideresult"];
    NSLog(@"teamWideResultDict:%@", teamWideResultArray);
    for (id key in teamWideResultArray) {
        //Images
        [self.team1ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [key valueForKey:@"ATLogo"]]] placeholderImage:[UIImage imageNamed:@"no-image"]]; //team_logo_csk
        [self.team2ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [key valueForKey:@"BTLogo"]]] placeholderImage:[UIImage imageNamed:@"no-image"]]; //srh_lgo
        
        NSLog(@"ATLogo:%@", [key valueForKey:@"ATLogo"]);
        NSLog(@"BTLogo:%@", [key valueForKey:@"BTLogo"]);
        
        //Team1
        self.avgRunsT1Lbl.text = [self checkNull:[[key valueForKey:@"AAvgRuns"]stringValue]];
        self.avgWicketsT1Lbl.text = [self checkNull:[[key valueForKey:@"AAvgwkts"]stringValue]];
        self.avgRunsOrWicketsT1Lbl.text = [self checkNull:[key valueForKey:@"AAVGRW"]];
        self.highScoreT1Lbl.text = [self checkNull:[key valueForKey:@"ATHighscore"]];
        self.lowScoreT1Lbl.text = [self checkNull:[key valueForKey:@"ATLowscore"]];
        
        //Team1 Progress View
        self.runsScoredT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATRuns"]];
//        self.runsScoredT1PV.progress = 1 - [self.runsScoredT1Lbl.text floatValue]/100;
        self.runsScoredT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTRuns"]];
        float runsScoredTotal = [self.runsScoredT1Lbl.text floatValue] + [self.runsScoredT2Lbl.text floatValue];
        self.runsScoredT1PV.progress = 1 - [self.runsScoredT1Lbl.text floatValue]/runsScoredTotal;
        
        self.runsPerOverT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATOvers"]];
//        self.runsPerOverT1PV.progress = 1 - [self.runsPerOverT1Lbl.text floatValue]/100;
         self.runsPerOverT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTOvers"]];
        float runsPerOverTotal = [self.runsPerOverT1Lbl.text floatValue] + [self.runsPerOverT2Lbl.text floatValue];
        self.runsPerOverT1PV.progress = 1 - [self.runsPerOverT1Lbl.text floatValue]/runsPerOverTotal;
        
        self.wicketsLostT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATWkts"]];
//        self.wicketsLostT1PV.progress = 1 - [self.wicketsLostT1Lbl.text floatValue]/100;
        self.wicketsLostT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTWkts"]];
        float wicketsLostTotal = [self.wicketsLostT1Lbl.text floatValue] + [self.wicketsLostT2Lbl.text floatValue];
        self.wicketsLostT1PV.progress = 1 - [self.wicketsLostT1Lbl.text floatValue]/wicketsLostTotal;
        
        self.battingSRT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATBATSR"]];
//        self.battingSRT1PV.progress = 1 - [self.battingSRT1Lbl.text floatValue]/100;
        self.battingSRT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTBATSR"]];
        float battingSRTotal = [self.battingSRT1Lbl.text floatValue] + [self.battingSRT2Lbl.text floatValue];
        self.battingSRT1PV.progress = 1 - [self.battingSRT1Lbl.text floatValue]/battingSRTotal;
        
        self.dotBallPercentT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ADotBall"]];
//        self.dotBallPercentT1PV.progress = 1 - [self.dotBallPercentT1Lbl.text floatValue]/100;
        self.dotBallPercentT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BDotBall"]];
        float dotBallPercentTotal = [self.dotBallPercentT1Lbl.text floatValue] + [self.dotBallPercentT2Lbl.text floatValue];
        self.dotBallPercentT1PV.progress = 1 - [self.dotBallPercentT1Lbl.text floatValue]/dotBallPercentTotal;
        
        self.boundariesPercentT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ATBound"]];
//        self.boundariesPercentT1PV.progress = 1 - [self.boundariesPercentT1Lbl.text floatValue]/100;
        self.boundariesPercentT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BTBound"]];
        float boundariesPercentTotal = [self.boundariesPercentT1Lbl.text floatValue] + [self.boundariesPercentT2Lbl.text floatValue];
        self.boundariesPercentT1PV.progress = 1 - [self.boundariesPercentT1Lbl.text floatValue]/boundariesPercentTotal;
        
        self.bowlingSRT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ABowlingSR"]];
//        self.bowlingSRT1PV.progress = 1 - [self.bowlingSRT1Lbl.text floatValue]/100;
        self.bowlingSRT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BBowlingSR"]];
        float bowlingSRTotal = [self.bowlingSRT1Lbl.text floatValue] + [self.bowlingSRT2Lbl.text floatValue];
        self.bowlingSRT1PV.progress = 1 - [self.bowlingSRT1Lbl.text floatValue]/bowlingSRTotal;
        
        self.bowlingAvgT1Lbl.text = [self checkNSNumber:[key valueForKey:@"ABowlingAvg"]];
//        self.bowlingAvgT1PV.progress = 1 - [self.bowlingAvgT1Lbl.text floatValue]/100;
        self.bowlingAvgT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BBowlingAvg"]];
        float bowlingAvgTotal = [self.bowlingAvgT1Lbl.text floatValue] + [self.bowlingAvgT2Lbl.text floatValue];
        self.bowlingAvgT1PV.progress = 1 - [self.bowlingAvgT1Lbl.text floatValue]/bowlingAvgTotal;
        
        //Team2
        self.avgRunsT2Lbl.text = [self checkNull:[[key valueForKey:@"BAvgRuns"]stringValue]];
        self.avgWicketsT2Lbl.text = [self checkNull:[[key valueForKey:@"BAvgwkts"]stringValue]];
        self.avgRunsOrWicketsT2Lbl.text = [self checkNull:[key valueForKey:@"BAVGRW"]];
        self.highScoreT2Lbl.text = [self checkNull:[key valueForKey:@"BTHighscore"]];
        self.lowScoreT2Lbl.text = [self checkNull:[key valueForKey:@"BTLowscore"]];
        
        //Team2 Progress View
        
//        self.runsScoredT2PV.progress = [self.runsScoredT2Lbl.text floatValue]/100;
        if (runsScoredTotal > 0) {
            self.runsScoredT2PV.progress = [self.runsScoredT2Lbl.text floatValue]/runsScoredTotal;
        } else {
            self.runsScoredT2PV.progress = 0;
        }
      
//        self.runsPerOverT2PV.progress = [self.runsPerOverT2Lbl.text floatValue]/100;
        if (runsPerOverTotal > 0) {
            self.runsPerOverT2PV.progress = [self.runsPerOverT2Lbl.text floatValue]/runsPerOverTotal;
        } else {
            self.runsPerOverT2PV.progress = 0;
        }
        
//        self.wicketsLostT2PV.progress = [self.wicketsLostT2Lbl.text floatValue]/100;
        if (wicketsLostTotal > 0) {
            self.wicketsLostT2PV.progress = [self.wicketsLostT2Lbl.text floatValue]/wicketsLostTotal;
        } else {
            self.wicketsLostT2PV.progress = 0;
        }
        
//        self.battingSRT2PV.progress = [self.battingSRT2Lbl.text floatValue]/100;
        if (battingSRTotal > 0) {
            self.battingSRT2PV.progress = [self.battingSRT2Lbl.text floatValue]/battingSRTotal;
        } else {
            self.battingSRT2PV.progress = 0;
        }
        
//        self.dotBallPercentT2PV.progress = [self.dotBallPercentT2Lbl.text floatValue]/100;
        if (dotBallPercentTotal > 0) {
            self.dotBallPercentT2PV.progress = [self.dotBallPercentT2Lbl.text floatValue]/dotBallPercentTotal;
        } else {
            self.dotBallPercentT2PV.progress = 0;
        }
        
//        self.boundariesPercentT2PV.progress = [self.dotBallPercentT2Lbl.text floatValue]/100;
        if (boundariesPercentTotal > 0) {
             self.boundariesPercentT2PV.progress = [self.boundariesPercentT2Lbl.text floatValue]/boundariesPercentTotal;
        } else {
            self.boundariesPercentT2PV.progress = 0;
        }
       
//        self.bowlingSRT2PV.progress = [self.bowlingSRT2Lbl.text floatValue]/100;
        if (bowlingSRTotal > 0) {
            self.bowlingSRT2PV.progress = [self.bowlingSRT2Lbl.text floatValue]/bowlingSRTotal;
        } else {
            self.bowlingSRT2PV.progress = 0;
        }
        
//        self.bowlingAvgT2PV.progress = [self.bowlingAvgT2Lbl.text floatValue]/100;
        if (bowlingAvgTotal > 0) {
            self.bowlingAvgT2PV.progress = [self.bowlingAvgT2Lbl.text floatValue]/bowlingAvgTotal;
        } else {
            self.bowlingAvgT2PV.progress = 0;
        }
        
    }
    
    //Toss Decision
    NSMutableArray *tossResultsArray = [h2hResultsDict valueForKey:@"Tossresults"];
    NSLog(@"tossResults:%@", tossResultsArray);
    //Team-1
    for (id key in tossResultsArray) {
        
        self.tossWonT1Lbl.text = [self checkNSNumber:[key valueForKey:@"TosswonTeamA"]];
//        self.tossWonT1PV.progress = 1 - [self.tossWonT1Lbl.text floatValue]/100;
        self.tossWonT2Lbl.text = [self checkNSNumber:[key valueForKey:@"TosswonTeamB"]];
        float tossWonTotal = [self.tossWonT1Lbl.text floatValue] + [self.tossWonT2Lbl.text floatValue];
        self.tossWonT1PV.progress = 1 - [self.tossWonT1Lbl.text floatValue]/tossWonTotal;
        
        self.decisionBatT1Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBattingA"]];
//        self.decisionBatT1PV.progress = 1 - [self.decisionBatT1Lbl.text floatValue]/100;
         self.decisionBatT2Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBattingB"]];
        float decisionBatTotal = [self.decisionBatT1Lbl.text floatValue] + [self.decisionBatT2Lbl.text floatValue];
        self.decisionBatT1PV.progress = 1 - [self.decisionBatT1Lbl.text floatValue]/decisionBatTotal;
        
        self.decisionBowlT1Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBowlingA"]];
//        self.decisionBowlT1PV.progress = 1 - [self.decisionBowlT1Lbl.text floatValue]/100;
        self.decisionBowlT2Lbl.text = [self checkNSNumber:[key valueForKey:@"DecisionBowlingB"]];
        float decisionBowlTotal = [self.decisionBowlT1Lbl.text floatValue] + [self.decisionBowlT2Lbl.text floatValue];
        self.decisionBowlT1PV.progress = 1 - [self.decisionBowlT1Lbl.text floatValue]/decisionBowlTotal;
        
        self.battingFirstInnWinT1Lbl.text = [self checkNSNumber:[key valueForKey:@"BatFirstInnsTeamA"]];
//        self.battingFirstInnWinT1PV.progress = 1 - [self.battingFirstInnWinT1Lbl.text floatValue]/100;
         self.battingFirstInnWinT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BatFirstInnsTeamB"]];
        float battingFirstInnWinTotal = [self.battingFirstInnWinT1Lbl.text floatValue] + [self.battingFirstInnWinT2Lbl.text floatValue];
        self.battingFirstInnWinT1PV.progress = 1 - [self.battingFirstInnWinT1Lbl.text floatValue]/battingFirstInnWinTotal;
        
        self.battingSecondInnWinT1Lbl.text = [self checkNSNumber:[key valueForKey:@"BatSecondInnsTeamA"]];
//        self.battingSecondInnWinT1PV.progress = 1 - [self.battingSecondInnWinT1Lbl.text floatValue]/100;
        self.battingSecondInnWinT2Lbl.text = [self checkNSNumber:[key valueForKey:@"BatSecondInnsTeamB"]];
        float battingSecondInnWinTotal = [self.battingSecondInnWinT1Lbl.text floatValue] + [self.battingSecondInnWinT2Lbl.text floatValue];
        self.battingSecondInnWinT1PV.progress = 1 - [self.battingSecondInnWinT1Lbl.text floatValue]/battingSecondInnWinTotal;
        
        //Team-2
//        self.tossWonT2PV.progress = [self.tossWonT2Lbl.text floatValue]/100;
        if (tossWonTotal > 0) {
            self.tossWonT2PV.progress = [self.tossWonT2Lbl.text floatValue]/tossWonTotal;
        } else {
            self.tossWonT2PV.progress = 0;
        }
        
//        self.decisionBatT2PV.progress = [self.decisionBatT2Lbl.text floatValue]/100;
        if (decisionBatTotal > 0) {
            self.decisionBatT2PV.progress = [self.decisionBatT2Lbl.text floatValue]/decisionBatTotal;
        } else {
            self.decisionBatT2PV.progress = 0;
        }
        
//        self.decisionBowlT2PV.progress = [self.decisionBowlT2Lbl.text floatValue]/100;
        if (decisionBowlTotal > 0) {
            self.decisionBowlT2PV.progress = [self.decisionBowlT2Lbl.text floatValue]/decisionBowlTotal;
        } else {
            self.decisionBowlT2PV.progress = 0;
        }
        
//        self.battingFirstInnWinT2PV.progress = [self.battingFirstInnWinT2Lbl.text floatValue]/100;
        if (battingFirstInnWinTotal > 0) {
            self.battingFirstInnWinT2PV.progress = [self.battingFirstInnWinT2Lbl.text floatValue]/battingFirstInnWinTotal;
        } else {
            self.battingFirstInnWinT2PV.progress = 0;
        }
        
//        self.battingSecondInnWinT2PV.progress = [self.battingSecondInnWinT2Lbl.text floatValue]/100;
        if (battingSecondInnWinTotal > 0) {
            self.battingSecondInnWinT2PV.progress = [self.battingSecondInnWinT2Lbl.text floatValue]/battingSecondInnWinTotal;
        } else {
            self.battingSecondInnWinT2PV.progress = 0;
        }
    }
}

-(void)altermsg:(NSString *) message
{
    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Head To Head" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"] || [_value isEqualToString:@""]) {
        _value=@"0";
    }
    return _value;
}

- (IBAction)actionDropDowns:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    
    if ([sender tag] == 2) // Competitions
    {
//        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        NSMutableArray* arr = [NSMutableArray new];
        [arr addObjectsFromArray:appDel.ArrayCompetition];
        NSDictionary* temp = @{
                               @"CompetitionCode": @"",
                               @"CompetitionName": @"All",
                               @"Groundcode": @"",
                               @"Ground": @"All"
                               };
        [arr insertObject:temp atIndex:0];
        dropVC.array = arr;

        
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(competitionView.frame), CGRectGetMaxY(competitionView.superview.frame)+70, CGRectGetWidth(competitionView.frame), 300)];
        
    }
    else if ([sender tag] == 3) // Ground
    {
        if (!competitionTF.hasText) {
            [AppCommon showAlertWithMessage:@"Please select Competetion Name"];
            return;
        }
//        else if (!team2TF.hasText) {
//            [AppCommon showAlertWithMessage:@"Please select opponent Team"];
//            return;
//        }
        
        
        NSArray* temparray = [self getCorrespondingGrounds];
        NSMutableArray* arr = [NSMutableArray new];
        for (NSDictionary* temp1 in temparray) {
            if (![[arr valueForKey:@"GroundCode"] containsObject:[temp1 valueForKey:@"GroundCode"]]) {
                [arr addObject:temp1];
            }
        }
        NSDictionary* temp = @{
                               @"CompetitionCode": @"",
                               @"CompetitionName": @"All",
                               @"GroundCode": @"",
                               @"GroundName": @"All"
                               };
        [arr insertObject:temp atIndex:0];
        
        dropVC.array = arr;
        dropVC.key = @"GroundName";
        
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(groundView.frame), CGRectGetMaxY(groundView.superview.frame)+70, CGRectGetWidth(groundView.frame), 300)];
        
        
    }
    else if ([sender tag] == 0) { // Teams 1
        teamCount = 1;
        dropVC.array = [self getCorrespondingOppenentTeams];
        
        dropVC.key = @"TeamBName";
        
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(team1View.frame), CGRectGetMaxY(team1View.superview.frame)+70, CGRectGetWidth(team1View.frame), 300)];
        
    }
    else if ([sender tag] == 1) // Teams 2
    {
        
        if (!competitionTF.hasText) {
            [AppCommon showAlertWithMessage:@"Please select Competetion Name"];
            return;
        }
        //        else if (!groundTF.hasText) {
        //            [AppCommon showAlertWithMessage:@"Please select Ground Name"];
        //            return;
        //        }
//        else if (!groundTF.hasText) {
//            [AppCommon showAlertWithMessage:@"Please select Ground"];
//            return;
//        }
        
        teamCount = 2;
        dropVC.array = [self getCorrespondingOppenentTeams];
        //        dropVC.array = self.commonArray1;
        dropVC.key = @"TeamBName";
        
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(team2View.frame), CGRectGetMaxY(team2View.superview.frame)+70, CGRectGetWidth(team2View.frame), 300)];
        
    }
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];
    
}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    if ([key  isEqualToString: @"CompetitionName"]) {
        
        
            NSLog(@"%@",array[Index.row]);
            NSLog(@"selected value %@",key);
            competitionTF.text = [[array objectAtIndex:Index.row] valueForKey:key];
            competitionCode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        
        if (![[[array objectAtIndex:Index.row] valueForKey:key] isEqualToString:@"All"]) {

            [[NSUserDefaults standardUserDefaults] setValue:competitionTF.text forKey:@"SelectedCompetitionName"];
            [[NSUserDefaults standardUserDefaults] setValue:competitionCode forKey:@"SelectedCompetitionCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        
        team2TF.text = @"";
        groundTF.text = @"";
    }
    else if([key isEqualToString:@"GroundName"])
    {
            groundTF.text = [[array objectAtIndex:Index.row] valueForKey:key];
            groundCode = [[array objectAtIndex:Index.row] valueForKey:@"GroundCode"];
//        if (![[[array objectAtIndex:Index.row] valueForKey:key] isEqualToString:@"All"]) {
//
//        }
        team2TF.text = @"";
        
    }
    else if([key isEqualToString:@"TeamBName"] && teamCount == 1) // currently fixed
    {
        
        if (team1TF.text.length > 0 && team1TF.text.length > 0 && [team1TF.text isEqualToString:team2TF.text]) {
            
            [AppCommon showAlertWithMessage:@"Please Select Different team in Team-A"];
            return;
        }
        

        team1Code = [[array objectAtIndex:Index.row] valueForKey:@"TeamBcode"];
        team1TF.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString *team1Win = [NSString stringWithFormat:@"%@ Win", [[array objectAtIndex:Index.row] valueForKey:key]];
        self.team1Win.text = team1Win;
    }
    else if([key isEqualToString:@"TeamBName"] && teamCount == 2)
    {
        
        if (team1TF.text.length > 0 && team1TF.text.length > 0 && [team1TF.text isEqualToString:team2TF.text]) {
            team2TF.text = @"";
            [AppCommon showAlertWithMessage:@"Please Select Different team in Team-B"];
            return;
        }
        
//        if (![[[array objectAtIndex:Index.row] valueForKey:key] isEqualToString:@"All"]) {
            team2Code = [[array objectAtIndex:Index.row] valueForKey:@"TeamBcode"];
            team2TF.text = [[array objectAtIndex:Index.row] valueForKey:key];
            NSString *team2Win = [NSString stringWithFormat:@"%@ Win", [[array objectAtIndex:Index.row] valueForKey:key]];
            self.team2Win.text = team2Win;

//        }

    }
    [self headToHeadResultsPostService];
}

- (IBAction)TeamInnsOversSelection:(id)sender {
    
    UIImage* check = [UIImage imageNamed:@"check"];
    UIImage* uncheck = [UIImage imageNamed:@"uncheck"];
    
    if ([[sender currentImage] isEqual:check]) {
        return;
    }
    
    
    if ([sender tag] == 7) // ALL innings
    {
        if ([[btnInnsAll currentImage] isEqual:uncheck]) {
            [btnInnsAll setImage:check forState:UIControlStateNormal];
            [firstInn setImage:uncheck forState:UIControlStateNormal];
            [secondInn setImage:uncheck forState:UIControlStateNormal];
            
            team1InnsNum = @"";
            team2InnsNum = @"";
            
        }
        
    }
    else if ([sender tag] == 0) // 1st Innings
    {
        if ([[firstInn currentImage] isEqual:uncheck]) {
            [firstInn setImage:check forState:UIControlStateNormal];
            [secondInn setImage:uncheck forState:UIControlStateNormal];
            [btnInnsAll setImage:uncheck forState:UIControlStateNormal];

            team1InnsNum = @"1";
            team2InnsNum = @"1";
            
        }
    }
    else if ([sender tag] == 1) // 2nd Innings
    {
        if ([[secondInn currentImage] isEqual:uncheck]) {
            [secondInn setImage:check forState:UIControlStateNormal];
            [firstInn setImage:uncheck forState:UIControlStateNormal];
            [btnInnsAll setImage:uncheck forState:UIControlStateNormal];

            team1InnsNum = @"2";
            team2InnsNum = @"2";
        }
    }
    else if ([sender tag] == 8) // ALL Team Win
    {
        
        
        if ([[btnAllWinTeams currentImage] isEqual:uncheck]) {
            [btnAllWinTeams setImage:check forState:UIControlStateNormal];
            [team2win setImage:uncheck forState:UIControlStateNormal];
            [team1win setImage:uncheck forState:UIControlStateNormal];
            
            tossWonTeamCode = @"";
            
            //                [self headToHeadResultsPostService];
        }
    }

    else if ([sender tag] == 2) // 1st Team Win
    {
        
        
        if ([[team1win currentImage] isEqual:uncheck]) {
            [team2win setImage:uncheck forState:UIControlStateNormal];
            [team1win setImage:check forState:UIControlStateNormal];
            [btnAllWinTeams setImage:uncheck forState:UIControlStateNormal];

            tossWonTeamCode = team1Code;
            
        }
    }
    else if ([sender tag] == 3) // 2nd Team Win
    {
        
        if ([[team2win currentImage] isEqual:uncheck]) {
            [team2win setImage:check forState:UIControlStateNormal];
            [team1win setImage:uncheck forState:UIControlStateNormal];
            [btnAllWinTeams setImage:uncheck forState:UIControlStateNormal];

            tossWonTeamCode = team2Code;
            
        }
    }
    else if ([sender tag] == 9) // ALL overs
    {
        if ([[spell1Inn currentImage] isEqual:uncheck]) {
            [btnAllOvers setImage:check forState:UIControlStateNormal];
            [spell1Inn setImage:uncheck forState:UIControlStateNormal];
            [spell2Inn setImage:uncheck forState:UIControlStateNormal];
            [spell3Inn setImage:uncheck forState:UIControlStateNormal];
            
            fromOver = @"";
            toOver = @"";
            
        }
    }

    else if ([sender tag] == 4) // 1-6 overs
    {
        if ([[spell1Inn currentImage] isEqual:uncheck]) {
            [spell1Inn setImage:check forState:UIControlStateNormal];
            [spell2Inn setImage:uncheck forState:UIControlStateNormal];
            [spell3Inn setImage:uncheck forState:UIControlStateNormal];
            [btnAllOvers setImage:uncheck forState:UIControlStateNormal];

            
            fromOver = @"0";
            toOver = @"5";
            
        }
    }
    else if ([sender tag] == 5) // 7-15 overs
    {
        
        if ([[spell2Inn currentImage] isEqual:uncheck]) {
            [spell2Inn setImage:check forState:UIControlStateNormal];
            [spell1Inn setImage:uncheck forState:UIControlStateNormal];
            [spell3Inn setImage:uncheck forState:UIControlStateNormal];
            [btnAllOvers setImage:uncheck forState:UIControlStateNormal];

            
            fromOver = @"6";
            toOver = @"14";
            
        }
    }
    else if ([sender tag] == 6) // 16-20 overs
    {
        
        if ([[spell3Inn currentImage] isEqual:uncheck]) {
            [spell3Inn setImage:check forState:UIControlStateNormal];
            [spell1Inn setImage:uncheck forState:UIControlStateNormal];
            [spell2Inn setImage:uncheck forState:UIControlStateNormal];
            [btnAllOvers setImage:uncheck forState:UIControlStateNormal];

            
            fromOver = @"15";
            toOver = @"19";
            
        }
    }
    
    
//    if ([[firstInn currentImage] isEqual:uncheck] && [[secondInn currentImage] isEqual:uncheck] && [[btnInnsAll currentImage] isEqual:uncheck]) {
//
//        viewTeamWin.userInteractionEnabled = NO;
//        viewTeamWin.alpha = 0.5;
//    }
//    else
//    {
//        viewTeamWin.userInteractionEnabled = YES;
//        viewTeamWin.alpha = 1.0;
//
//    }
//
//
//    if ([[team1win currentImage] isEqual:uncheck] && [[team2win currentImage] isEqual:uncheck]) {
//
//        viewTeamOvers.userInteractionEnabled = NO;
//        viewTeamOvers.alpha = 0.5;
//    }
//    else
//    {
//        viewTeamOvers.userInteractionEnabled = YES;
//        viewTeamOvers.alpha = 1.0;
//    }
    
    
    if ([[sender currentImage] isEqual:check]) {
        [self headToHeadResultsPostService];
        
    }
    

}

@end
