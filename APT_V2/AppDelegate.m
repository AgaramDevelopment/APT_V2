//
//  AppDelegate.m
//  APT_V2
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenStandingsVC.h"
#import "MatchCenterTBC.h"
#import "TeamsVC.h"
#import "TabHomeVC.h"
@interface AppDelegate ()
{
    BOOL IsTimer;
    BOOL isBackGroundTaskRunning;
    NSTimer* _timer;
    BOOL isCoach;
    
}

@end

@implementation AppDelegate

@synthesize window,revealViewController;

@synthesize frontNavigationController,rearNavigationController;

@synthesize storyBoard,rearViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
    //    UIViewController *frontViewController = [storyBoard instantiateViewControllerWithIdentifier:(isLogin ? @"frontViewController" : @"LoginVC")];
    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
    NSString *plyRolecode = @"ROL0000002";
    
    UIViewController *frontViewController;
    if(isLogin==YES)
    {
        if([rolecode isEqualToString:plyRolecode])
        {
            frontViewController = [TabHomeVC new];
        }
        else
        {
            frontViewController = [TeamsVC new];
        }
    }
    else
    {
        frontViewController = [LoginVC new];
    }

    rearViewController = [[RearViewController alloc] init];
    frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    revealViewController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    [frontNavigationController setNavigationBarHidden:YES];
    [rearNavigationController setNavigationBarHidden:YES];
    [revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    window.rootViewController = revealViewController;
    
    [window setBackgroundColor:[UIColor whiteColor]];
    [window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - SWRevealViewDelegate

- (id <UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    //    if ( operation != SWRevealControllerOperationReplaceRightController )
    //        return nil;
    //
    //    if ( [toVC isKindOfClass:[RightViewController class]] )
    //    {
    //        if ( [(RightViewController*)toVC wantsCustomAnimation] )
    //        {
    //            id<UIViewControllerAnimatedTransitioning> animationController = [[CustomAnimationController alloc] init];
    //            return animationController;
    //        }
    //    }
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    IsTimer=NO;
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    IsTimer=YES;
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    

    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    IsTimer=YES;
    UIApplication *app = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)SynenableanddisbleMethod
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"onlineSyn"])
    {
        IsTimer=YES;
        UIApplication *app = [UIApplication sharedApplication];
        
        //create new uiBackgroundTask
        __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        
        //and create new timer with async call:
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
    else
    {
        
        UIApplication *app = [UIApplication sharedApplication];
        //create new uiBackgroundTask
        __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        //and create new timer with async call:
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
            //[[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            //[[NSRunLoop currentRunLoop] run];
        });
        IsTimer=NO;
        
    }
    
}

-(void)methodRunAfterBackground
{
    
        NSLog(@"background process method");
        if(IsTimer == YES)
        {
            BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
            
            if(isLogin)
            {
                if(self.checkInternetConnection && !isBackGroundTaskRunning){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            DBMANAGERSYNC * objCaptransactions = [DBMANAGERSYNC sharedManager];
                            NSString *SequenceNo = @"0";
                            
                            if(![SequenceNo isEqualToString:@""] && ![SequenceNo isEqualToString:@"(null)"] ){
                                
                                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                                dic = [objCaptransactions AssessmentEntrySyncBackground];
                                NSMutableArray *reqList = [[NSMutableArray alloc]init];
                                reqList = [dic valueForKey:@"LstAssessmententry"];
                                if(reqList.count>0 ){
                                    [self PushWebservice:dic];
                                }
                            }
                        });
                    });
                }
                

            }
            
            
        }
        else if( IsTimer== NO)
        {
            if ([_timer isValid]) {
                [_timer invalidate];
            }
            _timer = nil;
            
        }
}

-(void)PushWebservice :(NSMutableDictionary *)reqdic
{
    
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",pushServiceKey]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        NSLog(@"response ; %@",reqdic);
        [manager POST:URLString parameters:reqdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                //if([[responseObject valueForKey:@"Message"] isEqualToString:@"PSUCCESS"])
                BOOL status = [responseObject valueForKey:@"Status"];
                if(status == 1)
                {
                    NSMutableArray *Assessmentlist = [responseObject valueForKey:@"LstAssessmententry"];
                    for(int i = 0;i<Assessmentlist.count;i++)
                    {
                        DBMANAGERSYNC * dbConnect = [DBMANAGERSYNC sharedManager];
                        [dbConnect UPDATESyncStatus:[Assessmentlist objectAtIndex:i]];
                    }
                    
                }
               
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
        }];
    }
    
}



- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end

