//
//  MyStatsBattingCell.h
//  APT_V2
//
//  Created by MAC on 07/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStatsBattingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreViewHeight;

//OverAll Reference Properties For Headers
@property (strong, nonatomic) IBOutlet UILabel *matchNmatchLbl;
@property (strong, nonatomic) IBOutlet UILabel *inningsNinningsLbl;
@property (strong, nonatomic) IBOutlet UILabel *noNoversLbl;
@property (strong, nonatomic) IBOutlet UILabel *runsNwicketsLbl;
@property (strong, nonatomic) IBOutlet UILabel *ballsNrunsLbl;
@property (strong, nonatomic) IBOutlet UILabel *avgNecoLbl;
@property (strong, nonatomic) IBOutlet UILabel *srNavgLbl;
@property (strong, nonatomic) IBOutlet UILabel *hundredsNsrLbl;
@property (strong, nonatomic) IBOutlet UILabel *fiftiesNthreewLbl;
@property (strong, nonatomic) IBOutlet UILabel *thirtiesNfivewLbl;
@property (strong, nonatomic) IBOutlet UILabel *foursNbbiLbl;
@property (strong, nonatomic) IBOutlet UILabel *sixsNwideLbl;
@property (strong, nonatomic) IBOutlet UILabel *bdyNnoBallLbl;
@property (strong, nonatomic) IBOutlet UILabel *dotNdbLbl;
@property (strong, nonatomic) IBOutlet UILabel *hsNbdryLbl;




//OverAll Reference Properties
@property (strong, nonatomic) IBOutlet UILabel *overallMatchesLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallInningsLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallNOLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallRunsLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallBallsLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallAvgLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallSRLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallHundredsLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallFiftiesLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallThirtiesLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallFoursLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallSixsLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallBDYPercentLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallDotPercentLbl;
@property (strong, nonatomic) IBOutlet UILabel *overallHSLbl;

//Recent Match Reference Properties


@property (weak, nonatomic) IBOutlet UILabel *teamNameiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamNameiPadLbl;
@property (weak, nonatomic) IBOutlet UIImageView *teamiPhoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *teamiPadImage;
@property (weak, nonatomic) IBOutlet UILabel *teamRunsiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamRunsiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamBallsiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *teamBallsiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchDateiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchDateiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *groundNameiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *groundNameiPadLbl;



@property (weak, nonatomic) IBOutlet UILabel *matchSRiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchSRiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchDotiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchDotiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchBDYiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchBDYiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchFoursiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchFoursiPadLbl;

@property (weak, nonatomic) IBOutlet UILabel *matchSixsiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchSixsiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchBDYFqiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchBDYFqiPadLbl;

@property (weak, nonatomic) IBOutlet UIImageView *dropDowniPhoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *dropDowniPadImage;
@property (weak, nonatomic) IBOutlet UIButton *dropDowniPadBtn;
@property (weak, nonatomic) IBOutlet UIButton *dropDowniPhoneBtn;

@property (nonatomic,strong) IBOutlet UIButton * onesBtniPhone;
@property (nonatomic,strong) IBOutlet UIButton * twoBtniPhone;
@property (nonatomic,strong) IBOutlet UIButton * threeBtniPhone;
@property (nonatomic,strong) IBOutlet UIButton * fourBtniPhone;
@property (nonatomic,strong) IBOutlet UIButton * sixBtniPhone;
@property (nonatomic, strong) IBOutlet UIButton *dotBtniPhone;
@property (nonatomic, strong) IBOutlet UIButton *wktBtniPhone;
@property (nonatomic,strong) IBOutlet UIButton * alllbliPhone;

@property (nonatomic,strong) IBOutlet UIButton * onesBtniPad;
@property (nonatomic,strong) IBOutlet UIButton * twoBtniPad;
@property (nonatomic,strong) IBOutlet UIButton * threeBtniPad;
@property (nonatomic,strong) IBOutlet UIButton * fourBtniPad;
@property (nonatomic,strong) IBOutlet UIButton * sixBtniPad;
@property (nonatomic, strong) IBOutlet UIButton *dotBtniPad;
@property (nonatomic, strong) IBOutlet UIButton *wktBtniPad;
@property (nonatomic,strong) IBOutlet UIButton * alllbliPad;

@property (nonatomic,strong) IBOutlet UIImageView * WagonImgiPhone;

@property (nonatomic,strong) IBOutlet UIImageView * PitchImgiPhone;

@property (nonatomic,strong) IBOutlet UIImageView * WagonImgiPad;

@property (nonatomic,strong) IBOutlet UIImageView * PitchImgiPad;

//Recent Matches Reference Properties For iPhone Headers
@property (weak, nonatomic) IBOutlet UILabel *srNecoiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *dotNnbiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *bdyNwdiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *foursNfoursiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *sixsNsixsiPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *bdyFeqNdbiPhoneLbl;




//Recent Matches Reference Properties For iPad Headers
@property (weak, nonatomic) IBOutlet UILabel *srNecoiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *dotNnbiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *bdyNwdiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *foursNfoursiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *sixsNsixsiPadLbl;
@property (weak, nonatomic) IBOutlet UILabel *bdyFeqNdbiPadLbl;

@end
