//
//  NewTabbarAnimationVC.m
//  APT_V2
//
//  Created by Apple on 03/07/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "NewTabbarAnimationVC.h"
#import "MCOverViewVC.h"
#import "MCTossAndResultsVC.h"
#import "MCTeamCompVC.h"
#import "MCBattingRootVC.h"
#import "GroundVC.h"
#import "StandingVC.h"
#import "MCBowlingRootVC.h"
#import "TeamHeadToHead.h"
#import "TeamOverviewVC.h"
#import "Config.h"
#import "HomeScreenStandingsVC.h"

typedef NS_ENUM(NSInteger, BATabBarType) {
    BATabBarTypeWithText,
    BATabBarTypeNoText
};

@interface NewTabbarAnimationVC ()

@property (nonatomic, assign) bool firstTime;
@property (nonatomic, assign) BATabBarType demoType;
@property (nonatomic, strong) BATabBarController* vc;

@end

@implementation NewTabbarAnimationVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTime = YES;
    
    //for easy swtiching between demos
    //self.demoType = BATabBarTypeWithText;
}


- (void)viewDidLayoutSubviews {
        BATabBarItem *tabBarItem1, *tabBarItem2, *tabBarItem3,*tabBarItem4,*tabBarItem5,*tabBarItem6,*tabBarItem7,*tabBarItem8;
        
//        UIViewController *Mvc1 = [[UIViewController alloc] init];
//        UIViewController *Mvc2 = [[UIViewController alloc] init];
//        UIViewController *Mvc3 = [[UIViewController alloc] init];
//        UIViewController *Mvc4 = [[UIViewController alloc] init];
//        UIViewController *Mvc5 = [[UIViewController alloc] init];
//        UIViewController *Mvc6 = [[UIViewController alloc] init];
//        UIViewController *Mvc7 = [[UIViewController alloc] init];
//        UIViewController *Mvc8 = [[UIViewController alloc] init];
    

        MCOverViewVC *Mvc1 = [MCOverViewVC new];
        Mvc1 = [[MCOverViewVC alloc] initWithNibName:@"MCOverViewVC" bundle:nil];
        Mvc1.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);
        
        MCTossAndResultsVC* Mvc2 = [MCTossAndResultsVC new];
        Mvc2 = [[MCTossAndResultsVC alloc] initWithNibName:@"MCTossAndResultsVC" bundle:nil];
        Mvc2.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);

        MCTeamCompVC *Mvc3 = [MCTeamCompVC new];
        Mvc3 = [[MCTeamCompVC alloc] initWithNibName:@"MCTeamCompVC" bundle:nil];
        Mvc3.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);

        MCBattingRootVC *Mvc4 = [MCBattingRootVC new];
        Mvc4 = [[MCBattingRootVC alloc] initWithNibName:@"MCBattingRootVC" bundle:nil];
        Mvc4.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);

        MCBowlingRootVC *Mvc5 = [MCBowlingRootVC new];
        Mvc5 = [[MCBowlingRootVC alloc] initWithNibName:@"MCBowlingRootVC" bundle:nil];
        Mvc5.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);

        GroundVC *Mvc6 = [GroundVC new];
        Mvc6 = [[GroundVC alloc] initWithNibName:@"GroundVC" bundle:nil];
        Mvc6.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);

        TeamHeadToHead *Mvc7 = [TeamHeadToHead new];
        Mvc7 = [[TeamHeadToHead alloc] initWithNibName:@"TeamHeadToHead" bundle:nil];
        Mvc7.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);

        HomeScreenStandingsVC *Mvc8 = [HomeScreenStandingsVC new];
        Mvc8 = [[HomeScreenStandingsVC alloc] initWithNibName:@"HomeScreenStandingsVC" bundle:nil];
        Mvc8.view.frame = CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height-50);
    
    if(IS_IPAD)
    {
        //Overview
        NSMutableAttributedString *option1 = [[NSMutableAttributedString alloc] initWithString:@"Overview"];
        [option1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option1.length)];
        
        tabBarItem1 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Overview_Unselect"] selectedImage:[UIImage imageNamed:@"Overview_select"] title:option1];
        
        // BATabBarBadge *badge = [[BATabBarBadge alloc] initWithValue:@22 backgroundColor:[UIColor redColor]];
        // tabBarItem.badge = badge;
        
        
        
        
        
        //TossAndResults
        NSMutableAttributedString *option2 = [[NSMutableAttributedString alloc] initWithString:@"Toss&Result"];
        [option2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option2.length)];
        tabBarItem2 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Toss_Unselect"] selectedImage:[UIImage imageNamed:@"Toss_select"] title:option2];
        
        
        
        
        
        //teamComp
        
        NSMutableAttributedString * option3 = [[NSMutableAttributedString alloc] initWithString:@"TeamComposition"];
        [option3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option3.length)];
        tabBarItem3 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"TeamComp_Unselect"] selectedImage:[UIImage imageNamed:@"TeamComp_select"] title:option3];
        
        
        
        //Batting
        
        NSMutableAttributedString * option4 = [[NSMutableAttributedString alloc] initWithString:@"Batting"];
        [option4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option4.length)];
        tabBarItem4 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Batting_UnSelect"] selectedImage:[UIImage imageNamed:@"Batting_Select"] title:option4];
        
        
        
        //Bowling
        
        NSMutableAttributedString * option5 = [[NSMutableAttributedString alloc] initWithString:@"Bowling"];
        [option5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option5.length)];
        tabBarItem5 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Bowling_Unselect"] selectedImage:[UIImage imageNamed:@"Bowling_select"] title:option5];
        
        
        //Ground
        
        NSMutableAttributedString * option6 = [[NSMutableAttributedString alloc] initWithString:@"Ground"];
        [option6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option6.length)];
        tabBarItem6 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Ground_Unselect"] selectedImage:[UIImage imageNamed:@"Ground_select"] title:option6];
        
        
        
        //H2H
        
        NSMutableAttributedString * option7 = [[NSMutableAttributedString alloc] initWithString:@"H2H"];
        [option7 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option7.length)];
        tabBarItem7 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"H2H_White"] selectedImage:[UIImage imageNamed:@"H2HBlue"] title:option7];
        
        //Standings
        
        NSMutableAttributedString * option8 = [[NSMutableAttributedString alloc] initWithString:@"Standings"];
        [option8 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option8.length)];
        tabBarItem8 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Standings_Unselected"] selectedImage:[UIImage imageNamed:@"Standings_selected"] title:option8];
    }
    else
    {
        //Overview
        // NSMutableAttributedString *option1 = [[NSMutableAttributedString alloc] initWithString:@"Overview"];
        //[option1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option1.length)];
        
        tabBarItem1 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Overview_Unselect"] selectedImage:[UIImage imageNamed:@"Overview_select"]];
        
        // BATabBarBadge *badge = [[BATabBarBadge alloc] initWithValue:@22 backgroundColor:[UIColor redColor]];
        // tabBarItem.badge = badge;
        
        
        
        
        
        //TossAndResults
        //NSMutableAttributedString *option2 = [[NSMutableAttributedString alloc] initWithString:@"Toss&Result"];
        // [option2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option2.length)];
        tabBarItem2 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Toss_Unselect"] selectedImage:[UIImage imageNamed:@"Toss_select"]];
        
        
        
        
        
        //teamComp
        
        //NSMutableAttributedString * option3 = [[NSMutableAttributedString alloc] initWithString:@"TeamComposition"];
        //[option3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option3.length)];
        tabBarItem3 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"TeamComp_Unselect"] selectedImage:[UIImage imageNamed:@"TeamComp_select"]];
        
        
        
        //Batting
        
        //NSMutableAttributedString * option4 = [[NSMutableAttributedString alloc] initWithString:@"Batting"];
        //[option4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option4.length)];
        tabBarItem4 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Batting_UnSelect"] selectedImage:[UIImage imageNamed:@"Batting_Select"]];
        
        
        
        //Bowling
        
        // NSMutableAttributedString * option5 = [[NSMutableAttributedString alloc] initWithString:@"Bowling"];
        //[option5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option5.length)];
        tabBarItem5 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Bowling_Unselect"] selectedImage:[UIImage imageNamed:@"Bowling_select"]];
        
        
        //Ground
        
        //NSMutableAttributedString * option6 = [[NSMutableAttributedString alloc] initWithString:@"Ground"];
        //[option6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option6.length)];
        tabBarItem6 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Ground_Unselect"] selectedImage:[UIImage imageNamed:@"Ground_select"]];
        
        
        
        //H2H
        
        //NSMutableAttributedString * option7 = [[NSMutableAttributedString alloc] initWithString:@"H2H"];
        //[option7 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option7.length)];
        tabBarItem7 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"H2H_White"] selectedImage:[UIImage imageNamed:@"H2HBlue"]];
        
        //Standings
        
        //NSMutableAttributedString * option8 = [[NSMutableAttributedString alloc] initWithString:@"Standings"];
        //[option8 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xF0F2F6] range:NSMakeRange(0,option8.length)];
        tabBarItem8 = [[BATabBarItem alloc] initWithImage:[UIImage imageNamed:@"Standings_Unselected"] selectedImage:[UIImage imageNamed:@"Standings_selected"]];
    }
        
        self.vc = [[BATabBarController alloc] init];
    
        self.vc.viewControllers = @[Mvc1,Mvc2,Mvc3,Mvc4,Mvc5,Mvc6,Mvc7,Mvc8];
        self.vc.tabBarItems = @[tabBarItem1,tabBarItem2,tabBarItem3,tabBarItem4,tabBarItem5,tabBarItem6,tabBarItem7,tabBarItem8];
        [self.vc setSelectedViewController:Mvc1 animated:NO];
        
        self.vc.delegate = self;
        self.vc.tabBar.backgroundColor = [UIColor colorWithRed:(24/255.0f) green:(40/255.0f) blue:(126/255.0f) alpha:1.0f];
        
        [self.view addSubview:self.vc.view];
        self.firstTime = NO;
    
}

- (void)tabBarController:(BATabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"Delegate success!");
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
