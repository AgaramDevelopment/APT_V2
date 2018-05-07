//
//  LoginVC.h
//  AlphaProTracker
//
//  Created by Lexicon on 22/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
@property (nonatomic,strong)IBOutlet UISwitch *swt;

@property (weak, nonatomic) IBOutlet UILabel *lblAppVersion;
@property (nonatomic,strong)IBOutlet UIImageView *securityImage;
@property (weak, nonatomic) IBOutlet UIView *teamview;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRight;
@end
