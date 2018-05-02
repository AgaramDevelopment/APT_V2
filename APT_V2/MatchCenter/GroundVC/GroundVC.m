//
//  GroundVC.m
//  APT_V2
//
//  Created by Apple on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "GroundVC.h"
#import "TabHomeCell.h"
#import "MCOverViewResultCVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "BowlTypeCell.h"
//#import "IntAxisValueFormatter.h"
#import "HorizontalXLblFormatter.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ResultsVc.h"
#import "TabbarVC.h"

@import drCharts;


#define ITEM_COUNT 12
#define header_height 65

@interface GroundVC ()<PieChartViewDataSource,PieChartViewDelegate,ChartViewDelegate,BarChartDelegate,BarChartDataSource>
{
    NSArray* headingKeyArray;
    NSArray* headingButtonNames;
    
    //Donar Charts
    NSMutableArray *markers1;
    NSMutableArray *markers2;
    float num1;
    float num2;
    float num3;
    float num4;
    
    TabbarVC *objtab;
    
    NSArray<NSString *> *months;
    NSMutableArray *recentMatchesArray;
    NSMutableDictionary *battingDict;
    NSMutableArray *commonArray;
    NSMutableArray *groundResultsArray;
    //Bar Charts
    NSArray *arr,*titleArray;
    NSArray *arr1;
    
    UIColor *strokeColor;
    
    BOOL isteamCode;
    BOOL isCompetitionCode;
    BOOL isGroundCode;
    NSString *teamCode;
    NSString *competitionCode, *competitionName;
    NSString *groundCode;
    NSIndexPath* selectedIndex;
    NSString* fromOver,* toOver;

    
}
@property (strong, nonatomic) IBOutlet PieChartView *battingFstPie;
@property (strong, nonatomic) IBOutlet PieChartView *battingSecPie;



@property (nonatomic, strong) IBOutlet BarChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (strong, nonatomic) IBOutlet BarChart *barChartMultipleView;

@end

@implementation GroundVC

@synthesize teamView,competitionView,groundView;

@synthesize groundLbl,teamCodeTF,competitionCodeTF;

@synthesize Titlecollview,overBlockbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hide navigationController
    self.navigationController.navigationBarHidden = YES;
    
    fromOver = @"0";
    toOver = @"5";

    selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    titleArray = @[@"Innings1",@"Innings2"];
    
    competitionCode = [AppCommon getCurrentCompetitionCode];
    competitionName = [AppCommon getCurrentCompetitionName];
    
    competitionCodeTF.text = [AppCommon getCurrentCompetitionName];
    
    NSArray* temp = [COMMON getCorrespondingTeamName:competitionName];
    teamCodeTF.text = [[temp firstObject] valueForKey:@"TeamName"];
    teamCode = [[temp firstObject] valueForKey:@"TeamCode"];
    NSString* groundName = [NSString stringWithFormat:@"%@, %@", [[temp firstObject] valueForKey:@"GroundName"], [[temp firstObject] valueForKey:@"City"]];
    
    groundLbl.text = groundName;
    groundCode = [[temp firstObject] valueForKey:@"GroundCode"];

    
    //Ground List Get Service Call dropdown
//    [self groundListGetService];
    
    [self groundGetService];
    
    [Titlecollview registerNib:[UINib nibWithNibName:@"TabHomeCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];


    //To Hide Team Code For Player
  
//    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
//    NSString *plyRolecode = @"ROL0000002";
//
//    if([rolecode isEqualToString:plyRolecode])
//        {
//        self.teamView.hidden = YES;
//        }
//    else
//        {
//        self.teamView.hidden = NO;
//        }
//
    
    
   // self.barchart.frame = CGRectMake(0, 0, self.view.frame.size.width, 338);
    //[self.reqBarChartView addSubview:self.barchart];
    
    self.battingFstPie.delegate = self;
    self.battingFstPie.datasource = self;
    
    
    self.battingSecPie.delegate = self;
    self.battingSecPie.datasource = self;
    
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"MCOverViewResultCVC" bundle:nil] forCellWithReuseIdentifier:@"mcResultCVC"];
    
    // [_scrollView contentSize ]
    // _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 3000);
    
    _scrollView.contentSize = _contentView.frame.size;
    
    self.competitionTeamCodesTblView.hidden = YES;
   // [self barchartMultiple];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    UIBezierPath *path = [UIBezierPath new];
    
    [path moveToPoint:(CGPoint){self.ColorView.frame.size.width-25,0 }];//w0
    [path addLineToPoint:(CGPoint){0, 0}];//00
    [path addLineToPoint:(CGPoint){0,self.ColorView.frame.size.height }];//0h
    [path addLineToPoint:(CGPoint){self.ColorView.frame.size.width, self.ColorView.frame.size.height}];//wh20
    
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = self.ColorView.bounds;
    mask.path = path.CGPath;
    self.ColorView.layer.mask = mask;
    

}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headerView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Ground";
    objCustomNavigation.btn_back.hidden = YES;
    objCustomNavigation.home_btn.hidden = YES;
    objCustomNavigation.menu_btn.hidden =NO;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)groundListButtonTapped:(id)sender {
    
    isCompetitionCode = NO;
    isteamCode = NO;
    isGroundCode = YES;
    self.competitionTeamCodesTblView.hidden = NO;
    self.codeArray = [NSMutableArray new];
    self.codeArray = groundResultsArray;
    self.tableWidth.constant = self.groundView.frame.size.width;
    self.tableXPosition.constant = self.groundView.frame.origin.x+10;
    self.tableYPosition.constant = self.groundView.frame.origin.y+10;
        //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.competitionTeamCodesTblView reloadData];
    });

}

- (void)groundListGetService {
    /*
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/APT_GROUNDLIST/UCC0000008
     METHOD     :   GET
     */
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    
    NSString *API_URL = [NSString stringWithFormat:@"%@/%@/%@",URL_FOR_RESOURCE(@""),GroundList, competitionCode];
//    NSString *API_URL = [NSString stringWithFormat:@"%@/%@/%@",URL_FOR_RESOURCE(@""),GroundList, @"UCC0000008"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"groundListGetService RESPONSE:%@",responseObject);
        
        if (responseObject) {
            
            groundResultsArray = [NSMutableArray new];
            groundResultsArray = [responseObject valueForKey:@"GroundResults"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self groundGetService];
            });

        }
        
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
    }];
}

