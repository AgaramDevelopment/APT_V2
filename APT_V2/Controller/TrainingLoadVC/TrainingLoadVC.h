//
//  TrainingLoadVC.h
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrainingLoadVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *yesterdayView;
@property (strong, nonatomic) IBOutlet UIView *todayView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yesterdayViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yesterdayViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *todayViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *todayViewHeight;

@property (strong, nonatomic) IBOutlet UIView *yesterdayMainView;
@property (strong, nonatomic) IBOutlet UIView *todayMainView;
@property (weak, nonatomic) IBOutlet UIView *traingView;

//Donar Charts
@property (strong, nonatomic) IBOutlet NSMutableArray *markers;
@property (strong, nonatomic) IBOutlet NSMutableArray *markers2;

@property (strong, nonatomic) IBOutlet UIButton *AddBtn;


@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl1;
@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl2;
@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl3;
@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl4;
@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl5;
@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl6;
@property (weak, nonatomic) IBOutlet UILabel *todayActivitynamelbl7;

@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl1;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl2;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl3;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl4;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl5;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl6;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayActivitynamelbl7;

@property (weak, nonatomic) IBOutlet UILabel *totalCountToday;
@property (weak, nonatomic) IBOutlet UILabel *totalCountYesterday;

-(void)reloadPiechartData;

@end
