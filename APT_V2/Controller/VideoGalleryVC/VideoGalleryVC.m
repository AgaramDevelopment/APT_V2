//
//  VideoGalleryVC.m
//  APT_V2
//
//  Created by Apple on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "VideoGalleryVC.h"
#import "Config.h"
#import "AppCommon.h"
#import "HomeScreenStandingsVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "VideoGalleryCell.h"
#import "VideoGalleryUploadCell.h"
#import "VideoPlayerViewController.h"
#import "VideoPlayerUploadVC.h"
#import "WebService.h"
#import "SchResStandVC.h"


@interface VideoGalleryVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,videoUploadDelegate,selectedDropDown>
{
    VideoPlayerViewController * videoPlayerVC;
    WebService * objWebService;
    BOOL isCategory;
    NSString* selectedTeamCode,*selectedPlayerCode;
    NSInteger* selectedButtonTag;
    UIDatePicker * datePicker;
}

@property (nonatomic,strong) NSMutableArray * objFirstGalleryArray;
@property (nonatomic,strong) NSMutableArray * objSecondGalleryArray;
@property (nonatomic,strong) NSMutableArray * objCatoryArray;
@property (nonatomic,strong) NSMutableArray * objVideoFilterArray;

@property (nonatomic,strong) NSMutableArray * CommonArray;

@property (nonatomic,strong) IBOutlet UITableView * categoryTbl;
@property (nonatomic,strong) IBOutlet UILabel * catagory_lbl;
@property (nonatomic,strong) IBOutlet UILabel * date_lbl;
@property (nonatomic,strong) IBOutlet UITextField * search_Txt;
@property (nonatomic, strong) NSArray *searchResult;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic,strong) IBOutlet UIView * view_datepicker;


@end

@implementation VideoGalleryVC

@synthesize btnUpload,dropdownView;

@synthesize btnTeam,btnPlayer,btnType,btnCategory;

@synthesize lblTeam,lblPlayer,lblType,lblcategory;

@synthesize tableMainView,tbl_list,lblNovideo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!appDel.ArrayIPL_teamplayers.count) {
        [AppCommon getTeamAndPlayerCode];
    }

    
    objWebService = [[WebService alloc]init];
    
    
    [self.videoCollectionview1 registerNib:[UINib nibWithNibName:@"VideoGalleryCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    [self.videoCollectionview2 registerNib:[UINib nibWithNibName:@"VideoGalleryUploadCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    self.categoryTbl.layer.borderColor = [UIColor brownColor].CGColor;
    self.categoryTbl.layer.borderWidth = 1.0;
    self.categoryTbl.layer.masksToBounds = YES;
    
    self.categoryTbl.layer.cornerRadius = 10;
    self.categoryTbl.layer.masksToBounds =YES;
    
    self.categoryTbl.hidden= YES;
    self.CancelTextImg.hidden = NO;
    self.clearBtn.hidden = NO;
//    [self.view_datepicker setHidden:YES];
    
//    [btnUpload setHidden:![AppCommon isCoach]];
    
    lblTeam.text = @"KKR";
    lblPlayer.text = @"Chris Lynn";
    lblcategory.text = @"BATTING";
    lblType.text = @"BEATEN&UNCOMFORT";
//    [self newVideoListingwebservice];
     [self videoGalleryWebservice];
    
//    view

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
    objCustomNavigation.tittle_lbl.text=@"VideoGallery";
    objCustomNavigation.btn_back.hidden = YES;
    objCustomNavigation.home_btn.hidden = YES;
    objCustomNavigation.menu_btn.hidden =NO;
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)showAnimate
{
    self.categoryTbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.categoryTbl.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.categoryTbl.alpha = 1;
        self.categoryTbl.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.categoryTbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.categoryTbl.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            // [self.popTblView removeFromSuperview];
            self.categoryTbl.hidden = YES;
        }
    }];
}

-(NSArray *)getCorrespoingPlayerForthisTeamCode:(NSString* )teamCode
{
    NSArray* result;
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"TeamCode == %@", teamCode];
    result = [appDel.ArrayIPL_teamplayers filteredArrayUsingPredicate:resultPredicate];
    
    return result;
}