- (IBAction)competitionCodeButtonTapped:(id)sender {
    
    isCompetitionCode = YES;
    isteamCode = NO;
    isGroundCode = NO;
    self.competitionTeamCodesTblView.hidden = NO;
    self.codeArray = [NSMutableArray new];
    NSLog(@"%@", appDel.ArrayCompetition);
    self.codeArray = appDel.ArrayCompetition;
    self.tableWidth.constant = self.competitionView.frame.size.width;
    self.tableXPosition.constant = self.competitionView.frame.origin.x+10;
    self.tableYPosition.constant = self.competitionView.frame.origin.y+self.competitionView.frame.size.height+15;
        //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.competitionTeamCodesTblView reloadData];
    });
}

- (IBAction)teamCodeButtonTapped:(id)sender {
    
    isCompetitionCode = NO;
    isGroundCode = NO;
    isteamCode = YES;
    self.competitionTeamCodesTblView.hidden = NO;
    self.codeArray = [NSMutableArray new];
    NSLog(@"%@", appDel.ArrayTeam);
    self.codeArray = appDel.ArrayTeam;
    self.tableWidth.constant = self.teamView.frame.size.width;
    self.tableXPosition.constant = self.teamView.frame.origin.x+10;
    self.tableYPosition.constant = self.teamView.frame.origin.y+self.teamView.frame.size.height+15;
        //Re-load Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.competitionTeamCodesTblView reloadData];
    });
}



- (IBAction)innings1ButtonTapped:(id)sender {
    NSMutableArray *battingInnFirstResultsArray = [self checkNull:[battingDict valueForKey:@"BattingInnFirstResults"]];
    
    for (id key in battingInnFirstResultsArray) {
            //Batting 1st  Values Assign to Label Properties
        self.OBAvgWinScore.text = [self checkNull:[key valueForKey:@"BFAvgWonScore"]];
        self.OBHighScore.text = [self checkNull:[key valueForKey:@"BFHighScore"]];
        self.OBAvgScore.text = [self checkNull:[key valueForKey:@"BFScore"]];
        self.OBLowScore.text = [self checkNull:[key valueForKey:@"BFLowScore"]];
    }
    
    commonArray = [NSMutableArray new];
    commonArray = [self checkNull:[battingDict valueForKey:@"PPOneBlockResult"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.BowlTypeTbl reloadData];
    });
    
//    UIButton *btn = self.overBlockbtn[0];
    
    [overBlockbtn.firstObject sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    //[self resultOverwise:self.overBlockbtn[0]];
    
    arr = [NSArray new];
    arr = [self checkNull:[battingDict valueForKey:@"BattingInnFirstChartResults"]];
    //Bar Charts
    [self createBarChart];
}

- (IBAction)innings2ButtonTapped:(id)sender {
    NSMutableArray *battingInnSecondResultsArray = [self checkNull:[battingDict valueForKey:@"BattingInnSecondResults"]];
    for (id key in battingInnSecondResultsArray) {
            //Batting 1st  Values Assign to Label Properties
        self.OBAvgWinScore.text = [self checkNull:[key valueForKey:@"BSAvgWonScore"]];
        self.OBHighScore.text = [self checkNull:[key valueForKey:@"BSHighScore"]];
        self.OBAvgScore.text = [self checkNull:[key valueForKey:@"BSScore"]];
        self.OBLowScore.text = [self checkNull:[key valueForKey:@"BSLowScore"]];
    }

    commonArray = [NSMutableArray new];
    commonArray = [battingDict valueForKey:@"PPTwoBlockResult"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.BowlTypeTbl reloadData];
    });

    arr = [NSArray new];
    arr = [self checkNull:[battingDict valueForKey:@"BattingInnSecondChartResults"]];
    //Bar Charts
    [self createBarChart];
}


