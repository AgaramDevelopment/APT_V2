//
//  SessionSummaryVC.h
//  NewSportsProject
//
//  Created by Mac on 28/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDayCell.h"

@interface SessionSummaryVC : UIViewController

@property (nonatomic,strong) IBOutlet UITableView * dayTbl;
@property (strong, nonatomic) IBOutlet UIView *navi_View;
@property (nonatomic,strong) IBOutlet UITableView * partnrshpTbl;

@property (nonatomic,strong) IBOutlet UIButton * day1;
@property (nonatomic,strong) IBOutlet UIButton * day2;
@property (nonatomic,strong) IBOutlet UIButton * day3;
@property (nonatomic,strong) IBOutlet UIButton * day4;
@property (nonatomic,strong) IBOutlet UIButton * day5;


@property (nonatomic,strong) IBOutlet UIButton * Innings1;
@property (nonatomic,strong) IBOutlet UIButton * Innings2;

@property (nonatomic,strong) IBOutlet UIView * ODIview;
@property (nonatomic,strong) IBOutlet UIView * TESTview;

@property (nonatomic,strong) IBOutlet UIView * SessionsView;


@property (nonatomic,strong) IBOutlet UIButton * session1;
@property (nonatomic,strong) IBOutlet UIButton * session2;
@property (nonatomic,strong) IBOutlet UIButton * session3;


@property (nonatomic,strong)  NSString * matchcode;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic,strong)  NSString * matchHeadding;


@property (nonatomic,strong) IBOutlet UIProgressView * OvrPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * OvrPrgSpin;
@property (nonatomic,strong) IBOutlet UIProgressView * RunsPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * RunsPrgSpin;
@property (nonatomic,strong) IBOutlet UIProgressView * WktsPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * WktsPrgSpin;
@property (nonatomic,strong) IBOutlet UIProgressView * MdnsPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * MdnsPrgSpin;
@property (nonatomic,strong) IBOutlet UIProgressView * StrPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * StrPrgSpin;
@property (nonatomic,strong) IBOutlet UIProgressView * AvgPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * AvgPrgSpin;
@property (nonatomic,strong) IBOutlet UIProgressView * EconPrgPace;
@property (nonatomic,strong) IBOutlet UIProgressView * EconPrgSpin;



@property (nonatomic,strong) IBOutlet UILabel * OversPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * OversSpinlbl;

@property (nonatomic,strong) IBOutlet UILabel * RunsPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * RunsSpinlbl;

@property (nonatomic,strong) IBOutlet UILabel * WktsPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * WktsSpinlbl;

@property (nonatomic,strong) IBOutlet UILabel * MdnsPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * MdnsSpinlbl;

@property (nonatomic,strong) IBOutlet UILabel * StrPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * StrSpinlbl;

@property (nonatomic,strong) IBOutlet UILabel * AvgPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * AvgSpinlbl;

@property (nonatomic,strong) IBOutlet UILabel * EconPacelbl;
@property (nonatomic,strong) IBOutlet UILabel * EconSpinlbl;
@property (nonatomic,strong) IBOutlet UIScrollView * scrollView;

@end
