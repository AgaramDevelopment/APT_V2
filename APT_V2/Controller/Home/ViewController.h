//
//  ViewController.h
//  APT_V2
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
//#import "UITextField+textCode.h"

@interface ViewController : UIViewController

@property (strong,nonatomic) NSString* playerCode;

@property (weak, nonatomic) IBOutlet UITableView *tblAssesments;
//@property (weak, nonatomic) IBOutlet LineTextField *txtModule;
//@property (weak, nonatomic) IBOutlet LineTextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITableView *tblDropDown;
@property (strong, nonatomic) IBOutlet LineTextField *txtModule;
@property (strong, nonatomic) IBOutlet LineTextField *txtTitle;
- (IBAction)actionOpenDate:(id)sender;

@property (strong, nonatomic) IBOutlet UIViewController *popupVC;
@property (weak, nonatomic) IBOutlet UILabel *lblAssessmentName;
@property (weak, nonatomic) IBOutlet UICollectionView *assCollection;
@property (weak, nonatomic) IBOutlet UILabel *lblRangeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblRangeName;
@property (weak, nonatomic) IBOutlet UILabel *lblUnitValue;
@property (weak, nonatomic) IBOutlet UILabel *lblUnitName;
@property (weak, nonatomic) IBOutlet UIButton *btnIgnore;
@property (weak, nonatomic) IBOutlet UITextField *txtRemarks;
@property (weak, nonatomic) IBOutlet UIView *Shadowview;
@property (nonatomic,strong) NSString * selectedPlayerCode;

- (IBAction)actionAssessmentSave:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNOData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;
- (IBAction)actionIgnore:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIViewController *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *dropdownPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerMainView;

- (IBAction)actionCancelDropDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

- (IBAction)actionDoneForNumberPad:(id)sender;
@end