- (void)groundGetService {
    
    /*
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/APT_GROUND/
     METHOD     :   GET
     PARAMETER  :   {COMPETITIONCODE}/{TEAMCODE}/{GROUNDCODE}
     //http://192.168.0.151:8044/AGAPTService.svc/APT_GROUND/UCC0000008/TEA0000010/GRD0000006
     */
    // PARAMETER  :   {COMPETITIONCODE}/{GROUNDCODE}
    //http://192.168.0.151:8044/AGAPTService.svc/APT_GROUND/UCC0000008/GRD0000006
    
    if(![COMMON isInternetReachable])
    {
        return;
    }
    else if([competitionCodeTF.text isEqualToString:@"Competition Name"])
    {
        return;
    }
    else if([teamCodeTF.text isEqualToString:@"Team Name"])
    {
        return;
    }

    
    [AppCommon showLoading];
    
    
    NSString *API_URL = [NSString stringWithFormat:@"%@/%@/%@/%@",Ground, competitionCode, groundCode,teamCode];
    
    NSString* main_URL = URL_FOR_RESOURCE(API_URL);
    
    NSLog(@"Ground_URL %@",main_URL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:main_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        
        //Recent Matches
        recentMatchesArray = [[NSMutableArray alloc] init];
        if(![[responseObject valueForKey:@"OvBatRecentmatch"] isEqual:[NSNull null]])
        {
        recentMatchesArray = [responseObject valueForKey:@"OvBatRecentmatch"];
        }

        
        //Pie Chart
//        markers = [[NSMutableArray alloc] initWithObjects:@"1", @"4", nil];

        markers1 = [NSMutableArray new];
//        NSMutableArray *batFirstTosswonReslts = [responseObject valueForKey:@"BatFirstTosswonReslts"];

        if(![[responseObject valueForKey:@"BatFirstTosswonReslts"] isEqual:[NSNull null]])
        {
        NSString *firstTotal, *firstWon, *firstLoss;
        for (id key in [responseObject valueForKey:@"BatFirstTosswonReslts"]) {
                //Batting 1st  Values Assign to Label Properties
            firstTotal = [self checkNull:[key valueForKey:@"Total"]];
            firstWon = [self checkNull:[key valueForKey:@"Won"]];
            firstLoss = [self checkNull:[key valueForKey:@"Loss"]];
        }
        
        float firtsResults =  [firstWon floatValue]/[firstTotal floatValue];
        NSNumber *num1 = [NSNumber numberWithFloat:firtsResults];
        
        if (firstLoss < firstWon) {
            [markers1 addObject:firstLoss];
            [markers1 addObject:firstWon];
        } else {
            [markers1 addObject:firstWon];
            [markers1 addObject:firstLoss];
        }
            self.battingFirstMatchWonLbl.text = firstWon;
            self.battingFirstMatchLostLbl.text = firstLoss;
            self.lbl1stBattingTot.text = firstTotal;
    }
        
        markers2 = [NSMutableArray new];
        if(![[responseObject valueForKey:@"BatSecondTosswonReslts"] isEqual:[NSNull null]])
        {
        NSMutableArray *batSecondTosswonReslts = [responseObject valueForKey:@"BatSecondTosswonReslts"];
        NSString *secondTotal, *secondWon, *secondLoss;
        for (id key in batSecondTosswonReslts) {
                //Batting 1st  Values Assign to Label Properties
            secondTotal = [self checkNull:[key valueForKey:@"Total"]];
            secondWon = [self checkNull:[key valueForKey:@"Won"]];
            secondLoss = [self checkNull:[key valueForKey:@"Loss"]];
        }
        float secondResults = [secondWon floatValue]/[secondTotal floatValue];
        NSNumber *num2 = [NSNumber numberWithFloat:secondResults];
        
        if (secondLoss < secondWon) {
            [markers2 addObject:secondLoss];
            [markers2 addObject:secondWon];
        } else {
            [markers2 addObject:secondWon];
            [markers2 addObject:secondLoss];
        }
        
 
            self.battingSecondMatchWonLbl.text = secondWon;
            self.battingSecondMatchLostLbl.text = secondLoss;
            self.lbl2ndBattingTot.text = secondTotal;
        }
            //Re-load Table View
        
        if(![[responseObject valueForKey:@"BattingScoreResults"] isEqual:[NSNull null]])
        {
        NSMutableArray *battingScoreResultsArray = [responseObject valueForKey:@"BattingScoreResults"];
        for (id key in battingScoreResultsArray) {
            //Batting 1st  Values Assign to Label Properties
            self.BFAvgWinScoreLbl.text = [self checkNull:[key valueForKey:@"BFAvgWonScore"]];
            self.BFHighScore.text = [self checkNull:[key valueForKey:@"BFHighScore"]];
            self.BFAvgScore.text = [self checkNull:[key valueForKey:@"BFScore"]];
            self.BFLowScore.text = [self checkNull:[key valueForKey:@"BFLowScore"]];
            
            //Batting 2nd  Values Assign to Label Properties
            self.BSAvgWinScoreLbl.text = [self checkNull:[key valueForKey:@"BSAvgWonScore"]];
            self.BSHighScore.text = [self checkNull:[key valueForKey:@"BSHighScore"]];
            self.BSAvgScore.text = [self checkNull:[key valueForKey:@"BSScore"]];
            self.BSLowScore.text = [self checkNull:[key valueForKey:@"BSLowScore"]];
        }
        }
        
        if(![[responseObject valueForKey:@"GroundDimensionResults"] isEqual:[NSNull null]])
        {
        NSMutableArray *groundDimensionResults = [responseObject valueForKey:@"GroundDimensionResults"];
        for (id key in groundDimensionResults) {
            self.groundTopLeft.text = [key valueForKey:@"GTopLeft"];
            self.groundTopRight.text = [key valueForKey:@"GTopRight"];
            self.groundBottomLeft.text = [key valueForKey:@"GTopRight"];
            self.groundBottomRight.text = [key valueForKey:@"GBottomLeft"];
            self.groundLight.text = [key valueForKey:@"GSTop"];
            self.groundRight.text = [key valueForKey:@"GSBottom"];
            
//            self.groundTopLeft.text = [NSString stringWithFormat:@"%@",[key valueForKey:@"GTopLeft"]];
//            self.groundTopRight.text = [NSString stringWithFormat:@"%@", [key valueForKey:@"GTopRight"]];
//            self.groundBottomLeft.text = [NSString stringWithFormat:@"%@", [key valueForKey:@"GTopRight"]];
//            self.groundBottomRight.text = [NSString stringWithFormat:@"%@", [key valueForKey:@"GBottomLeft"]];
        }
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.battingFstPie reloadData];
            [self.battingSecPie reloadData];

            //GroundOverResults Get Service Method
            [self.resultCollectionView reloadData];
            [overBlockbtn.firstObject sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
    }];
}

- (void)groundOverResultsGetService {
    /*
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/APT_GROUNDOVERRESULTS/
     METHOD     :   GET
     PARAMETER  :   {COMPETITIONCODE}/{GROUNDCODE}/{FromOver}/{ToOver}
     */
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",URL_FOR_RESOURCE(@""),groundOverResults, competitionCode, groundCode, fromOver, toOver];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        
        battingDict = [NSMutableDictionary new];
        battingDict = responseObject;
        
        [self loadGraphdata];
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
    }];
}

