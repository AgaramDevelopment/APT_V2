//
//  ScheduleVC.m
//  APT_V2
//
//  Created by MAC on 06/07/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "ScheduleVC.h"
#import "CustomNavigation.h"


@interface ScheduleVC () {
    UIDatePicker * datePicker;
    NSMutableArray *selectedSchedArray;
    NSMutableArray *planArray;
    NSMutableArray *selectedSavedArray;
}

@end

@implementation ScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selectedSchedArray = [NSMutableArray new];
        //UIDatePicker
    datePicker = [[UIDatePicker alloc] init];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
        //create left side empty space so that done button set on right side
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style: UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    NSMutableArray *toolbarArray = [NSMutableArray new];
    [toolbarArray addObject:cancelBtn];
    [toolbarArray addObject:flexSpace];
    [toolbarArray addObject:doneBtn];
    
    [toolbar setItems:toolbarArray animated:false];
    [toolbar sizeToFit];
    
        //setting toolbar as inputAccessoryView
    self.timeTF.inputAccessoryView = toolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation *objCustomNavigation=[CustomNavigation new];
    [self.navigationView addSubview:objCustomNavigation.view];
        //    objCustomNavigation.tittle_lbl.text=@"";
    objCustomNavigation.btn_back.hidden =NO;
    objCustomNavigation.menu_btn.hidden =YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionBack
{
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
}

-(void) cancelButtonAction {
    
    self.timeTF.text = @"";
    [self.timeTF resignFirstResponder];
    [self.view endEditing:true];
}


-(void) doneButtonAction {
    self.timeView.hidden = YES;
    self.schedSelectedTableView.hidden = NO;
    [self.view endEditing:true];
}

- (IBAction)timeButtonTapped:(id)sender {
    [self DisplayTime];
}

-(void)DisplayTime {
    datePicker.datePickerMode = UIDatePickerModeTime;
    self.timeTF.inputView = datePicker;
    [datePicker addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventValueChanged];
    [self.timeTF addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventEditingDidBegin];
    [self.timeTF becomeFirstResponder];
}

- (void) displaySelectedDateAndTime:(UIDatePicker*)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //   2016-06-25 12:00:00
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    [datePicker reloadInputViews];
    self.timeTF.text=[dateFormatter stringFromDate:datePicker.date];
}
- (IBAction)didClickSaveButton:(id)sender {
    self.planTextField.text = @"";
    self.plansTableView.hidden = NO;
    self.dropView.hidden = NO;
    planArray = [[NSMutableArray alloc] initWithObjects:@"All Day", @"Every Day", @"Week Day", @"Week Ends", @"Every Tuesday", nil];
    [self.plansTableView reloadData];
}


- (IBAction)planButtonTapped:(id)sender {
    self.planTextField.text = @"";
    self.plansTableView.hidden = NO;
    self.dropView.hidden = NO;
    planArray = [[NSMutableArray alloc] initWithObjects:@"All Day", @"Every Day", @"Week Day", @"Week Ends", @"Every Tuesday", nil];
    [self.plansTableView reloadData];
    
}

- (IBAction)saveButtonTapped:(id)sender {
    self.dropView.hidden = YES;
    selectedSavedArray = [NSMutableArray new];
    selectedSavedArray = selectedSchedArray;
    [self.savedTableView reloadData];
}


#pragma mark - UITableViewDataSource
    // number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    // number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.scheduleTableView) {
        return 10;
    } else if (tableView == self.schedSelectedTableView) {
        return selectedSchedArray.count;
    } else if (tableView == self.plansTableView) {
        return planArray.count;
    } else if (tableView == self.savedTableView) {
        return selectedSavedArray.count;
    }
    return nil;
}
    // the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"dateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (tableView == self.scheduleTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"Name:%d", (indexPath.row+1)];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Minutes", (indexPath.row+1)];
    }
    
    if (tableView == self.schedSelectedTableView) {
        if (selectedSchedArray.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"Name:%@", selectedSchedArray[indexPath.row]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Minutes", selectedSchedArray[indexPath.row]];
        }
    }
    
    if (tableView == self.plansTableView) {
        if (planArray.count) {
            cell.textLabel.text =  planArray[indexPath.row];
        }
    }
    
    if (tableView == self.savedTableView) {
        if (selectedSavedArray.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"Name:%@", selectedSavedArray[indexPath.row]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Minutes", selectedSavedArray[indexPath.row]];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
    // when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.scheduleTableView) {
        NSString *desc = [NSString stringWithFormat:@"Hello, This is Name:%d Description", (indexPath.row+1)];
        self.descriptionTextView.text = desc;
        
        NSString *value = [NSString stringWithFormat:@"%d", indexPath.row+1];
        [selectedSchedArray addObject:value];
        [self.schedSelectedTableView reloadData];
    }
    
    if (tableView == self.plansTableView) {
        self.planTextField.text = planArray[indexPath.row];
        self.plansTableView.hidden = YES;
    }
    
}


@end
