//
//  PlayersVC.m
//  NewSportsProject
//
//  Created by Mac on 27/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//


#import "PlayersVC.h"
#import "CustomNavigation.h"
#import "Config.h"
#import "PlayersCell.h"
#import "BattingKPIViewController.h"
#import "BowlingKPIViewController.h"
#import "WebService.h"


@interface PlayersVC ()
{
    NSString *teamcode;
}

@end

@implementation PlayersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"BatsmanDetailsArray1:%@", self.BatsmanDetailsArray1);
//    NSLog(@"BatsmanDetailsArray2:%@", self.BatsmanDetailsArray2);
//    NSLog(@"BatsmanDetailsArray3:%@", self.BatsmanDetailsArray3);
//    NSLog(@"BatsmanDetailsArray4:%@", self.BatsmanDetailsArray4);
//
//    NSLog(@"BowlingDetailsArray1:%@", self.BowlingDetailsArray1);
//    NSLog(@"BowlingDetailsArray2:%@", self.BowlingDetailsArray2);
//    NSLog(@"BowlingDetailsArray3:%@", self.BowlingDetailsArray3);
//    NSLog(@"BowlingDetailsArray4:%@", self.BowlingDetailsArray4);
    
    if (self.inningsDetailsArray.count == 2) {
        
        if (self.indexPath == 0) {
            [self.team1Btn setTitle:[[self.matchDetailss valueForKey:@"team1"] objectAtIndex:0] forState:UIControlStateNormal];
            [self.team2Btn setTitle:[[self.matchDetailss valueForKey:@"team2"] objectAtIndex:0] forState:UIControlStateNormal];
        } else if (self.indexPath == 1) {
            [self.team1Btn setTitle:[[self.matchDetailss valueForKey:@"team2"] objectAtIndex:0] forState:UIControlStateNormal];
            [self.team2Btn setTitle:[[self.matchDetailss valueForKey:@"team1"] objectAtIndex:0] forState:UIControlStateNormal];
        }
    } else {
        [self.team1Btn setTitle:[[self.matchDetailss valueForKey:@"team1"] objectAtIndex:0] forState:UIControlStateNormal];
        [self.team2Btn setTitle:[[self.matchDetailss valueForKey:@"team2"] objectAtIndex:0] forState:UIControlStateNormal];
    }
    
    if (self.inningsDetailsArray.count == 2) {
        commonArray = [[NSMutableArray alloc] init];
        if (self.indexPath == 0) {
            commonArray = self.BatsmanDetailsArray1;
            numberOfItems = (int)self.BatsmanDetailsArray1.count;
        }
        
        if (self.indexPath == 1) {
            commonArray = self.BowlingDetailsArray1;
            numberOfItems = (int)self.BowlingDetailsArray1.count;
        }
    } else if (self.inningsDetailsArray.count == 4) {
        
        //Default to display Team1
        commonArray1 = [[NSMutableArray alloc] init];
        commonArray2 = [[NSMutableArray alloc] init];
        
        BatsmanDetailsArray11 = [[NSMutableArray alloc] init];
        BatsmanDetailsArray33 = [[NSMutableArray alloc] init];
        BatsmanDetailsArray22 = [[NSMutableArray alloc] init];
        BatsmanDetailsArray44 = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            
            BatsmanDetailsArray11 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray1];
            BatsmanDetailsArray33 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray3];
            
            BatsmanDetailsArray22 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray2];
            BatsmanDetailsArray44 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray4];
            
            //Find team1MaxBatsmanCount for Rows
            if (self.BatsmanDetailsArray1.count > self.BatsmanDetailsArray3.count) {
                team1MaxBatsmanCount = (int)self.BatsmanDetailsArray1.count;
                for (int i = (int)self.BatsmanDetailsArray3.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray33  addObject:dict];
                }
            } else {
                team1MaxBatsmanCount = (int)self.BatsmanDetailsArray3.count;
                for (int i = (int)self.BatsmanDetailsArray1.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray11  addObject:dict];
                }
            }
            numberOfItems = team1MaxBatsmanCount;
            
            if (self.BatsmanDetailsArray2.count > self.BatsmanDetailsArray4.count) {
                team2MaxBatsmanCount = (int)self.BatsmanDetailsArray2.count;
                for (int i = (int)self.BatsmanDetailsArray4.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray44  addObject:dict];
                }
            } else {
                team2MaxBatsmanCount = (int)self.BatsmanDetailsArray4.count;
                for (int i = (int)self.BatsmanDetailsArray2.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray22  addObject:dict];
                }
            }
            
            commonArray1 = BatsmanDetailsArray11;
            commonArray2 = BatsmanDetailsArray33;
        }
        
        if (self.indexPath == 1) {
            
            BatsmanDetailsArray11 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray1];
            BatsmanDetailsArray33 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray3];
            
            BatsmanDetailsArray22 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray2];
            BatsmanDetailsArray44 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray4];
            
            //Find team1MaxBatsmanCount for Rows
            if (self.BowlingDetailsArray1.count > self.BowlingDetailsArray3.count) {
                team1MaxBatsmanCount = (int)self.BowlingDetailsArray1.count;
                for (int i = (int)self.BowlingDetailsArray3.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray33  addObject:dict];
                }
            } else {
                team1MaxBatsmanCount = (int)self.BowlingDetailsArray3.count;
                for (int i = (int)self.BowlingDetailsArray1.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray11  addObject:dict];
                }
            }
            
            if (self.BowlingDetailsArray2.count > self.BowlingDetailsArray4.count) {
                team2MaxBatsmanCount = (int)self.BowlingDetailsArray2.count;
                for (int i = (int)self.BowlingDetailsArray4.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray44  addObject:dict];
                }
            } else {
                team2MaxBatsmanCount = (int)self.BowlingDetailsArray4.count;
                for (int i = (int)self.BowlingDetailsArray2.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray22  addObject:dict];
                }
            }
            numberOfItems = team2MaxBatsmanCount;
            commonArray1 = BatsmanDetailsArray22;
            commonArray2 = BatsmanDetailsArray44;
        }
    } else if (self.inningsDetailsArray.count == 3) {
        
        //Default to display Team1
        commonArray1 = [[NSMutableArray alloc] init];
        commonArray2 = [[NSMutableArray alloc] init];
        
        BatsmanDetailsArray11 = [[NSMutableArray alloc] init];
        BatsmanDetailsArray33 = [[NSMutableArray alloc] init];
        BatsmanDetailsArray22 = [[NSMutableArray alloc] init];
        BatsmanDetailsArray44 = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            
            BatsmanDetailsArray11 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray1];
            BatsmanDetailsArray33 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray3];
            
            BatsmanDetailsArray22 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray2];
            BatsmanDetailsArray44 = [NSMutableArray arrayWithArray:self.BatsmanDetailsArray4];
            
            //Find team1MaxBatsmanCount for Rows
            if (self.BatsmanDetailsArray1.count > self.BatsmanDetailsArray3.count) {
                team1MaxBatsmanCount = (int)self.BatsmanDetailsArray1.count;
                for (int i = (int)self.BatsmanDetailsArray3.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray33  addObject:dict];
                }
            } else {
                team1MaxBatsmanCount = (int)self.BatsmanDetailsArray3.count;
                for (int i = (int)self.BatsmanDetailsArray1.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray11  addObject:dict];
                }
            }
            numberOfItems = team1MaxBatsmanCount;
            
            if (self.BatsmanDetailsArray2.count > self.BatsmanDetailsArray4.count) {
                team2MaxBatsmanCount = (int)self.BatsmanDetailsArray2.count;
                for (int i = (int)self.BatsmanDetailsArray4.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray44  addObject:dict];
                }
            } else {
                team2MaxBatsmanCount = (int)self.BatsmanDetailsArray4.count;
                for (int i = (int)self.BatsmanDetailsArray2.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DNB", @"Runs", nil];
                    [BatsmanDetailsArray22  addObject:dict];
                }
            }
            
            commonArray1 = BatsmanDetailsArray11;
            commonArray2 = BatsmanDetailsArray33;
        }
        
        if (self.indexPath == 1) {
            
            BatsmanDetailsArray11 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray1];
            BatsmanDetailsArray33 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray3];
            
            BatsmanDetailsArray22 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray2];
            BatsmanDetailsArray44 = [NSMutableArray arrayWithArray:self.BowlingDetailsArray4];
            
            //Find team1MaxBatsmanCount for Rows
            if (self.BowlingDetailsArray1.count > self.BowlingDetailsArray3.count) {
                team1MaxBatsmanCount = (int)self.BowlingDetailsArray1.count;
                for (int i = (int)self.BowlingDetailsArray3.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray33  addObject:dict];
                }
            } else {
                team1MaxBatsmanCount = (int)self.BowlingDetailsArray3.count;
                for (int i = (int)self.BowlingDetailsArray1.count+1; i <= team1MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray11  addObject:dict];
                }
            }
            
            if (self.BowlingDetailsArray2.count > self.BowlingDetailsArray4.count) {
                team2MaxBatsmanCount = (int)self.BowlingDetailsArray2.count;
                for (int i = (int)self.BowlingDetailsArray4.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray44  addObject:dict];
                }
            } else {
                team2MaxBatsmanCount = (int)self.BowlingDetailsArray4.count;
                for (int i = (int)self.BowlingDetailsArray2.count+1; i <= team2MaxBatsmanCount; i=i+1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"BowlerName", @"", @"BowlerCode", @"", @"Wickets", @"", @"Runs", nil];
                    [BatsmanDetailsArray22  addObject:dict];
                }
            }
            numberOfItems = team2MaxBatsmanCount;
            commonArray1 = BatsmanDetailsArray22;
            commonArray2 = BatsmanDetailsArray44;
        }
    }
    
    [self customnavigationmethod];
    
    [self.team1Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.GridTbl reloadData];
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
       
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [objCustomNavigation.home_btn addTarget:self action:@selector(didClickSummaryBtn:) forControlEvents:UIControlEventTouchUpInside];
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
-(IBAction)didClickBackBtn:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE_DEVICE)
    {
        if(!IS_IPHONE5)
        {
            return CGSizeMake(110, 110);
        }
        else
        {
            return CGSizeMake(90, 100);
        }
    }
    else
    {
        return CGSizeMake(200, 180);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return numberOfItems;
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return UIEdgeInsetsMake(20, 20, 20, 20); // top, left, bottom, right
    }
    else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return 20.0;
    }
    else{
        return 5.0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(!IS_IPHONE_DEVICE)
    {
        return 23.0;
    }
    else{
        return 10.0;
    }
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayersCell *cell = [self.GridTbl dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    
    if (self.inningsDetailsArray.count == 2) {
        
        cell.firstInningsScoreLbl.hidden = true;
        cell.secondInningsScoreLbl.hidden = true;
        cell.verticalLineLabel.hidden = true;
        cell.inningsScoreLbl.hidden = false;
        
        if (self.indexPath == 0) {
            [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray[indexPath.row] valueForKey:@"BatsmenPhoto"]]]
                                placeholderImage:[UIImage imageNamed:@"Default_image"]];

            cell.inningsScoreLbl.text = [[commonArray valueForKey:@"Runs"] objectAtIndex:indexPath.row];
            cell.playerNameLbl.text = [[commonArray valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row];
        }
        if (self.indexPath == 1) {
            
            [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray[indexPath.row] valueForKey:@"BowlerPhoto"]]]
                         placeholderImage:[UIImage imageNamed:@"Default_image"]];
            NSString *wicketsScore = [NSString stringWithFormat:@"%@/%@", [[commonArray valueForKey:@"Wickets"] objectAtIndex:indexPath.row], [[commonArray valueForKey:@"Runs"] objectAtIndex:indexPath.row]];
            cell.inningsScoreLbl.text = wicketsScore;
            cell.playerNameLbl.text = [[commonArray valueForKey:@"BowlerName"] objectAtIndex:indexPath.row];
        }
    }
    
    if (self.inningsDetailsArray.count == 4) {
        cell.inningsScoreLbl.hidden = true;
        cell.firstInningsScoreLbl.hidden = false;
        cell.secondInningsScoreLbl.hidden = false;
        cell.verticalLineLabel.hidden = false;
        
        if (self.indexPath == 0) { // Batsman
            
            [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray1[indexPath.row] valueForKey:@"BatsmenPhoto"]]]
                                placeholderImage:[UIImage imageNamed:@"Default_image"]];

            cell.playerNameLbl.text = [[commonArray1 valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row] ;
            cell.firstInningsScoreLbl.text = [[commonArray1 valueForKey:@"Runs"] objectAtIndex:indexPath.row];
            
            for (int i = 0; i < commonArray2.count; i++) {
                if ([[[commonArray1 valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row] isEqualToString:[[commonArray2 valueForKey:@"Batsmencode"] objectAtIndex:i]]) {
                    
                    cell.secondInningsScoreLbl.text = [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i];
                    break;
                } else {
                    
                    cell.secondInningsScoreLbl.text = [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i];
                }
            }
        } else if (self.indexPath == 1) { // Bowler
            
            if (![[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row] isEqualToString:@""]) {
                [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray1[indexPath.row] valueForKey:@"BowlerPhoto"]]]
                                    placeholderImage:[UIImage imageNamed:@"Default_image"]];

                cell.playerNameLbl.text = [[commonArray1 valueForKey:@"BowlerName"] objectAtIndex:indexPath.row];
                NSString *wicketsScore = [NSString stringWithFormat:@"%@/%@", [[commonArray1 valueForKey:@"Wickets"] objectAtIndex:indexPath.row], [[commonArray1 valueForKey:@"Runs"] objectAtIndex:indexPath.row]];
                cell.firstInningsScoreLbl.text = wicketsScore;
            } else {
                cell.firstInningsScoreLbl.text = @"DNB";
            }
            
            for (int i = 0; i < commonArray2.count; i++) {
                if ([[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row] isEqualToString:[[commonArray2 valueForKey:@"BowlerCode"] objectAtIndex:i]]) {
                    
                    [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [[commonArray2 valueForKey:@"BowlerPhoto"] objectAtIndex:i]]]
                                        placeholderImage:[UIImage imageNamed:@"Default_image"]];

                    NSLog(@"Name:%d:%@", i, [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i]);
                    cell.playerNameLbl.text = [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i];
                    cell.secondInningsScoreLbl.text = [NSString stringWithFormat:@"%@/%@", [[commonArray2 valueForKey:@"Wickets"] objectAtIndex:i], [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i]];
                    break;
                    
                } else {
                    if (self.BowlingDetailsArray1.count < self.BowlingDetailsArray3.count || self.BowlingDetailsArray2.count < self.BowlingDetailsArray4.count) {
                        [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray2[indexPath.row] valueForKey:@"BowlerPhoto"]]]
                                            placeholderImage:[UIImage imageNamed:@"Default_image"]];

                        NSLog(@"Name:%d:%@", i, [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i]);
                        cell.playerNameLbl.text = [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:indexPath.row];
                        if ([[[commonArray2 valueForKey:@"Runs"] objectAtIndex:indexPath.row] isEqualToString:@""]) {
                            cell.secondInningsScoreLbl.text = @"DNB";
                        } else {
                            cell.secondInningsScoreLbl.text = [NSString stringWithFormat:@"%@/%@", [[commonArray2 valueForKey:@"Wickets"] objectAtIndex:indexPath.row], [[commonArray2 valueForKey:@"Runs"] objectAtIndex:indexPath.row]];
                        }
                        
                    } else {
                        //cell.playerNameLbl.text = [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i];
                        if ([[[commonArray2 valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@""]) {
                            cell.secondInningsScoreLbl.text = @"DNB";
                        } else {
                            cell.secondInningsScoreLbl.text = [NSString stringWithFormat:@"%@/%@", [[commonArray2 valueForKey:@"Wickets"] objectAtIndex:i], [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i]];
                        }
                        
                    }
                }
            }
        }
    }
    if (self.inningsDetailsArray.count == 3)
    {
        cell.inningsScoreLbl.hidden = true;
        cell.firstInningsScoreLbl.hidden = false;
        cell.secondInningsScoreLbl.hidden = false;
        cell.verticalLineLabel.hidden = false;
        
        if (self.indexPath == 0) { // Batsman
            
            [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray1[indexPath.row] valueForKey:@"BatsmenPhoto"]]]
                                placeholderImage:[UIImage imageNamed:@"Default_image"]];
            
            cell.playerNameLbl.text = [[commonArray1 valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row] ;
            cell.firstInningsScoreLbl.text = [[commonArray1 valueForKey:@"Runs"] objectAtIndex:indexPath.row];
            
            for (int i = 0; i < commonArray2.count; i++) {
                if ([[[commonArray1 valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row] isEqualToString:[[commonArray2 valueForKey:@"Batsmencode"] objectAtIndex:i]]) {
                    
                    cell.secondInningsScoreLbl.text = [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i];
                    break;
                } else {
                    
                    cell.secondInningsScoreLbl.text = [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i];
                }
            }
        } else if (self.indexPath == 1) { // Bowler
            
            if (![[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row] isEqualToString:@""]) {
                [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray1[indexPath.row] valueForKey:@"BowlerPhoto"]]]
                                    placeholderImage:[UIImage imageNamed:@"Default_image"]];
                
                cell.playerNameLbl.text = [[commonArray1 valueForKey:@"BowlerName"] objectAtIndex:indexPath.row];
                NSString *wicketsScore = [NSString stringWithFormat:@"%@/%@", [[commonArray1 valueForKey:@"Wickets"] objectAtIndex:indexPath.row], [[commonArray1 valueForKey:@"Runs"] objectAtIndex:indexPath.row]];
                cell.firstInningsScoreLbl.text = wicketsScore;
            } else {
                cell.firstInningsScoreLbl.text = @"DNB";
            }
            
            for (int i = 0; i < commonArray2.count; i++) {
                if ([[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row] isEqualToString:[[commonArray2 valueForKey:@"BowlerCode"] objectAtIndex:i]]) {
                    
                    [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [[commonArray2 valueForKey:@"BowlerPhoto"] objectAtIndex:i]]]
                                        placeholderImage:[UIImage imageNamed:@"Default_image"]];
                    
                    NSLog(@"Name:%d:%@", i, [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i]);
                    cell.playerNameLbl.text = [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i];
                    cell.secondInningsScoreLbl.text = [NSString stringWithFormat:@"%@/%@", [[commonArray2 valueForKey:@"Wickets"] objectAtIndex:i], [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i]];
                    break;
                    
                } else {
                    if (self.BowlingDetailsArray1.count < self.BowlingDetailsArray3.count || self.BowlingDetailsArray2.count < self.BowlingDetailsArray4.count) {
                        [cell.playerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, [commonArray2[indexPath.row] valueForKey:@"BowlerPhoto"]]]
                                            placeholderImage:[UIImage imageNamed:@"Default_image"]];
                        
                        NSLog(@"Name:%d:%@", i, [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i]);
                        cell.playerNameLbl.text = [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:indexPath.row];
                        cell.secondInningsScoreLbl.text = [NSString stringWithFormat:@"%@/%@", [[commonArray2 valueForKey:@"Wickets"] objectAtIndex:indexPath.row], [[commonArray2 valueForKey:@"Runs"] objectAtIndex:indexPath.row]];
                    } else {
                        //cell.playerNameLbl.text = [[commonArray2 valueForKey:@"BowlerName"] objectAtIndex:i];
                        cell.secondInningsScoreLbl.text = [NSString stringWithFormat:@"%@/%@", [[commonArray2 valueForKey:@"Wickets"] objectAtIndex:i], [[commonArray2 valueForKey:@"Runs"] objectAtIndex:i]];
                    }
                }
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.inningsDetailsArray.count == 2)
    {
        if (self.indexPath == 0)
        {
            BattingKPIViewController * objFix = [[BattingKPIViewController alloc]init];
            objFix = (BattingKPIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BattingKPI"];
            objFix.SelectedMatchCode = self.matchcode;
            NSString *btcode = [[commonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
            objFix.SelectedPlayerCode = btcode;
            objFix.SelectedTeamCode = teamcode;
            [self.navigationController pushViewController:objFix animated:YES];
        }

        if (self.indexPath == 1)
        {
            BowlingKPIViewController * objFix = [[BowlingKPIViewController alloc]init];
            objFix = (BowlingKPIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BowlingKPI"];
            objFix.SelectedMatchCode = self.matchcode;
            NSString *btcode = [[commonArray valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }

            objFix.SelectedPlayerCode = btcode;
            objFix.SelectedTeamCode = teamcode;
            [self.navigationController pushViewController:objFix animated:YES];
        }
    }
    if (self.inningsDetailsArray.count == 3)
    {
        if (self.indexPath == 0)
        {
            BattingKPIViewController * objFix = [[BattingKPIViewController alloc]init];
            objFix = (BattingKPIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BattingKPI"];
            objFix.SelectedMatchCode = self.matchcode;
            NSString *btcode = [[commonArray1 valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
            objFix.SelectedPlayerCode = btcode;

            objFix.SelectedTeamCode = teamcode;
            [self.navigationController pushViewController:objFix animated:YES];
        }

        if (self.indexPath == 1)
        {
            BowlingKPIViewController * objFix = [[BowlingKPIViewController alloc]init];
            objFix = (BowlingKPIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BowlingKPI"];
            objFix.SelectedMatchCode = self.matchcode;
            NSString *btcode;
            if (![[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row] isEqualToString:@""]) {
                btcode=[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
            } else {

                btcode=[[commonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
            }

            objFix.SelectedPlayerCode = btcode;
            objFix.SelectedTeamCode = teamcode;
            [self.navigationController pushViewController:objFix animated:YES];
        }
    }

    if (self.inningsDetailsArray.count == 4)
    {
        if (self.indexPath == 0)
        {
            BattingKPIViewController * objFix = [[BattingKPIViewController alloc]init];
            objFix = (BattingKPIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BattingKPI"];
            objFix.SelectedMatchCode = self.matchcode;
            NSString *btcode = [[commonArray1 valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
            objFix.SelectedPlayerCode = btcode;

            objFix.SelectedTeamCode = teamcode;
            [self.navigationController pushViewController:objFix animated:YES];
        }

        if (self.indexPath == 1)
        {
            BowlingKPIViewController * objFix = [[BowlingKPIViewController alloc]init];
            objFix = (BowlingKPIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BowlingKPI"];
            objFix.SelectedMatchCode = self.matchcode;
            NSString *btcode;
            if (![[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row] isEqualToString:@""]) {
                btcode=[[commonArray1 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
            } else {

                btcode=[[commonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
            }

            objFix.SelectedPlayerCode = btcode;
            objFix.SelectedTeamCode = teamcode;
            [self.navigationController pushViewController:objFix animated:YES];
        }
    }
}
- (IBAction)Team1Action:(id)sender {
    
    [self clearBtnSubView:self.team2Btn];
    [self.team1Btn addSubview: [self getLineView:self.team1Btn]];
    
    if (self.inningsDetailsArray.count == 2) {
        commonArray = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            NSLog(@"Team1:0:%@", self.BatsmanDetailsArray1);
            commonArray = self.BatsmanDetailsArray1;
            numberOfItems = (int)self.BatsmanDetailsArray1.count;
            
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
            }
            else
            {
                teamcode = @"TEA0000026";
            }
        }
        
        if (self.indexPath == 1) {
            NSLog(@"Team1:1:%@", self.BowlingDetailsArray1);
            commonArray = self.BowlingDetailsArray1;
            numberOfItems = (int)self.BowlingDetailsArray1.count;
            
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
            }
            else
            {
                teamcode = @"TEA0000026";
            }
        }
    }
    if (self.inningsDetailsArray.count == 4) {
        commonArray1 = [[NSMutableArray alloc] init];
        commonArray2 = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            commonArray1 = BatsmanDetailsArray11;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray33;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
            }
            else
            {
                teamcode = @"TEA0000026";
            }
        } else if (self.indexPath == 1) {
            commonArray1 = BatsmanDetailsArray22;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray44;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
            }
            else
            {
                teamcode = @"TEA0000026";
            }
        }
    }
    
    if (self.inningsDetailsArray.count == 3) {
        commonArray1 = [[NSMutableArray alloc] init];
        commonArray2 = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            commonArray1 = BatsmanDetailsArray11;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray33;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
            }
            else
            {
                teamcode = @"TEA0000026";
            }
        } else if (self.indexPath == 1) {
            commonArray1 = BatsmanDetailsArray22;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray44;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team1Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
            }
            else
            {
                teamcode = @"TEA0000026";
            }
        }
    }

    
    [self.GridTbl reloadData];
}
- (IBAction)Team2Action:(id)sender {
    
    [self clearBtnSubView:self.team1Btn];
    [self.team2Btn addSubview: [self getLineView:self.team2Btn]];
    
    NSLog(@"Current Title Team2:%@", self.team2Btn.currentTitle);
    if (self.inningsDetailsArray.count == 2) {
        commonArray = [[NSMutableArray alloc] init];
        if (self.indexPath == 0) {
            commonArray = self.BatsmanDetailsArray2;
            numberOfItems = (int)self.BatsmanDetailsArray2.count;
            
            if ([self.team2Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }
        }
        if (self.indexPath == 1) {
            commonArray = self.BowlingDetailsArray2;
            numberOfItems = (int)self.BowlingDetailsArray2.count;
            
            if ([self.team2Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }
        }
    }
    if (self.inningsDetailsArray.count == 4) {
        commonArray1 = [[NSMutableArray alloc] init];
        commonArray2 = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            commonArray1 = BatsmanDetailsArray22;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray44;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team2Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }
        } else if(self.indexPath == 1) {
            commonArray1 = BatsmanDetailsArray11;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray33;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team2Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }
        }
    }
    
    if (self.inningsDetailsArray.count == 3) {
        commonArray1 = [[NSMutableArray alloc] init];
        commonArray2 = [[NSMutableArray alloc] init];
        
        if (self.indexPath == 0) {
            commonArray1 = BatsmanDetailsArray22;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray44;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team2Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }
        } else if(self.indexPath == 1) {
            commonArray1 = BatsmanDetailsArray11;
            NSLog(@"commonArray1:%@", commonArray1);
            commonArray2 = BatsmanDetailsArray33;
            NSLog(@"commonArray2:%@", commonArray2);
            numberOfItems = (int)commonArray2.count;
            if ([self.team2Btn.currentTitle isEqualToString:@"India"])
            {
                teamcode = @"TEA0000018";
                //objFix.SelectedTeamCode = teamcode;
            }
            else
            {
                teamcode = @"TEA0000026";
                //objFix.SelectedTeamCode = teamcode;
            }
        }
    }
    
    [self.GridTbl reloadData];
}

-(UIView *) getLineView : (UIButton *) btn{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height+5, btn.frame.size.width, 5)];
    lineView.backgroundColor =[UIColor colorWithRed:16.0f/255.0f
                                              green:45.0f/255.0f
                                               blue:125.0f/255.0f
                                              alpha:1.0f];
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

@end

