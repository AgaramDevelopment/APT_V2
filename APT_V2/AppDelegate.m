//
//  AppDelegate.m
//  IPL-2018 project
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenStandingsVC.h"
#import "MatchCenterTBC.h"
#import "TeamsVC.h"
#import "TabHomeVC.h"
#import "TeamMembersVC.h"
#import "ScoreCardVideoPlayer.h"
#import "BPXLUUIDHandler.h"
#import "DocumentViewController.h"
#import "PlannerAddEvent.h"
#import "TeamsReportsHistoryVC.h"

@interface AppDelegate ()<SharedNotificationDelegate>
{
    BOOL IsTimer;
    BOOL isBackGroundTaskRunning;
    NSTimer* _timer;
    BOOL isCoach;
    UNUserNotificationCenter *center;
    TabHomeVC* tabHome;
}

@end

@implementation AppDelegate

@synthesize window,revealViewController;

@synthesize frontNavigationController,rearNavigationController;

@synthesize storyBoard,rearViewController;

@synthesize ArrayTeam,ArrayCompetition;

@synthesize ArrayIPL_teamplayers,MainArray,LocalNotificationUserInfoArray;

@synthesize DBManSyn,DBCon;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    DBManSyn = [DBMANAGERSYNC sharedManager];
    DBCon = [DBAConnection sharedManager];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLater"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Override point for customization after application launch.
    storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
    center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [self configureLocalNotification];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    tabHome = [TabHomeVC new];
    tabHome.protocol = self;
    
    
    UIViewController *frontViewController;
    [COMMON getIPLteams];
    
//    NSString *rolecode = [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
//    NSString *plyRolecode = @"ROL0000002";
    
    if(![AppCommon isCoach])
    {
        frontViewController = (isLogin ? [TabHomeVC new] : [LoginVC new] );
    } else {
        frontViewController = (isLogin ? [TeamsVC new] : [LoginVC new] );
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    rearViewController = [[RearViewController alloc] init];
    frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    revealViewController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    [frontNavigationController setNavigationBarHidden:YES];
    [rearNavigationController setNavigationBarHidden:YES];
    [revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];

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
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(methodRunAfterBackground) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


-(void)triggerPush{
    
    DBMANAGERSYNC * objCaptransactions = [DBMANAGERSYNC sharedManager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = [objCaptransactions AssessmentEntrySyncBackground];
    NSMutableArray *reqList = [[NSMutableArray alloc]init];
    reqList = [dic valueForKey:@"LstAssessmententry"];
    if(reqList.count>0 ){
        [self PushWebservice:dic];
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
                                
                                [self triggerPush];
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
    
    if(![COMMON isInternetReachable])
        return;
    
        NSString *URLString =  URL_FOR_RESOURCE(pushServiceKey);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        NSLog(@"pushServiceKey request %@",reqdic);
        [manager POST:URLString parameters:reqdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"pushServiceKey response %@",responseObject);
            
            if(responseObject >0) {
                
                BOOL status = [responseObject valueForKey:@"Status"];
                if(status == 1) {
                    
                    NSMutableArray *Assessmentlist = [responseObject valueForKey:@"LstAssessmententry"];
                    for(int i = 0;i<Assessmentlist.count;i++) {
                        
                        DBMANAGERSYNC * dbConnect = [DBMANAGERSYNC sharedManager];
                        [dbConnect UPDATESyncStatus:[Assessmentlist objectAtIndex:i]];
                    }
                    
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"pushServiceKey failed %@",[error description]);
        }];
    
}



- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

/*
#pragma mark - VideoPlayer Landscape Orientation
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//    UIViewController *vc = self.window.rootViewController.presentedViewController;
    UIViewController *vc2 = [self.window.rootViewController presentedViewController];
//    UIViewController *vc2=vc.presentedViewController;
    
    if ([vc2 isKindOfClass:[ScoreCardVideoPlayer class]]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    if ([self.window.rootViewController.presentedViewController isKindOfClass: [ScoreCardVideoPlayer class]]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
*/

//-(UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow :(UIWindow *)window
//{
//    UIViewController *currentVC = [(UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController presentedViewController];
//    if ([currentVC isKindOfClass:[ScoreCardVideoPlayer class]])
//    {
//        return UIInterfaceOrientationMaskAll;
//    }
//
//    return UIInterfaceOrientationMaskPortrait;
//}

#pragma mark - Custom Methods

- (void)configureLocalNotification {
    
    /*
     let options: UNAuthorizationOptions = [.alert, .badge, .sound]
     center.requestAuthorization(options: options) { (granted, error) in
     if granted {
     application.registerForRemoteNotifications()
     }
     }
     */
    
    center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
    
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"Something went wrong");
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    // Play sound and show alert to the user
    completionHandler(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge);
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication]applicationIconBadgeNumber]+1];
    
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSLog(@"getDeliveredNotificationsWithCompletionHandler %@",@(notifications.count));
        
    }];
    
    
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
    if ([response.notification.request.identifier isEqualToString:@"UYLLocalNotification"]) {
        
        
        NSDictionary* responsecontent = response.notification.request.content.userInfo;
        NSLog(@"responsecontent %@",responsecontent);
        [self handlingNotification:responsecontent];
        
        if ([response.actionIdentifier isEqualToString:@"Snooze"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SnoozeNotifcation" object:nil];
            NSLog(@"Snooze");
        } else if ([response.actionIdentifier isEqualToString:@"Delete"]) {
            // Do Nothing
        } else {
            // Do Nothing
        }
    }
    
    completionHandler();
}

