//
//  HomeScreenStandingsCell.h
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenStandingsCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *rankLbl;
@property (strong, nonatomic) IBOutlet UILabel *teamLbl;
@property (strong, nonatomic) IBOutlet UILabel *playedLbl;
@property (strong, nonatomic) IBOutlet UILabel *wonLbl;
@property (strong, nonatomic) IBOutlet UILabel *lostLbl;
@property (strong, nonatomic) IBOutlet UILabel *nrrLbl;
@property (strong, nonatomic) IBOutlet UILabel *pointsLbl;
@property (weak, nonatomic) IBOutlet UILabel *tiedLbl;
@property (weak, nonatomic) IBOutlet UILabel *NRLbl;

@end
