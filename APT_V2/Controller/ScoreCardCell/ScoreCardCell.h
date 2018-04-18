//
//  ScoreCardCell.h
//  NewSportsProject
//
//  Created by Mac on 01/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCardCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel * CL1;
@property (nonatomic,strong) IBOutlet UILabel * CL2;
@property (nonatomic,strong) IBOutlet UIButton * onesBtn;
@property (nonatomic,strong) IBOutlet UIButton * twoBtn;
@property (nonatomic,strong) IBOutlet UIButton * threeBtn;
@property (nonatomic,strong) IBOutlet UIButton * fourBtn;
@property (nonatomic,strong) IBOutlet UIButton * sixBtn;
@property (nonatomic,strong) IBOutlet UIButton * dotBtn;
@property (nonatomic,strong) IBOutlet UIButton * wktBtn;
@property (nonatomic,strong) IBOutlet UIButton * alllbl;

@property (nonatomic,strong) IBOutlet UIImageView * WagonImg;

@property (nonatomic,strong) IBOutlet UIImageView * PitchImg;

@property (nonatomic,strong) IBOutlet UIView * topview;


@property (nonatomic,strong) IBOutlet UILabel * playerNamelbl;
@property (nonatomic,strong) IBOutlet UILabel * runslbl;
@property (nonatomic,strong) IBOutlet UILabel * ballslbl;
@property (nonatomic,strong) IBOutlet UILabel * fourslbl;
@property (nonatomic,strong) IBOutlet UILabel * sixeslbl;
@property (nonatomic,strong) IBOutlet UILabel * strikelbl;
@property (nonatomic,strong) IBOutlet UILabel * wktDesclbl;
@property (nonatomic,strong) IBOutlet UILabel * dotballslbl;


@property (nonatomic,strong) IBOutlet UIButton * runsBtn;
@property (nonatomic,strong) IBOutlet UIButton * ballsBtn;
@property (nonatomic,strong) IBOutlet UIButton * foursBtn;
@property (nonatomic,strong) IBOutlet UIButton * sixesBtn;
@property (nonatomic,strong) IBOutlet UIButton * dotsBtn;
@property (nonatomic,strong) IBOutlet UIButton * wktsBtn;




@end
