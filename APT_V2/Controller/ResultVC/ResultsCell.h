//
//  ResultsCell.h
//  NewSportsProject
//
//  Created by Mac on 18/11/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel * date;
@property (nonatomic,strong) IBOutlet UILabel * time;
@property (nonatomic,strong) IBOutlet UILabel * team1;
@property (nonatomic,strong) IBOutlet UILabel * team2;
@property (nonatomic,strong) IBOutlet UILabel * firstInn;
@property (nonatomic,strong) IBOutlet UILabel * secondInn;
@property (nonatomic,strong) IBOutlet UILabel * thirdInn;
@property (nonatomic,strong) IBOutlet UILabel * fourthInn;
@property (nonatomic,strong) IBOutlet UILabel * resultDetails;

@property (nonatomic,strong) IBOutlet UIImageView * team1Img;
@property (nonatomic,strong) IBOutlet UIImageView * team2Img;


@end
