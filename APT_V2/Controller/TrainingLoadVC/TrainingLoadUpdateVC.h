//
//  TrainingLoadUpdateVC.h
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTraingDelegate <NSObject>

-(void)closeUpdateTrainingSource;

@end


@interface TrainingLoadUpdateVC : UIViewController
{
    NSMutableArray *sessionArray;
    NSMutableArray *activityArray;
    NSMutableArray *valueArray;
}
@property (strong,nonatomic) id<AddTraingDelegate> Delegate;
@property (strong, nonatomic) IBOutlet UIButton *sessionBtn;
@property (strong, nonatomic) IBOutlet UIButton *ActivityBtn;
@property (strong, nonatomic) IBOutlet UIButton *UpdateBtn;

@property (strong, nonatomic) IBOutlet UIButton *SaveBtn;
@property (strong, nonatomic) IBOutlet UIButton *FetchedUpdateBtn;

@property (strong, nonatomic) IBOutlet UIView *countview;

@property (strong, nonatomic) IBOutlet UIView *ActivityFilterview;
@property (strong, nonatomic) IBOutlet UIView *RpeFilterview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *RpeFilterviewWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *countViewWidth;
@property (strong, nonatomic) IBOutlet UIView *todayMainView;

@property (strong, nonatomic) IBOutlet UIView *ballsView;
@property (strong, nonatomic) IBOutlet UILabel *bowledlblname;

    //Donar Charts
@property (strong, nonatomic) IBOutlet NSMutableArray *markers;


@property (strong, nonatomic) IBOutlet UITableView *popViewtable;
@property (strong, nonatomic) IBOutlet UITableView *SessionTable;
@property (strong, nonatomic) IBOutlet UILabel *activitylbl;
@property (strong, nonatomic) IBOutlet UILabel *rpelbl;
@property (strong, nonatomic) IBOutlet UITextField *timelbl;
@property (strong, nonatomic) IBOutlet UITextField *ballslbl;

@property (strong, nonatomic) IBOutlet UILabel *totalCountlbl;
@property (strong, nonatomic) IBOutlet UILabel *datelbl;

@property (strong,nonatomic) IBOutlet UIView * view_datepicker;

@property (strong,nonatomic)  NSMutableArray * TodayLoadArray;
@property (strong,nonatomic)  NSMutableArray * YesterdayLoadArray;
@property (strong,nonatomic)  NSString * isToday;
@property (strong,nonatomic)  NSString * isYesterday;
@property (strong,nonatomic)  NSString * isfromHome;

@property (strong, nonatomic) IBOutlet UIView *tapView;

@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeight;

@property (strong, nonatomic) IBOutlet UIButton *CancelBtn;
@property (strong, nonatomic) IBOutlet UIImageView *CancelImg;

@end
