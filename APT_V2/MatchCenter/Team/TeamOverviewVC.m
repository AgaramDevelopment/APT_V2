//
//  TeamOverviewVC.m
//  APT_V2
//
//  Created by MAC on 28/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TeamOverviewVC.h"
#import "Header.h"
#import "TeamOverviewCell.h"

@interface TeamOverviewVC () {
    UITableView *dropDownTblView;
    BOOL isSelectTeam;
}

@end

@implementation TeamOverviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    teamArray = [[NSMutableArray alloc] initWithObjects:@"Chennai Super Kings", @"Chennai Super Kings", @"Chennai Super Kings", @"Chennai Super Kings", @"Chennai Super Kings", @"Chennai Super Kings", @"Chennai Super Kings", nil];
    
    dropDownTblView = [[UITableView alloc]init];
    dropDownTblView.dataSource = self;
    dropDownTblView.delegate = self;
    
    [self.teamCollectionView registerNib:[UINib nibWithNibName:@"TeamOverviewCell" bundle:nil] forCellWithReuseIdentifier:@"teamOverviewCell"];
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
    
        //    [self.view addSubview:objCustomNavigation.view];
        //    objCustomNavigation.tittle_lbl.text=@"";
    
        //UIView* view= self.navigation_view.subviews.firstObject;
    [self.navigationView addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden =YES;
    objCustomNavigation.menu_btn.hidden =NO;
        //        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //        [objCustomNavigation.home_btn addTarget:self action:@selector(HomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)didSelectTeam:(id)sender {
    
    if(dropDownTblView != nil){
        [dropDownTblView removeFromSuperview];
    }
    
    if (!isSelectTeam) {
        [self resetDropDownTeamstatus];
        isSelectTeam = YES;
        
        if (IS_IPAD) {
            dropDownTblView.frame = CGRectMake(self.selectTeamView.frame.origin.x, self.selectTeamView.frame.origin.y+self.selectTeamView.frame.size.height+80, self.selectTeamView.frame.size.width, teamArray.count >= 5 ? 150 : teamArray.count*45);
        } else {
            dropDownTblView.frame = CGRectMake(self.selectTeamView.frame.origin.x, self.selectTeamView.frame.origin.y+self.selectTeamView.frame.size.height+70, self.selectTeamView.frame.size.width, teamArray.count >= 5 ? 150 : teamArray.count*45);
        }
        
        
        dropDownTblView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dropDownTblView];
        
        [dropDownTblView reloadData];
        
    } else {
        [self resetDropDownTeamstatus];
    }
    
}

- (void)resetDropDownTeamstatus {
    isSelectTeam =NO;
}

#pragma Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return teamArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"teamCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [teamArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectTeamTF.text = [teamArray objectAtIndex:indexPath.row];
    if(dropDownTblView != nil){
        [dropDownTblView removeFromSuperview];
    }
    [self resetDropDownTeamstatus];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (IS_IPAD) {
//        return 45;
//    } else {
//        return 35;
//    }
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamOverviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"teamOverviewCell" forIndexPath:indexPath];

    cell.headerView.layer.masksToBounds = NO;
    cell.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.headerView.layer.shadowOffset = CGSizeMake(-2.0f, -2.0f);
    cell.headerView.layer.shadowRadius = 5;
    cell.headerView.layer.shadowOpacity = 0.8f;
    
/*
        //Target for More Details
    [cell.breakfastBtn addTarget:self action:@selector(didClickBreakfastMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.snacksBtn addTarget:self action:@selector(didClickSnacksMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.lunchBtn addTarget:self action:@selector(didClickLunchMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.dinnerBtn addTarget:self action:@selector(didClickDinnerMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.supplementsBtn addTarget:self action:@selector(didClickSupplementsMore:) forControlEvents:UIControlEventTouchUpInside];
    */
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD) {
        return CGSizeMake(350, 435);
    } else {
        return CGSizeMake(280, 435);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return UIEdgeInsetsMake(10, 20, 10, 20); // top, left, bottom, right
    }
    else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
