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
    NSString *changedText;
}

@property (nonatomic,strong) NSMutableArray * CommonArray;
@property (nonatomic,strong) NSMutableArray * objFirstGalleryArray;
@property (nonatomic,strong) NSMutableArray * objSecondGalleryArray;
@property (nonatomic,strong) NSMutableArray * objCatoryArray;
@property (nonatomic,strong) NSMutableArray * objVideoFilterArray;
@property (nonatomic,strong) NSMutableArray * mainGalleryArray;
@property (nonatomic, strong) NSArray *searchResult;

@end


@implementation NewVideoDocumentVC

@synthesize pdfView,docWebview;
@synthesize tableMainView,tbl_list,lblNovideo, lblcategory, btnCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    
    objWebService = [[WebService alloc]init];
    
    [self.videoCollectionview1 registerNib:[UINib nibWithNibName:@"VideoGalleryCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    [self.videoCollectionview2 registerNib:[UINib nibWithNibName:@"VideoGalleryUploadCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
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
        
        
//        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnTeam.superview.frame), 0, CGRectGetWidth(btnTeam.superview.frame), height)];
        
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
        
//        [tbl_list setFrame:CGRectMake(CGRectGetMinX(btnType.superview.frame), 0, CGRectGetWidth(btnType.superview.frame), 50*_CommonArray.count)];
        
        
            //        [dropVC.tblDropDown setFrame:CGRectMake(leading, CGRectGetMaxY(dropdownView.superview.frame), CGRectGetWidth(dropdownView.frame)/2, 50*typeArray.count)];
        
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
        
        NSString * videoDetailStr = [[self.objFirstGalleryArray valueForKey:@"documentFile"] objectAtIndex:indexPath.row];
        
        [cell.fileImg setImage:[UIImage imageNamed:@"pdf"]];
        
        cell.batting_lbl.text = [[self.objFirstGalleryArray valueForKey:@"documentFileName"] objectAtIndex:indexPath.row];
        
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
    
    if (selectedButtonTag == 2) {
        
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
    
    if (selectedButtonTag == 2) {
        lblcategory.text = [[self.CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];
    }
    
    [tableMainView setHidden:YES];
}

- (void) videoDocumentWebservice {
    
    
    if(![COMMON isInternetReachable])
        return;
    
    NSString *URLString =  URL_FOR_RESOURCE(@"MOBILE_DOCUMENTFILEGALLERY");
   // NSString *URLString = @"http://192.168.0.154:8029/AGAPTService.svc/MOBILE_DOCUMENTFILEGALLERY";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
   // NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
//    selectedTeamCode = [AppCommon getCurrentTeamCode];
//    selectedPlayerCode = [AppCommon GetuserReference];
//
//    if(selectedTeamCode)   [dic    setObject:selectedTeamCode     forKey:@"TeamCode"];
//    if(selectedPlayerCode)   [dic    setObject:selectedPlayerCode     forKey:@"PlayerCode"];
////    if(lblType.text)   [dic    setObject:lblType.text     forKey:@"keyWords"];
//    if(lblcategory.text )   [dic    setObject:lblcategory.text     forKey:@"CategoryCode"];
//    [dic    setObject:@""  forKey:@"keyWords"];
    
    
    NSString *usercode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    // NSString *usercode = @"USM0000107";
    NSString *clientcode =  [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString *count =  @"0";
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //        if(competition)   [dic    setObject:competition     forKey:@"Competitioncode"];
    if(usercode)   [dic    setObject:usercode     forKey:@"Usercode"];
    if(clientcode)   [dic    setObject:clientcode     forKey:@"clientCode"];
    if(count)   [dic    setObject:count     forKey:@"Count"];
    
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
            {
            self.objFirstGalleryArray =[[NSMutableArray alloc]init];
            self.objFirstGalleryArray = [responseObject valueForKey:@"Secondlist"];
            self.mainGalleryArray = self.objFirstGalleryArray;
            
            [self.videoCollectionview2 reloadData];
            }
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}

#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"documentFileName CONTAINS[c] %@ OR keyWords CONTAINS[c] %@ OR TeamName CONTAINS[c] %@ OR PlayerName CONTAINS[c] %@ OR DocumentFileDate CONTAINS[c] %@ ", searchText,searchText,searchText,searchText, searchText];
    _searchResult = [self.mainGalleryArray filteredArrayUsingPredicate:resultPredicate];
    
    NSLog(@"searchResult:%@", _searchResult);
    
    dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
        if (_searchResult.count == 0) {
            self.objFirstGalleryArray = [self.searchResult copy];
            
            [self.videoCollectionview2 reloadData];
            
        } else {
            
            self.objFirstGalleryArray =[[NSMutableArray alloc]init];
            self.objFirstGalleryArray = [self.searchResult copy];
            
            [self.videoCollectionview2 reloadData];
            
        }
    });
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        //self.playerTbl.hidden = NO;
        //    NSLog(@"%@",textField);
        //    NSString *searchString = [NSString stringWithFormat:@"%@%@",textField.text, string];
        //
        //    if (self.search_Txt.text.length!=1)
        //    {
        //        [self filterContentForSearchText:searchString];
        //    }
        //    else
        //    {
        //        self.objVideoFilterArray = [[NSMutableArray alloc]init];
        //        self.objVideoFilterArray =  self.objSecondGalleryArray;
        //
        //        [self.videoCollectionview2 reloadData];
        //
        //    }
        //
        //    //[self filterContentForSearchText:searchString];
        //    dispatch_async(dispatch_get_main_queue(), ^{
        //        // Update the UI
        //        //[self.videoCollectionview2 reloadData];
        //    });
        //    return YES;
    
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
        self.objFirstGalleryArray = [[NSMutableArray alloc]init];
        self.objFirstGalleryArray =  self.mainGalleryArray;
        
        [self.videoCollectionview2 reloadData];
        }
    else
        {
        [self filterContentForSearchText:string];
        }
    
        //[self filterContentForSearchText:searchString];
    dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
        [self.videoCollectionview2 reloadData];
    });
}