-(void)videoGalleryWebservice
{
    
    
    if(![COMMON isInternetReachable])
        return;
    
    NSString *URLString =  URL_FOR_RESOURCE(GalleryVideo);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"clientCode"];
//    if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"Userreferencecode"];
//    if(usercode)   [dic    setObject:usercode     forKey:@"Usercode"];

    /*
    if (selectedTeamCode == nil) {
        [AppCommon showAlertWithMessage:@"Please select Team"];
        return;
    }
    else if (selectedPlayerCode == nil) {
        [AppCommon showAlertWithMessage:@"Please select Player"];
        return;
    }
    else if ([lblType.text isEqualToString:@"Type"]) {
        [AppCommon showAlertWithMessage:@"Please select type"];
        return;
    }
    else if ([lblType.text isEqualToString:@"category"]) {
        [AppCommon showAlertWithMessage:@"Please select Category"];
        return;
    }
    */
    selectedTeamCode = [AppCommon getCurrentTeamCode];
    selectedPlayerCode = [AppCommon GetuserReference];
    
    if(lblTeam.text)   [dic    setObject:selectedTeamCode     forKey:@"TeamCode"];
    if(selectedPlayerCode)   [dic    setObject:selectedPlayerCode     forKey:@"PlayerCode"];
    if(lblType.text)   [dic    setObject:lblType.text     forKey:@"keyWords"];
    if(lblcategory.text )   [dic    setObject:lblcategory.text     forKey:@"CategoryCode"];

    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            self.objFirstGalleryArray =[[NSMutableArray alloc]init];
            self.objSecondGalleryArray = [[NSMutableArray alloc]init];
            self.objCatoryArray = [[NSMutableArray alloc]init];
            self.objVideoFilterArray = [[NSMutableArray alloc]init];
            self.objFirstGalleryArray =[responseObject valueForKey:@"Firstlist"];
            self.objSecondGalleryArray =[responseObject valueForKey:@"Secondlist"];
            self.objCatoryArray = [responseObject valueForKey:@"Thirdlist"];
            
            self.CommonArray = [[NSMutableArray alloc]init];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:@"ALL" forKey:@"CategoryName"];
            [self.CommonArray addObject:dic];
            
            for(int i=0;i<self.objCatoryArray.count;i++)
            {
                [self.CommonArray addObject:[self.objCatoryArray objectAtIndex:i]];
            }
        
            self.objVideoFilterArray =  self.objSecondGalleryArray;
                
            [self.videoCollectionview1 reloadData];
            [self.videoCollectionview2 reloadData];
        
        }
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}


- (IBAction)UploadVideoAction:(id)sender {
    
    VideoPlayerUploadVC *VC = [VideoPlayerUploadVC new];
    VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [VC.view setBackgroundColor:[UIColor clearColor]];
    [appDel.frontNavigationController presentViewController:VC animated:YES completion:nil];
    
//    [appDel.frontNavigationController pushViewController:VC animated:YES];
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

    
//    if(IS_IPHONE_DEVICE)
//    {
//        if(!IS_IPHONE5)
//        {
//            return CGSizeMake(50, 50);
//        }
//        else
//        {
//            if(collectionView == self.videoCollectionview1)
//            {
//                return CGSizeMake(224, 135);
//            }
//            else
//            {
//                return CGSizeMake(120, 180);
//            }
//        }
//    }
//    else
//    {
//        //return CGSizeMake(160, 140);
//
//        if(collectionView == self.videoCollectionview1)
//        {
//            return CGSizeMake(224, 135);
//        }
//        else
//        {
//            return CGSizeMake(150, 122);
//        }
//    }
    
    
    
    //return UICollectionViewFlowLayoutAutomaticSize;
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if(!IS_IPHONE_DEVICE)
//    {
//        return UIEdgeInsetsMake(15, 15, 25, 15); // top, left, bottom, right
//    }
//    else{
//        return UIEdgeInsetsMake(10, 10, 10, 10);
//    }
    
    return UIEdgeInsetsMake(10, 10, 10, 10);

}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if(!IS_IPHONE_DEVICE)
//    {
//        return 10.0;
//    }
//    else{
//        return 10.0;
//    }
    
    return 10.0;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if(!IS_IPHONE_DEVICE)
