//
//  TabHomeCell.h
//  APT_V2
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabHomeCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIView *selectedLineView;

@end
