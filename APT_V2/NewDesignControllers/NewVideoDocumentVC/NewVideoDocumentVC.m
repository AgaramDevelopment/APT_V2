//
//  NewVideoDocumentVC.m
//  APT_V2
//
//  Created by MAC on 08/06/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "NewVideoDocumentVC.h"
#import "VideoPlayerViewController.h"
#import "Config.h"
#import "AppCommon.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "VideoPlayerUploadVC.h"
#import "WebService.h"
#import "VideoGalleryUploadCell.h"

@interface NewVideoDocumentVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,videoUploadDelegate,selectedDropDown>
{
    VideoPlayerViewController * videoPlayerVC;
    WebService * objWebService;
    BOOL isCategory;
    NSString* selectedTeamCode,*selectedPlayerCode;
    NSInteger* selectedButtonTag;
    UIDatePicker * datePicker;
}

@property (nonatomic,strong) NSMutableArray * CommonArray;
@property (nonatomic,strong) NSMutableArray * objFirstGalleryArray;
@property (nonatomic,strong) NSMutableArray * objSecondGalleryArray;
@property (nonatomic,strong) NSMutableArray * objCatoryArray;
@property (nonatomic,strong) NSMutableArray * objVideoFilterArray;

@end

@implementation NewVideoDocumentVC

@synthesize tableMainView,tbl_list,lblNovideo, lblcategory, btnCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    
    objWebService = [[WebService alloc]init];
    
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
    self.dateTF.inputAccessoryView = toolbar;
    
    lblcategory.text = @"BATTING";
    [self videoDocumentWebservice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) doneButtonAction {
    [self.view endEditing:true];
}

-(void) cancelButtonAction {
    
    self.dateTF.text = @"";
    [self.dateTF resignFirstResponder];
    [self.view endEditing:true];
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

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation;
    
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    [self.headerView addSubview:objCustomNavigation.view];
    objCustomNavigation.tittle_lbl.text=@"VideoDocument";
    objCustomNavigation.btn_back.hidden = YES;
    objCustomNavigation.home_btn.hidden = YES;
    objCustomNavigation.menu_btn.hidden =NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)UploadVideoAction:(id)sender {
    
    VideoPlayerUploadVC *VC = [VideoPlayerUploadVC new];
    VC.titleString = @"Documents";
//    VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [VC.view setBackgroundColor:[UIColor clearColor]];
//    [appDel.frontNavigationController presentViewController:VC animated:YES completion:nil];
    
    [appDel.frontNavigationController pushViewController:VC animated:YES];
}

- (IBAction)showFilter:(id)sender {
    
    [tableMainView setHidden:NO];
    selectedButtonTag = [sender tag];
    
    if([sender tag] == 1) // Category
    {
        NSArray* typeArray = @[@{@"category":@"BATTING"},@{@"category":@"BOWLING"}];
        _CommonArray = typeArray;
        
        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnCategory.superview.frame), 0, CGRectGetWidth(btnCategory.superview.frame), 50*_CommonArray.count)];
    }

    [tbl_list reloadData];
    
}

- (IBAction)dateButtonTapped:(id)sender {
    
    [self DisplaydatePickerForVideoGallery];
}

-(void)DisplaydatePickerForVideoGallery
{
    datePicker.datePickerMode = UIDatePickerModeDate;
    self.dateTF.inputView = datePicker;
    [datePicker addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventValueChanged];
    [self.dateTF addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventEditingDidBegin];
    [self.dateTF becomeFirstResponder];
}

- (void) displaySelectedDateAndTime:(UIDatePicker*)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //   2016-06-25 12:00:00
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    [datePicker reloadInputViews];
    self.dateTF.text = [dateFormatter stringFromDate:[datePicker date]];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        //return self.commonArray.count;
    if(collectionView == self.videoCollectionview1)
        {
        return self.objFirstGalleryArray.count;
        }
    else
        {
            //        return self.objVideoFilterArray.count;
        
        [lblNovideo setHidden:self.objFirstGalleryArray.count];
        
        return self.objFirstGalleryArray.count;
        
        }
}

