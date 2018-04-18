//
//  TeamMemebersCell.h
//  APT_V2
//
//  Created by Apple on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemebersCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *shadowview;
@property (strong, nonatomic) IBOutlet UILabel *playernamelbl;
@property (strong, nonatomic) IBOutlet UILabel *BowlingStylelbl;
@property (strong, nonatomic) IBOutlet UILabel *BattingStylelbl;
@property (strong, nonatomic) IBOutlet UILabel *agelbl;
@property (strong, nonatomic) IBOutlet UIView *availabilityView;
@property (weak, nonatomic) IBOutlet UIImageView *playerImg;

@end
