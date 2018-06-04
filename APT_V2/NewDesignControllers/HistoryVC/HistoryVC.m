//
//  HistoryVC.m
//  APT_V2
//
//  Created by Apple on 02/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "HistoryVC.h"
#import "PlayerDetailTableViewCell.h"
#import "AppCommon.h"
#import "Config.h"
#import "WebService.h"
#import "DropDownTableViewController.h"

@interface HistoryVC ()<selectedDropDown>

@property (strong, nonatomic)  NSMutableArray *listHistory;
@property (strong, nonatomic)  NSMutableArray *listModule;

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listHistory = [[NSMutableArray alloc]init];
    self.listModule = [[NSMutableArray alloc]init];
   
   // [self HistoryWebservice];
    [self Dropdownwebservice];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listHistory.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    PlayerDetailTableViewCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"PlayerDetailTableViewCell" owner:self options:nil];
    if (!tableView.tag) {
        cell = array[0];
    }
    else
    {
        cell = array[2];
    }
    
    
    return cell;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Plannerlistcell";
    
    
    PlayerDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Content"];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"PlayerDetailTableViewCell" owner:self options:nil];
    if (!tableView.tag) {
        
    }
    else
    {
        cell = array[3];
        
        cell.lblModuleName.text = [self checkNull:[[self.listHistory valueForKey:@"Modulename"] objectAtIndex:indexPath.row]];
        cell.lblAssessmentName.text = [self checkNull:[[self.listHistory valueForKey:@"Assessmentname"] objectAtIndex:indexPath.row]];
        cell.lblDate.text = [self checkNull:[[self.listHistory valueForKey:@"Assessmentdate"] objectAtIndex:indexPath.row]];
    }
    
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}
- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}


-(void)HistoryWebservice
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",@"PageloadSandcreport"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
//        NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
       
        NSString *Module= [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedModuleCode"];
        self.moduleLbl.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedModuleName"];
       
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
        if(Module)   [dic    setObject:Module     forKey:@"Modulecode"];
        
        
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                if( ![[responseObject valueForKey:@"LstHistoryDetails"] isEqual:[NSNull null]])
                {
                self.listHistory = [[NSMutableArray alloc]init];
                self.listHistory = [self checkNull:[responseObject valueForKey:@"LstHistoryDetails"]];
                [self.tblHistory reloadData];
                }
                else
                {
                    self.listHistory = [[NSMutableArray alloc]init];
                    [self.tblHistory reloadData];
                }
                
            }
            
            [AppCommon hideLoading];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
            
        }];
    }
    
}

-(void)Dropdownwebservice
{
    
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",@"FETCHASSESSMENTENTRY"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
                NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
        
        NSString *Module=@"MSC084";
        
        NSString *createdby = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
        
        
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
        if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"Userreferencecode"];
        if(Module)   [dic    setObject:Module     forKey:@"Module"];
        if(createdby)   [dic    setObject:createdby     forKey:@"Createdby"];
        
        
        
       
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                if( ![[responseObject valueForKey:@"lstAssessmentEntryModule"] isEqual:[NSNull null]])
                {
                    self.listModule = [[NSMutableArray alloc]init];
                    self.listModule = [self checkNull:[responseObject valueForKey:@"lstAssessmentEntryModule"]];
                    //[self.tblHistory reloadData];
                    [self HistoryWebservice];
                }
                
            }
            
            [AppCommon hideLoading];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
            [COMMON webServiceFailureError:error];
            
            
        }];
    }
    
}

-(IBAction)didClickModule:(id)sender
{
    
    
    
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
   
        dropVC.array = self.listModule;
        dropVC.key = @"ModuleName";
    
    int count = self.listModule.count * 100;
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(self.v1.frame), CGRectGetMaxY(self.v1.frame)+110, CGRectGetWidth(self.v1.frame), count)];

    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
        NSLog(@"DropDown loaded");
    }];
    
}

-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    
    if ([key  isEqualToString: @"ModuleName"]) {
        
        self.moduleLbl.text = [[array objectAtIndex:Index.row] valueForKey:key];
        NSString* modulecode = [[array objectAtIndex:Index.row] valueForKey:@"Module"];
        
        [[NSUserDefaults standardUserDefaults] setValue:modulecode forKey:@"SelectedModuleCode"];
        [[NSUserDefaults standardUserDefaults] setValue:self.moduleLbl.text forKey:@"SelectedModuleName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self HistoryWebservice];
    }
        
    
}


@end
