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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        cell.backgroundColor = [UIColor yellowColor];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];

    }

    
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
