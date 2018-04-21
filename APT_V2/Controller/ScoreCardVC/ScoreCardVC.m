//
//  ScoreCardVC.m
//  NewSportsProject
//
//  Created by Mac on 30/11/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "ScoreCardVC.h"
#import "Config.h"
#import "ScoreCardCell.h"
#import "ScorecardBowlCell.h"
#import "CustomNavigation.h"

#import "AppCommon.h"
#import "WebService.h"
#import "PlayersVC.h"
#import "SessionSummaryVC.h"
#import "FieldSummaryVC.h"
#import "BallsInVideosCVC.h"
#import "AppDelegate.h"
#import "VideoPlayerViewController.h"
#import "ScoreCardHeader.h"
#import "UIScrollView+APParallaxHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>





@interface ScoreCardVC ()<UIScrollViewDelegate>
{
    NSArray *titleArray;
    NSArray *valuesArray;
    
    NSInteger selectedIndex;
    NSIndexPath *lastIndex;
    
    NSMutableArray *BatsmanDetailsArray1;
    NSMutableArray *BatsmanDetailsArray2;
    NSMutableArray *BatsmanDetailsArray3;
    NSMutableArray *BatsmanDetailsArray4;
    
    NSMutableArray *BowlingDetailsArray1;
    NSMutableArray *BowlingDetailsArray2;
    NSMutableArray *BowlingDetailsArray3;
    NSMutableArray *BowlingDetailsArray4;
    
    NSMutableArray *matchDetailsImageArray;
    
    NSMutableArray *wktdescArray1;
    NSMutableArray *wktdescArray2;
    NSMutableArray *wktdescArray3;
    NSMutableArray *wktdescArray4;
    
    NSMutableArray *ExtrasArray;
    NSMutableArray *ExtrasArray2;
    NSMutableArray *ExtrasArray3;
    NSMutableArray *ExtrasArray4;
    
    
    
    NSMutableArray *didNotbatArray1;
    NSMutableArray *didNotbatArray2;
    NSMutableArray *didNotbatArray3;
    NSMutableArray *didNotbatArray4;
    
    
    NSMutableArray *fallOfWicketArray1;
    NSMutableArray *fallOfWicketArray2;
    NSMutableArray *fallOfWicketArray3;
    NSMutableArray *fallOfWicketArray4;
    
    NSMutableArray *CommonArray;
    NSMutableArray *CommonArray2;
    
    
    NSMutableArray *sendDetailsArray;
    
    NSIndexPath *seletedPath;
    
    bool isSelected ;
    
    BOOL isList;
    BOOL isBowl;
    
    BOOL isPoP;
    
    
    
    WebService *objWebservice;
    NSString *playercode;
    NSString *innno;
    
    
    
    //wagon
    BOOL isOnes ;
    BOOL isDotBall;
    BOOL isFours ;
    BOOL isTwos ;
    BOOL isThrees;
    BOOL isSixes;
    BOOL isWkt;
    BOOL isAll;
    
    BOOL isTestmatch;
    
    int zerocount;
    int Run1Count;
    int Run2Count;
    int Run3Count;
    int Run4Count;
    int Run6Count;
    
    int ones;
    int twos;
    int threes;
    int fours;
    int sixes;
    int onesq;
    
    UILabel * fineleg_lbl;
    UILabel * squareleg_lbl;
    UILabel * midWicket_lbl;
    UILabel * longon_lbl;
    UILabel * longoff_lbl;
    UILabel * cover_lbl;
    UILabel * point_lbl;
    UILabel * Thirdman_lbl;
    
    
    UILabel * lbl_fineleg_per;
    UILabel * lbl_squareleg_per;
    UILabel * lbl_midWicket_per;
    UILabel * lbl_longon_per;
    UILabel * lbl_longoff_per;
    UILabel * lbl_cover_per;
    UILabel * lbl_point_per;
    UILabel * lbl_Thirdman_per;
    
    
    UILabel * lbl_fineleg_count;
    UILabel * lbl_squareleg_count;
    UILabel * lbl_midWicket_count;
    UILabel * lbl_longon_count;
    UILabel * lbl_longoff_count;
    UILabel * lbl_cover_count;
    UILabel * lbl_point_count;
    UILabel * lbl_Thirdman_count;
    
    
    
    int ThirdmanCountRun;
    int pointRun;
    int coverRun;
    int longoffRun;
    int longonRun;
    int midWicketRun;
    int squarelegRun;
    int finelegRun;
    
    
    int ThirdmanCount;
    int pointCount;
    int coverCount;
    int longoffCount;
    int longonCount;
    int midWicketCount;
    int squarelegCount;
    int finelegCount;
    
    BOOL isFirstInn;
    BOOL isSecInn;
    BOOL isThirdInn;
    BOOL isFourthInn;
    BOOL isType;
    UIColor *strokeColor;
    
    
    //pitch
    BOOL isStandard;
    
    BOOL isStatic;
    
    
    
    UIButton * Img_ball;
    
    UILabel *fullTosswideOO;
    UILabel * fullTossoutsideoff;
    UILabel * Fulltossmiddle;
    UILabel* FullTossOSLeg;
    UILabel * FulltosswideWL;
    UILabel * yorkerwideOO;
    UILabel * yorkeroutsideoff;
    UILabel * yorkermiddle;
    UILabel * yorkeroutsideleg;
    UILabel * yorkerwideOL;
    UILabel * fullwideOO;
    UILabel * fulloutsideoff;
    UILabel * fullmiddle;
    UILabel * fulloutsideleg;
    UILabel * fullwideoutleg;
    UILabel * goodwideOO;
    UILabel * goodoutsideoff;
    UILabel * goodmiddle;
    UILabel * goodoutsidele;
    UILabel * goodoutsideleg;
    UILabel * goodwideoutleg;
    UILabel * shortwideOO;
    UILabel * shortoutsideoff;
    UILabel * shortmiddle;
    UILabel * shortoutsideleg;
    UILabel * shortwideOL;
    UILabel * bouncerwideOO;
    UILabel * bounceroutsideoff;
    UILabel * bouncermiddle;
    UILabel * bouncerousideleg;
    UILabel * bouncerwideOL;
    
    
    int  fullTosswideOORun;
    int fullTossoutsideoffRun;
    int  FulltossmiddleRun;
    int  FullTossOSLegRun;
    int  FulltosswideWLRun;
    int  yorkerwideOORun;
    int yorkeroutsideoffRun;
    int yorkermiddleRun;
    int yorkeroutsidelegRun;
    int yorkerwideOLRun;
    int fullwideOORun;
    int fulloutsideoffRun;
    int fullmiddleRun;
    int fulloutsidelegRun;
    int fullwideoutlegRun;
    int goodwideOORun;
    int goodoutsideoffRun;
    int goodmiddleRun;
    int goodoutsideleRun;
    int goodoutsidelegRun;
    int goodwideoutlegRun;
    int shortwideOORun;
    int shortoutsideoffRun;
    int shortmiddleRun;
    int shortoutsidelegRun;
    int shortwideOLRun;
    int bouncerwideOORun;
    int bounceroutsideoffRun;
    int bouncermiddleRun;
    int bouncerousidelegRun;
    int bouncerwideOLRun;
    
    NSMutableArray *array;
    
    AppDelegate* Appobj;
    
    int selectedVideo;
    NSMutableArray  *videoURLArray;
    
    BOOL parallaxWithView;
    
}

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * ContainerYposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * TeamsYposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * HeaderYposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * tableYposition;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * tableHeight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * tableHeight2;


@property (nonatomic,strong) IBOutlet NSLayoutConstraint * ScrollyPosition;




//wagon
@property (nonatomic,strong) NSMutableArray * wagonWheelDrawData;
@property (nonatomic,strong) NSMutableArray * wagonWheelDrawData2;
@property (nonatomic,strong) NSString *selectRun;
@property (nonatomic,strong) NSString *selectOnSide;
@property (nonatomic,strong) NSString *teamBcode;
@property (nonatomic,strong) NSString *totalRuns;
@property (nonatomic,assign) NSNumber *Runs;
@property (nonatomic,assign) NSNumber *tRuns;


@property (nonatomic,strong) NSString *fineLegRuns;
@property (nonatomic,strong) NSString *squareLegRuns;
@property (nonatomic,strong) NSString *midWktRuns;
@property (nonatomic,strong) NSString *longOnRuns;
@property (nonatomic,strong) NSString *longOffRuns;
@property (nonatomic,strong) NSString *coverRuns;
@property (nonatomic,strong) NSString *pointRuns;
@property (nonatomic,strong) NSString *thirdManRuns;

//pitch
@property (nonatomic,strong) NSMutableArray * pitchData;
@property (nonatomic,strong) NSMutableArray * pitchData2;
@property(nonatomic,strong) NSMutableArray * pitchTypeArray;

@property (nonatomic,strong) NSMutableArray * wwd1;
@property (nonatomic,strong) NSMutableArray * ppd1;
@property (nonatomic,strong) NSMutableArray * wwd2;
@property (nonatomic,strong) NSMutableArray * ppd2;
@property (nonatomic,strong) NSMutableArray * wwd3;
@property (nonatomic,strong) NSMutableArray * ppd3;
@property (nonatomic,strong) NSMutableArray * wwd4;
@property (nonatomic,strong) NSMutableArray * ppd4;

@property (nonatomic,strong) NSMutableArray * Bwwd1;
@property (nonatomic,strong) NSMutableArray * Bppd1;
@property (nonatomic,strong) NSMutableArray * Bwwd2;
@property (nonatomic,strong) NSMutableArray * Bppd2;
@property (nonatomic,strong) NSMutableArray * Bwwd3;
@property (nonatomic,strong) NSMutableArray * Bppd3;
@property (nonatomic,strong) NSMutableArray * Bwwd4;
@property (nonatomic,strong) NSMutableArray * Bppd4;

@property (nonatomic,strong) NSArray * Summaryarray;



@end

