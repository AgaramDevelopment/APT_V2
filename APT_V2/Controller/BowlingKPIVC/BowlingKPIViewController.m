//
//  BowlingKPIViewController.m
//  NewSportsProject
//
//  Created by user on 01/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import "BowlingKPIViewController.h"
#import "BowlingTableViewCell.h"
#import "WebService.h"
#import "CustomNavigation.h"
#import "Config.h"
#import "AppCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BallsInVideosCVC.h"
#import "VideoPlayerViewController.h"
#import "ScoreCardVideoPlayer.h"


@interface BowlingKPIViewController ()
{
    NSMutableArray* inningsArray,* sessionArray;
    NSMutableArray* session1,*session2;
    NSMutableArray *inningsCountArray;
    NSMutableArray* selectedDaysArray1, *selectedDaysArray2;
    NSInteger selectedSection1,selectedSection2;

    NSMutableArray* arr1,*arr2;
    NSArray* videoArrayValues;
    int selectedVideo;
    NSMutableArray  *videoURLArray;

}

@end

@implementation BowlingKPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    videoArrayValues = @[@"RUNS", @"WKT",@"OVERS", @"FOURS", @"SIXES", @"WIDE", @"NOBALL"];
    selectedVideo = 0;

    [self customnavigationmethod];
    inningsArray = [NSMutableArray new];
    inningsCountArray = [NSMutableArray new];
    
    session1 = [NSMutableArray new];
    session2 = [NSMutableArray new];
    
    selectedDaysArray1 = [NSMutableArray new];
    selectedDaysArray2 = [NSMutableArray new];
    
    arr1 = [NSMutableArray new];
    arr2 = [NSMutableArray new];
    [self resetValues];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self inningsWebService];
    });
    
    
}
-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        
        [objCustomNavigation.btn_back addTarget:self action:@selector(BackBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navi_View addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
}

-(IBAction)BackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark UITABLEVIEW DATASOURCE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return inningsArray.count;
    }
    else if(section == 1)
    {
        return (arr1.count > 0 ? arr1.count+1 : arr1.count);
        
    }
    else if (section == 2)
    {
        return (arr2.count > 0 ? arr2.count+1 : arr2.count);
    }
    return 0;
}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 if(section == 0)
 return 0;
 else
 return 70;
 }
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
        return 49;
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat requiredHeight = 0;
    if(indexPath.section == 0)
    {
        requiredHeight= 230;
    }
    else
    {
        requiredHeight = (indexPath.row == 0 ? 70 :  30);
    }
    return requiredHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1)
    {
        return NULL;
    }
    BowlingTableViewCell *cell = [_tblBowling dequeueReusableCellWithIdentifier:@"HeaderFooter1"];
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"BowlingTableViewCell" owner:self options:nil];
    cell = arr[1];
    
    return cell;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BowlingTableViewCell *cell = [_tblBowling dequeueReusableCellWithIdentifier:@"FIRSTINDEX"];
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"BowlingTableViewCell" owner:self options:nil];
    
    
    if(indexPath.section == 0) // Innings section
    {
        cell = arr[0];
//        NSString* Runs = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
//        NSString* Wickets = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Wkts"];
        
        cell.lblInningsCount.text = [NSString stringWithFormat:@"Innings %@",[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"]];
//        cell.lblRW_in.text = [self getRunWickets:Runs and:Wickets];
        cell.lblRuns_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
        cell.lblWkts_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Wkts"];
        cell.lblOvers_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Overs"];
        cell.lblMaidens_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Maiden"];
        cell.lblEco_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Eco"];
        cell.lblSR_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"SR"];
        cell.lblAvg_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Avg"];
        cell.lblFours_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Fours"];
        cell.lblSixs_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Sixs"];
        cell.lblWide_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Wide"];
        cell.lblNB_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"NoBall"];
        
        [cell.btnRuns setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnWkts setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnOvers setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnFours setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnSixs setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnWides setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnNB setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        
        [cell.btnRuns addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnWkts addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnOvers addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnFours addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSixs addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnWides addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnNB addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];


    }
    else if(indexPath.section == 1) // session section
    {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell = arr[2];
            
            cell.lblInningsCount_Session.text = [NSString stringWithFormat:@"Innings %@",[[arr1 objectAtIndex:0]valueForKey:@"InningsNo"]];
            
            [cell.btnDay1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay1 setUserInteractionEnabled:NO];
            [cell.btnDay2 setUserInteractionEnabled:NO];
            [cell.btnDay3 setUserInteractionEnabled:NO];
            [cell.btnDay4 setUserInteractionEnabled:NO];
            [cell.btnDay5 setUserInteractionEnabled:NO];
            
            
            for (id Value in session1) {
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"1"]) {
                    [cell.btnDay1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay1 setUserInteractionEnabled:YES];
                }
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"2"]) {
                    [cell.btnDay2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay2 setUserInteractionEnabled:YES];
                }
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"3"]) {
                    [cell.btnDay3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay3 setUserInteractionEnabled:YES];
                }
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"4"]) {
                    [cell.btnDay4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay4 setUserInteractionEnabled:YES];
                }
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"5"]) {
                    [cell.btnDay5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay5 setUserInteractionEnabled:YES];
                }
            }
            
            if (selectedSection1 == 1) {
                [cell.btnDay1 addSubview:[self getLineView:cell.btnDay1]];
                [self clearBtnSubView:cell.btnDay2];
                [self clearBtnSubView:cell.btnDay3];
                [self clearBtnSubView:cell.btnDay4];
                [self clearBtnSubView:cell.btnDay5];
                
            } else  if (selectedSection1 == 2) {
                [self clearBtnSubView:cell.btnDay1];
                [cell.btnDay2 addSubview:[self getLineView:cell.btnDay2]];
                [self clearBtnSubView:cell.btnDay3];
                [self clearBtnSubView:cell.btnDay4];
                [self clearBtnSubView:cell.btnDay5];
                
            }else  if (selectedSection1 == 3) {
                [self clearBtnSubView:cell.btnDay1];
                [self clearBtnSubView:cell.btnDay2];
                [cell.btnDay3 addSubview:[self getLineView:cell.btnDay3]];
                [self clearBtnSubView:cell.btnDay4];
                [self clearBtnSubView:cell.btnDay5];
                
            }else  if (selectedSection1 == 4) {
                [self clearBtnSubView:cell.btnDay1];
                [self clearBtnSubView:cell.btnDay2];
                [self clearBtnSubView:cell.btnDay3];
                [cell.btnDay4 addSubview:[self getLineView:cell.btnDay4]];
                [self clearBtnSubView:cell.btnDay5];
                
            }else  if (selectedSection1 == 5) {
                [self clearBtnSubView:cell.btnDay1];
                [self clearBtnSubView:cell.btnDay2];
                [self clearBtnSubView:cell.btnDay3];
                [self clearBtnSubView:cell.btnDay4];
                [cell.btnDay5 addSubview:[self getLineView:cell.btnDay5]];

            }
            
            
            [cell.btnDay1 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay2 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay3 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay4 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay5 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
        
        cell = arr[3];
        cell.lblSessionCount.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"SessionNo"];
        NSString* Run = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Runs"];
        NSString* Wicket = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Wkts"];
        
        cell.lblRW_Session.text = [self getRunWickets:Run and:Wicket];
        cell.lblOvers_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Overs"];
        //        cell.lblMaiden_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Maiden"]?[[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Maiden"]:@"";
        
        if(![[[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Maiden"] isEqual:[NSNull null]]) {
            cell.lblMaiden_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Maiden"];
        } else {
            cell.lblMaiden_Session.text = @"0";
        }
        cell.lblSR_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"SR"];
        cell.lblAvg_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Avg"];
        cell.lblEco_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Eco"];
        cell.lblFours_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Fours"];
        cell.lblSixs_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Sixs"];
        cell.lblWD_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"Wide"];
        cell.lblNB_Session.text = [[session1 objectAtIndex:indexPath.row-1] valueForKey:@"NoBall"];
    }
    else if(indexPath.section == 2) // session section
    {
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell = arr[2];
            cell.lblInningsCount_Session.text = [NSString stringWithFormat:@"Innings %@",[[arr2 objectAtIndex:0]valueForKey:@"InningsNo"]];
            
            [cell.btnDay1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnDay5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [cell.btnDay1 setUserInteractionEnabled:NO];
            [cell.btnDay2 setUserInteractionEnabled:NO];
            [cell.btnDay3 setUserInteractionEnabled:NO];
            [cell.btnDay4 setUserInteractionEnabled:NO];
            [cell.btnDay5 setUserInteractionEnabled:NO];
            
            for (id Value in session2) {
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"1"]) {
                    [cell.btnDay1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay1 setUserInteractionEnabled:YES];
                    
                }
                
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"2"]) {
                    [cell.btnDay2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay2 setUserInteractionEnabled:YES];
                    
                }
                
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"3"]) {
                    [cell.btnDay3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay3 setUserInteractionEnabled:YES];
                    
                }
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"4"]) {
                    [cell.btnDay4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay4 setUserInteractionEnabled:YES];
                    
                }
                if ([[Value valueForKey:@"DayNo"] isEqualToString:@"5"]) {
                    [cell.btnDay5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.btnDay5 setUserInteractionEnabled:YES];
                    
                }
            }
            if (selectedSection2 == 1) {
                [cell.btnDay1 addSubview:[self getLineView:cell.btnDay1]];
                [self clearBtnSubView:cell.btnDay2];
                [self clearBtnSubView:cell.btnDay3];
                [self clearBtnSubView:cell.btnDay4];
                [self clearBtnSubView:cell.btnDay5];
                
            } else  if (selectedSection2 == 2) {
                [self clearBtnSubView:cell.btnDay1];
                [cell.btnDay2 addSubview:[self getLineView:cell.btnDay2]];
                [self clearBtnSubView:cell.btnDay3];
                [self clearBtnSubView:cell.btnDay4];
                [self clearBtnSubView:cell.btnDay5];
                
            }else  if (selectedSection2 == 3) {
                [self clearBtnSubView:cell.btnDay1];
                [self clearBtnSubView:cell.btnDay2];
                [cell.btnDay3 addSubview:[self getLineView:cell.btnDay3]];
                [self clearBtnSubView:cell.btnDay4];
                [self clearBtnSubView:cell.btnDay5];
                
            }else  if (selectedSection2 == 4) {
                [self clearBtnSubView:cell.btnDay1];
                [self clearBtnSubView:cell.btnDay2];
                [self clearBtnSubView:cell.btnDay3];
                [cell.btnDay4 addSubview:[self getLineView:cell.btnDay4]];
                [self clearBtnSubView:cell.btnDay5];
                
            }else  if (selectedSection2 == 5) {
                [self clearBtnSubView:cell.btnDay1];
                [self clearBtnSubView:cell.btnDay2];
                [self clearBtnSubView:cell.btnDay3];
                [self clearBtnSubView:cell.btnDay4];
                [cell.btnDay5 addSubview:[self getLineView:cell.btnDay5]];
                
            }
            
            [cell.btnDay1 addTarget:self action:@selector(daysAction1:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay2 addTarget:self action:@selector(daysAction1:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay3 addTarget:self action:@selector(daysAction1:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay4 addTarget:self action:@selector(daysAction1:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDay5 addTarget:self action:@selector(daysAction1:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
        
        cell = arr[3];
        cell.lblSessionCount.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"SessionNo"];
        NSString* Run = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Runs"];
        NSString* Wicket = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Wkts"];
        
        cell.lblRW_Session.text = [self getRunWickets:Run and:Wicket];
        NSLog(@"%d", (int)indexPath.row);
        NSLog(@"%@",session2[indexPath.row-1]);
        cell.lblOvers_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Overs"];
        if(![[[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Maiden"] isEqual:[NSNull null]]) {
            cell.lblMaiden_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Maiden"];
        } else {
            cell.lblMaiden_Session.text = @"0";
        }
        
        cell.lblSR_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"SR"];
        cell.lblAvg_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Avg"];
        cell.lblEco_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Eco"];
        cell.lblFours_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Fours"];
        cell.lblSixs_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Sixs"];
        cell.lblWD_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"Wide"];
        cell.lblNB_Session.text = [[session2 objectAtIndex:indexPath.row-1] valueForKey:@"NoBall"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)buttonActionForVideoPlaying:(id)sender
{
    NSString* selectedValue = [videoArrayValues objectAtIndex:[sender tag]];
    NSString* InningsCount = [sender titleForState:UIControlStateNormal];
    NSLog(@"%@",selectedValue);
    //[self loadVideoPathsForPlayer:self.SelectedPlayerCode andValue:selectedValue type:@"BOWLING" inningsCount:InningsCount];
    
    [self loadVideoPlayer: self.SelectedPlayerCode : selectedValue: @"BOWLING"  innings: InningsCount];
}


-(void)daysAction:(id)sender1
{
    UIButton* sender = (UIButton *)sender1;
    
    
    NSString* str = @"";
    if ([sender.titleLabel.text isEqualToString:@"Day 1"]) {
        str = @"1";
    }else if([sender.titleLabel.text isEqualToString:@"Day 2"]){
        str = @"2";
    }else if([sender.titleLabel.text isEqualToString:@"Day 3"]){
        str = @"3";
    }else if([sender.titleLabel.text isEqualToString:@"Day 4"]){
        str = @"4";
    }else if([sender.titleLabel.text isEqualToString:@"Day 5"]){
        str = @"5";
    }
    
    if(![str isEqualToString:@""]){
        [arr1 removeAllObjects];
    }
    
    
    for (NSDictionary* dict in session1) {
        if ([[dict valueForKey:@"DayNo"]isEqualToString:str]) {
            [arr1 addObject:dict];
        }
    }
    selectedSection1 =  [str integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBowling reloadData];
    });
    
    
}
-(void)daysAction1:(id)sender1
{
    UIButton* sender = (UIButton *)sender1;
    NSLog(@"Selected button title %@",sender.titleLabel.text);
    NSString* str = @"";
    if ([sender.titleLabel.text isEqualToString:@"Day 1"]) {
        str = @"1";
    }else if([sender.titleLabel.text isEqualToString:@"Day 2"]){
        str = @"2";
    }else if([sender.titleLabel.text isEqualToString:@"Day 3"]){
        str = @"3";
    }else if([sender.titleLabel.text isEqualToString:@"Day 4"]){
        str = @"4";
    }else if([sender.titleLabel.text isEqualToString:@"Day 5"]){
        str = @"5";
    }
    
    if(![str isEqualToString:@""]){
        [arr2 removeAllObjects];
    }
    
    
    for (NSDictionary* dict in session2) {
        if ([[dict valueForKey:@"DayNo"]isEqualToString:str]) {
            [arr2 addObject:dict];
        }
    }
    
    selectedSection2 = [str integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBowling reloadData];
    });
    
}

-(void)selectFirstDayInFirstInnings:(id)sender
{
    [arr1 removeAllObjects];
    
    NSString* str = @"";
    if ([sender isEqualToString:@"Day1"]) {
        str = @"1";
    }else if([sender isEqualToString:@"Day2"]){
        str = @"2";
    }else if([sender isEqualToString:@"Day3"]){
        str = @"3";
    }else if([sender isEqualToString:@"Day4"]){
        str = @"4";
    }else if([sender isEqualToString:@"Day5"]){
        str = @"5";
    }
    
    for (NSDictionary* dict in session1) {
        if ([[dict valueForKey:@"DayNo"]isEqualToString:str]) {
            [arr1 addObject:dict];
        }
    }
    selectedSection1 = [str integerValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBowling reloadData];
        
    });
    
}
-(void)selectFirstDayInsecondInnings:(id)sender
{
    [arr2 removeAllObjects];
    
    NSString* str = @"";
    if ([sender isEqualToString:@"Day1"]) {
        str = @"1";
    }else if([sender isEqualToString:@"Day2"]){
        str = @"2";
    }else if([sender isEqualToString:@"Day3"]){
        str = @"3";
    }else if([sender isEqualToString:@"Day4"]){
        str = @"4";
    }else if([sender isEqualToString:@"Day5"]){
        str = @"5";
    }
    
    for (NSDictionary* dict in session2) {
        if ([[dict valueForKey:@"DayNo"]isEqualToString:str]) {
            [arr2 addObject:dict];
        }
    }
    selectedSection2 = [str integerValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBowling reloadData];
        
    });
}


