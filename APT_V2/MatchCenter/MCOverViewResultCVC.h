//
//  MCOverViewResultCVC.h
//  APT_V2
//
//  Created by apple on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOverViewResultCVC : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *Teamname1lbl;
@property (strong, nonatomic) IBOutlet UILabel *Teamname2lbl;
@property (strong, nonatomic) IBOutlet UILabel *TeamOvers1lbl;
@property (strong, nonatomic) IBOutlet UILabel *TeamOver2lbl;
@property (strong, nonatomic) IBOutlet UILabel *runs1lbl;
@property (strong, nonatomic) IBOutlet UILabel *runs2lbl;
@property (strong, nonatomic) IBOutlet UILabel *runrate1lbl;
@property (strong, nonatomic) IBOutlet UILabel *runrate2lbl;
@property (strong, nonatomic) IBOutlet UILabel *Datelbl;

@property (strong, nonatomic) IBOutlet UIImageView *team1Img;
@property (strong, nonatomic) IBOutlet UIImageView *team2Img;

@end
