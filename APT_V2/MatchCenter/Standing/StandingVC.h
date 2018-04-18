//
//  StandingVC.h
//  APT_V2
//
//  Created by apple on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandingVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UICollectionView *standingsCollectionView;
@property (strong, nonatomic) IBOutlet UIView *filterView;

@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableWidth;
@property (nonatomic, strong)IBOutlet  NSLayoutConstraint *tableXposition;
@property (nonatomic, strong) IBOutlet UITableView *PoplistTable;
@property (nonatomic, strong) IBOutlet UILabel *yearlbl;
@property (strong, nonatomic) IBOutlet UIView *headderView;


@property (strong, nonatomic) IBOutlet UIView *popTableView;
@property (weak, nonatomic) IBOutlet UIView *viewYear;
@property (weak, nonatomic) IBOutlet UIView *viewCompetetion;
@property (weak, nonatomic) IBOutlet UIView *viewTeam;
@property (weak, nonatomic) IBOutlet UILabel *lblCompetetion;
@property (weak, nonatomic) IBOutlet UILabel *lblTeam;
- (IBAction)actionDropDown:(id)sender;



@end