//    {
//        return 23.0;
//    }
//    else{
//        return 10.0;
//    }
    
    return 10.0;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if(collectionView==self.videoCollectionview1)
//    {
//
//        VideoGalleryCell* cell = [self.videoCollectionview1 dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//
//        cell.contentView.layer.cornerRadius = 2.0f;
//        cell.contentView.layer.borderWidth = 1.0f;
//        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
//        cell.contentView.layer.masksToBounds = YES;
//
//        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
//        cell.layer.shadowRadius = 2.0f;
//        cell.layer.shadowOpacity = 1.0f;
//        cell.layer.masksToBounds = NO;
//        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
//        NSString * videoDetailStr = [[self.objFirstGalleryArray valueForKey:@"videoName"] objectAtIndex:indexPath.row];
//        NSArray *component3 = [videoDetailStr componentsSeparatedByString:@" "];
//
//        cell.playername_lbl.text =  [NSString stringWithFormat:@"%@",component3[0]];
//        cell.batting_lbl.text =  [NSString stringWithFormat:@"%@",component3[1]];
//        cell.date_lbl.text =  [NSString stringWithFormat:@"%@",component3[2]];
//        return cell;
//    }
    
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
//        NSArray *component3 = [videoDetailStr componentsSeparatedByString:@" "];
        
//        cell.playername_lbl.text =  [NSString stringWithFormat:@"%@",component3[0]];
//        if ([[AppCommon checkNull:[[self.objFirstGalleryArray valueForKey:@"videoFile"] objectAtIndex:indexPath.row]] isEqualToString:@""]) {
//
//
//        }
        
        cell.batting_lbl.text = [[self.objFirstGalleryArray valueForKey:@"videoName"] objectAtIndex:indexPath.row];
//        cell.date_lbl.text =  [NSString stringWithFormat:@"%@",component3[2]];
        
//        if (indexPath.row % 2 == 1) {
//
            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        }
//        else {
//            cell.layer.shadowColor = [UIColor redColor].CGColor;
//        }
        

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
    
//    ScoreCardVideoPlayer * videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
//    videoPlayerVC = (ScoreCardVideoPlayer *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
//    videoPlayerVC.isFromHome = YES;
//    videoPlayerVC.HomeVideoStr = selectvideoStr;
//    NSLog(@"appDel.frontNavigationController.topViewController %@",appDel.frontNavigationController.topViewController);
//    [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];

    
    videoPlayerVC = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" bundle:nil];
    videoPlayerVC.objSelectVideoLink = selectvideoStr;
    [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];
    
}

-(IBAction)didClickcategoryPopView:(id)sender
{
    if(isCategory == NO)
    {
        self.categoryTbl.hidden = NO;
        isCategory = YES;
        [self showAnimate];
        [self.categoryTbl reloadData];
    }
    else
    {
        self.categoryTbl.hidden = YES;
        isCategory = NO;
        [self removeAnimate];
    }
    
}

