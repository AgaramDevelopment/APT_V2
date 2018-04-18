//
//  MCTeamPlayersCompCell.h
//  APT_V2
//
//  Created by Apple on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTeamPlayersCompCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UILabel *PlayerName;
@property (strong, nonatomic) IBOutlet UILabel *PlayerRole;
@property (strong, nonatomic) IBOutlet UILabel *PlayerStyle;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UIImageView *PlayerImg;

@end