- (void)groundDimensions {
    
    self.wagonWheelDrawData = [[NSMutableArray alloc] initWithObjects:
                               @{
                                 @"Colour":@"#ed1d24",
                                 @"WWX1":@"161",
                                 @"WWX2":@"90",
                                 @"WWY1":@"125",
                                 @"WWY2":@"250"
                                 },
                               @{
                                 @"Colour":@"#ed1d24",
                                 @"WWX1":@"161",
                                 @"WWX2":@"180",
                                 @"WWY1":@"125",
                                 @"WWY2":@"250"
                                 },
                               @{
                                 @"Colour":@"#ed1d24",
                                 @"WWX1":@"161",
                                 @"WWX2":@"270",
                                 @"WWY1":@"125",
                                 @"WWY2":@"250"
                                 },
                               @{
                                 @"Colour":@"#ed1d24",
                                 @"WWX1":@"161",
                                 @"WWX2":@"20",
                                 @"WWY1":@"125",
                                 @"WWY2":@"150"
                                 },
                               nil];
    /*
     WWX1 = 161;
     WWX2 = 279;
     WWY1 = 125;
     WWY2 = 168;
     */
    
    if (IS_IPAD) {
        
            //wagon wheel
        if(self.wagonWheelDrawData.count>0)
            {
            
            NSMutableArray *sepArray = [[NSMutableArray alloc]init];
            
            sepArray= self.wagonWheelDrawData;
            if(![sepArray isEqual:[NSNull null]])
                {
                
                for(int i=0;sepArray.count>i;i++)
                {
                    for (CALayer *layer in self.wagonImage.layer.sublayers) {
                        if ([layer.name isEqualToString:@"DrawLine"]) {
                            [layer removeFromSuperlayer];
                            break;
                        }
                    }
                }
                
                int x1position;
                int y1position;
                int x2position;
                int y2position;
                
                int BASE_X = 280;
                
                
                for(int i=0; i<sepArray.count;i++)
                    {
                    
                    if(IS_IPHONE_DEVICE)
                        {
                        x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                        y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                        x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                        y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                        }
                    
                    else
                        {
                        
                        x1position = 100;
                        y1position = 84.7;
                        
                        x2position = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*200);
                        y2position = ([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*200;
                        
                        
                        }
                    
                    
                    
                    int Xposition = x1position;
                    int Yposition = y1position;
                    
                    
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
                    
                    
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    
                    NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                    
                    strokeColor = [self colorWithHexString:color];
                    
                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.wagonImage.layer addSublayer:shapeLayer];
                    }
                }
            }
    } else {
        
            //wagon wheel
        if(self.wagonWheelDrawData.count>0)
            {
            
            NSMutableArray *sepArray = [[NSMutableArray alloc]init];
            
            sepArray= self.wagonWheelDrawData;
            if(![sepArray isEqual:[NSNull null]])
                {
                
                for(int i=0;sepArray.count>i;i++)
                    {
                    for (CALayer *layer in self.wagonImage.layer.sublayers) {
                        if ([layer.name isEqualToString:@"DrawLine"]) {
                            [layer removeFromSuperlayer];
                            break;
                        }
                    }
                    }
                
                int x1position;
                int y1position;
                int x2position;
                int y2position;
                
                int BASE_X = 280;
                
                
                
                
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
                    
                    int Xposition = x1position;
                    int Yposition = y1position;
                    
                    
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
                    
                    
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    
                    
                    NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                    
                    strokeColor = [self colorWithHexString:color];
                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.wagonImage.layer addSublayer:shapeLayer];
                    
                    }
                }
            }
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == _resultCollectionView){
        return recentMatchesArray.count;
    }
    else if(collectionView == Titlecollview)
    {
        return 2;
    }
    else{
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == Titlecollview)
    {
        CGFloat widthF = self.Titlecollview.superview.frame.size.width/2;
        CGFloat HeightF = self.Titlecollview.superview.frame.size.height;
        
        return CGSizeMake(widthF, HeightF);
    }
    else
    {
        CGFloat width = collectionView.frame.size.width;
        CGFloat height = collectionView.frame.size.height;
        
        if(IS_IPAD)
        {
            width = width/2;
        }
        
        return CGSizeMake(width, height);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 10, 10, 10);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(collectionView == self.resultCollectionView){
        
        MCOverViewResultCVC* cell = [self.resultCollectionView dequeueReusableCellWithReuseIdentifier:@"mcResultCVC" forIndexPath:indexPath];
        
//        cell.team1Img.image = [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATPhoto"] ];
        
        NSString* ATPhoto = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATPhoto"];
        
//        [cell.team1Img sd_setImageWithURL:[NSURL URLWithString:ATPhoto ]placeholderImage:[UIImage imageNamed:@"csk_lgo"]];
        
//        [self downloadImageWithURL:[NSURL URLWithString:ATPhoto] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.team1Img.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.team1Img.image = image;
//            }
//            else
//            {
//                cell.team1Img.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.team1Img sd_setImageWithURL:[NSURL URLWithString:ATPhoto] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        cell.Teamname1lbl.text = [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATName"]];
        
        NSString *team1RunsWickets = [NSString stringWithFormat:@"%@/%@", [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATMaxInnsTotal"]], [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATMaxInnsWckts"]]];
        cell.runs1lbl.text = team1RunsWickets;
        
        NSString *team1Overs = [NSString stringWithFormat:@"%@/20 Overs", [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATOvers"]]];
        cell.TeamOvers1lbl.text = team1Overs;
        
        NSString *team1crr = [NSString stringWithFormat:@"CRR:%@", [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATRR"]]];
        cell.runrate1lbl.text = team1crr;
        
//                cell.team2Img.image = [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTPhoto"] ];
        
        NSLog(@"IMage URL %@",[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTPhoto"]);
        
         NSString* BTPhoto = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTPhoto"];
        NSURL* url1 = [NSURL URLWithString:BTPhoto];
        
//        [cell.team2Img sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"csk_lgo"]];
        
        cell.Teamname2lbl.text = [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTName"]];
        
//        [self downloadImageWithURL:[NSURL URLWithString:BTPhoto] completionBlock:^(BOOL succeeded, UIImage *image) {
//            if (succeeded) {
//                // change the image in the cell
//                cell.team2Img.image = image;
//
//                // cache the image for use later (when scrolling up)
//                cell.team2Img.image = image;
//            }
//            else
//            {
//                cell.team2Img.image = [UIImage imageNamed:@"no-image"];
//            }
//        }];
        [cell.team2Img sd_setImageWithURL:[NSURL URLWithString:BTPhoto] placeholderImage:[UIImage imageNamed:@"no-image"]];
        
        NSString *team2RunsWickets = [NSString stringWithFormat:@"%@/%@", [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTMaxInnsTotal"]], [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTMaxInnsWckts"]]];
        cell.runs2lbl.text = team2RunsWickets;
        
        NSString *team2Overs = [NSString stringWithFormat:@"%@/20 Overs", [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTOvers"]]];
        
        cell.TeamOver2lbl.text = team2Overs;
        NSString *team2crr = [NSString stringWithFormat:@"CRR:%@", [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"BTRR"]]];
        cell.runrate2lbl.text = team2crr;
        
        //       Date Format
        NSString *currentDate = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATMatchDate"];
        NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
        [dateFormatters setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *dates = [dateFormatters dateFromString:currentDate];
        

        NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
//        [dfs setDateFormat:@"dd MMM yyyy"];
        [dfs setDateFormat:@"dd MMM''yy"];
        NSString * ondateStr = [dfs stringFromDate:dates];

        NSString *dateNvenue = [NSString stringWithFormat:@"%@ @ %@", ondateStr, [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Venue"]]];
//        cell.Datelbl.text = dateNvenue;
        cell.lblOwnStats.text = dateNvenue;

        return cell;
        
    }
    else if(collectionView == Titlecollview)
    {
        TabHomeCell* cell = [self.Titlecollview dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        cell.Title.text = titleArray[indexPath.row];
        [cell setTag:indexPath.row];
        
        
        
        if (indexPath == selectedIndex) {
            cell.selectedLineView.backgroundColor = [UIColor colorWithRed:(37/255.0f) green:(176/255.0f) blue:(240/255.0f) alpha:1.0f];
           
        }
        else {
            cell.selectedLineView.backgroundColor = [UIColor clearColor];
        }
        
        return cell;

    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(collectionView == Titlecollview)
    {
        if(indexPath.row ==0)
        {
            [self innings1ButtonTapped:nil];
        }
        else if(indexPath.row==1)
        {
            [self innings2ButtonTapped:nil];
        }
        selectedIndex = indexPath;
    
        [collectionView reloadData];
        [self loadGraphdata];
        
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        objtab = (TabbarVC *)[storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
        appDel.Currentmatchcode = [self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"ATMatchCode"]];
        //appDel.Scorearray = scoreArray;
        //objtab.backkey = @"yes";
        //[self.navigationController pushViewController:objFix animated:YES];
        [appDel.frontNavigationController pushViewController:objtab animated:YES];
    }

}


-(void)loadGraphdata
{
    NSString* str_Result = (selectedIndex.item == 0 ? @"BattingInnFirstResults" :@"BattingInnSecondResults");
    
    NSMutableArray *battingInnFirstResultsArray = [self checkNull:[battingDict valueForKey:str_Result]];
    
    if( [str_Result isEqualToString:@"BattingInnFirstResults"])
    {
    for (id key in battingInnFirstResultsArray) {
        //Batting 1st  Values Assign to Label Properties
        self.OBAvgWinScore.text = [self checkNull:[key valueForKey:@"BFAvgWonScore"]];
        self.OBHighScore.text = [self checkNull:[key valueForKey:@"BFHighScore"]];
        self.OBAvgScore.text = [self checkNull:[key valueForKey:@"BFScore"]];
        self.OBLowScore.text = [self checkNull:[key valueForKey:@"BFLowScore"]];
    }
    }
    else if( [str_Result isEqualToString:@"BattingInnSecondResults"])
    {
        for (id key in battingInnFirstResultsArray) {
            //Batting 1st  Values Assign to Label Properties
            self.OBAvgWinScore.text = [self checkNull:[key valueForKey:@"BSAvgWonScore"]];
            self.OBHighScore.text = [self checkNull:[key valueForKey:@"BSHighScore"]];
            self.OBAvgScore.text = [self checkNull:[key valueForKey:@"BSScore"]];
            self.OBLowScore.text = [self checkNull:[key valueForKey:@"BSLowScore"]];
        }
    }
    
    commonArray = [NSMutableArray new];
    NSString* str_BlockResult = (selectedIndex.item == 0 ? @"PPOneBlockResult" :@"PPTwoBlockResult");
    
    commonArray = [self checkNull:[battingDict valueForKey:str_BlockResult]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.BowlTypeTbl reloadData];
    });
    
    arr = [NSArray new];
    NSString* str_ChartResult = (selectedIndex.item == 0 ? @"BattingInnFirstChartResults" :@"BattingInnSecondChartResults");
    
    arr = [self checkNull:[battingDict valueForKey:str_ChartResult]];
    //Bar Charts
    [self createBarChart];
    
}
#pragma mark -    PieChartViewDelegate
-(CGFloat)centerCircleRadius
{
    if(IS_IPHONE_DEVICE)
    {
        return 30;
    }
    else
    {
        return 30;
    }
    
    
}

#pragma mark - PieChartViewDataSource
-(int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    if (self.battingFstPie == pieChartView) {
        NSUInteger  obj =  markers1.count;
        return (int)obj;
    } else if (self.battingSecPie == pieChartView) {
        NSUInteger  obj =  markers2.count;
        return (int)obj;
    }
    return nil;
}


-(UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    UIColor * color;
    if(index==0)
    {
        color = [UIColor colorWithRed:(0/255.0f) green:(178/255.0f) blue:(235/255.0f) alpha:1.0f];
    }
    if(index==1)
    {
        color = [UIColor colorWithRed:(204/255.0f) green:(204/255.0f) blue:(204/255.0f) alpha:1.0f];
    }
    if(index==2)
    {
        color = [UIColor colorWithRed:(0/255.0f) green:(139/255.0f) blue:(139/255.0f) alpha:1.0f];
    }
    if(index==3)
    {
        color = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(42/255.0f) alpha:1.0f];
    }
    return color;
    //return GetRandomUIColor();
}

-(double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    
//    float  obj = [[NSDecimalNumber decimalNumberWithString:[markers objectAtIndex:index]]floatValue] ;
    float  obj;
    if (self.battingFstPie == pieChartView) {
        
        obj = [[NSDecimalNumber decimalNumberWithString:[markers1 objectAtIndex:index]]floatValue] ;
        
    }
  
    if (self.battingSecPie == pieChartView) {
        
        obj = [[NSDecimalNumber decimalNumberWithString:[markers2 objectAtIndex:index]]floatValue] ;
        
    }
    
    if(obj==0)
    {
        return 0;
    }
    else
    {
        
        if(index ==0)
        {
            return 100/obj;
        }
        if(index ==1)
        {
            return 100/obj;
        }
        if(index ==2)
        {
            return 100/obj;
        }
        if(index ==3)
        {
            return 100/obj;
        }
    }
    
    return 0;
}

-(NSString *)percentagevalue
{
    float a = num1;
    float b = num2;
    float c = num3;
    float d = num4;
    
    float Total = a+b+c+d;
    
    float per = (Total *100/28);
    
    NSString * obj;
    if(per == 0)
    {
        obj = @"";
    }
    else
    {
        
        obj =[NSString stringWithFormat:@"%f",per];
        
    }
    
    return obj;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.competitionTeamCodesTblView == tableView) {
        return self.codeArray.count;
    } else {
        return commonArray.count;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.competitionTeamCodesTblView == tableView) {
        static NSString *MyIdentifier = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
            }
        
        cell.textLabel.numberOfLines = 2;
        [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
        
        if(isteamCode == YES) {
            cell.textLabel.text = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        }
        
        if(isCompetitionCode == YES) {
            cell.textLabel.text = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"];
        }
        
        if(isGroundCode == YES) {
            cell.textLabel.text = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"GroundName"];
        }
        
        return cell;
    } else {
        static NSString *MyIdentifier = @"MyIdentifier";
        BowlTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
            {
            [[NSBundle mainBundle] loadNibNamed:@"BowlTypeCell" owner:self options:nil];
                //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefaultreuseIdentifier:MyIdentifier];
            cell = self.objCell;
            }
            //cell.textLabel.text = @"Text";
        cell.bowlingStyleLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"BowlingStyle"]];
        cell.wicketsLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"Wickets"]];
        cell.economyLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"Econ"]];
        cell.avgLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"Average"]];
        cell.strikeRateLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"StrikRate"]];
        cell.dotBallsPercentLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"DotBallPercent"]];
        cell.boundaryPercentLbl.text = [self checkNull:[[commonArray objectAtIndex:indexPath.row] valueForKey:@"BoundaryPercent"]];
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.competitionTeamCodesTblView == tableView) {
        if(isteamCode == YES)
            {
            self.teamCodeTF.text = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
            teamCode = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"TeamCode"];
            self.competitionTeamCodesTblView.hidden = YES;
            
                //Sync Team Code
//            [[NSUserDefaults standardUserDefaults] setValue:self.teamCodeTF.text forKey:@"SelectedTeamName"];
//            [[NSUserDefaults standardUserDefaults] setValue:teamCode forKey:@"SelectedTeamCode"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            }
        
        if(isCompetitionCode == YES)
        {
            self.competitionCodeTF.text = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"CompetitionName"];
            competitionCode = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"CompetitionCode"];
            self.competitionTeamCodesTblView.hidden = YES;
        
            //Sync Competition Code
            [[NSUserDefaults standardUserDefaults] setValue:self.competitionCodeTF.text forKey:@"SelectedCompetitionName"];
            [[NSUserDefaults standardUserDefaults] setValue:competitionCode forKey:@"SelectedCompetitionCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (isGroundCode == YES) {
            self.groundLbl.text = [NSString stringWithFormat:@"%@ %@", [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"GroundName"], [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"Venue"]];
            
            groundCode = [[self.codeArray objectAtIndex:indexPath.row] valueForKey:@"GroundCode"];
            self.competitionTeamCodesTblView.hidden = YES;
                //Get Ground Combo Box Results
            [self groundGetService];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)barchartMultiple
{
    self.title = @"Multiple Bar Chart";
    
//    self.options = @[
//                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
//                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
//                     @{@"key": @"animateX", @"label": @"Animate X"},
//                     @{@"key": @"animateY", @"label": @"Animate Y"},
//                     @{@"key": @"animateXY", @"label": @"Animate XY"},
//                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
//                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
//                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
//                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
//                     @{@"key": @"toggleBarBorders", @"label": @"Show Bar Borders"},
//                     ];
    
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    //    BalloonMarker *marker = [[BalloonMarker alloc]
    //                             initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
    //                             font: [UIFont systemFontOfSize:12.0]
    //                             textColor: UIColor.whiteColor
    //                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    //    marker.chartView = _chartView;
    //    marker.minimumSize = CGSizeMake(80.f, 40.f);
    //    _chartView.marker = marker;
    
    ChartLegend *legend = _chartView.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    legend.verticalAlignment = ChartLegendVerticalAlignmentTop;
    legend.orientation = ChartLegendOrientationVertical;
    legend.drawInside = YES;
    legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:8.f];
    legend.yOffset = 10.0;
    legend.xOffset = 10.0;
    legend.yEntrySpace = 0.0;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    xAxis.granularity = 1.f;
    xAxis.centerAxisLabelsEnabled = YES;
    //xAxis.valueFormatter = [[IntAxisValueFormatter alloc] init];
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.maximumFractionDigits = 1;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    //leftAxis.valueFormatter = [[HorizontalXLblFormatter alloc] init];
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.spaceTop = 0.35;
    leftAxis.axisMinimum = 0;
    
    _chartView.rightAxis.enabled = NO;
    
    _sliderX.value = 10.0;
    _sliderY.value = 100.0;
    [self slidersValueChanged:nil];
}


