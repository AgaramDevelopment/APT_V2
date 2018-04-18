//
//  TabbarVC.h
//  APT_V2
//
//  Created by Apple on 06/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarVC : UITabBarController

@property (strong, nonatomic) IBOutlet UITabBar *tabBarCntrlr;
@property (strong, nonatomic) IBOutlet UITabBarItem *overviewBarItem;
@property (strong, nonatomic) IBOutlet UITabBarItem *tossAndResultBarItem;



@property (strong, nonatomic)  NSString *matchCode;
@property (strong, nonatomic)  NSMutableArray *matchDetails;
@end
