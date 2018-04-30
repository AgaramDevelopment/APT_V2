//
//  HomeScreenStandingsVC.h
//  APT_V2
//
//  Created by MAC on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenStandingsVC : UIViewController
{
    NSMutableArray *rankArray;
    NSMutableArray *teamArray;
    NSMutableArray *playedArray;
    NSMutableArray *wonArray;
    NSMutableArray *lostArray;
    NSMutableArray *nrrArray;
    NSMutableArray *pointsArray;
}
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UITableView *standingsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblHeight;

@end
