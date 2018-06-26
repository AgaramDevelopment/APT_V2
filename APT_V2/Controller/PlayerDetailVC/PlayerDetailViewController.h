//
//  PlayerDetailViewController.h
//  APT_V2
//
//  Created by user on 21/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface PlayerDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;

@property (strong, readwrite) NSString* PlayerCode;
@property (strong, readwrite) NSString* athletCode;

@property (strong, readwrite) NSString* PlayerAge;
@property (strong, readwrite) NSString* TeamName;
@property (strong, readwrite) NSString* TeamCode;
@property (strong, readwrite) NSString* PlaerDesignation;

@property (strong, nonatomic) UIColor* availableColor;
@property (strong, nonatomic) NSMutableArray* selectedPlayerArray;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPlayer;
@property (weak, nonatomic) IBOutlet UILabel *lblTeamName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayerType;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayerAge;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailability;

@property (weak, nonatomic) IBOutlet UITableView *tblRecentPerformance;
@property (weak, nonatomic) IBOutlet UITableView *tblHistory;
@property (weak, nonatomic) IBOutlet LineTextField *txtTestDate;
@property (weak, nonatomic) IBOutlet RadarChartView *spiderChartView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl2Height;
@property (weak, nonatomic) IBOutlet UILabel *lblNoHistory;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecentPerformance;
@property (strong, nonatomic) IBOutlet UITableViewController *tblpopup;
- (IBAction)actionpopup:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblDateDropDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableWidth;

- (IBAction)playerMultiActions:(id)sender;

@end
