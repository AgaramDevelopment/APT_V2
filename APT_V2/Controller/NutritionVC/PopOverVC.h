//
//  PopOverVC.h
//  APT_V2
//
//  Created by MAC on 22/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverVC : UIViewController

@property (nonatomic, strong)NSMutableArray *listArray;
@property (strong, nonatomic) IBOutlet UITableView *popOverTableView;
@property (strong, nonatomic) NSString *notificationsCount;
@property (strong, nonatomic) IBOutlet UILabel *noNotificationLabel;

@end
