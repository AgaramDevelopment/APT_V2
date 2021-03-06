//
//  FoodDiaryUpdateVC.m
//  APT_V2
//
//  Created by MAC on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "FoodDiaryUpdateVC.h"
#import "Header.h"

@interface FoodDiaryUpdateVC () {
    NSString *clientCode;
    NSString *userCode;
    NSString *userRefCode;
    UIDatePicker * datePicker;
    BOOL isDate;
    BOOL isTime;
    NSComparisonResult result;
    NSMutableArray *foodDiaryDateArray;
    NSMutableArray *foodDescriptionArray;
    NSMutableArray *foodDiaryCodeArray;
    NSMutableArray *locationCodeArray;
    NSString *selectedDate;
    NSMutableArray *mealsTitleArray;
    NSString  *foodDiaryCode;
    NSString  *mealCode;
    NSMutableArray *mealLocationArray;
    NSMutableArray *foodArray;
    NSMutableArray *mealCodeArray;
    NSMutableArray *FOODDIARYSSSSS;
    NSMutableArray *FOODDIARYS;
    NSMutableArray *emptyFoodArray;
}

@end

@implementation FoodDiaryUpdateVC
@synthesize foodDiaryType, selectedIndexPath, foodDiaryArray, foodIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FOODDIARYSSSSS = [NSMutableArray new];
    FOODDIARYS = [NSMutableArray new];
    emptyFoodArray = [NSMutableArray new];
        //MSC412    Supplements
        //    self.saveOrUpdateBtn.hidden = NO;
    foodDescriptionArray = [[NSMutableArray alloc] init];
    foodArray = [NSMutableArray new];
    foodDiaryCodeArray = [[NSMutableArray alloc] initWithObjects:@"MSC342", @"MSC343", @"MSC344", @"MSC345", @"MSC412", nil];
    locationCodeArray = [[NSMutableArray alloc] initWithObjects:@"Team", @"Restaurant", @"Home", @"Other", nil];
        //TableView Editing
    self.foodTableView.editing=YES;
    
        //UIDatePicker
    datePicker = [[UIDatePicker alloc] init];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
        //create left side empty space so that done button set on right side
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    
        //    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style: UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    NSMutableArray *toolbarArray = [NSMutableArray new];
    [toolbarArray addObject:cancelBtn];
    [toolbarArray addObject:flexSpace];
    [toolbarArray addObject:doneBtn];
    
    [toolbar setItems:toolbarArray animated:false];
    [toolbar sizeToFit];
    
        //setting toolbar as inputAccessoryView
    self.dateTF.inputAccessoryView = toolbar;
    self.timeTF.inputAccessoryView = toolbar;
    
    mealCodeArray = [NSMutableArray new];
        //Fetch Service Call
//    [self foodDiaryFetchDetailsPostMethodWebService];
    [self cornerRadiusStyleForButtons];
    [self insertOrUpdateFoodDiaryMethod];
}

