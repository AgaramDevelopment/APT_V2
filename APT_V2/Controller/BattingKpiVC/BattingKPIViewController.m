//
//  BattingKPIViewController.m
//  NewSportsProject
//
//  Created by user on 27/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//
@class BattingTableViewCell;

#import "BattingKPIViewController.h"
#import "BattingTableViewCell.h"
#import "WebService.h"
#import "CustomNavigation.h"
#import "Config.h"
//#import "FieldSummaryVC.h"
#import "AppCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BallsInVideosCVC.h"
#import "ScoreCardVideoPlayer.h"


#define DarkBlue = [UIColor colorWithRed:16.0/255.0 green:45.0/255.0 blue:124.0/255.0 alpha:1.0]

@interface BattingKPIViewController ()
{
    NSMutableArray* inningsArray,* sessionArray;
    NSMutableArray* daysArray;
    NSMutableArray *inningsCountArray;
    BOOL isSecondInngsCalled;
    NSMutableArray* session1,* session2;
    NSInteger selectedSection1,selectedSection2;
    NSMutableArray* selectedDaysArray1, *selectedDaysArray2;
    
    NSMutableArray* arr1,*arr2;
    int selectedVideo;
    NSMutableArray  *videoURLArray;
    NSArray* videoArrayValues;
}

@end

@implementation BattingKPIViewController

