//
//  IllnessTracker.h
//  APT_V2
//
//  Created by MAC on 26/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllnessTracker : UIViewController
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITextField *expectedDateTF;
@property (strong, nonatomic) IBOutlet UITextField *onsetDateTF;
@property (strong, nonatomic) IBOutlet UITextField *illnessNameTF;
@property (strong, nonatomic) IBOutlet UITextField *chiefCompliantTF;
@property (strong, nonatomic) IBOutlet UITextField *affectSystemTF;
@property (strong, nonatomic) IBOutlet UITextField *mainSymptomTF;
@property (strong, nonatomic) IBOutlet UITextField *causeOfIllnessTF;
@property (strong, nonatomic) IBOutlet UIButton *expertYesBtn;
@property (strong, nonatomic) IBOutlet UIButton *expertNoBtn;

@property (strong, nonatomic) IBOutlet UIView *illnessNameView;
@property (strong, nonatomic) IBOutlet UIView *chiefCompliantView;
@property (strong, nonatomic) IBOutlet UIView *affectSystemView;
@property (strong, nonatomic) IBOutlet UIView *mainSymptomView;
@property (strong, nonatomic) IBOutlet UIView *causeIllnessView;
@property (strong, nonatomic) IBOutlet UIView *investigationsUploadView;


@property (strong, nonatomic) IBOutlet UIView *filePopView;

@property (strong, nonatomic) IBOutlet UIButton *affectSystemBtn;
@property (strong, nonatomic) IBOutlet UIButton *mainSymptomBtn;
@property (strong, nonatomic) IBOutlet UIButton *causeBtn;

@property (nonatomic,assign)  BOOL isUpdate;
@property (nonatomic,strong) NSMutableArray * objSelectobjIllnessArray;

@property (strong, nonatomic) IBOutlet UILabel *xrayLbl;
@property (strong, nonatomic) IBOutlet UILabel *CTScanLbl;
@property (strong, nonatomic) IBOutlet UILabel *MRILbl;
@property (strong, nonatomic) IBOutlet UILabel *BloodTestLbl;

@property (strong, nonatomic) IBOutlet UIButton *updateBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic) IBOutlet UIImageView *xRayImageView;

//Properties for Files Buttons
@property (strong, nonatomic) IBOutlet UIButton *xRayBtn;
@property (strong, nonatomic) IBOutlet UIButton *ctScanBtn;
@property (strong, nonatomic) IBOutlet UIButton *mriBtn;
@property (strong, nonatomic) IBOutlet UIButton *bloodTestBtn;
@end