- (void)cornerRadiusStyleForButtons {
    
    if (IS_IPAD) {
        self.breakfastBtn.layer.cornerRadius = 8;
        self.snacksBtn.layer.cornerRadius = 8;
        self.lunchBtn.layer.cornerRadius = 8;
        self.dinnerBtn.layer.cornerRadius = 8;
        self.supplementsBtn.layer.cornerRadius = 8;
        
        self.teamBtn.layer.cornerRadius = 8;
        self.restaurantBtn.layer.cornerRadius = 8;
        self.homeBtn.layer.cornerRadius = 8;
        self.otherBtn.layer.cornerRadius = 8;
    } else {
        self.breakfastBtn.layer.cornerRadius = 5;
        self.snacksBtn.layer.cornerRadius = 5;
        self.lunchBtn.layer.cornerRadius = 5;
        self.dinnerBtn.layer.cornerRadius = 5;
        self.supplementsBtn.layer.cornerRadius = 5;
        
        self.teamBtn.layer.cornerRadius = 5;
        self.restaurantBtn.layer.cornerRadius = 5;
        self.homeBtn.layer.cornerRadius = 5;
        self.otherBtn.layer.cornerRadius = 5;
    }
    
    self.breakfastBtn.layer.masksToBounds = YES;
    self.snacksBtn.layer.masksToBounds = YES;
    self.lunchBtn.layer.masksToBounds = YES;
    self.dinnerBtn.layer.masksToBounds = YES;
    self.supplementsBtn.layer.masksToBounds = YES;
    
    self.teamBtn.layer.masksToBounds = YES;
    self.restaurantBtn.layer.masksToBounds =YES;
    self.homeBtn.layer.masksToBounds = YES;
    self.otherBtn.layer.masksToBounds = YES;
    
}
- (void)insertOrUpdateFoodDiaryMethod {
    
    if ([foodDiaryType isEqualToString:@"Save"]) {
        [self setClearBorderForMealTypeAndLocation];
    } else {
        [self.saveOrUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
        selectedDate = [[foodDiaryArray objectAtIndex:selectedIndexPath.row] valueForKey:@"DATE"];
        self.dateTF.text = selectedDate;
        self.timeTF.text = [[foodDiaryArray objectAtIndex:selectedIndexPath.row] valueForKey:@"STARTTIME"];
        foodDiaryCode = [[foodDiaryArray objectAtIndex:selectedIndexPath.row] valueForKey:@"FOODDIARYCODE"];
        
        
        FOODDIARYSSSSS = [NSMutableArray new];
        emptyFoodArray = [NSMutableArray new];
        
        if (foodDiaryArray.count) {
            for (int i=0; i<foodDiaryArray.count; i++) {
                
                NSMutableArray *foodArray = [[foodDiaryArray objectAtIndex:i] valueForKey:@"FOODLIST"];
                
                if (foodArray.count) {
                    
                    NSMutableDictionary *mealLocationDict = [NSMutableDictionary new];
                    
                    [mealLocationDict setObject:[[foodDiaryArray objectAtIndex:i] valueForKey:@"DATE"] forKey:@"DATE"];
                    [mealLocationDict setObject:[[foodDiaryArray objectAtIndex:i] valueForKey:@"STARTTIME"] forKey:@"STARTTIME"];
                    [mealLocationDict setObject:[[foodDiaryArray objectAtIndex:i] valueForKey:@"FOODDIARYCODE"] forKey:@"FOODDIARYCODE"];
                    [mealLocationDict setObject:[[foodDiaryArray objectAtIndex:i] valueForKey:@"MEALCODE"] forKey:@"MEALCODE"];
                    [mealLocationDict setObject:[[foodDiaryArray objectAtIndex:i] valueForKey:@"LOCATION"] forKey:@"LOCATION"];
                    
                    NSMutableArray *arrayy = [NSMutableArray new];
                    for (id key in foodArray) {
                        
                        NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                        [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                        [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                        [arrayy addObject:foodDescriptionDict];
                    }
                    [mealLocationDict setObject:arrayy forKey:@"FOODLIST"];
                    [FOODDIARYSSSSS addObject:mealLocationDict];
                }
            }
            
            int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[foodDiaryArray objectAtIndex:selectedIndexPath.row] valueForKey:@"MEALCODE"]];
            int locationCode = (int)[locationCodeArray indexOfObject:[[foodDiaryArray objectAtIndex:selectedIndexPath.row] valueForKey:@"LOCATION"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBorderForMealType:mealCode+1];
                [self setBorderForLocation:locationCode+1];
                [self.foodTableView reloadData];
            });
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}
/*
-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
        //    [self.view addSubview:objCustomNavigation.view];
        //    objCustomNavigation.tittle_lbl.text=@"";
    
        //UIView* view= self.navigation_view.subviews.firstObject;
    [self.navi_View addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden =YES;
    objCustomNavigation.menu_btn.hidden =NO;
        //        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //        [objCustomNavigation.home_btn addTarget:self action:@selector(HomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
*/

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            //[objCustomNavigation.btn_back addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
        {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        }
    [self.navi_View addSubview:objCustomNavigation.view];
        //    objCustomNavigation.tittle_lbl.text=@"";
    
}

-(IBAction)didClickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) doneButtonAction {
    
    if (isDate) {
        NSDate *today = [NSDate date];
        result = [today compare:datePicker.date]; // comparing two dates
        
        if(result == NSOrderedAscending)
            {
            [self altermsg:@"Future date is not allowed"];
            } else {
                if ([self.dateTF.text isEqualToString:selectedDate]) {
                    [self.saveOrUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
                        //        [self foodDiaryUpdatePostMethodWebService];
                } else if(self.dateTF.text) {
                    
                    [self setClearForFoodDiaryDetails];
                    [self foodDiaryFetchDetailsPostMethodWebServiceForNewDate:self.dateTF.text];
                }
            }
    }
    
    [self.view endEditing:true];
}

-(void) cancelButtonAction {
    if(isDate==YES) {
        self.dateTF.text = @"";
        [self.dateTF resignFirstResponder];
    } else if(isTime==YES) {
        self.timeTF.text = @"";
        [self.timeTF resignFirstResponder];
    }
    [self.view endEditing:true];
}

- (IBAction)dateButtonTapped:(id)sender {
    isDate = YES;
    isTime = NO;
    [self DisplaydatePicker];
}

-(void)DisplaydatePicker
{
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.dateTF.inputView = datePicker;
    [datePicker addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventValueChanged];
    [self.dateTF addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventEditingDidBegin];
    [self.dateTF becomeFirstResponder];
}

- (IBAction)timeButtonTapped:(id)sender {
    
    isDate = NO;
    isTime = YES;
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
    
    if(isDate==YES)
        {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //   2016-06-25 12:00:00
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [datePicker setLocale:locale];
        [datePicker reloadInputViews];
        self.dateTF.text = [dateFormatter stringFromDate:[datePicker date]];
        
        NSDate *today = [NSDate date];
        result = [today compare:datePicker.date]; // comparing two dates
        
        } else if(isTime == YES){
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //   2016-06-25 12:00:00
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [datePicker setLocale:locale];
            [datePicker reloadInputViews];
            self.timeTF.text=[dateFormatter stringFromDate:datePicker.date];
            
        }
}

- (IBAction)mealTypeBreakfastAction:(id)sender {
    [self setBorderForMealType:1];
}

- (IBAction)mealTypeSnacksAction:(id)sender {
    [self setBorderForMealType:2];
}

- (IBAction)mealTypeLunchAction:(id)sender {
    [self setBorderForMealType:3];
}

- (IBAction)mealTypeDinnerAction:(id)sender {
    [self setBorderForMealType:4];
}

- (IBAction)mealTypeSupplementsAction:(id)sender {
    [self setBorderForMealType:5];
}


- (IBAction)foodDescriptionButtonTapped:(id)sender {
    
        //    self.saveOrUpdateBtn.hidden = NO;
    
    if([self.dateTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select date"];
    } else if ([self.timeTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select time"];
    } else if ([self.mealTypeTF isEqualToString:@""]) {
        [self altermsg:@"Please select Meal Type"];
    } else if ([self.foodItemTF.text isEqualToString:@""]) {
        [self altermsg:@"Please enter food item"];
    } else if ([self.quantityTF.text isEqualToString:@""]) {
        [self altermsg:@"Please enter food quantity"];
    } else if ([self.locationTF isEqualToString:@""]) {
        [self altermsg:@"Please enter Location"];
    } else {
        
        NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
        [foodDescriptionDict setObject:self.foodItemTF.text forKey:@"FOOD"];
        [foodDescriptionDict setObject:self.quantityTF.text forKey:@"FOODQUANTITY"];
            //        [foodArray addObject:foodDescriptionDict];
            //        [foodDescriptionArray addObject:foodDescriptionDict];
        
            //Which Food FOODDIARYCODE have to maintain for Update Service Call [insert new Item in New Meal Type + delete existing item]
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:self.dateTF.text forKey:@"DATE"];
        [dic setObject:self.timeTF.text forKey:@"STARTTIME"];
        [dic setObject:self.timeTF.text forKey:@"ENDTIME"];
        [dic setObject:self.mealTypeTF forKey:@"MEALCODE"];
        [dic setObject:self.locationTF forKey:@"LOCATION"];
        
        NSMutableArray *arrayy = [NSMutableArray new];
        [arrayy addObject:foodDescriptionDict];
        
        
       // Date Predicate
        
        NSArray *filteredDateArray = [FOODDIARYSSSSS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(DATE contains[c] %@)", self.dateTF.text]];
        
        if (filteredDateArray.count) {
                //To Search Food Item is present or not
            NSPredicate *mealPredicate = [NSPredicate
                                          predicateWithFormat:@"SELF CONTAINS %@",
                                          mealCode];
            
            NSArray *mealCodeArray = [FOODDIARYSSSSS filteredArrayUsingPredicate:mealPredicate];
            
            
            //Custom Code
            if (mealCodeArray.count) {
                
                if ([mealCode isEqualToString:[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"MEALCODE"]]) {
                    
                    [[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] setObject:self.timeTF.text forKey:@"STARTTIME"];
                    [[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] setObject:self.timeTF.text forKey:@"ENDTIME"];
                    [[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] setObject:self.mealTypeTF forKey:@"MEALCODE"];
                    [[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] setObject:self.locationTF forKey:@"LOCATION"];
                    [[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"FOODLIST"] addObject:foodDescriptionDict];
                }
            } else {
                [dic setObject:[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"FOODDIARYCODE"] forKey:@"FOODDIARYCODE"];
                [dic setObject:arrayy forKey:@"FOODLIST"];
                [FOODDIARYSSSSS addObject:dic];
            }
        } else {
            [dic setObject:arrayy forKey:@"FOODLIST"];
            [FOODDIARYSSSSS addObject:dic];
        }
        
        
        NSLog(@"Updated:%@", FOODDIARYSSSSS);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.lblNoData setHidden:FOODDIARYSSSSS.count];
            [self.foodTableView reloadData];
            self.foodItemTF.text = @"";
            self.quantityTF.text = @"";
        });
    }
}

