//
//  VideoDocumentVC.m
//  APT_V2
//
//  Created by Apple on 26/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "VideoDocumentVC.h"
#import "VideoGalleryCell.h"
#import "VideoGalleryUploadCell.h"
#import "VideoPlayerViewController.h"
#import "Header.h"
#import "Config.h"
#import "ScoreCardVideoPlayer.h"


@interface VideoDocumentVC ()
{
    NSMutableArray* docResultArray,* CommonArray;
    NSInteger* selectedButtonTag;
    NSString* selectedTeamCode;
    NSString* selctedValues;
    BOOL isNext,isBack;
    
    VideoPlayerViewController *videoPlayerVC;
    NSMutableArray* backButtonNames;
    NSInteger LineCount;
    CGFloat VideoCollectionHeight;
}

@end

@implementation VideoDocumentVC

@synthesize docView,docCollectionView;

@synthesize teamView,venueView,tableMainView;

@synthesize tblDropDown,lblTeam,lblVenue;

@synthesize lblNoDoc,protocolUpload;

@synthesize pdfView,docWebview,btnStackView;

@synthesize lblFilePath,btnUpload,collectionTop;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    docResultArray = [NSMutableArray new];
    CommonArray = [NSMutableArray new];
    self.backBtn.hidden = YES;
    [docCollectionView registerNib:[UINib nibWithNibName:@"VideoGalleryCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    selctedValues = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
    [self videoGalleryWebservice];
    backButtonNames = [NSMutableArray new];
        
    [btnUpload setHidden:![AppCommon isKXIP]];

    
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

-(void) addAndRemoveInputs:(NSString *)strValue
{
    if (isNext) {
        selctedValues = [selctedValues stringByAppendingPathComponent:strValue];
    }
    else
    {
        
        NSString* str = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
        if ([[selctedValues lastPathComponent] isEqualToString:str]) {
            return;
        }

        
        selctedValues = [selctedValues stringByDeletingLastPathComponent];
        
    }
    isNext = !isNext;
    lblFilePath.text = selctedValues;
    [self videoGalleryWebservice];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    [lblNoDoc setHidden:docResultArray.count];
    
    
    return docResultArray.count;
}

-(CGSize)collectionSize
{
    CGFloat width = self.docCollectionView.frame.size.width;
    CGFloat height = 130;
    
    if(IS_IPHONE5) {
        
        width = width/3;
    }
    else if(IS_IPHONE_DEVICE && !IS_IPHONE5) {
        
        width = width/3;
    }
    else if(IS_IPAD) {
        
        width = width/5;
    }

    return CGSizeMake(width-10, width);

}


#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = collectionView.frame.size.width;
    CGFloat height = 130;

    if(IS_IPHONE5) {

        width = width/3;
        LineCount = 3;
    }
    else if(IS_IPHONE_DEVICE && !IS_IPHONE5) {

        width = width/3;
        LineCount = 3;

    }
    else if(IS_IPAD) {

        width = width/5;
        LineCount = 5;

    }
    VideoCollectionHeight = width;
    return CGSizeMake(width-10, width);
    
//    return [self collectionSize];
    
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10.0;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VideoGalleryCell* cell = [docCollectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
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
    
    if (![[[docResultArray objectAtIndex:indexPath.item] valueForKey:@"videoFolderName"] isEqualToString:@""]) {
        [cell.imgView setImage:[UIImage imageNamed:@"folderBlue-icon"]];
        cell.lblfileName.text = [[docResultArray objectAtIndex:indexPath.item] valueForKey:@"videoFolderName"];
    }
    else{
        [cell.imgView setImage:[UIImage imageNamed:@"Video-Icon-crop"]];
        
        cell.lblfileName.text = [[[docResultArray objectAtIndex:indexPath.item] valueForKey:@"videoFileName"] lastPathComponent];
        
    }
    
    return cell;
    
}

-(void)BackTapped
{
    NSLog(@"BackTapped");
}

-(void)updateRootButtons
{
    if (isNext) {
        
        UIButton* but1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, btnStackView.frame.size.height)];
        [but1 setTitle:backButtonNames.lastObject forState:UIControlStateNormal];
        [but1 addTarget:self action:@selector(BackTapped) forControlEvents:UIControlEventTouchUpInside];
        [btnStackView addArrangedSubview:but1];
    }
    else
    {
        [btnStackView removeArrangedSubview:btnStackView.arrangedSubviews.lastObject];
    }
    

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    isNext = YES;
    
    if (![[[docResultArray objectAtIndex:indexPath.item] valueForKey:@"videoFolderName"] isEqualToString:@""]) {
        NSString* fileName = [[docResultArray objectAtIndex:indexPath.item] valueForKey:@"videoFolderName"];
        [self addAndRemoveInputs:fileName];
        
        VideoGalleryCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        [backButtonNames addObject:cell.lblfileName.text];
        isNext = YES;

        [self updateRootButtons];
        
    }
    else{
        
        NSString* fileName = [[docResultArray objectAtIndex:indexPath.item] valueForKey:@"videoFile"];
        //        pdfView
        //[self loadWebView:fileName];
        
       // [appDel.frontNavigationController presentViewController:pdfView animated:YES completion:^{
       // }];
        
        
//        videoPlayerVC = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" bundle:nil];
//        videoPlayerVC.objSelectVideoLink = fileName;
//        [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];
        
        /*
         VideoPlayerViewController * videoPlayerVC = [[VideoPlayerViewController alloc]init];
         videoPlayerVC = (VideoPlayerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
         videoPlayerVC.MatchCode = self.matchCode;
         videoPlayerVC.PlayerCode = playercode;
         videoPlayerVC.VideoValue = value;
         videoPlayerVC.Innings = innNo;
         videoPlayerVC.Type = batOrBowl;
         [self.navigationController presentViewController:videoPlayerVC animated:YES completion:nil];

         */
        
        
        ScoreCardVideoPlayer * videoPlayerVC = [[ScoreCardVideoPlayer alloc]init];
        videoPlayerVC = (ScoreCardVideoPlayer *)[appDel.storyBoard instantiateViewControllerWithIdentifier:@"ScoreCardVideoPlayer"];
        videoPlayerVC.isFromHome = YES;
        videoPlayerVC.HomeVideoStr = fileName;
        NSLog(@"appDel.frontNavigationController.topViewController %@",appDel.frontNavigationController.topViewController);
        [appDel.frontNavigationController presentViewController:videoPlayerVC animated:YES completion:nil];

        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [CommonArray count];    //count number of row from counting array hear cataGorry is An Array
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
        cell.textLabel.text = [[CommonArray valueForKey:@"TeamName"] objectAtIndex:indexPath.row];
        
    }
    else if (selectedButtonTag == 1) {
        
        cell.textLabel.text = [[CommonArray valueForKey:@"PlayerName"] objectAtIndex:indexPath.row];
        
    }
    else if (selectedButtonTag == 2) {
        
        cell.textLabel.text = [[CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];
        
    }
    else if (selectedButtonTag == 3) {
        
        cell.textLabel.text = [[CommonArray valueForKey:@"type"] objectAtIndex:indexPath.row];
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
        lblTeam.text = [[CommonArray valueForKey:@"TeamName"] objectAtIndex:indexPath.row];
        selectedTeamCode = [[CommonArray valueForKey:@"TeamCode"] objectAtIndex:indexPath.row];
        //        lblPlayer.text = @"Player";
    }
    else if (selectedButtonTag == 1) {
        
        //        lblPlayer.text = [[self.CommonArray valueForKey:@"PlayerName"] objectAtIndex:indexPath.row];
        //        selectedPlayerCode = [[self.CommonArray valueForKey:@"PlayerCode"] objectAtIndex:indexPath.row];
    }
    else if (selectedButtonTag == 2) {
        
        //        lblcategory.text = [[self.CommonArray valueForKey:@"category"] objectAtIndex:indexPath.row];
    }
    else if (selectedButtonTag == 3) {
        
        //        lblType.text = [[self.CommonArray valueForKey:@"type"] objectAtIndex:indexPath.row];
    }
    [self closeView:nil];
    
}

- (IBAction)showFilter:(id)sender {
    
    [tableMainView setHidden:NO];
    selectedButtonTag = [sender tag];
    
    if ([sender tag] == 0) {
        
        CommonArray = appDel.ArrayTeam;
        
        
        CGFloat height = 0;
        if (CommonArray.count > 5) {
            height = 5 * 50;
        }
        else
        {
            height = CommonArray.count * 50;
        }
        
        
        [tblDropDown setFrame:CGRectMake(CGRectGetMinX([sender superview].frame), 0, CGRectGetWidth([sender superview].frame), height)];
        
    }
    else if([sender tag] == 1)
    {
        
    }
    
    [tblDropDown reloadData];
    
}

-(IBAction)closeView:(id)sender
{
    [tableMainView setHidden:YES];
}

-(void)videoGalleryWebservice
{
    
    [AppCommon showLoading];
    if(![COMMON isInternetReachable])
        return;
    
    //    NSString* temp_str = [NSString stringWithFormat:@"FETCH_AMAZONDOCUMENTS/%@",selctedValues];
    NSString *URLString =  URL_FOR_RESOURCE(@"FETCH_AMAZONFILES");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    NSDictionary* dict = @{@"TeamName":selctedValues,
                           @"ClientCode":[AppCommon GetClientCode],
                           @"UserCode":[AppCommon GetUsercode]
                           };
    
//    "ClientCode":"CLI0000002",
//    "UserCode":"USM0000028"
    
    
    NSLog(@"DOC parameters : %@",dict);
    [manager POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            

            docResultArray = responseObject;
            /*
             no.of.lines = arraycount + space
             */
//            CGFloat Xwidth = [self collectionSize].width;
//            CGFloat space = 10;
            
            NSString* str = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
            if ([[selctedValues lastPathComponent] isEqualToString:str])
            {
                self.backBtn.hidden =YES;
                self.collectionTop.constant = -40;
            }
            else
            {
                self.backBtn.hidden =NO;
                self.collectionTop.constant = 0;
                
            }
            

            NSString* first = [self isGreaterThanOneLine];
            NSNumber* second = [NSNumber numberWithFloat:VideoCollectionHeight];
            NSString* third = (self.backBtn.isHidden ? @"1" : @"0");

            
            NSDictionary* dict = @{@"iSGreaterThanOneLine":first,
                                   @"Height":second,
                                   @"BackVisible":third
                                   };
            [protocolUpload updateVideoCollectionCount:dict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.docCollectionView reloadData];
            });
        }
        
        
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}