-(IBAction)didClickDatePicker:(id)sender
{
    [self DisplaydatePicker];
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

    if (selectedButtonTag == 0) {
        cell.textLabel.text = [[self.CommonArray valueForKey:@"TeamName"] objectAtIndex:indexPath.row];

    }
    else if (selectedButtonTag == 1) {
        
        cell.textLabel.text = [[self.CommonArray valueForKey:@"PlayerName"] objectAtIndex:indexPath.row];

    }
    else if (selectedButtonTag == 2) {
        
        cell.textLabel.text = [[self.CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];

    }
    else if (selectedButtonTag == 3) {
        
        cell.textLabel.text = [[self.CommonArray valueForKey:@"type"] objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectedButtonTag == 0) {
        lblTeam.text = [[self.CommonArray valueForKey:@"TeamName"] objectAtIndex:indexPath.row];
        selectedTeamCode = [[self.CommonArray valueForKey:@"TeamCode"] objectAtIndex:indexPath.row];
        lblPlayer.text = @"Player";
    }
    else if (selectedButtonTag == 1) {
        
        lblPlayer.text = [[self.CommonArray valueForKey:@"PlayerName"] objectAtIndex:indexPath.row];
        selectedPlayerCode = [[self.CommonArray valueForKey:@"PlayerCode"] objectAtIndex:indexPath.row];
    }
    else if (selectedButtonTag == 2) {
        
        lblcategory.text = [[self.CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];
    }
    else if (selectedButtonTag == 3) {
        
        lblType.text = [[self.CommonArray valueForKey:@"type"] objectAtIndex:indexPath.row];
    }
    [self closeView:nil];

}

#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"videoName CONTAINS[c] %@", searchText];
    _searchResult = [self.objSecondGalleryArray filteredArrayUsingPredicate:resultPredicate];
    
    NSLog(@"searchResult:%@", _searchResult);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        if (_searchResult.count == 0) {
            self.objVideoFilterArray = [self.searchResult copy];
            
            [self.videoCollectionview2 reloadData];
            
        } else {
            
            self.objVideoFilterArray =[[NSMutableArray alloc]init];
            self.objVideoFilterArray = [self.searchResult copy];
            
            [self.videoCollectionview2 reloadData];
            
        }
    });
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //self.playerTbl.hidden = NO;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //self.playerTbl.hidden = NO;
    NSLog(@"%@",textField);
    NSString *searchString = [NSString stringWithFormat:@"%@%@",textField.text, string];
    
    if (self.search_Txt.text.length!=1)
    {
        [self filterContentForSearchText:searchString];
    }
    else
    {
        self.objVideoFilterArray = [[NSMutableArray alloc]init];
        self.objVideoFilterArray =  self.objSecondGalleryArray;
    
        [self.videoCollectionview2 reloadData];
    
    }
    
    //[self filterContentForSearchText:searchString];
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        //[self.videoCollectionview2 reloadData];
    });
    return YES;
}

-(void)textFieldDidChange :(UITextField *) textField
{
    if (textField.text.length == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoCollectionview2 reloadData];
        });
    }
    else {
        
        [self filterContentForSearchText:textField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //self.videoCollectionview2.hidden = NO;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoCollectionview2 reloadData];
    });
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    [textField resignFirstResponder];
}

# pragma Date Picker

-(void)DisplaydatePicker
{
    if(self.datePicker!= nil)
    {
        [self.datePicker removeFromSuperview];
        
    }
    self.view_datepicker.hidden=NO;
    //isStartDate =YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    self.datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.view_datepicker.frame.origin.y-200,self.view.frame.size.width,100)];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [self.datePicker setLocale:locale];
    
    // [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self.datePicker reloadInputViews];
    [self.view_datepicker addSubview:self.datePicker];
    
}

-(IBAction)showSelecteddate:(id)sender{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString * actualDate = [dateFormat stringFromDate:self.datePicker.date];
    
    self.date_lbl.text = actualDate;
    
    if( ![self.date_lbl.text isEqualToString:@""])
    {
        self.CancelTextImg.hidden = NO;
        self.clearBtn.hidden = NO;
    }
    
    [self.view_datepicker setHidden:YES];
    
    self.objVideoFilterArray =[[NSMutableArray alloc]init];
    for(NSDictionary * objDic in self.objSecondGalleryArray)
    {
        NSString * objStr = [objDic valueForKey:@"videoName"];
        NSArray *component3 = [objStr componentsSeparatedByString:@" "];
        
        NSString * filterStr =  [NSString stringWithFormat:@"%@",component3[2]];
        if([filterStr isEqualToString:actualDate])
        {
            [self.objVideoFilterArray addObject:objDic];
        }
    }
    
    [self.videoCollectionview2 reloadData];
    
}

- (IBAction)ClearTextAction:(id)sender
{
    self.date_lbl.text = @"";
    self.CancelTextImg.hidden = YES;
    self.clearBtn.hidden = YES;
    
    self.objVideoFilterArray = [[NSMutableArray alloc]init];
    self.objVideoFilterArray =  self.objSecondGalleryArray;
    
    [self.videoCollectionview2 reloadData];
    
}