- (IBAction)locationTeamAction:(id)sender { //Team, Restaurant, Home, Other
                                            //        self.locationTF = @"Team";
    [self setBorderForLocation:1];
}
- (IBAction)locationRestaurantAction:(id)sender {
        //        self.locationTF = @"Restaurant";
    [self setBorderForLocation:2];
}

- (IBAction)locationHomeAction:(id)sender {
        //        self.locationTF = @"Home";
    [self setBorderForLocation:3];
}

- (IBAction)locationOtherAction:(id)sender {
        //        self.locationTF = @"Other";
    [self setBorderForLocation:4];
}

- (IBAction)saveOrUpdateButtonTapped:(id)sender {
    
    if([self.dateTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select date"];
    } else if ([self.timeTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select time"];
    } else if ([self.mealTypeTF isEqualToString:@""]) {
        [self altermsg:@"Please select Meal Type"];
    }
        //    else if (foodDescriptionArray.count == 0) {
        //        [self altermsg:@"Please select Food Description"];
        //    }
    else if ([self.locationTF isEqualToString:@""]) {
        [self altermsg:@"Please enter Location"];
    }  else {
        
        if ([self.dateTF.text isEqualToString:selectedDate]) {
            /*
             for (id key in mealLocationArray) {
             if ([self.mealTypeTF isEqualToString:[key valueForKey:@"MEALCODE"]]) {
             NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
             [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
             [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
             [foodArray addObject:foodDescriptionDict];
             }
             }
             [self foodDiaryUpdatePostMethodWebService];
             */
            
            /*
            FOODDIARYS = [NSMutableArray new];
            if (FOODDIARYSSSSS.count) {
                for (int i=0; i<FOODDIARYSSSSS.count; i++) {
                    
                        //Custom Code
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"DATE"] forKey:@"DATE"];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"STARTTIME"] forKey:@"STARTTIME"];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"MEALCODE"] forKey:@"MEALCODE"];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"LOCATION"] forKey:@"LOCATION"];
                    [dic setObject:foodDiaryCode forKey:@"FOODDIARYCODE"];
                        //                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"FOODDIARYCODE"] forKey:@"FOODDIARYCODE"];
                    
                    NSMutableArray *foodList = [NSMutableArray new];
                    NSMutableArray *extractArray = [NSMutableArray new];
                    
                        //                    [foodList addObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"FOODLIST"]];
                    extractArray = [[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"FOODLIST"];
                    
                    for (id key in extractArray) {
                        NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                        [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                        [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                        [foodList addObject:foodDescriptionDict];
                    }
                    
                    for (int j = i+1; j<FOODDIARYSSSSS.count; j++) {
                        
                        if ([[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"MEALCODE"] isEqualToString:[[FOODDIARYSSSSS objectAtIndex:j] valueForKey:@"MEALCODE"]]) {
                            
                            extractArray = [[FOODDIARYSSSSS objectAtIndex:j] valueForKey:@"FOODLIST"];
                            
                            for (id key in extractArray) {
                                NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                                [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                                [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                                [foodList addObject:foodDescriptionDict];
                            }
                                //                            [foodList addObject:[[FOODDIARYSSSSS objectAtIndex:j] valueForKey:@"FOODLIST"]];
                            
                            [FOODDIARYSSSSS removeObjectAtIndex:j];
                            j = j-1;
                        }
                    }
                    [dic setObject:foodList forKey:@"FOODLIST"];
                    [FOODDIARYS addObject:dic];
                }
            } else {
                if (emptyFoodArray.count) {
                    for (id key in emptyFoodArray) {
                        [FOODDIARYS addObject:key];
                    }
                }
            }
            */
                //Test Case-3
            if (FOODDIARYSSSSS.count) {
                
                NSString *date = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"DATE"];
                NSString *time = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"STARTTIME"];
                NSString *meal = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"MEALCODE"];
                NSString *location = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"LOCATION"];
//                NSString *foodDiaryCcode = foodDiaryCode;
                NSString *foodDiaryCcode = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"FOODDIARYCODE"];
                
                NSMutableArray *foodList = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"FOODLIST"];
                    //                if (foodList.count) {
                [self foodDiaryUpdatePostMethodWebServiceAndDate:date andTime:time andMeealType:meal andLocation:location andFoodDiaryCode:foodDiaryCcode andFoodList:foodList andLoopCount:0 andTotalCount:(int)FOODDIARYSSSSS.count];
                    //                }
            } else {
                [self altermsg:@"Please enter food details"];
            }
            
        } else {
            /* SAVE */
                //Test Case - 1
                //[self foodDiaryInsertPostMethodWebService];
            
                //Test Case - 2
            /*
             if (FOODDIARYSSSSS.count) {
             for (id key in FOODDIARYSSSSS) {
             
             NSString *date = [key valueForKey:@"DATE"];
             NSString *time = [key valueForKey:@"STARTTIME"];
             NSString *meal = [key valueForKey:@"MEALCODE"];
             NSString *location = [key valueForKey:@"LOCATION"];
             NSMutableArray *foodList = [key valueForKey:@"FOODLIST"];
             if (foodList.count) {
             [self foodDiaryInsertPostMethodWebServiceDate:date andTime:time andMeealType:meal andLocation:location andFoodList:foodList];
             } else {
             [self altermsg:@"Please enter food item and quantity"];
             }
             }
             }  else {
             [self altermsg:@"Please enter food details"];
             }
             */
            /*
            FOODDIARYS = [NSMutableArray new];
            if (FOODDIARYSSSSS.count) {
                for (int i=0; i<FOODDIARYSSSSS.count; i++) {
                    
                        //Custom Code
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"DATE"] forKey:@"DATE"];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"STARTTIME"] forKey:@"STARTTIME"];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"MEALCODE"] forKey:@"MEALCODE"];
                    [dic setObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"LOCATION"] forKey:@"LOCATION"];
                    NSMutableArray *foodList = [NSMutableArray new];
                    NSMutableArray *extractArray = [NSMutableArray new];
                    
                        //                    [foodList addObject:[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"FOODLIST"]];
                    extractArray = [[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"FOODLIST"];
                    
                    for (id key in extractArray) {
                        NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                        [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                        [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                        [foodList addObject:foodDescriptionDict];
                    }
                    
                    for (int j = i+1; j<FOODDIARYSSSSS.count; j++) {
                        
                        if ([[[FOODDIARYSSSSS objectAtIndex:i] valueForKey:@"MEALCODE"] isEqualToString:[[FOODDIARYSSSSS objectAtIndex:j] valueForKey:@"MEALCODE"]]) {
                            
                            extractArray = [[FOODDIARYSSSSS objectAtIndex:j] valueForKey:@"FOODLIST"];
                            
                            for (id key in extractArray) {
                                NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                                [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                                [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                                [foodList addObject:foodDescriptionDict];
                            }
                                //                            [foodList addObject:[[FOODDIARYSSSSS objectAtIndex:j] valueForKey:@"FOODLIST"]];
                            
                            [FOODDIARYSSSSS removeObjectAtIndex:j];
                            j = j-1;
                        }
                    }
                    [dic setObject:foodList forKey:@"FOODLIST"];
                    [FOODDIARYS addObject:dic];
                }
            }
            */
                //Test Case-3
            if (FOODDIARYSSSSS.count) {
                
                NSString *date = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"DATE"];
                NSString *time = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"STARTTIME"];
                NSString *meal = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"MEALCODE"];
                NSString *location = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"LOCATION"];
                NSMutableArray *foodList = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"FOODLIST"];
                if (foodList.count) {
                    [self foodDiaryInsertPostMethodWebServiceAndDate:date andTime:time andMeealType:meal andLocation:location andFoodList:foodList andLoopCount:0 andTotalCount:(int)FOODDIARYSSSSS.count];
                }
            } else {
                [self altermsg:@"Please enter food details"];
            }
        }
    }
}

