//
//  MCBattingRootVC.h
//  APT_V2
//
//  Created by apple on 19/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCBattingRootVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *battingBtn;
@property (strong, nonatomic) IBOutlet UIButton *overViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *overBlockBtn;
@property (strong, nonatomic) IBOutlet UIView *headderView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedTab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selctedTabLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedTabWidth;

@end
