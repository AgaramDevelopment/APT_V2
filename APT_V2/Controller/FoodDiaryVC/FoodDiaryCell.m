//
//  FoodDiaryCell.m
//  APT_V2
//
//  Created by MAC on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "FoodDiaryCell.h"

@implementation FoodDiaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mealNameLbl.layer.cornerRadius = 5;
    self.mealNameLbl.layer.masksToBounds = YES;
}

@end
