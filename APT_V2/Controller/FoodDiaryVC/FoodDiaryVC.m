//
//  FoodDiaryVC.m
//  APT_V2
//
//  Created by MAC on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "FoodDiaryVC.h"
#import "FoodDiaryCell.h"
#import "FoodDescriptionCell.h"
#import "Header.h"

@interface FoodDiaryVC () {
    NSString *clientCode;
    NSString *userCode;
    NSString *userRefCode;
    UIDatePicker * datePicker;
    BOOL isDate;
    BOOL isTime;
    NSComparisonResult result;
    NSMutableArray *foodDiaryArray;
    NSMutableArray *foodDiaryDateArray;
    NSMutableArray *foodDescriptionArray;
    NSMutableArray *foodDiaryCodeArray;
    NSMutableArray *locationCodeArray;
    NSString *selectedDate;
    NSMutableArray *mealsTitleArray;
    NSString  *foodDiaryCode;
    NSMutableArray *mealLocationArray;
    NSMutableArray *foodArray;
    NSMutableArray *mealCodeArray;
}

@end

@implementation FoodDiaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
//    [self customnavigationmethod];
        //MSC412    Supplements
    self.saveOrUpdateBtn.hidden = NO;
    [self.saveOrUpdateBtn setTitle:@"Save" forState:UIControlStateNormal];
    foodDescriptionArray = [[NSMutableArray alloc] init];
    foodArray = [NSMutableArray new];
    foodDiaryCodeArray = [[NSMutableArray alloc] initWithObjects:@"MSC342", @"MSC343", @"MSC344", @"MSC345", @"MSC412", nil];
    locationCodeArray = [[NSMutableArray alloc] initWithObjects:@"Team", @"Restaurant", @"Home", @"Other", nil];
        //TableView Editing
    self.foodTableView.editing=YES;
        //Adds a shadow to contentView
    self.addBtn.layer.masksToBounds = NO;
    self.addBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addBtn.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.addBtn.layer.shadowRadius = 5;
    self.addBtn.layer.shadowOpacity = 0.8f;
    
    [self.foodDiaryCollectionView registerNib:[UINib nibWithNibName:@"FoodDiaryCell" bundle:nil] forCellWithReuseIdentifier:@"foodCell"];
    
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
    [self foodDiaryFetchDetailsPostMethodWebService];
}

