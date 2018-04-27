//
//  FieldSummaryVC.m
//  NewSportsProject
//
//  Created by apple on 27/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "FieldSummaryVC.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "CustomNavigation.h"
#import "BallsInVideosCVC.h"
#import "VideoPlayerViewController.h"
#import "ScoreCardVideoPlayer.h"

@interface FieldSummaryVC ()
{
    WebService *objWebservice;
    NSInteger selectedIndex;
    NSIndexPath *lastIndex;
    int positiveCount;
    
    
    int caughtCount;
    int chaseStopCount;
    int directHitCount;
    int diveStopCount;
    int goodThrowCount;
    int pickThrowCount;
    int relayThrowCount;
    int slideStopCount;
    int wellKeptCount;
    
    int catchDropCount;
    int diveMissCount;
    int fumbleCount;
    int misFieldCount;
    int runOutMissCount;
    int throwaatStumpsCount;
    int selectedTab;

}
@end

@implementation FieldSummaryVC

NSMutableDictionary *innsOne;
NSMutableDictionary *innsTwo;
NSMutableDictionary *innsThree;
NSMutableDictionary *innsFour;


NSMutableArray  *catchDropedArray;

//NSMutableArray  *negativeArray;
//NSMutableArray  *positiveArray;

NSMutableDictionary  *negativeTypeDict;
NSMutableDictionary  *positiveTypeDict;

NSMutableArray  *videoURLArray;


int dropCatchStartPostion = -1;
int positivesStartPostion = -1;
int negativeStartPostion = -1;

int dropCatchEndPostion = -1;
int positivesEndPostion = -1;
int negativeEndPostion = -1;

int selectedVideo = 0;
//NSString *matchCode = @"IMSC023D017C2AA4FC420171114191400995";
NSString *matchResult = @"MSC125";
//NSString *matchHeadding = @"India VS Srilanka 2nd Test - Eden Gardens";
int headdingCount = 0;
//bool isTest = true;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedTab = 1;
    self.matchcode = appDel.Currentmatchcode;
    self.matchHeadding = appDel.matchHeaderDetails;
    self.isTest = appDel.isTest;
    
    [self.odiInn1Btn setTitle:appDel.TeamB forState:UIControlStateNormal];
    [self.odiInn2Btn setTitle:appDel.TeamA forState:UIControlStateNormal];

    self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tblView.hidden = true;
    self.rootVideoView.hidden = YES;
    
    objWebservice = [[WebService alloc]init];

    
   [self loadFieldSummary];
    
    if(_isTest){
        self.testInnsView.clipsToBounds = NO;
        self.testInnsView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.testInnsView.layer.shadowOffset = CGSizeMake(0,5);
        self.testInnsView.layer.shadowOpacity = 0.5;

    }else{
        self.odiInnsView.clipsToBounds = NO;
        self.odiInnsView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.odiInnsView.layer.shadowOffset = CGSizeMake(0,5);
        self.odiInnsView.layer.shadowOpacity = 0.5;
        
    }
    
    lastIndex = NULL;
    selectedIndex = -1;
    selectedTab = 1;

    [self setTabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        //[objCustomNavigation.btn_back addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
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


-(IBAction)didClickBackBtn:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onClickFstInns:(id)sender {
    
    lastIndex = NULL;
    selectedIndex = -1;
    selectedTab = 1;
    [self setTabView];

    if(innsOne == NULL){
        _tblView.hidden = true;
        [self loadFieldSummary];
    }else{
        [self setDataDictInTableView:innsOne];
    }
    
}
- (IBAction)onClickSecInns:(id)sender {
    
    lastIndex = NULL;
    selectedIndex = -1;
    selectedTab = 2;
    [self setTabView];
    
    if(innsTwo == NULL){
        _tblView.hidden = true;
        [self loadFieldSummary];
    }else{
        [self setDataDictInTableView:innsTwo];
    }

}
- (IBAction)onClickThirdInns:(id)sender {
    
    lastIndex = NULL;
    selectedIndex = -1;
    selectedTab = 3;
    [self setTabView];
    if(innsThree == NULL){
        _tblView.hidden = true;
        [self loadFieldSummary];
    }else{
        [self setDataDictInTableView:innsThree];
    }
}
- (IBAction)onClickForthInns:(id)sender {
    
    lastIndex = NULL;
    selectedIndex = -1;
    selectedTab = 4;
    [self setTabView];

    if(innsFour == NULL){
        _tblView.hidden = true;
        [self loadFieldSummary];
    }else{
        [self setDataDictInTableView:innsFour];
    }
}

-(UIView *) getLineView : (UIButton *) btn{

    CGFloat Xvalue = (btn.frame.size.width/4);

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Xvalue, btn.frame.size.height-5, btn.frame.size.width/2, 5)];

    [UIView animateWithDuration:0.3 animations:^{
        [lineView layoutIfNeeded];
    }];

    lineView.backgroundColor =[UIColor colorWithRed:37.0f/255.0f
                                              green:176.0f/255.0f
                                               blue:240.0f/255.0f
                                              alpha:1.0f];
    lineView.tag = 1234;
    return lineView;
}

