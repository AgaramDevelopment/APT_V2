//
//  ViewController.h
//  APT_V2
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblAssesments;
//@property (weak, nonatomic) IBOutlet LineTextField *txtModule;
//@property (weak, nonatomic) IBOutlet LineTextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITableView *tblDropDown;
@property (weak, nonatomic) IBOutlet LineTextField *txtModule;
@property (weak, nonatomic) IBOutlet LineTextField *txtTitle;

@end