- (void)updateChartData
{
//    if (self.shouldHideData)
//    {
//        _chartView.data = nil;
//        return;
//    }
    
    [self setDataCount:_sliderX.value range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range
{
    float groupSpace = 0.08f;
    float barSpace = 0.03f;
    float barWidth = 0.2f;
    // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals4 = [[NSMutableArray alloc] init];
    
    double randomMultiplier = range * 100000.f;
    
    int groupCount = count + 1;
    int startYear = 1980;
    int endYear = startYear + groupCount;
    
    for (int i = startYear; i < endYear; i++)
    {
        [yVals1 addObject:[[BarChartDataEntry alloc]
                           initWithX:i
                           y:(double) (arc4random_uniform(randomMultiplier))]];
        
        [yVals2 addObject:[[BarChartDataEntry alloc]
                           initWithX:i
                           y:(double) (arc4random_uniform(randomMultiplier))]];
        
        [yVals3 addObject:[[BarChartDataEntry alloc]
                           initWithX:i
                           y:(double) (arc4random_uniform(randomMultiplier))]];
        
        [yVals4 addObject:[[BarChartDataEntry alloc]
                           initWithX:i
                           y:(double) (arc4random_uniform(randomMultiplier))]];
    }
    
    BarChartDataSet *set1 = nil, *set2 = nil, *set3 = nil, *set4 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set2 = (BarChartDataSet *)_chartView.data.dataSets[1];
        set3 = (BarChartDataSet *)_chartView.data.dataSets[2];
        set4 = (BarChartDataSet *)_chartView.data.dataSets[3];
        set1.values = yVals1;
        set2.values = yVals2;
        set3.values = yVals3;
        set4.values = yVals4;
        
        BarChartData *data = _chartView.barData;
        
        _chartView.xAxis.axisMinimum = startYear;
        _chartView.xAxis.axisMaximum = [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * _sliderX.value + startYear;
        [data groupBarsFromX: startYear groupSpace: groupSpace barSpace: barSpace];
        
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals1 label:@"Company A"];
        [set1 setColor:[UIColor colorWithRed:104/255.f green:241/255.f blue:175/255.f alpha:1.f]];
        
        set2 = [[BarChartDataSet alloc] initWithValues:yVals2 label:@"Company B"];
        [set2 setColor:[UIColor colorWithRed:164/255.f green:228/255.f blue:251/255.f alpha:1.f]];
        
        set3 = [[BarChartDataSet alloc] initWithValues:yVals3 label:@"Company C"];
        [set3 setColor:[UIColor colorWithRed:242/255.f green:247/255.f blue:158/255.f alpha:1.f]];
        
        set4 = [[BarChartDataSet alloc] initWithValues:yVals4 label:@"Company D"];
        [set4 setColor:[UIColor colorWithRed:255/255.f green:102/255.f blue:0/255.f alpha:1.f]];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        [dataSets addObject:set3];
        [dataSets addObject:set4];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
       // [data setValueFormatter:[[HorizontalXLblFormatter alloc] init]];
        
        // specify the width each bar should have
        data.barWidth = barWidth;
        
        // restrict the x-axis range
        _chartView.xAxis.axisMinimum = startYear;
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        _chartView.xAxis.axisMaximum = startYear + [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * groupCount;
        
        [data groupBarsFromX: startYear groupSpace: groupSpace barSpace: barSpace];
        
        _chartView.data = data;
    }
}



#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    int startYear = 1980;
    int endYear = startYear + _sliderX.value;
    
    _sliderTextX.text = [NSString stringWithFormat:@"%d-%d", startYear, endYear];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


- (void)createBarChart{
    
    if (self.barChartMultipleView == nil) {
    
        _barChartMultipleView = [[BarChart alloc] initWithFrame:CGRectMake(0, 0, self.barchart.frame.size.width, self.barchart.frame.size.height)];
        //_barChartMultipleView = [[BarChart alloc]init];
        [_barChartMultipleView setDataSource:self];
        [_barChartMultipleView setDelegate:self];
        [_barChartMultipleView setLegendViewType:LegendTypeHorizontal];
        [_barChartMultipleView setShowCustomMarkerView:TRUE];
        [_barChartMultipleView drawBarGraph];
        [_barChartMultipleView setLegendViewType:@"fff"];
        
        
//        [_barChartMultipleView removeFromSuperview];
        [self.barchart addSubview:_barChartMultipleView];
    }
    else{
        [_barChartMultipleView setLegendViewType:LegendTypeHorizontal];
        [_barChartMultipleView setShowCustomMarkerView:TRUE];

        [self.barChartMultipleView reloadBarGraph];
    }
}
#pragma mark BarChartDataSource
- (NSMutableArray *)xDataForBarChart{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //[array addObject:@""];
    for (int i = 0; i < arr.count; i++) {
            [array addObject:[NSString stringWithFormat:@"%@", [[arr objectAtIndex:i] valueForKey:@"BFOvers"]]];
    }
    return  array;
}

- (NSInteger)numberOfBarsToBePlotted{
    return 2;
}

- (UIColor *)colorForTheBarWithBarNumber:(NSInteger)barNumber{
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    return randColor;
}

- (CGFloat)widthForTheBarWithBarNumber:(NSInteger)barNumber{
    return 40;
}

- (NSString *)nameForTheBarWithBarNumber:(NSInteger)barNumber{
    
    if(barNumber == 0)
    {
        return [NSString stringWithFormat:@"Avg - All Matches"];
    }
    else if(barNumber == 1)
    {
    return [NSString stringWithFormat:@"Avg - Win Matches"];
    }
    return nil;
}

- (NSMutableArray *)yDataForBarWithBarNumber:(NSInteger)barNumber{
    NSMutableArray *array;
//    NSArray *arr = @[ @"20",@"30",@"40",@"20",@"20",@"30",@"40",@"20"];
//    NSArray *arr1 = @[ @"10",@"20",@"30",@"40",@"10",@"20",@"30",@"40"];
    
    if(barNumber==0)
    {
        array = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            // [array addObject:[NSNumber numberWithLong:random() % 100]];
            [array addObject:[[arr objectAtIndex:i]valueForKey:@"BFScore"]];
        }
    }
    if(barNumber==1)
    {
        array = [[NSMutableArray alloc] init];
        for (int i = 0; i < arr.count; i++) {
            // [array addObject:[NSNumber numberWithLong:random() % 100]];
            [array addObject:[[arr objectAtIndex:i]valueForKey:@"BSRuns"]];
        }
    }
    return array;
}

- (UIView *)customViewForBarChartTouchWithValue:(NSNumber *)value{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:4.0F];
    [view.layer setBorderWidth:1.0F];
    [view.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:2.0F];
    [view.layer setShadowOpacity:0.3F];

    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"%@", value]];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:label];

    [view setFrame:label.frame];
    return view;
}

