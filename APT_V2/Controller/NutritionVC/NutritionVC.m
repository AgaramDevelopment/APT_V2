//
//  NutritionVC.m
//  APT_V2
//
//  Created by MAC on 21/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "NutritionVC.h"
#import "NutritionCell.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "Config.h"
#import "AppCommon.h"
#import "WebService.h"

@interface NutritionVC () {
    NSString *clientCode;
    NSString *userCode;
    NSString *userRefCode;
    NSMutableArray *foodDiaryArray;
    NSMutableArray *foodDiaryCodeArray;
//    UIPopoverController *popOverController;
}

@end

@implementation NutritionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self customnavigationmethod];
    
    [self.nutritionCollectionView registerNib:[UINib nibWithNibName:@"NutritionCell" bundle:nil] forCellWithReuseIdentifier:@"nutritionCell"];
    /*
     MSC342    BREAKFAST
     MSC343    SNACK
     MSC344    LUNCH
     MSC345    DINNER
*/
    foodDiaryCodeArray = [[NSMutableArray alloc] initWithObjects:@"MSC342", @"MSC343", @"MSC344", @"MSC345", @"MSC412", nil];
    
        //Fetch Service Call
    [self foodDiaryFetchDetailsPostMethodWebService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NutritionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nutritionCell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = 0.8f;
    
        //    cell.tag=indexPath.item;
        //    [cell.breakfastBtn addTarget:self action:@selector(didClickBreakfastMore:) forControlEvents:UIControlEventTouchUpInside];
        //    [cell.snacksBtn addTarget:self action:@selector(didClickSnacksMore:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     MSC342    BREAKFAST
     MSC343    SNACK
     MSC344    LUNCH
     MSC345    DINNER
     MSC412    Supplements
     */
    /*
    if ([[[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"MEALCODE"] isEqualToString:@"MSC342"]) {
        
        NSMutableArray *foodListArray = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"FOODLIST"];
        cell.breakfastTimeLbl.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"STARTTIME"];
            //    cell.mealNameLbl.text = [[foodDiaryArray objectAtIndex:indexPath.row] valueForKey:@"MEALNAME"];
        if (foodListArray.count == 1) {
            cell.breakfast1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
            cell.breakfast2Lbl.text = @"";
            cell.breakfast3Lbl.text = @"";
        } else if (foodListArray.count == 2) {
            cell.breakfast1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
            cell.breakfast2Lbl.text = [[foodListArray objectAtIndex:1] valueForKey:@"FOOD"];
            cell.breakfast3Lbl.text = @"";
        } else if (foodListArray.count == 3) {
            cell.breakfast1Lbl.text = [[foodListArray objectAtIndex:0] valueForKey:@"FOOD"];
            cell.breakfast2Lbl.text = [[foodListArray objectAtIndex:1] valueForKey:@"FOOD"];
            cell.breakfast3Lbl.text = [[foodListArray objectAtIndex:2] valueForKey:@"FOOD"];
        }
    }
    */
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD) {
        return CGSizeMake(200, 650);
    } else {
        return CGSizeMake(200, 650);
    }
}

-(IBAction)didClickBreakfastMore:(id)sender
{
//    NutritionCell *cell = (NutritionCell *)[self.nutritionCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[sender tag] inSection:0]];
//    CGRect rect = CGRectMake(cell.bounds.origin.x+600, cell.bounds.origin.y+10, 50, 30);
//    [popOverController presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [self.popView setModalPresentationStyle:UIModalPresentationPopover];
    
//    UIPopoverPresentationController *popPresenter =  [[UIPopoverPresentationController alloc] init];
        //(UIPopoverPresentationController *)self.popView;
//    popPresenter.sourceView = sender;
//    popPresenter.sourceRect = [sender bounds]; // You can set position of popover
    [self presentViewController:self.popView  animated:TRUE completion:nil];

}

-(IBAction)didClickSnacksMore:(id)sender
{
//    NutritionCell *cell = (NutritionCell *)[self.nutritionCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[sender tag] inSection:0]];
        //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    CGRect rect = CGRectMake(cell.bounds.origin.x+600, cell.bounds.origin.y+10, 50, 30);
//    [popOverController presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    if (IS_IPAD) {
        NutritionVC *PopoverView =[[NutritionVC alloc] initWithNibName:@"NutritionVC" bundle:nil];
        self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
        [self.popOver presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        NutritionVC *PopoverView =[[NutritionVC alloc] initWithNibName:@"NutritionVC" bundle:nil];
        self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
        [self.popOver presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
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
            
            
            NSMutableArray *resultArray = [responseObject objectForKey:@"FOODDIARYS"];
            NSMutableArray *filteredArray = [NSMutableArray new];
            for (int i=0; i<resultArray.count; i++) {
                NSArray *filteredData = [resultArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(DATE contains[c] %@)", [[resultArray objectAtIndex:i] valueForKey:@"DATE"]]];
                
                [filteredArray addObject:filteredData];
                NSLog(@"filteredData:%d:%@", i, filteredData);
            }
            
            foodDiaryArray = [NSMutableArray new];
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:filteredArray];
            foodDiaryArray = (NSMutableArray *)[orderedSet array];
            NSLog(@"arrayWithoutDuplicates:%@", foodDiaryArray);
            NSLog(@"count:%lu", (unsigned long)foodDiaryArray.count);
        }
        
        [AppCommon hideLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
