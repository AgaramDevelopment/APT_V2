//
//  ScoreCardVC.h
//  NewSportsProject
//
//  Created by Mac on 30/11/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PlayerStatsListViewCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScoreCardVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *navi_View;
@property (nonatomic,strong) IBOutlet UIImageView * ww;
@property (nonatomic,strong) IBOutlet UIButton * Team1;
@property (nonatomic,strong) IBOutlet UIButton * Team2;

@property (nonatomic,strong) IBOutlet UIButton * StickyTeam1;
@property (nonatomic,strong) IBOutlet UIButton * StickyTeam2;
@property (nonatomic,strong) IBOutlet UIView * StickyView;

@property (nonatomic,strong) IBOutlet UIView * StickyBattingHeader;
@property (nonatomic,strong) IBOutlet UIView * StickyBowlingHeader;
@property (nonatomic,strong) IBOutlet UIView * StickyFallofWktsHeader;

@property (nonatomic,strong) IBOutlet UIButton * Team3;
@property (nonatomic,strong) IBOutlet UIButton * Team4;



@property (nonatomic,strong) IBOutlet UIButton * Inn1;
@property (nonatomic,strong) IBOutlet UIButton * Inn2;
@property (nonatomic,strong) IBOutlet UIButton * Inn3;
@property (nonatomic,strong) IBOutlet UIButton * Inn4;


@property (nonatomic,strong) IBOutlet UIButton * ExtrasBtn;


@property (nonatomic,strong) IBOutlet UIScrollView * commonScroll;

@property (nonatomic,strong) IBOutlet UITableView * popTbl;
@property (nonatomic,strong) IBOutlet UITableView * listTbl;
@property (nonatomic,strong) IBOutlet UITableView * bowlingTbl;

@property (nonatomic,strong) IBOutlet UIView * containerUIView;
@property (nonatomic,strong) IBOutlet UIView * teamsUIView;
@property (nonatomic,strong) IBOutlet UIView * headerUIView;
@property (nonatomic,strong) IBOutlet UIView * headerUIViewTestmatch;

@property (nonatomic,strong) IBOutlet UIView * FallofwktsUIView;
@property (nonatomic,strong) IBOutlet UIView * BowlingUIView;



@property (nonatomic,strong)  NSString * matchCode;
@property (nonatomic,strong)  NSString * backkey;
@property (nonatomic,strong)  NSMutableArray * matchDetails;



@property (nonatomic,strong) IBOutlet UILabel * competitionTypelbl;
@property (nonatomic,strong) IBOutlet UILabel * groundlbl;
@property (nonatomic,strong) IBOutlet UILabel * teamAlbl;
@property (nonatomic,strong) IBOutlet UILabel * teamBlbl;
@property (nonatomic,strong) IBOutlet UILabel * teamAScorelbl;
@property (nonatomic,strong) IBOutlet UILabel * teamBScorelbl;
@property (nonatomic,strong) IBOutlet UILabel * teamAinn2Scorelbl;
@property (nonatomic,strong) IBOutlet UILabel * teamBinn2Scorelbl;
@property (nonatomic,strong) IBOutlet UILabel * resultlbl;

@property (nonatomic,strong) IBOutlet UILabel * didNotbatlbl;
@property (nonatomic,strong) IBOutlet UILabel * extraslbl;
@property (nonatomic,strong) IBOutlet UILabel * extrastypelbl;
@property (nonatomic,strong) IBOutlet UILabel * fallofWicketslbl;
@property (nonatomic,strong) IBOutlet UILabel * totallbl;
@property (nonatomic,strong) IBOutlet UILabel * wktsOverslbl;

@property (nonatomic,strong) IBOutlet UIImageView * teamAlogo;
@property (nonatomic,strong) IBOutlet UIImageView * teamBlogo;



@property (nonatomic,strong) NSString *selectRegionCode;
@property (nonatomic,strong) NSString *selectRuns;
@property (nonatomic,strong) NSString *selectBattingStyle;
@property (nonatomic,strong) NSString *sectorrr;

@property (strong, nonatomic) IBOutlet UILabel *lbl_striker;
@property (strong,nonatomic) AVPlayerViewController *avPlayerViewController;
@property (strong,nonatomic) AVPlayer *avPlayer;


@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *rootVideoView;
@property (strong, nonatomic) IBOutlet UICollectionView *ballsColView;

//Batting Header Properties Labels
@property (strong, nonatomic) IBOutlet UILabel *battingLabel;
@property (strong, nonatomic) IBOutlet UILabel *battingRunsLbl;
@property (strong, nonatomic) IBOutlet UILabel *ballsLbl;
@property (strong, nonatomic) IBOutlet UILabel *foursLbl;
@property (strong, nonatomic) IBOutlet UILabel *sixsLbl;
@property (strong, nonatomic) IBOutlet UILabel *strikeRateLbl;
@property (strong, nonatomic) IBOutlet UILabel *battingDotBallsLbl;

//Sticky Batting Header Properties Labels
@property (strong, nonatomic) IBOutlet UILabel *stickyBattingLabel;
@property (strong, nonatomic) IBOutlet UILabel *stickyBattingRunsLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyBallsLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyFoursLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickySixsLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyStrikeRateLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyBattingDotBallsLbl;

//Batting Header Properties Labels
@property (strong, nonatomic) IBOutlet UILabel *bowlingLbl;
@property (strong, nonatomic) IBOutlet UILabel *oversLbl;
@property (strong, nonatomic) IBOutlet UILabel *bowlingRunsLbl;
@property (strong, nonatomic) IBOutlet UILabel *wicketsLbl;
@property (strong, nonatomic) IBOutlet UILabel *economyLbl;
@property (strong, nonatomic) IBOutlet UILabel *bowlingDotBallsLbl;

    //Sticky Batting Header Properties Labels
@property (strong, nonatomic) IBOutlet UILabel *stickyBowlingLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyOversLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyBowlingRunsLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyWicketsLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyEconomyLbl;
@property (strong, nonatomic) IBOutlet UILabel *stickyBowlingDotBallsLbl;

@end
