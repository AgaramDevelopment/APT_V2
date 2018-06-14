//
//  MCBattingRootVC.m
//  APT_V2
//
//  Created by apple on 19/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "MCBowlingRootVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "BowlingView.h"
#import "OverviewBowlingView.h"
#import "BowlingOverBlockView.h"


@interface MCBowlingRootVC ()
{
    BowlingView *bowView;
    OverviewBowlingView *overView;
    BowlingOverBlockView *bowlOverBlockView;

}
@end

@implementation MCBowlingRootVC
@synthesize lblSelectedTab,selectedTabWidth,selectedTabLeading;

- (void)viewDidLoad {
    [super viewDidLoad];
    
        // Hide navigationController
    self.navigationController.navigationBarHidden = YES;
    
//    [self setInningsBySelection:@"1"];
    
//    selectedTabLeading.constant = [_battingBtn frame].origin.x +[_battingBtn frame].size.width/4;
//    selectedTabWidth.constant = [_battingBtn frame].size.width/2;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.lblSelectedTab layoutIfNeeded];
//    }];
//
//
//    [self loadContainerView:@"1"];
    
    [self.battingBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//    btView = [[[NSBundle mainBundle] loadNibNamed:@"BattingView" owner:self options:nil] objectAtIndex:0];
//
//
//    btView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
//    btView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self removePreviousView:btView FromSuperView: self.containerView];
//    [self.containerView addSubview:btView];
//
//    [btView loadChart];
//    [btView loadTableFreez];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        selectedTabLeading.constant = [self.battingBtn frame].origin.x +[self.battingBtn frame].size.width/4;
        selectedTabWidth.constant = [self.battingBtn frame].size.width/2;
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.lblSelectedTab layoutIfNeeded];
        }];
    });
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

- (void)removePreviousView:(UIView*)previousView FromSuperView:(UIView*)view{
    for (UIView *subView in view.subviews) {
        if (![subView isKindOfClass:[previousView class]]) {
            [subView removeFromSuperview];
        }
    }
}


-(void) loadContainerView : (NSString *) position{
    
    if([position isEqualToString:@"1"]){

        if(bowView == nil){
            bowView = [[[NSBundle mainBundle] loadNibNamed:@"BowlingView" owner:self options:nil] objectAtIndex:0];
        }
        
        bowView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        bowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self removePreviousView:bowView FromSuperView: self.containerView];
        [self.containerView addSubview:bowView];
        bowView.lblCompetetion.text = [AppCommon getCurrentCompetitionName];
        bowView.lblteam.text = [AppCommon getCurrentTeamName];
        
       // [bowView loadChart];
        [bowView loadTableFreez];

    }else if([position isEqualToString:@"2"]){
       
        if(overView == nil){
        
        overView = [[[NSBundle mainBundle] loadNibNamed:@"OverviewBowlingView" owner:self options:nil] objectAtIndex:0];
        
        }
        
        overView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        overView.lblCompetetion.text = [AppCommon getCurrentCompetitionName];
        overView.teamlbl.text = [AppCommon getCurrentTeamName];

        overView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self removePreviousView:overView FromSuperView: self.containerView];
        [self.containerView addSubview:overView];
        
        [overView loadChart];
       
    }
    else if([position isEqualToString:@"3"]){
        
      //  [self setInningsButtonSelect:self.overBlockBtn];
        
        
        
        if(bowlOverBlockView == nil){
            
            bowlOverBlockView = [[[NSBundle mainBundle] loadNibNamed:@"BowlingOverBlockView" owner:self options:nil] objectAtIndex:0];
            
        }
        
        bowlOverBlockView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        bowlOverBlockView.lblCompetetion.text = [AppCommon getCurrentCompetitionName];
        bowlOverBlockView.teamlbl.text = [AppCommon getCurrentTeamName];

        bowlOverBlockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self removePreviousView:bowlOverBlockView FromSuperView: self.containerView];
        [self.containerView addSubview:bowlOverBlockView];
        
        [bowlOverBlockView loadPowerPlayDetails];
                
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headderView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"Bowling";
    objCustomNavigation.btn_back.hidden = YES;
    objCustomNavigation.home_btn.hidden = YES;
    objCustomNavigation.menu_btn.hidden =NO;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.battingBtn];
    [self setInningsButtonUnselect:self.overViewBtn];
    [self setInningsButtonUnselect:self.overBlockBtn];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.battingBtn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.overViewBtn];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.overBlockBtn];
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
- (IBAction)onClickBatting:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        selectedTabLeading.constant = [sender frame].origin.x +[sender frame].size.width/4;
        selectedTabWidth.constant = [sender frame].size.width/2;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.lblSelectedTab layoutIfNeeded];
        }];

    });

    

//    [self setInningsBySelection:@"1"];
    
    [self loadContainerView : @"1"];
    
}
- (IBAction)onClickOverView:(id)sender {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        selectedTabLeading.constant = [sender frame].origin.x +[sender frame].size.width/4;
        selectedTabWidth.constant = [sender frame].size.width/2;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.lblSelectedTab layoutIfNeeded];
        }];

    });


//    [self setInningsBySelection:@"2"];
    [self loadContainerView : @"2"];

}

- (IBAction)onClickOverBlock:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedTabLeading.constant = [sender frame].origin.x +[sender frame].size.width/4;
        selectedTabWidth.constant = [sender frame].size.width/2;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.lblSelectedTab layoutIfNeeded];
        }];

    });


//    [self setInningsBySelection:@"3"];
    [self loadContainerView : @"3"];

}



@end