#pragma mark - sendStreamingStatus
-(void)foodDiaryInsertPostMethodWebServiceDate:(NSString*)date andTime:(NSString*)time andMeealType:(NSString*)meal andLocation:(NSString*)location andFoodList:(NSMutableArray*)foodList {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSString *urlString= URL_FOR_RESOURCE(foodDiaryInsert);;
        
            //        NSString *post =[[NSString alloc] initWithFormat:@"action=setStreamStatus&channel_id=%@&status=0",_channelID];
        
        clientCode = [AppCommon GetClientCode];
        userCode = [AppCommon GetUsercode];
        userRefCode = [AppCommon GetuserReference];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
        if(userCode)   [dic    setObject:userCode     forKey:@"CREATEDBY"];
        if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
        
        [dic setObject:date forKey:@"DATE"];
        [dic setObject:time forKey:@"STARTTIME"];
        [dic setObject:time forKey:@"ENDTIME"];
        [dic setObject:meal forKey:@"MEALCODE"];
        [dic setObject:location forKey:@"LOCATION"];
        [dic setObject:foodList forKey:@"FOODLIST"];
        
        NSLog(@"parameters : %@",dic);
        
        
        NSURL *url = [NSURL URLWithString:urlString];
            //        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
            //        NSData* postData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            //        NSError *error;
        NSError *error = nil;
        NSData* postData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            //        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
            //        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld %@", (long)[response statusCode], response);
    });
    
}

