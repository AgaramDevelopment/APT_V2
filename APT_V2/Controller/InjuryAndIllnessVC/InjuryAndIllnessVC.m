//
//  InjuryAndIllnessVC.m
//  APT_V2
//
//  Created by MAC on 27/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "InjuryAndIllnessVC.h"
#import "InjuryAndIllnessCell.h"
#import "Config.h"
#import "Header.h"
#import "AppCommon.h"
#import "InjuryVC.h"
#import "IllnessTracker.h"

@interface InjuryAndIllnessVC () {
    NSString * clientCode ;
    NSString * userRefCode;
}

@end

@implementation InjuryAndIllnessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customnavigationmethod];
    // Do any additional setup after loading the view from its nib.
    
    clientCode = [AppCommon GetClientCode];
    userRefCode = [AppCommon GetuserReference];
    
    //FETCHLOADINJURYWEB
    [self fetchLoadInjuryPostMethodService];
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
    [self.navigationView addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden =NO;
    objCustomNavigation.menu_btn.hidden =YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionBack
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)injuriesAction:(id)sender {
    InjuryVC *injuryObj = [InjuryVC new];
    [self.navigationController pushViewController:injuryObj animated:YES];
}

- (IBAction)illnessAction:(id)sender {
    IllnessTracker *illnessObj = [IllnessTracker new];
    [self.navigationController pushViewController:illnessObj animated:YES];
}


- (void)fetchLoadInjuryPostMethodService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(fetchLoadInjury);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"ClientCode"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"Userreferencecode"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"Status"] integerValue] == 1) {
            
            injuryArray = [NSMutableArray new];
            injuryArray = [responseObject objectForKey:@"InjuryWebs"];
    
            [self fetchLoadIllnessPostMethodService];
        }
        
        [AppCommon hideLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
    
}
- (void)fetchLoadIllnessPostMethodService {
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
    NSString *URLString =  URL_FOR_RESOURCE(fetchLoadIllness);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(clientCode)   [dic    setObject:clientCode     forKey:@"ClientCode"];
    if(userRefCode)   [dic    setObject:userRefCode     forKey:@"Userreferencecode"];
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if ([[responseObject valueForKey:@"Status"] integerValue] == 1) {
            
            illnessArray = [NSMutableArray new];
            illnessArray = [responseObject objectForKey:@"illnessWebCruds"];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.injuryTableView reloadData];
                [self.illnessTableView reloadData];
            });
        }
        
        [AppCommon hideLoading];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
    
}

#pragma Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.injuryTableView) {
        return injuryArray.count;
    }
    
    if (tableView == self.illnessTableView) {
        return illnessArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InjuryAndIllnessCell *cell;
    
    if (tableView == self.injuryTableView) {
        static NSString *cellIdentifier = @"injuryCell";
        
      cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"InjuryAndIllnessCell" owner:self options:nil];
        cell = arr[0];
//        NSArray *commonArray = [injuryArray objectAtIndex:indexPath.row];
        if (injuryArray.count) {
            cell.injuryLbl.text = [[injuryArray objectAtIndex:indexPath.row] valueForKey:@"InjuryName"];
//            NSString *onSetDate = [[injuryArray objectAtIndex:indexPath.row] valueForKey:@"OnSetDate"];
//                // Instantiate a NSDateFormatter
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//                // Set the dateFormatter format
//            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//
//                // Get the date time in NSString
//            NSString *onSetDate1 = [dateFormatter stringFromDate:onSetDate];
            
//            cell.injuryDateLbl.text = onSetDate1;
            
            NSString *currentDate = [[injuryArray objectAtIndex:indexPath.row] valueForKey:@"OnSetDate"];
            NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
            [dateFormatters setDateFormat:@"MM/dd/yyyy"];
            NSDate *dates = [dateFormatters dateFromString:currentDate];
            
            NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
            [dfs setDateFormat:@"dd-MM-yyyy"];
            cell.injuryDateLbl.text  = [dfs stringFromDate:dates];
            
            
            
//            NSString *erdDate =  [[injuryArray objectAtIndex:indexPath.row] valueForKey:@"ExpectedDateOfRecovery"];
//
//                // Get the date time in NSString
//            NSString *erdDate1 = [dateFormatter stringFromDate:erdDate];
//
//            cell.injuryErdLbl.text = erdDate1;
            
            NSString *currentDate1 = [[injuryArray objectAtIndex:indexPath.row] valueForKey:@"ExpectedDateOfRecovery"];
            NSDateFormatter *dateFormatters1 = [[NSDateFormatter alloc] init];
            [dateFormatters1 setDateFormat:@"MM/dd/yyyy"];
            NSDate *dates1 = [dateFormatters1 dateFromString:currentDate1];
            
            NSDateFormatter* dfs1 = [[NSDateFormatter alloc]init];
            [dfs1 setDateFormat:@"dd-MM-yyyy"];
            cell.injuryErdLbl.text  = [dfs1 stringFromDate:dates1];
            
        }
    }
    
    if (tableView == self.illnessTableView) {
        static NSString *cellIdentifier = @"illnessCell";
        
        cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"InjuryAndIllnessCell" owner:self options:nil];
        cell = arr[1];
//        NSArray *commonArray = [illnessArray objectAtIndex:indexPath.row];
        if (injuryArray.count) {
            cell.illnessLbl.text = [[illnessArray objectAtIndex:indexPath.row] valueForKey:@"IllnessName"];
            
            
//                Date Format
            NSString *currentDate = [[illnessArray objectAtIndex:indexPath.row] valueForKey:@"DateofOnset"];
            NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
            [dateFormatters setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
            NSDate *dates = [dateFormatters dateFromString:currentDate];

            NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
            [dfs setDateFormat:@"dd-MM-yyyy"];
            NSString * ondateStr = [dfs stringFromDate:dates];
            cell.illnessDateLbl.text = ondateStr;
            
//            NSString *onSetDate = [[illnessArray objectAtIndex:indexPath.row] valueForKey:@"DateofOnset"];
//                // Instantiate a NSDateFormatter
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//                // Set the dateFormatter format
//            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//
//                // Get the date time in NSString
//            NSString *onSetDate1 = [dateFormatter stringFromDate:onSetDate];
//            cell.illnessDateLbl.text = onSetDate1;
            
            
            
//            NSString *erdDate =  [[illnessArray objectAtIndex:indexPath.row] valueForKey:@"ExpectedDateofRecovery"];
//
//                // Get the date time in NSString
//            NSString *erdDate1 = [dateFormatter stringFromDate:erdDate];
//            cell.illnessErdLbl.text = erdDate1;
            
            NSString *currentDate1 = [[illnessArray objectAtIndex:indexPath.row] valueForKey:@"ExpectedDateofRecovery"];
            NSDateFormatter *dateFormatters1 = [[NSDateFormatter alloc] init];
            [dateFormatters1 setDateFormat:@"MM/dd/yyyy"];
            NSDate *dates1 = [dateFormatters1 dateFromString:currentDate1];
            
            NSDateFormatter* dfs1 = [[NSDateFormatter alloc]init];
            [dfs1 setDateFormat:@"dd-MM-yyyy"];
             cell.illnessErdLbl.text  = [dfs1 stringFromDate:dates1];
            
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _injuryTableView) {
        
        InjuryVC *injuryObj = [InjuryVC new];
        injuryObj.InjuryListArray = [injuryArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:injuryObj animated:YES];

        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 45;
    } else {
        return 35;
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

@end
