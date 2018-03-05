//
//  AppDelegate.h
//  APT_V2
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "RearViewController.h"
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *revealViewController;
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) UINavigationController *frontNavigationController;
@property (strong, nonatomic) RearViewController *rearViewController;
@property (strong, nonatomic) UINavigationController *rearNavigationController;
@end

