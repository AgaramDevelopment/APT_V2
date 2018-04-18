//
//  ScheduleCell.h
//  APT_V2
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *shadowview;
@property (strong, nonatomic) IBOutlet UILabel *eventNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *eventTypelbl;
@property (strong, nonatomic) IBOutlet UILabel *eventTypeLetterlbl;
@property (strong, nonatomic) IBOutlet UILabel *timelbl;
@property (strong, nonatomic) IBOutlet UILabel *venuelbl;
@property (strong, nonatomic) IBOutlet UIImageView *ImgEvent;

@end