#pragma mark WEBSERVICE

-(void)inningsWebService
{
    [AppCommon showLoading];
    /*
     API URL    :   http://13.126.151.253:9001/AGAPTSERVICE.svc/LOADBOWLINGKPIFORPLAYER/
     METHOD     :   GET
     PARAMETER  :   LOADBOWLINGKPIFORPLAYER(string MATCHCODE, string TEAMCODE, string PLAYERCODE)
     
     
     IMSC022D017C2AA4FC420171206183301000 // ondeday match code
     IMSC023D017C2AA4FC420171114191800997 // test match code
     
     mathe PYC0000431
     murali vijay PYC0000287
     */
    
    NSString *API_URL = [NSString stringWithFormat:@"%@LOADBOWLINGKPIFORPLAYER/%@/%@/%@",URL_FOR_RESOURCE(@""),_SelectedMatchCode,_SelectedTeamCode,_SelectedPlayerCode ];
    //NSString *API_URL = [NSString stringWithFormat:@"%@LOADBOWLINGKPIFORPLAYER/IMSC023D017C2AA4FC420171114191400995/TEA0000018/PYC0000345",URL_FOR_RESOURCE(@"") ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE %@",responseObject);
        NSDictionary *ResponseDictionary = responseObject;
        [self setInningsDetails:[ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"]];
        [self setPlayerDetails:[[ResponseDictionary valueForKey:@"lstKPIPlayerDetails"]firstObject]];
        inningsArray = [ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"];
        [self getInningsCount:[ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"]];
        [AppCommon hideLoading];
         
        
        [self sessionSummaryWebService:[inningsCountArray firstObject]];
        
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.tblBowling reloadData];
        //        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
    }];
    
    
}


-(void)sessionSummaryWebService:(NSString *)Innings
{
    /*
     
     API URL    :   http://13.126.151.253:9001/AGAPTSERVICE.svc/BOWLINGKPISESSIONWISE/
     METHOD     :   GET
     PARAMETER  :   BOWLINGKPISESSIONWISE(string MATCHCODE, string INNS, string PLAYERCODE)
     
     BOWLINGKPISESSIONWISE/IMSC023D017C2AA4FC420171114191400995/2/PYC0000345
     
     */
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@BOWLINGKPISESSIONWISE/%@/%@/%@",URL_FOR_RESOURCE(@""),_SelectedMatchCode,Innings,_SelectedPlayerCode ];
    
    //NSString *API_URL = [NSString stringWithFormat:@"%@BOWLINGKPISESSIONWISE/IMSC023D017C2AA4FC420171114191400995/%@/PYC0000345",URL_FOR_RESOURCE(@""),Innings ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE %@",responseObject);
        NSDictionary *ResponseDictionary = responseObject;
        session1 = [ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"];
        
        for (NSDictionary* dict in session1) {
            if(![selectedDaysArray1 containsObject:[dict valueForKey:@"DayNo"]])
            {
                [selectedDaysArray1 addObject:[dict valueForKey:@"DayNo"]];
            }
        }
        
        [AppCommon hideLoading];
         
        
        if(inningsCountArray.count == 1)
        {
            
            id buttonName1 = [NSString stringWithFormat:@"Day%@",[selectedDaysArray1 firstObject]];
            [self selectFirstDayInFirstInnings:buttonName1];
            
            return ;
            
        }
        
        [self sessionSummaryForInnings2:[inningsCountArray objectAtIndex:1]];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
    }];
}

-(void)sessionSummaryForInnings2:(NSString *)Innings
{
    /*
     
     API URL    :   http://13.126.151.253:9001/AGAPTSERVICE.svc/BOWLINGKPISESSIONWISE/
     METHOD     :   GET
     PARAMETER  :   BOWLINGKPISESSIONWISE(string MATCHCODE, string INNS, string PLAYERCODE)
     
     
     
     */
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@BOWLINGKPISESSIONWISE/%@/%@/%@",URL_FOR_RESOURCE(@""),_SelectedMatchCode,Innings,_SelectedPlayerCode ];
    //NSString *API_URL = [NSString stringWithFormat:@"%@BOWLINGKPISESSIONWISE/IMSC023D017C2AA4FC420171114191400995/%@/PYC0000345",URL_FOR_RESOURCE(@""),Innings ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE %@",responseObject);
        NSDictionary *ResponseDictionary = responseObject;
        session2 = [ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"];
        
        for (NSDictionary* dict in session2) {
            if(![selectedDaysArray2 containsObject:[dict valueForKey:@"DayNo"]])
            {
                [selectedDaysArray2 addObject:[dict valueForKey:@"DayNo"]];
            }
        }
        
        id buttonName1 = [NSString stringWithFormat:@"Day%@",[selectedDaysArray1 firstObject]];
        id buttonName2 = [NSString stringWithFormat:@"Day%@",[selectedDaysArray2 firstObject]];
        [self selectFirstDayInFirstInnings:buttonName1];
        [self selectFirstDayInsecondInnings:buttonName2];
        [AppCommon hideLoading];
         
        
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.tblBowling reloadData];
        //        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
    }];
}

