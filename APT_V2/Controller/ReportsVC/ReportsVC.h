//
//  ReportsVC.h
//  APT_V2
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface ReportsVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *navi_View;

@property (strong, nonatomic) IBOutlet UIView *RecentFitnessView;
@property (strong, nonatomic) IBOutlet UIView *TraingLoadView;
@property (strong, nonatomic) IBOutlet UIView *BowlingLoadView;

@property (strong, nonatomic) IBOutlet UIButton *MonthlyBtn;
@property (strong, nonatomic) IBOutlet UIButton *WeeklyBtn;
@property (strong, nonatomic) IBOutlet UIButton *DailyBtn;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
