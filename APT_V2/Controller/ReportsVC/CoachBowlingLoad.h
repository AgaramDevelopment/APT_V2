//
//  CoachBowlingLoad.h
//  APT_V2
//
//  Created by Apple on 22/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachBowlingLoad : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *MonthlyBtn;
@property (strong, nonatomic) IBOutlet UIButton *WeeklyBtn;
@property (strong, nonatomic) IBOutlet UIButton *DailyBtn;
@property (strong, nonatomic)  NSString *selectionBaseKey;


@end