-(void)getInningsCount:(NSArray *)array
{
    [inningsCountArray removeAllObjects];
    for (id value in inningsArray) {
        [inningsCountArray addObject:[value valueForKey:@"InningsNo"]];
    }
}
-(void)resetValues
{
    self.lblPlayerName.text = @"";
    self.lblPlayerDesignation.text = @"";
    self.lblPlayerRole.text = @"";
    self.lblTest1.text = @"";
    self.lblTest2.text = @"";
    
}

-(void)setPlayerDetails:(NSDictionary *)dictionary
{
    self.lblPlayerName.text = [dictionary valueForKey:@"PlayerName"];
    self.lblPlayerDesignation.text = [dictionary valueForKey:@"PlayerRole"];
    self.lblPlayerRole.text = [dictionary valueForKey:@"BatStyle"];
    [self.imgviewPlayer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [dictionary valueForKey:@"PlayerPhoto"]]]
                          placeholderImage:[UIImage imageNamed:@"Default_image"]];

    //    self.imgviewPlayer
    
}

-(void)setInningsDetails:(NSArray *)arrayResponse
{
    NSLog(@"arrayResponse:%@", arrayResponse);
    NSString* runs = [[arrayResponse firstObject] valueForKey:@"Runs"];
    
    self.lblTest1.text = [NSString stringWithFormat:@"%@/%@",runs,[[arrayResponse firstObject] valueForKey:@"Wkts"]];
    
    if (arrayResponse.count == 1) {
        [self.lblTest1 setHidden:YES];
        [self.lblSeparator setHidden:YES];
        NSString* run2 = [[arrayResponse firstObject] valueForKey:@"Runs"];
        
        self.lblTest2.text = [NSString stringWithFormat:@"%@/%@",run2,[[arrayResponse firstObject] valueForKey:@"Wkts"]];
        
        
        return;
    }
    NSString* run2 = [[arrayResponse lastObject] valueForKey:@"Runs"];
    
    self.lblTest2.text = [NSString stringWithFormat:@"%@/%@",run2,[[arrayResponse lastObject] valueForKey:@"Wkts"]];
    
}