@synthesize lblPlayerName,lblPlayerSpeciality,lblPlayerDesignation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedVideo = 0;

    videoArrayValues = @[@"RUNS", @"BALLS",@"ONES", @"TWOS", @"THREES", @"FOURS", @"SIXES"];

    [self customnavigationmethod];
    inningsArray = [NSMutableArray new];
    sessionArray = [NSMutableArray new];
    daysArray = [NSMutableArray new];
    inningsCountArray = [NSMutableArray new];
    
    session1 = [NSMutableArray new];
    session2 = [NSMutableArray new];
    
    selectedDaysArray1 = [NSMutableArray new];
    selectedDaysArray2 = [NSMutableArray new];
    
    arr1 = [NSMutableArray new];
    arr2 = [NSMutableArray new];
    [self resetValues];
    
    [self inningsWebService];
    //    UIColor *darkblue = [UIColor colorWithRed:16.0/255.0 green:45.0/255.0 blue:124.0/255.0 alpha:1.0];
    //    [_tblBattingKPI registerNib:[UINib nibWithNibName:@"BattingTableViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderFooter1"];
    //    [_tblBattingKPI registerClass:[BattingTableViewCell class] forHeaderFooterViewReuseIdentifier:@"HeaderFooter1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //        if (isSecondInngsCalled) {
        //            NSArray* temp1 = sessionArray[0];
        //            NSArray* temp2 = sessionArray[1];
        //
        //            return (temp2 > 0 ? temp1.count+temp2.count+2 : temp1.count+temp2.count);
        //
        //        }
        //        NSArray* temp1 = sessionArray[0];
        //        return (temp1 > 0 ? temp1.count+1 : temp1.count);
        
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
/*
 - (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 if(section == 0)
 {
 return NULL;
 }
 BattingTableViewCell *cell = [_tblBattingKPI dequeueReusableCellWithIdentifier:@"HeaderFooter1"];
 NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"BattingTableViewCell" owner:self options:nil];
 cell = arr[2];
 
 if (sessionArray.count > 0) {
 NSLog(@"Header days button Reloaded");
 
 if ([[[sessionArray objectAtIndex:section] valueForKey:@"DayNo"] isEqualToString:@"1"]) {
 [cell.btnDay1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [cell.btnDay2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 
 }else if ([[[sessionArray objectAtIndex:section] valueForKey:@"DayNo"] isEqualToString:@"2"]) {
 [cell.btnDay1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [cell.btnDay3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 
 }else if ([[[sessionArray objectAtIndex:section] valueForKey:@"DayNo"] isEqualToString:@"3"]) {
 [cell.btnDay1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [cell.btnDay4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 
 }else if ([[[sessionArray objectAtIndex:section] valueForKey:@"DayNo"] isEqualToString:@"4"]) {
 [cell.btnDay1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [cell.btnDay5 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 
 }else if ([[[sessionArray objectAtIndex:section] valueForKey:@"DayNo"] isEqualToString:@"5"]) {
 [cell.btnDay1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
 [cell.btnDay5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
 }
 }
 [cell.btnDay1 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
 [cell.btnDay2 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
 [cell.btnDay3 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
 [cell.btnDay4 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
 [cell.btnDay5 addTarget:self action:@selector(daysAction:) forControlEvents:UIControlEventTouchUpInside];
 
 //    if (cell.btnDay1.tag == 0) {
 //        cell.btnDay1.tag = 1;
 //    }
 
 
 return cell;
 }
 */
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1)
    {
        return NULL;
    }
    BattingTableViewCell *cell = [_tblBattingKPI dequeueReusableCellWithIdentifier:@"HeaderFooter1"];
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"BattingTableViewCell" owner:self options:nil];
    cell = arr[1];
    
    return cell;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BattingTableViewCell *cell = [_tblBattingKPI dequeueReusableCellWithIdentifier:@"FIRSTINDEX"];
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"BattingTableViewCell" owner:self options:nil];
    
    
    if(indexPath.section == 0) // Innings section
    {
        cell = arr[0];
        NSString* Fours = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Fours"];
        NSString* Sixs = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Sixs"];
        NSString* Runs = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
        NSString* dotBalls = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Dots"];
        NSString* balls = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Balls"];
        cell.lblInningsCount.text = [NSString stringWithFormat:@"Innings %@",[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"]];
        cell.lblRuns_in.text = Runs;
        cell.lblBalls_in.text = balls;
        cell.lblDB_in.text = [self getDotBallFrom:dotBalls andhitBalls:balls];
        cell.lblB_in.text = [self getBoundryValueFromFour:Fours andSix:Sixs andTotalRun:Runs];
        cell.lblSR_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"SR"];
        cell.lblOne_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Ones"];
        cell.lblTwo_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Twos"];
        cell.lblThree_in.text = [[inningsArray objectAtIndex:indexPath.row] valueForKey:@"Threes"];
        cell.lblFour_in.text = Fours;
        cell.lblSix_in.text = Sixs;
        
        [cell.btnRuns setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnBalls setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnOnes setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnTwos setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnThrees setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnFours setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        [cell.btnSixs setTitle:[[inningsArray objectAtIndex:indexPath.row]valueForKey:@"InningsNo"] forState:UIControlStateNormal];
        
        [cell.btnRuns addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnBalls addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnOnes addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTwos addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnThrees addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnFours addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSixs addTarget:self action:@selector(buttonActionForVideoPlaying:) forControlEvents:UIControlEventTouchUpInside];
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
        cell.lblSessionCount.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"SessionNo"];
        cell.lblRuns_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Runs"];
        cell.lblBalls_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Balls"];
        cell.lblDB_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Dots"];
        cell.lblSR_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"SR"];
        cell.lblOnes_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Ones"];
        cell.lblTwos_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Twos"];
        cell.lblThrees_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Threes"];
        cell.lblFours_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Fours"];
        cell.lblSixs_Session.text = [[arr1 objectAtIndex:indexPath.row-1] valueForKey:@"Sixs"];
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
        cell.lblSessionCount.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"SessionNo"];
        cell.lblRuns_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Runs"];
        cell.lblBalls_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Balls"];
        cell.lblDB_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Dots"];
        cell.lblSR_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"SR"];
        cell.lblOnes_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Ones"];
        cell.lblTwos_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Twos"];
        cell.lblThrees_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Threes"];
        cell.lblFours_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Fours"];
        cell.lblSixs_Session.text = [[arr2 objectAtIndex:indexPath.row-1] valueForKey:@"Sixs"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)buttonActionForVideoPlaying:(id)sender
{
    NSString* selectedValue = [videoArrayValues objectAtIndex:[sender tag]];
    NSString* InningsCount = [sender titleForState:UIControlStateNormal];
    NSLog(@"%@",selectedValue);
//    [self loadVideoPathsForPlayer:self.SelectedPlayerCode andValue:selectedValue type:@"BATTING" inningsCount:InningsCount];
    
    ScoreCardVideoPlayer * videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
    videoPlayerVC = (ScoreCardVideoPlayer *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
    videoPlayerVC.MatchCode = self.SelectedMatchCode;
    videoPlayerVC.PlayerCode = self.SelectedPlayerCode;
    videoPlayerVC.VideoValue = selectedValue;
    videoPlayerVC.Innings = InningsCount;
    videoPlayerVC.Type = @"BATTING";
    [self.navigationController presentViewController:videoPlayerVC animated:YES completion:nil];

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
    if(![str isEqualToString:@""])
    {
        [arr1 removeAllObjects];
        
    }
    
    
    for (NSDictionary* dict in session1) {
        if ([[dict valueForKey:@"DayNo"]isEqualToString:str]) {
            [arr1 addObject:dict];
        }
    }
    selectedSection1 = [str integerValue];

//    selectedSection1 = [NSIndexPath indexPathWithIndex:[str integerValue]];
    
//    id header = [_tblBattingKPI cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //    id header1 = [_tblBattingKPI headerViewForSection:1];
    
//    if ([[BattingTableViewCell classForCoder] isKindOfClass:header])
//    {
//        BattingTableViewCell* cell = header;
//        [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//    }
    //    BattingTableViewCell* cell = header;
    ////    [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    ////    FieldSummaryVC *fieldSummary = [FieldSummaryVC new];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //    if ([sender.titleLabel.text isEqualToString:@"Day 1"]) {
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay5];
    //
    //        [cell.btnDay1 addSubview:[self getLineView:cell.btnDay1]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 2"]){
    //        [self clearBtnSubView:cell.btnDay1];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay5];
    //        [cell.btnDay2 addSubview:[self getLineView:cell.btnDay2]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 3"]){
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay1];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay5];
    //        [cell.btnDay3 addSubview:[self getLineView:cell.btnDay3]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 4"]){
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay1];
    //        [self clearBtnSubView:cell.btnDay5];
    //        [cell.btnDay4 addSubview:[self getLineView:cell.btnDay4]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 5"]){
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay1];
    //        [cell.btnDay5 addSubview:[self getLineView:cell.btnDay5]];
    //    }
    //
    ////        [self.tblBattingKPI reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    ////        [self.tblBattingKPI reloadRowsAtIndexPaths:@[@0] withRowAnimation:UITableViewRowAnimationNone];
    //
    //        [self.tblBattingKPI reloadData];
    //    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBattingKPI reloadData];
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
    
    if(![str isEqualToString:@""])
    {
        [arr2 removeAllObjects];
        
    }
    
    
    for (NSDictionary* dict in session2) {
        if ([[dict valueForKey:@"DayNo"]isEqualToString:str]) {
            [arr2 addObject:dict];
        }
    }
    
