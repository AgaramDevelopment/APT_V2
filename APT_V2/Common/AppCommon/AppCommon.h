//
//  AppCommon.h
//  AlphaProTracker
//
//  Created by Mac on 21/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface AppCommon : NSObject
{
    UIView *loadingView;
    BOOL isPlayer;
    
    
}
@property (nonatomic, strong) NSArray *contents;

+ (AppCommon *)common;
-(BOOL) isInternetReachable;
-(void)webServiceFailureError:(NSError *)error;
-(void)reachabilityNotReachableAlert;
- (CGSize)getControlHeight:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth;

+(NSString *)GetUsercode;
+(NSString *)GetUserName;
+(NSString *) GetClientCode;
+(NSString *) GetuserReference;
+(NSString *)GetUserRoleName;
+(NSString *)GetUserRoleCode;

+(NSString *)getCurrentTeamCode;
+(NSString *)getAppVersion;
-(void)getIPLteams;

+(NSString *)getFileType:(NSString *)filePath;
+(void)showAlertWithMessage:(NSString *)message;
+(void)showLoading;
+(void)hideLoading;

+(UIColor*)colorWithHexString:(NSString*)hex;

-(void)actionLogOut;
+ (NSString *)syncId;

@end

extern AppCommon *sharedCommon;
#define COMMON (sharedCommon? sharedCommon:[AppCommon common])