-(void)viewWillAppear:(BOOL)animated
{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(void) doneButtonAction {
    
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

- (void)foodDiarySelectedDateDetails {
    
    self.timeTF.text = [[foodDiaryDateArray objectAtIndex:0] valueForKey:@"STARTTIME"];
    foodDiaryCode = [[foodDiaryDateArray objectAtIndex:0] valueForKey:@"FOODDIARYCODE"];
    
    for (int i=0; i<foodDiaryDateArray.count; i++) {
        
        NSMutableArray *foodListArray = [[foodDiaryDateArray objectAtIndex:i] valueForKey:@"FOODLIST"];
        foodDescriptionArray = [NSMutableArray new];
        for (id key in foodListArray) {
            NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
            [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
            [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
            [foodDescriptionArray addObject:foodDescriptionDict];
        }
    }
    
    int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[foodDiaryDateArray objectAtIndex:0] valueForKey:@"MEALCODE"]];
    int locationCode = (int)[locationCodeArray indexOfObject:[[foodDiaryDateArray objectAtIndex:0] valueForKey:@"LOCATION"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBorderForMealType:mealCode+1];
        [self setBorderForLocation:locationCode+1];
        [self.foodTableView reloadData];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

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

- (IBAction)addFoodDiaryButtonTapped:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setClearBorderForMealTypeAndLocation];
    });
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
    
    self.saveOrUpdateBtn.hidden = NO;
    if ([self.foodItemTF.text isEqualToString:@""]) {
        [self altermsg:@"Please enter food item"];
    } else if ([self.quantityTF.text isEqualToString:@""]) {
        [self altermsg:@"Please enter food quantity"];
    } else {
        
        NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
        [foodDescriptionDict setObject:self.foodItemTF.text forKey:@"FOOD"];
        [foodDescriptionDict setObject:self.quantityTF.text forKey:@"FOODQUANTITY"];
        [foodArray addObject:foodDescriptionDict];
        [foodDescriptionArray addObject:foodDescriptionDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
            
            for (id key in mealLocationArray) {
                if ([self.mealTypeTF isEqualToString:[key valueForKey:@"MEALCODE"]]) {
                    NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                    [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                    [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                    [foodArray addObject:foodDescriptionDict];
                }
            }
            [self foodDiaryUpdatePostMethodWebService];
            /*
             for (id key in mealLocationArray) {
             for (NSString *mealCode in mealCodeArray) {
             
             if ([mealCode isEqualToString:[key valueForKey:@"MEALCODE"]]) {
             foodArray = [NSMutableArray new];
             NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
             [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
             [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
             [foodArray addObject:foodDescriptionDict];
             [self foodDiaryUpdatePostMethodWebService];
             }
             }
             }
             [mealCodeArray removeAllObjects];
             */
        } else {
            [self foodDiaryInsertPostMethodWebService];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self.lblNoData setHidden:foodDiaryArray.count];
    return foodDiaryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodDiaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 3;
    cell.layer.shadowOpacity = 0.8f;
    
    if (foodDiaryArray.count) {
        NSMutableArray *foodListArray = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"FOODLIST"];
        
            cell.timeLbl.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"STARTTIME"];
            cell.mealNameLbl.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"MEALNAME"];
            
            if (foodListArray.count == 1) {
                cell.food1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
                cell.food2Lbl.text = @"";
                cell.food3Lbl.text = @"";
            } else if (foodListArray.count == 2) {
                cell.food1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
                cell.food2Lbl.text = [[foodListArray objectAtIndex:1] valueForKey:@"FOOD"];
                cell.food3Lbl.text = @"";
            } else {
                cell.food1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
                cell.food2Lbl.text = [[foodListArray objectAtIndex:1] valueForKey:@"FOOD"];
                cell.food3Lbl.text = [[foodListArray objectAtIndex:2] valueForKey:@"FOOD"];
            }
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.saveOrUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
    selectedDate = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"DATE"];
    self.dateTF.text = selectedDate;
    self.timeTF.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"STARTTIME"];
    foodDiaryCode = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"FOODDIARYCODE"];
    NSMutableArray *foodListArray = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"FOODLIST"];
    foodDescriptionArray = [NSMutableArray new];
    
    for (id key in foodListArray) {
        NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
        [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
        //        [foodDescriptionDict setObject:[[key objectAtIndex:indexPath.row] valueForKey:@"FOOD"] forKey:@"FOOD"];
        [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
        [foodDescriptionArray addObject:foodDescriptionDict];
    }
    
    int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"]];
    int locationCode = (int)[locationCodeArray indexOfObject:[[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"LOCATION"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBorderForMealType:mealCode+1];
        [self setBorderForLocation:locationCode+1];
        [self.foodTableView reloadData];
    });
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPAD) {
        return CGSizeMake(120, 140);
    } else {
        return CGSizeMake(120, 140);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return foodDescriptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"foodDescriptionCell";
    
    FoodDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"FoodDescriptionCell" owner:self options:nil];
    cell = arr[0];
    
    if (foodDescriptionArray.count) {
        cell.foodItemLbl.text = [[foodDescriptionArray objectAtIndex:indexPath.row] valueForKey:@"FOOD"];
        cell.quantityLbl.text = [[foodDescriptionArray objectAtIndex:indexPath.row] valueForKey:@"FOODQUANTITY"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"foodDescriptionArray1:%@", foodDescriptionArray);
        NSString *mealCodeString = [[mealLocationArray objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"];
//        [mealCodeArray addObject:mealCode];
        NSLog(@"mealCode:%@", mealCodeString);
        
        [foodDescriptionArray removeObjectAtIndex:indexPath.row];
        [mealLocationArray removeObjectAtIndex:indexPath.row];
        
        foodArray = [NSMutableArray new];
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
        
        /*
        //Remove MealCode and LocationCode
        int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[mealLocationArray objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"]];
        int locationCode = (int)[locationCodeArray indexOfObject:[[mealLocationArray objectAtIndex:indexPath.row] valueForKey:@"LOCATION"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setBorderForMealType:mealCode+1];
            [self setBorderForLocation:locationCode+1];
        });
        */
        NSLog(@"foodDescriptionArray2:%@", foodDescriptionArray);
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [self foodDiaryUpdatePostMethodWebService];
        [foodArray removeAllObjects];
    }
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
            for (id key in FOODDIARYSArray) {
               
                if ([[key valueForKey:@"FOODLIST"] count]) {
                    if ([date isEqualToString:[key valueForKey:@"DATE"]]) {
                         [foodDiaryArray addObject:key];
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
            foodDescriptionArray = [NSMutableArray new];
            mealLocationArray = [NSMutableArray new];
            foodArray = [NSMutableArray new];
            if (foodDiarys.count) {
                for (int i=0; i<foodDiarys.count; i++) {
                    
                    NSString *date = [[foodDiarys objectAtIndex:i] valueForKey:@"DATE"];
                    
                    if ([self.dateTF.text isEqualToString:date]) {
                        
                        selectedDate = self.dateTF.text;
                        [self.saveOrUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
                        NSMutableArray *foodListArray = [[foodDiarys objectAtIndex:i] valueForKey:@"FOODLIST"];
                        
                        if (foodListArray.count) {

                            for (id key in foodListArray) {
                                
                                 NSMutableDictionary *mealLocationDict = [NSMutableDictionary new];
                                
                                [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"STARTTIME"] forKey:@"STARTTIME"];
                                [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"FOODDIARYCODE"] forKey:@"FOODDIARYCODE"];
                                [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"MEALCODE"] forKey:@"MEALCODE"];
                                [mealLocationDict setObject:[[foodDiarys objectAtIndex:i] valueForKey:@"LOCATION"] forKey:@"LOCATION"];
                                [mealLocationDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                                [mealLocationDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                                
                                [mealLocationArray addObject:mealLocationDict];
                            }
                            self.saveOrUpdateBtn.hidden = YES;
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
            
            if (mealLocationArray.count) {
                for (id key in mealLocationArray) {
                    NSMutableDictionary *foodDescriptionDict = [NSMutableDictionary new];
                    [foodDescriptionDict setObject:[key valueForKey:@"FOOD"] forKey:@"FOOD"];
                    [foodDescriptionDict setObject:[key valueForKey:@"FOODQUANTITY"] forKey:@"FOODQUANTITY"];
                    [foodDescriptionArray addObject:foodDescriptionDict];
                }
                
                self.timeTF.text = [[mealLocationArray objectAtIndex:0] valueForKey:@"STARTTIME"];
                foodDiaryCode = [[mealLocationArray objectAtIndex:0] valueForKey:@"FOODDIARYCODE"];
                int mealCode = (int)[foodDiaryCodeArray indexOfObject:[[mealLocationArray objectAtIndex:0] valueForKey:@"MEALCODE"]];
                int locationCode = (int)[locationCodeArray indexOfObject:[[mealLocationArray objectAtIndex:0] valueForKey:@"LOCATION"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setBorderForMealType:mealCode+1];
                    [self setBorderForLocation:locationCode+1];
                    [self.foodTableView reloadData];
                });
            }
        }
        NSLog(@"foodDescriptionArray:%@", foodDescriptionArray);
        NSLog(@"mealLocationArray:%@", mealLocationArray);
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
            [self foodDiaryFetchDetailsPostMethodWebService];
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
            [self foodDiaryFetchDetailsPostMethodWebService];
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
            btn.layer.borderWidth = 2.0f;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
        } else {
            btn.layer.borderWidth = 0.0f;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
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
    
    self.saveOrUpdateBtn.hidden = NO;
    [self.saveOrUpdateBtn setTitle:@"Save" forState:UIControlStateNormal];
    selectedDate = @"";
    self.dateTF.text = @"";
    self.timeTF.text = @"";
    self.mealTypeTF = @"";
    [foodDescriptionArray removeAllObjects];
    self.locationTF = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.foodTableView reloadData];
        [self.foodDiaryCollectionView reloadData];
    });
    
    NSArray *arr = @[self.breakfastBtn,self.snacksBtn,self.lunchBtn,self.dinnerBtn,self.supplementsBtn, self.teamBtn,self.restaurantBtn,self.homeBtn,self.otherBtn];
    for (UIButton *btn in arr) {
        btn.layer.borderWidth = 0.0f;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

- (void)setClearForFoodDiaryDetails {
    
    self.saveOrUpdateBtn.hidden = NO;
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
