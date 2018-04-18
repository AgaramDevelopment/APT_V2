//
//  MyStatsBattingVC.m
//  APT_V2
//
//  Created by MAC on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "MyStatsBattingVC.h"
#import "MyStatsBattingCell.h"
#import "Config.h"
#import "AppCommon.h"
#import "WebService.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "ScoreCardVC.h"
#import "AppDelegate.h"
#import "TabbarVC.h"

@interface MyStatsBattingVC ()
{
    NSInteger selectedIndex;
    NSIndexPath *lastIndex;
    
    NSString *userCode;
    NSString *clientCode;
    NSString *userRefCode;
    
        //wagon
    BOOL isOnes;
    BOOL isTwos;
    BOOL isThrees;
    BOOL isFours;
    BOOL isSixes;
    BOOL isDotBall;
    BOOL isWkt;
    BOOL isAll;
    
    UIColor *strokeColor;
    UIButton * Img_ball;
    
    NSMutableArray *CommonArray;
    
    BOOL isBatting;
    BOOL isBowling;
    
    TabbarVC *objtab;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *battingTableViewHeight;

@end

@implementation MyStatsBattingVC

@synthesize selectedPlayerCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        //Get Server Data
    bowlingmatchDetailsArray = [NSMutableArray new];
    bowlingWagonWheelDrawData = [NSMutableArray new];
    bowlingPitchData = [NSMutableArray new];
    
    //Get Server Data
    battingmatchDetailsArray = [NSMutableArray new];
    battingWagonWheelDrawData = [NSMutableArray new];
    battingPitchData = [NSMutableArray new];
    
    
    self.PlayerNamelbl.text = self.selectedPlayerName;
//    lastIndex = NULL;
//    selectedIndex = -1;
//
//    isOnes = YES;
//    isTwos = YES;
//    isThrees = YES;
//    isFours = YES;
//    isSixes = YES;
//    isWkt = YES;
//     isDotBall = YES;
//    isBatting = YES;
//    isBowling = NO;
    