-(void)handlingNotification:(NSDictionary *)dict
{
    
    NSDictionary* clickedData = [dict valueForKeyPath:@"userInfo"];
    
    NSLog(@"handlingNotification %@",clickedData);
    
    if ([[clickedData valueForKey:@"TypeDesc"] isEqualToString:@"video"]) {

        NSString* fileName = [clickedData valueForKey:@"FilePath"];
        ScoreCardVideoPlayer *videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
        videoPlayerVC = (ScoreCardVideoPlayer *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
        videoPlayerVC.isFromHome = YES;
        videoPlayerVC.HomeVideoStr = fileName;
        NSLog(@"appDel.frontNavigationController.topViewController %@",appDel.frontNavigationController.topViewController);
        //        [self presentViewController:videoPlayerVC animated:YES completion:nil]; // 19

        [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:^{
            
            NSNumber* badgeCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"badgeCount"];
            NSInteger* badge = [badgeCount integerValue];
            badgeCount = [NSNumber numberWithInteger:badge-1];
            [[NSUserDefaults standardUserDefaults] setValue:badgeCount forKey:@"badgeCount"];

        }];


    } else if ([[clickedData valueForKey:@"TypeDesc"] isEqualToString:@"file"]) {

        DocumentViewController *documentObj = [DocumentViewController new];
        documentObj.isNotificationPDF = YES;
        documentObj.filePath = [clickedData valueForKey:@"FilePath"];
        [appDel.frontNavigationController presentViewController:documentObj animated:YES completion:^{
            
            NSNumber* badgeCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"badgeCount"];
            NSInteger* badge = [badgeCount integerValue];
            badgeCount = [NSNumber numberWithInteger:badge-1];
            [[NSUserDefaults standardUserDefaults] setValue:badgeCount forKey:@"badgeCount"];

        }];
        //        [self.navigationController pushViewController:documentObj animated:YES];
        //        NSString* fileName = [[self.listArray objectAtIndex:indexPath.item] valueForKey:@"FilePath"];
        //            //        pdfView
        //        [self loadWebView:fileName];
        //
        //        [appDel.frontNavigationController presentViewController:pdfView animated:YES completion:^{
        //        }];

    } else if ([[clickedData valueForKey:@"TypeDesc"] isEqualToString:@"Event"]) {

        PlannerAddEvent  * objaddEvent=[[PlannerAddEvent alloc]init];
        //objaddEvent = (PlannerAddEvent *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];

        objaddEvent = (PlannerAddEvent *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"AddEvent"];
        objaddEvent.isEdit =YES;
        objaddEvent.isNotification = @"yes";
        objaddEvent.eventType = [clickedData valueForKey:@"Type"];
        [appDel.frontNavigationController pushViewController:objaddEvent animated:YES];
        
        NSNumber* badgeCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"badgeCount"];
        NSInteger* badge = [badgeCount integerValue];
        badgeCount = [NSNumber numberWithInteger:badge-1];
        [[NSUserDefaults standardUserDefaults] setValue:badgeCount forKey:@"badgeCount"];

    }

//    NSString *notificationCode = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"NotificationCode"];
//    if (![notificationCode isEqualToString:@""]) {
//        //Read Notification for UPDATENOTIFICATIONS
//        [self updateNotificationsPostService:notificationCode];
//    }

}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    
    NSLog(@"didUpdateUserActivity called");
}

