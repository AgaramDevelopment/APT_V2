//
//  LandingViewController.h
//  APT_V2
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *LandingTable;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *BowlingUIView;
@property (weak, nonatomic) IBOutlet UIView *WellnessUIView;
@property (strong, nonatomic) IBOutlet UIView *FoodDiaryUIView;
@property (weak, nonatomic) IBOutlet UIView *ResultsUIView;
@property (weak, nonatomic) IBOutlet UIView *VideosUIView;
@property (strong, nonatomic) IBOutlet UIView *DocumentsUIView;
@property (weak, nonatomic) IBOutlet UIView *EventsUIView;
@property (weak, nonatomic) IBOutlet UIView *FixturesUIView;
@property (strong, nonatomic) IBOutlet UIView *TeamsUIView;


@property (strong, nonatomic) IBOutlet UIButton *BowlingMonthlyBtn;
@property (strong, nonatomic) IBOutlet UIButton *BowlingWeeklyBtn;
@property (strong, nonatomic) IBOutlet UIButton *BowlingDailyBtn;



@property (strong, nonatomic) IBOutlet UILabel *bodyWeightlbl;
@property (strong, nonatomic) IBOutlet UILabel *sleepHrlbl;
@property (strong, nonatomic) IBOutlet UILabel *ratinglbl;

@property (strong, nonatomic) IBOutlet UILabel *sleeplbl;
@property (strong, nonatomic) IBOutlet UILabel *fatiquelbl;
@property (strong, nonatomic) IBOutlet UILabel *musclelbl;
@property (strong, nonatomic) IBOutlet UILabel *stresslbl;

@property (strong, nonatomic) IBOutlet UIView *SleepColorView;
@property (strong, nonatomic) IBOutlet UIView *FatiqueColorView;
@property (strong, nonatomic) IBOutlet UIView *MuscleColorView;
@property (strong, nonatomic) IBOutlet UIView *StressColorView;
@property (weak, nonatomic) IBOutlet UIView *NoDataView;

//Food Diary Properties
@property (strong, nonatomic) IBOutlet UICollectionView *foodDiaryCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *ResultsCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *VideosCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *DocumentsCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *EventsCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *FixturesCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *TeamsCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblNoData;



@end