//    selectedSection2 = [NSIndexPath indexPathWithIndex:[str integerValue]];
    selectedSection2 = [str integerValue];

    
    //    id header = [_tblBattingKPI cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //    //    id header1 = [_tblBattingKPI headerViewForSection:1];
    //
    //    if ([[BattingTableViewCell classForCoder] isKindOfClass:header])
    //    {
    //        BattingTableViewCell* cell = header;
    //        [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    }
    //    BattingTableViewCell* cell = header;
    //    //    [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    //    FieldSummaryVC *fieldSummary = [FieldSummaryVC new];
    //    if ([sender.titleLabel.text isEqualToString:@"Day 1"]) {
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay5];
    //
    //        [cell.btnDay1 addSubview:[self getLineView:cell.btnDay1]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 2"]){
    //        [self clearBtnSubView:cell.btnDay1];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay5];
    //        [cell.btnDay2 addSubview:[self getLineView:cell.btnDay2]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 3"]){
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay1];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay5];
    //        [cell.btnDay3 addSubview:[self getLineView:cell.btnDay3]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 4"]){
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay1];
    //        [self clearBtnSubView:cell.btnDay5];
    //        [cell.btnDay4 addSubview:[self getLineView:cell.btnDay4]];
    //    }else if([sender.titleLabel.text isEqualToString:@"Day 5"]){
    //        [self clearBtnSubView:cell.btnDay2];
    //        [self clearBtnSubView:cell.btnDay3];
    //        [self clearBtnSubView:cell.btnDay4];
    //        [self clearBtnSubView:cell.btnDay1];
    //        [cell.btnDay5 addSubview:[self getLineView:cell.btnDay5]];
    //    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBattingKPI reloadData];
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
//    selectedSection1 = [NSIndexPath indexPathWithIndex:[str integerValue]];
    selectedSection1 = [str integerValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBattingKPI reloadData];
        
    });
    
    
    
