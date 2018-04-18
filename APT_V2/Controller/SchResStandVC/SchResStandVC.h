//
//  SchResStandVC.h
//  APT_V2
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleCell.h"
#import "ResultCell.h"

@protocol openUploadDataSource <NSObject>

-(void)openVideoUploadViewInTabHomeVC:(NSString *)from;

@end


@interface SchResStandVC : UIViewController

@property (strong,nonatomic) id<openUploadDataSource> Delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *scheduleCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *resultCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *eventsCollectionView;

@property (strong, nonatomic) IBOutlet ScheduleCell *objSchedule;
@property (strong, nonatomic) IBOutlet ResultCell *objResult;

@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UIView *commonView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *standingsView;

@property (strong, nonatomic) IBOutlet UIButton *MoreBtn;
@property (strong, nonatomic) IBOutlet UILabel *Nodatalbl;


@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *documentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScrollcontentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewHeight;

@end