    [self myStatsBattingPostMethodWebService];
 //   [self myStatsBowlingPostMethodWebService];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [self.navBar addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden = NO;
    objCustomNavigation.menu_btn.hidden = YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
    // number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
    // number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return overAllArray.count;
    }
    if (section == 1) {
        return recentMatchesArray.count;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyStatsBattingCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyStatsBattingCell" owner:self options:nil];
     if (section == 0) {
         return nil;
     }
    if (section == 1) {
            // 1. Dequeue the custom header cell
        headerCell = arr[1];
            // 2. Set the various properties
            //    headerCell.title.text = @"Custom header from cell";
            //    [headerCell.title sizeToFit];
            //
            //    headerCell.subtitle.text = @"The subtitle";
            //    [headerCell.subtitle sizeToFit];
            //
            //    headerCell.image.image = [UIImage imageNamed:@"smiley-face"];
        
            // 3. And return
        return headerCell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if (section == 1) {
        return (IS_IPAD)?65:55;
    }
    return 0;
}


    // the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStatsBattingCell *cell;
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyStatsBattingCell" owner:self options:nil];
   
    if (isBatting) {
    if (indexPath.section == 0) {
        NSString * cellIdentifier =  @"battingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = arr[0];
        
        
         cell.matchNmatchLbl.text = @"M";
         cell.inningsNinningsLbl.text = @"INN";
         cell.noNoversLbl.text = @"NO";
         cell.runsNwicketsLbl.text = @"RUNS";
         cell.ballsNrunsLbl.text = @"BALLS";
         cell.avgNecoLbl.text = @"AVG";
         cell.srNavgLbl.text = @"SR";
         cell.hundredsNsrLbl.text = @"100's";
         cell.fiftiesNthreewLbl.text = @"50's";
         cell.thirtiesNfivewLbl.text = @"30's";
         cell.foursNbbiLbl.text = @"4's";
         cell.sixsNwideLbl.text = @"6's";
         cell.bdyNnoBallLbl.text = @"BDY %";
         cell.dotNdbLbl.text = @"DOT %";
         cell.hsNbdryLbl.text = @"HS";
        
        
        cell.overallMatchesLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Matches"];
        cell.overallInningsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Inns"];
        cell.overallNOLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"NOs"];
        cell.overallRunsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
        cell.overallBallsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Balls"];
        cell.overallAvgLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"BatAve"];
        cell.overallSRLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"BatSR"];
        NSLog(@"S:%@", [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"hunderds"]);
        NSString *hundreds = [self checkNull:[[overAllArray objectAtIndex:indexPath.row] valueForKey:@"hunderds"]];
        if ([hundreds isEqualToString:@""]) {
            hundreds = @"0";
        }
        cell.overallHundredsLbl.text = hundreds;
        NSLog(@"%@", cell.overallHundredsLbl.text);
        cell.overallFiftiesLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"fifties"];
        cell.overallThirtiesLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"thirties"];
        cell.overallFoursLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Fours"];
        cell.overallSixsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Sixs"];
        cell.overallBDYPercentLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"boundariespercent"];
        cell.overallDotPercentLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"dotspercent"];
        cell.overallHSLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"HS"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    if (indexPath.section == 1) {

        NSString * cellIdentifier = (IS_IPAD)? @"battingCellForiPad" : @"battingCellForiPhone";
        cell =(MyStatsBattingCell *) [self.batttingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"MyStatsBattingCell" owner:self options:nil];
            cell = (IS_IPAD)?self.StatsBattingCell: self.StatsBattingCellIphone;
                // self.batsmanCell = nil;
        }
        cell.backgroundColor = [UIColor clearColor];

    
            //Drop Down Action For Expanded Cell
        [[cell dropDowniPhoneBtn] setTag:[indexPath row]];
        [cell.dropDowniPhoneBtn addTarget:self action:@selector(didClickDropDownButtonForExpandCell:) forControlEvents:UIControlEventTouchUpInside];
        
        [[cell dropDowniPadBtn] setTag:[indexPath row]];
        [cell.dropDowniPadBtn addTarget:self action:@selector(didClickDropDownButtonForExpandCell:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"recentMatchesArray:%@", recentMatchesArray);
        if (IS_IPAD) {
            cell.teamNameiPadLbl.text =  [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"OppTeamName"];
                //            cell.teamiPadImage.image = nil;
            cell.teamRunsiPadLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
            NSString *runs = [NSString stringWithFormat:@"(%@)", [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Balls"]];
            cell.teamBallsiPadLbl.text = runs;
            
                // Match Date
            NSString *myString = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"MatchDate"];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
            NSDate *yourDate = [dateFormatter dateFromString:myString];
            dateFormatter.dateFormat = @"dd MMM, yyyy";
            NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
            
            
            cell.matchDateiPadLbl.text = [dateFormatter stringFromDate:yourDate];
            cell.groundNameiPadLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"GroundName"];
            

            if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"HOME"])
            {
                cell.teamiPadImage.image = [UIImage imageNamed:@"matchHome"];
            }
            else  if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"AWAY"])
            {
                cell.teamiPadImage.image = [UIImage imageNamed:@"matchAway"];
            }
            else
            {
                cell.teamiPadImage.image = [UIImage imageNamed:@"NeutralImg"];
            }
           
                if (matchDetailsArray.count != 0 && indexPath.row == selectedIndex) {

                // EXpanded iPad Cell Header
                cell.srNecoiPadLbl.text = @"SR";
                cell.dotNnbiPadLbl.text = @"DOT %";
                cell.bdyNwdiPadLbl.text = @"BDY %";
                cell.foursNfoursiPadLbl.text = @"4's";
                cell.sixsNsixsiPadLbl.text = @"6's";
                cell.bdyFeqNdbiPadLbl.text = @"BDY Fq";
                
                
                cell.matchSRiPadLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"BatSR"];
                cell.matchDotiPadLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"dotspercent"];
                cell.matchBDYiPadLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"boundariespercent"];
                cell.matchFoursiPadLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Fours"];
                cell.matchSixsiPadLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Sixs"];
                cell.matchBDYFqiPadLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"boundaryfrequency"];
                
                [cell.onesBtniPad addTarget:self action:@selector(didClickOnesBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.twoBtniPad addTarget:self action:@selector(didClicktwosBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.threeBtniPad addTarget:self action:@selector(didClickthreeBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.fourBtniPad addTarget:self action:@selector(didClickfourssBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.sixBtniPad addTarget:self action:@selector(didClicksixesBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.dotBtniPad addTarget:self action:@selector(didClickdotsBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.wktBtniPad addTarget:self action:@selector(didClickwicketBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.alllbliPad addTarget:self action:@selector(didClickAllBatting:) forControlEvents:UIControlEventTouchUpInside];
                
                    

                    //wagon wheel
                if(self.wagonWheelDrawData.count>0)
                    {
                        //for(int i=0;i<self.wagonWheelDrawData.count;i++)
                    
                    NSMutableArray *sepArray = [[NSMutableArray alloc]init];
//                    sepArray= [[self.wagonWheelDrawData valueForKey:@"BattingSpiderWagonWheelValues"]objectAtIndex:indexPath.row];
                        sepArray= [self.wagonWheelDrawData valueForKey:@"BattingSpiderWagonWheelValues"];
                    if(![sepArray isEqual:[NSNull null]])
                        {
                        
                        for(int i=0;sepArray.count>i;i++)
                            {
                            for (CALayer *layer in cell.WagonImgiPad.layer.sublayers) {
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
                                //SpiderWagonRecords * objRecord =(SpiderWagonRecords *)[_spiderWagonArray objectAtIndex:i];
                            
                            
                                //                if(IS_IPHONE_DEVICE)
                                //                {
                                //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                //                }
                                //
                                //                else
                                //                {
                                //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-70;
                                //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-70;
                                //
                                //                }
                                //
                                //
                                //                self.selectRuns =[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                                //
                                //                int Xposition = x1position-60;
                                //                int Yposition = y1position-40;
                                //
                                //
                                //                CGMutablePathRef straightLinePath = CGPathCreateMutable();
                                //                CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                                //                CGPathAddLineToPoint(straightLinePath, NULL,(x2position/2)+60,(y2position/2)+60);
                            
                            if(IS_IPHONE_DEVICE)
                                {
                                x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                }
                            
                            else
                                {
                                    //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                    //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                    //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue];
                                    //                  y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue];
                                
                                x1position = 100;
                                y1position = 84.7;
                                    //                    x2position  =196;
                                    //                    y2position  =109;
                                
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
                                [cell.onesBtniPad setTitle:ss forState:UIControlStateNormal];
                                
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
                                [cell.twoBtniPad setTitle:ss forState:UIControlStateNormal];
                                
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
                                [cell.threeBtniPad setTitle:ss forState:UIControlStateNormal];
                                
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
                                [cell.fourBtniPad setTitle:ss forState:UIControlStateNormal];
                                
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
                                
                                
                                
                                    //                }else if ([self.selectRuns isEqualToString: @"5"]){
                                    //                   // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                    //                    NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                                    //                    strokeColor = [self colorWithHexString:color];
                                
                            }else if ([self.selectRuns isEqualToString: @"6"]){
                                
                                
                                    // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                [sixscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)sixscount.count];
                                [cell.sixBtniPad setTitle:ss forState:UIControlStateNormal];
                                
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
                                
                            } else if ([self.selectRuns isEqualToString: @"90"]){
                                
                                    //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                                [cell.dotBtniPad setTitle:ss forState:UIControlStateNormal];
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
                            
                                //                else if ([self.selectRuns isEqualToString: @"0"]){
                                //
                                //                    //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                //                    strokeColor = [self colorWithHexString:color];
                                //
                                //                }
                            
                            
                                //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
                                //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
                                //        }
                                //
                            
                            shapeLayer.strokeColor = strokeColor.CGColor;
                            shapeLayer.lineWidth = 2.0f;
                            shapeLayer.fillRule = kCAFillRuleNonZero;
                            shapeLayer.name = @"DrawLine";
                            [cell.WagonImgiPad.layer addSublayer:shapeLayer];
                            
                                //}
                            }
                        }
                    }
                
                    //pitch map
                
                if(self.pitchData.count>0)
                    {
                    
                    NSMutableArray *sepArray = [[NSMutableArray alloc]init];
//                    sepArray= [[self.pitchData valueForKey:@"PitchMapValuesBatting"]objectAtIndex:indexPath.row];
                    sepArray= [self.pitchData valueForKey:@"PitchMapValuesBatting"];
                    for(UIImageView * obj in [cell.PitchImgiPad subviews])
                        {
                        NSLog(@"%@",obj);
                        [obj removeFromSuperview];
                        }
                    
                    
                    int xposition;
                    int yposition;
                    
                    if(![sepArray isEqual:[NSNull null]])
                        {
                        for(int i=0; i<sepArray.count;i++)
                            {
                                //PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
                            
                            if(IS_IPHONE_DEVICE)
                                {
                                xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-90;
                                yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-60;
                                }
                            else
                                {
                                
                                
                                    //                        xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-83;
                                    //                        yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-30;
                                
                                
                                xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*200)-4;
                                yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*200)-1;
                                
                                }
                            
                            if([[self.pitchData valueForKey:@"BattingStyle"] isEqualToString:@"RIGHT"])
                                {
                                
                                cell.PitchImgiPad.image = [UIImage imageNamed:@"Pitchmap"];
                                }
                            else
                                {
                                cell.PitchImgiPad.image = [UIImage imageNamed:@"PitchmapLefthand"];
                                }
                            
                            NSString * run;
                            run =([[[sepArray valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                            
                            if(!(xposition == 1 && yposition == 1) && (xposition!=0 && yposition !=0)){
                                
                                Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition,yposition,6, 6)];
                                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                                
                                Img_ball.layer.cornerRadius =3;
                                Img_ball.layer.masksToBounds=YES;
                                if ([run isEqualToString: @"1"]) {
                                    
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        // else{
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
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
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                                    if(isTwos == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ff6c00"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                }else if ([run isEqualToString: @"3"]){
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                                    
                                    if(isThrees == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"A305C0"];
                                        }
                                    
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                }else if ([run isEqualToString: @"4"]){
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                                    if(isFours == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"2454f1"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                    
                                }else if ([run isEqualToString: @"5"]){
                                        // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                    if(isFours == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                    
                                } else if ([run isEqualToString: @"6"]){
                                        // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    
                                    
                                    if(isSixes == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ff00ea"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                    
                                }else if ([run isEqualToString: @"90"]){
                                    
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    
                                    
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
                                        //ed1d24
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    
                                    
                                    
                                    if(isWkt == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ed1d24"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                }
                                
                                    //                        else if ([run isEqualToString: @"0"]){
                                    //
                                    //                            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    //                        }
                                
                                [cell.PitchImgiPad addSubview:Img_ball];
                                
                            }
                            }
                        }
                    }
            }
            
        } else {
            cell.teamNameiPhoneLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"OppTeamName"];
            NSLog(@"OppTeamName:%@", cell.teamNameiPhoneLbl.text);
//            cell.teamiPhoneImage.image = nil;
            cell.teamRunsiPhoneLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
            NSString *runs = [NSString stringWithFormat:@"(%@)", [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Balls"]];
            cell.teamBallsiPhoneLbl.text = runs;
            
                // Match Date
            NSString *myString = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"MatchDate"];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
            NSDate *yourDate = [dateFormatter dateFromString:myString];
            dateFormatter.dateFormat = @"dd MMM, yyyy";
            NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
            
            cell.matchDateiPhoneLbl.text = [dateFormatter stringFromDate:yourDate];
            cell.groundNameiPhoneLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"GroundName"];
            
            if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"HOME"])
                {
                cell.teamiPhoneImage.image = [UIImage imageNamed:@"matchHome"];
                }
            else if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"AWAY"])
                {
                cell.teamiPhoneImage.image = [UIImage imageNamed:@"matchAway"];
                }
             else
               {
                 cell.teamiPhoneImage.image = [UIImage imageNamed:@"NeutralImg"];
               }
            
                if (matchDetailsArray.count != 0 && indexPath.row == selectedIndex) {

                // EXpanded iPhone Cell Header
                cell.srNecoiPhoneLbl.text = @"SR";
                cell.dotNnbiPhoneLbl.text = @"DOT %";
                cell.bdyNwdiPhoneLbl.text = @"BDY %";
                cell.foursNfoursiPhoneLbl.text = @"4's";
                cell.sixsNsixsiPhoneLbl.text  = @"6's";
                cell.bdyFeqNdbiPhoneLbl.text = @"BDY Fq";
                
                cell.matchSRiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"BatSR"];
                cell.matchDotiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"dotspercent"];
                cell.matchBDYiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"boundariespercent"];
                cell.matchFoursiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Fours"];
                cell.matchSixsiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Sixs"];
                cell.matchBDYFqiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"boundaryfrequency"];
                
                [cell.onesBtniPhone addTarget:self action:@selector(didClickOnesBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.twoBtniPhone addTarget:self action:@selector(didClicktwosBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.threeBtniPhone addTarget:self action:@selector(didClickthreeBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.fourBtniPhone addTarget:self action:@selector(didClickfourssBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.sixBtniPhone addTarget:self action:@selector(didClicksixesBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.dotBtniPhone addTarget:self action:@selector(didClickdotsBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.wktBtniPhone addTarget:self action:@selector(didClickwicketBatting:) forControlEvents:UIControlEventTouchUpInside];
                [cell.alllbliPhone addTarget:self action:@selector(didClickAllBatting:) forControlEvents:UIControlEventTouchUpInside];
                
                    //wagon wheel
                if(self.wagonWheelDrawData.count>0)
                    {
                        //for(int i=0;i<self.wagonWheelDrawData.count;i++)
                    
                    NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                        //                    sepArray= [[self.wagonWheelDrawData valueForKey:@"BattingSpiderWagonWheelValues"]objectAtIndex:indexPath.row];
                    sepArray= [self.wagonWheelDrawData valueForKey:@"BattingSpiderWagonWheelValues"];
                    if(![sepArray isEqual:[NSNull null]])
                        {
                        
                        for(int i=0;sepArray.count>i;i++)
                            {
                            for (CALayer *layer in cell.WagonImgiPhone.layer.sublayers) {
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
                                //SpiderWagonRecords * objRecord =(SpiderWagonRecords *)[_spiderWagonArray objectAtIndex:i];
                            
                            
                                //                if(IS_IPHONE_DEVICE)
                                //                {
                                //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                //                }
                                //
                                //                else
                                //                {
                                //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-70;
                                //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-70;
                                //
                                //                }
                                //
                                //
                                //                self.selectRuns =[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                                //
                                //                int Xposition = x1position-60;
                                //                int Yposition = y1position-40;
                                //
                                //
                                //                CGMutablePathRef straightLinePath = CGPathCreateMutable();
                                //                CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                                //                CGPathAddLineToPoint(straightLinePath, NULL,(x2position/2)+60,(y2position/2)+60);
                            
                            if(IS_IPHONE_DEVICE)
                                {
//                                x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
//                                y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                x1position = 65;
                                y1position = 55;
//                                x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
//                                y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                x2position  = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*130);
                                y2position  = (([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*130);
                                }
                            
                            else
                                {
                                    //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                    //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                    //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue];
                                    //                  y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue];
                                
                                x1position = 100;
                                y1position = 84.7;
                                    //                    x2position  =196;
                                    //                    y2position  =109;
                                
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
                                [cell.onesBtniPhone setTitle:ss forState:UIControlStateNormal];
                                
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
                                [cell.twoBtniPhone setTitle:ss forState:UIControlStateNormal];
                                
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
                                [cell.threeBtniPhone setTitle:ss forState:UIControlStateNormal];
                                
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
                                [cell.fourBtniPhone setTitle:ss forState:UIControlStateNormal];
                                
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
                                
                                
                                
                                    //                }else if ([self.selectRuns isEqualToString: @"5"]){
                                    //                   // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                    //                    NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                                    //                    strokeColor = [self colorWithHexString:color];
                                
                            } else if ([self.selectRuns isEqualToString: @"6"]){
                                
                                
                                    // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                [sixscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)sixscount.count];
                                [cell.sixBtniPhone setTitle:ss forState:UIControlStateNormal];
                                
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
                                
                            } else if ([self.selectRuns isEqualToString: @"90"]){
                                
                                    //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                                [cell.dotBtniPhone setTitle:ss forState:UIControlStateNormal];
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
                                //                else if ([self.selectRuns isEqualToString: @"0"]){
                                //
                                //                    //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                //                    strokeColor = [self colorWithHexString:color];
                                //
                                //                }
                            
                            
                                //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
                                //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
                                //        }
                                //
                            
                            shapeLayer.strokeColor = strokeColor.CGColor;
                            shapeLayer.lineWidth = 2.0f;
                            shapeLayer.fillRule = kCAFillRuleNonZero;
                            shapeLayer.name = @"DrawLine";
                            [cell.WagonImgiPhone.layer addSublayer:shapeLayer];
                            
                                //}
                            }
                        }
                    }
                
                    //pitch map
                
                if(self.pitchData.count>0)
                    {
                    
                    NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                        //                    sepArray= [[self.pitchData valueForKey:@"PitchMapValuesBatting"]objectAtIndex:indexPath.row];
                    sepArray= [self.pitchData valueForKey:@"PitchMapValuesBatting"];
                    for(UIImageView * obj in [cell.PitchImgiPhone subviews])
                        {
                        NSLog(@"%@",obj);
                        [obj removeFromSuperview];
                        }
                    
                    
                    int xposition;
                    int yposition;
                    
                    if(![sepArray isEqual:[NSNull null]])
                        {
                        for(int i=0; i<sepArray.count;i++)
                            {
                                //PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
                            
                            if(IS_IPHONE_DEVICE)
                                {
//                                xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-90;
//                                yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-60;
                                xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*130)-4;
                                yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*130)-1;
                                }
                            else
                                {
                                
                                
                                    //                        xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-83;
                                    //                        yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-30;
                                
                                
                                xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*200)-4;
                                yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*200)-1;
                                
                                }
                            
                            if([[self.pitchData valueForKey:@"Battingstyle"] isEqualToString:@"RIGHT"])
                                {
                                
                                cell.PitchImgiPhone.image = [UIImage imageNamed:@"Pitchmap"];
                                }
                            else
                                {
                                cell.PitchImgiPhone.image = [UIImage imageNamed:@"PitchmapLefthand"];
                                }
                            
                            NSString * run;
                            run =([[[sepArray valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                            
                            if(!(xposition == 1 && yposition == 1) && (xposition!=0 && yposition !=0)){
                                
                                Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition,yposition,6, 6)];
                                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                                
                                Img_ball.layer.cornerRadius =3;
                                Img_ball.layer.masksToBounds=YES;
                                if ([run isEqualToString: @"1"]) {
                                    
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        // else{
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
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
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                                    if(isTwos == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ff6c00"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                }else if ([run isEqualToString: @"3"]){
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                                    
                                    if(isThrees == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"A305C0"];
                                        }
                                    
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                }else if ([run isEqualToString: @"4"]){
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                                    if(isFours == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"2454f1"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                    
                                }else if ([run isEqualToString: @"5"]){
                                        // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                    if(isFours == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                    
                                }else if ([run isEqualToString: @"6"]){
                                        // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    
                                    
                                    if(isSixes == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ff00ea"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                    
                                } else if ([run isEqualToString: @"90"]){
                                    
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    
                                    
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
                                        //ed1d24
                                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    
                                    
                                    
                                    if(isWkt == YES)
                                        {
                                        Img_ball.backgroundColor = [self colorWithHexString:@"ed1d24"];
                                        }
                                    else
                                        {
                                        Img_ball.backgroundColor =[UIColor clearColor];
                                        }
                                    
                                }
                                
                                    //                        else if ([run isEqualToString: @"0"]){
                                    //
                                    //                            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    //                        }
                                
                                [cell.PitchImgiPhone addSubview:Img_ball];
                                
                            }
                            }
                        }
                    }
            }
        }
        cell.selectionStyle = UIAccessibilityTraitNone;
    }
        return cell;
    }
    
    
    if (isBowling) {
        if (indexPath.section == 0) {
            NSString * cellIdentifier =  @"battingCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell = arr[0];
            
            cell.matchNmatchLbl.text = @"M";
            cell.inningsNinningsLbl.text = @"INN";
            cell.noNoversLbl.text = @"OVERS";
            cell.runsNwicketsLbl.text = @"WICKETS";
            cell.ballsNrunsLbl.text = @"RUNS";
            cell.avgNecoLbl.text = @"ECO";
            cell.srNavgLbl.text = @"AVG";
            cell.hundredsNsrLbl.text = @"SR";
            cell.fiftiesNthreewLbl.text = @"3 W";
            cell.thirtiesNfivewLbl.text = @"5 W";
            cell.foursNbbiLbl.text = @"BBI";
            cell.sixsNwideLbl.text = @"WIDE";
            cell.bdyNnoBallLbl.text = @"NO BALL";
            cell.dotNdbLbl.text = @"DB %";
            cell.hsNbdryLbl.text = @"BDRY %";
            
            
            cell.overallMatchesLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Matches"];
            cell.overallInningsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Inns"];
            cell.overallNOLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Overs"];
            cell.overallRunsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"wickets"];
            cell.overallBallsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Runs"];
            cell.overallAvgLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Econ"];
            
            cell.overallSRLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"BowlAve"];
            NSLog(@"S:%@", [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"BowlSR"]);
            cell.overallHundredsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"BowlSR"];
            NSLog(@"%@", cell.overallHundredsLbl.text);
            NSString *ThreesW = [self checkNull:[[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Threes"]];
            if ([ThreesW isEqualToString:@""]) {
                ThreesW = @"0";
            }
            cell.overallFiftiesLbl.text = ThreesW;
            
            NSString *FivesW = [self checkNull:[[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Fives"]];
            if ([FivesW isEqualToString:@""]) {
                FivesW = @"0";
            }

            cell.overallThirtiesLbl.text = FivesW;
            cell.overallFoursLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"BBI"];
            cell.overallSixsLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Wides"];
            cell.overallBDYPercentLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"Noballs"];
            cell.overallDotPercentLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"dotspercent"];
            cell.overallHSLbl.text = [[overAllArray objectAtIndex:indexPath.row] valueForKey:@"boundariespercent"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
        if (indexPath.section == 1) {
            
            NSString * cellIdentifier = (IS_IPAD)? @"battingCellForiPad" : @"battingCellForiPhone";
            cell =(MyStatsBattingCell *) [self.batttingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"MyStatsBattingCell" owner:self options:nil];
                cell = (IS_IPAD)?self.StatsBattingCell: self.StatsBattingCellIphone;
                    // self.batsmanCell = nil;
            }
            cell.backgroundColor = [UIColor clearColor];
            
                //Drop Down Action For Expanded Cell
            [[cell dropDowniPhoneBtn] setTag:[indexPath row]];
            [cell.dropDowniPhoneBtn addTarget:self action:@selector(didClickDropDownButtonForExpandCell:) forControlEvents:UIControlEventTouchUpInside];
            
            [[cell dropDowniPadBtn] setTag:[indexPath row]];
            [cell.dropDowniPadBtn addTarget:self action:@selector(didClickDropDownButtonForExpandCell:) forControlEvents:UIControlEventTouchUpInside];
            
            
            NSLog(@"recentMatchesArray:%@", recentMatchesArray);
            if (IS_IPAD) {
                cell.teamNameiPadLbl.text =  [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"OppTeamName"];
                    //            cell.teamiPadImage.image = nil;
                NSString *runsNwickets = [NSString stringWithFormat:@"%@/%@", [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Wickets"], [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Runs"]];
                cell.teamRunsiPadLbl.text = runsNwickets;
                NSString *runs = [NSString stringWithFormat:@"(%@)", [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Overs"]];
                cell.teamBallsiPadLbl.text = runs;
                
                    // Match Date
                NSString *myString = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"MatchDate"];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
                NSDate *yourDate = [dateFormatter dateFromString:myString];
                dateFormatter.dateFormat = @"dd MMM, yyyy";
                NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
                
                
                cell.matchDateiPadLbl.text = [dateFormatter stringFromDate:yourDate];
                cell.groundNameiPadLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"GroundName"];
                
                if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"HOME"])
                    {
                        cell.teamiPadImage.image = [UIImage imageNamed:@"matchHome"];
                    }
                else if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"AWAY"])
                    {
                        cell.teamiPadImage.image = [UIImage imageNamed:@"matchAway"];
                    }
                    else
                    {
                        cell.teamiPadImage.image = [UIImage imageNamed:@"NeutralImg"];
                    }
                
                if (matchDetailsArray.count != 0 && indexPath.row == selectedIndex) {
                    
                        // EXpanded iPad Cell Header
                    cell.srNecoiPadLbl.text = @"ECO";
                    cell.dotNnbiPadLbl.text = @"NB";
                    cell.bdyNwdiPadLbl.text = @"WD";
                    cell.foursNfoursiPadLbl.text = @"4's";
                    cell.sixsNsixsiPadLbl.text = @"6's";
                    cell.bdyFeqNdbiPadLbl.text = @"DB %";
                    
                    NSLog(@"matchDetailsArray:%@", matchDetailsArray);
                    cell.matchSRiPadLbl.text = [self checkNull:[[matchDetailsArray objectAtIndex:0] valueForKey:@"Econ"]];
                    cell.matchDotiPadLbl.text = [self checkNull:[[matchDetailsArray objectAtIndex:0] valueForKey:@"Noballs"]];
                    cell.matchBDYiPadLbl.text = [self checkNull:[[matchDetailsArray objectAtIndex:0] valueForKey:@"Wides"]];
                    cell.matchFoursiPadLbl.text = [self checkNull:[[matchDetailsArray objectAtIndex:0] valueForKey:@"Fours"]];
                    cell.matchSixsiPadLbl.text = [self checkNull:[[matchDetailsArray objectAtIndex:0] valueForKey:@"Sixs"]];
                    cell.matchBDYFqiPadLbl.text = [self checkNull:[[matchDetailsArray objectAtIndex:0] valueForKey:@"dotspercent"]];
                    
//                    NSLog(@"matchDetailsArray:%@", matchDetailsArray);
//                    cell.matchSRiPadLbl.text = [matchDetailsArray  valueForKey:@"Econ"];
//                    cell.matchDotiPadLbl.text = [matchDetailsArray  valueForKey:@"Noballs"];
//                    cell.matchBDYiPadLbl.text = [matchDetailsArray  valueForKey:@"Wides"];
//                    cell.matchFoursiPadLbl.text = [matchDetailsArray  valueForKey:@"Fours"];
//                    cell.matchSixsiPadLbl.text = [matchDetailsArray  valueForKey:@"Sixs"];
//                    cell.matchBDYFqiPadLbl.text = [matchDetailsArray  valueForKey:@"dotspercent"];
                    
                    [cell.onesBtniPad addTarget:self action:@selector(didClickOnesBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.twoBtniPad addTarget:self action:@selector(didClicktwosBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.threeBtniPad addTarget:self action:@selector(didClickthreeBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.fourBtniPad addTarget:self action:@selector(didClickfourssBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.sixBtniPad addTarget:self action:@selector(didClicksixesBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.dotBtniPad addTarget:self action:@selector(didClickdotsBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.wktBtniPad addTarget:self action:@selector(didClickwicketBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.alllbliPad addTarget:self action:@selector(didClickAllBatting:) forControlEvents:UIControlEventTouchUpInside];
                    
                        //wagon wheel
                    if(self.wagonWheelDrawData.count>0)
                        {
                            //for(int i=0;i<self.wagonWheelDrawData.count;i++)
                        
                        NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                            //                    sepArray= [[self.wagonWheelDrawData valueForKey:@"BattingSpiderWagonWheelValues"]objectAtIndex:indexPath.row];
                        sepArray= [self.wagonWheelDrawData valueForKey:@"BowlingSpiderWagonWheelValues"];
                        if(![sepArray isEqual:[NSNull null]])
                            {
                            
                            for(int i=0;sepArray.count>i;i++)
                                {
                                for (CALayer *layer in cell.WagonImgiPad.layer.sublayers) {
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
                            NSMutableArray *wktsscount = [[NSMutableArray alloc]init];
                            
                            
                            for(int i=0; i<sepArray.count;i++)
                                {
                                    //SpiderWagonRecords * objRecord =(SpiderWagonRecords *)[_spiderWagonArray objectAtIndex:i];
                                
                                
                                    //                if(IS_IPHONE_DEVICE)
                                    //                {
                                    //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                    //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                    //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                    //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                    //                }
                                    //
                                    //                else
                                    //                {
                                    //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                    //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                    //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-70;
                                    //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-70;
                                    //
                                    //                }
                                    //
                                    //
                                    //                self.selectRuns =[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                                    //
                                    //                int Xposition = x1position-60;
                                    //                int Yposition = y1position-40;
                                    //
                                    //
                                    //                CGMutablePathRef straightLinePath = CGPathCreateMutable();
                                    //                CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                                    //                CGPathAddLineToPoint(straightLinePath, NULL,(x2position/2)+60,(y2position/2)+60);
                                
                                if(IS_IPHONE_DEVICE)
                                    {
                                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                    }
                                
                                else
                                    {
                                        //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                        //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                        //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue];
                                        //                  y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue];
                                    
                                    x1position = 100;
                                    y1position = 84.7;
                                        //                    x2position  =196;
                                        //                    y2position  =109;
                                    
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
                                    [cell.onesBtniPad setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    [cell.twoBtniPad setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    [cell.threeBtniPad setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    [cell.fourBtniPad setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    
                                    
                                    
                                        //                }else if ([self.selectRuns isEqualToString: @"5"]){
                                        //                   // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                        //                    NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                                        //                    strokeColor = [self colorWithHexString:color];
                                    
                                }else if ([self.selectRuns isEqualToString: @"6"]){
                                    
                                    
                                        // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    [sixscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                    NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)sixscount.count];
                                    [cell.sixBtniPad setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    
                                } else if ([self.selectRuns isEqualToString: @"90"]){
                                    
                                    
                                    
                                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                    NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                                    [cell.dotBtniPad setTitle:ss forState:UIControlStateNormal];
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
                                
                                    //                else if ([self.selectRuns isEqualToString: @"0"]){
                                    //
                                    //                    //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    //                    strokeColor = [self colorWithHexString:color];
                                    //
                                    //                }
                                
                                
                                    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
                                    //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
                                    //        }
                                    //
                                
                                shapeLayer.strokeColor = strokeColor.CGColor;
                                shapeLayer.lineWidth = 2.0f;
                                shapeLayer.fillRule = kCAFillRuleNonZero;
                                shapeLayer.name = @"DrawLine";
                                [cell.WagonImgiPad.layer addSublayer:shapeLayer];
                                
                                    //}
                                }
                            }
                        }
                    
                        //pitch map
                    
                    if(self.pitchData.count>0)
                        {
                        
                        NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                            //                    sepArray= [[self.pitchData valueForKey:@"PitchMapValuesBatting"]objectAtIndex:indexPath.row];
                        sepArray= [self.pitchData valueForKey:@"PitchMapValuesBowling"];
                        for(UIImageView * obj in [cell.PitchImgiPad subviews])
                            {
                            NSLog(@"%@",obj);
                            [obj removeFromSuperview];
                            }
                        
                        
                        int xposition;
                        int yposition;
                        
                        if(![sepArray isEqual:[NSNull null]])
                            {
                            for(int i=0; i<sepArray.count;i++)
                                {
                                    //PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
                                
                                if(IS_IPHONE_DEVICE)
                                    {
                                    xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-90;
                                    yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-60;
                                    }
                                else
                                    {
                                    
                                    
                                        //                        xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-83;
                                        //                        yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-30;
                                    
                                    
                                    xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*200)-4;
                                    yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*200)-1;
                                    
                                    }
                                
                                if([[self.pitchData valueForKey:@"Battingstyle"] isEqualToString:@"RIGHT"])
                                    {
                                    
                                    cell.PitchImgiPad.image = [UIImage imageNamed:@"Pitchmap"];
                                    }
                                else
                                    {
                                    cell.PitchImgiPad.image = [UIImage imageNamed:@"PitchmapLefthand"];
                                    }
                                
                                NSString * run;
                                run =([[[sepArray valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                                
                                if(!(xposition == 1 && yposition == 1) && (xposition!=0 && yposition !=0)){
                                    
                                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition,yposition,6, 6)];
                                        //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                                    
                                    Img_ball.layer.cornerRadius =3;
                                    Img_ball.layer.masksToBounds=YES;
                                    if ([run isEqualToString: @"1"]) {
                                        
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                            // else{
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
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
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                                        if(isTwos == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"ff6c00"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                    }else if ([run isEqualToString: @"3"]){
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                                        
                                        if(isThrees == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"A305C0"];
                                            }
                                        
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                    }else if ([run isEqualToString: @"4"]){
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                                        if(isFours == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"2454f1"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                        
                                    }else if ([run isEqualToString: @"5"]){
                                            // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                        if(isFours == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                        
                                    }else if ([run isEqualToString: @"6"]){
                                            // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        
                                        
                                        if(isSixes == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"ff00ea"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                    } else if ([run isEqualToString: @"90"]){
                                        
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        
                                        
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
                                            //ed1d24
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        
                                        
                                        
                                        if(isWkt == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"ed1d24"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                    }
                                    
                                        //                        else if ([run isEqualToString: @"0"]){
                                        //
                                        //                            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        //                        }
                                    
                                    [cell.PitchImgiPad addSubview:Img_ball];
                                    
                                }
                                }
                            }
                        }
                }
                
            } else {
                cell.teamNameiPhoneLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"OppTeamName"];
                NSLog(@"OppTeamName:%@", cell.teamNameiPhoneLbl.text);
                    //            cell.teamiPhoneImage.image = nil;
                NSString *runsNwickets = [NSString stringWithFormat:@"%@/%@", [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Wickets"], [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Runs"]];
                cell.teamRunsiPhoneLbl.text = runsNwickets;
                NSString *overs = [NSString stringWithFormat:@"(%@)", [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Overs"]];
                cell.teamBallsiPhoneLbl.text = overs;
                
                    // Match Date
                NSString *myString = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"MatchDate"];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
                NSDate *yourDate = [dateFormatter dateFromString:myString];
                dateFormatter.dateFormat = @"dd MMM, yyyy";
                NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
                
                cell.matchDateiPhoneLbl.text = [dateFormatter stringFromDate:yourDate];
                cell.groundNameiPhoneLbl.text = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"GroundName"];
                
                if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"HOME"])
                    {
                    cell.teamiPhoneImage.image = [UIImage imageNamed:@"matchHome"];
                    }
                else if([[self checkNull:[[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"Condition"]] isEqualToString:@"AWAY"])
                    {
                    cell.teamiPhoneImage.image = [UIImage imageNamed:@"matchAway"];
                    }
                else
                {
                    cell.teamiPhoneImage.image = [UIImage imageNamed:@"NeutralImg"];
                }
                
                if (matchDetailsArray.count != 0 && indexPath.row == selectedIndex) {
                    
                        // EXpanded iPhone Cell Header
                    cell.srNecoiPhoneLbl.text = @"ECO";
                    cell.dotNnbiPhoneLbl.text = @"NB";
                    cell.bdyNwdiPhoneLbl.text = @"WD";
                    cell.foursNfoursiPhoneLbl.text = @"4's";
                    cell.sixsNsixsiPhoneLbl.text  = @"6's";
                    cell.bdyFeqNdbiPhoneLbl.text = @"DB %";
                    
                    cell.matchSRiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Econ"];
                    cell.matchDotiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Noballs"];
                    cell.matchBDYiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Wides"];
                    cell.matchFoursiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Fours"];
                    cell.matchSixsiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"Sixs"];
                    cell.matchBDYFqiPhoneLbl.text = [[matchDetailsArray objectAtIndex:0] valueForKey:@"dotspercent"];
                    
        
                    [cell.onesBtniPhone addTarget:self action:@selector(didClickOnesBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.twoBtniPhone addTarget:self action:@selector(didClicktwosBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.threeBtniPhone addTarget:self action:@selector(didClickthreeBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.fourBtniPhone addTarget:self action:@selector(didClickfourssBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.sixBtniPhone addTarget:self action:@selector(didClicksixesBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.dotBtniPhone addTarget:self action:@selector(didClickdotsBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.wktBtniPhone addTarget:self action:@selector(didClickwicketBatting:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.alllbliPhone addTarget:self action:@selector(didClickAllBatting:) forControlEvents:UIControlEventTouchUpInside];
                    
                        //wagon wheel
                    if(self.wagonWheelDrawData.count>0)
                        {
                            //for(int i=0;i<self.wagonWheelDrawData.count;i++)
                        
                        NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                            //                    sepArray= [[self.wagonWheelDrawData valueForKey:@"BattingSpiderWagonWheelValues"]objectAtIndex:indexPath.row];
                        sepArray= [self.wagonWheelDrawData valueForKey:@"BowlingSpiderWagonWheelValues"];
                        if(![sepArray isEqual:[NSNull null]])
                            {
                            
                            for(int i=0;sepArray.count>i;i++)
                                {
                                for (CALayer *layer in cell.WagonImgiPhone.layer.sublayers) {
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
                            NSMutableArray *wktsscount = [[NSMutableArray alloc]init];
                            
                            
                            for(int i=0; i<sepArray.count;i++)
                                {
                                    //SpiderWagonRecords * objRecord =(SpiderWagonRecords *)[_spiderWagonArray objectAtIndex:i];
                                
                                
                                    //                if(IS_IPHONE_DEVICE)
                                    //                {
                                    //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                    //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                    //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                    //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                    //                }
                                    //
                                    //                else
                                    //                {
                                    //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                    //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                    //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-70;
                                    //                    y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-70;
                                    //
                                    //                }
                                    //
                                    //
                                    //                self.selectRuns =[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                                    //
                                    //                int Xposition = x1position-60;
                                    //                int Yposition = y1position-40;
                                    //
                                    //
                                    //                CGMutablePathRef straightLinePath = CGPathCreateMutable();
                                    //                CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                                    //                CGPathAddLineToPoint(straightLinePath, NULL,(x2position/2)+60,(y2position/2)+60);
                                
                                if(IS_IPHONE_DEVICE)
                                    {
                                        //                                x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue]-105;
                                        //                                y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue]-90;
                                    x1position = 65;
                                    y1position = 55;
                                        //                                x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue]-105;
                                        //                                y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue]-90;
                                    x2position  = (([[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] floatValue ]/322)*130);
                                    y2position  = (([[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] floatValue]/284)*130);
                                    }
                                
                                else
                                    {
                                        //                    x1position = [[[sepArray valueForKey:@"WWX1"] objectAtIndex:i] intValue];
                                        //                    y1position = [[[sepArray valueForKey:@"WWY1"] objectAtIndex:i] intValue];
                                        //                    x2position  =[[[sepArray valueForKey:@"WWX2"] objectAtIndex:i] intValue];
                                        //                  y2position  =[[[sepArray valueForKey:@"WWY2"] objectAtIndex:i] intValue];
                                    
                                    x1position = 100;
                                    y1position = 84.7;
                                        //                    x2position  =196;
                                        //                    y2position  =109;
                                    
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
                                    [cell.onesBtniPhone setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    [cell.twoBtniPhone setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    [cell.threeBtniPhone setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    [cell.fourBtniPhone setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    
                                    
                                    
                                        //                }else if ([self.selectRuns isEqualToString: @"5"]){
                                        //                   // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                        //                    NSString *color = [[sepArray valueForKey:@"Colour"] objectAtIndex:i];
                                        //                    strokeColor = [self colorWithHexString:color];
                                    
                                } else if ([self.selectRuns isEqualToString: @"6"]){
                                    
                                    
                                        // strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    [sixscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                    NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)sixscount.count];
                                    [cell.sixBtniPhone setTitle:ss forState:UIControlStateNormal];
                                    
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
                                    
                                }   else if ([self.selectRuns isEqualToString: @"90"]){
                                    
                                    
                                    
                                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    [dotscount addObject:[[sepArray valueForKey:@"Runs"] objectAtIndex:i]];
                                    NSString *ss = [NSString stringWithFormat:@"%lu",(unsigned long)dotscount.count];
                                    [cell.dotBtniPhone setTitle:ss forState:UIControlStateNormal];
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

                                
                                    //                else if ([self.selectRuns isEqualToString: @"0"]){
                                    //
                                    //                    //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                    //                    strokeColor = [self colorWithHexString:color];
                                    //
                                    //                }
                                
                                
                                    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
                                    //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
                                    //        }
                                    //
                                
                                shapeLayer.strokeColor = strokeColor.CGColor;
                                shapeLayer.lineWidth = 2.0f;
                                shapeLayer.fillRule = kCAFillRuleNonZero;
                                shapeLayer.name = @"DrawLine";
                                [cell.WagonImgiPhone.layer addSublayer:shapeLayer];
                                
                                    //}
                                }
                            }
                        }
                    
                        //pitch map
                    
                    if(self.pitchData.count>0)
                        {
                        
                        NSMutableArray *sepArray = [[NSMutableArray alloc]init];
                            //                    sepArray= [[self.pitchData valueForKey:@"PitchMapValuesBatting"]objectAtIndex:indexPath.row];
                        sepArray= [self.pitchData valueForKey:@"PitchMapValuesBowling"];
                        for(UIImageView * obj in [cell.PitchImgiPhone subviews])
                            {
                            NSLog(@"%@",obj);
                            [obj removeFromSuperview];
                            }
                        
                        
                        int xposition;
                        int yposition;
                        
                        if(![sepArray isEqual:[NSNull null]])
                            {
                            for(int i=0; i<sepArray.count;i++)
                                {
                                    //PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
                                
                                if(IS_IPHONE_DEVICE)
                                    {
                                        //                                xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-90;
                                        //                                yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-60;
                                    xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*130)-4;
                                    yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*130)-1;
                                    }
                                else
                                    {
                                    
                                    
                                        //                        xposition = [[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] intValue]-83;
                                        //                        yposition = [[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] intValue]-30;
                                    
                                    
                                    xposition = (([[[sepArray valueForKey:@"PMX2"] objectAtIndex:i] floatValue ]/380)*200)-4;
                                    yposition = (([[[sepArray valueForKey:@"PMY2"] objectAtIndex:i] floatValue]/295)*200)-1;
                                    
                                    }
                                
                                if([[self.pitchData valueForKey:@"Battingstyle"] isEqualToString:@"RIGHT"])
                                    {
                                    
                                    cell.PitchImgiPhone.image = [UIImage imageNamed:@"Pitchmap"];
                                    }
                                else
                                    {
                                    cell.PitchImgiPhone.image = [UIImage imageNamed:@"PitchmapLefthand"];
                                    }
                                
                                NSString * run;
                                run =([[[sepArray valueForKey:@"Runs"] objectAtIndex:i] isEqualToString:@"0"])?@"":[[sepArray valueForKey:@"Runs"] objectAtIndex:i];
                                
                                if(!(xposition == 1 && yposition == 1) && (xposition!=0 && yposition !=0)){
                                    
                                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition,yposition,6, 6)];
                                        //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                                    
                                    Img_ball.layer.cornerRadius =3;
                                    Img_ball.layer.masksToBounds=YES;
                                    if ([run isEqualToString: @"1"]) {
                                        
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                            // else{
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
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
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                                        if(isTwos == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"ff6c00"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                    }else if ([run isEqualToString: @"3"]){
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                                        
                                        if(isThrees == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"A305C0"];
                                            }
                                        
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                    }else if ([run isEqualToString: @"4"]){
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                                        if(isFours == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"2454f1"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                        
                                    }else if ([run isEqualToString: @"5"]){
                                            // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                                        if(isFours == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"22beef"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                        
                                    }else if ([run isEqualToString: @"6"]){
                                            // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        
                                        
                                        if(isSixes == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"ff00ea"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                        
                                    } else if ([run isEqualToString: @"90"]){
                                        
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        
                                        
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
                                            //ed1d24
                                            //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        
                                        
                                        
                                        if(isWkt == YES)
                                            {
                                            Img_ball.backgroundColor = [self colorWithHexString:@"ed1d24"];
                                            }
                                        else
                                            {
                                            Img_ball.backgroundColor =[UIColor clearColor];
                                            }
                                        
                                    }
                                    
                                        //                        else if ([run isEqualToString: @"0"]){
                                        //
                                        //                            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                                        //                        }
                                    
                                    [cell.PitchImgiPhone addSubview:Img_ball];
                                    
                                }
                                }
                            }
                        }
                }
            }
            cell.selectionStyle = UIAccessibilityTraitNone;
        }
        return cell;
    }
    
     return nil;
}

#pragma mark - UITableViewDelegate
    // when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"recentMatchesArray:%@", recentMatchesArray);
//    AppDelegate *Appobj = [AppDelegate new];
    appDel.Currentmatchcode = [[recentMatchesArray objectAtIndex:indexPath.row] valueForKey:@"MatchCode"];
    appDel.Scorearray = [recentMatchesArray objectAtIndex:indexPath.row];
    
//    ScoreCardVC *scoreObj = [[ScoreCardVC alloc] init];
//    scoreObj = (ScoreCardVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVC"];
//    [appDel.frontNavigationController pushViewController:scoreObj animated:YES];

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    objtab = (TabbarVC *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"TabbarVC"];
//    appDel.Currentmatchcode = displayMatchCode;
//    appDel.Scorearray = scoreArray;
        //objtab.backkey = @"yes";
        //[self.navigationController pushViewController:objFix animated:YES];
    [appDel.frontNavigationController pushViewController:objtab animated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return (IS_IPAD)?380:285;
    }
    
    if (indexPath.section == 1) {
        if(indexPath.row ==  selectedIndex)
        {
            return 450;
        } else {
            return (IS_IPAD)?80: 60;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MyStatsBattingCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1  )
    {
        if (selectedIndex == indexPath.row)
            {
                [cell setBackgroundColor:[UIColor lightGrayColor]];
                [cell setAccessibilityTraits:UIAccessibilityTraitSelected];
                CGFloat height = MIN(self.view.bounds.size.height, self.batttingTableView.contentSize.height);
                self.battingTableViewHeight.constant = height;
                    cell.scoreView.hidden = NO;
                [self.view layoutIfNeeded];
            } else {
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell setAccessibilityTraits:0];
                    cell.scoreView.hidden = YES;

                CGFloat height = MIN(self.view.bounds.size.height, self.batttingTableView.contentSize.height);
                self.battingTableViewHeight.constant = height;
                [self.view layoutIfNeeded];
            }
        }
}

- (void)myStatsBattingPostMethodWebService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    NSString *URLString =  URL_FOR_RESOURCE(playerMyStatsBatting);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    clientCode = [AppCommon GetClientCode];
    userRefCode = ([AppCommon isCoach] ? selectedPlayerCode : [AppCommon GetuserReference]);
//    userRefCode = [AppCommon GetuserReference];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"ClientCode"];
//    if(userCode)   [dic    setObject:userCode     forKey:@"UserCode"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"UserrefCode"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        battingOverAllArray = [NSMutableArray new];
        battingOverAllArray = [responseObject valueForKey:@"PlayerDetailsList"];
        
        battingRecentMatchesArray = [NSMutableArray new];
        battingRecentMatchesArray = [responseObject valueForKey:@"PlayerRecentDetailsList"];
        
        [AppCommon hideLoading];
        
        //Bowling Service
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self myStatsBowlingPostMethodWebService];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
    
}

- (void) getMatchBattingPerformanceGetMethodWebServiceMatchCode:(NSString*)matchCode inningsNo:(NSString*)innings andPlayerCode:(NSString*)playerCode  : (int) loopCount : (int) totalCount {
    /*
     
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/GETMATCHBATTINGPERFORMANCE/
     METHOD     :   GET
     PARAMETER  :   {CLIENTCODE}/{USERREFCODE}/{PLAYERCODE}/{MATCHCODE}/{INNGS}
     */
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    NSString *API_URL;
    if (isBatting) {
        API_URL = [NSString stringWithFormat:@"%@GETMATCHBATTINGPERFORMANCE/%@/%@/%@/%@/%@",URL_FOR_RESOURCE(@""),clientCode,userRefCode,playerCode, matchCode, innings];
    }
    
    if (isBowling) {
        API_URL = [NSString stringWithFormat:@"%@GETMATCHBOWLINGPERFORMANCE/%@/%@/%@/%@/%@",URL_FOR_RESOURCE(@""),clientCode,userRefCode,playerCode, matchCode, innings];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        NSMutableArray *bbPerformanceArray = [[NSMutableArray alloc] init];
        bbPerformanceArray = [responseObject valueForKey:@"PlayerMatchDetailsList"];
        NSLog(@"%@", matchCode);
        
        if(isBatting){
            
            //Add Performance
            if (bbPerformanceArray.count) {
                [battingmatchDetailsArray addObject:bbPerformanceArray];
            }

            if(battingmatchDetailsArray.count >= battingRecentMatchesArray.count){
                
                
                //WagonWheel Web Service
                if(battingRecentMatchesArray.count >0){
                    
                    NSString *matchCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"MatchCode"]];
                    NSString *innigs = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"InnsNo"]];
                    NSString *playerCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"PlayerCode"]];
                    [self wagonWheelWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:0: (int)battingRecentMatchesArray.count];
                }
                
            }else{
            
                NSString *matchCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"MatchCode"]];
                NSString *innigs = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"InnsNo"]];
                NSString *playerCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"PlayerCode"]];
                
                //Get Match Batting Performance
                
                [self getMatchBattingPerformanceGetMethodWebServiceMatchCode:matchCode inningsNo:innigs andPlayerCode:playerCode:(loopCount+1): (int)battingRecentMatchesArray.count];
            }
        }else{
                //Add Performance
            if (bbPerformanceArray.count) {
                [bowlingmatchDetailsArray addObject:bbPerformanceArray];
            }
            
            if(bowlingmatchDetailsArray.count >= bowlingRecentMatchesArray.count){
                
                
                    //WagonWheel Web Service
                if(bowlingRecentMatchesArray.count >0){
                    
                    NSString *matchCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"MatchCode"]];
                    NSString *innigs = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"InnsNo"]];
                    NSString *playerCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"PlayerCode"]];
                    [self wagonWheelWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:0: (int)bowlingRecentMatchesArray.count];
                }
                
            }else{
                
                NSString *matchCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"MatchCode"]];
                NSString *innigs = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"InnsNo"]];
                NSString *playerCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"PlayerCode"]];
                
                    //Get Match bowling Performance
                
                [self getMatchBattingPerformanceGetMethodWebServiceMatchCode:matchCode inningsNo:innigs andPlayerCode:playerCode:(loopCount+1): (int)bowlingRecentMatchesArray.count];
            }
        }
        
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
    
}

-(void)wagonWheelWebservicePlayerCode:(NSString*)playerCode andMatchCode:(NSString*)matchCode andInningsNo:(NSString*)innings  : (int) loopCount : (int) totalCount
{
    /*
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/GETSCORECARDBATTINGSPIDERWAGONWHEEL/
     METHOD     :   GET
     PARAMETER  :   {PLAYERCODE}/{MATCHCODE}/{INNGS}
     */
    
   
    if(![COMMON isInternetReachable])
        return ;
    
    [AppCommon showLoading];
    
    NSString *API_URL = [NSString stringWithFormat:@"%@GETSCORECARDBATTINGSPIDERWAGONWHEEL/%@/%@/%@",URL_FOR_RESOURCE(@""),playerCode, matchCode, innings];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);
        NSMutableArray *bbWagonWheelArray = [[NSMutableArray alloc] init];
        bbWagonWheelArray = responseObject;
        
        if(isBatting){
            if (bbWagonWheelArray.count) {
                [battingWagonWheelDrawData addObject:bbWagonWheelArray];
            }
            
            
            if(battingWagonWheelDrawData.count >= battingRecentMatchesArray.count){
                
                
                    //Pitch Map Web Service
                
                if(battingRecentMatchesArray.count >0){
                    
                    NSString *matchCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"MatchCode"]];
                    NSString *innigs = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"InnsNo"]];
                    NSString *playerCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"PlayerCode"]];
                    
                    [self pitchMapWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:0: (int)battingRecentMatchesArray.count];
                }
                
            }else{
                
                NSString *matchCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"MatchCode"]];
                NSString *innigs = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"InnsNo"]];
                NSString *playerCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"PlayerCode"]];
                [self wagonWheelWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:(loopCount+1): (int)battingRecentMatchesArray.count];
            }
        }else {
            if (bbWagonWheelArray.count) {
                [bowlingWagonWheelDrawData addObject:bbWagonWheelArray];
            }
            
            
            if(bowlingWagonWheelDrawData.count >= bowlingRecentMatchesArray.count){
                
                
                    //Pitch Map Web Service
                
                if(bowlingRecentMatchesArray.count >0){
                    
                    NSString *matchCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"MatchCode"]];
                    NSString *innigs = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"InnsNo"]];
                    NSString *playerCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"PlayerCode"]];
                    
                    [self pitchMapWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:0: (int)bowlingRecentMatchesArray.count];
                }
                
            }else{
                
                NSString *matchCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"MatchCode"]];
                NSString *innigs = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"InnsNo"]];
                NSString *playerCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"PlayerCode"]];
                [self wagonWheelWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:(loopCount+1): (int)bowlingRecentMatchesArray.count];
            }
        }
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