-(NSString *)getRunWickets:(NSString *)R and:(NSString *)W
{
    NSString* RW = [NSString stringWithFormat:@"%@/%@",R,W];
    
    return RW;
}

-(UIView *) getLineView : (UIButton *) btn{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height+5, 100, 5)];
    lineView.backgroundColor =[UIColor whiteColor];
    lineView.tag = 1234;
    return lineView;
}

-(void) clearBtnSubView : (UIButton *) btn{
    for (UIView *view in [btn subviews])
    {
        if(view.tag == 1234){
            [view removeFromSuperview];
        }
    }
}

#pragma mark UICollectionView Delegates


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return videoURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    BallsInVideosCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ballsInVideosCVC" forIndexPath:indexPath];
    
    cell.ballLbl.layer.masksToBounds = true;
    cell.ballLbl.clipsToBounds = true;
    cell.ballLbl.layer.cornerRadius = cell.ballLbl.frame.size.width/2;
    
    
    
    cell.ballLbl.text = [NSString stringWithFormat:@"%ld",((long)indexPath.row+1)];
    
    if(selectedVideo == indexPath.row){
        
        cell.ballLbl.backgroundColor = [UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        cell.ballLbl.textColor = [UIColor whiteColor];
        
    }else{
        cell.ballLbl.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(221/255.0f) blue:(221/255.0f) alpha:1.0f];
        cell.ballLbl.textColor = [UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        
        
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    selectedVideo = (int) indexPath.row;
    
    NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:indexPath.row];
    NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
    
    
    
    NSURL *videoURL = [NSURL URLWithString:url];
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];
    [self.avPlayerViewController.view removeFromSuperview];
    self.avPlayer = NULL;
    
    
    self.avPlayer = [AVPlayer playerWithURL:videoURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayerViewController.player ];
    
    
    self.avPlayerViewController = [AVPlayerViewController new];
    self.avPlayerViewController.player = self.avPlayer;
    self.avPlayerViewController.view.frame = _videoView.bounds;
    [_videoView addSubview:self.avPlayerViewController.view];
    
    [self.avPlayer play];
    
    [self.ballsColView reloadData];
    
}