//    id header = [_tblBattingKPI cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //    id header1 = [_tblBattingKPI headerViewForSection:1];
    
//    if ([[BattingTableViewCell classForCoder] isKindOfClass:header])
//    {
//        BattingTableViewCell* cell = header;
//        [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }
    //    BattingTableViewCell* cell = header;
    //    [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
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
//    selectedSection2 = [NSIndexPath indexPathWithIndex:[str integerValue]];
    selectedSection2 = [str integerValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBattingKPI reloadData];
        
    });
    
//    id header = [_tblBattingKPI cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //    id header1 = [_tblBattingKPI headerViewForSection:1];
    
//    if ([[BattingTableViewCell classForCoder] isKindOfClass:header])
//    {
//        BattingTableViewCell* cell = header;
//        [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }
    //    BattingTableViewCell* cell = header;
    //    [cell.btnDay1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
}


#pragma mark WEBSERVICE

-(void)inningsWebService
{
    /*
     API URL    :   http://13.126.151.253:9001/AGAPTSERVICE.svc/LOADBATTINGKPIFORPLAYER/
     METHOD     :   GET
     PARAMETER  :   {MATCHCODE}/{TEAMCODE}/{PLAYERCODE}
     
     IMSC022D017C2AA4FC420171206183301000 // ondeday match code
     IMSC023D017C2AA4FC420171114191800997 // test match code
     
     mathe PYC0000431
     murali vijay PYC0000287
     */
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@LOADBATTINGKPIFORPLAYER/%@/%@/%@",URL_FOR_RESOURCE(@""),_SelectedMatchCode,_SelectedTeamCode,_SelectedPlayerCode ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE %@",responseObject);
        NSDictionary *ResponseDictionary = responseObject;
        inningsArray = [ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"];
        [self setInningsDetails:[ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"]];
        [self setPlayerDetails:[[ResponseDictionary valueForKey:@"lstKPIPlayerDetails"]firstObject]];


        if(inningsArray.count == 0)
        {
            self.lbl1st_Inn_Runs.text = @"";
            self.lbl1st_inn_Balls.text = @"";
            self.lbl2nd_inn_Runs.text = @"";
            self.lbl2nd_inn_Balls.text = @"";

            [AppCommon hideLoading];
             

            return ;
        }
        
        [self getInningsCount:[ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"]];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.tblBattingKPI reloadData];
        //        });
        //        isSecondInngsCalled = false;
        
        [AppCommon hideLoading];
         
        [self sessionSummaryWebService:[inningsCountArray firstObject]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
    }];
    
}

-(void)sessionSummaryWebService:(NSString *)Innings
{
    /*
     
     API URL    :   http://13.126.151.253:9001/AGAPTSERVICE.svc/BATTINGKPISESSIONWISE/
     METHOD     :   GET
     PARAMETER  :   {MATCHCODE}/{INNS}/{PLAYERCODE}
     
     
     
     */
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@BATTINGKPISESSIONWISE/%@/%@/%@",URL_FOR_RESOURCE(@""),_SelectedMatchCode,Innings,_SelectedPlayerCode ];
    //NSString *API_URL = [NSString stringWithFormat:@"%@BATTINGKPISESSIONWISE/IMSC022D017C2AA4FC420171206183301000/%@/PYC0000431",URL_FOR_RESOURCE(@""),Innings ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE %@",responseObject);
        NSDictionary *ResponseDictionary = responseObject;
        session1 = [ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"];
        //        NSMutableDictionary* dict = [NSMutableDictionary new];
        //        [dict ]
        
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
     
     API URL    :   http://13.126.151.253:9001/AGAPTSERVICE.svc/BATTINGKPISESSIONWISE/
     METHOD     :   GET
     PARAMETER  :   {MATCHCODE}/{INNS}/{PLAYERCODE}
     
     */
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@BATTINGKPISESSIONWISE/%@/%@/%@",URL_FOR_RESOURCE(@""),_SelectedMatchCode,Innings,_SelectedPlayerCode ];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE SESSION2 %@",responseObject);
        NSDictionary *ResponseDictionary = responseObject;
        session2 = [ResponseDictionary valueForKey:@"lstKPIMatchScoreSummary"];
        
        for (NSDictionary* dict in session2) {
            if(![selectedDaysArray2 containsObject:[dict valueForKey:@"DayNo"]])
            {
                [selectedDaysArray2 addObject:[dict valueForKey:@"DayNo"]];
            }
        }
        
        
        
        //        NSMutableArray* day1 = [NSMutableArray new];
        //        NSMutableArray* day2 = [NSMutableArray new];
        //        NSMutableArray* day3 = [NSMutableArray new];
        //        NSMutableArray* day4 = [NSMutableArray new];
        //        NSMutableArray* day5 = [NSMutableArray new];
        //
        //        for (NSDictionary *dict in session2) {
        //            if ([[dict valueForKey:@"DayNo"] isEqualToString:@"1"]) {
        //                [day1 addObject:dict];
        //            }else if ([[dict valueForKey:@"DayNo"] isEqualToString:@"2"]) {
        //                [day2 addObject:dict];
        //            }
        //            else if ([[dict valueForKey:@"DayNo"] isEqualToString:@"3"]) {
        //                [day3 addObject:dict];
        //            }
        //            else if ([[dict valueForKey:@"DayNo"] isEqualToString:@"4"]) {
        //                [day4 addObject:dict];
        //            }
        //            else if ([[dict valueForKey:@"DayNo"] isEqualToString:@"5"]) {
        //                [day5 addObject:dict];
        //            }
        //        }
        
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        id buttonName1 = [NSString stringWithFormat:@"Day%@",[selectedDaysArray1 firstObject]];
        id buttonName2 = [NSString stringWithFormat:@"Day%@",[selectedDaysArray2 firstObject]];
        //            UIButton* but1 = [[UIButton alloc] initWithFrame:CGRectZero];
        //            [but1 setTitle:buttonName1 forState:UIControlStateNormal];
        //
        //            UIButton* but2 = [[UIButton alloc] initWithFrame:CGRectZero];
        //            [but1 setTitle:buttonName2 forState:UIControlStateNormal];
        
        //            [self daysAction:but1];
        //            [self daysAction1:but2];
        
        [self selectFirstDayInFirstInnings:buttonName1];
        [self selectFirstDayInsecondInnings:buttonName2];
        [AppCommon hideLoading];
         
        
        //            [self.tblBattingKPI reloadData];
        //        });
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblBattingKPI reloadData];
        });
        
    }];
}