- (void)pitchMapWebservicePlayerCode:(NSString*)playerCode andMatchCode:(NSString*)matchCode andInningsNo:(NSString*)innings : (int) loopCount : (int) totalCount
{
    /*
     API URL    :   http://192.168.0.151:8044/AGAPTService.svc/FETCH_SCORECARD_PITCHMAP/
     METHOD     :   GET
     PARAMETER  :   {PLAYERCODE}/{MATCHCODE}/{INNGS}
     */
    
    if(![COMMON isInternetReachable])
        return ;
    
    [AppCommon showLoading];
    NSString *API_URL;
    if (isBatting) {
        API_URL = [NSString stringWithFormat:@"%@%@/%@/%@/%@",URL_FOR_RESOURCE(@""), ScorecardPitchmapKey, playerCode, matchCode, innings];
    } else {
        API_URL = [NSString stringWithFormat:@"%@%@/%@/%@/%@",URL_FOR_RESOURCE(@""), ScorecardPitchbowlmapKey, playerCode, matchCode, innings];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager GET:API_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS RESPONSE:%@",responseObject);

        NSMutableArray *bbPitchDataArray = [[NSMutableArray alloc] init];
        bbPitchDataArray = responseObject;
        
        if(isBatting){
        
            if (bbPitchDataArray.count) {
                [battingPitchData addObject:bbPitchDataArray];
            }
            
            if(battingPitchData.count >= battingRecentMatchesArray.count){

                recentMatchesArray = [[NSMutableArray alloc] init];
                recentMatchesArray = battingRecentMatchesArray;
                
                [self.batttingTableView reloadData];
           
            }else{
                
                    NSString *matchCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"MatchCode"]];
                    NSString *innigs = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"InnsNo"]];
                    NSString *playerCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"PlayerCode"]];
                
                    [self pitchMapWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:(loopCount+1): (int)battingRecentMatchesArray.count];
                
            }
        
        }else{
            
            if (bbPitchDataArray.count) {
                [bowlingPitchData addObject:bbPitchDataArray];
            }
            
            if(bowlingPitchData.count >= bowlingRecentMatchesArray.count){
                
                recentMatchesArray = [[NSMutableArray alloc] init];
                recentMatchesArray = bowlingRecentMatchesArray;
                
                [self.batttingTableView reloadData];
                
            }else{
                
                NSString *matchCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"MatchCode"]];
                NSString *innigs = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"InnsNo"]];
                NSString *playerCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:(loopCount+1)] valueForKey:@"PlayerCode"]];
                
                [self pitchMapWebservicePlayerCode:playerCode andMatchCode:matchCode andInningsNo:innigs:(loopCount+1): (int)bowlingRecentMatchesArray.count];
            }
        }
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE RESPONSE %@",error.description);
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