#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = collectionView.frame.size.width;
        //    CGFloat height = collectionView.frame.size.height;
    
    if(IS_IPHONE5) {
        
        width = width/3;
    }
    else if(!IS_IPAD && !IS_IPHONE5) {
        
        width = width/4;
    }
    else if(IS_IPAD) {
        
        width = width/5;
    }
    
    return CGSizeMake(width-20, width-20);
    
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView==self.videoCollectionview2)
        {
        VideoGalleryUploadCell* cell = [self.videoCollectionview2 dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        cell.contentView.layer.cornerRadius = 2.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        NSString * videoDetailStr = [[self.objFirstGalleryArray valueForKey:@"videoFile"] objectAtIndex:indexPath.row];
        
        cell.batting_lbl.text = [[self.objFirstGalleryArray valueForKey:@"videoName"] objectAtIndex:indexPath.row];
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        
        return cell;
        }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * selectvideoStr;
    if (videoPlayerVC != nil) {
        
    }
    
    if(collectionView == self.videoCollectionview1)
        {
        selectvideoStr = [[self.objFirstGalleryArray valueForKey:@"videoFile"]objectAtIndex:indexPath.row];
        }
    else if(collectionView == self.videoCollectionview2)
        {
        selectvideoStr = [[self.objFirstGalleryArray valueForKey:@"videoFile"]objectAtIndex:indexPath.row];
        }
    
    videoPlayerVC = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" bundle:nil];
    videoPlayerVC.objSelectVideoLink = selectvideoStr;
    [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.CommonArray count];    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"CategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    
    cell.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:26.0/255.0 blue:68.0/255.0 alpha:0.5];
    cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:(IS_IPAD ? 13.0 : 13.0 )];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.numberOfLines = 2;
    
    if (selectedButtonTag == 1) {
        
        cell.textLabel.text = [[self.CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedButtonTag == 1) {
        lblcategory.text = [[self.CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];
    }
}

- (void) videoDocumentWebservice {
    
    
    if(![COMMON isInternetReachable])
        return;
    
//    NSString *URLString =  URL_FOR_RESOURCE(GalleryVideo);
    NSString *URLString = @"http://192.168.0.154:8029/AGAPTService.svc/MOBILE_DOCUMENTFILEGALLERY";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    selectedTeamCode = [AppCommon getCurrentTeamCode];
    selectedPlayerCode = [AppCommon GetuserReference];
    
    if(selectedTeamCode)   [dic    setObject:selectedTeamCode     forKey:@"TeamCode"];
    if(selectedPlayerCode)   [dic    setObject:selectedPlayerCode     forKey:@"PlayerCode"];
//    if(lblType.text)   [dic    setObject:lblType.text     forKey:@"keyWords"];
    if(lblcategory.text )   [dic    setObject:lblcategory.text     forKey:@"CategoryCode"];
    [dic    setObject:@""  forKey:@"keyWords"];
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
            {
            self.objFirstGalleryArray =[[NSMutableArray alloc]init];
            self.objSecondGalleryArray = [[NSMutableArray alloc]init];
            self.objCatoryArray = [[NSMutableArray alloc]init];
            self.objVideoFilterArray = [[NSMutableArray alloc]init];
//            self.objFirstGalleryArray =[responseObject valueForKey:@"Firstlist"];
//            self.objSecondGalleryArray =[responseObject valueForKey:@"Secondlist"];
//            self.objCatoryArray = [responseObject valueForKey:@"Thirdlist"];
//
//            self.CommonArray = [[NSMutableArray alloc]init];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:@"ALL" forKey:@"CategoryName"];
//            [self.CommonArray addObject:dic];
//
//            for(int i=0;i<self.objCatoryArray.count;i++)
//                {
//                [self.CommonArray addObject:[self.objCatoryArray objectAtIndex:i]];
//                }
//
//            self.objVideoFilterArray =  self.objSecondGalleryArray;
//
//            [self.videoCollectionview1 reloadData];
//            [self.videoCollectionview2 reloadData];
            
            }
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}

@end