@implementation ScoreCardVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    Appobj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.headerUIView.hidden = YES;
    self.headerUIViewTestmatch.hidden = YES;
    
    //Assign Values to Batting Properties
    if (IS_IPAD) {
        self.battingLabel.text = @"Batting";
        self.battingRunsLbl.text = @"Runs";
        self.ballsLbl.text = @"Balls";
        self.foursLbl.text = @"4's";
        self.sixsLbl.text = @"6's";
        self.strikeRateLbl.text = @"S/R";
        self.battingDotBallsLbl.text = @"Dot Balls";
        
        self.stickyBattingLabel.text = @"Batting";
        self.stickyBattingRunsLbl.text = @"Runs";
        self.stickyBallsLbl.text = @"Balls";
        self.stickyFoursLbl.text = @"4's";
        self.stickySixsLbl.text = @"6's";
        self.stickyStrikeRateLbl.text = @"S/R";
        self.stickyBattingDotBallsLbl.text = @"Dot Balls";
    } else {
        self.battingLabel.text = @"Batting";
        self.battingRunsLbl.text = @"R";
        self.ballsLbl.text = @"B";
        self.foursLbl.text = @"4's";
        self.sixsLbl.text = @"6's";
        self.strikeRateLbl.text = @"SR";
        self.battingDotBallsLbl.text = @"DB";
        
        self.stickyBattingLabel.text = @"Batting";
        self.stickyBattingRunsLbl.text = @"R";
        self.stickyBallsLbl.text = @"B";
        self.stickyFoursLbl.text = @"4's";
        self.stickySixsLbl.text = @"6's";
        self.stickyStrikeRateLbl.text = @"SR";
        self.stickyBattingDotBallsLbl.text = @"DB";
    }
    
    //Assign Values to Bowling Properties
    if (IS_IPAD) {
        self.bowlingLbl.text = @"Bowling";
        self.oversLbl.text = @"Overs";
        self.bowlingRunsLbl.text = @"Runs";
        self.wicketsLbl.text = @"Wkts";
        self.economyLbl.text = @"Econ";
        self.bowlingDotBallsLbl.text = @"Dot Balls";
        
        self.stickyBowlingLbl.text = @"Bowling";
        self.stickyOversLbl.text = @"Overs";
        self.stickyBowlingRunsLbl.text = @"Runs";
        self.stickyWicketsLbl.text = @"Wkts";
        self.stickyEconomyLbl.text = @"Econ";
        self.stickyBowlingDotBallsLbl.text = @"Dot Balls";
    } else {
        self.bowlingLbl.text = @"Bowling";
        self.oversLbl.text = @"O";
        self.bowlingRunsLbl.text = @"R";
        self.wicketsLbl.text = @"W";
        self.economyLbl.text = @"E";
        self.bowlingDotBallsLbl.text = @"DB";
        
        self.stickyBowlingLbl.text = @"Bowling";
        self.stickyOversLbl.text = @"O";
        self.stickyBowlingRunsLbl.text = @"R";
        self.stickyWicketsLbl.text = @"W";
        self.stickyEconomyLbl.text = @"E";
        self.stickyBowlingDotBallsLbl.text = @"DB";
    }
    
    titleArray = [NSArray arrayWithObjects:@"National Team",@"Age",@"Date of Birth",@"Weight",@"height",@"Role",@"Batting Style",@"Bowling Style", nil];
    valuesArray = [NSArray arrayWithObjects:@"India",@"28",@"5 Nvember 1988",@"69kg",@"1.75 m",@"Batsman",@"Right Handed Bat",@"Right-arm Medium", nil];
    
    self.Summaryarray = [NSArray arrayWithObjects:@"BattingKPI",@"BowlingKPI",@"Fielding Summary",@"Session Summary", nil];
    
    selectedIndex = -1;
    
    isList = YES;
    isBowl = NO;
    isPoP = NO;
    objWebservice = [[WebService alloc]init];

    self.rootVideoView.hidden = YES;
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
    
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
    
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
        // Add both effects to your view
        [self.view addMotionEffect:group];
    
    
    selectedVideo = 0;
    // NSMutableArray  *videoURLArray;
    
    if(IS_IPHONE_DEVICE) {
        
        UIBezierPath *path = [UIBezierPath new];
        
        [path moveToPoint:(CGPoint){self.Team1.frame.size.width+50,0 }];//w0
        [path addLineToPoint:(CGPoint){0, 0}];//00
        [path addLineToPoint:(CGPoint){0,self.Team1.frame.size.height }];//0h
        [path addLineToPoint:(CGPoint){self.Team1.frame.size.width+50, self.Team1.frame.size.height}];//wh20
        
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.Team1.bounds;
        mask.path = path.CGPath;
        self.Team1.layer.mask = mask;
        
        
        UIBezierPath *path1 = [UIBezierPath new];
        
        [path1 moveToPoint:(CGPoint){self.Team2.frame.size.width+30,0 }];//w0
        [path1 addLineToPoint:(CGPoint){15, 0}];//00
        [path1 addLineToPoint:(CGPoint){0,self.Team2.frame.size.height }];//0h
        [path1 addLineToPoint:(CGPoint){self.Team2.frame.size.width+30, self.Team2.frame.size.height}];//wh20
        
        CAShapeLayer *mask1 = [CAShapeLayer new];
        mask1.frame = self.Team2.bounds;
        mask1.path = path1.CGPath;
        self.Team2.layer.mask = mask1;
        
        
        UIBezierPath *path2 = [UIBezierPath new];
        
        [path2 moveToPoint:(CGPoint){self.StickyTeam1.frame.size.width+50,0 }];//w0
        [path2 addLineToPoint:(CGPoint){0, 0}];//00
        [path2 addLineToPoint:(CGPoint){0,self.StickyTeam1.frame.size.height }];//0h
        [path2 addLineToPoint:(CGPoint){self.StickyTeam1.frame.size.width+50, self.StickyTeam1.frame.size.height}];//wh20
        
        CAShapeLayer *mask2 = [CAShapeLayer new];
        mask2.frame = self.StickyTeam1.bounds;
        mask2.path = path2.CGPath;
        self.StickyTeam1.layer.mask = mask2;
        
        
        UIBezierPath *path3 = [UIBezierPath new];
        
        [path3 moveToPoint:(CGPoint){self.StickyTeam2.frame.size.width+30,0 }];//w0
        [path3 addLineToPoint:(CGPoint){15, 0}];//00
        [path3 addLineToPoint:(CGPoint){0,self.StickyTeam2.frame.size.height }];//0h
        [path3 addLineToPoint:(CGPoint){self.StickyTeam2.frame.size.width+30, self.StickyTeam2.frame.size.height}];//wh20
        
        CAShapeLayer *mask3 = [CAShapeLayer new];
        mask3.frame = self.StickyTeam2.bounds;
        mask3.path = path3.CGPath;
        self.StickyTeam2.layer.mask = mask3;
        
    }else
    {
        //odi ,t20 match buttons
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){self.Team1.frame.size.width,0 }];//w0
        [path addLineToPoint:(CGPoint){0, 0}];//00
        [path addLineToPoint:(CGPoint){0,self.Team1.frame.size.height }];//0h
        [path addLineToPoint:(CGPoint){self.Team1.frame.size.width-25, self.Team1.frame.size.height}];//wh20
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.Team1.bounds;
        mask.path = path.CGPath;
        self.Team1.layer.mask = mask;
        
        
        UIBezierPath *path1 = [UIBezierPath new];
        [path1 moveToPoint:(CGPoint){self.Team2.frame.size.width,0 }];//w0
        [path1 addLineToPoint:(CGPoint){25, 0}];//00
        [path1 addLineToPoint:(CGPoint){0,self.Team2.frame.size.height }];//0h
        [path1 addLineToPoint:(CGPoint){self.Team2.frame.size.width, self.Team2.frame.size.height}];//wh20
        CAShapeLayer *mask1 = [CAShapeLayer new];
        mask1.frame = self.Team2.bounds;
        mask1.path = path1.CGPath;
        self.Team2.layer.mask = mask1;
        
        
        UIBezierPath *pathsticky1 = [UIBezierPath new];
        [pathsticky1 moveToPoint:(CGPoint){self.StickyTeam1.frame.size.width,0 }];//w0
        [pathsticky1 addLineToPoint:(CGPoint){0, 0}];//00
        [pathsticky1 addLineToPoint:(CGPoint){0,self.StickyTeam1.frame.size.height }];//0h
        [pathsticky1 addLineToPoint:(CGPoint){self.StickyTeam1.frame.size.width-25, self.StickyTeam1.frame.size.height}];//wh20
        CAShapeLayer *maskst1 = [CAShapeLayer new];
        maskst1.frame = self.StickyTeam1.bounds;
        maskst1.path = pathsticky1.CGPath;
        self.StickyTeam1.layer.mask = maskst1;
        
        
        UIBezierPath *pathsticky2 = [UIBezierPath new];
        [pathsticky2 moveToPoint:(CGPoint){self.StickyTeam2.frame.size.width,0 }];//w0
        [pathsticky2 addLineToPoint:(CGPoint){25, 0}];//00
        [pathsticky2 addLineToPoint:(CGPoint){0,self.StickyTeam2.frame.size.height }];//0h
        [pathsticky2 addLineToPoint:(CGPoint){self.StickyTeam2.frame.size.width, self.StickyTeam2.frame.size.height}];//wh20
        CAShapeLayer *maskst2 = [CAShapeLayer new];
        maskst2.frame = self.StickyTeam2.bounds;
        maskst2.path = pathsticky2.CGPath;
        self.StickyTeam2.layer.mask = maskst2;
        
        
       
        
        
        
        //test match buttons
        UIBezierPath *path2 = [UIBezierPath new];
        [path2 moveToPoint:(CGPoint){self.Inn1.frame.size.width,0 }];//w0
        [path2 addLineToPoint:(CGPoint){0, 0}];//00
        [path2 addLineToPoint:(CGPoint){0,self.Inn1.frame.size.height }];//0h
        [path2 addLineToPoint:(CGPoint){self.Inn1.frame.size.width-15, self.Inn1.frame.size.height}];//wh20
        CAShapeLayer *mask2 = [CAShapeLayer new];
        mask2.frame = self.Inn1.bounds;
        mask2.path = path2.CGPath;
        self.Inn1.layer.mask = mask2;
        
        
        UIBezierPath *path4 = [UIBezierPath new];
        [path4 moveToPoint:(CGPoint){self.Inn2.frame.size.width,0 }];//w0
        [path4 addLineToPoint:(CGPoint){0, 0}];//00
        [path4 addLineToPoint:(CGPoint){0,self.Inn2.frame.size.height }];//0h
        [path4 addLineToPoint:(CGPoint){self.Inn2.frame.size.width-15, self.Inn2.frame.size.height}];//wh20
        CAShapeLayer *mask3 = [CAShapeLayer new];
        mask3.frame = self.Inn2.bounds;
        mask3.path = path4.CGPath;
        self.Inn2.layer.mask = mask3;
        
        UIBezierPath *path5 = [UIBezierPath new];
        [path5 moveToPoint:(CGPoint){self.Inn3.frame.size.width,0 }];//w0
        [path5 addLineToPoint:(CGPoint){0, 0}];//00
        [path5 addLineToPoint:(CGPoint){0,self.Inn3.frame.size.height }];//0h
        [path5 addLineToPoint:(CGPoint){self.Inn3.frame.size.width-15, self.Inn3.frame.size.height}];//wh20
        CAShapeLayer *mask4 = [CAShapeLayer new];
        mask4.frame = self.Inn3.bounds;
        mask4.path = path5.CGPath;
        self.Inn3.layer.mask = mask4;
        
        
        UIBezierPath *path6 = [UIBezierPath new];
        [path6 moveToPoint:(CGPoint){self.Inn4.frame.size.width,0 }];//w0
        [path6 addLineToPoint:(CGPoint){0, 0}];//00
        [path6 addLineToPoint:(CGPoint){0,self.Inn4.frame.size.height }];//0h
        [path6 addLineToPoint:(CGPoint){self.Inn4.frame.size.width, self.Inn4.frame.size.height}];//wh20
        CAShapeLayer *mask5 = [CAShapeLayer new];
        mask5.frame = self.Inn4.bounds;
        mask5.path = path6.CGPath;
        self.Inn4.layer.mask = mask5;
  
        
    }
    
    
    NSLog(@"%@", _matchCode);
    
    //    if([self.backkey isEqualToString:@"no"])
    //    {
    //    self.matchCode=Appobj.Currentmatchcode;
    //    self.matchDetails =Appobj.Scorearray;
    //    }
    
    self.matchCode=appDel.Currentmatchcode;
    self.matchDetails =appDel.Scorearray;
    
    NSLog(@"matchCode:%@", self.matchCode);
    NSLog(@"matchDetails:%@", self.matchDetails);
    
    self.commonScroll.delegate=self;
    
    self.popTbl.hidden=YES;
    
   // [self toggle:nil];
    
    
    [self ScoreWebservice];
    
    
    
    
    // [self.Team1 sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

- (void)toggle:(id)sender {
    /**
     *  For demo purposes this view controller either adds a parallaxView with a custom view
     *  or a parallaxView with an image.
     */
    //if(parallaxWithView == NO) {
        // add parallax with view

       //[self ScoreWebservice];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LiveBgimg"]];
        [imageView setFrame:CGRectMake(0, 0, 320, 160)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];


        UIView *l = [[UIView alloc]init];
        [l setFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];



        ScoreCardHeader *header = [[ScoreCardHeader alloc]init];
        header.matchDetailsArray = matchDetailsImageArray;
        header.view.frame = CGRectMake(0, 0, self.view.frame.size.width,200);
        [l addSubview:header.view];

   // NSString *size = @"{{0, 0}, {768, 240}}";
    
    NSString *size = [NSString stringWithFormat:@"{{0, 0}, {%ld, 240}}",self.view.frame.size.width];
    
    [self.commonScroll addParallaxWithView:header.view andHeight:200];
    [self.commonScroll scrollRectToVisible:CGRectFromString(size) animated:YES];
//    self.commonScroll.parallaxView
    
    //APParallaxTrackingActive
    

        parallaxWithView = YES;

        // Update the toggle button
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];

 //   }
//    else {
//        // add parallax with image
//        [self.commonScroll addParallaxWithImage:[UIImage imageNamed:@"ParallaxImage.jpg"] andHeight:160 andShadow:YES];
//        parallaxWithView = NO;
//
//        // Update the toggle button
//        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
//        [self.navigationItem setRightBarButtonItem:barButton];
//    }

    /**
     *  Setting a delegate for the parallaxView will allow you to get callbacks for when the
     *  frame of the parallaxView changes.
     *  Totally optional thou.
     */
    self.commonScroll.parallaxView.delegate = self;
    self.commonScroll.scrollsToTop =YES;
    
//    APParallaxView *view;
    //view.frame = CGRectMake(0, -240, self.view.frame.size.width, 240);
    
    //NSString *size = @"{{0, -240}, {768, 240}}";
    //view.frame = CGRectFromString(size);
    
   // self.ScrollyPosition.constant = 240;

}



#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview before its frame changes
    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));

    
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview after its frame changed
    NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"yes");
    NSLog(@"%f", scrollView.contentOffset.y);
    
    float fScroll = scrollView.contentOffset.y;
    
    float fFallofWkts  = self.teamsUIView.frame.size.height+self.containerUIView.frame.size.height + self.headerUIView.frame.size.height + self.listTbl.frame.size.height+100;
    
    float fBowling  = self.teamsUIView.frame.size.height+self.containerUIView.frame.size.height + self.headerUIView.frame.size.height + self.listTbl.frame.size.height+100+self.FallofwktsUIView.frame.size.height;
    
    
//    if(fScroll == fFallofWkts)
//    {
//        self.StickyView.hidden = NO;
//        self.StickyBattingHeader.hidden = YES;
//        self.StickyBowlingHeader.hidden = YES;
//        self.StickyFallofWktsHeader.hidden = NO;
//    }
//    else  if(fScroll == fBowling)
//    {
//        self.StickyView.hidden = NO;
//        self.StickyBattingHeader.hidden = YES;
//        self.StickyBowlingHeader.hidden = NO;
//        self.StickyFallofWktsHeader.hidden = YES;
//    }
    
//  if(isSelected ==NO)
//  {
      if(fScroll>=200.000000 && fScroll<=fFallofWkts)
      {
          self.StickyView.hidden = NO;
          self.StickyBattingHeader.hidden = NO;
          self.StickyBowlingHeader.hidden = YES;
          self.StickyFallofWktsHeader.hidden = YES;
      }
      else if(fScroll>=fFallofWkts && fScroll<=fBowling)  //
      {

          self.StickyView.hidden = NO;
          self.StickyBattingHeader.hidden = YES;
          self.StickyBowlingHeader.hidden = YES;
          self.StickyFallofWktsHeader.hidden = NO;
      }
      else if(fScroll>=fBowling)
      {
          self.StickyView.hidden = NO;
          self.StickyBattingHeader.hidden = YES;
          self.StickyBowlingHeader.hidden = NO;
          self.StickyFallofWktsHeader.hidden = YES;
      }
      else{

          self.StickyView.hidden = YES;
          self.StickyBattingHeader.hidden = YES;
          self.StickyBowlingHeader.hidden = YES;
          self.StickyFallofWktsHeader.hidden = YES;
      }
 // }
  //else
//  {
//      if(fScroll>=232.000000 && fScroll<=1042.500000)
//      {
//          self.StickyView.hidden = NO;
//          self.StickyBattingHeader.hidden = NO;
//          self.StickyBowlingHeader.hidden = YES;
//          self.StickyFallofWktsHeader.hidden = YES;
//      }
////      else if(f>=1042.500000 && f<=1203.500000 )
////      {
////          self.StickyView.hidden = NO;
////          self.StickyBattingHeader.hidden = YES;
////          self.StickyBowlingHeader.hidden = YES;
////          self.StickyFallofWktsHeader.hidden = NO;
////      }else if(f>=1203.500000)
////      {
////          self.StickyView.hidden = NO;
////          self.StickyBattingHeader.hidden = YES;
////          self.StickyBowlingHeader.hidden = NO;
////          self.StickyFallofWktsHeader.hidden = YES;
////      }
//      else{
//
//          self.StickyView.hidden = YES;
//          self.StickyBattingHeader.hidden = YES;
//          self.StickyBowlingHeader.hidden = YES;
//          self.StickyFallofWktsHeader.hidden = YES;
//      }
//  }

}




