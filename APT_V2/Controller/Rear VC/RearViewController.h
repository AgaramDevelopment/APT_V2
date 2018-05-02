//
//  RearViewController.h
//  APT_V2
//
//  Created by user on 03/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RearViewController : UIViewController
@property (strong, nonatomic) NSArray* arrItems;




@property (weak, nonatomic) IBOutlet UITableView *RearTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblimgBackground;

@end
