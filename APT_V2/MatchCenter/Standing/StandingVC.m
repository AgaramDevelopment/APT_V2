//
//  StandingVC.m
//  APT_V2
//
//  Created by apple on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "StandingVC.h"
#import "PlayerListCollectionViewCell.h"
#import "Config.h"
#import "CustomNavigation.h"
#import "WebService.h"
#import "Header.h"

@interface StandingVC ()<selectedDropDown>
{
    NSArray* headingKeyArray;
    NSArray* headingButtonNames;
    BOOL isYear;
    WebService *objWebservice;
    NSMutableArray *competitionArray;
    NSString *competitionCode;
    
    NSMutableArray *DetailsArray;

}

@end

@implementation StandingVC

@synthesize viewTeam,viewCompetetion;

@synthesize lblCompetetion,lblTeam;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.PoplistTable.delegate = self;
    self.PoplistTable.dataSource = self;
    
    self.standingsCollectionView.hidden = YES;
    self.PoplistTable.hidden = YES;
    
    
//    headingKeyArray =  @[@"Rank",@"TeamName",@"Played",@"Won",@"Lost",@"Tied",@"NoResults",@"NETRUNRESULT",@"For",@"Against",@"Points"];
//
//
//    headingButtonNames = @[@"Rank",@"Team",@"Played",@"Won",@"Lost",@"Tied",@"N/R",@"Net RR",@"For",@"Against",@"Pts"];
    
    headingKeyArray =  @[@"Rank",@"TeamName",@"Played",@"Won",@"Lost",@"Tied",@"NoResults",@"NETRUNRESULT",@"Points"];
    
    headingButtonNames = @[@"Rank",@"Team",@"Played",@"Won",@"Lost",@"Tied",@"N/R",@"Net RR",@"Pts"];

    [self.standingsCollectionView registerNib:[UINib nibWithNibName:@"PlayerListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ContentCellIdentifier"];
    
    self.standingsCollectionView.delegate = self;
    self.standingsCollectionView.dataSource = self;
    
    lblTeam.text = [AppCommon getCurrentTeamName];
    lblCompetetion.text = [AppCommon getCurrentCompetitionName];
    
    [self StandingsWebservice];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headderView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Standings";
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

}



/* Filter */


#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(isYear==YES)
    {
        return appDel.ArrayCompetition.count;
    }
    else{
        return 0;
    }
    
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
    
    if(isYear==YES)
    {
        //cell.textLabel.text = indexPath.row == 0 ? @"2017" : indexPath.row == 1 ? @"2016" : indexPath.row == 2 ? @"2015" :  indexPath.row == 3 ? @"2014" :  @"2013";
        
        cell.textLabel.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"] objectAtIndex:indexPath.row];
        
    }else{
        cell.textLabel.text = @"";
    }
    
    
    cell.selectionStyle = UIAccessibilityTraitNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isYear==YES)
    {
       // self.yearlbl.text = indexPath.row == 0 ? @"2017" : indexPath.row == 1 ? @"2016" : indexPath.row == 2 ? @"2015" :  indexPath.row == 3 ? @"2014" :  @"2013";
        self.yearlbl.text = [[appDel.ArrayCompetition valueForKey:@"CompetitionName"] objectAtIndex:indexPath.row];
        competitionCode = [[appDel.ArrayCompetition valueForKey:@"CompetitionCode"] objectAtIndex:indexPath.row];
        self.standingsCollectionView.hidden = NO;
        self.PoplistTable.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setValue:self.yearlbl.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:competitionCode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self StandingsWebservice];
        
    }
    
    isYear = NO;
    self.PoplistTable.hidden = YES;
    
}

- (IBAction)onClickYearDD:(id)sender
{
    
    if(isYear){
        
        isYear = NO;
        self.PoplistTable.hidden = YES;
        self.popTableView.hidden = YES;
        
        
    }else{
        
        isYear = YES;
        
        self.PoplistTable.hidden = NO;
        self.popTableView.hidden = NO;
        
        self.tableWidth.constant = self.viewCompetetion.frame.size.width;
        self.tableXposition.constant = self.viewCompetetion.frame.origin.x;
        
        [self.PoplistTable reloadData];
        
    }
}

- (IBAction)dismissview:(id)sender
{
        self.popTableView.hidden = YES;
        self.PoplistTable.hidden = YES;
}




