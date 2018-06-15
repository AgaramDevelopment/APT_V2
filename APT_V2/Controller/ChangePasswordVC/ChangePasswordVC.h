//
//  ChangePasswordVC.h
//  APT_V2
//
//  Created by Apple on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@protocol passwordChangedNotification <NSObject>

-(void)notifyPasswordChanged;

@end


@interface ChangePasswordVC : UIViewController<UITextFieldDelegate> {

    IBOutlet CustomTextField *oldPasswordTF;
    IBOutlet CustomTextField *newwPasswordTF;
    IBOutlet CustomTextField *confirmNewPasswordTF;
    
}

@property (strong, nonatomic) id<passwordChangedNotification> passwordDelegate;
@property (strong, nonatomic) IBOutlet UIView *navi_View;

@end