- (IBAction)battingAction:(id)sender {
    
    [self setInningsButtonSelect:self.battingBtn];
    [self setInningsButtonUnselect:self.bowlingBtn];
        
    lastIndex = NULL;
    selectedIndex = -1;
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    isBatting = YES;
    isBowling = NO;
//    matchDetailsArray = [NSMutableArray new];
    overAllArray = [[NSMutableArray alloc] init];
    overAllArray = battingOverAllArray;
    
//    //Get Server Data
//    battingmatchDetailsArray = [NSMutableArray new];
//    battingWagonWheelDrawData = [NSMutableArray new];
//    battingPitchData = [NSMutableArray new];
    
    //Get Match Batting Performance
    if(battingRecentMatchesArray.count >0){
            NSString *matchCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"MatchCode"]];
            NSString *innigs = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"InnsNo"]];
            NSString *playerCode = [self checkNull:[[battingRecentMatchesArray objectAtIndex:0] valueForKey:@"PlayerCode"]];
            
            //Get Match Batting Performance
            
            [self getMatchBattingPerformanceGetMethodWebServiceMatchCode:matchCode inningsNo:innigs andPlayerCode:playerCode:0: (int)battingRecentMatchesArray.count];
    }
}

- (IBAction)bowlingAction:(id)sender {
    
    [self setInningsButtonSelect:self.bowlingBtn];
    [self setInningsButtonUnselect:self.battingBtn];
    
    lastIndex = NULL;
    selectedIndex = -1;
    
    isOnes = YES;
    isTwos = YES;
    isThrees = YES;
    isFours = YES;
    isSixes = YES;
    isWkt = YES;
    isDotBall = YES;
    
    isBatting = NO;
    isBowling = YES;
    overAllArray = [[NSMutableArray alloc] init];
    overAllArray = bowlingOverAllArray;
    
    
//        //Get Server Data
//    bowlingmatchDetailsArray = [NSMutableArray new];
//    bowlingWagonWheelDrawData = [NSMutableArray new];
//    bowlingPitchData = [NSMutableArray new];
    
        //Get Match Batting Performance
    if(bowlingRecentMatchesArray.count >0){
        NSString *matchCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"MatchCode"]];
        NSString *innigs = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"InnsNo"]];
        NSString *playerCode = [self checkNull:[[bowlingRecentMatchesArray objectAtIndex:0] valueForKey:@"PlayerCode"]];
        
            //Get Match Batting Performance
        
        [self getMatchBattingPerformanceGetMethodWebServiceMatchCode:matchCode inningsNo:innigs andPlayerCode:playerCode:0: (int)bowlingRecentMatchesArray.count];
    }
   
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
    
    [self.batttingTableView reloadData];
    
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
    
    [self.batttingTableView reloadData];
    
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
    
    [self.batttingTableView reloadData];
    
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
    
    [self.batttingTableView reloadData];
    
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
    
    [self.batttingTableView reloadData];
   
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
    
    [self.batttingTableView reloadData];
   
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
    
    [self.batttingTableView reloadData];
    
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

    [self.batttingTableView reloadData];
    
}

