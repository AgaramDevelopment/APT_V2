//
//  HomeScreenStandingsVC.m
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "HomeScreenStandingsVC.h"
#import "HomeScreenStandingsCell.h"
#import "WebService.h"
#import "Header.h"

@interface HomeScreenStandingsVC ()
{
    NSMutableArray* resultArray;
}

@end

@implementation HomeScreenStandingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    resultArray = [NSMutableArray new];
    
    //Applying overall shadow to shadowView
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.shadowView.layer.shadowOpacity = 1.0;
    self.shadowView.layer.shadowRadius = 6.0;
    
//    headingKeyArray =  @[@"Rank",@"TeamName",@"Played",@"Won",@"Lost",@"Tied",@"NoResults",@"NETRUNRESULT",@"Points"];
//
//    headingButtonNames = @[@"Rank",@"Team",@"Played",@"Won",@"Lost",@"Tied",@"N/R",@"Net RR",@"Pts"];
//    rankArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", nil];
//    teamArray = [[NSMutableArray alloc] initWithObjects:@"CKS", @"RR", @"MI", @"KXIP", @"SRH", @"DD", @"KKR", @"RCB", nil];
//    playedArray = [[NSMutableArray alloc] initWithObjects:@"14", @"14", @"14", @"14", @"14", @"14", @"14", @"14", nil];
//    wonArray = [[NSMutableArray alloc] initWithObjects:@"4", @"4", @"4", @"4", @"4", @"4", @"4", @"4", nil];
//    lostArray = [[NSMutableArray alloc] initWithObjects:@"3", @"3", @"3", @"3", @"3", @"3", @"3", @"3", nil];
//    nrrArray = [[NSMutableArray alloc] initWithObjects:@"+4.33", @"+4.33", @"+4.33", @"+4.33",@"+4.33", @"+4.33", @"+4.33", @"+4.33", nil];
//    pointsArray = [[NSMutableArray alloc] initWithObjects:@"12", @"12", @"12", @"12", @"12", @"12", @"12", @"12", nil];
    
    [self StandingsWebservice];
//    [self customnavigationmethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [self.navigationView addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
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
    
}

-(void)actionBack
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPAD ? 50 : 45;
}
    // number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (resultArray.count > 10) {
        self.tblHeight.constant = (IS_IPAD ? 50 : 45) * 10;
    }
    else //if (resultArray.count > 0)
    {
        self.tblHeight.constant = (IS_IPAD ? 50 : 45) * resultArray.count;
    }
    
    [self.standingsTableView updateConstraintsIfNeeded];
    
    return resultArray.count;
}
    // the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"standingsCell";
    
    HomeScreenStandingsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"HomeScreenStandingsCell" owner:self options:nil];
    cell = arr[0];

    cell.rankLbl.text = [self getStringValue:@"Rank" andIndex:indexPath];
    cell.teamLbl.text = [self getStringValue:@"TeamName" andIndex:indexPath];
    cell.playedLbl.text = [self getStringValue:@"Played" andIndex:indexPath];
    cell.wonLbl.text = [self getStringValue:@"Won" andIndex:indexPath];
    cell.lostLbl.text = [self getStringValue:@"Lost" andIndex:indexPath];
//    cell.tiedLbl.text = [self getStringValue:@"Tied" andIndex:indexPath];
    cell.NRLbl.text = [self getStringValue:@"NoResults" andIndex:indexPath];
    cell.pointsLbl.text = [self getStringValue:@"Points" andIndex:indexPath];
    cell.nrrLbl.text = [self getStringValue:@"NETRUNRESULT" andIndex:indexPath];
    
    if (indexPath.row >= 0 && indexPath.row <= 3) {
        
        cell.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:81.0/255.0 alpha:0.5];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];

    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSString *)getStringValue:(NSString *)Key andIndex:(NSIndexPath *)indexPath
{
    NSString* str;
    
    if([[[resultArray objectAtIndex:indexPath.row]valueForKey:Key] isKindOfClass:[NSNumber class]])
    {
        
        NSNumber *vv = [AppCommon checkNull:[[resultArray objectAtIndex:indexPath.row]valueForKey:Key]];
        str = [vv stringValue];
    }
    else
    {
        str = [AppCommon checkNull:[[resultArray objectAtIndex:indexPath.row]valueForKey:Key]];
    }

    
    return str;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)StandingsWebservice
{
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading ];
    
    NSString *CompetitionCode ;
    WebService* objWebservice = [[WebService alloc]init];
    
    if (appDel.ArrayCompetition.count) {
        CompetitionCode = [[appDel.ArrayCompetition firstObject] valueForKey:@"CompetitionCode"];
        NSLog(@"%@",[appDel.ArrayCompetition firstObject]);
    }
    else
    {
        CompetitionCode = @"UCC0000274";
    }
    
    
    [objWebservice TeamStandings:StandingsKey :CompetitionCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        if(responseObject >0)
        {
            resultArray = [[NSMutableArray alloc]init];
            resultArray = [responseObject valueForKey:@"TeamResult"];
            [self.standingsTableView reloadData];
            
        }
        [AppCommon hideLoading];
        
    }failure:^(AFHTTPRequestOperation *operation, id error) {
         NSLog(@"failed");
         [COMMON webServiceFailureError:error];
     }];
    
}


@end
