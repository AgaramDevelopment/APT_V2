//
//  LandingTableViewCell.m
//  APT_V2
//
//  Created by user on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "LandingTableViewCell.h"
#import "ScheduleCell.h"
#import "ResultCell.h"
#import "TeamCollectionViewCell.h"
#import "FoodDiaryCell.h"

@implementation LandingTableViewCell 
@synthesize collectionArray,collection;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [collection registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    [collection registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellWithReuseIdentifier:@"cellno"];
    [collection registerNib:[UINib nibWithNibName:@"TeamCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TeamCollectionViewCell"];
//    [collection registerNib:[UINib nibWithNibName:@"FoodDiaryCell" bundle:nil] forCellWithReuseIdentifier:@"foodCell"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(id <UICollectionViewDelegate,UICollectionViewDataSource>)delegate andIndex:(NSInteger)indexPath andTitile:(NSString *)title {
    collection.dataSource = delegate;
    collection.delegate = delegate;
    
    if ([title isEqualToString:@"Events"]) {
        [collection setTag:indexPath];
    }
    else if ([title isEqualToString:@"Teams"]) {
        [collection setTag:indexPath];
    }
    else if ([title isEqualToString:@"Fixtures"]) {
        [collection setTag:indexPath];
    }
    else if ([title isEqualToString:@"Results"]) {
        [collection setTag:indexPath];
    }
//    else if ([title isEqualToString:@"Food"]) {
//        [collection setTag:indexPath];
//    }
    else if ([title isEqualToString:@"Videos"]) {
        [collection setTag:indexPath];
    }
    else if ([title isEqualToString:@"Documents"]) {
        [collection setTag:indexPath];
    }
    
    NSLog(@"collectionArray %ld",(long)collection.tag);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collection reloadData];
    });

    
}



@end