-(void) clearBtnSubView : (UIButton *) btn{
    for (UIView *view in [btn subviews])
    {
        if(view.tag == 1234){
            [view removeFromSuperview];
        }
    }
}


-(void) setTabView{
    
    if(_isTest){
        
        _odiInnsView.hidden = true;
        _testInnsView.hidden = false;
        
        [self clearBtnSubView:_testInn1Btn];
        [self clearBtnSubView:_testInn2Btn];
        [self clearBtnSubView:_testInn3Btn];
        [self clearBtnSubView:_testInn4Btn];

        if(selectedTab ==  1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_testInn1Btn addSubview: [self getLineView:_testInn1Btn]];
            });

        }else if(selectedTab ==  2){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_testInn2Btn addSubview: [self getLineView:_testInn2Btn]];
            });


        }else if(selectedTab ==  3){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_testInn3Btn addSubview: [self getLineView:_testInn3Btn]];
            });


        }else if(selectedTab ==  4){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_testInn4Btn addSubview: [self getLineView:_testInn4Btn]];
            });


        }
        
    }else{
        
        _odiInnsView.hidden = false;
        _testInnsView.hidden = true;
        
        [self.odiInn1Btn setTitle:appDel.TeamB forState:UIControlStateNormal];
        [self.odiInn2Btn setTitle:appDel.TeamA forState:UIControlStateNormal];
        
        [self clearBtnSubView:_odiInn1Btn];
        [self clearBtnSubView:_odiInn2Btn];
        
        if(selectedTab ==  1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_odiInn1Btn addSubview: [self getLineView:_odiInn1Btn]];
            });


        }else if(selectedTab ==  2){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_odiInn2Btn addSubview: [self getLineView:_odiInn2Btn]];
            });


        }
        
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    long count = [catchDropedArray count] + [negativeTypeDict count]  +[positiveTypeDict count] + headdingCount;
    //NSLog(@"==>%ld",count);
    return count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(  indexPath.row == dropCatchStartPostion ){ // Drop Catch headding
        FieldSummaryHeading *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_headding"];
        [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
        cell = self.headdingTVC;
        cell.headdingLbl.text = @"Dropped Catches";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if( indexPath.row > dropCatchStartPostion && indexPath.row <= dropCatchEndPostion) { // Drop Catch
        
        FieldSummaryDroppedCatches *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_dropcatch"];
        [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
        cell = self.dropCatchTVC;
        
        
        long postion = indexPath.row-1;
        
        cell.batsmanNameLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BatsmanName"];
        cell.fielderNameLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"FielderName"];
        cell.fieldRegionLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"Region"];
        cell.batsmanTotalScoreLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BScoreFinal"];

//        cell.dropOverLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"DropOverNo"];
//        cell.dropBowerLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BowlerName"];
//        cell.dropTeamScoreLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"TeamScoreOnDrop"];
//        cell.dropRunLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BScoreOnDrop"];
//
//        cell.dismissRunLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BScoreFinal"];
//        cell.dismissOverLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"WicketNo"];
//        cell.dismissTeamScoreLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"FOW"];
//        cell.dismissPartnerShipLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"Partnership"];
        
        
        if(selectedIndex == indexPath.row){
            
            cell.dropOverLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"DropOverNo"];
            cell.dropBowerLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BowlerName"];
            cell.dropTeamScoreLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"TeamScoreOnDrop"];
            cell.dropRunLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BScoreOnDrop"];
            
            cell.dismissRunLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"BScoreFinal"];
            cell.dismissOverLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"WicketNo"];
            cell.dismissTeamScoreLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"FOW"];
            cell.dismissPartnerShipLbl.text = [[catchDropedArray objectAtIndex: postion] valueForKey:@"Partnership"];
            
            cell.arrowImg.image = [UIImage imageNamed:@"upArrow"];
            
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"downArrow"];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if( indexPath.row == positivesStartPostion) { // Positives headding
        
        FieldSummaryHeading *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_headding"];
        [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
        cell = self.headdingTVC;
        cell.headdingLbl.text = @"Positives";
        //cell.countLbl.text = [NSString stringWithFormat:@"%d",positiveCount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if( indexPath.row > positivesStartPostion && indexPath.row <= positivesEndPostion) {// Positives
        
        FieldSummaryTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_tvc"];
        [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
        cell = self.filedingSumTVC;
        
        long postion = indexPath.row - (positivesStartPostion  + 1);

        long loop = 0;
        
        for (id key in positiveTypeDict) {
            
            if(loop == postion){

                if([key isEqualToString:@"Caught"]){
                    [self loadFieldPlayer: cell :key : @"Caught":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",caughtCount];
                }else if([key isEqualToString:@"ChaseStop"]){
                    [self loadFieldPlayer: cell :key : @"Chase and Stop":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",chaseStopCount];
                }else if([key isEqualToString:@"DirectHit"]){
                    [self loadFieldPlayer: cell :key : @"Direct Hit":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",directHitCount];
                }else if([key isEqualToString:@"DiveStop"]){
                    [self loadFieldPlayer: cell :key : @"Dive and Stop":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",diveStopCount];
                }else if([key isEqualToString:@"GoodThrow"]){
                    [self loadFieldPlayer: cell :key : @"Good Throw":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",goodThrowCount];
                }else if([key isEqualToString:@"PickThrow"]){
                    [self loadFieldPlayer: cell :key : @"Pick and Throw":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",pickThrowCount];
                }else if([key isEqualToString:@"RelayThrow"]){
                    [self loadFieldPlayer: cell :key : @"Relay Throw":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",relayThrowCount];
                }else if([key isEqualToString:@"SlideStop"]){
                    [self loadFieldPlayer: cell :key : @"Side and Stop":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",slideStopCount];
                }else if([key isEqualToString:@"WellKept"]){
                    [self loadFieldPlayer: cell :key : @"Well Kept":positiveTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",wellKeptCount];
                }
                
                break;
            }
            loop ++;
        }

        if(selectedIndex == indexPath.row){
            cell.arrowImg.image = [UIImage imageNamed:@"upArrow"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"downArrow"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if( indexPath.row == negativeStartPostion) {// Negatives headding
        
        FieldSummaryHeading *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_headding"];
        [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
        cell = self.headdingTVC;
        cell.headdingLbl.text = @"Negatives";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.row > negativeStartPostion && indexPath.row <= negativeEndPostion) {// Negatives
        
        FieldSummaryTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_tvc"];
        [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
        cell = self.filedingSumTVC;
        
        long postion = indexPath.row - (negativeStartPostion  + 1);
        
        long loop = 0;
        
        for (id key in negativeTypeDict) {
            
            if(loop == postion){
                
                if([key isEqualToString:@"CatchDrop"]){
                    [self loadFieldPlayer: cell :key : @"Catch Dropped":negativeTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",catchDropCount];
                }else if([key isEqualToString:@"DiveMiss"]){
                    [self loadFieldPlayer: cell :key : @"Dive and Miss":negativeTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",diveMissCount];
                }else if([key isEqualToString:@"Fumble"]){
                    [self loadFieldPlayer: cell :key : @"Fumble":negativeTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",fumbleCount];
                }else if([key isEqualToString:@"MisField"]){
                    [self loadFieldPlayer: cell :key : @"Mis-field":negativeTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",misFieldCount];
                }else if([key isEqualToString:@"RunOutMiss"]){
                    [self loadFieldPlayer: cell :key : @"Run Out Missed":negativeTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",runOutMissCount];
                }else if([key isEqualToString:@"ThrowaatStumps"]){
                    [self loadFieldPlayer: cell :key : @"Thrown at Stumps":negativeTypeDict:indexPath];
                    cell.countLbl.text = [NSString stringWithFormat:@"%d",throwaatStumpsCount];
                }
                break;
            }
            loop ++;
        }
        
        
        if(selectedIndex == indexPath.row){
            cell.arrowImg.image = [UIImage imageNamed:@"upArrow"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"downArrow"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    //fs_tvc
    //fs_sub_tvc
    
    FieldSummaryHeading *cell = [tableView dequeueReusableCellWithIdentifier:@"fs_headding"];
    [[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC" owner:self options:nil];
    cell = self.headdingTVC;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hidden = true;
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat dropCatchNormalHeight = 73;
    CGFloat dropCatchExpandHeight = 234;
    
    CGFloat positiveNormalHeight = 58;
    CGFloat negativeNormalHeight = 58;
    
    CGFloat subCellHeight = 35;

    
    
   if( indexPath.row > dropCatchStartPostion && indexPath.row <= dropCatchEndPostion) { // Drop Catch
       
       if(indexPath.row ==  selectedIndex){
           return dropCatchExpandHeight;
       }else{
           return dropCatchNormalHeight;
       }

       
       
       
   }else if( indexPath.row > positivesStartPostion && indexPath.row <= positivesEndPostion) { // Positive
       
       
       if(indexPath.row ==  selectedIndex){
           
           long postion = indexPath.row - (positivesStartPostion  + 1);
           
           long loop = 0;
           
           for (id key in positiveTypeDict) {
               
               if(loop == postion){
                   long playerSize = [[positiveTypeDict objectForKey:key] count];
                   return  (subCellHeight * playerSize)+positiveNormalHeight;
               }
               loop ++;
           }
       }
       else{
           return positiveNormalHeight;
       }
       
    }else if(indexPath.row > negativeStartPostion && indexPath.row <= negativeEndPostion) { // Negative
        
        
        
        if(indexPath.row ==  selectedIndex){
            
            long postion = indexPath.row - (negativeStartPostion  + 1);
            
            long loop = 0;
            
            for (id key in negativeTypeDict) {
                
                if(loop == postion){
                    long playerSize = [[negativeTypeDict objectForKey:key] count];
                    return  (subCellHeight * playerSize)+negativeNormalHeight;
                }
                loop ++;
            }
        }
        else{
            return negativeNormalHeight;
        }

    }
    
    return _tblView.rowHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // NSLog(@"%ld",indexPath.row);
    
    [self.tblView beginUpdates];
    if(indexPath.row == selectedIndex)
    {
        selectedIndex = -1;
        lastIndex = NULL;
        
    }
    else
    {
        
        if(lastIndex != nil){
            
            
            
            [self.tblView reloadRowsAtIndexPaths:@[lastIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        lastIndex = indexPath;
        selectedIndex = indexPath.row;
        
    }
    
    [self.tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tblView reloadData];
    [self.tblView endUpdates];
    
}

//Load fieding type sub players
-(void) loadFieldPlayer : (FieldSummaryTVC *) cell : (id) key : (NSString *) typeName : (NSMutableDictionary *) dict : (NSIndexPath *)indexPath
{

    NSMutableArray *players = [dict objectForKey:key];

    cell.fieldingTypeLbl.text = typeName;
    
    
    if(selectedIndex == indexPath.row){
    
        int playerCount = 0;
        for (NSMutableDictionary *player in players) {
            
            FieldSummarySubTVC *fieldSummarySubTVC =  [[[NSBundle mainBundle] loadNibNamed:@"FieldSummaryTVC"
                                                                                     owner:self                                                                                               options:nil] objectAtIndex:3];
            fieldSummarySubTVC.playerNameLbl.text = [player valueForKey:@"FielderName"];
            fieldSummarySubTVC.countLbl.text = [player valueForKey:@"count"];
            
            CGRect r = [fieldSummarySubTVC frame];
            r.origin.y = playerCount * 35;
            [fieldSummarySubTVC setFrame:r];
            
            fieldSummarySubTVC.clickBtn.tag = playerCount;
            
            [fieldSummarySubTVC.clickBtn addTarget:self action:@selector(didClickVideoBatting:) forControlEvents:UIControlEventTouchUpInside];

            
            [cell.containerView addSubview: fieldSummarySubTVC];
            
            
            playerCount ++;
        }
    }

    
}


-(void) loadFieldSummary
{
    
    [AppCommon showLoading];

    
     [objWebservice LoadFieldingSummaryByInnins :LoadFieldSummary  :matchResult :self.matchcode :[NSString stringWithFormat:@"%d", selectedTab]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setDictionary:responseObject];
            [self setDataDictInTableView: dic1];
         
        }
        
         [AppCommon hideLoading];
         self.view.userInteractionEnabled = true;
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        //NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        self.view.userInteractionEnabled = true;
    }];
}






-(void) setDataDictInTableView : (NSMutableDictionary *) dic1{
    
    
    //-------- Positive
    NSMutableArray *positiveFielderArray = [[NSMutableArray alloc] init];
    positiveFielderArray =  [dic1 valueForKey:@"lstFieldingPositive"];
    
    //positiveTypeDict =
    
    NSMutableArray *caught = [[NSMutableArray alloc] init];
    NSMutableArray *chaseStop = [[NSMutableArray alloc] init];
    NSMutableArray *directHit = [[NSMutableArray alloc] init];
    NSMutableArray *diveStop = [[NSMutableArray alloc] init];
    NSMutableArray *goodThrow = [[NSMutableArray alloc] init];
    NSMutableArray *pickThrow = [[NSMutableArray alloc] init];
    NSMutableArray *relayThrow = [[NSMutableArray alloc] init];
    NSMutableArray *slideStop = [[NSMutableArray alloc] init];
    NSMutableArray *wellKept = [[NSMutableArray alloc] init];

    
    for (NSDictionary *positiveDic in positiveFielderArray){
        
        if(![[positiveDic valueForKey:@"Caught"] isEqualToString:@"0"]){
            
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"Caught"] forKey:@"count"];
            
            [caught setObject:player atIndexedSubscript:caught.count];
        }
        
        if(![[positiveDic valueForKey:@"ChaseStop"] isEqualToString:@"0"]){
            
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"ChaseStop"] forKey:@"count"];
            
            [chaseStop setObject:player atIndexedSubscript:chaseStop.count];
            
            
        }
        
        if(![[positiveDic valueForKey:@"DirectHit"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"DirectHit"] forKey:@"count"];
            
            [directHit setObject:player atIndexedSubscript:directHit.count];
            
        }
        
        if(![[positiveDic valueForKey:@"DiveStop"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"DiveStop"] forKey:@"count"];
            
            [diveStop setObject:player atIndexedSubscript:diveStop.count];
            
        }
        
        if(![[positiveDic valueForKey:@"GoodThrow"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"GoodThrow"] forKey:@"count"];
            
            [goodThrow setObject:player atIndexedSubscript:goodThrow.count];
            
        }
        
        if(![[positiveDic valueForKey:@"PickThrow"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"PickThrow"] forKey:@"count"];
            
            [pickThrow setObject:player atIndexedSubscript:pickThrow.count];
            
        }
        
        if(![[positiveDic valueForKey:@"RelayThrow"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"RelayThrow"] forKey:@"count"];
            
            [relayThrow setObject:player atIndexedSubscript:relayThrow.count];
            
        }
        
        if(![[positiveDic valueForKey:@"SlideStop"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"SlideStop"] forKey:@"count"];
            
            [slideStop setObject:player atIndexedSubscript:slideStop.count];
            
        }
        
        
        if(![[positiveDic valueForKey:@"WellKept"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[positiveDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[positiveDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[positiveDic valueForKey:@"WellKept"] forKey:@"count"];
            
            [wellKept setObject:player atIndexedSubscript:wellKept.count];
            
        }
    }
    
    
    positiveTypeDict = [[NSMutableDictionary alloc] init];
    
    if(caught.count > 0){
        
        [positiveTypeDict setObject:caught forKey:@"Caught"];
        
        int totalCount = 0;
        for( int i=0;i<caught.count;i++)
        {
            int value = [[[caught valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        
         caughtCount = totalCount;
    }

    if(chaseStop.count > 0){
        [positiveTypeDict setObject:chaseStop forKey:@"ChaseStop"];
        
        int totalCount = 0;
        for( int i=0;i<chaseStop.count;i++)
        {
            int value = [[[chaseStop valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
         chaseStopCount = totalCount;
    }
    
    if(directHit.count > 0){
        [positiveTypeDict setObject:directHit forKey:@"DirectHit"];
        
        int totalCount = 0;
        for( int i=0;i<directHit.count;i++)
        {
            int value = [[[directHit valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        
        directHitCount = totalCount;
    }
    
    if(diveStop.count > 0){
        [positiveTypeDict setObject:diveStop forKey:@"DiveStop"];
        int totalCount = 0;
        for( int i=0;i<diveStop.count;i++)
        {
            int value = [[[diveStop valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        diveStopCount = totalCount;
    }
    
    if(goodThrow.count > 0){
        [positiveTypeDict setObject:goodThrow forKey:@"GoodThrow"];
        
        int totalCount = 0;
        for( int i=0;i<goodThrow.count;i++)
        {
            int value = [[[goodThrow valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        goodThrowCount = totalCount;
    }
    
    if(pickThrow.count > 0){
        [positiveTypeDict setObject:pickThrow forKey:@"PickThrow"];
        
        int totalCount = 0;
        for( int i=0;i<pickThrow.count;i++)
        {
            int value = [[[pickThrow valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        pickThrowCount = totalCount;
    }
    
    if(relayThrow.count > 0){
        [positiveTypeDict setObject:relayThrow forKey:@"RelayThrow"];
        
        int totalCount = 0;
        for( int i=0;i<relayThrow.count;i++)
        {
            int value = [[[relayThrow valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        
        relayThrowCount = totalCount;
    }
    
    if(slideStop.count > 0){
        [positiveTypeDict setObject:slideStop forKey:@"SlideStop"];
        
        int totalCount = 0;
        for( int i=0;i<slideStop.count;i++)
        {
            int value = [[[slideStop valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
         slideStopCount = totalCount;
    }
    
    if(wellKept.count > 0){
        [positiveTypeDict setObject:wellKept forKey:@"WellKept"];
        int totalCount = 0;
        for( int i=0;i<wellKept.count;i++)
        {
            int value = [[[wellKept valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
         wellKeptCount = totalCount;
    }
    
    
//     positiveCount = caught.count+chaseStop.count+directHit.count+diveStop.count+goodThrow.count+pickThrow.count+relayThrow.count+slideStop.count+wellKept.count;
    
    
    
    //-------- Negatives
    
   NSMutableArray *negativeFielderArray = [[NSMutableArray alloc] init];
    negativeFielderArray =  [dic1 valueForKey:@"lstFieldingNegative"];
    
    
    
    
    NSMutableArray *catchDrop = [[NSMutableArray alloc] init];
    NSMutableArray *diveMiss = [[NSMutableArray alloc] init];
    NSMutableArray *fumble = [[NSMutableArray alloc] init];
    NSMutableArray *misField = [[NSMutableArray alloc] init];
    NSMutableArray *runOutMiss = [[NSMutableArray alloc] init];
    NSMutableArray *throwaatStumps = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *negativeDic in negativeFielderArray){
        
        if(![[negativeDic valueForKey:@"CatchDrop"] isEqualToString:@"0"]){
            
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[negativeDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[negativeDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[negativeDic valueForKey:@"CatchDrop"] forKey:@"count"];
            
            [catchDrop setObject:player atIndexedSubscript:catchDrop.count];
        }
        
        if(![[negativeDic valueForKey:@"DiveMiss"] isEqualToString:@"0"]){
            
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[negativeDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[negativeDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[negativeDic valueForKey:@"DiveMiss"] forKey:@"count"];
            
            [diveMiss setObject:player atIndexedSubscript:diveMiss.count];
            
            
        }
        
        if(![[negativeDic valueForKey:@"Fumble"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[negativeDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[negativeDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[negativeDic valueForKey:@"Fumble"] forKey:@"count"];
            
            [fumble setObject:player atIndexedSubscript:fumble.count];
            
        }
        
        if(![[negativeDic valueForKey:@"MisField"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[negativeDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[negativeDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[negativeDic valueForKey:@"MisField"] forKey:@"count"];
            
            [misField setObject:player atIndexedSubscript:misField.count];
            
        }
        
        if(![[negativeDic valueForKey:@"RunOutMiss"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[negativeDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[negativeDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[negativeDic valueForKey:@"RunOutMiss"] forKey:@"count"];
            
            [runOutMiss setObject:player atIndexedSubscript:runOutMiss.count];
            
        }
        
        if(![[negativeDic valueForKey:@"ThrowaatStumps"] isEqualToString:@"0"]){
            NSMutableDictionary *player = [[NSMutableDictionary alloc] init];
            
            [player setValue:[negativeDic valueForKey:@"FielderName"] forKey:@"FielderName"];
            [player setValue:[negativeDic valueForKey:@"FielderCode"] forKey:@"FielderCode"];
            [player setValue:[negativeDic valueForKey:@"ThrowaatStumps"] forKey:@"count"];
            
            [throwaatStumps setObject:player atIndexedSubscript:throwaatStumps.count];
            
        }
        
       
    }
    
    
    negativeTypeDict = [[NSMutableDictionary alloc] init];
    
    if(catchDrop.count > 0){
        
        [negativeTypeDict setObject:catchDrop forKey:@"CatchDrop"];
        int totalCount = 0;
        for( int i=0;i<catchDrop.count;i++)
        {
            int value = [[[catchDrop valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        catchDropCount = totalCount;
    }
    
    if(diveMiss.count > 0){
        [negativeTypeDict setObject:diveMiss forKey:@"DiveMiss"];
        
        
        int totalCount = 0;
        for( int i=0;i<diveMiss.count;i++)
        {
            int value = [[[diveMiss valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        diveMissCount = totalCount;
    }
    
    if(fumble.count > 0){
        [negativeTypeDict setObject:fumble forKey:@"Fumble"];
        
        int totalCount = 0;
        for( int i=0;i<fumble.count;i++)
        {
            int value = [[[fumble valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        fumbleCount = totalCount;
    }
    
    if(misField.count > 0){
        [negativeTypeDict setObject:misField forKey:@"MisField"];
        
        int totalCount = 0;
        for( int i=0;i<misField.count;i++)
        {
            int value = [[[misField valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        misFieldCount =totalCount;
    }
    
    if(runOutMiss.count > 0){
        [negativeTypeDict setObject:runOutMiss forKey:@"RunOutMiss"];
        
        int totalCount = 0;
        for( int i=0;i<runOutMiss.count;i++)
        {
            int value = [[[runOutMiss valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
         runOutMissCount = totalCount;
    }
    
    if(throwaatStumps.count > 0){
        [negativeTypeDict setObject:throwaatStumps forKey:@"ThrowaatStumps"];
        int totalCount = 0;
        for( int i=0;i<throwaatStumps.count;i++)
        {
            int value = [[[throwaatStumps valueForKey:@"count"] objectAtIndex:i] intValue];
            totalCount=totalCount+value;
        }
        throwaatStumpsCount = totalCount;
    }
    
   
    //------ Catch Dropped
    catchDropedArray = [[NSMutableArray alloc] init];
    catchDropedArray =  [dic1 valueForKey:@"lstFieldingCatchDrop"];
    
    
  //  NSLog(@"%@",dic1);
    
    if(selectedTab == 1 ){
        innsOne = dic1;
    }else if(selectedTab == 2 ){
        innsTwo = dic1;
    }else if(selectedTab == 3 ){
        innsThree = dic1;
    }else if(selectedTab == 4 ){
        innsFour = dic1;
    }
    
    [self generatePostionForTblView];
    _tblView.hidden = false;
    [_tblView reloadData];
   
}

-(void) generatePostionForTblView {
    headdingCount = 0;
    
    if(catchDropedArray.count>0){
        dropCatchStartPostion = 0;
        headdingCount = 1;
        dropCatchEndPostion = (int) catchDropedArray.count;

    }else{
        dropCatchStartPostion = -1;
        dropCatchEndPostion = -1;
    }
    
    if(catchDropedArray.count >0){
        positivesStartPostion = (int) catchDropedArray.count + 1;
        headdingCount = 2;
        positivesEndPostion = (int) (catchDropedArray.count + positiveTypeDict.count + 1);
        
    }else if(positiveTypeDict.count>0){
        positivesStartPostion = 0;
        headdingCount = 1;
        positivesEndPostion = (int) (positiveTypeDict.count);

    }else{
        positivesStartPostion = -1;
        positivesEndPostion = -1;
    }
    
    if(catchDropedArray.count >0 && positiveTypeDict.count >0){
        negativeStartPostion = (int) (catchDropedArray.count + positiveTypeDict.count + 1 + 1) ;
        headdingCount = 3;
        negativeEndPostion = (int) (catchDropedArray.count + positiveTypeDict.count + negativeTypeDict.count + 2) ;

    }else if(catchDropedArray.count >0){
        negativeStartPostion = (int) catchDropedArray.count + 1;
        headdingCount = 2;
        negativeEndPostion = (int) (catchDropedArray.count + negativeTypeDict.count + 1) ;
    }else if(positiveTypeDict.count >0){
        negativeStartPostion = (int) positiveTypeDict.count + 1;
        headdingCount = 2;
        negativeEndPostion = (int) (positiveTypeDict.count + negativeTypeDict.count + 1) ;

    }else if(negativeTypeDict.count>0){
        negativeStartPostion = 0;
        headdingCount = 1;
        negativeEndPostion = (int) ( negativeTypeDict.count ) ;

    }else{
        negativeStartPostion = -1;
        negativeEndPostion = -1;
        
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

//get player code
-(void) loadVideoFieldPlayer : (id) key : (NSString *) typeName : (NSMutableDictionary *) dict : (int) playerPos
{
    
    NSMutableArray *players = [dict objectForKey:key];
    NSMutableDictionary *player =  [players objectAtIndex: playerPos];
    
     ;

    if( ![[player valueForKey:@"count"] isEqualToString:@"0"]){
        
   //     [self loadVideoPaths:[player valueForKey:@"FielderCode"] : typeName : @"FIELDING" ];
        
        [self loadVideoPlayer: [player valueForKey:@"FielderCode"] : typeName: @"FIELDING"  innings: [NSString stringWithFormat:@"%d", selectedTab]];
        
    }

    
    
}





-(IBAction)didClickVideoBatting:(id)sender
{
    
    if(selectedIndex != -1){
        
        if ([sender isKindOfClass:[UIButton class]]){
            
            int playerPos = (int)((UIButton *)sender).tag;
           // NSLog(@"%li", (long)((UIButton *)sender).tag);
            
            
       if( selectedIndex > positivesStartPostion && selectedIndex <= positivesEndPostion) {// Positives
           
           long position = selectedIndex - (positivesStartPostion  + 1);

           
           long loop = 0;
           
           for (id key in positiveTypeDict) {
               
               if(loop == position){
                   
                   
                   
                   if([key isEqualToString:@"Caught"]){
                       [self loadVideoFieldPlayer :key : @"CAUGHT":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"ChaseStop"]){
                       [self loadVideoFieldPlayer :key : @"CANDS":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"DirectHit"]){
                       [self loadVideoFieldPlayer:key : @"DHIT":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"DiveStop"]){
                       [self loadVideoFieldPlayer:key : @"DANDS":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"GoodThrow"]){
                       [self loadVideoFieldPlayer:key : @"GOODT":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"PickThrow"]){
                       [self loadVideoFieldPlayer:key : @"PANDT":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"RelayThrow"]){
                       [self loadVideoFieldPlayer:key : @"RELAYT":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"SlideStop"]){
                       [self loadVideoFieldPlayer:key : @"SANDS":positiveTypeDict:playerPos];
                   }else if([key isEqualToString:@"WellKept"]){
                       [self loadVideoFieldPlayer:key : @"WELLK":positiveTypeDict:playerPos];
                   }
                   
                   break;
               }
               loop ++;
           }
           
            
        }else if(selectedIndex > negativeStartPostion && selectedIndex <= negativeEndPostion) {// Negatives
            
            long position = selectedIndex - (negativeStartPostion  + 1);
            
            long loop = 0;
            
            for (id key in negativeTypeDict) {
                
                if(loop == position){
                    
                    if([key isEqualToString:@"CatchDrop"]){
                        [self loadVideoFieldPlayer:key : @"CATD":negativeTypeDict:playerPos];

                    }else if([key isEqualToString:@"DiveMiss"]){
                        [self loadVideoFieldPlayer:key : @"DANDM":negativeTypeDict:playerPos];
                    }else if([key isEqualToString:@"Fumble"]){
                        [self loadVideoFieldPlayer:key : @"FUMB":negativeTypeDict:playerPos];
                    }else if([key isEqualToString:@"MisField"]){
                        [self loadVideoFieldPlayer:key : @"MISSF":negativeTypeDict:playerPos];
                    }else if([key isEqualToString:@"RunOutMiss"]){
                        [self loadVideoFieldPlayer:key : @"ROM":negativeTypeDict:playerPos];
                    }else if([key isEqualToString:@"ThrowaatStumps"]){
                        [self loadVideoFieldPlayer:key : @"TATS":negativeTypeDict:playerPos];
                    }
                    break;
                }
                loop ++;
            }

        }
            
        }
        
    }
    
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

-(void)loadVideoPlayer: (NSString *) playercode : (NSString *) value: (NSString *) batOrBowl innings:(NSString*)innNo
{
    //NSString * Batsmancode =[[CommonArray valueForKey:@"Batsmencode"] objectAtIndex:indexPath.row];
    
    ScoreCardVideoPlayer * videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
    videoPlayerVC = (ScoreCardVideoPlayer *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
    videoPlayerVC.MatchCode = self.matchcode;
    videoPlayerVC.PlayerCode = playercode;
    videoPlayerVC.VideoValue = value;
    videoPlayerVC.Innings = innNo;
    videoPlayerVC.Type = batOrBowl;
    [self.navigationController presentViewController:videoPlayerVC animated:YES completion:nil];
}


//GETSCORECARDVIDEOSFILEPATH/' + BatsmanCode + '/' + $scope.MatchCode + '/' + $scope.DefaultInn + '/' + value + '/' + batorbowl

-(void) loadVideoPaths : (NSString *) batsmanCode : (NSString *) value: (NSString *) batOrBowl
{
    
    [AppCommon showLoading];
    
    
    [objWebservice GetVideoPathFile :GetVideoFilePath  :batsmanCode :self.matchcode :[NSString stringWithFormat:@"%d", selectedTab] :value : batOrBowl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
            [dic1 setDictionary:responseObject];
            
            videoURLArray= [[NSMutableArray alloc] init];
            videoURLArray =  [dic1 valueForKey:@"lstScoreCardVideoFilePathValuesRuns"];
            
            if(videoURLArray.count >0){
                 selectedVideo = 0;
                self.rootVideoView.hidden = NO;
                
                [self.ballsColView reloadData];
                
                NSMutableDictionary *playerVdo =  [videoURLArray objectAtIndex:selectedVideo];
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



@end