-(NSString *)isGreaterThanOneLine
{
    NSString* resultedCount = @"0";
    
    if(IS_IPHONE_DEVICE && docResultArray.count > 2) {
        
        resultedCount = @"1";
        
    }
    else if(IS_IPAD && docResultArray.count > 4) {
        
        resultedCount = @"1";

    }
    else {
        resultedCount = @"0";

    }
    
    NSLog(@"TOTAL NO OF LINE %@ ",resultedCount);
    return resultedCount;

}

- (IBAction)actionBack:(id)sender {
    
    isNext = NO;
    [self addAndRemoveInputs:@""];
    
}

-(void)loadWebView:(NSString *)str_file {
    //    [COMMON loadingIcon:self.view];
    NSURL *videoURL = [NSURL URLWithString:[str_file stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    docWebview.scrollView.showsHorizontalScrollIndicator = NO;
    docWebview.scrollView.showsVerticalScrollIndicator = NO;
    //    NSURL*url=[[NSURL alloc]initWithString:str_file];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL];
    [docWebview loadRequest:requestObj];
    [docWebview stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 5.0;"];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [COMMON RemoveLoadingIcon];
    NSLog(@"webViewDidFinishLoad");
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
}

- (IBAction)actionUpload:(id)sender {
    
    [protocolUpload openVideoUploadView];
//    TabHomeVC* vc = [TabHomeVC new];
//    [vc.view addSubview:vc.viewUpload];
}

@end
