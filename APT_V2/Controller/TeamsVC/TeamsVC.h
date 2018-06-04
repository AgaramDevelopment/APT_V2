//
//  TeamsVC.h
//  APT_V2
//
//  Created by Apple on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileVCCell.h"

@interface TeamsVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *navi_View;
@property (strong, nonatomic) IBOutlet UITableView *teamsTable;
@property (nonatomic,strong) IBOutlet ProfileVCCell *objProfilecell;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@end
