//
//  FoodDiaryUpdateVC.h
//  APT_V2
//
//  Created by MAC on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDiaryUpdateVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *navi_View;
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
@property (strong, nonatomic) IBOutlet UIButton *saveOrUpdateBtn;

@property(strong, nonatomic) IBOutlet NSString *mealTypeTF;
@property(strong, nonatomic) IBOutlet NSString *locationTF;
@property (nonatomic, strong) NSArray *searchResult;
@property(strong, nonatomic) IBOutlet NSString *foodDiaryType;
@property(strong, nonatomic) IBOutlet NSMutableArray *foodDiaryArray;
@property(strong, nonatomic) IBOutlet NSIndexPath *selectedIndexPath;
@property(strong, nonatomic) IBOutlet NSIndexPath *foodIndexPath;

@end