-(void)textFieldDidChange :(UITextField *) textField
{
    if (changedText.length==0 || changedText.length == nil)
        {
        self.objFirstGalleryArray = [[NSMutableArray alloc]init];
        self.objFirstGalleryArray =  self.mainGalleryArray;
        
        [self.videoCollectionview2 reloadData];
        }
    else
        {
        [self filterContentForSearchText:changedText];
        }
    
        //[self filterContentForSearchText:searchString];
    dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
        [self.videoCollectionview2 reloadData];
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


-(void)loadWebView:(NSString *)str_file {
        //    [COMMON loadingIcon:self.view];
    NSURL *videoURL = [NSURL URLWithString:[str_file stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    docWebview.scrollView.showsHorizontalScrollIndicator = NO;
    docWebview.scrollView.showsVerticalScrollIndicator = NO;
        //    NSURL*url=[[NSURL alloc]initWithString:str_file];
    docWebview.scalesPageToFit = YES;
    [docWebview setTranslatesAutoresizingMaskIntoConstraints: NO];
    
        // Fast scrolling   UIScrollViewDecelerationRateNormal UIScrollViewContentInsetAdjustmentAutomatic
    docWebview.scrollView.decelerationRate = UIScrollViewContentInsetAdjustmentAutomatic;
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL];
    [docWebview loadRequest:requestObj];
    
        //    NSURL *pdfUrl = [NSURL fileURLWithPath:strPDFFilePath];
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)videoURL);
    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
    
    NSLog(@"Total no of page %@ ",pageCount);
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
        //    [COMMON RemoveLoadingIcon];
    NSLog(@"webViewDidFinishLoad");
    NSString* js =
    @"var meta = document.createElement('meta'); " \
    "meta.setAttribute( 'name', 'viewport' ); " \
    "meta.setAttribute( 'content', 'width = device-width, initial-scale = 1.0,minimum-scale=1.0,maximum-scale=10.0 user-scalable = yes' ); " \
    "document.getElementsByTagName('head')[0].appendChild(meta)";
    [webView stringByEvaluatingJavaScriptFromString: js];
    
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)webView.request.URL);
        //    size_t pageCount = CGPDFDocumentGetPage(document, 1);
    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
    
    NSLog(@"Total no of page %@ ",pageCount);
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pdfView.view;
}
- (IBAction)closePDFDoc:(id)sender {
    
    [pdfView dismissViewControllerAnimated:YES completion:nil];
        //    [self.navigationController popViewControllerAnimated:YES];
}

@end
