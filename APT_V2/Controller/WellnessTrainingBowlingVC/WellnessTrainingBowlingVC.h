//
//  WellnessTrainingBowlingVC.h
//  APT_V2
//
//  Created by Apple on 07/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;


@interface WellnessTrainingBowlingVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *commonView;
@property (strong, nonatomic) IBOutlet UIView *trainingview;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic) IBOutlet UIView *bowlingLoadView;

@property (strong, nonatomic) IBOutlet UILabel *bodyWeightlbl;
@property (strong, nonatomic) IBOutlet UILabel *sleepHrlbl;
@property (strong, nonatomic) IBOutlet UILabel *ratinglbl;

@property (strong, nonatomic) IBOutlet UILabel *sleeplbl;
@property (strong, nonatomic) IBOutlet UILabel *fatiquelbl;
@property (strong, nonatomic) IBOutlet UILabel *musclelbl;
@property (strong, nonatomic) IBOutlet UILabel *stresslbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *traingViewHeight;



@property (strong, nonatomic) IBOutlet UIView *SleepColorView;
@property (strong, nonatomic) IBOutlet UIView *FatiqueColorView;
@property (strong, nonatomic) IBOutlet UIView *MuscleColorView;
@property (strong, nonatomic) IBOutlet UIView *StressColorView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topviewHeight;

-(BOOL)setHeight;

@property (strong, nonatomic) IBOutlet UIView *RootTrainingView;
@property (strong, nonatomic) IBOutlet UIButton *fetchButton;

@property (strong, nonatomic) IBOutlet UIButton *AddTrainingBtn;


//traing Load

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

@property (strong, nonatomic) IBOutlet UIButton *AddBtn;

@property (strong, nonatomic) IBOutlet UIButton *BowlingMonthlyBtn;
@property (strong, nonatomic) IBOutlet UIButton *BowlingWeeklyBtn;
@property (strong, nonatomic) IBOutlet UIButton *BowlingDailyBtn;


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

-(void)reloaddataVC;

@end
