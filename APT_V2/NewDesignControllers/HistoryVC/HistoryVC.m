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

@interface HistoryVC ()<selectedDropDown,UISearchBarDelegate>
{
    NSString *changedText;
}


@property (strong, nonatomic)  NSMutableArray *listHistory;
@property (strong, nonatomic)  NSMutableArray *mainArray;
@property (strong, nonatomic)  NSMutableArray *listModule;
@property (nonatomic, strong) NSArray *searchResult;
@property (strong, nonatomic) IBOutlet UITextField *search_Txt;


@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listHistory = [[NSMutableArray alloc]init];
    self.listModule = [[NSMutableArray alloc]init];
    
    [self Dropdownwebservice];
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    self.searchViewWidth.constant = 0;
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
        
        
        NSString *dateString = [self checkNull:[[self.listHistory valueForKey:@"Assessmentdate"] objectAtIndex:indexPath.row]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:dateString];


        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd-MM-yyyy"];
        NSString *stringDate = [dateFormatter1 stringFromDate:dateFromString];
        NSLog(@"%@", stringDate);
      
        cell.lblDate.text = stringDate;
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
                    
                    self.mainArray = [[NSMutableArray alloc]init];
                    self.mainArray = self.listHistory;
                    
                    self.search_Txt.text = @"";
                [self.tblHistory reloadData];
                }
                else
                {
                    self.listHistory = [[NSMutableArray alloc]init];
                    self.search_Txt.text = @"";
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
                    //self.searchViewWidth.constant = 0;
                    self.search_Txt.hidden =YES;
                    self.searchBtn.hidden = NO;
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
    
    self.search_Txt.hidden = YES;
    self.searchBtn.hidden = NO;
    
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


#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Assessmentname CONTAINS[c] %@ OR Modulename CONTAINS[c] %@ OR Assessmentdate CONTAINS[c] %@", searchText,searchText,searchText];
    _searchResult = [self.mainArray filteredArrayUsingPredicate:resultPredicate];
    
    NSLog(@"searchResult:%@", _searchResult);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        if (_searchResult.count == 0) {
            self.listHistory = [self.searchResult copy];
            [self.tblHistory reloadData];
            
        } else {
            
            self.listHistory =[[NSMutableArray alloc]init];
            self.listHistory = [self.searchResult copy];
            
            [self.tblHistory reloadData];
            
        }
    });
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //self.playerTbl.hidden = NO;
    
    return YES;
}
-(BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
   
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    //self.playerTbl.hidden = NO;
//    NSLog(@"%@",textField);
//    NSString *searchString = [NSString stringWithFormat:@"%@%@",textField.text, string];
//
////    if (self.search_Txt.text.length!=1)
////    {
////        [self filterContentForSearchText:searchString];
////    }
////    else
////    {
////        self.listHistory = [[NSMutableArray alloc]init];
////        self.listHistory =  self.mainArray;
////
////        [self.tblHistory reloadData];
////
////    }
//
//    if (self.search_Txt.text.length==0 || self.search_Txt.text.length == nil)
//    {
//        self.listHistory = [[NSMutableArray alloc]init];
//        self.listHistory =  self.mainArray;
//
//        [self.tblHistory reloadData];
//    }
//    else
//    {
//        [self filterContentForSearchText:searchString];
//    }
//
//    //[self filterContentForSearchText:searchString];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // Update the UI
//        [self.tblHistory reloadData];
//    });
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateTextLabelsWithText: newString];
    
    changedText = newString;
    
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
   // [self.search_Txt setText:string];
    NSLog(@"@%",string);
    
        if (string.length==0 || string.length == nil)
        {
            self.listHistory = [[NSMutableArray alloc]init];
            self.listHistory =  self.mainArray;
    
            [self.tblHistory reloadData];
        }
        else
        {
            [self filterContentForSearchText:string];
        }
    
        //[self filterContentForSearchText:searchString];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.tblHistory reloadData];
        });
}

-(void)textFieldDidChange :(UITextField *) textField
{
    if (changedText.length==0 || changedText.length == nil)
    {
        self.listHistory = [[NSMutableArray alloc]init];
        self.listHistory =  self.mainArray;
        
        [self.tblHistory reloadData];
    }
    else
    {
        [self filterContentForSearchText:changedText];
    }
    
    //[self filterContentForSearchText:searchString];
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        [self.tblHistory reloadData];
    });

}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.videoCollectionview2 reloadData];
    });
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    
    [textField resignFirstResponder];
}


- (IBAction)SearchBtnAction:(id)sender {
    
    self.search_Txt.hidden = NO;
    self.searchBtn.hidden = YES;
}


@end
