//
//  TeamsReportsHistoryVC.h
//  APT_V2
//
//  Created by Apple on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "TeamMembersVC.h"

@interface TeamsReportsHistoryVC : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *Titlecollview;
@property (strong, nonatomic) IBOutlet UIView *navi_View;
@property (strong, nonnull) NSString* teamCode;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property BOOL isBackBtnEnable;


@end
