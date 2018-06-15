//
//  AddWellnessRatingVC.h
//  APT_V2
//
//  Created by Apple on 07/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGSColorSlider.h"
#import "StepSlider.h"
@protocol AddWelnessDelegate <NSObject>

-(void)closeWellnessSource;

@end




@interface AddWellnessRatingVC : UIViewController
@property (strong,nonatomic) id<AddWelnessDelegate> Delegate;

@property (strong, nonatomic) IBOutlet  RGSColorSlider *ColorSlider1;
@property (strong, nonatomic) IBOutlet  RGSColorSlider *ColorSlider2;
@property (strong, nonatomic) IBOutlet  RGSColorSlider *ColorSlider3;
@property (strong, nonatomic) IBOutlet  RGSColorSlider *ColorSlider4;
@property (strong, nonatomic) IBOutlet  StepSlider *step1;


- (IBAction)sliderDidChange:(RGSColorSlider *)sender;

@property (strong,nonatomic) IBOutlet UIView * view_datepicker;
@property (strong,nonatomic) IBOutlet UIView * ViewMain;

@property (strong,nonatomic) IBOutlet UIButton * DateBtn;
@property (strong,nonatomic) IBOutlet UILabel * datelbl;
@property (strong,nonatomic) IBOutlet UITextField * bodyWeightTxt;
@property (strong,nonatomic) IBOutlet UITextField * sleepHrTxt;
@property (strong,nonatomic) IBOutlet UITextField * sleepMinTxt;
@property (strong,nonatomic) IBOutlet UITextField * fatTxt;
@property (strong,nonatomic) IBOutlet UITextField * restingHrTxt;
@property (strong,nonatomic) IBOutlet UITextField * restingBpMaxTxt;
@property (strong,nonatomic) IBOutlet UITextField * restingBpMinTxt;

@property (strong,nonatomic) IBOutlet UIButton * SaveBtn;
@property (strong,nonatomic) IBOutlet UIButton * UpdateBtn;

@property (strong,nonatomic) IBOutlet UILabel * SleepRatinglbl;
@property (strong,nonatomic) IBOutlet UILabel * FatiqueRatinglbl;
@property (strong,nonatomic) IBOutlet UILabel * MuscleRatinglbl;
@property (strong,nonatomic) IBOutlet UILabel * StressRatinglbl;
@property (strong,nonatomic) IBOutlet UILabel * UrineRatinglbl;

@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn1;
@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn2;
@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn3;
@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn4;
@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn5;
@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn6;
@property (strong,nonatomic) IBOutlet UIButton * UrineColorBtn7;

@property (strong,nonatomic)  NSMutableArray * fetchArray;
@property (strong,nonatomic)  NSString * isFetch;
@property (strong,nonatomic)  NSString * isFromHome;

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeight;

@property (strong, nonatomic) IBOutlet UIButton *CancelBtn;
@property (strong, nonatomic) IBOutlet UIImageView *CancelImg;

@end
