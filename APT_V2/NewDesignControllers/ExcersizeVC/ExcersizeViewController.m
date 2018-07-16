//
//  ExcersizeViewController.m
//  AlphaProTracker
//
//  Created by user on 16/01/18.
//  Copyright © 2018 agaraminfotech. All rights reserved.
//

#import "ExcersizeViewController.h"
#import "ExcersizeCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "Config.h"
#import "WebService.h"
#import "CustomNavigation.h"
#import "AppCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ExcierseDetailVC.h"

@interface ExcersizeViewController ()
{
    NSMutableArray* arrayProgrammesList;
    NSMutableArray* arrayExcersizeList;
    NSMutableArray *arrResponse;
    
}

@end

@implementation ExcersizeViewController
@synthesize excersizeCollection;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [excersizeCollection registerNib:[UINib nibWithNibName:@"ExcersizeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"First"];
    [excersizeCollection registerNib:[UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Second"];
    [self customnavigationmethod];
    arrayExcersizeList = [NSMutableArray new];
    arrayProgrammesList = [NSMutableArray new];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self loadProgramWebService];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.excersizeCollection reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)customnavigationmethod
{
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    CustomNavigation * objCustomNavigation = [[CustomNavigation alloc] init];
    [self.topView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"";
    objCustomNavigation.btn_back.hidden =YES;
    objCustomNavigation.menu_btn.hidden = NO;
    objCustomNavigation.home_btn.hidden =YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(didClickbackBtn) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)didClickbackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionView Delegate 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    if ([[arrayExcersizeList valueForKey:@"lstExcercise_Details"] count] == 0) {
//        return  0;
//    }

    return arrayProgrammesList.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        if (arrayProgrammesList.count == 0) {
            return  0;
        }
    NSArray* resultArray = [self getValueSectionWise:[[arrayProgrammesList valueForKey:@"programcode"] objectAtIndex:section]:section];
    if (![resultArray isEqual:[NSNull null]]){
    return resultArray.count;
    }
    else
    {
        return  0;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        HeaderCollectionReusableView * cell = [excersizeCollection dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Second" forIndexPath:indexPath];
       // self.lblHeaderName.text = [[[arrayExcersizeList valueForKey:@"lstExcercise_programs"] objectAtIndex:indexPath.row]valueForKey:@"programName"];
        
        
        UILabel* label= [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
        label.text = [[arrayProgrammesList  objectAtIndex:indexPath.section] valueForKey:@"programName"];
        //label.text = @"ProgramName";
        [label setTextColor:[UIColor whiteColor]];
        [cell addSubview:label];
        

        UICollectionViewFlowLayout* lay1 = (UICollectionViewFlowLayout *)excersizeCollection.collectionViewLayout;
        lay1.sectionHeadersPinToVisibleBounds = YES;
        
        return cell;
        
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    ExcersizeCollectionViewCell* cell = [excersizeCollection dequeueReusableCellWithReuseIdentifier:@"First" forIndexPath:indexPath];
    
    NSString *sectionValue = [[arrayProgrammesList valueForKey:@"programcode"] objectAtIndex:indexPath.section];
    
    NSMutableArray *arraValues = [[arrayExcersizeList valueForKey:sectionValue] objectAtIndex:indexPath.section];
    
    NSString* strImg = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[arraValues objectAtIndex:indexPath.row]valueForKey:@"Clientcode"]];
   // NSString* strImg = @".pdf";

        if ([[AppCommon getFileType:strImg] isEqualToString:@"pdf"]) {
            [cell.imgView setImage:[UIImage imageNamed:@"pdf"]];
        }
        else if ([[AppCommon getFileType:strImg] isEqualToString:@"video"]){
            [cell.imgView setImage:[UIImage imageNamed:@"Video-Icon-crop"]];
        }
        else{
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"Default_userimage"]];
        }
    
    //[cell.imgView setImage:[UIImage imageNamed:@"Default_userimage"]];
    
    cell.lblExcersize.text = [[arraValues objectAtIndex:indexPath.row] valueForKey:@"ExcerciseName"];
    //cell.lblExcersize.text = @"dfgfd";
    cell.lblExcersize.textAlignment = UITextAlignmentCenter;
    
   

    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *sectionValue = [[arrayProgrammesList valueForKey:@"programcode"] objectAtIndex:indexPath.section];
    
    NSMutableArray *arraValues = [[arrayExcersizeList valueForKey:sectionValue] objectAtIndex:indexPath.section];
    
    //NSArray* array = [self getValueSectionWise:indexPath];
    ExcierseDetailVC* VC = [ExcierseDetailVC new];
    VC.ExcerciseCode = [[arraValues  valueForKey:@"ExcerciseCode"] objectAtIndex:indexPath.row];
    VC.ProgramCode = sectionValue;
    //[[arrayProgrammesList  objectAtIndex:indexPath.section] valueForKey:@"programcode"];
    VC.OrderNo = [[arraValues  valueForKey:@"OrderNo"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}

-(NSArray *)getValueSectionWise:(NSString *)prgCode :(NSInteger *)sec
{
    if (arrayExcersizeList.count == 0) {
        return  0;
    }
    NSArray *arr = [[arrayExcersizeList valueForKey:prgCode] objectAtIndex:sec];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProgramCode == %@",[arrayExcersizeList valueForKey:prgCode]];
//    NSArray *resultArray = [arrayExcersizeList  filteredArrayUsingPredicate:predicate];
    //[self loadExcerciseWebService:[arr valueForKey:@"programcode"]];
    return arr;
}

-(void)loadProgramWebService
{
    /*
     API URL : http://192.168.1.84:8029/AGAPTSERVICE.svc/GETALLPLAYERPROGRAMS
     METHOD : POST
     INPUT PARAMS :
     {
     "Clientcode":"CLI0000001",
     "UserCode":"USM0000012",
     "UserReferenceCode":"AMR0000011"
     }
     */
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"GETALLPLAYERPROGRAMS"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    
    //Clientcode,UserCode,UserReferenceCode
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if([AppCommon GetClientCode]) [dic setObject:[AppCommon GetClientCode] forKey:@"Clientcode"];
    if([AppCommon GetUsercode]) [dic setObject:[AppCommon GetUsercode] forKey:@"UserCode"];
    if([AppCommon GetuserReference]) [dic setObject:[AppCommon GetuserReference] forKey:@"UserReferenceCode"];
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        if(responseObject > 0)
        {
            arrayProgrammesList = [NSMutableArray new];
            arrayProgrammesList = [responseObject valueForKey:@"lstExcercise_programs"];
            
            [self SetExcersizes];
            
        }
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
    }];
    
}

-(void)SetExcersizes{
    
    arrayExcersizeList = [NSMutableArray new];
    arrResponse = [NSMutableArray new];
    for(int i=0;i<arrayProgrammesList.count;i++)
    {
            [self loadExcerciseWebService:[[arrayProgrammesList valueForKey:@"programcode"] objectAtIndex:i]];
    }
}

-(void)loadExcerciseWebService:(NSString *)ProgramCode
{
    /*
     API URL : http://192.168.1.84:8029/AGAPTSERVICE.svc/GETALLPLAYERPROGRAMS
     METHOD : POST
     INPUT PARAMS :
     {
     "Clientcode":"CLI0000001",
     "UserCode":"USM0000012",
     "UserReferenceCode":"AMR0000011"
     }
     */
//    if(![COMMON isInternetReachable])
//        return nil;
    
    [AppCommon showLoading];
    NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"OPENPLAYEREXERCISES"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    
    //Clientcode,UserCode,UserReferenceCode
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if([AppCommon GetClientCode]) [dic setObject:[AppCommon GetClientCode] forKey:@"Clientcode"];
    if([AppCommon GetUsercode]) [dic setObject:[AppCommon GetUsercode] forKey:@"UserCode"];
    if([AppCommon GetuserReference]) [dic setObject:[AppCommon GetuserReference] forKey:@"UserReferenceCode"];
    if(ProgramCode) [dic setObject:ProgramCode forKey:@"ProgramCode"];
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        if(responseObject > 0)
        {
            
//            arrResponse = responseObject ;
//            NSMutableDictionary *dic = [NSMutableDictionary new];
//            [dic setObject:arr forKey:ProgramCode];
            
            
            NSArray *arr = [responseObject valueForKey:@"lstExcercise_Details"];
            if(arr.count>0)
            {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setObject:arr forKey:ProgramCode];
                [arrayExcersizeList addObject:dic];
                //[arrayExcersizeList addObjectsFromArray:arr];
                
            }
            
            if(arrayExcersizeList.count == arrayProgrammesList.count)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.excersizeCollection reloadData];
                });
            }
            

            
        }
        [AppCommon hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
    }];
    
    
    
}




@end
