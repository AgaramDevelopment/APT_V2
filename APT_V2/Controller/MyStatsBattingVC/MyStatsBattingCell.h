//
//  MyStatsBattingCell.h
//  APT_V2
//
//  Created by MAC on 07/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStatsBattingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreViewHeight;

@end