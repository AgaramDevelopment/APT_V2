//
//  RecentFitnessGraph.h
//  APT_V2
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface RecentFitnessGraph : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *Poptable;

@property (nonatomic, strong) IBOutlet UIView *dateView;
@property (nonatomic, strong) IBOutlet UIView *barView;
@property (nonatomic, strong) IBOutlet UIView *lineView;

@property (nonatomic, strong) IBOutlet UILabel *datelbl;
@property (nonatomic, strong) IBOutlet UILabel *barlbl;
@property (nonatomic, strong) IBOutlet UILabel *linelbl;
@property (strong, nonatomic)  NSString *selectionBaseKey;




@end
