//
//  DocumentViewController.m
//  APT_V2
//
//  Created by user on 23/03/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "DocumentViewController.h"
#import "VideoGalleryCell.h"
#import "VideoGalleryUploadCell.h"
#import "VideoPlayerViewController.h"
#import "Header.h"


@interface DocumentViewController ()
{
    NSMutableArray* docResultArray,* CommonArray;
    NSInteger* selectedButtonTag;
    NSString* selectedTeamCode;
    NSString* selctedValues;
    BOOL isNext,isBack;
}

@end

@implementation DocumentViewController

@synthesize docView,docCollectionView;

@synthesize teamView,venueView,tableMainView;

@synthesize tblDropDown,lblTeam,lblVenue;

@synthesize lblNoDoc,protocolUpload,btnUpload;

@synthesize pdfView,docWebview,lblFilePath,collectionTop;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
//    [btnUpload setHidden:![AppCommon isKXIP]];

    if (self.isNotificationPDF) {
        
        [self loadWebView:self.filePath];
        [appDel.frontNavigationController presentViewController:pdfView animated:YES completion:^{
        }];
    } else {
        docResultArray = [NSMutableArray new];
        CommonArray = [NSMutableArray new];
        
        self.backBtn.hidden =YES;
        
        [docCollectionView registerNib:[UINib nibWithNibName:@"VideoGalleryCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
        selctedValues = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
        [self videoGalleryWebservice];
    }
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

#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat width = collectionView.frame.size.width;
    //    CGFloat height = collectionView.frame.size.height;

    if(IS_IPHONE5) {

        width = width/3;
    }
    else if(!IS_IPAD && !IS_IPHONE5) {

        width = width/3;
    }
    else if(IS_IPAD) {

        width = width/5;
    }

    return CGSizeMake(width-10, width);


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
    
    
    NSString* str = [[[docResultArray objectAtIndex:indexPath.item] valueForKey:@"folderName"] lowercaseString];
    
    
    if (![str isEqualToString:@""] && [[str pathExtension] isEqualToString:@""]) {

        [cell.imgView setImage:[UIImage imageNamed:@"folderBlue-icon"]];
        cell.lblfileName.text = [[docResultArray objectAtIndex:indexPath.item] valueForKey:@"folderName"];
    }
    else{
        
        NSString* document = [[[docResultArray objectAtIndex:indexPath.item] valueForKey:@"documentName"] lastPathComponent];

        if ([[document pathExtension]isEqualToString:@"pdf"]) {
            [cell.imgView setImage:[UIImage imageNamed:@"pdf"]];
        }
        else
        {
            [cell.imgView setImage:[UIImage imageNamed:@"no-image"]];
        }

        cell.lblfileName.text = document;

    }

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    isNext = YES;
    
    if (![[[docResultArray objectAtIndex:indexPath.item] valueForKey:@"folderName"] isEqualToString:@""]) {
        NSString* fileName = [[docResultArray objectAtIndex:indexPath.item] valueForKey:@"folderName"];
        [self addAndRemoveInputs:fileName];

    }
    else{
        
       NSString* fileName = [[docResultArray objectAtIndex:indexPath.item] valueForKey:@"documentName"];
//        pdfView
        [self loadWebView:fileName];

        [appDel.frontNavigationController presentViewController:pdfView animated:YES completion:^{
        }];
        

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
    NSString *URLString =  URL_FOR_RESOURCE(@"FETCH_AMAZONDOCUMENTS");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
//    NSDictionary* dict = @{@"TeamName":selctedValues};
    
    NSDictionary* dict = @{
                           @"TeamName":selctedValues,
                           @"ClientCode":[AppCommon GetClientCode],
                           @"UserCode":[AppCommon GetUsercode]
                           };

    
    
    NSLog(@"URLString %@",URLString);
    NSLog(@"DOC parameters : %@",dict);
    
    [manager POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            NSString* str = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
            if ([[selctedValues lastPathComponent] isEqualToString:str])
            {
                self.backBtn.hidden =YES;
                collectionTop.constant = -40;
            }
            else
            {
                self.backBtn.hidden =NO;
                collectionTop.constant = 0;

            }
            docResultArray = responseObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.docCollectionView reloadData];
            });
        }
        
        
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        
        isNext = NO;
        [self addAndRemoveInputs:@""];

        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
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
- (IBAction)actionUpload:(id)sender {
    [protocolUpload openDocumentUploadView];
}

@end