-(IBAction)didClickDropDownButtonForExpandCell:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:1];
    MyStatsBattingCell *cell = [self.batttingTableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        
        matchDetailsArray = [NSMutableArray new];
        self.wagonWheelDrawData = [NSMutableArray new];
        self.pitchData = [NSMutableArray new];
        
        if (isBatting) {
//            NSLog(@"battingWagonWheelDrawData:%@", battingWagonWheelDrawData);
//            NSLog(@"battingPitchData:%@", battingPitchData);
            matchDetailsArray = [battingmatchDetailsArray objectAtIndex:indexPath.row];
            self.wagonWheelDrawData = [battingWagonWheelDrawData objectAtIndex:indexPath.row];
            self.pitchData = [battingPitchData objectAtIndex:indexPath.row];
            NSLog(@"wagonWheelDrawData:%@", self.wagonWheelDrawData);
            NSLog(@"pitchData:%@", self.pitchData);
        }
        
        if (isBowling) {
//            NSLog(@"bowlingWagonWheelDrawData:%@", bowlingWagonWheelDrawData);
//            NSLog(@"bowlingPitchData:%@", bowlingPitchData);
            matchDetailsArray = [bowlingmatchDetailsArray objectAtIndex:indexPath.row];
            self.wagonWheelDrawData = [bowlingWagonWheelDrawData objectAtIndex:indexPath.row];
            self.pitchData = [bowlingPitchData objectAtIndex:indexPath.row];
            NSLog(@"wagonWheelDrawData:%@", self.wagonWheelDrawData);
            NSLog(@"pitchData:%@", self.pitchData);
        }
    
        [self.batttingTableView beginUpdates];
        
        if(indexPath.row == selectedIndex) {
            selectedIndex = -1;
                //cell.scoreView.hidden = YES;
            lastIndex = NULL;
        } else {
                //cell.scoreView.hidden = NO;
            if(lastIndex != nil) {
                
                [self.batttingTableView reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                
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
        
        [self.batttingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.batttingTableView endUpdates];
        
        
//        [self.batttingTableView reloadData];
    }
    
}

-(NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
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


-(void) setInningsButtonSelect : (UIButton*) innsBtn{
        // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#1C1A44"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
        //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#C8C8C8"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (void)myStatsBowlingPostMethodWebService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    NSString *URLString =  URL_FOR_RESOURCE(playerMyStatsBowling);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    clientCode = [AppCommon GetClientCode];
    userRefCode = ([AppCommon isCoach] ? selectedPlayerCode : [AppCommon GetuserReference]);
//    userRefCode = [AppCommon GetuserReference];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"ClientCode"];
//    if(userCode)   [dic    setObject:userCode     forKey:@"UserCode"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"UserrefCode"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        bowlingOverAllArray = [NSMutableArray new];
        bowlingOverAllArray = [responseObject valueForKey:@"PlayerDetailsList"];
        bowlingRecentMatchesArray = [NSMutableArray new];
        bowlingRecentMatchesArray = [responseObject valueForKey:@"PlayerRecentDetailsList"];
        
        [AppCommon hideLoading];
        
        //Batting Action Call
        [self.battingBtn sendActionsForControlEvents:UIControlEventTouchUpInside];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
