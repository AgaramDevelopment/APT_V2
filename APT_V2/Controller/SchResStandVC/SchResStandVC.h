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

@interface SchResStandVC : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *scheduleCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *resultCollectionView;

@property (strong, nonatomic) IBOutlet ScheduleCell *objSchedule;
@property (strong, nonatomic) IBOutlet ResultCell *objResult;

@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UIView *commonView;


@property (strong, nonatomic) IBOutlet UIScrollView *scroll;


@end