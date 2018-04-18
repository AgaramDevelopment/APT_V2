//
//  TeamMembersVC.h
//  APT_V2
//
//  Created by MAC on 12/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface TeamMembersVC : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *playesTable;
@property (strong, nonatomic) IBOutlet UILabel *TeamNamelbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic)  NSString *teamCode;
@property (strong, nonatomic)  NSString *teamname;

@property (strong, nonatomic) IBOutlet UIButton *AllBtn;
@property (strong, nonatomic) IBOutlet UIButton *BatsmanBtn;
@property (strong, nonatomic) IBOutlet UIButton *WktKeeperBtn;
@property (strong, nonatomic) IBOutlet UIButton *AllrounderBtn;
@property (strong, nonatomic) IBOutlet UIButton *BowlerBtn;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;
@property (weak, nonatomic) IBOutlet UIView *filterContainerView;


@end
