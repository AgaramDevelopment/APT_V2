//
//  BowlTypeCell.h
//  APT_V2
//
//  Created by Apple on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BowlTypeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bowlingStyleLbl;
@property (strong, nonatomic) IBOutlet UILabel *wicketsLbl;
@property (strong, nonatomic) IBOutlet UILabel *economyLbl;
@property (strong, nonatomic) IBOutlet UILabel *avgLbl;
@property (strong, nonatomic) IBOutlet UILabel *strikeRateLbl;
@property (strong, nonatomic) IBOutlet UILabel *dotBallsPercentLbl;
@property (strong, nonatomic) IBOutlet UILabel *boundaryPercentLbl;

@end