-(void)loadVideoPlayer: (NSString *) playercode : (NSString *) value: (NSString *) batOrBowl innings:(NSString*)innNo
{
    
    //[self loadVideoPlayer: [player valueForKey:@"FielderCode"] : typeName: @"FIELDING"  innings: [NSString stringWithFormat:@"%d", selectedTab]];
    
    //NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
    ScoreCardVideoPlayer * videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
    videoPlayerVC = (ScoreCardVideoPlayer *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
    videoPlayerVC.MatchCode = self.SelectedMatchCode;
    videoPlayerVC.PlayerCode = playercode;
    videoPlayerVC.VideoValue = value;
    videoPlayerVC.Innings = innNo;
    videoPlayerVC.Type = batOrBowl;
    [self.navigationController presentViewController:videoPlayerVC animated:YES completion:nil];
}


#pragma mark Video player methods


//GETSCORECARDVIDEOSFILEPATH/' + BatsmanCode + '/' + $scope.MatchCode + '/' + $scope.DefaultInn + '/' + value + '/' + batorbowl

-(void)loadVideoPathsForPlayer:(NSString *)batsmanCode andValue:(NSString *) value type:(NSString *) batOrBowl inningsCount:(NSString *)innno
{
    
   [AppCommon showLoading];
    WebService *objWebservice = [[WebService alloc]init];
    
    
    [objWebservice GetVideoPathFile :GetVideoFilePath  :batsmanCode :self.SelectedMatchCode : innno :value : batOrBowl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setDictionary:responseObject];
            
            videoURLArray= [[NSMutableArray alloc] init];
            videoURLArray =  [dic1 valueForKey:@"lstScoreCardVideoFilePathValuesRuns"];
            
            if(videoURLArray.count >0){
                selectedVideo = 0;
                self.rootVideoView.hidden = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.ballsColView reloadData];
                });
                
                
                
                NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
                NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
                
                
                
                NSURL *videoURL = [NSURL URLWithString:url];
                
                [self.avPlayer seekToTime:CMTimeMake(0, 1)];
                [self.avPlayer pause];
                [self.avPlayerViewController.view removeFromSuperview];
                self.avPlayer = NULL;
                
                
                self.avPlayer = [AVPlayer playerWithURL:videoURL];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayerViewController.player ];
                
                
                self.avPlayerViewController = [AVPlayerViewController new];
                self.avPlayerViewController.player = self.avPlayer;
                self.avPlayerViewController.view.frame = _videoView.bounds;
                [_videoView addSubview:self.avPlayerViewController.view];
                
                [self.avPlayer play];
                
                
            }
            //[self setDataDictInTableView: dic1];
            
        }
        
        [AppCommon hideLoading];
        self.view.userInteractionEnabled = true;
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        //NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        self.view.userInteractionEnabled = true;
    }];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    
    if((selectedVideo+1)<videoURLArray.count){
        selectedVideo = selectedVideo +1;
        
        [self.ballsColView reloadData];
        
        NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
        NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
        
        
        
        NSURL *videoURL = [NSURL URLWithString:url];
        
        [self.avPlayer seekToTime:CMTimeMake(0, 1)];
        [self.avPlayer pause];
        [self.avPlayerViewController.view removeFromSuperview];
        self.avPlayer = NULL;
        
        
        self.avPlayer = [AVPlayer playerWithURL:videoURL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer];
        
        
        self.avPlayerViewController = [AVPlayerViewController new];
        self.avPlayerViewController.player = self.avPlayer;
        self.avPlayerViewController.view.frame = _videoView.bounds;
        [_videoView addSubview:self.avPlayerViewController.view];
        
        [self.avPlayer play];
    }
    
}

- (IBAction)onClickCloseVideo:(id)sender {
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];
    [self.avPlayerViewController.view removeFromSuperview];
    self.avPlayer = NULL;
    
    _rootVideoView.hidden = YES;
    
    
    
}

@end
