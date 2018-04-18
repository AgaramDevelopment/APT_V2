//
//  GroundVC.h
//  APT_V2
//
//  Created by Apple on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"
#import "BowlTypeCell.h"
@import Charts;

@interface GroundVC : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *ColorView;
@property (strong, nonatomic) IBOutlet UICollectionView *resultCollectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIView *barchart;
@property (strong, nonatomic) IBOutlet UIView *reqBarChartView;


@property (strong, nonatomic) IBOutlet UITableView *BowlTypeTbl;

@property (nonatomic,strong) IBOutlet BowlTypeCell *objCell;

//Batting 1st Label Properties
@property (strong, nonatomic) IBOutlet UILabel *BFAvgWinScoreLbl;
@property (strong, nonatomic) IBOutlet UILabel *BFHighScore;
@property (strong, nonatomic) IBOutlet UILabel *BFAvgScore;
@property (strong, nonatomic) IBOutlet UILabel *BFLowScore;
//Batting 2nd Label Properties
@property (strong, nonatomic) IBOutlet UILabel *BSAvgWinScoreLbl;
@property (strong, nonatomic) IBOutlet UILabel *BSHighScore;
@property (strong, nonatomic) IBOutlet UILabel *BSAvgScore;
@property (strong, nonatomic) IBOutlet UILabel *BSLowScore;


//Over Block 1-6 Label Properties
@property (strong, nonatomic) IBOutlet UIButton *innings1Btn;
@property (strong, nonatomic) IBOutlet UIButton *innings2Btn;

@property (strong, nonatomic) IBOutlet UILabel *OBAvgWinScore;
@property (strong, nonatomic) IBOutlet UILabel *OBHighScore;
@property (strong, nonatomic) IBOutlet UILabel *OBAvgScore;
@property (strong, nonatomic) IBOutlet UILabel *OBLowScore;

//Toss Won Label Properties
@property (strong, nonatomic) IBOutlet UILabel *battingFirstMatchWonLbl;
@property (strong, nonatomic) IBOutlet UILabel *battingFirstMatchLostLbl;
@property (strong, nonatomic) IBOutlet UILabel *battingSecondMatchWonLbl;
@property (strong, nonatomic) IBOutlet UILabel *battingSecondMatchLostLbl;
@property (strong, nonatomic) IBOutlet UIImageView *wagonImage;

    //wagon
@property (nonatomic,strong) NSMutableArray * wagonWheelDrawData;
@property (strong, nonatomic) IBOutlet UITableView *competitionTeamCodesTblView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableYPosition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableXPosition;
@property (strong, nonatomic) IBOutlet UIView *competitionView;
@property (strong, nonatomic) IBOutlet UIView *teamView;
@property (nonatomic,strong) NSMutableArray * codeArray;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableWidth;
@property (strong, nonatomic) IBOutlet UITextField *competitionCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *teamCodeTF;

@property (strong, nonatomic) IBOutlet UILabel *groundTopLeft;
@property (strong, nonatomic) IBOutlet UILabel *groundTopRight;
@property (strong, nonatomic) IBOutlet UILabel *groundBottomLeft;
@property (strong, nonatomic) IBOutlet UILabel *groundBottomRight;
@property (strong, nonatomic) IBOutlet UILabel *groundRight;
@property (strong, nonatomic) IBOutlet UILabel *groundLight;
@property (strong, nonatomic) IBOutlet UIView *groundView;
@property (strong, nonatomic) IBOutlet UILabel *groundLbl;
@property (strong, nonatomic) IBOutlet UILabel *homeGroundLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *Titlecollview;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *overBlockbtn;

@property (weak, nonatomic) IBOutlet UILabel *lbl2ndBattingTot;
@property (weak, nonatomic) IBOutlet UILabel *lbl1stBattingTot;

@end
