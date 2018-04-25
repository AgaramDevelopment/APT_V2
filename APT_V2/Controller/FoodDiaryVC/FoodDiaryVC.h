//
//  FoodDiaryVC.h
//  APT_V2
//
//  Created by MAC on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodDiaryCell.h"

@interface FoodDiaryVC : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *foodDiaryCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UITextField *dateTF;
@property (strong, nonatomic) IBOutlet UITextField *timeTF;
@property (strong, nonatomic) IBOutlet UITextField *foodItemTF;
@property (strong, nonatomic) IBOutlet UITextField *quantityTF;
@property (strong, nonatomic) IBOutlet UITableView *foodTableView;

@property (strong, nonatomic) IBOutlet UIButton *breakfastBtn;
@property (strong, nonatomic) IBOutlet UIButton *snacksBtn;
@property (strong, nonatomic) IBOutlet UIButton *lunchBtn;
@property (strong, nonatomic) IBOutlet UIButton *dinnerBtn;
@property (strong, nonatomic) IBOutlet UIButton *supplementsBtn;

@property (strong, nonatomic) IBOutlet UIButton *teamBtn;
@property (strong, nonatomic) IBOutlet UIButton *restaurantBtn;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;
@property (strong, nonatomic) IBOutlet UIButton *otherBtn;
@property(strong, nonatomic) IBOutlet NSString *mealTypeTF;
@property(strong, nonatomic) IBOutlet NSString *locationTF;
@property (strong, nonatomic) IBOutlet UIView *navi_View;
@property (strong, nonatomic) IBOutlet UIButton *saveOrUpdateBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblNoData;

@end
