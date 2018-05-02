//
//  ChangePasswordVC.m
//  APT_V2
//
//  Created by Apple on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "AppCommon.h"
#import "AppDelegate.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [oldPasswordTF.setup]
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
    
    isBackEnable = NO;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        objCustomNavigation.home_btn.hidden = YES;
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            //[objCustomNavigation.btn_back addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
            //[objCustomNavigation.home_btn addTarget:self action:@selector(didClickSummaryBtn:) forControlEvents:UIControlEventTouchUpInside];
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


-(IBAction)didClickSubmitBtn:(id)sender
{
    NSString *password = [AppCommon GetPassword];
    if ([oldPasswordTF getText].length == 0) {
        [AppCommon showAlertWithMessage:@"Please Enter Old Password"];
    } else if (![oldPasswordTF.text isEqualToString:password]) {
        [AppCommon showAlertWithMessage:@"Please Enter Correct Old Password"];
    } else if ([newwPasswordTF getText].length == 0) {
        [AppCommon showAlertWithMessage:@"Please Enter New Password"];
    } else if ([newwPasswordTF getText].length < 7) {
        [AppCommon showAlertWithMessage:@"New Password should be min 8 digits"];
    } else if ([newwPasswordTF.text isEqualToString:oldPasswordTF.text]) {
        [AppCommon showAlertWithMessage:@"New Password should be different from old Password"];
    } else if ([confirmNewPasswordTF getText].length == 0) {
        [AppCommon showAlertWithMessage:@"Please Enter Confirm Password"];
    } else if (![newwPasswordTF.text isEqualToString:confirmNewPasswordTF.text]) {
        [AppCommon showAlertWithMessage:@"Please Enter Correct Confirm Password"];
    } else {
        /*
         API URL    :   http://192.168.0.154:8029/AGAPTService.svc/INSERTRESETPWDDETAILS
         METHOD     :   POST
         PARAMETER  :   {Clientcode}/{Createdby}/{LoginID}/{NewPassword}/{OldPassword}
         */
        
        NSString *clientCode = [AppCommon GetClientCode];
        NSString *userCode = [AppCommon GetUsercode];
//        NSString *userName = [AppCommon GetUserName];
        NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        
        if(![COMMON isInternetReachable])
            return;
        
        [AppCommon showLoading];
        NSString *URLString =  URL_FOR_RESOURCE(ChangePassword);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        if(clientCode)   [dic    setObject:clientCode     forKey:@"Clientcode"];
        if(userCode)   [dic    setObject:userCode     forKey:@"Createdby"];
        if(userName)   [dic    setObject:userName     forKey:@"LoginID"];
        
        [dic    setObject:oldPasswordTF.text  forKey:@"OldPassword"];
        [dic    setObject:newwPasswordTF.text  forKey:@"NewPassword"];
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if([[responseObject valueForKey:@"Status"] integerValue] == 1)
            {
                NSMutableArray *passwordArray = [responseObject valueForKey:@"lstResetPasswordDetails"];
                for (id key in passwordArray) {
                    NSString *password = [key valueForKey:@"OldPassword"];
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"Password"];
                }
                oldPasswordTF.text = @"";
                newwPasswordTF.text = @"";
                confirmNewPasswordTF.text = @"";
            
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

            UIViewController* newFrontController= [LoginVC new];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
            [navigationController setNavigationBarHidden:YES];
            appDel.frontNavigationController = navigationController;
            [appDel.revealViewController pushFrontViewController:navigationController animated:YES];
            [AppCommon showAlertWithMessage:@"Password Changed Successfully"];
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            [AppCommon hideLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            [AppCommon hideLoading];
        }];
    }
}


    // press return to hide keyboard
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == oldPasswordTF){
        [newwPasswordTF becomeFirstResponder];
    }else if(textField == newwPasswordTF){
        [confirmNewPasswordTF becomeFirstResponder];
    }else if(textField == confirmNewPasswordTF){
        [textField resignFirstResponder];
    }
    return YES;
}

@end