#pragma Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        //    return FOODDIARYSSSSS.count;
    
    if (FOODDIARYSSSSS.count) {
        
            //To Search Food Item is present or not
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF CONTAINS %@",
                                        mealCode];
        
        NSArray *mealCodeArray = [FOODDIARYSSSSS filteredArrayUsingPredicate:resultPredicate];
        [self.lblNoData setHidden:mealCodeArray.count];
        if (mealCodeArray.count) {
            
            NSArray *IDs = [FOODDIARYSSSSS valueForKey:@"MEALCODE"];
            foodIndexPath = [NSIndexPath indexPathForRow:[IDs indexOfObject:mealCode] inSection:section];
            
            if ([mealCode isEqualToString:[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"MEALCODE"]]) {
                return [[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"FOODLIST"] count];
            }
        } else {
            [self setClearBorderLocationAndTime];
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"foodDescriptionCell";
    
    FoodDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"FoodDescriptionCell" owner:self options:nil];
    cell = arr[0];
    
    if (FOODDIARYSSSSS.count) {
        NSMutableArray *extractArray = [[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"FOODLIST"];
        self.timeTF.text = [[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"STARTTIME"];
        int locationCode = (int)[locationCodeArray indexOfObject:[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"LOCATION"]];
        [self setBorderForLocation:locationCode+1];
        
        if (extractArray.count) {
            cell.foodItemLbl.text = [[extractArray objectAtIndex:indexPath.row] valueForKey:@"FOOD"];
            cell.quantityLbl.text = [[extractArray objectAtIndex:indexPath.row] valueForKey:@"FOODQUANTITY"];
            
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /*
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF CONTAINS %@",
                                        [[FOODDIARYSSSSS objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"]];
        
        self.searchResult = [FOODDIARYSSSSS filteredArrayUsingPredicate:resultPredicate];
        
        if (self.searchResult.count == 1) {
                //            [emptyFoodArray addObject:[[FOODDIARYSSSSS objectAtIndex:indexPath.row] replaceO]];
            
                //Custom Code
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:[[FOODDIARYSSSSS objectAtIndex:indexPath.row] valueForKey:@"DATE"] forKey:@"DATE"];
            [dic setObject:[[FOODDIARYSSSSS objectAtIndex:indexPath.row] valueForKey:@"STARTTIME"] forKey:@"STARTTIME"];
            [dic setObject:[[FOODDIARYSSSSS objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"] forKey:@"MEALCODE"];
            [dic setObject:[[FOODDIARYSSSSS objectAtIndex:indexPath.row] valueForKey:@"LOCATION"] forKey:@"LOCATION"];
            [dic setObject:foodDiaryCode forKey:@"FOODDIARYCODE"];
            NSMutableArray *foodListArray = [NSMutableArray new];
            [dic setObject:foodListArray forKey:@"FOODLIST"];
            
            [emptyFoodArray addObject:dic];
        }//FOODLIST
        [FOODDIARYSSSSS removeObjectAtIndex:indexPath.row];
        */
        /*
         NSString *mealCodeString = [[mealLocationArray objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"];
         //        [mealCodeArray addObject:mealCode];
         NSLog(@"mealCode:%@", mealCodeString);
         
         //        foodArray = [NSMutableArray new];
         for (id key in mealLocationArray) {
         if ([mealCodeString isEqualToString:[key valueForKey:@"MEALCODE"]]) {
         NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
         [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
         [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
         [foodArray addObject:foodDescriptionDict];
         
         self.mealTypeTF = [key valueForKey:@"MEALCODE"];
         self.locationTF = [key valueForKey:@"LOCATION"];
         foodDiaryCode = [key valueForKey:@"FOODDIARYCODE"];
         }
         }
         */
        
        NSLog(@"Deleted Item:%@", [[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"FOODLIST"] objectAtIndex:indexPath.row]);
        
            //To Delete particular Food Item
        [[[FOODDIARYSSSSS objectAtIndex:foodIndexPath.row] valueForKey:@"FOODLIST"] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
            //        [self foodDiaryUpdatePostMethodWebService];
        
    }
    NSLog(@"FOODDIARYSSSSS Removed:%@", FOODDIARYSSSSS);
        //    self.saveOrUpdateBtn.hidden = NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.foodTableView.editing)
        {
        return UITableViewCellEditingStyleDelete;
        }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 45;
    } else {
        return 35;
    }
}

- (void)foodDiaryFetchDetailsPostMethodWebService {
    
        // Get current datetime
    NSDate *currentDateTime = [NSDate date];
    
        // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
        // Set the dateFormatter format
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
        // Get the date time in NSString
    NSString *date = [dateFormatter stringFromDate:currentDateTime];
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryFetch);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
        //CLIENTCODE, PLAYERCODE, DATE
    clientCode = [AppCommon GetClientCode];
    userRefCode = [AppCommon GetuserReference];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    [dic setObject:date forKey:@"DATE"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            
            foodDiaryArray = [NSMutableArray new];
            NSMutableArray *FOODDIARYSArray = [NSMutableArray new];
            FOODDIARYSArray = [responseObject objectForKey:@"FOODDIARYS"];
            
            if (FOODDIARYSArray.count) {
                for (id key in FOODDIARYSArray) {
                    
                    if ([[key valueForKey:@"FOODLIST"] count]) {
                        if ([date isEqualToString:[key valueForKey:@"DATE"]]) {
                            [foodDiaryArray addObject:key];
                        }
                    }
                }
            }
            
            NSLog(@"Count:%ld", foodDiaryArray.count);
            [self setClearBorderForMealTypeAndLocation];
        }
        
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

- (void)foodDiaryFetchDetailsPostMethodWebServiceForNewDate:(NSString *)date {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryFetch);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
        //CLIENTCODE, PLAYERCODE, DATE
    clientCode = [AppCommon GetClientCode];
    userRefCode = [AppCommon GetuserReference];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    [dic setObject:date forKey:@"DATE"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            
            NSMutableArray *foodDiarys = [responseObject objectForKey:@"FOODDIARYS"];
            FOODDIARYSSSSS = [NSMutableArray new];
            mealLocationArray = [NSMutableArray new];
            foodArray = [NSMutableArray new];
            emptyFoodArray = [NSMutableArray new];
            if (foodDiarys.count) {
                for (int i=0; i<foodDiarys.count; i++) {
                    
                    NSString *date = [[foodDiarys objectAtIndex:i] valueForKey:@"DATE"];
                    
                    if ([self.dateTF.text isEqualToString:date]) {
                        
                        selectedDate = self.dateTF.text;
                        [self.saveOrUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
                        NSMutableArray *foodListArray = [[foodDiarys objectAtIndex:i] valueForKey:@"FOODLIST"];
                        
                        if (foodListArray.count) {
                            
                            NSMutableDictionary *mealLocationDict = [NSMutableDictionary new];
                            
                            [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"DATE"] forKey:@"DATE"];
                            [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"STARTTIME"] forKey:@"STARTTIME"];
                            [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"FOODDIARYCODE"] forKey:@"FOODDIARYCODE"];
                            [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"MEALCODE"] forKey:@"MEALCODE"];
                            [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"LOCATION"] forKey:@"LOCATION"];
                            
                            NSMutableArray *arrayy = [NSMutableArray new];
                            
                            for (id key in foodListArray) {
                                
                                NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                                [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                                [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                                
                                [arrayy addObject:foodDescriptionDict];
                            }
                            
                            [mealLocationDict setObject:arrayy forKey:@"FOODLIST"];
                            [FOODDIARYSSSSS addObject:mealLocationDict];
                                //                            self.saveOrUpdateBtn.hidden = YES;
                        } else {
                            self.timeTF.text = [[foodDiarys objectAtIndex:i] valueForKey:@"STARTTIME"];
                            foodDiaryCode = [[foodDiarys objectAtIndex:i] valueForKey:@"FOODDIARYCODE"];
                            int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[foodDiarys objectAtIndex:i] valueForKey:@"MEALCODE"]];
                            int locationCode = (int)[locationCodeArray indexOfObject:[[foodDiarys objectAtIndex:i] valueForKey:@"LOCATION"]];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setBorderForMealType:mealCode+1];
                                [self setBorderForLocation:locationCode+1];
                                [self.foodTableView reloadData];
                            });
                            
                        }
                    }
                }
            }
            NSLog(@"FOODDIARYSSSSS:%@", FOODDIARYSSSSS);
            if (FOODDIARYSSSSS.count) {
                
                self.timeTF.text = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"STARTTIME"];
                foodDiaryCode = [[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"FOODDIARYCODE"];
                int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"MEALCODE"]];
                int locationCode = (int)[locationCodeArray indexOfObject:[[FOODDIARYSSSSS objectAtIndex:0] valueForKey:@"LOCATION"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setBorderForMealType:mealCode+1];
                    [self setBorderForLocation:locationCode+1];
                    [self.foodTableView reloadData];
                });
            }
            NSLog(@"Final Resp:%@", FOODDIARYSSSSS);
        }
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

