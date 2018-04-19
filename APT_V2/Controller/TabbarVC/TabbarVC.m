//
//  TabbarVC.m
//  APT_V2
//
//  Created by Apple on 06/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TabbarVC.h"
#import "ScoreCardVC.h"
#import "PlayersVC.h"
#import "SessionSummaryVC.h"
#import "FieldSummaryVC.h"

@interface TabbarVC ()
{
    ScoreCardVC *firstViewController;
    PlayersVC *secondViewController;
    PlayersVC *thirdViewController;
    FieldSummaryVC *fourthVC;
    SessionSummaryVC *fifthVC;
}

@end

@implementation TabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewDidAppear:(BOOL)animated
{
  // [self setUpTabBar];
    
    [self changeTabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) setUpTabBar {
    
    self.tabBar.barTintColor = [UIColor brownColor];
    
    //MCOverViewVC
    firstViewController = [[ScoreCardVC alloc]init];
    firstViewController.title = @"ScoreCard";
    firstViewController.tabBarItem = self.overviewBarItem;
    //firstViewController.matchDetails = self.matchDetails;
    //firstViewController.matchCode = self.matchCode;
    firstViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"Overview_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    firstViewController.tabBarItem.image = [[UIImage imageNamed:@"Overview_Unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
    //MCTossAndResultsVC
   secondViewController = [[PlayersVC alloc]init];
    secondViewController.title = @"BattingKPI";
    secondViewController.tabBarItem = self.tossAndResultBarItem;
    
    secondViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"Batting_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    secondViewController.tabBarItem.image = [[UIImage imageNamed:@"Batting_UnSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
    
    
    //MCTeamCompVC
    thirdViewController = [[PlayersVC alloc]init];
    thirdViewController.title = @"BowlingKPI";
    thirdViewController.tabBarItem = self.tossAndResultBarItem;
    
    thirdViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"Bowling_SelectIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    thirdViewController.tabBarItem.image = [[UIImage imageNamed:@"Bowling_Unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    fourthVC = [[FieldSummaryVC alloc]init];
    fourthVC.title = @"Fielding Summary";
    fourthVC.tabBarItem = self.tossAndResultBarItem;
    
    fourthVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"ico_calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    fourthVC.tabBarItem.image = [[UIImage imageNamed:@"ico_calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    fifthVC = [[SessionSummaryVC alloc]init];
    fifthVC.title = @"Over Block Summary";
    fifthVC.tabBarItem = self.tossAndResultBarItem;
    
    fifthVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"ico_calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    fifthVC.tabBarItem.image = [[UIImage imageNamed:@"ico_calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
    self.viewControllers = [[NSArray alloc] initWithObjects:firstViewController, secondViewController,thirdViewController,fourthVC,fifthVC, nil];
    
    
//    self.tabBar.barTintColor=[UIColor colorWithRed:(24/255.0f) green:(40/255.0f) blue:(126/255.0f) alpha:1.0f];
    
    // Add this code to change StateNormal text Color,
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor grayColor]}
//                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
//                                           forState:UIControlStateSelected];
    
}

-(void)changeTabbar
{
    UITabBar *tabBar = self.tabBarCntrlr;
    
    UITabBarItem *tabItem1 = [tabBar.items objectAtIndex:0];
    tabItem1.selectedImage = [[UIImage imageNamed:@"Overview_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabItem1.image = [[UIImage imageNamed:@"Overview_Unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabItem1.title = @"SCORECARD";
    //tabItem1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
//    UITabBarItem *tabItem2 = [tabBar.items objectAtIndex:1];
//    tabItem2.selectedImage = [[UIImage imageNamed:@"Batting_Select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//    tabItem2.image = [[UIImage imageNamed:@"Batting_UnSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//    tabItem2.title = @"BATTING KPI";
//    //tabItem2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//
//    UITabBarItem *tabItem3 = [tabBar.items objectAtIndex:2];
//    tabItem3.selectedImage = [[UIImage imageNamed:@"Bowling_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//    tabItem3.image = [[UIImage imageNamed:@"Bowling_Unselect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
//    tabItem3.title = @"BOWLING KPI";
    //tabItem3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    UITabBarItem *tabItem2 = [tabBar.items objectAtIndex:1];
    tabItem2.selectedImage = [[UIImage imageNamed:@"Field_Select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabItem2.image = [[UIImage imageNamed:@"Field_UnSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabItem2.title = @"FIELDING SUMMARY";
    //tabItem4.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    UITabBarItem *tabItem3 = [tabBar.items objectAtIndex:2];
    tabItem3.selectedImage = [[UIImage imageNamed:@"OverBlock_Select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabItem3.image = [[UIImage imageNamed:@"OverBlock_UnSelect"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabItem3.title = @"OVER BLOCK SUMMARY";
    //tabItem5.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
  
    self.tabBar.barTintColor=[UIColor colorWithRed:(24/255.0f) green:(40/255.0f) blue:(126/255.0f) alpha:1.0f];

    //self.tabBar.tintColor = [UIColor whiteColor];
    //self.tabBar.unselectedItemTintColor = [UIColor colorWithRed:(80/255.0f) green:(177/255.0f) blue:(215/255.0f) alpha:1.0f];
    
    //
    
    // Add this code to change StateNormal text Color,
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor colorWithRed:(80/255.0f) green:(177/255.0f) blue:(215/255.0f) alpha:1.0f]}
//                                           forState:UIControlStateNormal];
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor blackColor]}
//                                           forState:UIControlStateNormal];
//
//    // then if StateSelected should be different, you should add this code
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
//                                           forState:UIControlStateSelected];
    
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tabBar.tintColor = [UIColor colorWithRed:(80/255.0f) green:(177/255.0f) blue:(215/255.0f) alpha:1.0f];
    [tabBar setUnselectedItemTintColor:[UIColor whiteColor]];
    
//    [tabBar setselectedItemTintColor:[UIColor colorWithRed:(37/255.0f) green:(176/255.0f) blue:(240/255.0f) alpha:1.0f]];
//
    

//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
//                                           forState:UIControlStateNormal];
//
//    // then if StateSelected should be different, you should add this code
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor colorWithRed:(37/255.0f) green:(176/255.0f) blue:(240/255.0f) alpha:1.0f]}
//                                           forState:UIControlStateSelected];
//
    

    
   
}


@end
