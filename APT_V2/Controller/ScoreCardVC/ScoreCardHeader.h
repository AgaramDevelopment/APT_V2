//
//  ScoreCardHeader.h
//  APT_V2
//
//  Created by Apple on 17/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCardHeader : UIViewController


@property (nonatomic,strong) NSMutableArray * matchDetailsArray;

@property (nonatomic,strong) IBOutlet UILabel * competitionTypelbl;
@property (nonatomic,strong) IBOutlet UILabel * groundlbl;
@property (nonatomic,strong) IBOutlet UILabel * teamAlbl;
@property (nonatomic,strong) IBOutlet UILabel * teamBlbl;
@property (nonatomic,strong) IBOutlet UILabel * teamAScorelbl;
@property (nonatomic,strong) IBOutlet UILabel * teamBScorelbl;
@property (nonatomic,strong) IBOutlet UILabel * teamAinn2Scorelbl;
@property (nonatomic,strong) IBOutlet UILabel * teamBinn2Scorelbl;
@property (nonatomic,strong) IBOutlet UILabel * resultlbl;


@property (nonatomic,strong) IBOutlet UIImageView * teamAlogo;
@property (nonatomic,strong) IBOutlet UIImageView * teamBlogo;
@end