- (void)foodDiaryInsertPostMethodWebService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryInsert);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
        //CLIENTCODE, PLAYERCODE, DATE
    clientCode = [AppCommon GetClientCode];
    userCode = [AppCommon GetUsercode];
    userRefCode = [AppCommon GetuserReference];
    
        //CLIENTCODE, PLAYERCODE, DATE, STARTTIME, ENDTIME, MEALCODE, LOCATION, CREATEDBY, FOODLIST(FOOD, FOODQUANTITY)
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userCode)   [dic    setObject:userCode     forKey:@"CREATEDBY"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    
    [dic setObject:self.dateTF.text forKey:@"DATE"];
    [dic setObject:self.timeTF.text forKey:@"STARTTIME"];
    [dic setObject:self.timeTF.text forKey:@"ENDTIME"];
    [dic setObject:self.mealTypeTF forKey:@"MEALCODE"];
    [dic setObject:self.locationTF forKey:@"LOCATION"];
        //    [dic setObject:@"Dinner" forKey:@"MEALCODE"];
        //    [dic setObject:@"Other" forKey:@"LOCATION"];
        //    [dic setObject:foodDescriptionArray forKey:@"FOODLIST"];
    [dic setObject:foodArray forKey:@"FOODLIST"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            
            [self altermsg:[responseObject valueForKey:@"MESSAGE"]];
//            [self foodDiaryFetchDetailsPostMethodWebService];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

- (void)foodDiaryInsertPostMethodWebServiceAndDate:(NSString*)date andTime:(NSString*)time andMeealType:(NSString*)meal andLocation:(NSString*)location andFoodList:(NSMutableArray*)foodList andLoopCount:(int)loopCount andTotalCount:(int)totalCount {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryInsert);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    clientCode = [AppCommon GetClientCode];
    userCode = [AppCommon GetUsercode];
    userRefCode = [AppCommon GetuserReference];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userCode)   [dic    setObject:userCode     forKey:@"CREATEDBY"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    
    [dic setObject:date forKey:@"DATE"];
    [dic setObject:time forKey:@"STARTTIME"];
    [dic setObject:time forKey:@"ENDTIME"];
    [dic setObject:meal forKey:@"MEALCODE"];
    [dic setObject:location forKey:@"LOCATION"];
    [dic setObject:foodList forKey:@"FOODLIST"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            
            NSLog(@"Total:%ld", totalCount);
            NSLog(@"Loop:%ld", loopCount+1);
            if (totalCount > (loopCount+1)) {
                
                NSString *date = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"DATE"];
                NSString *time = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"STARTTIME"];
                NSString *meal = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"MEALCODE"];
                NSString *location = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"LOCATION"];
                NSMutableArray *foodList = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"FOODLIST"];
                if (foodList.count) {
                    
                    [self foodDiaryInsertPostMethodWebServiceAndDate:date andTime:time andMeealType:meal andLocation:location andFoodList:foodList andLoopCount:(loopCount+1) andTotalCount:(int)FOODDIARYSSSSS.count];
                }
            } else {
                [self altermsg:[responseObject valueForKey:@"MESSAGE"]];
//                [self foodDiaryFetchDetailsPostMethodWebService];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}


- (void)foodDiaryUpdatePostMethodWebServiceAndDate:(NSString*)date andTime:(NSString*)time andMeealType:(NSString*)meal andLocation:(NSString*)location andFoodDiaryCode:(NSString*)foodDiaryCcode andFoodList:(NSMutableArray*)foodList andLoopCount:(int)loopCount andTotalCount:(int)totalCount {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryUpdate);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
        //CLIENTCODE, PLAYERCODE, DATE
    clientCode = [AppCommon GetClientCode];
    userCode = [AppCommon GetUsercode];
    userRefCode = [AppCommon GetuserReference];
    
        //CLIENTCODE, PLAYERCODE, DATE, STARTTIME, ENDTIME, MEALCODE, LOCATION, CREATEDBY, FOODLIST(FOOD, FOODQUANTITY)
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userCode)   [dic    setObject:userCode     forKey:@"MODIFIEDBY"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    
    [dic setObject:date forKey:@"DATE"];
    [dic setObject:time forKey:@"STARTTIME"];
    [dic setObject:time forKey:@"ENDTIME"];
    [dic setObject:meal forKey:@"MEALCODE"];
    [dic setObject:location forKey:@"LOCATION"];
    [dic setObject:foodDiaryCcode forKey:@"FOODDIARYCODE"];
    
    [dic setObject:foodList forKey:@"FOODLIST"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            
            NSLog(@"Total:%ld", totalCount);
            NSLog(@"Loop:%ld", loopCount+1);
            if (totalCount > (loopCount+1)) {
                
                NSString *date = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"DATE"];
                NSString *time = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"STARTTIME"];
                NSString *meal = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"MEALCODE"];
                NSString *location = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"LOCATION"];
