//
//  TeamHeadToHead.h
//  APT_V2
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamHeadToHead : UIViewController

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) IBOutlet UITableView *Poptable;

//Combo box Properties
@property (nonatomic, strong) IBOutlet UIView *team1View;
@property (strong, nonatomic) IBOutlet UIView *team2View;

@property (nonatomic, strong) IBOutlet UIView *groundView;
@property (strong, nonatomic) IBOutlet UIView *competitionView;

@property (strong, nonatomic) IBOutlet UIView *InsideTeam2View;

//TextFields Properties
@property (nonatomic, strong) IBOutlet UITextField *team1TF;
@property (strong, nonatomic) IBOutlet UITextField *team2TF;
@property (strong, nonatomic) IBOutlet UITextField *competitionTF;
@property (nonatomic, strong) IBOutlet UITextField *groundTF;

//Team-1 Matches Win/Loss Label Properties
@property (strong, nonatomic) IBOutlet UILabel *playedT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *homeT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *awayT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *playOffsT1Lbl;

@property (strong, nonatomic) IBOutlet UILabel *playedLbl;


//Team-1 Matches Win/Loss Progress View Properties
@property (strong, nonatomic) IBOutlet UIProgressView *playedT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *homeT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *awayT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *playOffsT1PV;


//Team-2 Matches Win/Loss Label Properties
@property (strong, nonatomic) IBOutlet UILabel *playedT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *homeT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *awayT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *playOffsT2Lbl;

//Team-2 Matches Win/Loss Progress View Properties
@property (strong, nonatomic) IBOutlet UIProgressView *playedT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *homeT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *awayT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *playOffsT2PV;


//Team-1 Toss Decision Labels Properties
@property (strong, nonatomic) IBOutlet UILabel *tossWonT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *decisionBatT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *decisionBowlT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *battingFirstInnWinT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *battingSecondInnWinT1Lbl;

//Team-2 Toss Decision Labels Properties
@property (strong, nonatomic) IBOutlet UILabel *tossWonT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *decisionBatT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *decisionBowlT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *battingFirstInnWinT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *battingSecondInnWinT2Lbl;

//Team-1 Toss Decision Progress View Properties
@property (strong, nonatomic) IBOutlet UIProgressView *tossWonT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *decisionBatT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *decisionBowlT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *battingFirstInnWinT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *battingSecondInnWinT1PV;

//Team-2 Toss Decision Progress View Properties
@property (strong, nonatomic) IBOutlet UIProgressView *tossWonT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *decisionBatT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *decisionBowlT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *battingFirstInnWinT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *battingSecondInnWinT2PV;


//Innings Buttons Properties
@property (nonatomic, strong) IBOutlet UIButton *firstInn;
@property (nonatomic, strong) IBOutlet UIButton *secondInn;
@property (nonatomic, strong) IBOutlet UIButton *team1win;
@property (nonatomic, strong) IBOutlet UIButton *team2win;
@property (nonatomic, strong) IBOutlet UIButton *spell1Inn;
@property (nonatomic, strong) IBOutlet UIButton *spell2Inn;
@property (nonatomic, strong) IBOutlet UIButton *spell3Inn;
@property (weak, nonatomic) IBOutlet UIButton *btnInnsAll;

//Team-1 Properties

@property (strong, nonatomic) IBOutlet UILabel *team1Win;
@property (strong, nonatomic) IBOutlet UIImageView *team1ImageView;
@property (strong, nonatomic) IBOutlet UILabel *avgRunsT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *avgWicketsT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *avgRunsOrWicketsT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *highScoreT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *lowScoreT1Lbl;

//Team-2 Properties

@property (strong, nonatomic) IBOutlet UILabel *team2Win;
@property (strong, nonatomic) IBOutlet UIImageView *team2ImageView;
@property (strong, nonatomic) IBOutlet UILabel *avgRunsT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *avgWicketsT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *avgRunsOrWicketsT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *highScoreT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *lowScoreT2Lbl;

//Team-1 Labels for Progress View Properties
@property (strong, nonatomic) IBOutlet UILabel *runsScoredT1Lbl;

@property (strong, nonatomic) IBOutlet UILabel *runsPerOverT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *wicketsLostT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *battingSRT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *dotBallPercentT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *boundariesPercentT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *bowlingSRT1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *bowlingAvgT1Lbl;

//Team-1 Labels for Progress View Properties
@property (strong, nonatomic) IBOutlet UILabel *runsScoredT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *runsPerOverT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *wicketsLostT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *battingSRT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *dotBallPercentT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *boundariesPercentT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *bowlingSRT2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *bowlingAvgT2Lbl;


//Team-1  Progress View Properties
@property (strong, nonatomic) IBOutlet UIProgressView *runsScoredT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *runsPerOverT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *wicketsLostT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *battingSRT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *dotBallPercentT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *boundariesPercentT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *bowlingSRT1PV;
@property (strong, nonatomic) IBOutlet UIProgressView *bowlingAvgT1PV;
@property (strong, nonatomic) IBOutlet UILabel *nrORtieLbl;


//Team-2  Progress View Properties
@property (strong, nonatomic) IBOutlet UIProgressView *runsScoredT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *runsPerOverT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *wicketsLostT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *battingSRT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *dotBallPercentT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *boundariesPercentT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *bowlingSRT2PV;
@property (strong, nonatomic) IBOutlet UIProgressView *bowlingAvgT2PV;

@property (weak, nonatomic) IBOutlet UIView *viewTeamWin;
@property (weak, nonatomic) IBOutlet UIView *viewTeamOvers;
@property (weak, nonatomic) IBOutlet UIButton *btnAllOvers;
@property (weak, nonatomic) IBOutlet UIButton *btnAllWinTeams;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTeamWidth;


@end
