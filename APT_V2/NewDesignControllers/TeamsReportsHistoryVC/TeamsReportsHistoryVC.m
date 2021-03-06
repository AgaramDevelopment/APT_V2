//
//  TeamsReportsHistoryVC.m
//  APT_V2
//
//  Created by Apple on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TeamsReportsHistoryVC.h"
#import "Config.h"
#import "AppCommon.h"
#import "TabHomeCell.h"
#import "SchResStandVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "WellnessTrainingBowlingVC.h"
#import "VideoGalleryVC.h"
#import "HomeScreenStandingsVC.h"
#import "SwipeView.h"
#import "MyStatsBattingVC.h"
#import "TeamMembersVC.h"
#import "PopOverVC.h"
#import "TeamsVC.h"
#import "ReportsVC.h"
#import "HistoryVC.h"

@interface TeamsReportsHistoryVC ()
{
    NSIndexPath* selectedIndex;
    NSArray *titleArray;
    TeamMembersVC *objteam;
    ReportsVC *objrep;
    CustomNavigation *objCustomNavigation;
    HistoryVC *objhis;
}

@end

@implementation TeamsReportsHistoryVC
@synthesize teamCode;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     [self.Titlecollview registerNib:[UINib nibWithNibName:@"TabHomeCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    objteam = [[TeamMembersVC alloc] initWithNibName:@"TeamMembersVC" bundle:nil];
    objteam.teamCode = teamCode;
    objrep = [[ReportsVC alloc] initWithNibName:@"ReportsVC" bundle:nil];
    objhis = [[HistoryVC alloc] initWithNibName:@"HistoryVC" bundle:nil];
    selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    
    if([AppCommon isCoach])
    {
        titleArray = @[@"Players",@"Reports",@"History"];

    }else
    {
        titleArray = @[@"Reports",@"History"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customnavigationmethod];

}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [self.navi_View addSubview:objCustomNavigation.view];
    
    
    objCustomNavigation.btn_back.hidden = !self.isBackBtnEnable;
    objCustomNavigation.menu_btn.hidden = self.isBackBtnEnable;
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.btn_back addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.notificationBtn addTarget:self action:@selector(didClickNotificationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backButton{
    
    [appDel.frontNavigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.commonArray.count;
    
    return titleArray.count;
}

#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![AppCommon isCoach])
    {
        CGFloat widthF = self.Titlecollview.superview.frame.size.width/2;
        CGFloat HeightF = self.Titlecollview.superview.frame.size.height;
        
        return CGSizeMake(widthF, HeightF);
    }
    else
    {
    CGFloat widthF = self.Titlecollview.superview.frame.size.width/3;
    CGFloat HeightF = self.Titlecollview.superview.frame.size.height;
    
    return CGSizeMake(widthF, HeightF);
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TabHomeCell* cell = [self.Titlecollview dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.Title.text = titleArray[indexPath.row];
    [cell setTag:indexPath.row];
    
    if (indexPath == selectedIndex) {
        cell.selectedLineView.backgroundColor = [UIColor colorWithRed:(37/255.0f) green:(176/255.0f) blue:(240/255.0f) alpha:1.0f];
    }
    else {
        cell.selectedLineView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.swipeView scrollToItemAtIndex:indexPath.item duration:0.2];
}
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return titleArray.count;
}

//- (void)swipeViewDidScroll:(__unused SwipeView *)swipeView {}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if([AppCommon isCoach])
    {
        if(index == 0)
        {
//            objteam.view.frame = CGRectMake(0, 0, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height);
//            objteam.naviHeight.constant = 0;
//            objteam.navi_View.hidden = YES;
            
            objteam.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+70);
            [view addSubview:objteam.view];
        }
        else if(index == 1)
        {
            objrep.selectionBaseKey = @"reportselected";
            objrep.view.frame = CGRectMake(0, 0, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height);
            objrep.naviHeight.constant = 0;
            objrep.navi_View.hidden = YES;
            [view addSubview:objrep.view];
        }
        else if(index == 2)
        {
            objhis.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+70);
            [view addSubview:objhis.view];
            
        }

    }
    else
    {
        if(index == 0)
        {
            
            objrep.view.frame = CGRectMake(0, 0, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height);
            objrep.naviHeight.constant = 0;
            objrep.navi_View.hidden = YES;
            [view addSubview:objrep.view];
            
        }
        else if(index == 1)
        {
            objhis.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height);
            [view addSubview:objhis.view];
            
        }
    }
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    selectedIndex = [NSIndexPath indexPathForItem:swipeView.currentItemIndex inSection:0];
    if(selectedIndex == 1)
    {
        [self.swipeView setScrollEnabled:NO];
    }
    [self.Titlecollview reloadData];
    
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    // self.page_control.currentPage = self.swipeView.currentItemIndex;
    
    selectedIndex = [NSIndexPath indexPathForItem:swipeView.currentItemIndex inSection:0];
    if(selectedIndex ==2)
    {
        [self.swipeView setScrollEnabled:NO];
    }
    [self.Titlecollview reloadData];
}


@end
