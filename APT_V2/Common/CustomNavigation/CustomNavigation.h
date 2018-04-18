//
//  CustomNavigation.h
//  AlphaProTracker
//
//  Created by Mac on 22/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "Config.h"

@interface CustomNavigation : UIViewController

@property (nonatomic,strong) IBOutlet UIView * common_view;
@property (nonatomic,strong) IBOutlet UILabel * tittle_lbl;
@property (nonatomic,strong) IBOutlet UIButton * btn_back;
@property (nonatomic,strong) IBOutlet UIImageView * nav_header_img;
@property (nonatomic,strong) IBOutlet UIButton * cartBtn;
@property (nonatomic,strong) IBOutlet UIButton * ticketBtn;
@property (nonatomic,strong) IBOutlet UIButton * menu_btn;
@property (nonatomic,strong) IBOutlet UIButton * home_btn;
@property (strong, nonatomic) IBOutlet UIButton *notificationBtn;
@property (strong, nonatomic) IBOutlet UILabel *notificationCountLbl;
@property (strong, nonatomic) IBOutlet UIView *notificationView;

@end
