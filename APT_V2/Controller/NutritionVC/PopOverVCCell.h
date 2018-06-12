//
//  PopOverVCCell.h
//  APT_V2
//
//  Created by MAC on 30/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverVCCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notificationCountLbl;
@property (strong, nonatomic) IBOutlet UILabel *notificationTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *notificationDescrLbl;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;

@end
