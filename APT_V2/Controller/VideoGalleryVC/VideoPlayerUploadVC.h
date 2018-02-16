//
//  VideoPlayerUploadVC.h
//  APT_V2
//
//  Created by Apple on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface VideoPlayerUploadVC : UIViewController

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

@property (weak, nonatomic) IBOutlet UIView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *currentlySelectedImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgViewBottomConst;

@end
