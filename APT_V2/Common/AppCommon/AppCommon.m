//
//  AppCommon.m
//  AlphaProTracker
//
//  Created by Mac on 21/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "AppCommon.h"
#import "Header.h"
#import "WebService.h"

@implementation AppCommon
AppCommon *sharedCommon = nil;

+ (AppCommon *)common {
    
    if (!sharedCommon) {
        
        sharedCommon = [[self alloc] init];
    }
    return sharedCommon;
}

- (id)init {
    
    return self;
}

#pragma mark Reachable

-(BOOL) isInternetReachable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        NSLog(@"Data Connected");
        return YES;
    }
    else {
        [self reachabilityNotReachableAlert];
        return NO;
    }
}

-(void)reachabilityNotReachableAlert{
    [AppCommon hideLoading];
    [AppCommon showAlertWithMessage:@"It appears that you have lost network connectivity. Please check your network settings!"];
}

-(void)webServiceFailureError:(NSError *)error
{
    [AppCommon hideLoading];
    [AppCommon showAlertWithMessage:error.localizedDescription];
}

#pragma mark - get usercode,clientcode,usereferencecode

+(NSString *)GetUsercode
{
    NSString * usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    return usercode;
}

+(NSString *)GetUserName
{
    NSString * userName = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserName"];
    return userName;
}

+(NSString *) GetClientCode
{
    NSString * clientcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    return clientcode;
}
+(NSString *) GetuserReference
{
    NSString * userreference =  [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    return userreference;
}

+(NSString *)GetUserRoleName
{
    NSString * userreference =  [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleName"];
    return userreference;
}

+(NSString *)GetUserRoleCode
{
    NSString * userreference =  [[NSUserDefaults standardUserDefaults]stringForKey:@"RoleCode"];
    return userreference;
}

+(NSString *)getCurrentTeamCode
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedTeamCode"];
}

+(NSString *)getAppVersion
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
        //    NSString *productName = [info objectForKey:@"CFBundleName"];
    NSString *AppVersion = [info objectForKey:@"CFBundleShortVersionString"];
    
    return AppVersion;
}

-(void)getIPLteams
{
    if(![COMMON isInternetReachable])
        return;
    
    
        //    [AppCommon showLoading];
    
    WebService* objWebservice = [[WebService alloc]init];
    [objWebservice getIPLTeamCodessuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject >0)
            {
            appDel.MainArray = [NSMutableArray new];
            appDel.MainArray = responseObject;
            NSLog(@"IPL TEAMS %@ ",appDel.MainArray);
            NSString* Teamcode = [[responseObject firstObject] valueForKey:@"TeamCode"];
            NSString* TeamName = [[responseObject firstObject] valueForKey:@"TeamName"];
            
            [[NSUserDefaults standardUserDefaults] setValue:TeamName forKey:@"SelectedTeamName"];
            [[NSUserDefaults standardUserDefaults] setValue:Teamcode forKey:@"SelectedTeamCode"];
            
            NSLog(@"IPL COMPETETION %@ ",appDel.MainArray);
            NSString* Competetioncode = [[responseObject firstObject] valueForKey:@"CompetitionCode"];
            NSString* CompetetionName = [[responseObject firstObject] valueForKey:@"CompetitionName"];
            
            [[NSUserDefaults standardUserDefaults] setValue:CompetetionName forKey:@"SelectedCompetitionName"];
            [[NSUserDefaults standardUserDefaults] setValue:Competetioncode forKey:@"SelectedCompetitionCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
                //            NSSet* set1 = [NSSet setWithArray:[responseObject valueForKey:@"CompetitionCode"]];
                //            [appDel.ArrayCompetition addObjectsFromArray:];
            
            appDel.ArrayCompetition = [NSMutableArray new];
            
                //            NSMutableArray* temp = [NSMutableArray new];
            for (NSDictionary* dict in responseObject) {
                
                NSLog(@"%@",dict[@"CompetitionCode"]);
                if (![[appDel.ArrayCompetition valueForKey:@"CompetitionCode"] containsObject:dict[@"CompetitionCode"]]) {
                    [appDel.ArrayCompetition addObject:dict];
                    NSLog(@"temp %@",[appDel.ArrayCompetition valueForKey:@"CompetitionCode"]);
                }
                
            }
            NSString* lastYearTeams = [[appDel.ArrayCompetition firstObject] valueForKey:@"CompetitionName"];
            NSArray* temp = [COMMON getCorrespondingTeamName:lastYearTeams];
                //            appDel.ArrayCompetition = temp;
            NSLog(@"appDel.ArrayCompetition %@ ",appDel.ArrayCompetition);
            
            }
        
            //        [AppCommon hideLoading];
        
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self getIPLCompetetion];
            //        });
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
            //        [AppCommon hideLoading];
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        
    }];
    
}

-(NSArray *)getCorrespondingTeamName:(NSString *)competetionName
{
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedCompetitionName"]) {
        NSLog(@"Please select Competetion");
    }
    
    NSLog(@"competetionName %@",appDel.MainArray);
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"CompetitionName == %@", competetionName];
    NSArray* temparray = [appDel.MainArray filteredArrayUsingPredicate:resultPredicate];
    
    if (temparray.count > 0) {
        appDel.ArrayTeam = [NSMutableArray new];
        
        for (NSDictionary* temp1 in temparray) {
            if (![[appDel.ArrayTeam valueForKey:@"TeamCode"] containsObject:[temp1 valueForKey:@"TeamCode"]]) {
                [appDel.ArrayTeam addObject:temp1];
            }
        }
        
    }
    else
        {
        NSString* msg = [NSString stringWithFormat:@"NO Teams Founds in %@",competetionName];
        [AppCommon showAlertWithMessage:msg];
        }
    
    return appDel.ArrayTeam;
}

#pragma mark - Get Height of Control

- (CGSize)getControlHeight:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth {
    CGSize maxSize = LabelWidth;
    CGSize dataHeight;
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.paragraphSpacing = 50 * font.lineHeight;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if ([version floatValue]>=7.0) {
        CGRect textRect = [string boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
        
        
        dataHeight = CGSizeMake(textRect.size.width , textRect.size.height+20);
        
    }
    
    return CGSizeMake(dataHeight.width, dataHeight.height);
}


+(NSString *)getFileType:(NSString *)filePath
{
    NSString* fileExtension = [[filePath pathExtension]lowercaseString];
    if ([fileExtension isEqualToString:@"png"] || [fileExtension isEqualToString:@"jpeg"] || [fileExtension isEqualToString:@"jpg"] ) {
        return @"img";
    }
    else if([fileExtension isEqualToString:@"pdf"]){
        return @"pdf";
    }
    return @"video";
}

+(void)showAlertWithMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [appDel.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+(void)showLoading
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDel.window animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    hud.label.text = @"Please wait";
    [hud setBackgroundColor:[UIColor clearColor]];
}
+(void)hideLoading
{
    [MBProgressHUD hideHUDForView:appDel.window animated:YES];
}

+(UIColor*)colorWithHexString:(NSString*)hex
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

+ (NSString *)syncId
{
    return @"Sync";
}

@end