#pragma mark Custom methods

-(void)getInningsCount:(NSArray *)array
{
    [inningsCountArray removeAllObjects];
    for (id value in inningsArray) {
        [inningsCountArray addObject:[value valueForKey:@"InningsNo"]];
    }
}

-(NSMutableArray* )selectDayButton:(NSMutableArray *)array andDay:(NSString *)day
{
    NSMutableArray* temp = [NSMutableArray new];
    for (NSDictionary* dict in array) {
        if ([[dict valueForKey:@""] isEqualToString:day]) {
            [temp addObject:dict];
        }
    }
    
    return temp;
}
-(void)resetValues
{
    self.lblPlayerName.text = @"";
    self.lblPlayerDesignation.text = @"";
    self.lblPlayerSpeciality.text = @"";
    self.lbl1st_Inn_Runs.text = @"";
    self.lbl1st_inn_Balls.text = @"";
    self.lbl2nd_inn_Runs.text = @"";
    self.lbl2nd_inn_Balls.text = @"";
    
    
}

-(void)setPlayerDetails:(NSDictionary *)dictionary
{
    NSLog(@"__________________________________________");
    NSLog(@"Selected player details \n %@",dictionary);
    NSLog(@"__________________________________________");
    
    self.lblPlayerName.text = [dictionary valueForKey:@"PlayerName"];
    self.lblPlayerDesignation.text = [dictionary valueForKey:@"PlayerRole"];
    self.lblPlayerSpeciality.text = [dictionary valueForKey:@"BatStyle"];
    [self.imgviewPlayer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [dictionary valueForKey:@"PlayerPhoto"]]]
                        placeholderImage:[UIImage imageNamed:@"Default_image"]];
}
-(void)setInningsDetails:(NSArray *)arrayResponse
{
    self.lbl1st_Inn_Runs.text = [[arrayResponse firstObject] valueForKey:@"Runs"];
    self.lbl1st_inn_Balls.text = [NSString stringWithFormat:@"(%@)",[[arrayResponse firstObject] valueForKey:@"Balls"]];
    
    if (arrayResponse.count == 1) {
        [self.lbl1st_Inn_Runs setHidden:YES];
        [self.lbl1st_inn_Balls setHidden:YES];
        [self.lblSeparator setHidden:YES];
        
        self.lbl2nd_inn_Runs.text = [[arrayResponse lastObject] valueForKey:@"Runs"];
        self.lbl2nd_inn_Balls.text = [NSString stringWithFormat:@"(%@)",[[arrayResponse lastObject] valueForKey:@"Balls"]];
        
        return;
    }
    self.lbl2nd_inn_Runs.text = [[arrayResponse lastObject] valueForKey:@"Runs"];
    self.lbl2nd_inn_Balls.text = [NSString stringWithFormat:@"(%@)",[[arrayResponse lastObject] valueForKey:@"Balls"]];
    
}