- (IBAction)showFilter:(id)sender {
    
    [tableMainView setHidden:NO];
    selectedButtonTag = [sender tag];
    
//    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
//    dropVC.protocol = self;
//    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [dropVC.view setBackgroundColor:[UIColor clearColor]];
//
//    CGFloat leading = (dropVC.view.frame.size.width/2) - dropVC.tblDropDown.frame.size.width;

    if ([sender tag] == 0) { // TEAM
        _CommonArray = appDel.ArrayTeam;
//        _CommonArray = appDel.MainArray;

        
        
//        dropVC.array = appDel.ArrayTeam;
//        dropVC.key = @"TeamName";
//        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(dropdownView.frame), CGRectGetMinY(dropdownView.frame), CGRectGetWidth(dropdownView.frame)/2, 300)];
        
        CGFloat height = 0;
        if (_CommonArray.count > 5) {
            height = 5 * 50;
        }
        else
        {
            height = _CommonArray.count * 50;
        }
        
        
        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnTeam.superview.frame), 0, CGRectGetWidth(btnTeam.superview.frame), height)];
        
    }
    else if([sender tag] == 1) // player
    {
        if ([lblTeam.text isEqualToString:@"Team"]) {
            [AppCommon showAlertWithMessage:@"Plaese select Team"];
            return;
        }
        
        if([lblTeam.text isEqualToString:@"KKR"])
        {
            selectedTeamCode = @"TEA0000008";
        }
        _CommonArray = [self getCorrespoingPlayerForthisTeamCode:selectedTeamCode];

//        dropVC.array = [self getCorrespoingPlayerForthisTeamCode:selectedTeamCode];
//        dropVC.key = @"PlayerName";
//        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(dropdownView.frame), CGRectGetMaxY(dropdownView.frame), CGRectGetWidth(dropdownView.frame)/2, 300)];
        
        CGFloat height = 0;
        if (_CommonArray.count > 5) {
            height = 5 * 50;
        }
        else
        {
            height = _CommonArray.count * 50;
        }

        
        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnPlayer.superview.frame), 0, CGRectGetWidth(btnPlayer.superview.frame), height)];


    }
    else if([sender tag] == 2) // Category
    {
        
        NSArray* typeArray = @[@{@"category":@"BATTING"},@{@"category":@"BOWLING"}];
        _CommonArray = typeArray;
        
        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnCategory.superview.frame), 0, CGRectGetWidth(btnCategory.superview.frame), 50*_CommonArray.count)];


        
//        dropVC.array = typeArray;
//        dropVC.key = @"type";
        
//        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX(dropdownView.frame), CGRectGetMaxY(dropdownView.superview.frame), CGRectGetWidth(dropdownView.frame)/2, 50*typeArray.count)];

    }
    else if([sender tag] == 3) // Type
    {
        NSString* temp =@"";
        if ([lblcategory.text isEqualToString:@"Batting"]) {
            temp = @"DISMISSALS";
        }
        else {
            temp = @"VARIATIONS";
            
        }
        
        
        NSArray* typeArray = @[@{@"type":@"BEATEN&UNCOMFORT"},@{@"type":@"BOUNDARIES"},@{@"type":@"DOTBALLS"},@{@"type":temp}];
        _CommonArray = typeArray;
        
        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnType.superview.frame), 0, CGRectGetWidth(btnType.superview.frame), 50*_CommonArray.count)];

        
//        [dropVC.tblDropDown setFrame:CGRectMake(leading, CGRectGetMaxY(dropdownView.superview.frame), CGRectGetWidth(dropdownView.frame)/2, 50*typeArray.count)];

    }
    
//    [dropVC.tblDropDown setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [[dropVC.tblDropDown.widthAnchor constraintLessThanOrEqualToConstant:250] setActive:true];
//    [[dropVC.tblDropDown.heightAnchor constraintLessThanOrEqualToConstant:300] setActive:true];
//    [[dropVC.tblDropDown.centerXAnchor constraintEqualToAnchor:dropVC.view.centerXAnchor] setActive:true];
//    [[dropVC.tblDropDown.centerYAnchor constraintEqualToAnchor:dropVC.view.centerYAnchor] setActive:true];
//    [dropVC.tblDropDown updateFocusIfNeeded];

