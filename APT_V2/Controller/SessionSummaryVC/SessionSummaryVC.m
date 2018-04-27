//
//  SessionSummaryVC.m
//  NewSportsProject
//
//  Created by Mac on 28/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "SessionSummaryVC.h"
#import "CustomNavigation.h"
#import "Config.h"
#import "WebService.h"
#import "SessionPartCell.h"
#import "AppCommon.h"


@interface SessionSummaryVC ()
{
    WebService *objWebservice;
    
    NSString *matchstatus;
    NSString *dayno;
    NSString *sessionNo;
    NSString *innNo;
    
    NSString *matchTypeCode;
    
    
    NSMutableArray *day1Sessionarray;
    
    NSMutableArray *Session1array;
    NSMutableArray *Session2array;
    NSMutableArray *Session3array;
    
    
    NSMutableArray *commonArray;
    
    NSMutableArray *pacearrS1;
    NSMutableArray *spinarrS1;
    
    NSMutableArray *pacearrS2;
    NSMutableArray *spinarrS2;
    
    NSMutableArray *pacearrS3;
    NSMutableArray *spinarrS3;
    int selectedTab;
    
}

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * TblHeight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * partnrTblHeight;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * ScrollHeight;

@end

@implementation SessionSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedTab =1;
    
    self.matchcode = appDel.Currentmatchcode;
    self.matchHeadding = appDel.matchHeaderDetails;
    self.isTest = appDel.isTest;
    
    [self.Innings1 setTitle:appDel.TeamA forState:UIControlStateNormal];
    [self.Innings2 setTitle:appDel.TeamB forState:UIControlStateNormal];

    matchstatus = @"MSC215";
    
    objWebservice = [[WebService alloc]init];
    
    self.SessionsView.layer.cornerRadius = 5;
    self.SessionsView.layer.masksToBounds = true;
    //self.SessionsView.layer.borderColor = [UIColor colorWithRed:(24/255.0f) green:(40/255.0f) blue:(126/255.0f) alpha:1.0f].CGColor;
    //self.SessionsView.layer.borderWidth = 1.0f;
    
    
    [self MatchTypeService];
    //[self.day1 sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    if(_isTest){
        self.TESTview.clipsToBounds = NO;
        self.TESTview.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.TESTview.layer.shadowOffset = CGSizeMake(0,5);
        self.TESTview.layer.shadowOpacity = 0.5;
        
    }else{
        self.ODIview.clipsToBounds = NO;
        self.ODIview.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.ODIview.layer.shadowOffset = CGSizeMake(0,5);
        self.ODIview.layer.shadowOpacity = 0.5;
        
    }
    [self setTabView];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;

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
        
        [objCustomNavigation.btn_back addTarget:self action:@selector(BackBtn:) forControlEvents:UIControlEventTouchUpInside];
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


- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"] || [_value isEqualToString:@""]) {
        _value=@"0";
    }
    return _value;
}
-(void)MatchTypeService
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice matchtypesummary :MatchTypeKey :self.matchcode :matchstatus  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            
            matchTypeCode =[responseObject valueForKey:@"MatchType"];
            
            if(self.isTest == YES)
            {
                self.ODIview.hidden=YES;
                self.TESTview.hidden=NO;
                [self.session1 setTitle:@"SESSION1"  forState:UIControlStateNormal];
                [self.session2 setTitle:@"SESSION2"  forState:UIControlStateNormal];
                [self.session3 setTitle:@"SESSION3"  forState:UIControlStateNormal];
                [self.day1 sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            else if(self.isTest == NO)
            {
                self.ODIview.hidden=NO;
                self.TESTview.hidden=YES;
                [self.session1 setTitle:@"1-6 Ov"  forState:UIControlStateNormal];
                [self.session2 setTitle:@"7-15 Ov"  forState:UIControlStateNormal];
                [self.session3 setTitle:@"16-20 Ov"  forState:UIControlStateNormal];
                [self.Innings1 sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            
            //[self.day1 sendActionsForControlEvents:UIControlEventTouchUpInside];
          
            [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

-(void)OdiService1
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice SingledaySession :SingledayKey :self.matchcode :matchTypeCode:sessionNo:innNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr= [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            arr2= [responseObject valueForKey:@"lstSessionPartnerships"];
            
            pacearrS1 = [[NSMutableArray alloc]init];
            pacearrS1= [responseObject valueForKey:@"lstSessionPace"];
            
            spinarrS1 = [[NSMutableArray alloc]init];
            spinarrS1= [responseObject valueForKey:@"lstSessionSpin"];
            
            
            
            
            for(int i =0;i<arr.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [day1Sessionarray addObject:arr1];
                
            }
            sessionNo = @"2";
            [self OdiService2];
            
            Session1array = [[NSMutableArray alloc]init];
            for(int i =0;i<arr2.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr2 objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [Session1array addObject:arr1];
                
            }
            
            CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
            self.partnrTblHeight.constant = height1;
            [self.view layoutIfNeeded];
            
            self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
            
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            self.scrollView.contentSize = contentRect.size;

            
            [self.view updateConstraintsIfNeeded];
            NSLog(@"%@", day1Sessionarray);
            
            
            

            [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

-(void)OdiService2
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice SingledaySession :SingledayKey :self.matchcode :matchTypeCode:sessionNo:innNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr= [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            arr2= [responseObject valueForKey:@"lstSessionPartnerships"];
            
            
            pacearrS2 = [[NSMutableArray alloc]init];
            pacearrS2= [responseObject valueForKey:@"lstSessionPace"];
            
            spinarrS2 = [[NSMutableArray alloc]init];
            spinarrS2= [responseObject valueForKey:@"lstSessionSpin"];
            
            for(int i =0;i<arr.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [day1Sessionarray addObject:arr1];
                
                
            }
            
            sessionNo = @"3";
            [self OdiService3];
            
            Session2array = [[NSMutableArray alloc]init];
            for(int i =0;i<arr2.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr2 objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [Session2array addObject:arr1];
                
            }
            
            CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
            self.partnrTblHeight.constant = height1;
            [self.view layoutIfNeeded];
            
            self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
            
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            self.scrollView.contentSize = contentRect.size;

            
            [self.view updateConstraintsIfNeeded];
            
            
            
            NSLog(@"%@", day1Sessionarray);
           [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

-(void)OdiService3
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice SingledaySession :SingledayKey :self.matchcode :matchTypeCode:sessionNo:innNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr= [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            arr2= [responseObject valueForKey:@"lstSessionPartnerships"];
            
            
            pacearrS3 = [[NSMutableArray alloc]init];
            pacearrS3= [responseObject valueForKey:@"lstSessionPace"];
            
            spinarrS3 = [[NSMutableArray alloc]init];
            spinarrS3= [responseObject valueForKey:@"lstSessionSpin"];
            
            for(int i =0;i<arr.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [day1Sessionarray addObject:arr1];
                
            }
            
            NSLog(@"%@", day1Sessionarray);
            
            //            commonArray = [[NSMutableArray alloc]init];
            //            commonArray = day1Sessionarray;
        
            [self.dayTbl reloadData];
        
            CGFloat height = MIN(self.view.bounds.size.height, self.dayTbl.contentSize.height);
            self.TblHeight.constant = height;
            [self.view layoutIfNeeded];
            
            
            
            
            Session3array = [[NSMutableArray alloc]init];
            for(int i =0;i<arr2.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr2 objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [Session3array addObject:arr1];
                
            }
            
            [self.session1 sendActionsForControlEvents:UIControlEventTouchUpInside];
        
            [self.partnrshpTbl reloadData];
        
            CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
            self.partnrTblHeight.constant = height1;
            [self.view layoutIfNeeded];
            
            
            self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
            
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            self.scrollView.contentSize = contentRect.size;
            
            [self.view updateConstraintsIfNeeded];
           [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}





-(void)SessionWebservice1
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice sessionsummary:SessionKey :self.matchcode :matchstatus :dayno :sessionNo :innNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr= [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            arr2= [responseObject valueForKey:@"lstSessionPartnerships"];
            
            pacearrS1 = [[NSMutableArray alloc]init];
            pacearrS1= [responseObject valueForKey:@"lstSessionPace"];
            
            spinarrS1 = [[NSMutableArray alloc]init];
            spinarrS1= [responseObject valueForKey:@"lstSessionSpin"];
            
            
            
            
            for(int i =0;i<arr.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [day1Sessionarray addObject:arr1];
                
            }
            sessionNo = @"2";
            [self SessionWebservice2];
            
            Session1array = [[NSMutableArray alloc]init];
            for(int i =0;i<arr2.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr2 objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [Session1array addObject:arr1];
                
            }
            
            CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
            self.partnrTblHeight.constant = height1;
            [self.view layoutIfNeeded];
            
            
            self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
            
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            self.scrollView.contentSize = contentRect.size;
            
            [self.view updateConstraintsIfNeeded];
            
            
            NSLog(@"%@", day1Sessionarray);
            
            
            // day1Session1array = [responseObject valueForKey:@"lstSessionTeamSummary"];
           [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

-(void)SessionWebservice2
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice sessionsummary:SessionKey :self.matchcode :matchstatus :dayno :sessionNo :innNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            
            // day1Session1array = [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr= [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            arr2= [responseObject valueForKey:@"lstSessionPartnerships"];
            
            
            pacearrS2 = [[NSMutableArray alloc]init];
            pacearrS2= [responseObject valueForKey:@"lstSessionPace"];
            
            spinarrS2 = [[NSMutableArray alloc]init];
            spinarrS2= [responseObject valueForKey:@"lstSessionSpin"];
            
            for(int i =0;i<arr.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [day1Sessionarray addObject:arr1];
                
                
            }
            
            sessionNo = @"3";
            [self SessionWebservice3];
            
            Session2array = [[NSMutableArray alloc]init];
            for(int i =0;i<arr2.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr2 objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [Session2array addObject:arr1];
                
            }
            
            CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
            self.partnrTblHeight.constant = height1;
            [self.view layoutIfNeeded];
            
            self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
            
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            self.scrollView.contentSize = contentRect.size;
            
            [self.view updateConstraintsIfNeeded];
            
            NSLog(@"%@", day1Sessionarray);
           [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

-(void)SessionWebservice3
{
    [AppCommon showLoading];
    objWebservice = [[WebService alloc]init];
    [objWebservice sessionsummary:SessionKey :self.matchcode :matchstatus :dayno :sessionNo :innNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject>0)
        {
            
            // day1Session1array = [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr= [responseObject valueForKey:@"lstSessionTeamSummary"];
            
            NSMutableArray *arr2 = [[NSMutableArray alloc]init];
            arr2= [responseObject valueForKey:@"lstSessionPartnerships"];
            
            
            pacearrS3 = [[NSMutableArray alloc]init];
            pacearrS3= [responseObject valueForKey:@"lstSessionPace"];
            
            spinarrS3 = [[NSMutableArray alloc]init];
            spinarrS3= [responseObject valueForKey:@"lstSessionSpin"];
            
            for(int i =0;i<arr.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [day1Sessionarray addObject:arr1];
                
            }
            
            NSLog(@"%@", day1Sessionarray);
            
            //            commonArray = [[NSMutableArray alloc]init];
            //            commonArray = day1Sessionarray;
        
            [self.dayTbl reloadData];
        
            CGFloat height = MIN(self.view.bounds.size.height, self.dayTbl.contentSize.height);
            self.TblHeight.constant = height;
            [self.view layoutIfNeeded];
            
            
            Session3array = [[NSMutableArray alloc]init];
            for(int i =0;i<arr2.count;i++)
            {
                NSMutableDictionary *arr1 = [[NSMutableDictionary alloc]init];
                [arr1 setDictionary:[arr2 objectAtIndex:i]];
                //[day1Session1array   addObject:[arr objectAtIndex:i]];
                
                [Session3array addObject:arr1];
                
            }
            
            [self.session1 sendActionsForControlEvents:UIControlEventTouchUpInside];
        
            [self.partnrshpTbl reloadData];
        
            CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
            self.partnrTblHeight.constant = height1;
            [self.view layoutIfNeeded];
            
            self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
            
            CGRect contentRect = CGRectZero;
            for (UIView *view in self.scrollView.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            self.scrollView.contentSize = contentRect.size;
            
            [self.view updateConstraintsIfNeeded];
            
           [AppCommon hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}




-(IBAction)Session1Action:(id)sender
{
    
    [self setSessionsBySelection:@"1"];
    commonArray = [[NSMutableArray alloc]init];
//    commonArray = Session1array;
    [commonArray addObjectsFromArray:Session1array];
    
    //Pace
    self.OversPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceOvers"] objectAtIndex:0]];
    NSString *v1 =[self checkNull:[[pacearrS1 valueForKey:@"PaceOversWidth"] objectAtIndex:0]];
    NSArray* foo = [v1 componentsSeparatedByString: @"%"];
    NSString* firstBit = [foo objectAtIndex: 0];
    float x = [firstBit floatValue];
    self.OvrPrgPace.progress = 1-(x/100);
    
    self.RunsPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceRuns"] objectAtIndex:0]];
    NSString *v2 = [self checkNull:[[pacearrS1 valueForKey:@"PaceRunsWidth"] objectAtIndex:0]];
    NSArray* foo1 = [v2 componentsSeparatedByString: @"%"];
    NSString* firstBit1 = [foo1 objectAtIndex: 0];
    float x1 = [firstBit1 floatValue];
    self.RunsPrgPace.progress = 1-(x1/100);
    
    self.WktsPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceWkts"] objectAtIndex:0]];
    NSString *v3 = [self checkNull:[[pacearrS1 valueForKey:@"PaceWktsWidth"] objectAtIndex:0]];
    NSArray* foo2 = [v3 componentsSeparatedByString: @"%"];
    NSString* firstBit2 = [foo2 objectAtIndex: 0];
    float x2 = [firstBit2 floatValue];
    self.WktsPrgPace.progress = 1-(x2/100);
    
    self.MdnsPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceDots"] objectAtIndex:0]];
    NSString *v4 = [self checkNull:[[pacearrS1 valueForKey:@"PaceDotsWidth"] objectAtIndex:0]];
    NSArray* foo3 = [v4 componentsSeparatedByString: @"%"];
    NSString* firstBit3 = [foo3 objectAtIndex: 0];
    float x3 = [firstBit3 floatValue];
    self.MdnsPrgPace.progress = 1-(x3/100);
    
    self.StrPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceSR"] objectAtIndex:0]];
    NSString *v5 = [self checkNull:[[pacearrS1 valueForKey:@"PaceSRWidth"] objectAtIndex:0]];
    NSArray* foo4 = [v5 componentsSeparatedByString: @"%"];
    NSString* firstBit4 = [foo4 objectAtIndex: 0];
    float x4 = [firstBit4 floatValue];
    self.StrPrgPace.progress = 1-(x4/100);
    
    self.AvgPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceAvg"] objectAtIndex:0]];
    NSString *v6 = [self checkNull:[[pacearrS1 valueForKey:@"PaceAvgWidth"] objectAtIndex:0]];
    NSArray* foo5 = [v6 componentsSeparatedByString: @"%"];
    NSString* firstBit5 = [foo5 objectAtIndex: 0];
    float x5 = [firstBit5 floatValue];
    self.AvgPrgPace.progress = 1-(x5/100);
    
    self.EconPacelbl.text = [self checkNull:[[pacearrS1 valueForKey:@"PaceEcon"] objectAtIndex:0]];
    NSString *v7 = [self checkNull:[[pacearrS1 valueForKey:@"PaceEconWidth"] objectAtIndex:0]];
    NSArray* foo6 = [v7 componentsSeparatedByString: @"%"];
    NSString* firstBit6 = [foo6 objectAtIndex: 0];
    float x6 = [firstBit6 floatValue];
    self.EconPrgPace.progress = 1-(x6/100);

    
    
    
    //spin
    self.OversSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinOvers"] objectAtIndex:0]];
    NSString *vv1 = [self checkNull:[[spinarrS1 valueForKey:@"SpinOversWidth"] objectAtIndex:0]];
    NSArray* fooo = [vv1 componentsSeparatedByString: @"%"];
    NSString* first = [fooo objectAtIndex: 0];
    float y = [first floatValue];
    self.OvrPrgSpin.progress = y/100;
    
    self.RunsSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinRuns"] objectAtIndex:0]];
    NSString *vv2 = [self checkNull:[[spinarrS1 valueForKey:@"SpinRunsWidth"] objectAtIndex:0]];
    NSArray* fooo2 = [vv2 componentsSeparatedByString: @"%"];
    NSString* first2 = [fooo2 objectAtIndex: 0];
    float y1 = [first2 floatValue];
    self.RunsPrgSpin.progress = y1/100;
    
    self.WktsSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinWkts"] objectAtIndex:0]];
    NSString *vv3 = [self checkNull:[[spinarrS1 valueForKey:@"SpinWktsWidth"] objectAtIndex:0]];
    NSArray* fooo3 = [vv3 componentsSeparatedByString: @"%"];
    NSString* first3 = [fooo3 objectAtIndex: 0];
    float y2 = [first3 floatValue];
    self.WktsPrgSpin.progress = y2/100;
    
    
    self.MdnsSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinDots"] objectAtIndex:0]];
    NSString *vv4 = [self checkNull:[[spinarrS1 valueForKey:@"SpinDotsWidth"] objectAtIndex:0]];
    NSArray* fooo4 = [vv4 componentsSeparatedByString: @"%"];
    NSString* first4 = [fooo4 objectAtIndex: 0];
    float y3 = [first4 floatValue];
    self.MdnsPrgSpin.progress = y3/100;
    
    self.StrSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinSR"] objectAtIndex:0]];
    NSString *vv5 = [self checkNull:[[spinarrS1 valueForKey:@"SpinSRWidth"] objectAtIndex:0]];
    NSArray* fooo5 = [vv5 componentsSeparatedByString: @"%"];
    NSString* first5 = [fooo5 objectAtIndex: 0];
    float y4 = [first5 floatValue];
    self.StrPrgSpin.progress = y4/100;
    
    self.AvgSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinAvg"] objectAtIndex:0]];
    NSString *vv6 = [self checkNull:[[spinarrS1 valueForKey:@"SpinAvgWidth"] objectAtIndex:0]];
    NSArray* fooo6 = [vv6 componentsSeparatedByString: @"%"];
    NSString* first6 = [fooo6 objectAtIndex: 0];
    float y5 = [first6 floatValue];
    self.AvgPrgSpin.progress = y5/100;
    
    self.EconSpinlbl.text = [self checkNull:[[spinarrS1 valueForKey:@"SpinEcon"] objectAtIndex:0]];
    NSString *vv7 = [self checkNull:[[spinarrS1 valueForKey:@"SpinEconWidth"] objectAtIndex:0]];
    NSArray* fooo7 = [vv7 componentsSeparatedByString: @"%"];
    NSString* first7 = [fooo7 objectAtIndex: 0];
    float y6 = [first7 floatValue];
    self.EconPrgSpin.progress = y6/100;
    
    [self.partnrshpTbl reloadData];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
    
}
-(IBAction)Session2Action:(id)sender
{
    
    [self setSessionsBySelection:@"2"];
    commonArray = [[NSMutableArray alloc]init];
//    commonArray = Session2array;
    [commonArray addObjectsFromArray:Session2array];

    
    //Pace
    self.OversPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceOvers"] objectAtIndex:0]];
    NSString *v1 = [self checkNull:[[pacearrS2 valueForKey:@"PaceOversWidth"] objectAtIndex:0]];
    NSArray* foo = [v1 componentsSeparatedByString: @"%"];
    NSString* firstBit = [foo objectAtIndex: 0];
    float x = [firstBit floatValue];
    self.OvrPrgPace.progress = 1-(x/100);
    
    self.RunsPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceRuns"] objectAtIndex:0]];
    NSString *v2 =[self checkNull:[[pacearrS2 valueForKey:@"PaceRunsWidth"] objectAtIndex:0]];
    NSArray* foo1 = [v2 componentsSeparatedByString: @"%"];
    NSString* firstBit1 = [foo1 objectAtIndex: 0];
    float x1 = [firstBit1 floatValue];
    self.RunsPrgPace.progress = 1-(x1/100);
    
    self.WktsPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceWkts"] objectAtIndex:0]];
    NSString *v3 = [self checkNull:[[pacearrS2 valueForKey:@"PaceWktsWidth"] objectAtIndex:0]];
    NSArray* foo2 = [v3 componentsSeparatedByString: @"%"];
    NSString* firstBit2 = [foo2 objectAtIndex: 0];
    float x2 = [firstBit2 floatValue];
    self.WktsPrgPace.progress = 1-(x2/100);
    
    self.MdnsPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceDots"] objectAtIndex:0]];
    NSString *v4 = [self checkNull:[[pacearrS2 valueForKey:@"PaceDotsWidth"] objectAtIndex:0]];
    NSArray* foo3 = [v4 componentsSeparatedByString: @"%"];
    NSString* firstBit3 = [foo3 objectAtIndex: 0];
    float x3 = [firstBit3 floatValue];
    self.MdnsPrgPace.progress = 1-(x3/100);
    
    
    self.StrPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceSR"] objectAtIndex:0]];
    NSString *v5 = [self checkNull:[[pacearrS2 valueForKey:@"PaceSRWidth"] objectAtIndex:0]];
    NSArray* foo4 = [v5 componentsSeparatedByString: @"%"];
    NSString* firstBit4 = [foo4 objectAtIndex: 0];
    float x4 = [firstBit4 floatValue];
    self.StrPrgPace.progress = 1-(x4/100);
    
    self.AvgPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceAvg"] objectAtIndex:0]];
    NSString *v6 = [self checkNull:[[pacearrS2 valueForKey:@"PaceAvgWidth"] objectAtIndex:0]];
    NSArray* foo5 = [v6 componentsSeparatedByString: @"%"];
    NSString* firstBit5 = [foo5 objectAtIndex: 0];
    float x5 = [firstBit5 floatValue];
    self.AvgPrgPace.progress = 1-(x5/100);
    
    self.EconPacelbl.text = [self checkNull:[[pacearrS2 valueForKey:@"PaceEcon"] objectAtIndex:0]];
    NSString *v7 = [self checkNull:[[pacearrS2 valueForKey:@"PaceEconWidth"] objectAtIndex:0]];
    NSArray* foo6 = [v7 componentsSeparatedByString: @"%"];
    NSString* firstBit6 = [foo6 objectAtIndex: 0];
    float x6 = [firstBit6 floatValue];
    self.EconPrgPace.progress = 1-(x6/100);
    
    
    //spin
    self.OversSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinOvers"] objectAtIndex:0]];
    NSString *vv1 = [self checkNull:[[spinarrS2 valueForKey:@"SpinOversWidth"] objectAtIndex:0]];
    NSArray* fooo = [vv1 componentsSeparatedByString: @"%"];
    NSString* first = [fooo objectAtIndex: 0];
    float y = [first floatValue];
    self.OvrPrgSpin.progress = y/100;
    
    self.RunsSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinRuns"] objectAtIndex:0]];
    NSString *vv2 = [self checkNull:[[spinarrS2 valueForKey:@"SpinRunsWidth"] objectAtIndex:0]];
    NSArray* fooo2 = [vv2 componentsSeparatedByString: @"%"];
    NSString* first2 = [fooo2 objectAtIndex: 0];
    float y1 = [first2 floatValue];
    self.RunsPrgSpin.progress = y1/100;
    
    self.WktsSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinWkts"] objectAtIndex:0]];
    NSString *vv3 = [self checkNull:[[spinarrS2 valueForKey:@"SpinWktsWidth"] objectAtIndex:0]];
    NSArray* fooo3 = [vv3 componentsSeparatedByString: @"%"];
    NSString* first3 = [fooo3 objectAtIndex: 0];
    float y2 = [first3 floatValue];
    self.WktsPrgSpin.progress = y2/100;
    
    
    self.MdnsSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinDots"] objectAtIndex:0]];
    NSString *vv4 = [self checkNull:[[spinarrS2 valueForKey:@"SpinDotsWidth"] objectAtIndex:0]];
    NSArray* fooo4 = [vv4 componentsSeparatedByString: @"%"];
    NSString* first4 = [fooo4 objectAtIndex: 0];
    float y3 = [first4 floatValue];
    self.MdnsPrgSpin.progress = y3/100;
    
    self.StrSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinSR"] objectAtIndex:0]];
    NSString *vv5 = [self checkNull:[[spinarrS2 valueForKey:@"SpinSRWidth"] objectAtIndex:0]];
    NSArray* fooo5 = [vv5 componentsSeparatedByString: @"%"];
    NSString* first5 = [fooo5 objectAtIndex: 0];
    float y4 = [first5 floatValue];
    self.StrPrgSpin.progress = y4/100;
    
    self.AvgSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinAvg"] objectAtIndex:0]];
    NSString *vv6 = [self checkNull:[[spinarrS2 valueForKey:@"SpinAvgWidth"] objectAtIndex:0]];
    NSArray* fooo6 = [vv6 componentsSeparatedByString: @"%"];
    NSString* first6 = [fooo6 objectAtIndex: 0];
    float y5 = [first6 floatValue];
    self.AvgPrgSpin.progress = y5/100;
    
    self.EconSpinlbl.text = [self checkNull:[[spinarrS2 valueForKey:@"SpinEcon"] objectAtIndex:0]];
    NSString *vv7 = [self checkNull:[[spinarrS2 valueForKey:@"SpinEconWidth"] objectAtIndex:0]];
    NSArray* fooo7 = [vv7 componentsSeparatedByString: @"%"];
    NSString* first7 = [fooo7 objectAtIndex: 0];
    float y6 = [first7 floatValue];
    self.EconPrgSpin.progress = y6/100;
    
    [self.partnrshpTbl reloadData];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
}
-(IBAction)Session3Action:(id)sender
{
    
    [self setSessionsBySelection:@"3"];
    commonArray = [[NSMutableArray alloc]init];
//    commonArray = Session3array;
    [commonArray addObjectsFromArray:Session3array];

    
    //Pace
    self.OversPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceOvers"] objectAtIndex:0]];
    NSString *v1 = [self checkNull:[[pacearrS3 valueForKey:@"PaceOversWidth"] objectAtIndex:0]];
    NSArray* foo = [v1 componentsSeparatedByString: @"%"];
    NSString* firstBit = [foo objectAtIndex: 0];
    float x = [firstBit floatValue];
    self.OvrPrgPace.progress = 1-(x/100);
    
    self.RunsPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceRuns"] objectAtIndex:0]];
    NSString *v2 = [self checkNull:[[pacearrS3 valueForKey:@"PaceRunsWidth"] objectAtIndex:0]];
    NSArray* foo1 = [v2 componentsSeparatedByString: @"%"];
    NSString* firstBit1 = [foo1 objectAtIndex: 0];
    float x1 = [firstBit1 floatValue];
    self.RunsPrgPace.progress = 1-(x1/100);
    
    self.WktsPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceWkts"] objectAtIndex:0]];
    NSString *v3 = [self checkNull:[[pacearrS3 valueForKey:@"PaceWktsWidth"] objectAtIndex:0]];
    NSArray* foo2 = [v3 componentsSeparatedByString: @"%"];
    NSString* firstBit2 = [foo2 objectAtIndex: 0];
    float x2 = [firstBit2 floatValue];
    self.WktsPrgPace.progress = 1-(x2/100);
    
    self.MdnsPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceDots"] objectAtIndex:0]];
    NSString *v4 = [self checkNull:[[pacearrS3 valueForKey:@"PaceDotsWidth"] objectAtIndex:0]];
    NSArray* foo3 = [v4 componentsSeparatedByString: @"%"];
    NSString* firstBit3 = [foo3 objectAtIndex: 0];
    float x3 = [firstBit3 floatValue];
    self.MdnsPrgPace.progress = 1-(x3/100);
    
    self.StrPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceSR"] objectAtIndex:0]];
    NSString *v5 = [self checkNull:[[pacearrS3 valueForKey:@"PaceSRWidth"] objectAtIndex:0]];
    NSArray* foo4 = [v5 componentsSeparatedByString: @"%"];
    NSString* firstBit4 = [foo4 objectAtIndex: 0];
    float x4 = [firstBit4 floatValue];
    self.StrPrgPace.progress = 1-(x4/100);
    
    self.AvgPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceAvg"] objectAtIndex:0]];
    NSString *v6 = [self checkNull:[[pacearrS3 valueForKey:@"PaceAvgWidth"] objectAtIndex:0]];
    NSArray* foo5 = [v6 componentsSeparatedByString: @"%"];
    NSString* firstBit5 = [foo5 objectAtIndex: 0];
    float x5 = [firstBit5 floatValue];
    self.AvgPrgPace.progress = 1-(x5/100);
    
    self.EconPacelbl.text = [self checkNull:[[pacearrS3 valueForKey:@"PaceEcon"] objectAtIndex:0]];
    NSString *v7 = [self checkNull:[[pacearrS3 valueForKey:@"PaceEconWidth"] objectAtIndex:0]];
    NSArray* foo6 = [v7 componentsSeparatedByString: @"%"];
    NSString* firstBit6 = [foo6 objectAtIndex: 0];
    float x6 = [firstBit6 floatValue];
    self.EconPrgPace.progress = 1-(x6/100);
    
    
    
    //spin
    self.OversSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinOvers"] objectAtIndex:0]];
    NSString *vv1 = [self checkNull:[[spinarrS3 valueForKey:@"SpinOversWidth"] objectAtIndex:0]];
    NSArray* fooo = [vv1 componentsSeparatedByString: @"%"];
    NSString* first = [fooo objectAtIndex: 0];
    float y = [first floatValue];
    self.OvrPrgSpin.progress = y/100;
    
    self.RunsSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinRuns"] objectAtIndex:0]];
    NSString *vv2 = [self checkNull:[[spinarrS3 valueForKey:@"SpinRunsWidth"] objectAtIndex:0]];
    NSArray* fooo2 = [vv2 componentsSeparatedByString: @"%"];
    NSString* first2 = [fooo2 objectAtIndex: 0];
    float y1 = [first2 floatValue];
    self.RunsPrgSpin.progress = y1/100;
    
    self.WktsSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinWkts"] objectAtIndex:0]];
    NSString *vv3 = [self checkNull:[[spinarrS3 valueForKey:@"SpinWktsWidth"] objectAtIndex:0]];
    NSArray* fooo3 = [vv3 componentsSeparatedByString: @"%"];
    NSString* first3 = [fooo3 objectAtIndex: 0];
    float y2 = [first3 floatValue];
    self.WktsPrgSpin.progress = y2/100;
    
    
    self.MdnsSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinDots"] objectAtIndex:0]];
    NSString *vv4 = [self checkNull:[[spinarrS3 valueForKey:@"SpinDotsWidth"] objectAtIndex:0]];
    NSArray* fooo4 = [vv4 componentsSeparatedByString: @"%"];
    NSString* first4 = [fooo4 objectAtIndex: 0];
    float y3 = [first4 floatValue];
    self.MdnsPrgSpin.progress = y3/100;
    
    self.StrSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinSR"] objectAtIndex:0]];
    NSString *vv5 = [self checkNull:[[spinarrS3 valueForKey:@"SpinSRWidth"] objectAtIndex:0]];
    NSArray* fooo5 = [vv5 componentsSeparatedByString: @"%"];
    NSString* first5 = [fooo5 objectAtIndex: 0];
    float y4 = [first5 floatValue];
    self.StrPrgSpin.progress = y4/100;
    
    self.AvgSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinAvg"] objectAtIndex:0]];
    NSString *vv6 = [self checkNull:[[spinarrS3 valueForKey:@"SpinAvgWidth"] objectAtIndex:0]];
    NSArray* fooo6 = [vv6 componentsSeparatedByString: @"%"];
    NSString* first6 = [fooo6 objectAtIndex: 0];
    float y5 = [first6 floatValue];
    self.AvgPrgSpin.progress = y5/100;
    
    self.EconSpinlbl.text = [self checkNull:[[spinarrS3 valueForKey:@"SpinEcon"] objectAtIndex:0]];
    NSString *vv7 = [self checkNull:[[spinarrS3 valueForKey:@"SpinEconWidth"] objectAtIndex:0]];
    NSArray* fooo7 = [vv7 componentsSeparatedByString: @"%"];
    NSString* first7 = [fooo7 objectAtIndex: 0];
    float y6 = [first7 floatValue];
    self.EconPrgSpin.progress = y6/100;
    
    [self.partnrshpTbl reloadData];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
}


-(IBAction)Innings1Action:(id)sender
{
    //[self setInningsBySelection:@"1"];
    
    selectedTab =1;
    [self setTabView];
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"1";
    innNo = @"1";
    sessionNo = @"1";
    //self.day1.backgroundColor = [UIColor blueColor];
    [self OdiService1];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
}
-(IBAction)Innings2Action:(id)sender
{
    //[self setInningsBySelection:@"2"];
    
    
    
    selectedTab =2;
    [self setTabView];
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"1";
    innNo = @"2";
    sessionNo = @"1";
    //self.day1.backgroundColor = [UIColor blueColor];
    [self OdiService1];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
}

-(void) setTabView{
    
    if(_isTest){
        
        self.ODIview.hidden = true;
        self.TESTview.hidden = false;
        
        [self clearBtnSubView:self.day1];
        [self clearBtnSubView:self.day2];
        [self clearBtnSubView:self.day3];
        [self clearBtnSubView:self.day4];
        
        if(selectedTab ==  1){
            
            [self.day1 addSubview: [self getLineView:self.day1]];
        }else if(selectedTab ==  2){
            [self.day2 addSubview: [self getLineView:self.day2]];
            
        }else if(selectedTab ==  3){
            [self.day3 addSubview: [self getLineView:self.day3]];
            
        }else if(selectedTab ==  4){
            [self.day4 addSubview: [self getLineView:self.day4]];
            
        }
        
    }else{
        
        self.ODIview.hidden = false;
        self.TESTview.hidden = true;
        
        [self clearBtnSubView:self.Innings1];
        [self clearBtnSubView:self.Innings2];
        
        if(selectedTab ==  1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.Innings1 addSubview: [self getLineView:self.Innings1]];
            });
            
        }else if(selectedTab ==  2){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.Innings2 addSubview: [self getLineView:self.Innings2]];
            });

            
        }
        
    }
    
}

-(UIView *) getLineView : (UIButton *) btn{
//    [btn setBackgroundColor:[UIColor redColor]];
    CGFloat Xvalue = (btn.frame.size.width/4);

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Xvalue, btn.frame.size.height-5, btn.frame.size.width/2, 5)];
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


-(IBAction)day1Action:(id)sender
{
    //[self setDayBySelection:@"1"];
    
    
    selectedTab =1;
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"1";
    innNo = @"1";
    sessionNo = @"1";
    //self.day1.backgroundColor = [UIColor blueColor];
    [self SessionWebservice1];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
    
    
}
-(IBAction)day2Action:(id)sender
{
    [self setDayBySelection:@"2"];
    
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"2";
    innNo = @"1";
    sessionNo = @"1";
    // self.day1.backgroundColor = [UIColor blueColor];
    [self SessionWebservice1];
    
    CGFloat height1 = MIN(self.view.bounds.size.height, self.partnrshpTbl.contentSize.height);
    self.partnrTblHeight.constant = height1;
    [self.view layoutIfNeeded];
    self.ScrollHeight.constant = self.ODIview.frame.size.height+50+self.dayTbl.contentSize.height+self.SessionsView.frame.size.height+height1+900;
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.view updateConstraintsIfNeeded];
}
-(IBAction)day3Action:(id)sender
{
    [self setDayBySelection:@"3"];
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"3";
    innNo = @"1";
    sessionNo = @"1";
    // self.day1.backgroundColor = [UIColor blueColor];
    [self SessionWebservice1];
    
}
-(IBAction)day4Action:(id)sender
{
    [self setDayBySelection:@"4"];
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"4";
    innNo = @"1";
    sessionNo = @"1";
    // self.day1.backgroundColor = [UIColor blueColor];
    [self SessionWebservice1];
    
}
-(IBAction)day5Action:(id)sender
{
    [self setDayBySelection:@"5"];
    day1Sessionarray = [[NSMutableArray alloc]init];
    matchstatus = @"MSC215";
    dayno= @"5";
    innNo = @"1";
    sessionNo = @"1";
    // self.day1.backgroundColor = [UIColor blueColor];
    [self SessionWebservice1];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.dayTbl)
        return day1Sessionarray.count;
    else
        return commonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.dayTbl)
    {
        static NSString *MyIdentifier = @"mycell";
        
        SessionDayCell *cell = [self.dayTbl dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            // cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell=[[SessionDayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        // cell = self.objCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.Sessionlbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"SessionNo"] objectAtIndex:indexPath.row]];
        cell.batlbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"TeamName"] objectAtIndex:indexPath.row]];
        cell.overslbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"Overs"] objectAtIndex:indexPath.row]];
        cell.runslbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"Runs"] objectAtIndex:indexPath.row]];
        cell.runratelbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"RR"] objectAtIndex:indexPath.row]];
        cell.wicketslbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"Wkts"] objectAtIndex:indexPath.row]];
        cell.dotballslbl.text = [self checkNull:[[day1Sessionarray valueForKey:@"Dots"] objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else  if(tableView == self.partnrshpTbl)
    {
        static NSString *MyIdentifier = @"mycell";
        
        SessionPartCell *cell = [self.partnrshpTbl dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            // cell = [self.listTbl dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell=[[SessionPartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        
        // cell = self.objCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *plyAname = [self checkNull:[[commonArray valueForKey:@"PlayerAName"] objectAtIndex:indexPath.row]];
        NSString *plyAruns = [self checkNull:[[commonArray valueForKey:@"PlayerARuns"] objectAtIndex:indexPath.row]];
        NSString *plyAballs = [self checkNull:[[commonArray valueForKey:@"PlayerABalls"] objectAtIndex:indexPath.row]];
        
        NSString *plyBname = [self checkNull:[[commonArray valueForKey:@"PlayerBName"] objectAtIndex:indexPath.row]];
        NSString *plyBruns = [self checkNull:[[commonArray valueForKey:@"PlayerBRuns"] objectAtIndex:indexPath.row]];
        NSString *plyBballs = [self checkNull:[[commonArray valueForKey:@"PlayerBBalls"] objectAtIndex:indexPath.row]];
        
        cell.playerA.text = [NSString stringWithFormat:@"%@ %@(%@)",plyAname,plyAruns,plyAballs];
        cell.playerB.text = [NSString stringWithFormat:@"%@ %@(%@)",plyBname,plyBruns,plyBballs];
        cell.runs.text = [self checkNull:[[commonArray valueForKey:@"PartneshipRuns"] objectAtIndex:indexPath.row]];
        
        NSString *v1 = [self checkNull:[[commonArray valueForKey:@"PartneshipA"] objectAtIndex:indexPath.row]];
        NSString *v2 = [self checkNull:[[commonArray valueForKey:@"PartneshipB"] objectAtIndex:indexPath.row]];
        
        NSArray* foo = [v1 componentsSeparatedByString: @"%"];
        NSString* firstBit = [foo objectAtIndex: 0];
        float x = [firstBit floatValue];
        
        
        NSArray* foo1 = [v2 componentsSeparatedByString: @"%"];
        NSString* firstBit1 = [foo1 objectAtIndex: 0];
        float x1 = [firstBit1 floatValue];
        
        cell.pr1.progress = 1-(x/100);
        cell.pr2.progress = x1/100;
        return cell;
        
    }
    return nil;
}


-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.Innings1];
    [self setInningsButtonUnselect:self.Innings2];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.Innings1];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.Innings2];
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
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}

