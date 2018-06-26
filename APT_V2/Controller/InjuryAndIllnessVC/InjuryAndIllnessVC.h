//
//  InjuryAndIllnessVC.h
//  APT_V2
//
//  Created by MAC on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InjuryAndIllnessVC : UIViewController {
    NSMutableArray *injuryArray;
    NSMutableArray *illnessArray;
}
@property (strong, nonatomic) IBOutlet UITableView *injuryTableView;
@property (strong, nonatomic) IBOutlet UITableView *illnessTableView;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoInjuryData;
@property (strong, nonatomic) IBOutlet UILabel *lblNoIllnessData;
@property (strong, readwrite) NSString* TeamCode;
@end
