//
//  PlannerVC.h
//  AlphaProTracker
//
//  Created by Mac on 28/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFCalendarViewControllerProtocol <NSObject>
@required
- (void)arrayUpdatedWithAllEvents:(NSMutableArray *)arrayUpdated;
@end

@interface PlannerVC : UIViewController

@property (nonatomic, strong) id <FFCalendarViewControllerProtocol> protocol;
@property (nonatomic, strong) NSMutableArray *arrayWithEvents;
@property (nonatomic, strong)IBOutlet UIButton *WEEK;
@property (nonatomic, strong)IBOutlet UIButton *DAY;
@property (nonatomic, strong)IBOutlet UIButton *MONTH;
@property (nonatomic, strong)IBOutlet UILabel *nameOfMonth;
@property (nonatomic, copy, readwrite) NSDate *reqDate;
@property (nonatomic, strong) NSString *checkBacknavi;
@property (weak, nonatomic) IBOutlet UIView *calendarView;

@property (strong, nonatomic) IBOutlet UIView *navi_View;

@property (weak, nonatomic) IBOutlet UIView *tapview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plannerTblHeight;

@end
