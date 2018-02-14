//
//  TrainingLoadUpdateVC.h
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingLoadUpdateVC : UIViewController
{
    NSMutableArray *sessionArray;
    NSMutableArray *activityArray;
    NSMutableArray *valueArray;
}
@property (strong, nonatomic) IBOutlet UIButton *sessionBtn;
@property (strong, nonatomic) IBOutlet UIButton *ActivityBtn;
@property (strong, nonatomic) IBOutlet UIButton *UpdateBtn;

@property (strong, nonatomic) IBOutlet UIView *countview;

@property (strong, nonatomic) IBOutlet UIView *ActivityFilterview;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countViewWidth;
@property (strong, nonatomic) IBOutlet UIView *todayMainView;

    //Donar Charts
@property (strong, nonatomic) IBOutlet NSMutableArray *markers;


@property (strong, nonatomic) IBOutlet UITableView *popViewtable;
@property (strong, nonatomic) IBOutlet UITableView *SessionTable;
@property (strong, nonatomic) IBOutlet UILabel *activitylbl;
@property (strong, nonatomic) IBOutlet UITextField *rpelbl;
@property (strong, nonatomic) IBOutlet UITextField *timelbl;
@property (strong, nonatomic) IBOutlet UITextField *ballslbl;

@property (strong, nonatomic) IBOutlet UILabel *totalCountlbl;
@property (strong, nonatomic) IBOutlet UILabel *datelbl;

@property (strong,nonatomic) IBOutlet UIView * view_datepicker;

@end
