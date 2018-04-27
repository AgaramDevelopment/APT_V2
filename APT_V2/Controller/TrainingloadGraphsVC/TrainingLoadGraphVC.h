//
//  TrainingLoadGraphVC.h
//  APT_V2
//
//  Created by Apple on 19/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface TrainingLoadGraphVC : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *BackBtn;
@property (nonatomic, strong) IBOutlet UITableView *PoplistTable;

@property (nonatomic, strong)  NSMutableArray *ActivityArray;

@property (nonatomic, strong) IBOutlet UIView *barfilterView;
@property (nonatomic, strong) IBOutlet UIView *linefilterView;
@property (nonatomic, strong) IBOutlet UIView *navigationView;

@property (nonatomic, strong) IBOutlet UILabel *linefilterlbl;
@property (nonatomic, strong) IBOutlet UILabel *barfilterlbl;

@property (nonatomic, strong) IBOutlet UIButton *DailyBtn;
@property (nonatomic, strong) IBOutlet UIButton *WeeklyBtn;
@property (nonatomic, strong) IBOutlet UIButton *MonthlyBtn;
@end