//    label.widthAnchor.constraint(equalToConstant: 250).isActive = true
//    label.heightAnchor.constraint(equalToConstant: 100).isActive = true
//    label.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
//    label.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
//    dropVC.tblDropDown.center = CGPointMake(dropVC.view.frame.size.width/2, dropVC.view.frame.size.height/2);
    

    
//    [appDel.frontNavigationController presentViewController:dropVC animated:YES completion:^{
//        NSLog(@"DropDown loaded");
//
//    }];
    
    [tbl_list reloadData];
    
}


-(void)selectedValue:(NSMutableArray *)array andKey:(NSString*)key andIndex:(NSIndexPath *)Index
{
    if ([key isEqualToString:@"TeamName"]) {
        lblTeam.text = [[array objectAtIndex:Index.row] valueForKey:key];
        selectedTeamCode = [[array objectAtIndex:Index.row] valueForKey:@"TeamCode"];
    }
    else if ([key isEqualToString:@"PlayerName"]) {
        
        
        lblPlayer.text = [[array objectAtIndex:Index.row] valueForKey:key];
        selectedPlayerCode = [[array objectAtIndex:Index.row] valueForKey:@"PlayerCode"];
    }
    else if ([key isEqualToString:@"type"]) {
        lblType.text = [[array objectAtIndex:Index.row] valueForKey:key];
        
    }
    else if ([key isEqualToString:@"category"]) {
        lblcategory.text = [[array objectAtIndex:Index.row] valueForKey:key];
        
    }


    
    NSLog(@"selected value %@",[[array objectAtIndex:Index.row] valueForKey:key]);
}



- (IBAction)actionFilterVideo:(id)sender {
    
//    [self videoGalleryWebservice];
    [self newVideoListingwebservice];
}

-(IBAction)closeView:(id)sender
{
    [tableMainView setHidden:YES];
}


-(void)newVideoListingwebservice
{
    /*
     FETCH_AMAZONFILES/{TEAMNAME}/{PLAYERNAME}/{CATEGORY}/{TYPE}
     
     {
     "TeamName":"KKR",
     "Category":"BATTING",
     "PlayerName":"Chris Lynn",
     "Type":"BEATEN&UNCOMFORT"
     
     }
     */
    
    if(![COMMON isInternetReachable])
        return;
    
    if (lblTeam.text == nil || [lblTeam.text isEqualToString:@"Team"]) {
        [AppCommon showAlertWithMessage:@"Please select Team"];
        return;
    }
    else if (lblPlayer.text == nil || [lblPlayer.text isEqualToString:@"Player"]) {
        [AppCommon showAlertWithMessage:@"Please select Player"];
        return;
    }
    else if (lblType.text == nil || [lblType.text isEqualToString:@"Type"]) {
        [AppCommon showAlertWithMessage:@"Please select type"];
        return;
    }
    else if (lblcategory.text == nil || [lblcategory.text isEqualToString:@"category"]) {
        [AppCommon showAlertWithMessage:@"Please select Category"];
        return;
    }
    
    
    NSMutableDictionary* paramDict = [NSMutableDictionary new];
    [paramDict setValue:lblTeam.text forKey:@"TeamName"];
    [paramDict setValue:lblPlayer.text forKey:@"PlayerName"];
    [paramDict setValue:lblType.text forKey:@"Type"];
    [paramDict setValue:lblcategory.text forKey:@"Category"];
    
    [AppCommon showLoading];
    
    NSString* URLString = URL_FOR_RESOURCE(@"FETCH_AMAZONFILES");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager POST:URLString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject >0)
        {
            self.objFirstGalleryArray =[[NSMutableArray alloc]init];
            self.objFirstGalleryArray =responseObject;
        
            [self.videoCollectionview2 reloadData];
        }
        
        [AppCommon hideLoading];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];

    }];
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

@end
