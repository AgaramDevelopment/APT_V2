//
//  MCOverViewVC.h
//  APT_V2
//
//  Created by apple on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOverViewVC : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *resultCollectionView;

@property (strong, nonatomic) IBOutlet UITableView *CompetitionListtbl;
@property (strong, nonatomic) IBOutlet UIView *popTableView;
@property (strong, nonatomic) IBOutlet UILabel *competitionlbl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIView *NodataView;

@property (strong, nonatomic) IBOutlet UILabel *Teamnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *Groundmnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *Captainnamelbl;
@property (strong, nonatomic) IBOutlet UIImageView *TeamImgView;



@property (strong, nonatomic) IBOutlet UILabel *PlayerTypelbl;
@property (strong, nonatomic) IBOutlet UIButton *prevBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

@property (strong, nonatomic) IBOutlet UIImageView *Player1Img;
@property (strong, nonatomic) IBOutlet UILabel *Player1Namelbl;
@property (strong, nonatomic) IBOutlet UILabel *Player1Countlbl;
@property (strong, nonatomic) IBOutlet UILabel *Player1SRlbl;

@property (strong, nonatomic) IBOutlet UILabel *Player2Namelbl;
@property (strong, nonatomic) IBOutlet UILabel *Player2Countlbl;
@property (strong, nonatomic) IBOutlet UILabel *Player2SRlbl;

@property (strong, nonatomic) IBOutlet UILabel *Player3Namelbl;
@property (strong, nonatomic) IBOutlet UILabel *Player3Countlbl;
@property (strong, nonatomic) IBOutlet UILabel *Player3SRlbl;

@property (strong, nonatomic) IBOutlet UILabel *Player4Namelbl;
@property (strong, nonatomic) IBOutlet UILabel *Player4Countlbl;
@property (strong, nonatomic) IBOutlet UILabel *Player4SRlbl;

@property (strong, nonatomic) IBOutlet UILabel *Player5Namelbl;
@property (strong, nonatomic) IBOutlet UILabel *Player5Countlbl;
@property (strong, nonatomic) IBOutlet UILabel *Player5SRlbl;


@property (weak, nonatomic) IBOutlet UIView *dropviewComp;
@property (strong, nonatomic) IBOutlet UILabel *TotalMatcheslbl;
@property (strong, nonatomic) IBOutlet UILabel *winLosslbl;
@property (strong, nonatomic) IBOutlet UILabel *winLossCountlbl;
@property (strong, nonatomic) IBOutlet UILabel *Forlbl;
@property (strong, nonatomic) IBOutlet UILabel *ForCountlbl;
@property (strong, nonatomic) IBOutlet UILabel *Againstlbl;
@property (strong, nonatomic) IBOutlet UILabel *AgainstCountlbl;
@property (strong, nonatomic) IBOutlet UILabel *nrrlbl;
@property (strong, nonatomic) IBOutlet UILabel *Wktslbl;
@property (weak, nonatomic) IBOutlet UIView *viewCompetetion;
@property (weak, nonatomic) IBOutlet UILabel *lblCompetetion;
@property (weak, nonatomic) IBOutlet UILabel *teamlbl;

@property (weak, nonatomic) IBOutlet UIView *viewTeam;
@property (weak, nonatomic) IBOutlet UILabel *lblTeamName;

@property (strong, nonatomic) IBOutlet UIView *competView;
@property (strong, nonatomic) IBOutlet UIView *teamView;


@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableYposition;


@end
