//
//  ExcierseDetailVC.h
//  AlphaProTracker
//
//  Created by apple on 16/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExcerciseAttachmentCVC.h"
#import "ExcerciseParameterTVC.h"

@interface ExcierseDetailVC : UIViewController  
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet ExcerciseAttachmentCVC *attachmentCVC;
@property (strong, nonatomic) IBOutlet UICollectionView *imageCView;
@property (strong, nonatomic) IBOutlet UICollectionView *videoCView;
@property (strong, nonatomic) IBOutlet UICollectionView *docuCView;
@property (strong, nonatomic) IBOutlet ExcerciseParameterTVC *paramTVC;
@property (strong, nonatomic) IBOutlet UITableViewCell *paramHeaderTVC;
@property (strong, nonatomic) IBOutlet UITableView *paramTView;
@property (strong, nonatomic) IBOutlet UIView *imageContainerView;
@property (strong, nonatomic) IBOutlet UIView *videoContainerView;
@property (strong, nonatomic) IBOutlet UIView *documentContainerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *instructionLblHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *paramTblViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rootViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *attImageHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *attDocmHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *attVideoHeight;
@property (strong, nonatomic) IBOutlet UILabel *instructionLbl;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *instructionLblHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgViewContainerTop;

@property (nonatomic,strong)  NSString * ExcerciseCode;
@property (nonatomic,strong)  NSString * ProgramCode;
@property (nonatomic,strong)  NSString * OrderNo;


@end
