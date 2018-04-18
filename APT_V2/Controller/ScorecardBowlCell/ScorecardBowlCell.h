//
//  ScorecardBowlCell.h
//  NewSportsProject
//
//  Created by Mac on 13/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScorecardBowlCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView * WagonImg;

@property (nonatomic,strong) IBOutlet UIImageView * PitchImg;

@property (nonatomic,strong) IBOutlet UIView * topview;


@property (nonatomic,strong) IBOutlet UILabel * bowelernamelbl;
@property (nonatomic,strong) IBOutlet UILabel * overslbl;
@property (nonatomic,strong) IBOutlet UILabel * runslbl;
@property (nonatomic,strong) IBOutlet UILabel * wicketslbl;
@property (nonatomic,strong) IBOutlet UILabel * economylbl;
@property (nonatomic,strong) IBOutlet UILabel * dotballslbl;


@property (nonatomic,strong) IBOutlet UIButton * onesBtn;
@property (nonatomic,strong) IBOutlet UIButton * twoBtn;
@property (nonatomic,strong) IBOutlet UIButton * threeBtn;
@property (nonatomic,strong) IBOutlet UIButton * fourBtn;
@property (nonatomic,strong) IBOutlet UIButton * sixBtn;
@property (nonatomic,strong) IBOutlet UIButton * dotBtn;
@property (nonatomic,strong) IBOutlet UIButton * wktBtn;
@property (nonatomic,strong) IBOutlet UIButton * alllbl;

@property (nonatomic,strong) IBOutlet UIButton * runSBtn;
@property (nonatomic,strong) IBOutlet UIButton * oversBtn;
@property (nonatomic,strong) IBOutlet UIButton * wicketsBtn;
@property (nonatomic,strong) IBOutlet UIButton * dotsBtn;


@end
