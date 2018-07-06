//
//  ScheduleVC.h
//  APT_V2
//
//  Created by MAC on 06/07/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *timeTF;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UITableView *scheduleTableView;
@property (strong, nonatomic) IBOutlet UITableView *schedSelectedTableView;
@property (strong, nonatomic) IBOutlet UIView *dropView;
@property (strong, nonatomic) IBOutlet UITableView *plansTableView;
@property (strong, nonatomic) IBOutlet UITextField *planTextField;
@property (strong, nonatomic) IBOutlet UITableView *savedTableView;

@end
