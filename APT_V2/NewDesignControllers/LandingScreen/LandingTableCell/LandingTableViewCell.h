//
//  LandingTableViewCell.h
//  APT_V2
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSectionTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSectionHead;
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIView *customView;

@property (strong, nonnull) NSMutableDictionary* collectionArray;


-(void)configureCell:(id <UICollectionViewDelegate,UICollectionViewDataSource>)delegate andIndex:(NSInteger)indexPath andTitile:(NSString *)title;
@end
