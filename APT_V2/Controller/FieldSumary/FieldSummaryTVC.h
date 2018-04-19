//
//  FieldSummaryTVC.h
//  NewSportsProject
//
//  Created by apple on 27/12/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface FieldSummaryHeading : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *headdingLbl;

@end


@interface FieldSummaryDroppedCatches : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *batsmanNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *batsmanTotalScoreLbl;
@property (strong, nonatomic) IBOutlet UILabel *fielderNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *fieldRegionLbl;

@property (strong, nonatomic) IBOutlet UILabel *dropOverLbl;
@property (strong, nonatomic) IBOutlet UILabel * dropRunLbl;
@property (strong, nonatomic) IBOutlet UILabel * dropBowerLbl;
@property (strong, nonatomic) IBOutlet UILabel * dropTeamScoreLbl;

@property (strong, nonatomic) IBOutlet UILabel * dismissOverLbl;
@property (strong, nonatomic) IBOutlet UILabel * dismissRunLbl;
@property (strong, nonatomic) IBOutlet UILabel * dismissPartnerShipLbl;
@property (strong, nonatomic) IBOutlet UILabel * dismissTeamScoreLbl;

@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;

@end

@interface FieldSummaryTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fieldingTypeLbl;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;
@property (strong, nonatomic) IBOutlet UILabel *countLbl;

@end

@interface FieldSummarySubTVC : UIView
@property (strong, nonatomic) IBOutlet UILabel *playerNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *countLbl;
@property (strong, nonatomic) IBOutlet UIButton *clickBtn;

@end

