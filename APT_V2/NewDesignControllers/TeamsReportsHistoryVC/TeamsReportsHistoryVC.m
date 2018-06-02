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

@interface TeamsReportsHistoryVC ()
{
    NSIndexPath* selectedIndex;
    NSArray *titleArray;
}

@end

@implementation TeamsReportsHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    
    titleArray = @[@"Home",([AppCommon isCoach] ? @"My Teams" : @"Wellness/Training/Bowling")];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.commonArray.count;
    
    return 2;
}

#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat widthF = self.Titlecollview.superview.frame.size.width/2;
    CGFloat HeightF = self.Titlecollview.superview.frame.size.height;
    
    return CGSizeMake(widthF, HeightF);
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
    
    if(index == 0)
    {
//        objSch.view.frame = CGRectMake(0, 0, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height);
//        [view addSubview:objSch.view];
        
    }
    
    else if(index == 1)
    {
        //            if ([AppCommon isCoach]) {
        //                CGFloat Yposition = objPlayersVC.filterContainerView.frame.origin.y;
        //                objPlayersVC.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+70);
        //                [view addSubview:objPlayersVC.view];
        //            }
        //            else
        //            {
        //                objStats.view.frame = CGRectMake(0, -75, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+75);
        //                [view addSubview:objStats.view];
        //            }
        //CGFloat Yposition = objWell.filterContainerView.frame.origin.y;
//        objWell.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+70);
//        
//        [view addSubview:objWell.view];
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
    if(selectedIndex ==1)
    {
        [self.swipeView setScrollEnabled:NO];
    }
    [self.Titlecollview reloadData];
    
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    // self.page_control.currentPage = self.swipeView.currentItemIndex;
    
    selectedIndex = [NSIndexPath indexPathForItem:swipeView.currentItemIndex inSection:0];
    if(selectedIndex ==1)
    {
        [self.swipeView setScrollEnabled:NO];
    }
    [self.Titlecollview reloadData];
}


@end