#pragma mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(DetailsArray.count>0)
    {
        return DetailsArray.count+1;
        //return headingButtonNames.count;
    }
    else
    {
        return 0;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return headingButtonNames.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(IS_IPHONE_DEVICE)
//    {
//        if(!IS_IPHONE5)
//        {
//            return CGSizeMake(130, 35);
//        }
//        else
//        {
//
//            return CGSizeMake(150, 40);
//        }
//    }
//    else
//    {
//
//        return CGSizeMake(200, 50);
//    }
    
    return CGSizeMake(80, 50);

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlayerListCollectionViewCell* cell = [self.standingsCollectionView dequeueReusableCellWithReuseIdentifier:@"ContentCellIdentifier" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:167.0/255.0 blue:219.0/255.0 alpha:1.0];
        
        
        
        [cell.lblRightShadow setHidden:YES];
        cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        
        for (id value in headingButtonNames) {
            
            if ([headingButtonNames indexOfObject:value] == indexPath.row) {
                [cell.btnName setTitle:value forState:UIControlStateNormal];
                cell.btnName.secondTag = indexPath.row;
                cell.btnName.titleLabel.numberOfLines = 2;
                
                break;
            }
        }
        cell.btnName.userInteractionEnabled = YES;
        
    }
    else
    {
        [cell.lblRightShadow setHidden:(indexPath.row == 0 ? NO : YES)];
        if (!cell.lblRightShadow.isHidden) {
            cell.lblRightShadow.clipsToBounds = NO;
            [self setShadow:cell.lblRightShadow.layer];
        }
        
//        if (indexPath.section % 2 != 0) {
//            cell.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
//
//        }else
//        {
//            cell.backgroundColor = [UIColor whiteColor];
//        }
        
        cell.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];

        [cell.btnName setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        
        cell.btnName.userInteractionEnabled = NO;
        
        
        for (id temp in headingKeyArray) {
            if ([headingKeyArray indexOfObject:temp] == indexPath.row) {
                
                NSString *str;
                if([[[DetailsArray objectAtIndex:indexPath.section-1]valueForKey:temp] isKindOfClass:[NSNumber class]])
                {

                    NSNumber *vv = [self checkNull:[[DetailsArray objectAtIndex:indexPath.section-1]valueForKey:temp]];
                    str = [vv stringValue];
                }
                else
                {
                    str = [self checkNull:[[DetailsArray objectAtIndex:indexPath.section-1]valueForKey:temp]];
                }
//                if([temp isEqualToString:@"Rank"])
//                {
//                    cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                    cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//                    //NSLog(@"Player Name %@ ",str);
//                }
//                else
//                {
//                    cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//                    cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                }
                cell.btnName.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                cell.btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

                //[cell.btnName setTitle:[NSString stringWithFormat:@"T %ld",indexPath.section-1] forState:UIControlStateNormal];
                
                    [cell.btnName setTitle:str forState:UIControlStateNormal];
                break;
            }
        }
        
    }
    
    return cell;
}
-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    //    PlayerStatsVC * nextVC = [[PlayerStatsVC alloc]init];
    //    nextVC = (PlayerStatsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerStats"];
    //    nextVC.SelectedPlayerCode = [[PlayerListArray objectAtIndex:indexPath.section-1] valueForKey:@"PlayerCode"];
    //    [self.navigationController pushViewController:nextVC animated:YES];
    
}
-(void)setShadow:(CALayer *)layer
{
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOffset = CGSizeMake(10,3);
    layer.shadowOpacity = 1.0;
    
}


-(void)StandingsWebservice
{
    
    if(![COMMON isInternetReachable])
    {
        return;
    }
    else if ([lblCompetetion.text isEqualToString:@"Competetion Name"]) {
        
        return;
    }
//    else if([AppCommon isCoach] && [lblTeam.text isEqualToString:@"Team Name"])
//    {
//        return;
//    }

    
    [AppCommon showLoading ];
    
    
    
    NSString *CompetitionCode ;// = [AppCommon getCurrentCompetitionCode];
//    self.yearlbl.text = [AppCommon getCurrentCompetitionName];
    objWebservice = [[WebService alloc]init];
    
    
    
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
            //competitionArray = [[NSMutableArray alloc]init];
            //competitionArray = [responseObject valueForKey:@"CompetitionResult"];
            DetailsArray = [[NSMutableArray alloc]init];
            DetailsArray = [responseObject valueForKey:@"TeamResult"];
            
            self.standingsCollectionView.hidden = NO;
        
            [self.standingsCollectionView reloadData];
            
        }
        [AppCommon hideLoading];
        
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
    }];
    
}


- (IBAction)actionDropDown:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    if(![sender tag]) // COMPETETION
    {
        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(viewCompetetion.frame), CGRectGetMaxY(viewCompetetion.superview.frame)+70, CGRectGetWidth(viewCompetetion.frame), 300)];

    }
    else // TEAM
    {
        dropVC.array = appDel.ArrayTeam;
        dropVC.key = @"TeamName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(viewTeam.frame), CGRectGetMaxY(viewTeam.superview.frame)+70, CGRectGetWidth(viewTeam.frame), 300)];

    }
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];

}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    
    if ([key  isEqualToString: @"CompetitionName"]) {
        
        lblCompetetion.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Competetioncode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:lblCompetetion.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        lblTeam.text =@"Team Name";
        
        
    }
    else
    {
        lblTeam.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* Teamcode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
        
        [[NSUserDefaults standardUserDefaults] setValue:lblTeam.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:Teamcode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    [self StandingsWebservice];
    
}


@end