//                NSString *foodDiaryCccode = foodDiaryCode;
                NSString *foodDiaryCccode = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"FOODDIARYCODE"];
                NSMutableArray *foodList = [[FOODDIARYSSSSS objectAtIndex:(loopCount+1)] valueForKey:@"FOODLIST"];
                    //                if (foodList.count) {
                
                [self foodDiaryUpdatePostMethodWebServiceAndDate:date andTime:time andMeealType:meal andLocation:location andFoodDiaryCode:foodDiaryCccode andFoodList:foodList andLoopCount:(loopCount+1) andTotalCount:(int)FOODDIARYSSSSS.count];
                    //                }
            } else {
                [self altermsg:[responseObject valueForKey:@"MESSAGE"]];
//                [self foodDiaryFetchDetailsPostMethodWebService];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

- (void)foodDiaryUpdatePostMethodWebService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(foodDiaryUpdate);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
        //CLIENTCODE, PLAYERCODE, DATE
    clientCode = [AppCommon GetClientCode];
    userCode = [AppCommon GetUsercode];
    userRefCode = [AppCommon GetuserReference];
    
        //CLIENTCODE, PLAYERCODE, DATE, STARTTIME, ENDTIME, MEALCODE, LOCATION, CREATEDBY, FOODLIST(FOOD, FOODQUANTITY)
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
    if(userCode)   [dic    setObject:userCode     forKey:@"MODIFIEDBY"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"PLAYERCODE"];
    
    [dic setObject:self.dateTF.text forKey:@"DATE"];
    [dic setObject:self.timeTF.text forKey:@"STARTTIME"];
    [dic setObject:self.timeTF.text forKey:@"ENDTIME"];
    [dic setObject:self.mealTypeTF forKey:@"MEALCODE"];
    [dic setObject:self.locationTF forKey:@"LOCATION"];
    [dic setObject:foodDiaryCode forKey:@"FOODDIARYCODE"];
        //    [dic setObject:@"Other" forKey:@"LOCATION"];
        //    [dic setObject:foodDescriptionArray forKey:@"FOODLIST"];
    [dic setObject:foodArray forKey:@"FOODLIST"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"STATUS"] integerValue] == 1) {
            [self altermsg:[responseObject valueForKey:@"MESSAGE"]];
//            [self foodDiaryFetchDetailsPostMethodWebService];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
    }];
}