- (void)scheduleLocalNotifications:(NSArray *)array {
    
    /*
     Create and configure a UNMutableNotificationContent object with the notification details.
     
     Create a UNCalendarNotificationTrigger, UNTimeIntervalNotificationTrigger, or UNLocationNotificationTrigger object to describe the conditions under which the notification is delivered.
     
     Create a UNNotificationRequest object with the content and trigger information.
     
     Call the addNotificationRequest:withCompletionHandler: method to schedule the notification; see Scheduling Local Notifications for Delivery
     */
    
    NSString *identifier = @"UYLLocalNotification";

    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //    center.delegate = [[UIApplication sharedApplication] delegate];
    UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:@"open"
                                                                              title:@"open" options:UNNotificationActionOptionNone];
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Delete"
                                                                              title:@"Delete" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identifier
                                                                              actions:@[snoozeAction,deleteAction] intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    [center setNotificationCategories:categories];
    
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Don't forget to view";
    content.body = [[array lastObject] valueForKey:@"Description"];
    content.categoryIdentifier = identifier;
    content.sound = [UNNotificationSound defaultSound];
    
//    NotificationCode = NOT0000082;

    content.userInfo = @{@"userInfo":[array lastObject]};
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        NSNumber* count = [NSNumber numberWithInteger:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
        //        content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber]+1);
        content.badge = @(1);
        
    });
    
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
}

- (void)scheduleLocalNotificationImage {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Close"
                                                                              title:@"Close" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"IPLCategoryImage"
                                                                              actions:@[deleteAction] intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    [center setNotificationCategories:categories];
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"LOGO" ofType:@"png"];
    UNNotificationAttachment *imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"UYLReminderAttachmentImage" URL:[NSURL fileURLWithPath:moviePath] options:nil error:nil];
    
    //    UNNotificationAttachment *imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"UYLReminderAttachmentImage" URL:[NSURL fileURLWithPath:moviePath] options:nil error:nil];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Watch";
    content.body = @"Watch is not paired";
    content.categoryIdentifier = @"IPLCategoryImage";
    content.sound = [UNNotificationSound defaultSound];
    content.attachments = @[imageAttachment];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0 repeats:NO];
    
    NSString *identifier = @"IPLCategoryImage";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
}

- (void)scheduleLocalNotificationVideo {
    
    NSString *identifier = @"IPLCategoryVideo";

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Close"
                                                                              title:@"Close" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identifier
                                                                              actions:@[deleteAction] intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    [center setNotificationCategories:categories];
    
//    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"superquest" ofType:@"mp4"];
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"LOGO" ofType:@"png"];

    UNNotificationAttachment *movieAttachment = [UNNotificationAttachment attachmentWithIdentifier:identifier URL:[NSURL fileURLWithPath:moviePath] options:nil error:nil];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Demo";
    content.body = @"Description";
    content.categoryIdentifier = identifier;
    content.sound = [UNNotificationSound defaultSound];
    content.attachments = @[movieAttachment];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    // We will add content here soon.
//    completionHandler();
//    UIBackgroundFetchResultNoData
    
    TabHomeVC *viewController = [TabHomeVC new];
    
    [viewController fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
        
        switch (result) {
            case UIBackgroundRefreshStatusAvailable:
                // We can do background fetch! Let's do this!
                NSLog(@"UIBackgroundRefreshStatusAvailable");
                break;
            case UIBackgroundRefreshStatusDenied:
                // The user has background fetch turned off. Too bad.
                NSLog(@"UIBackgroundRefreshStatusDenied");

                break;
            case UIBackgroundRefreshStatusRestricted:
                // Parental Controls, Enterprise Restrictions, Old Phones, Oh my!
                NSLog(@"UIBackgroundRefreshStatusRestricted");

                break;
        }

    }];
    
//    UIBackgroundRefreshStatus status = [application backgroundRefreshStatus];
//    switch (status) {
//        case UIBackgroundRefreshStatusAvailable:
//            // We can do background fetch! Let's do this!
//            break;
//        case UIBackgroundRefreshStatusDenied:
//            // The user has background fetch turned off. Too bad.
//            break;
//        case UIBackgroundRefreshStatusRestricted:
//            // Parental Controls, Enterprise Restrictions, Old Phones, Oh my!
//            break;
//    }

}

//-(void)PassedValue:(NSNotificationCenter *)notification
//{
//
//}

//-(void)PassedValue:(NSArray *)array
//{
//    [self scheduleLocalNotifications:array];
//}


@end

