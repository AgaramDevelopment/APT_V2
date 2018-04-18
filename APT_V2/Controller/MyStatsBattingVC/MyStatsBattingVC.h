//
//  MyStatsBattingVC.h
//  APT_V2
//
//  Created by MAC on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStatsBattingCell.h"
@interface MyStatsBattingVC : UIViewController
{
    NSMutableArray *battingOverAllArray;
    NSMutableArray *bowlingOverAllArray;
    NSMutableArray *overAllArray;
    
    NSMutableArray *battingRecentMatchesArray;
    NSMutableArray *bowlingRecentMatchesArray;
    NSMutableArray *recentMatchesArray;
    
    NSMutableArray *battingmatchDetailsArray;
    NSMutableArray *bowlingmatchDetailsArray;
    NSMutableArray *matchDetailsArray;
    
    NSMutableArray *battingWagonWheelDrawData;
    NSMutableArray *bowlingWagonWheelDrawData;
    
    NSMutableArray *battingPitchData;
    NSMutableArray *bowlingPitchData;
}

@property (assign, nonatomic) NSIndexPath *selectedRowIndex;
@property (strong, nonatomic) IBOutlet UITableView *batttingTableView;
@property (nonatomic,strong) IBOutlet MyStatsBattingCell * StatsBattingCell;
@property (nonatomic,strong) IBOutlet MyStatsBattingCell * StatsBattingCellIphone;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIButton *battingBtn;
@property (strong, nonatomic) IBOutlet UIButton *bowlingBtn;
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (weak, nonatomic) IBOutlet UIView *myStats;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myStatsViewHeight;

@property (weak, nonatomic) IBOutlet UIView *mainContentview;

@property (nonatomic,strong) NSString *selectRuns;
    //wagon
@property (nonatomic,strong) NSMutableArray * wagonWheelDrawData;
    //pitch
@property (nonatomic,strong) NSMutableArray * pitchData;

@property (strong,nonatomic) NSString* selectedPlayerCode;
@property (strong,nonatomic) NSString* selectedPlayerName;
@property (strong,nonatomic)IBOutlet UILabel* PlayerNamelbl;

@end