-(void)setBorderForMealType:(int)selectedTag
{
    NSArray *arr = @[self.breakfastBtn,self.snacksBtn,self.lunchBtn,self.dinnerBtn,self.supplementsBtn];
    
    for (UIButton *btn in arr) {
        if(btn.tag == selectedTag) {
            self.mealTypeTF = [foodDiaryCodeArray objectAtIndex:selectedTag-1];
            mealCode = [foodDiaryCodeArray objectAtIndex:selectedTag-1];
            btn.layer.borderWidth = 2.0f;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
        } else {
            btn.layer.borderWidth = 0.0f;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
        //Re-load TableView
    [self.foodTableView reloadData];
}

-(void)setBorderForLocation:(int)selectedTag
{
    NSArray *arr = @[self.teamBtn,self.restaurantBtn,self.homeBtn,self.otherBtn];
    
    for (UIButton *btn in arr) {
        if(btn.tag == selectedTag) {
            self.locationTF = [locationCodeArray objectAtIndex:selectedTag-1];
            btn.layer.borderWidth = 2.0f;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
        } else {
            btn.layer.borderWidth = 0.0f;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

-(void)setClearBorderForMealTypeAndLocation {
    
        //    self.saveOrUpdateBtn.hidden = NO;
    [self.saveOrUpdateBtn setTitle:@"Save" forState:UIControlStateNormal];
    selectedDate = @"";
    self.dateTF.text = @"";
    self.timeTF.text = @"";
    self.mealTypeTF = @"";
    [FOODDIARYSSSSS removeAllObjects];
    [emptyFoodArray removeAllObjects];
    self.locationTF = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.foodTableView reloadData];
    });
    
    NSArray *arr = @[self.breakfastBtn,self.snacksBtn,self.lunchBtn,self.dinnerBtn,self.supplementsBtn, self.teamBtn,self.restaurantBtn,self.homeBtn,self.otherBtn];
    for (UIButton *btn in arr) {
        btn.layer.borderWidth = 0.0f;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

- (void)setClearBorderLocationAndTime {
    self.timeTF.text = @"";
    NSArray *arr = @[self.teamBtn,self.restaurantBtn,self.homeBtn,self.otherBtn];
    for (UIButton *btn in arr) {
        btn.layer.borderWidth = 0.0f;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
    }
}
- (void)setClearForFoodDiaryDetails {
    
        //    self.saveOrUpdateBtn.hidden = NO;
    [self.saveOrUpdateBtn setTitle:@"Save" forState:UIControlStateNormal];
    selectedDate = @"";
    self.mealTypeTF = @"";
    [foodDescriptionArray removeAllObjects];
    self.locationTF = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.foodTableView reloadData];
    });
    
    NSArray *arr = @[self.breakfastBtn,self.snacksBtn,self.lunchBtn,self.dinnerBtn,self.supplementsBtn, self.teamBtn,self.restaurantBtn,self.homeBtn,self.otherBtn];
    for (UIButton *btn in arr) {
        btn.layer.borderWidth = 0.0f;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

-(void)altermsg:(NSString *) message
{
    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Food Diary" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objaltert show];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==self.foodItemTF){
        
//        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "];
//        for (int i = 0; i < [string length]; i++)
//            {
//            unichar c = [string characterAtIndex:i];
//            if (![myCharSet characterIsMember:c])
//                {
//                [self alertStatus:@"Food Item allows only letters and numbers" :@"Food Diary Failed" :0];
//                return NO;
//                }
//            }
        
        if (textField==self.foodItemTF){
            
            if (newString.length>25) {
                [self alertStatus:@"Food Name must be minimum of 1-25 alpha numeric" :@"Food Diary Failed" :0];
                return NO;
            }
        }
    }
    
    if (textField==self.quantityTF){
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++)
            {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
                {
                [self alertStatus:@"Food Quantity allows only numbers" :@"Food Diary Failed" :0];
                return NO;
                }
            }
        
        if (textField==self.quantityTF){
            
            if (newString.length>6) {
                [self alertStatus:@"Food Quantity must be minimum of 1-6 digits" :@"Food Diary Failed" :0];
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UIAlertView Delegate Method
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg  delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                   [alertView show];
                   });
}

#pragma mark - UITextField Delegate Methods
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.foodItemTF) {
        [self.quantityTF becomeFirstResponder];
    } else if (textField == self.quantityTF) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