#pragma mark BarChartDelegate
- (void)didTapOnBarChartWithValue:(NSString *)value{
    NSLog(@"Bar Chart: %@",value);
}

- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

- (IBAction)actionDropDowns:(id)sender {
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    if ([sender tag] == 0) // Competitions
    {
//        dropVC.array = appDel.ArrayCompetition;
        dropVC.key = @"CompetitionName";
        NSMutableArray* arr = [NSMutableArray new];
        [arr addObjectsFromArray:appDel.ArrayCompetition];
        NSDictionary* temp = @{
                               @"CompetitionCode": @"none",
                               @"CompetitionName": @"All",
                               @"Groundcode": @"none",
                               @"Ground": @"All"
                               };
        [arr insertObject:temp atIndex:0];
        
        dropVC.array = arr;

        dropVC.key = @"CompetitionName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(competitionView.frame), CGRectGetMaxY(competitionView.superview.frame), CGRectGetWidth(competitionView.frame), 300)];
        
    }
    else if ([sender tag] == 1) // Teams
    {
//        dropVC.array = [COMMON getCorrespondingTeamName:competitionCodeTF.text];
        
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"CompetitionCode != %@",@""];
        
        NSArray* temparray = [appDel.MainArray filteredArrayUsingPredicate:predicate];

        NSMutableArray* resultedArray = [NSMutableArray new];
        for (NSDictionary* dict in temparray) {
            if (![[resultedArray valueForKey:@"TeamCode"] containsObject:[dict valueForKey:@"TeamCode"]]) {
                [resultedArray addObject:dict];
            }
        }

//        NSMutableArray* arr = [NSMutableArray new];
//        [arr addObjectsFromArray:appDel.ArrayCompetition];
        NSDictionary* temp = @{
                               @"TeamCode": @"none",
                               @"TeamName": @"All"
                               };
        [resultedArray insertObject:temp atIndex:0];
        
        dropVC.array = resultedArray;

        dropVC.key = @"TeamName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(teamView.frame), CGRectGetMaxY(teamView.superview.frame), CGRectGetWidth(teamView.frame), 300)];
        
    }
    else if ([sender tag] == 2) { // X Axis value
        
//        NSArray* arr = @[@{@"Xvalue":@"Runs"},
//                         @{@"Xvalue":@"Wickets"},
//                         @{@"Xvalue":@"Strike Rate"},
//                         @{@"Xvalue":@"Runs per over"},
//                         @{@"Xvalue":@"Dot balls %"},
//                         @{@"Xvalue":@"Boundaries %"}];
        
//        if (!groundResultsArray.count) {
//            [self groundListGetService];
//        }
        
        NSMutableArray* arr = [NSMutableArray new];
        for (NSDictionary* temp1 in appDel.MainArray) {
            if (![[arr valueForKey:@"GroundCode"] containsObject:[temp1 valueForKey:@"GroundCode"]]) {
                [arr addObject:temp1];
            }
        }
        
//        NSDictionary* temp = @{
//                               @"CompetitionCode": @"",
//                               @"CompetitionName": @"All",
//                               @"GroundCode": @"",
//                               @"GroundName": @"All"
//                               };
//        [arr insertObject:temp atIndex:0];

        dropVC.array = arr;
        dropVC.key = @"GroundName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(groundView.frame), CGRectGetMaxY(groundView.superview.frame), CGRectGetWidth(groundView.frame), 300)];
        
    }
