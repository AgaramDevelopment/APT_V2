//
//  VideoPlayerUploadVC.h
//  APT_V2
//
//  Created by Apple on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol videoUploadDelegate

-(void) removeImagePicker;

@end


@interface VideoPlayerUploadVC : UIViewController

@property(nonatomic,strong) id<videoUploadDelegate>delegate;


@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIView *teamView;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) IBOutlet UIView *videoDateView;
@property (strong, nonatomic) IBOutlet UIView *CategoryView;

@property (strong, nonatomic) IBOutlet UIView *sharetoUserView;
@property (strong, nonatomic) IBOutlet UIView *keywordsView;

@property (nonatomic,strong) IBOutlet UILabel * date_lbl;
@property (nonatomic,strong) IBOutlet UILabel * player_lbl;
@property (nonatomic,strong) IBOutlet UILabel * category_lbl;
@property (nonatomic,strong) IBOutlet UILabel * shareuser_lbl;
@property (nonatomic,strong) IBOutlet UILabel * module_lbl;

@property (strong, nonatomic) IBOutlet UIView *imgView;
@property (strong, nonatomic) IBOutlet UIImageView *currentlySelectedImage;
@property (strong,nonatomic) IBOutlet UIView * commonView;
@property (nonatomic,strong) IBOutlet UITextField * objKeyword_Txt;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgViewBottomConst;

@property (strong, nonatomic) IBOutlet UIView *datepickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtVideoDate;
- (IBAction)didClickType:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *teamBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic,strong) NSString * titleString;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCloud;
@end
