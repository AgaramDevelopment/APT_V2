//
//  HistoryVC.h
//  APT_V2
//
//  Created by Apple on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblHistory;


@property (nonatomic,strong) IBOutlet UIButton * ModuleBtn;


@property (nonatomic,strong) IBOutlet UIView * v1;
@property (strong, nonatomic) IBOutlet UILabel *moduleLbl;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moduleViewWidth;

@property (weak, nonatomic) IBOutlet UIView *navView;
@property (strong, nonnull) NSString* playerCode;

@end