-(NSString *)getBoundryValueFromFour:(NSString *)Fours andSix:(NSString *)Sixs andTotalRun:(NSString *)Runs
{
    /*
     Based on Runs
     
     Runs = 73, Fours = 7, Six = 0
     Total Boundry = (7*4)28
     28/73 = 0.3835616438 * 100 => 38.35;
     */
    
    float Run = [Runs intValue];
    float Four = [Fours intValue];
    float Six = [Sixs intValue];
    float totalBoundry = (Four * 4) + (Six * 6);
    float result = (totalBoundry/Run) * 100;
    NSLog(@"(%f / %f) * 100 ",totalBoundry,Run);
    
    NSString* res = [NSString stringWithFormat:@"%.02f %@",result,@"%"];
    
    return res;
}

-(NSString *)getDotBallFrom:(NSString *)dotBalls andhitBalls:(NSString *)totalBalls
{
    /*
     DotBalls / totalBalls * 100
     */
    float TB = [totalBalls intValue];
    float DB = [dotBalls intValue];
    float result = (DB / TB) * 100;
    
    NSString* res = [NSString stringWithFormat:@"%.02f %@",result,@"%"];
    return res;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    UITouch *touch = [[event allTouches] anyObject];
    //    lastLocation = [touch locationInView:self];
    [super touchesEnded:touches withEvent:event];
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