-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#0D2B81"];
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2CA9D9"];
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

-(void) setSessionsBySelection: (NSString*) innsNo{
    
    [self setSessionsButtonUnselect:self.session1];
    [self setSessionsButtonUnselect:self.session2];
    [self setSessionsButtonUnselect:self.session3];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setSessionsButtonSelect:self.session1];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setSessionsButtonSelect:self.session2];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setSessionsButtonSelect:self.session3];
    }
    
    
}

-(void) setSessionsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    //UIColor *extrasBrushBG = [self colorWithHexString : @"#000000"];
    //innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

-(void) setSessionsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    // UIColor *extrasBrushBG = [self colorWithHexString : @"#FFFFFF"];
    //innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}


-(void) setDayBySelection: (NSString*) innsNo{
    
    [self setDayButtonUnselect:self.day1];
    [self setDayButtonUnselect:self.day2];
    [self setDayButtonUnselect:self.day3];
    [self setDayButtonUnselect:self.day4];
    [self setDayButtonUnselect:self.day5];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setDayButtonSelect:self.day1];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setDayButtonSelect:self.day2];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setDayButtonSelect:self.day3];
    }
    else if([innsNo isEqualToString:@"4"]){
        
        [self setDayButtonSelect:self.day4];
    }
    else if([innsNo isEqualToString:@"5"]){
        
        [self setDayButtonSelect:self.day5];
    }
    
}


-(void) setDayButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#0D2B81"];
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void) setDayButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2CA9D9"];
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    [innsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

-(IBAction)BackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