//    else if ([sender tag] == 3) // Y Axis value
//    {
//
//        NSArray* arr = @[@{@"Yvalue":@"Runs"},
//                         @{@"Yvalue":@"Wickets"},
//                         @{@"Yvalue":@"Strike Rate"},
//                         @{@"Yvalue":@"Runs per over"},
//                         @{@"Yvalue":@"Dot balls %"},
//                         @{@"Yvalue":@"Boundaries %"}];
//
//        dropVC.array = arr;
//        dropVC.key = @"Yvalue";
//        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(lineView.frame), CGRectGetMaxY(lineView.superview.frame)+70+50, CGRectGetWidth(lineView.frame), 300)];
//
//    }
    
    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];
    
}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    if ([key  isEqualToString: @"CompetitionName"]) {
        
        NSLog(@"%@",array[Index.row]);
        NSLog(@"selected value %@",key);
        competitionCodeTF.text = [[array objectAtIndex:Index.row] valueForKey:key];
        competitionCode = [[array objectAtIndex:Index.row] valueForKey:@"CompetitionCode"];
        
        if (![[[array objectAtIndex:Index.row] valueForKey:key] isEqualToString:@"All"]) {

        [[NSUserDefaults standardUserDefaults] setValue:competitionCodeTF.text forKey:@"SelectedCompetitionName"];
        [[NSUserDefaults standardUserDefaults] setValue:competitionCode forKey:@"SelectedCompetitionCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        teamCodeTF.text = @"Team Name";
        
    }
    else if([key isEqualToString:@"TeamName"])
    {
        teamCodeTF.text = [[array objectAtIndex:Index.row] valueForKey:key];
        teamCode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
        
        if (![[[array objectAtIndex:Index.row] valueForKey:key] isEqualToString:@"All"]) {

        [[NSUserDefaults standardUserDefaults] setValue:teamCodeTF.text forKey:@"SelectedTeamName"];
        [[NSUserDefaults standardUserDefaults] setValue:teamCode forKey:@"SelectedTeamCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
//        groundLbl.text = @"";
        
    }
    else //if([key isEqualToString:@"GroundName"])
    {
        groundLbl.text = [NSString stringWithFormat:@"%@, %@", [[array objectAtIndex:Index.row] valueForKey:@"GroundName"], [[array objectAtIndex:Index.row] valueForKey:@"City"]];
        
        groundCode = [[array objectAtIndex:Index.row] valueForKey:@"GroundCode"];

    }
    [self groundGetService];
    
    
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

- (IBAction)onClickMoreMatches:(id)sender
{
    ResultsVc* objresult = (ResultsVc *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ResultsVc"];
    [appDel.frontNavigationController pushViewController:objresult animated:YES];
    
}

- (IBAction)resultOverwise:(id)sender {
    
    for (UIButton* btn in overBlockbtn) {
        if ([sender isEqual:btn]) {
            //[[btn titleLabel] setFont:[UIFont fontWithName:@"Montserrat Bold" size:13]];
            [btn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            //[[btn titleLabel] setFont:[UIFont fontWithName:@"Montserrat Regular" size:13]];
            [btn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    if ([sender tag] == 0) // over 1-6
    {
        fromOver = @"0";
        toOver = @"5";

    }
    else if ([sender tag] == 1) // over 7-15
    {
        fromOver = @"6";
        toOver = @"14";

    }
    else if ([sender tag] == 2) // over 16-20
    {
        fromOver = @"15";
        toOver = @"19";

    }

    [self groundOverResultsGetService];

}


@end