- (void)viewWillAppear:(BOOL)animated
{
    // just add this line to the end of this method or create it if it does not exist
    // [self.listTbl reloadData];
   // [self toggle:nil];
    
    [super viewWillAppear:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated {
   // NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
   // [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
     [super viewWillDisappear:animated];
}


-(void)buttonclicked:(UIButton*)selectedBtn
{
    NSArray *arr= @[self.Inn1,self.Inn2,self.Inn3,self.Inn4];
    
    for (UIButton *curBtn in arr) {
        
        if(selectedBtn == curBtn)
        {
            selectedBtn.tag = 1;
        }
        else
        {
            curBtn.tag = 0;
        }
    }
}



-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        objCustomNavigation.home_btn.hidden = YES;
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[objCustomNavigation.btn_back addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //[objCustomNavigation.home_btn addTarget:self action:@selector(didClickSummaryBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navi_View addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
}

-(IBAction)didClickSummaryBtn:(id)sender
{
    if(isPoP==NO)
    {
        self.popTbl.hidden=NO;
        isPoP = YES;
        isList=NO;
        isBowl=NO;
        [self.popTbl reloadData];
    }
    else
    {
        self.popTbl.hidden=YES;
        isPoP=NO;
        isList=YES;
        isBowl=YES;
    }
}


#pragma mark uitableview delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.listTbl)
        // {
        return CommonArray.count;
    // }
    else if(tableView == self.bowlingTbl)
        //    {
        return CommonArray2.count;
    else if(tableView==self.popTbl)
        return self.Summaryarray.count;
    //    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.popTbl)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:nil];
        }
        
        
        cell.textLabel.text = self.Summaryarray[indexPath.row];
        cell.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    if(tableView == self.listTbl)
    {
        
        static NSString *MyIdentifier = @"MyIdentifier";
        
        
        
        ScoreCardCell *cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            // cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell=[[ScoreCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        //[cell setBackgroundColor:[UIColor lightGrayColor]];
        //[cell setAccessibilityTraits:UIAccessibilityTraitSelected];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.playerNamelbl.numberOfLines = 2;
        [cell.playerNamelbl setAdjustsFontSizeToFitWidth:YES];
        
        cell.playerNamelbl.text = [[CommonArray valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row];
        cell.runslbl.text = [[CommonArray valueForKey:@"Runs"] objectAtIndex:indexPath.row];
        cell.ballslbl.text = [[CommonArray valueForKey:@"Balls"] objectAtIndex:indexPath.row];
        cell.fourslbl.text = [[CommonArray valueForKey:@"Fours"] objectAtIndex:indexPath.row];
        cell.sixeslbl.text = [[CommonArray valueForKey:@"Sixs"] objectAtIndex:indexPath.row];
        cell.strikelbl.text = [[CommonArray valueForKey:@"Strikerate"] objectAtIndex:indexPath.row];
        cell.wktDesclbl.text = [[CommonArray valueForKey:@"WicketsDesc"] objectAtIndex:indexPath.row];
        cell.dotballslbl.text = [[CommonArray valueForKey:@"DotBalls"] objectAtIndex:indexPath.row];
        //DotBalls
        
        
        [cell.onesBtn addTarget:self action:@selector(didClickOnesBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.twoBtn addTarget:self action:@selector(didClicktwosBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.threeBtn addTarget:self action:@selector(didClickthreeBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fourBtn addTarget:self action:@selector(didClickfourssBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sixBtn addTarget:self action:@selector(didClicksixesBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dotBtn addTarget:self action:@selector(didClickdotsBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.wktBtn addTarget:self action:@selector(didClickwicketBatting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.alllbl addTarget:self action:@selector(didClickAllBatting:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setTag:indexPath.row];
        
        [[cell runsBtn] setTag:[indexPath row]];
        [[cell ballsBtn] setTag:[indexPath row]];
        [[cell foursBtn] setTag:[indexPath row]];
        [[cell sixesBtn] setTag:[indexPath row]];
        [[cell dotsBtn] setTag:[indexPath row]];
        [[cell wktsBtn] setTag:[indexPath row]];
        
        
        [cell.runsBtn addTarget:self action:@selector(myActionRuns:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ballsBtn addTarget:self action:@selector(myActionBalls:) forControlEvents:UIControlEventTouchUpInside];
        [cell.foursBtn addTarget:self action:@selector(myActionFours:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sixesBtn addTarget:self action:@selector(myActionSixes:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dotsBtn addTarget:self action:@selector(myActionDots:) forControlEvents:UIControlEventTouchUpInside];
        [cell.wktsBtn addTarget:self action:@selector(myActionplayerWkt:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
        
    }
    if(tableView == self.bowlingTbl)
    {
        static NSString *MyIdentifier = @"myid";
        ScorecardBowlCell *cell = [self.bowlingTbl dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
        {
            // cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell=[[ScorecardBowlCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        //[cell setBackgroundColor:[UIColor lightGrayColor]];
        //[cell setAccessibilityTraits:UIAccessibilityTraitSelected];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.bowelernamelbl.text = [[CommonArray2 valueForKey:@"BowlerName"] objectAtIndex:indexPath.row];
        cell.overslbl.text = [[CommonArray2 valueForKey:@"Overs"] objectAtIndex:indexPath.row];
        cell.runslbl.text = [[CommonArray2 valueForKey:@"Runs"] objectAtIndex:indexPath.row];
        cell.wicketslbl.text = [[CommonArray2 valueForKey:@"Wickets"] objectAtIndex:indexPath.row];
        cell.economylbl.text = [[CommonArray2 valueForKey:@"Econ"] objectAtIndex:indexPath.row];
        cell.dotballslbl.text = [[CommonArray2 valueForKey:@"DotBalls"] objectAtIndex:indexPath.row];
        
        [cell.onesBtn addTarget:self action:@selector(didClickOnesbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.twoBtn addTarget:self action:@selector(didClicktwosbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.threeBtn addTarget:self action:@selector(didClickthreebowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fourBtn addTarget:self action:@selector(didClickfourssbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sixBtn addTarget:self action:@selector(didClicksixesbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dotBtn addTarget:self action:@selector(didClickdotsbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.wktBtn addTarget:self action:@selector(didClickwicketbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        [cell.alllbl addTarget:self action:@selector(didClickAllbowlingTbl:) forControlEvents:UIControlEventTouchUpInside];
        
        [[cell runSBtn] setTag:[indexPath row]];
        [[cell oversBtn] setTag:[indexPath row]];
        [[cell wicketsBtn] setTag:[indexPath row]];
        [[cell dotsBtn] setTag:[indexPath row]];
        
        [cell setTag:indexPath.row];
        
        [cell.runSBtn addTarget:self action:@selector(myActionRUNSBowling:) forControlEvents:UIControlEventTouchUpInside];
        [cell.oversBtn addTarget:self action:@selector(myActionOversBowling:) forControlEvents:UIControlEventTouchUpInside];
        [cell.wicketsBtn addTarget:self action:@selector(myActionWktsBowling:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dotsBtn addTarget:self action:@selector(myActionDotsBowling:) forControlEvents:UIControlEventTouchUpInside];
     
        return cell;
        
    }
    
    return nil;
    
}
-(IBAction)CellActionWagonPitch:(id)sender
{
    
//    UIButton *button = sender;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
//    seletedPath = indexPath;
//    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    
    
   // NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
//    playercode = [[BatsmanDetailsArray1 valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
//    innno = [[BatsmanDetailsArray1 valueForKey:@"Inningsno"] objectAtIndex:indexPath.row];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    dict = [self WagonWheelWebservice];
    
}

-(IBAction)myExtras:(id)sender
{
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    //[self loadVideoPlayer1:@"" :self.matchCode :innno : @"":@"EXTRAS"];
    //[self loadVideoPlayer:@"0":self.matchCode:innno:@"0":@"EXTRAS"];
    [self loadVideoPlayer:@"0" :@"0" :@"EXTRAS" innings:innno];
    
    
   // http://13.126.151.253:9001/AGAPTService.svc/GETSCORECARDVIDEOSFILEPATH/0/DMSC11600224DB2663B20170414152400012/1/0/EXTRAS
}
-(IBAction)myActionRuns:(id)sender
{
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"RUNS" :@"BATTING" innings:innno];
    
}
-(IBAction)myActionBalls:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row]);
    
    
    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
    [self loadVideoPlayer:Batsmancode :@"BALLS" :@"BATTING" innings:innno];
    
}

-(IBAction)myActionFours:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row]);

    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"FOURS" :@"BATTING" innings:innno];
    
}

-(IBAction)myActionSixes:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row]);
    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"SIXES" :@"BATTING" innings:innno];
    
}
-(IBAction)myActionDots:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray valueForKey:@"BatsmenName"] objectAtIndex:indexPath.row]);
    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"DOTS" :@"BATTING" innings:innno];
    
}

-(IBAction)myActionplayerWkt:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.listTbl cellForRowAtIndexPath:indexPath];
    
    NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
    [self loadVideoPlayer:Batsmancode :@"WKT" :@"BATTING" innings:innno];
    
}



-(IBAction)myActionOversBowling:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScorecardBowlCell * cell = [self.bowlingTbl cellForRowAtIndexPath:indexPath];
    
    NSString * Batsmancode =[[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
    
    [self loadVideoPlayer:Batsmancode :@"OVERS" :@"BOWLING" innings:innno];
}
-(IBAction)myActionRUNSBowling:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCell * cell = [self.bowlingTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row]);
  
    NSString * Batsmancode =[[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"RUNS" :@"BOWLING" innings:innno];
    
}



-(IBAction)myActionWktsBowling:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScorecardBowlCell * cell = [self.bowlingTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row]);
   
    NSString * Batsmancode =[[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"WKT" :@"BOWLING" innings:innno];
    
}
-(IBAction)myActionDotsBowling:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScorecardBowlCell * cell = [self.bowlingTbl cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",[[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row]);
    
    NSString * Batsmancode =[[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
    [self loadVideoPlayer:Batsmancode :@"DOTS" :@"BOWLING" innings:innno];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView== self.listTbl ||tableView== self.bowlingTbl )
    {
        if(indexPath.row ==  selectedIndex)
        {
                        if(IS_IPHONE_DEVICE)
                        {
                            return 220;
                        }
                        else
                        {
                            return 300;
                        }
            
        }
        else
        {
            if(IS_IPHONE_DEVICE)
            {
                if(tableView== self.listTbl ||tableView== self.bowlingTbl) {
                    return 50;
                } else {
                    return 35;
                }
            }
            else
            {
                
                return 50;
            }
        }
    }
    else
    {
        return 50;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if(tableView == self.listTbl)
        {
    
            isList = YES;
            isBowl = NO;
            static NSString *MyIdentifier = @"MyIdentifier";
    
            ScoreCardCell *cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
    
            [self.listTbl beginUpdates];
    
    
            if(indexPath.row == selectedIndex)
            {
                selectedIndex = -1;
                isSelected =NO;
    
                lastIndex = NULL;
    
                isOnes = YES;
                isTwos = YES;
                isThrees = YES;
                isFours = YES;
                isSixes = YES;
                isWkt = YES;
                isDotBall = YES;
    
            }
            else
            {
    
                if(lastIndex != nil){
    
                    [self.listTbl reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                    isSelected =YES;
    
                    isOnes = YES;
                    isTwos = YES;
                    isThrees = YES;
                    isFours = YES;
                    isSixes = YES;
                    isWkt = YES;
                    isDotBall = YES;
    
                    //self.tableHeight.constant = self.listTbl.frame.size.height-300;
    
                    // self.tableHeight.constant = self.listTbl.frame.size.height300;
                    // [self.listTbl reloadData];
                }
                
                isSelected =YES;
    
                lastIndex = indexPath;
                selectedIndex = indexPath.row;
    
            }
            seletedPath = indexPath;
            playercode = [[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
            innno = [[CommonArray valueForKey:@"Inningsno"] objectAtIndex:indexPath.row];
            //NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
             [self WagonWheelWebservice];
             [self PitchmapWebservice];
           
            
            
            
            
            [self.listTbl reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
           // self.tableYposition.constant = 0;
            [self.listTbl endUpdates];
    
            [self.listTbl reloadData];
            CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
            self.tableHeight.constant = height;
            [self.view layoutIfNeeded];
            CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
            self.tableHeight2.constant = height1;
            [self.view layoutIfNeeded];
            
            
            
            
    
        }
    
    
        if(tableView == self.bowlingTbl)
        {
            
            isList = NO;
            isBowl = YES;
            static NSString *MyIdentifier = @"myid";
    
            ScorecardBowlCell *cell = [self.bowlingTbl dequeueReusableCellWithIdentifier:MyIdentifier];
    
            [self.bowlingTbl beginUpdates];
            if(indexPath.row == selectedIndex)
            {
                selectedIndex = -1;
                lastIndex = NULL;
    
                isOnes = YES;
                isTwos = YES;
                isThrees = YES;
                isFours = YES;
                isSixes = YES;
                isWkt = YES;
                isDotBall = YES;
            }
            else
            {
    
                if(lastIndex != nil){
    
    
    
                    [self.bowlingTbl reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    isSelected =YES;
    
    
                    isOnes = YES;
                    isTwos = YES;
                    isThrees = YES;
                    isFours = YES;
                    isSixes = YES;
                    isWkt = YES;
                    isDotBall = YES;
    
    
                }
                lastIndex = indexPath;
                selectedIndex = indexPath.row;
    
            }
            
            seletedPath = indexPath;
            playercode = [[CommonArray2 valueForKey:@"BowlerCode"] objectAtIndex:indexPath.row];
            innno = [[CommonArray2 valueForKey:@"Inningsno"] objectAtIndex:indexPath.row];
            //NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [self WagonWheelWebservice];
            [self PitchmapbowlWebservice];
    
            [self.bowlingTbl reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
            [self.bowlingTbl endUpdates];
            [self.bowlingTbl reloadData];
    
    
            CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
            self.tableHeight.constant = height;
            [self.view layoutIfNeeded];
            CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
            self.tableHeight2.constant = height1;
            [self.view layoutIfNeeded];
        }
    if(tableView == self.popTbl)
    {
        //isPoP = NO;
        //        if(indexPath.row == 0 || indexPath.row == 1)
        //        {
        //            self.popTbl.hidden = YES;
        //        self.popTbl.hidden=YES;
        //        PlayersVC * objFix = [[PlayersVC alloc]init];
        //        objFix = (PlayersVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayersVC"];
        //        [self.navigationController pushViewController:objFix animated:YES];
        //        }
        
        if(indexPath.row == 0)
        {
            self.popTbl.hidden=YES;
            PlayersVC * objFix = [[PlayersVC alloc]init];
            objFix = (PlayersVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayersVC"];
            objFix.indexPath = indexPath.row;
            objFix.matchcode = self.matchCode;
            objFix.matchDetailss = self.matchDetails;
            objFix.BatsmanDetailsArray1 = BatsmanDetailsArray1;
            objFix.BatsmanDetailsArray2 = BatsmanDetailsArray2;
            objFix.BatsmanDetailsArray3 = BatsmanDetailsArray3;
            objFix.BatsmanDetailsArray4 = BatsmanDetailsArray4;
            objFix.inningsDetailsArray = array;
            NSLog(@"%@", objFix.inningsDetailsArray);
            [self.navigationController pushViewController:objFix animated:YES];
            
        } else if (indexPath.row == 1) {
            
            self.popTbl.hidden=YES;
            PlayersVC * objFix = [[PlayersVC alloc]init];
            objFix = (PlayersVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayersVC"];
            objFix.indexPath = indexPath.row;
            objFix.matchcode = self.matchCode;
            objFix.matchDetailss = self.matchDetails;
            objFix.BowlingDetailsArray1 = BowlingDetailsArray1;
            objFix.BowlingDetailsArray2 = BowlingDetailsArray2;
            objFix.BowlingDetailsArray3 = BowlingDetailsArray3;
            objFix.BowlingDetailsArray4 = BowlingDetailsArray4;
            objFix.inningsDetailsArray = array;
            [self.navigationController pushViewController:objFix animated:YES];
        }
        
        if(indexPath.row == 2)
        {
            
            NSString *matchHeaderDetail =[NSString stringWithFormat:@"%@ Vs %@ - %@",self.teamAlbl.text,self.teamBlbl.text,self.groundlbl.text];
            
            self.popTbl.hidden = YES;
            FieldSummaryVC * objFix = [[FieldSummaryVC alloc]init];
            objFix = (FieldSummaryVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FieldingSummaryVC"];
            objFix.matchcode = self.matchCode;
            objFix.matchHeadding = matchHeaderDetail;
            objFix.isTest = isTestmatch;
            [self.navigationController pushViewController:objFix animated:YES];
            
            
            
            //            self.teamAlbl.text = [[self.matchDetails valueForKey:@"team1"] objectAtIndex:0];
            //            self.teamBlbl.text = [[self.matchDetails valueForKey:@"team2"] objectAtIndex:0];
            //
            //            //    self.teamAScorelbl.text = [[self.matchDetails valueForKey:@"Inn1Score"] objectAtIndex:0];
            //            //    self.teamBScorelbl.text = [[self.matchDetails valueForKey:@"Inn2Score"] objectAtIndex:0];
            //            self.groundlbl.text = [[self.matchDetails valueForKey:@"ground"] objectAtIndex:0];
        }
        
        
        if(indexPath.row == 3)
        {
            NSString *matchHeaderDetail =[NSString stringWithFormat:@"%@ Vs %@ - %@",self.teamAlbl.text,self.teamBlbl.text,self.groundlbl.text];
            self.popTbl.hidden = YES;
            SessionSummaryVC * objFix = [[SessionSummaryVC alloc]init];
            objFix = (SessionSummaryVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SessionSummaryVC"];
            objFix.matchcode = self.matchCode;
            objFix.isTest = isTestmatch;
            objFix.matchHeadding = matchHeaderDetail;
            [self.navigationController pushViewController:objFix animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if(tableView== self.listTbl ||tableView== self.bowlingTbl )
        {
            if (selectedIndex == indexPath.row)
            {
    
                [cell setBackgroundColor:[UIColor lightGrayColor]];
                [cell setAccessibilityTraits:UIAccessibilityTraitSelected];
            }
            else
            {
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell setAccessibilityTraits:0];
    
            }
    
        }
        else if(tableView == self.popTbl)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setAccessibilityTraits:0];
    
        }
    
    
}


//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    float scrollViewHeight = scrollView.frame.size.height;
//    float scrollContentSizeHeight = self.commonScroll.contentSize.height;
//    float scrollOffset = scrollView.contentOffset.y;
//
//
//    if(IS_IPHONE_DEVICE)
//    {
//        if(scrollOffset <=153 )
//        {
//            self.ContainerYposition.constant = -scrollOffset+70;
//
//
//        }
//        else
//        {
//            self.ContainerYposition.constant = -90;
//        }
//    }
//    else
//    {
//        if(scrollOffset <=153 )
//        {
//            self.ContainerYposition.constant = -scrollOffset+60;
//
//        }
//        else
//        {
//            self.ContainerYposition.constant = -190;
//        }
//
//    }
//
//    NSLog(@"%f",scrollOffset);
//}
-(IBAction)Inn1Action:(id)sender
{
    
    NSLog(@"Service Start");
    [AppCommon showLoading];
    
    [self buttonclicked:sender];
    NSLog(@"%@", self.Team1);
    [self setInningsBySelection1:@"1"];
    CommonArray = [[NSMutableArray alloc]init];
    CommonArray = BatsmanDetailsArray1;
    CommonArray2 = [[NSMutableArray alloc]init];
    CommonArray2 = BowlingDetailsArray1;
    
    //Wagon Wheel and pitchmap Details
    self.wwd1 = [[NSMutableArray alloc]init];
    self.ppd1 = [[NSMutableArray alloc]init];
    
    for(int i= 0 ;i<BatsmanDetailsArray1.count;i++)
    {
        playercode = [[BatsmanDetailsArray1 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray1 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelWebservice];
        
        [self.wwd1 addObject:dict];
        
        
        NSLog(@"Service  wwbat %d",i);
    }
    
    for(int i= 0 ;i<BatsmanDetailsArray1.count;i++)
    {
        playercode = [[BatsmanDetailsArray1 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray1 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.ppd1 addObject:dict];
        }
        NSLog(@"Service  pmbat %d",i);
        
    }
    
    self.Bwwd1 = [[NSMutableArray alloc]init];
    self.Bppd1 = [[NSMutableArray alloc]init];
    
    for(int i= 0 ;i<BowlingDetailsArray1.count;i++)
    {
        playercode = [[BowlingDetailsArray1 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray1 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelbowlWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bwwd1 addObject:dict];
        }
        NSLog(@"Service  wwbow %d",i);
    }
    
    for(int i= 0 ;i<BowlingDetailsArray1.count;i++)
    {
        playercode = [[BowlingDetailsArray1 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray1 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapbowlWebservice];
        
        
        //        if(i>BowlingDetailsArray1.count)
        //        {
        //            
        //        }
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bppd1 addObject:dict];
        }
        NSLog(@"Service  pmbow %d",i);
        
    }
    
    //Wagon Wheel and pitchmap Details end
    
    
    self.extrastypelbl.text = [ExtrasArray objectAtIndex:0];
    self.extraslbl.text = [ExtrasArray objectAtIndex:1];
    self.totallbl.text = [ExtrasArray objectAtIndex:2];
    self.wktsOverslbl.text = [ExtrasArray objectAtIndex:4];
    self.fallofWicketslbl.text = [fallOfWicketArray1 objectAtIndex:0];
    self.didNotbatlbl.text = [[didNotbatArray1 valueForKey:@"PlayerName"] objectAtIndex:0];
    
    
    //    self.wagonWheelDrawData = [[NSMutableArray alloc]init];
    //    self.pitchData = [[NSMutableArray alloc]init];
    
    
    
    
    self.wagonWheelDrawData = self.wwd1;
    self.pitchData = self.ppd1;
    
    self.wagonWheelDrawData2 = self.Bwwd1;
    self.pitchData2 = self.Bppd1;
    //    //    self.wagonWheelDrawData2 = [[NSMutableArray alloc]init];
    //    //    self.pitchData2 = [[NSMutableArray alloc]init];
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    selectedIndex =-1;
    lastIndex = NULL;
    
    [self.listTbl reloadData];
    [self.bowlingTbl reloadData];
    
    CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
    self.tableHeight.constant = height;
    [self.view layoutIfNeeded];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
    self.tableHeight2.constant = height1;
    [self.view layoutIfNeeded];
    
    
    NSLog(@"Service End");
    
    //[self.listTbl reloadData];
}

-(IBAction)Inn2Action:(id)sender
{
    [AppCommon showLoading];
    [self buttonclicked:sender];
    NSLog(@"%@", self.Team1);
    [self setInningsBySelection1:@"2"];
    CommonArray = [[NSMutableArray alloc]init];
    CommonArray = BatsmanDetailsArray2;
    CommonArray2 = [[NSMutableArray alloc]init];
    CommonArray2 = BowlingDetailsArray2;
    
    
    //Wagon Wheel and pitchmap Details
    self.wwd2 = [[NSMutableArray alloc]init];
    self.ppd2 = [[NSMutableArray alloc]init];
    
    
    for(int i= 0 ;i<BatsmanDetailsArray2.count;i++)
    {
        playercode = [[BatsmanDetailsArray2 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray2 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.wwd2 addObject:dict];
        }
        
    }
    
    for(int i= 0 ;i<BatsmanDetailsArray2.count;i++)
    {
        playercode = [[BatsmanDetailsArray2 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray2 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.ppd2 addObject:dict];
        }
        
    }
    
    
    self.Bwwd2 = [[NSMutableArray alloc]init];
    self.Bppd2 = [[NSMutableArray alloc]init];
    
    for(int i= 0 ;i<BowlingDetailsArray2.count;i++)
    {
        playercode = [[BowlingDetailsArray2 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray2 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelbowlWebservice];
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bwwd2 addObject:dict];
        }
        
    }
    
    for(int i= 0 ;i<BowlingDetailsArray2.count;i++)
    {
        playercode = [[BowlingDetailsArray2 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray2 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapbowlWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bppd2 addObject:dict];
        }
        
    }
    
    
    
    //Wagon Wheel and pitchmap Details end
    
    
    self.extrastypelbl.text = [ExtrasArray2 objectAtIndex:0];
    self.extraslbl.text = [ExtrasArray2 objectAtIndex:1];
    self.totallbl.text = [ExtrasArray2 objectAtIndex:2];
    self.wktsOverslbl.text = [ExtrasArray2 objectAtIndex:4];
    self.fallofWicketslbl.text = [fallOfWicketArray2 objectAtIndex:0];
    self.didNotbatlbl.text = [[didNotbatArray2 valueForKey:@"PlayerName"] objectAtIndex:0];
    
    
    //    self.wagonWheelDrawData = [[NSMutableArray alloc]init];
    //    self.pitchData = [[NSMutableArray alloc]init];
    
    
    
    
    self.wagonWheelDrawData = self.wwd2;
    self.pitchData = self.ppd2;
    
    self.wagonWheelDrawData2 = self.Bwwd2;
    self.pitchData2 = self.Bppd2;
    //    //    self.wagonWheelDrawData2 = [[NSMutableArray alloc]init];
    //    //    self.pitchData2 = [[NSMutableArray alloc]init];
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    selectedIndex =-1;
    lastIndex = NULL;
    
    [self.listTbl reloadData];
    [self.bowlingTbl reloadData];
    
    CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
    self.tableHeight.constant = height;
    [self.view layoutIfNeeded];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
    self.tableHeight2.constant = height1;
    [self.view layoutIfNeeded];
    
    
    //[self.listTbl reloadData];
}

-(IBAction)Inn3Action:(id)sender
{
    [AppCommon showLoading];
    [self buttonclicked:sender];
    NSLog(@"%@", self.Team1);
    [self setInningsBySelection1:@"3"];
    CommonArray = [[NSMutableArray alloc]init];
    CommonArray = BatsmanDetailsArray3;
    CommonArray2 = [[NSMutableArray alloc]init];
    CommonArray2 = BowlingDetailsArray3;
    
    
    //Wagon Wheel and pitchmap Details
    
    self.wwd3 = [[NSMutableArray alloc]init];
    self.ppd3 = [[NSMutableArray alloc]init];
    
    
    for(int i= 0 ;i<BatsmanDetailsArray3.count;i++)
    {
        playercode = [[BatsmanDetailsArray3 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray3 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.wwd3 addObject:dict];
        }
        
    }
    
    for(int i= 0 ;i<BatsmanDetailsArray3.count;i++)
    {
        playercode = [[BatsmanDetailsArray3 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray3 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.ppd3 addObject:dict];
        }
        
    }
    
    self.Bwwd3 = [[NSMutableArray alloc]init];
    self.Bppd3 = [[NSMutableArray alloc]init];
    
    for(int i= 0 ;i<BowlingDetailsArray3.count;i++)
    {
        playercode = [[BowlingDetailsArray3 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray3 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelbowlWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bwwd3 addObject:dict];
        }
        
    }
    
    for(int i= 0 ;i<BowlingDetailsArray3.count;i++)
    {
        playercode = [[BowlingDetailsArray3 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray3 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapbowlWebservice];
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bppd3 addObject:dict];
        }
    }
    
    
    
    //Wagon Wheel and pitchmap Details end
    
    self.extrastypelbl.text = [ExtrasArray3 objectAtIndex:0];
    self.extraslbl.text = [ExtrasArray3 objectAtIndex:1];
    self.totallbl.text = [ExtrasArray3 objectAtIndex:2];
    self.wktsOverslbl.text = [ExtrasArray3 objectAtIndex:4];
    self.fallofWicketslbl.text = [fallOfWicketArray3 objectAtIndex:0];
    self.didNotbatlbl.text = [[didNotbatArray3 valueForKey:@"PlayerName"] objectAtIndex:0];
    
    
    //    self.wagonWheelDrawData = [[NSMutableArray alloc]init];
    //    self.pitchData = [[NSMutableArray alloc]init];
    
    
    
    self.wagonWheelDrawData = self.wwd3;
    self.pitchData = self.ppd3;
    
    self.wagonWheelDrawData2 = self.Bwwd3;
    self.pitchData2 = self.Bppd3;
    //    //    self.wagonWheelDrawData2 = [[NSMutableArray alloc]init];
    //    //    self.pitchData2 = [[NSMutableArray alloc]init];
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    selectedIndex =-1;
    lastIndex = NULL;
    
    [self.listTbl reloadData];
    [self.bowlingTbl reloadData];
    
    CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
    self.tableHeight.constant = height;
    [self.view layoutIfNeeded];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
    self.tableHeight2.constant = height1;
    [self.view layoutIfNeeded];
    
    
    //[self.listTbl reloadData];
}


-(IBAction)Inn4Action:(id)sender
{
    [AppCommon showLoading];
    [self buttonclicked:sender];
    NSLog(@"%@", self.Team1);
    [self setInningsBySelection1:@"4"];
    CommonArray = [[NSMutableArray alloc]init];
    CommonArray = BatsmanDetailsArray4;
    CommonArray2 = [[NSMutableArray alloc]init];
    CommonArray2 = BowlingDetailsArray4;
    
    
    //Wagon Wheel and pitchmap Details
    self.wwd4 = [[NSMutableArray alloc]init];
    self.ppd4 = [[NSMutableArray alloc]init];
    
    
    for(int i= 0 ;i<BatsmanDetailsArray4.count;i++)
    {
        playercode = [[BatsmanDetailsArray4 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray4 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        dict = [self WagonWheelWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.wwd4 addObject:dict];
        }
        
    }
    
    for(int i= 0 ;i<BatsmanDetailsArray4.count;i++)
    {
        playercode = [[BatsmanDetailsArray4 valueForKey:@"Batsmencode"] objectAtIndex:i];
        innno = [[BatsmanDetailsArray4 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.ppd4 addObject:dict];
        }
        
    }
    
    self.Bwwd4 = [[NSMutableArray alloc]init];
    self.Bppd4 = [[NSMutableArray alloc]init];
    
    for(int i= 0 ;i<BowlingDetailsArray4.count;i++)
    {
        playercode = [[BowlingDetailsArray4 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray4 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self WagonWheelbowlWebservice];
        
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bwwd4 addObject:dict];
        }
        
    }
    
    for(int i= 0 ;i<BowlingDetailsArray4.count;i++)
    {
        playercode = [[BowlingDetailsArray4 valueForKey:@"BowlerCode"] objectAtIndex:i];
        innno = [[BowlingDetailsArray4 valueForKey:@"Inningsno"] objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [self PitchmapbowlWebservice];
        if(![dict isEqual:[NSNull null]])
        {
            [self.Bppd4 addObject:dict];
        }
        
    }
    
    
    //Wagon Wheel and pitchmap Details end
    
    self.extrastypelbl.text = [ExtrasArray4 objectAtIndex:0];
    self.extraslbl.text = [ExtrasArray4 objectAtIndex:1];
    self.totallbl.text = [ExtrasArray4 objectAtIndex:2];
    self.wktsOverslbl.text = [ExtrasArray4 objectAtIndex:4];
    self.fallofWicketslbl.text = [fallOfWicketArray4 objectAtIndex:0];
    self.didNotbatlbl.text = [[didNotbatArray4 valueForKey:@"PlayerName"] objectAtIndex:0];
    
    
    //    self.wagonWheelDrawData = [[NSMutableArray alloc]init];
    //    self.pitchData = [[NSMutableArray alloc]init];
    
    
    
    
    self.wagonWheelDrawData = self.wwd4;
    self.pitchData = self.ppd4;
    
    self.wagonWheelDrawData2 = self.Bwwd4;
    self.pitchData2 = self.Bppd4;
    //    //    self.wagonWheelDrawData2 = [[NSMutableArray alloc]init];
    //    //    self.pitchData2 = [[NSMutableArray alloc]init];
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    selectedIndex =-1;
    lastIndex = NULL;
    
    [self.listTbl reloadData];
    [self.bowlingTbl reloadData];
    
    CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
    self.tableHeight.constant = height;
    [self.view layoutIfNeeded];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
    self.tableHeight2.constant = height1;
    [self.view layoutIfNeeded];
    
    
    //[self.listTbl reloadData];
}






-(IBAction)Team1Action:(id)sender
{
    //[AppCommon showLoading];
    [self buttonclicked:sender];
    NSLog(@"%@", self.Team1);
    [self setInningsBySelection:@"1"];
    CommonArray = [[NSMutableArray alloc]init];
    CommonArray = BatsmanDetailsArray1;
    CommonArray2 = [[NSMutableArray alloc]init];
    CommonArray2 = BowlingDetailsArray1;
    
    isSelected = NO;
    
    self.extrastypelbl.text = [ExtrasArray objectAtIndex:0];
    self.extraslbl.text = [ExtrasArray objectAtIndex:1];
    self.totallbl.text = [ExtrasArray objectAtIndex:2];
    self.wktsOverslbl.text = [ExtrasArray objectAtIndex:4];
    self.fallofWicketslbl.text = [fallOfWicketArray1 objectAtIndex:0];
    self.didNotbatlbl.text = [[didNotbatArray1 valueForKey:@"PlayerName"] objectAtIndex:0];
    
    innno =@"1";
    
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    selectedIndex =-1;
    lastIndex = NULL;
    
    [self.listTbl reloadData];
    [self.bowlingTbl reloadData];
    
    CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
    self.tableHeight.constant = height;
    [self.view layoutIfNeeded];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
    self.tableHeight2.constant = height1;
    [self.view layoutIfNeeded];
    
    //[self.StickyTeam1 sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    //[self.listTbl reloadData];
}

-(IBAction)Team2Action:(id)sender
{
    // [AppCommon showLoading];
    
    [self buttonclicked:sender];
    [self setInningsBySelection:@"2"];
    CommonArray = [[NSMutableArray alloc]init];
    CommonArray = BatsmanDetailsArray2;
    CommonArray2 = [[NSMutableArray alloc]init];
    CommonArray2 = BowlingDetailsArray2;
    
    
    isSelected = NO;
    
    self.extrastypelbl.text = [ExtrasArray2 objectAtIndex:0];
    self.extraslbl.text = [ExtrasArray2 objectAtIndex:1];
    self.totallbl.text = [ExtrasArray2 objectAtIndex:2];
    self.wktsOverslbl.text = [ExtrasArray2 objectAtIndex:4];
    
    self.didNotbatlbl.text = [[didNotbatArray2 valueForKey:@"PlayerName"] objectAtIndex:0];
    self.fallofWicketslbl.text = [fallOfWicketArray2 objectAtIndex:0];
    
    innno =@"2";
    
    
   
    
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    selectedIndex =-1;
    lastIndex = NULL;
    [self.listTbl reloadData];
    [self.bowlingTbl reloadData];
    CGFloat height = MIN(self.view.bounds.size.height, self.listTbl.contentSize.height);
    self.tableHeight.constant = height;
    [self.view layoutIfNeeded];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.bowlingTbl.contentSize.height);
    self.tableHeight2.constant = height1;
    [self.view layoutIfNeeded];
    
    //[self.StickyTeam2 sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}
-(IBAction)didClickAllBatting:(id)sender
{
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.listTbl reloadData];
}


-(IBAction)didClickOnesBatting:(id)sender
{
    
    
    isOnes = YES;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.listTbl reloadData];
}
-(IBAction)didClickwicketBatting:(id)sender
{
    
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = YES;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.listTbl reloadData];
}

-(IBAction)didClicktwosBatting:(id)sender
{
    
    
    isOnes = NO;
    isTwos = YES;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.listTbl reloadData];
}

-(IBAction)didClickthreeBatting:(id)sender
{
    
    isOnes = NO;
    isTwos = NO;
    isThrees = YES;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    //[self.listTbl reloadData];
}

-(IBAction)didClickfourssBatting:(id)sender
{
    
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = YES;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.listTbl reloadData];
}

-(IBAction)didClicksixesBatting:(id)sender
{
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = YES;
    isWkt = NO;
    isDotBall = NO;
    
    
    [self drawWagonwheel];
    [self drawPitchmap];
    //[self.listTbl reloadData];
}

-(IBAction)didClickdotsBatting:(id)sender
{
    
    
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = YES;
   
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.listTbl reloadData];
}

-(IBAction)didClickOnesbowlingTbl:(id)sender
{
    
    isOnes = YES;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.bowlingTbl reloadData];
}
-(IBAction)didClickwicketbowlingTbl:(id)sender
{
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = YES;
    isDotBall = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.bowlingTbl reloadData];
}

-(IBAction)didClicktwosbowlingTbl:(id)sender
{
    
    
    isOnes = NO;
    isTwos = YES;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.bowlingTbl reloadData];
}

-(IBAction)didClickthreebowlingTbl:(id)sender
{
    
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = YES;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.bowlingTbl reloadData];
}

-(IBAction)didClickfourssbowlingTbl:(id)sender
{
    
    
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = YES;
    isSixes = NO;
    isWkt = NO;
    isDotBall = NO;
    
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.bowlingTbl reloadData];
}

-(IBAction)didClicksixesbowlingTbl:(id)sender
{
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = YES;
    isWkt = NO;
    isDotBall = NO;
    isAll = NO;
    
    [self drawWagonwheel];
    [self drawPitchmap];
    //[self.bowlingTbl reloadData];
}

-(IBAction)didClickdotsbowlingTbl:(id)sender
{
    
    
    
    isOnes = NO;
    isTwos = NO;
    isThrees = NO;
    isFours = NO;
    isSixes = NO;
    isWkt = NO;
    isDotBall = YES;
    
    
    [self drawWagonwheel];
    [self drawPitchmap];
    //[self.bowlingTbl reloadData];
}
-(IBAction)didClickAllbowlingTbl:(id)sender
{
    
    
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    
    [self drawWagonwheel];
    [self drawPitchmap];
    
    //[self.bowlingTbl reloadData];
}



-(void) setInningsBySelection1: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.Inn1];
    [self setInningsButtonUnselect:self.Inn2];
    [self setInningsButtonUnselect:self.Inn3];
    [self setInningsButtonUnselect:self.Inn4];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.Inn1];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.Inn2];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.Inn3];
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.Inn4];
    }
    
    
    
}






-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.Team1];
    [self setInningsButtonUnselect:self.Team2];
    
    
    [self setInningsButtonUnselect:self.StickyTeam1];
    [self setInningsButtonUnselect:self.StickyTeam2];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.Team1];
        [self setInningsButtonSelect:self.StickyTeam1];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.Team2];
        [self setInningsButtonSelect:self.StickyTeam2];
    }
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    /*
     CGFloat red   = ((baseColor1 & 0xFF0000) >> 16) / 255.0f;
     CGFloat green = ((baseColor1 & 0x00FF00) >>  8) / 255.0f;
     CGFloat blue  =  (baseColor1 & 0x0000FF) / 255.0f;
     */[scanner scanHexInt:&hexint];
    
    
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255.0f
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255.0f
                     blue:((CGFloat) (hexint & 0xFF))/255.0f
                    alpha:1.0f];
    
    return color;
}

-(UIColor *)colorWithHexString1:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
//    UIColor *extrasBrushBG = [self colorWithHexString : @"#2CA7DB"];
    UIColor *extrasBrushBG = [self colorWithHexString : @"#0066cc"];

    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2C2C2C"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}




-(void)ScoreWebservice
{
    
    if([COMMON isInternetReachable])
    {
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",ScorecardKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *competition = @"";
        NSString *teamcode = @"";
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(competition)   [dic    setObject:competition     forKey:@"Competitioncode"];
        if(teamcode)   [dic    setObject:teamcode     forKey:@"Teamcode"];
        if(self.matchCode)   [dic    setObject:self.matchCode     forKey:@"MatchCode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                
                //first button details
                NSMutableArray *array1 = [[NSMutableArray alloc]init];
                array1 = [responseObject valueForKey:@"firstlstFallofWickets"];
                
                
                BatsmanDetailsArray1 = [[NSMutableArray alloc]init];
                BatsmanDetailsArray1 = [[array1 valueForKey:@"lstSCBatsmanDetails"] objectAtIndex:0];
                
                
                ExtrasArray = [[NSMutableArray alloc]init];
                ExtrasArray = [[array1 valueForKey:@"SCExtras"] objectAtIndex:0];
                
                didNotbatArray1 = [[NSMutableArray alloc]init];
                didNotbatArray1 = [[array1 valueForKey:@"lstSCDidNotBat"] objectAtIndex:0];
                
                fallOfWicketArray1 = [[NSMutableArray alloc]init];
                fallOfWicketArray1 = [[array1 valueForKey:@"SCFallofWickets"] objectAtIndex:0];
                
                BowlingDetailsArray1 = [[NSMutableArray alloc]init];
                BowlingDetailsArray1 = [[array1 valueForKey:@"lstSEBowlerDetails"] objectAtIndex:0];
                
                matchDetailsImageArray = [[NSMutableArray alloc]init];
                matchDetailsImageArray = [[array1 valueForKey:@"lstMatchDetails"] objectAtIndex:0];
                
                
                
                
                
                self.competitionTypelbl.text = [[matchDetailsImageArray valueForKey:@"Tournament"] objectAtIndex:0];
                self.resultlbl.text = [NSString stringWithFormat:@" %@ " ,  [[self.matchDetails valueForKey:@"result"] objectAtIndex:0]];
                
                self.teamAlbl.text = [[matchDetailsImageArray valueForKey:@"BattingTeamName"] objectAtIndex:0];
                self.teamBlbl.text = [[matchDetailsImageArray valueForKey:@"BowlingTeamName"] objectAtIndex:0];
                
                //self.teamAScorelbl.text = [[matchDetailsImageArray valueForKey:@"Inn1Score"] objectAtIndex:0];
                // self.teamBScorelbl.text = [[matchDetailsImageArray valueForKey:@"Inn2Score"] objectAtIndex:0];
                self.groundlbl.text = [[matchDetailsImageArray valueForKey:@"Venue"] objectAtIndex:0];
                
                
                self.teamAScorelbl.text = [[matchDetailsImageArray valueForKey:@"TeamAScore"] objectAtIndex:0];
                self.teamBScorelbl.text = [[matchDetailsImageArray valueForKey:@"TeamBScore"] objectAtIndex:0];
                self.groundlbl.text = [[matchDetailsImageArray valueForKey:@"Venue"] objectAtIndex:0];
                self.resultlbl.text = [[matchDetailsImageArray valueForKey:@"MatchResult"] objectAtIndex:0];
                
                
                [self.Team1 setTitle:[[matchDetailsImageArray valueForKey:@"BattingTeamName"] objectAtIndex:0] forState:UIControlStateNormal];
                [self.Team2 setTitle:[[matchDetailsImageArray valueForKey:@"BowlingTeamName"] objectAtIndex:0] forState:UIControlStateNormal];
                
                [self.StickyTeam1 setTitle:[[matchDetailsImageArray valueForKey:@"BattingTeamName"] objectAtIndex:0] forState:UIControlStateNormal];
                [self.StickyTeam2 setTitle:[[matchDetailsImageArray valueForKey:@"BowlingTeamName"] objectAtIndex:0] forState:UIControlStateNormal];
                
                //                [self.Inn1 setTitle:[NSString stringWithFormat:@"Inn1-%@" , [[self.matchDetails valueForKey:@"team1"] objectAtIndex:0]] forState:UIControlStateNormal];
                //                [self.Inn2 setTitle:[NSString stringWithFormat:@"Inn2-%@" ,[[self.matchDetails valueForKey:@"team2"] objectAtIndex:0]] forState:UIControlStateNormal];
                //                [self.Inn3 setTitle:[NSString stringWithFormat:@"Inn3-%@" , [[self.matchDetails valueForKey:@"team1"] objectAtIndex:0]] forState:UIControlStateNormal];
                //                [self.Inn4 setTitle:[NSString stringWithFormat:@"Inn4-%@" ,[[self.matchDetails valueForKey:@"team2"] objectAtIndex:0]] forState:UIControlStateNormal];
                
                NSString * imgStr1 = ([[matchDetailsImageArray objectAtIndex:0] valueForKey:@"BattingTeamlogo"]==[NSNull null])?@"":[[matchDetailsImageArray objectAtIndex:0] valueForKey:@"BattingTeamlogo"];
                NSString *teamAString = [NSString stringWithFormat:@"%@",imgStr1];
                
                NSString * imgStr2 = ([[matchDetailsImageArray objectAtIndex:0] valueForKey:@"BowlingTeamlogo"]==[NSNull null])?@"":[[matchDetailsImageArray objectAtIndex:0] valueForKey:@"BowlingTeamlogo"];
                NSString *teamBString = [NSString stringWithFormat:@"%@",imgStr2];
                
//                [self downloadImageWithURL:[NSURL URLWithString:imgStr1] completionBlock:^(BOOL succeeded, UIImage *image) {
//                    if (succeeded) {
//                        // change the image in the cell
//                        self.teamAlogo.image = image;
//
//                        // cache the image for use later (when scrolling up)
//                        self.teamAlogo.image = image;
//                    }
//                    else
//                    {
//                        self.teamAlogo.image = [UIImage imageNamed:@"no-image"];
//                    }
//                }];
                [self.teamAlogo sd_setImageWithURL:[NSURL URLWithString:imgStr1] placeholderImage:[UIImage imageNamed:@"no-image"]];
                
//                [self downloadImageWithURL:[NSURL URLWithString:imgStr2] completionBlock:^(BOOL succeeded, UIImage *image) {
//                    if (succeeded) {
//                        // change the image in the cell
//                        self.teamBlogo.image = image;
//
//                        // cache the image for use later (when scrolling up)
//                        self.teamBlogo.image = image;
//                    }
//                    else
//                    {
//                        self.teamBlogo.image = [UIImage imageNamed:@"no-image"];
//                    }
//                }];
                [self.teamBlogo sd_setImageWithURL:[NSURL URLWithString:imgStr2] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
                ScoreCardHeader *header = [[ScoreCardHeader alloc]init];
                header.matchDetailsArray = matchDetailsImageArray;
            
               // [self toggle:nil];
                
                
                
                
                //second button details
                
                NSMutableArray *array2 = [[NSMutableArray alloc]init];
                array2 = [responseObject valueForKey:@"secondlstFallofWickets"];
                
                BatsmanDetailsArray2 = [[NSMutableArray alloc]init];
                BatsmanDetailsArray2 = [[array2 valueForKey:@"lstSCBatsmanDetails"] objectAtIndex:0];
                
                
                ExtrasArray2 = [[NSMutableArray alloc]init];
                ExtrasArray2 = [[array2 valueForKey:@"SCExtras"] objectAtIndex:0];
                
                didNotbatArray2 = [[NSMutableArray alloc]init];
                didNotbatArray2 = [[array2 valueForKey:@"lstSCDidNotBat"] objectAtIndex:0];
                
                fallOfWicketArray2 = [[NSMutableArray alloc]init];
                fallOfWicketArray2 = [[array2 valueForKey:@"SCFallofWickets"] objectAtIndex:0];
                
                BowlingDetailsArray2 = [[NSMutableArray alloc]init];
                BowlingDetailsArray2 = [[array2 valueForKey:@"lstSEBowlerDetails"] objectAtIndex:0];
                
                //third button details
                
                if(![[responseObject valueForKey:@"thirdlstFallofWickets"] isEqual:[NSNull null]])
                {
                    NSMutableArray *array3 = [[NSMutableArray alloc]init];
                    array3 = [responseObject valueForKey:@"thirdlstFallofWickets"];
                    
                    if(![[array3 valueForKey:@"lstSCBatsmanDetails"] isEqual:[NSNull null]])
                    {
                        
                        BatsmanDetailsArray3 = [[NSMutableArray alloc]init];
                        BatsmanDetailsArray3 = [[array3 valueForKey:@"lstSCBatsmanDetails"] objectAtIndex:0];
                        
                        
                        ExtrasArray3 = [[NSMutableArray alloc]init];
                        ExtrasArray3 = [[array3 valueForKey:@"SCExtras"] objectAtIndex:0];
                        
                        didNotbatArray3 = [[NSMutableArray alloc]init];
                        didNotbatArray3 = [[array3 valueForKey:@"lstSCDidNotBat"] objectAtIndex:0];
                        
                        fallOfWicketArray3 = [[NSMutableArray alloc]init];
                        fallOfWicketArray3 = [[array3 valueForKey:@"SCFallofWickets"] objectAtIndex:0];
                        
                        BowlingDetailsArray3 = [[NSMutableArray alloc]init];
                        BowlingDetailsArray3 = [[array3 valueForKey:@"lstSEBowlerDetails"] objectAtIndex:0];
                    }
                }
                
                
                //fourth button details
                
                
                if(![[responseObject valueForKey:@"fouthlstFallofWickets"] isEqual:[NSNull null]])
                {
                    NSMutableArray *array4 = [[NSMutableArray alloc]init];
                    array4 = [responseObject valueForKey:@"fouthlstFallofWickets"];
                    
                    if(![[array4 valueForKey:@"lstSCBatsmanDetails"] isEqual:[NSNull null]])
                    {
                        
                        BatsmanDetailsArray4 = [[NSMutableArray alloc]init];
                        BatsmanDetailsArray4 = [[array4 valueForKey:@"lstSCBatsmanDetails"] objectAtIndex:0];
                        
                        
                        ExtrasArray4 = [[NSMutableArray alloc]init];
                        ExtrasArray4 = [[array4 valueForKey:@"SCExtras"] objectAtIndex:0];
                        
                        didNotbatArray4 = [[NSMutableArray alloc]init];
                        didNotbatArray4 = [[array4 valueForKey:@"lstSCDidNotBat"] objectAtIndex:0];
                        
                        fallOfWicketArray4 = [[NSMutableArray alloc]init];
                        fallOfWicketArray4 = [[array4 valueForKey:@"SCFallofWickets"] objectAtIndex:0];
                        
                        BowlingDetailsArray4 = [[NSMutableArray alloc]init];
                        BowlingDetailsArray4 = [[array4 valueForKey:@"lstSEBowlerDetails"] objectAtIndex:0];
                    }
                }
                
                array = [[NSMutableArray alloc]init];
                array = [responseObject valueForKey:@"lstSCInnsDetails"];
                if(array.count==2)
                {
                    self.headerUIView.hidden = NO;
                    self.headerUIViewTestmatch.hidden = YES;
                    //self.teamAScorelbl.text = [[self.matchDetails valueForKey:@"Inn1Score"] objectAtIndex:0];
                    // self.teamBScorelbl.text = [[self.matchDetails valueForKey:@"Inn2Score"] objectAtIndex:0];
                    isTestmatch=NO;
                    [self.Team1 sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                }
                if(array.count==3)
                {
                    self.headerUIView.hidden = YES;
                    self.headerUIViewTestmatch.hidden = NO;
                    [self.Inn4 setUserInteractionEnabled:NO];
                    [self.Inn4 setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
                    //self.teamAScorelbl.text = [[self.matchDetails valueForKey:@"Inn1Score"] objectAtIndex:0];
                    //self.teamBScorelbl.text = [[self.matchDetails valueForKey:@"Inn2Score"] objectAtIndex:0];
                    //self.teamAinn2Scorelbl.text = [[self.matchDetails valueForKey:@"Inn3Score"] objectAtIndex:0];
                    //self.teamBinn2Scorelbl.text = [[self.matchDetails valueForKey:@"Inn4Score"] objectAtIndex:0];
                    isTestmatch=YES;
                    [self.Inn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
                
                if(array.count==4)
                {
                    self.headerUIView.hidden = YES;
                    self.headerUIViewTestmatch.hidden = NO;
                    //self.teamAScorelbl.text = [[self.matchDetails valueForKey:@"Inn1Score"] objectAtIndex:0];
                    //self.teamBScorelbl.text = [[self.matchDetails valueForKey:@"Inn2Score"] objectAtIndex:0];
                    //self.teamAinn2Scorelbl.text = [[self.matchDetails valueForKey:@"Inn3Score"] objectAtIndex:0];
                    //self.teamBinn2Scorelbl.text = [[self.matchDetails valueForKey:@"Inn4Score"] objectAtIndex:0];
                    isTestmatch=YES;
                    [self.Inn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
                
                
                
                
                
                [self.listTbl reloadData];
                
                
                //batting KPI
                appDel.indexPath = 0;
                appDel.Currentmatchcode = self.matchCode;
                appDel.Scorearray = self.matchDetails;
                appDel.BatsmanDetailsArray1 = BatsmanDetailsArray1;
                appDel.BatsmanDetailsArray2 = BatsmanDetailsArray2;
                appDel.BatsmanDetailsArray3 = BatsmanDetailsArray3;
                appDel.BatsmanDetailsArray4 = BatsmanDetailsArray4;
                appDel.inningsDetailsArray = array;
                
                //bowling KPI
                
                appDel.indexPath2 = 1;
                appDel.BowlingDetailsArray1 = BowlingDetailsArray1;
                appDel.BowlingDetailsArray2 = BowlingDetailsArray2;
                appDel.BowlingDetailsArray3 = BowlingDetailsArray3;
                appDel.BowlingDetailsArray4 = BowlingDetailsArray4;
                //appDel.inningsDetailsArray = array;
                
                
                //Fielding
                
                NSString *matchHeaderDetail =[NSString stringWithFormat:@"%@ Vs %@ - %@",self.teamAlbl.text,self.teamBlbl.text,self.groundlbl.text];
                appDel.matchHeaderDetails = matchHeaderDetail;
                appDel.TeamA = self.teamAlbl.text;
                appDel.TeamB = self.teamBlbl.text;
                appDel.isTest = isTestmatch;
                
                
                [self.ExtrasBtn addTarget:self action:@selector(myExtras:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            
            
        }];
    }
}

-(NSMutableDictionary *)WagonWheelWebservice
{
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    
    [objWebservice BattingWagonWheel:ScorecardWagonKey  :playercode :self.matchCode :innno success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        
        
        if(responseObject >0)
        {
            
            if(isList)
            {
            [dic1 setValue:[responseObject valueForKey:@"BattingSpiderWagonWheelValues"] forKey:@"Value"];
            }
            else
            {
                [dic1 setValue:[responseObject valueForKey:@"BowlingSpiderWagonWheelValues"] forKey:@"Value"];
            }
            [dic1 setValue:playercode forKey:@"playercode"];
            
            
            //self.wagonWheelDrawData = [responseObject valueForKey:@"BattingSpiderWagonWheelValues"];
            
            self.selectBattingStyle = [responseObject valueForKey:@"BattingStyle"];
            
            NSLog(@"%@", self.wagonWheelDrawData);
            
            self.wagonWheelDrawData  =[[NSMutableArray alloc]init];
            self.wwd1  =[[NSMutableArray alloc]init];
            if(![dic1 isEqual:[NSNull null]])
            {
                [self.wwd1 addObject:dic1];
                self.wagonWheelDrawData = self.wwd1;
                [self drawWagonwheel];
                
            }

            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
    }];
    return dic1;
}
-(NSMutableDictionary *)WagonWheelbowlWebservice
{
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    
    [objWebservice BattingWagonWheel:ScorecardWagonKey  :playercode :self.matchCode :innno success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            
            [dic1 setValue:[responseObject valueForKey:@"BowlingSpiderWagonWheelValues"] forKey:@"Value"];
            [dic1 setValue:playercode forKey:@"playercode"];
            
            
            
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
    }];
    
    return dic1;
}


-(NSMutableDictionary * )PitchmapWebservice
{
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    
    [objWebservice Battingpitchmap :ScorecardPitchmapKey  :playercode :self.matchCode :innno success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            if(isList)
            {
            [dic1 setValue:[responseObject valueForKey:@"PitchMapValuesBatting"] forKey:@"Value"];
            }
            else
            {
                [dic1 setValue:[responseObject valueForKey:@"PitchMapValuesBowling"] forKey:@"Value"];
            }
            [dic1 setValue:playercode forKey:@"playercode"];
            [dic1 setValue:[responseObject valueForKey:@"BattingStyle"] forKey:@"Battingstyle"];
            
            
            self.pitchData  =[[NSMutableArray alloc]init];
            self.ppd1  =[[NSMutableArray alloc]init];
            if(![dic1 isEqual:[NSNull null]])
            {
                    [self.ppd1 addObject:dic1];
                    self.pitchData = self.ppd1;
                    [self drawPitchmap];
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        
    }];
    return dic1;
}


-(NSMutableDictionary *)PitchmapbowlWebservice
{
    objWebservice = [[WebService alloc]init];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    [objWebservice Bowlingpitchmap :@"FETCH_SCORECARD_PITCHMAP_BOWLING"  :playercode :self.matchCode :innno success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            [dic1 setValue:[responseObject valueForKey:@"PitchMapValuesBowling"] forKey:@"Value"];
            [dic1 setValue:playercode forKey:@"playercode"];
            
            self.pitchData  =[[NSMutableArray alloc]init];
            self.ppd1  =[[NSMutableArray alloc]init];
            if(![dic1 isEqual:[NSNull null]])
            {
                [self.ppd1 addObject:dic1];
                self.pitchData = self.ppd1;
                [self drawPitchmap];
            }
            
            
        }
        
        [AppCommon hideLoading];
         
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
         
        
    }];
    
    return dic1;
    
}




-(IBAction)didClickBackBtn:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) clearValues{
    
    ThirdmanCountRun = 0;
    pointRun = 0;
    coverRun = 0;
    longoffRun = 0;
    longonRun = 0;
    midWicketRun = 0;
    squarelegRun = 0;
    finelegRun = 0;
    
    
    ThirdmanCount = 0;
    pointCount = 0;
    coverCount = 0;
    longoffCount = 0;
    longonCount = 0;
    midWicketCount = 0;
    squarelegCount = 0;
    finelegCount = 0;
    
    
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
    
    
    ones = 0;
    twos = 0;
    threes = 0;
    fours = 0;
    sixes = 0;
    
    
}

-(void)drawSpiderWagonLine{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    ScoreCardCell *cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
    for(int i=0;self.wagonWheelDrawData.count>i;i++)
    {
        for (CALayer *layer in self.ww.layer.sublayers) {
            if ([layer.name isEqualToString:@"DrawLine"]) {
                [layer removeFromSuperlayer];
                break;
            }
        }
    }
    
    
    //[self HideLable];
    int x1position;
    int y1position;
    int x2position;
    int y2position;
    
    int BASE_X = 280;
    
    
    for(int i=0; i< self.wagonWheelDrawData.count;i++)
    {
        
        
        
        if(IS_IPHONE_DEVICE)
        {
            x1position = [[[self.wagonWheelDrawData valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
            y1position = [[[self.wagonWheelDrawData valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
            x2position  =[[[self.wagonWheelDrawData valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
            y2position  =[[[self.wagonWheelDrawData valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
        }
        
        else
        {
            x1position = [[[self.wagonWheelDrawData valueForKey:@"WWX1"] objectAtIndex:i] intValue];
            y1position = [[[self.wagonWheelDrawData valueForKey:@"WWY1"] objectAtIndex:i] intValue];
            x2position  =[[[self.wagonWheelDrawData valueForKey:@"WWX2"] objectAtIndex:i] intValue];
            y2position  =[[[self.wagonWheelDrawData valueForKey:@"WWY2"] objectAtIndex:i] intValue];
            
        }
        
        self.selectRuns =([[[self.wagonWheelDrawData valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[self.wagonWheelDrawData valueForKey:@"Runs"] objectAtIndex:i];
      
        
        
        int Xposition = x1position;
        int Yposition = y1position;
        
        
        CGMutablePathRef straightLinePath = CGPathCreateMutable();
        CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
        CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:cell.WagonImg.bounds];
        //[shapeLayer setPosition:self.center];
        shapeLayer.path = straightLinePath;
        UIColor *fillColor = [UIColor redColor];
        shapeLayer.fillColor = fillColor.CGColor;
        
        
        
        
        if ([self.selectRuns isEqualToString: @"1"]) {
            
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
            
        }else if ([self.selectRuns isEqualToString: @"2"]){
            strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
            
        }else if ([self.selectRuns isEqualToString: @"3"]){
            strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
            
        }else if ([self.selectRuns isEqualToString: @"4"]){
            strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
            
        }else if ([self.selectRuns isEqualToString: @"5"]){
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
            
        }else if ([self.selectRuns isEqualToString: @"6"]){
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
            
        }else if ([self.selectRuns isEqualToString: @"0"]){
            
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            
        }
        //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
        //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
        //        }
        //
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.fillRule = kCAFillRuleNonZero;
        shapeLayer.name = @"DrawLine";
        [self.ww.layer addSublayer:shapeLayer];
        
        //}
        
    }
}

//----------- Video
- (IBAction)onClickCloseVideo:(id)sender {
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];
    [self.avPlayerViewController.view removeFromSuperview];
    self.avPlayer = NULL;
    
    _rootVideoView.hidden = YES;
    
    
    
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return videoURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    BallsInVideosCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ballsInVideosCVC" forIndexPath:indexPath];
    
    cell.ballLbl.layer.masksToBounds = true;
    cell.ballLbl.clipsToBounds = true;
    cell.ballLbl.layer.cornerRadius = cell.ballLbl.frame.size.width/2;
    
    
    
    cell.ballLbl.text = [NSString stringWithFormat:@"%ld",((long)indexPath.row+1)];
    
    if(selectedVideo == indexPath.row){
        
        cell.ballLbl.backgroundColor = [UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        cell.ballLbl.textColor = [UIColor whiteColor];
        
    }else{
        cell.ballLbl.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(221/255.0f) blue:(221/255.0f) alpha:1.0f];
        cell.ballLbl.textColor = [UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        
        
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    selectedVideo = (int) indexPath.row;
    
    NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:indexPath.row];
    NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
    
    
    
    NSURL *videoURL = [NSURL URLWithString:url];
    
    [self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self.avPlayer pause];
    [self.avPlayerViewController.view removeFromSuperview];
    self.avPlayer = NULL;
    
    
    self.avPlayer = [AVPlayer playerWithURL:videoURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayerViewController.player ];
    
    
    self.avPlayerViewController = [AVPlayerViewController new];
    self.avPlayerViewController.player = self.avPlayer;
    self.avPlayerViewController.view.frame = _videoView.bounds;
    [_videoView addSubview:self.avPlayerViewController.view];
    
    [self.avPlayer play];
    
    [self.ballsColView reloadData];
    
}

-(void)loadVideoPlayer1: (NSString *) playercode : (NSString *) value: (NSString *) batOrBowl innings:(NSString*)innNo :(NSString*)TYPE
{
    //NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
    VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc]init];
    videoPlayerVC = (VideoPlayerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
    videoPlayerVC.MatchCode = self.matchCode;
    videoPlayerVC.PlayerCode = playercode;
    videoPlayerVC.VideoValue = value;
    videoPlayerVC.Innings = innNo;
    videoPlayerVC.Type = batOrBowl;
    [self.navigationController presentViewController:videoPlayerVC animated:YES completion:nil];
    //[self.navigationController popToViewController:videoPlayerVC animated:YES];
}

-(void)loadVideoPlayer: (NSString *) playercode : (NSString *) value: (NSString *) batOrBowl innings:(NSString*)innNo
{
    //NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
    VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc]init];
    videoPlayerVC = (VideoPlayerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
    videoPlayerVC.MatchCode = self.matchCode;
    videoPlayerVC.PlayerCode = playercode;
    videoPlayerVC.VideoValue = value;
    videoPlayerVC.Innings = innNo;
    videoPlayerVC.Type = batOrBowl;
    [self.navigationController presentViewController:videoPlayerVC animated:YES completion:nil];
    //[self.navigationController popToViewController:videoPlayerVC animated:YES];
}



//GETSCORECARDVIDEOSFILEPATH/' + BatsmanCode + '/' + $scope.MatchCode + '/' + $scope.DefaultInn + '/' + value + '/' + batorbowl

-(void) loadVideoPaths : (NSString *) batsmanCode : (NSString *) value: (NSString *) batOrBowl
{
    
    [AppCommon showLoading];
    
    
    [objWebservice GetVideoPathFile :GetVideoFilePath  :batsmanCode :self.matchCode : innno :value : batOrBowl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setDictionary:responseObject];
            
            videoURLArray= [[NSMutableArray alloc] init];
            videoURLArray =  [dic1 valueForKey:@"lstScoreCardVideoFilePathValuesRuns"];
            
            if(videoURLArray.count >0){
                selectedVideo = 0;
                //                self.rootVideoView.hidden = NO;
                //                [self.ballsColView reloadData];
                
                
                NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
                NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
                
                
                
                NSURL *videoURL = [NSURL URLWithString:url];
                
                [self.avPlayer seekToTime:CMTimeMake(0, 1)];
                [self.avPlayer pause];
                [self.avPlayerViewController.view removeFromSuperview];
                self.avPlayer = NULL;
                
                
                self.avPlayer = [AVPlayer playerWithURL:videoURL];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayerViewController.player ];
                
                
                //                self.avPlayerViewController = [AVPlayerViewController new];
                //                self.avPlayerViewController.player = self.avPlayer;
                //                self.avPlayerViewController.view.frame = _videoView.bounds;
                //                [_videoView addSubview:self.avPlayerViewController.view];
                //
                //                [self.avPlayer play];
                
                
            }
            //[self setDataDictInTableView: dic1];
            
        }
        
        [AppCommon hideLoading];
        self.view.userInteractionEnabled = true;
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        //NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        self.view.userInteractionEnabled = true;
    }];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    
    if((selectedVideo+1)<videoURLArray.count){
        selectedVideo = selectedVideo +1;
        
        [self.ballsColView reloadData];
        
        NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
        NSString *url = [playerVdo valueForKey:@"VIDEOFILE"];
        
        
        
        NSURL *videoURL = [NSURL URLWithString:url];
        
        [self.avPlayer seekToTime:CMTimeMake(0, 1)];
        [self.avPlayer pause];
        [self.avPlayerViewController.view removeFromSuperview];
        self.avPlayer = NULL;
        
        
        self.avPlayer = [AVPlayer playerWithURL:videoURL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer];
        
        
        self.avPlayerViewController = [AVPlayerViewController new];
        self.avPlayerViewController.player = self.avPlayer;
        self.avPlayerViewController.view.frame = _videoView.bounds;
        [_videoView addSubview:self.avPlayerViewController.view];
        
        [self.avPlayer play];
    }
    
}


-(void)drawWagonwheel
{
    
    if(isList == YES)
    {
        ScoreCardCell *cell = [self.listTbl cellForRowAtIndexPath:seletedPath];
       // cell=(ScorecardBowlCell *)cell;
        if(self.wagonWheelDrawData.count>0)
        {
            //for(int i=0;i<self.wagonWheelDrawData.count;i++)
            
            NSMutableArray *sepArray = [[NSMutableArray alloc]init];
            sepArray= [[self.wagonWheelDrawData valueForKey:@"Value"]objectAtIndex:0];
            
            if(![sepArray isEqual:[NSNull null]])
            {
                
                for(int i=0;sepArray.count>i;i++)
                {
                    for (CALayer *layer in cell.WagonImg.layer.sublayers) {
                        if ([layer.name isEqualToString:@"DrawLine"]) {
                            [layer removeFromSuperlayer];
                            break;
                        }
                    }
                }
                
                
                //[self HideLable];
                int x1position;
                int y1position;
                int x2position;
                int y2position;
                
                int BASE_X = 280;
                
                NSMutableArray *onescount = [[NSMutableArray alloc]init];
                NSMutableArray *twoscount = [[NSMutableArray alloc]init];
                NSMutableArray *threescount = [[NSMutableArray alloc]init];
                NSMutableArray *fourscount = [[NSMutableArray alloc]init];
                NSMutableArray *sixscount = [[NSMutableArray alloc]init];
                NSMutableArray *dotscount = [[NSMutableArray alloc]init];
                
                
                for(int i=0; i<sepArray.count;i++)
                {
                    
                    
                    if(IS_IPHONE_DEVICE)
                    {
                        
                        
                        x1position = 65;
                        y1position = 55;
                        
                        x2position  = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*130);
                        y2position  = (([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*130);
                    }
                    
                    else
                    {
                        
                        x1position = 100;
                        y1position = 84.7;
                        
                        
                        x2position = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*200);
                        y2position = ([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*200;
                        
                        
                    }
                    
                    
                    self.selectRuns =[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                    
                    int Xposition = x1position;
                    int Yposition = y1position;
                    
                    
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
                    
                    
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    //[shapeLayer setPosition:cell.WagonImg.center];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    
                    
                    
                    //NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                    
                    
                    if ([self.selectRuns isEqualToString: @"1"]) {
                        
                        
                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                        [onescount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                        NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)onescount.count];
                        [cell.onesBtn setTitle:ss forState:UIControlStateNormal];
                        
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        
                        if(isOnes == YES)
                        {
                            strokeColor = [self colorWithHexString:color];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                        
                    }else if ([self.selectRuns isEqualToString: @"2"]){
                        
                        
                        //strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        [twoscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                        NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)twoscount.count];
                        [cell.twoBtn setTitle:ss forState:UIControlStateNormal];
                        
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        //strokeColor = [self colorWithHexString:color];
                        
                        if(isTwos == YES)
                        {
                            strokeColor = [self colorWithHexString:color];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                        
                        
                    }else if ([self.selectRuns isEqualToString: @"3"]){
                        
                        
                        //strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                        [threescount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                        NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)threescount.count];
                        [cell.threeBtn setTitle:ss forState:UIControlStateNormal];
                        
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        
                        // strokeColor = [self colorWithHexString:color];
                        if(isThrees == YES)
                        {
                            strokeColor = [self colorWithHexString:color];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                        
                        
                    }else if ([self.selectRuns isEqualToString: @"4"]){
                        
                        
                        //strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        [fourscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                        NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)fourscount.count];
                        [cell.fourBtn setTitle:ss forState:UIControlStateNormal];
                        
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        
                        //strokeColor = [self colorWithHexString:color];
                        
                        if(isFours == YES)
                        {
                            strokeColor = [self colorWithHexString:color];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                        
                    }else if ([self.selectRuns isEqualToString: @"6"]){
                        
                        
                        // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        [sixscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                        NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)sixscount.count];
                        [cell.sixBtn setTitle:ss forState:UIControlStateNormal];
                        
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        
                        //strokeColor = [self colorWithHexString:color];
                        
                        if(isSixes == YES)
                        {
                            strokeColor = [self colorWithHexString:color];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                    }
                    else if ([self.selectRuns isEqualToString: @"90"] ){
                        
                        
                        
                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        //[dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                       // NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                       // [cell.dotBtn setTitle:ss forState:UIControlStateNormal];
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        //strokeColor = [self colorWithHexString:@"#eee"];
                        
                        if(isDotBall == YES)
                        {
                            strokeColor = [UIColor colorWithRed:(238/255.0f) green:(238/255.0f) blue:(238/255.0f) alpha:0.8f];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                        //strokeColor = [UIColor colorWithRed:(238/255.0f) green:(238/255.0f) blue:(238/255.0f) alpha:0.8f];
                        
                    }
                    else if ([self.selectRuns isEqualToString: @"80"]){
                        
                        
                        NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                        if(isWkt == YES)
                        {
                            strokeColor = [self colorWithHexString:color];
                        }
                        else
                        {
                            strokeColor = [UIColor clearColor];
                        }
                        
                        
                    }
                    
                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.WagonImg.layer addSublayer:shapeLayer];
                    
                    //}
                }
                
                    [self.listTbl reloadData];
            }
        }
        
    }
    else
    {
        ScorecardBowlCell *cell = [self.bowlingTbl cellForRowAtIndexPath:seletedPath];
    
    if(self.wagonWheelDrawData.count>0)
                {
                    //for(int i=0;i<self.wagonWheelDrawData.count;i++)
        
                      NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                      sepArray= [[self.wagonWheelDrawData valueForKey:@"Value"]objectAtIndex:0];
        
                    if(![sepArray isEqual:[NSNull null]])
                    {
        
                    for(int i=0;sepArray.count>i;i++)
                    {
                        for (CALayer *layer in cell.WagonImg.layer.sublayers) {
                            if ([layer.name isEqualToString:@"DrawLine"]) {
                                [layer removeFromSuperlayer];
                                break;
                            }
                        }
                    }
        
        
                    //[self HideLable];
                    int x1position;
                    int y1position;
                    int x2position;
                    int y2position;
        
                    int BASE_X = 280;
        
                NSMutableArray *onescount = [[NSMutableArray alloc]init];
                NSMutableArray *twoscount = [[NSMutableArray alloc]init];
                NSMutableArray *threescount = [[NSMutableArray alloc]init];
                NSMutableArray *fourscount = [[NSMutableArray alloc]init];
                NSMutableArray *sixscount = [[NSMutableArray alloc]init];
                NSMutableArray *dotscount = [[NSMutableArray alloc]init];
        
        
                    for(int i=0; i<sepArray.count;i++)
                    {
                 
        
                        if(IS_IPHONE_DEVICE)
                        {
      
        
                            x1position = 65;
                            y1position = 55;
        
                            x2position  = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*130);
                            y2position  = (([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*130);
                        }
        
                        else
                        {
       
                            x1position = 100;
                            y1position = 84.7;
      
        
                            x2position = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*200);
                            y2position = ([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*200;
        
        
                        }
        
        
                        self.selectRuns =[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
        
                        int Xposition = x1position;
                        int Yposition = y1position;
        
        
                        CGMutablePathRef straightLinePath = CGPathCreateMutable();
                        CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                        CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
        
        
                        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                        //[shapeLayer setPosition:cell.WagonImg.center];
                        shapeLayer.path = straightLinePath;
                        UIColor *fillColor = [UIColor redColor];
                        shapeLayer.fillColor = fillColor.CGColor;
        
        
                            if ([self.selectRuns isEqualToString: @"1"]) {
        
        
                                
        
                                [onescount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)onescount.count];
                                [cell.onesBtn setTitle:ss forState:UIControlStateNormal];
        
                                NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
        
                                if(isOnes == YES)
                                {
                                strokeColor = [self colorWithHexString:color];
                                }
                                else
                                {
                                    strokeColor = [UIColor clearColor];
                                }
        
        
                        }else if ([self.selectRuns isEqualToString: @"2"]){
        
        
                            [twoscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)twoscount.count];
                            [cell.twoBtn setTitle:ss forState:UIControlStateNormal];
        
                            NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                            
        
                            if(isTwos == YES)
                            {
                                strokeColor = [self colorWithHexString:color];
                            }
                            else
                            {
                                strokeColor = [UIColor clearColor];
                            }
        
        
        
                        }else if ([self.selectRuns isEqualToString: @"3"]){
        
        
                            [threescount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)threescount.count];
                            [cell.threeBtn setTitle:ss forState:UIControlStateNormal];
        
                            NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
        
                           
                            if(isThrees == YES)
                            {
                                strokeColor = [self colorWithHexString:color];
                            }
                            else
                            {
                                strokeColor = [UIColor clearColor];
                            }
        
        
        
                        }else if ([self.selectRuns isEqualToString: @"4"]){
        
    
                            [fourscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)fourscount.count];
                            [cell.fourBtn setTitle:ss forState:UIControlStateNormal];
        
                            NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
        
                            
        
                            if(isFours == YES)
                            {
                                strokeColor = [self colorWithHexString:color];
                            }
                            else
                            {
                                strokeColor = [UIColor clearColor];
                            }
        
        
                        }else if ([self.selectRuns isEqualToString: @"6"]){
        
        
                          
                            [sixscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)sixscount.count];
                            [cell.sixBtn setTitle:ss forState:UIControlStateNormal];
        
                            NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
        
                            
        
                            if(isSixes == YES)
                            {
                                strokeColor = [self colorWithHexString:color];
                            }
                            else
                            {
                                strokeColor = [UIColor clearColor];
                            }
        
                        }
                        else if ([self.selectRuns isEqualToString: @"90"] ){
        
        
        
                            
                            [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                            [cell.dotBtn setTitle:ss forState:UIControlStateNormal];
                            NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                            
        
                            if(isDotBall == YES)
                            {
                                strokeColor = [UIColor colorWithRed:(238/255.0f) green:(238/255.0f) blue:(238/255.0f) alpha:0.8f];
                            }
                            else
                            {
                                strokeColor = [UIColor clearColor];
                            }
        
                        }
                        else if ([self.selectRuns isEqualToString: @"80"]){
        
        
                            NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
        
                            if(isWkt == YES)
                            {
                                strokeColor = [self colorWithHexString:color];
                            }
                            else
                            {
                                strokeColor = [UIColor clearColor];
                            }
        
        
                        }
        
        
                        shapeLayer.strokeColor = strokeColor.CGColor;
                        shapeLayer.lineWidth = 2.0f;
                        shapeLayer.fillRule = kCAFillRuleNonZero;
                        shapeLayer.name = @"DrawLine";
                        [cell.WagonImg.layer addSublayer:shapeLayer];
                        
                        //}
                    }
                        
                            [self.bowlingTbl reloadData];
                    }
}
}
}

-(void)drawPitchmap
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    if(isList == YES)
    {
        ScoreCardCell *cell = [self.listTbl cellForRowAtIndexPath:seletedPath];
        if(self.pitchData.count>0)
        {
            NSMutableArray *sepArray = [[NSMutableArray alloc]init];
            sepArray= [[self.pitchData valueForKey:@"Value"]objectAtIndex:0];
            for(UIImageView * obj in [cell.PitchImg subviews])
            {
                NSLog(@"%@",obj);
                [obj removeFromSuperview];
            }
            
            
            int xposition;
            int yposition;
            NSMutableArray *dotscount = [[NSMutableArray alloc]init];
            
            if(![sepArray isEqual:[NSNull null]])
            {
                for(int i=0; i<sepArray.count;i++)
                {
                    
                    if(IS_IPHONE_DEVICE)
                    {
                       
                        xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*130)-4;
                        yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*130)-1;
                        
                    }
                    else
                    {
                        
                        
                       
                        
                        xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*200)-4;
                        yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*200)-1;
                        
                    }
                    
                    if([[[self.pitchData valueForKey:@"Battingstyle"]objectAtIndex:0] isEqualToString:@"RIGHT"])
                    {
                        
                        cell.PitchImg.image = [UIImage imageNamed:@"Pitchmap"];
                    }
                    else
                    {
                        cell.PitchImg.image = [UIImage imageNamed:@"PitchmapLefthand"];
                    }
                    
                    NSString * run;
                    run =([[[sepArray valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                    
                    if(!(xposition == 1 && yposition == 1) && (xposition!=0 && yposition !=0)){
                        
                        Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition,yposition,6, 6)];
                       
                        
                        Img_ball.layer.cornerRadius =3;
                        Img_ball.layer.masksToBounds=YES;
                        if ([run isEqualToString: @"1"]) {
                            
                            
                            if(isOnes == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            // }
                        }else if ([run isEqualToString: @"2"]){
                            
                            if(isTwos == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"ff6c00"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                        }else if ([run isEqualToString: @"3"]){
                            
                            
                            if(isThrees == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"A305C0"];
                            }
                            
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                        }else if ([run isEqualToString: @"4"]){
                            
                            if(isFours == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"2454f1"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                            
                        }else if ([run isEqualToString: @"5"]){
                            
                            if(isFours == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                            
                        }else if ([run isEqualToString: @"6"]){
                            
                            if(isSixes == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"ff00ea"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                            
                        }else if ([run isEqualToString: @"90"]){
                            
                           
                            [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                            [cell.dotBtn setTitle:ss forState:UIControlStateNormal];
                            
                            if(isDotBall == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"EEEEEE"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                        }
                        else if ([run isEqualToString: @"80"]){
                           
                            [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                            NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                            [cell.dotBtn setTitle:ss forState:UIControlStateNormal];
                            
                            if(isWkt == YES)
                            {
                                Img_ball.backgroundColor = [self colorWithHexString:@"ed1d24"];
                            }
                            else
                            {
                                Img_ball.backgroundColor =[UIColor clearColor];
                            }
                            
                        }
                      
                        
                        [cell.PitchImg addSubview:Img_ball];
                        
                        
                    }
                }
            }
                [self.listTbl reloadData];
            
        }
        
    }else 
    {
    ScorecardBowlCell *cell = [self.bowlingTbl cellForRowAtIndexPath:seletedPath];
    if(self.pitchData.count>0)
                    {
                    NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                    sepArray= [[self.pitchData valueForKey:@"Value"]objectAtIndex:0];
                        for(UIImageView * obj in [cell.PitchImg subviews])
                        {
                            NSLog(@"%@",obj);
                            [obj removeFromSuperview];
                        }
        
        
                        int xposition;
                        int yposition;
                        NSMutableArray *dotscount = [[NSMutableArray alloc]init];
        
                        if(![sepArray isEqual:[NSNull null]])
                        {
                        for(int i=0; i<sepArray.count;i++)
                        {
                            if(IS_IPHONE_DEVICE)
                            {
        
                            xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*130)-4;
                            yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*130)-1;
        
                            }
                            else
                            {
        
                                xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*200)-4;
                                yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*200)-1;
        
                            }
        

        
                                cell.PitchImg.image = [UIImage imageNamed:@"Pitchmap"];

        
                            NSString * run;
                                run =([[[sepArray valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
        
                            if(!(xposition == 1 && yposition == 1) && (xposition!=0 && yposition !=0)){
        
                                Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition,yposition,6, 6)];
        
                                Img_ball.layer.cornerRadius =3;
                                Img_ball.layer.masksToBounds=YES;
                                if ([run isEqualToString: @"1"]) {
        
                                    
                                    if(isOnes == YES)
                                    {
                                    Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
                                   
                                }else if ([run isEqualToString: @"2"]){
                                    
                                    if(isTwos == YES)
                                    {
                                    Img_ball.backgroundColor = [self colorWithHexString:@"ff6c00"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
                                }else if ([run isEqualToString: @"3"]){
                                    
        
                                    if(isThrees == YES)
                                    {
                                    Img_ball.backgroundColor = [self colorWithHexString:@"A305C0"];
                                    }
        
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
                                }else if ([run isEqualToString: @"4"]){
                                    
                                    if(isFours == YES)
                                    {
                                    Img_ball.backgroundColor = [self colorWithHexString:@"2454f1"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
        
                                }else if ([run isEqualToString: @"5"]){
                                   
                                    if(isFours == YES)
                                    {
                                    Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
        
                                }else if ([run isEqualToString: @"6"]){
                                   
        
                                    if(isSixes == YES)
                                    {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ff00ea"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
        
                                }else if ([run isEqualToString: @"90"]){
        
                                
                                    [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                    NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                                    [cell.dotBtn setTitle:ss forState:UIControlStateNormal];
        
                                    if(isDotBall == YES)
                                    {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"EEEEEE"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
                                }
                                else if ([run isEqualToString: @"80"]){
                                    
                                    [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                    NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                                    [cell.dotBtn setTitle:ss forState:UIControlStateNormal];
        
                                    if(isWkt == YES)
                                    {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ed1d24"];
                                    }
                                    else
                                    {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                    }
        
                                }
        
        
                                [cell.PitchImg addSubview:Img_ball];
        
        
                            }
                          }
                            [self.bowlingTbl reloadData];
                        }
                        
                        }
                      }
}

@end
    

    
