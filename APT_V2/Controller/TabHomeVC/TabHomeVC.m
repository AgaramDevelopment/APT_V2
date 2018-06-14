//
//  TabHomeVC.m
//  APT_V2
//
//  Created by Apple on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "TabHomeVC.h"
#import "Config.h"
#import "AppCommon.h"
#import "TabHomeCell.h"
#import "SchResStandVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "WellnessTrainingBowlingVC.h"
#import "VideoGalleryVC.h"
#import "HomeScreenStandingsVC.h"
#import "SwipeView.h"
#import "MyStatsBattingVC.h"
#import "TeamMembersVC.h"
#import "PopOverVC.h"

@interface TabHomeVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate, UIPopoverPresentationControllerDelegate>
{
    SchResStandVC *objSch;
    WellnessTrainingBowlingVC * objWell;
    VideoGalleryVC * objVideo;
    HomeScreenStandingsVC *StandsVC;
    MyStatsBattingVC *objStats;
    NSIndexPath* selectedIndex;
    TeamMembersVC* objPlayersVC;
    NSArray* titleArray;
    NSMutableArray* selectedUserArray;
    NSArray* uploadDropDownArray;
    
    NSString *imgData,* imgFileName;
    UIImagePickerController *videoPicker;
    NSString * selectedPlayerCode;
    NSString * selectedTeamCode;
    UIImage* thumbNailImage;
    UIDocumentPickerViewController* docPicker;
    NSURL* videofileURL;
    NSString* mimeType;
    CustomNavigation * objCustomNavigation;
    NSMutableArray *notificationArray;
    NSTimer* myTimer;
    BOOL success;
}

@end

@implementation TabHomeVC

@synthesize tblList,lblTeam,lblPlayer;

@synthesize lblCategory,lblShareUser;

@synthesize txtKeyword,txtVideoDate,viewUpload;

@synthesize selectedImageView,datePickerView;

@synthesize datePicker,btnGallery,protocol;

@synthesize lblUploadHeaderName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.Titlecollview registerNib:[UINib nibWithNibName:@"TabHomeCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    
    objSch = [[SchResStandVC alloc] initWithNibName:@"SchResStandVC" bundle:nil];
    objSch.Delegate = self;
    objStats = [[MyStatsBattingVC alloc] initWithNibName:@"MyStatsBattingVC" bundle:nil];
    objPlayersVC = [TeamMembersVC new];
    
    objWell = [[WellnessTrainingBowlingVC alloc] initWithNibName:@"WellnessTrainingBowlingVC" bundle:nil];
    //objWell.Delegate = self;
    
    selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    selectedUserArray = [NSMutableArray new];
    
    titleArray = @[@"Home",([AppCommon isCoach] ? @"My Teams" : @"Wellness/Training/Bowling")];
    
    [self FetchvideouploadWebservice];
    [txtVideoDate setInputView:datePickerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationCount) name:@"updateNotificationCount" object:nil];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateNotificationCount) userInfo:nil repeats:YES];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
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
    
    //Notification Method
    
    
    [objCustomNavigation.notificationView setHidden:![AppCommon isKXIP]];

    [objCustomNavigation.notificationBtn addTarget:self action:@selector(didClickNotificationBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateNotificationCount
{
    NSLog(@"updateNotificationCount method called");
    [self getNotificationsPostService];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [AppCommon getAppVersion];
        
    [objCustomNavigation.notificationView setHidden:![AppCommon isKXIP]];

    
    [self getNotificationsPostService];
    if (!appDel.MainArray.count) {
        [COMMON getIPLteams];
    }
    
//    NSString* CompetetionName = [[appDel.MainArray firstObject] valueForKey:@"CompetitionName"];
//    NSArray* temp1 = [COMMON getCorrespondingTeamName:CompetetionName];
    
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.Titlecollview selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionBottom];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:YES];
    [revealController.tapGestureRecognizer setEnabled:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Titlecollview reloadData];
    });

    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(IBAction)didClickNotificationBtn:(id)sender
{
    /*
     PopOverVC *popOverObj = [[PopOverVC alloc] init];
     popOverObj.listArray = array;
     UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:popOverObj];
     CGSize size;
     if (IS_IPAD) {
     size = CGSizeMake(300, array.count > 5 ? 200 : array.count*45);
     } else {
     size = CGSizeMake(250, array.count > 5 ? 200 : array.count*45);
     }
     
     [popOver setPopoverContentSize:size];
     [popOver setBackgroundColor:[UIColor colorWithRed:36/255.0 green:52/255.0 blue:75/255.0 alpha:1.0]];
     [popOver presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     */
    
    PopOverVC *contentVC = [[PopOverVC alloc] initWithNibName:@"PopOverVC" bundle:nil]; // 12
    contentVC.listArray = notificationArray;
//    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Notification-1", @"Notification-2", @"Notification-3", @"Notification-4", @"Notification-5", @"Notification-6", nil];
//    contentVC.listArray = array;
    contentVC.modalPresentationStyle = UIModalPresentationPopover; // 13
    UIPopoverPresentationController *popPC = contentVC.popoverPresentationController; // 14
    contentVC.popoverPresentationController.sourceRect = [sender bounds]; // 15
    contentVC.popoverPresentationController.sourceView = sender; // 16
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny; // 17
    popPC.delegate = self; //18
    [popPC setBackgroundColor:[UIColor colorWithRed:36/255.0 green:52/255.0 blue:75/255.0 alpha:1.0]];
//    [self presentViewController:contentVC animated:YES completion:nil]; // 19
    [appDel.frontNavigationController presentViewController:contentVC animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone; // 20
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
        // return YES if the Popover should be dismissed
        // return NO if the Popover should not be dismissed
    return YES;
}


 - (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
 return navController; // 21
 }
 
 # pragma mark - Popover Presentation Controller Delegate
 
 - (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
 
 // called when a Popover is dismissed
 }
 
 - (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
 
 // called when the Popover changes position
 }
 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.commonArray.count;
    
    return 2;
}

#pragma mar - UICollectionViewFlowDelegateLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat widthF = self.Titlecollview.superview.frame.size.width/2;
    CGFloat HeightF = self.Titlecollview.superview.frame.size.height;
    
    return CGSizeMake(widthF, HeightF);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TabHomeCell* cell = [self.Titlecollview dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.Title.text = titleArray[indexPath.row];
    [cell setTag:indexPath.row];
    
    if (indexPath == selectedIndex) {
        cell.selectedLineView.backgroundColor = [UIColor colorWithRed:(37/255.0f) green:(176/255.0f) blue:(240/255.0f) alpha:1.0f];
    }
    else {
        cell.selectedLineView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.swipeView scrollToItemAtIndex:indexPath.item duration:0.2];
}



- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return titleArray.count;
}

//- (void)swipeViewDidScroll:(__unused SwipeView *)swipeView {}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        if(index == 0)
        {
            objSch.view.frame = CGRectMake(0, 0, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height);
            [view addSubview:objSch.view];
   
        }
    
         else if(index == 1)
        {
//            if ([AppCommon isCoach]) {
//                CGFloat Yposition = objPlayersVC.filterContainerView.frame.origin.y;
//                objPlayersVC.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+70);
//                [view addSubview:objPlayersVC.view];
//            }
//            else
//            {
//                objStats.view.frame = CGRectMake(0, -75, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+75);
//                [view addSubview:objStats.view];
//            }
            //CGFloat Yposition = objWell.filterContainerView.frame.origin.y;
            objWell.view.frame = CGRectMake(0, -70, self.swipeView.bounds.size.width, self.swipeView.bounds.size.height+70);
            
            [view addSubview:objWell.view];
        }

    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    selectedIndex = [NSIndexPath indexPathForItem:swipeView.currentItemIndex inSection:0];
   if(selectedIndex ==1)
   {
       [self.swipeView setScrollEnabled:NO];
   }
    [self.Titlecollview reloadData];
   
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
   // self.page_control.currentPage = self.swipeView.currentItemIndex;
    
    selectedIndex = [NSIndexPath indexPathForItem:swipeView.currentItemIndex inSection:0];
    if(selectedIndex ==1)
    {
        [self.swipeView setScrollEnabled:NO];
    }
    [self.Titlecollview reloadData];
}



- (IBAction)actionDatePicker:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString * actualDate = [dateFormat stringFromDate:datePicker.date];
    
    txtVideoDate.text = actualDate;
    [txtVideoDate resignFirstResponder];

}

- (IBAction)actionDatePickerChange:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString * actualDate = [dateFormat stringFromDate:datePicker.date];
    
    txtVideoDate.text = actualDate;
    [txtVideoDate resignFirstResponder];

}


- (IBAction)actionCameraGallery:(id)sender {
    
    if ([sender tag] == 0) // Camera
    {
        videoPicker = [[UIImagePickerController alloc]init];
        videoPicker.delegate = self;
        videoPicker.allowsEditing = YES;
        
        videoPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        videoPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        videoPicker.videoMaximumDuration = 30;
        [self presentViewController:videoPicker animated:YES completion:nil];

    }
    else // Gallery
    {
        if ([[sender currentTitle]isEqualToString:@"Gallery"]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.delegate = self;
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            imagePicker.mediaTypes =  @[(NSString *) kUTTypeImage,(NSString *) kUTTypeMovie];
            
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            // ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
            
            [self showDocumentPickerInMode:UIDocumentPickerModeOpen];

        }
        
        
        

    }
    
    
}

-(void)uploadAPI
{
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString * createdby = [AppCommon GetUsercode];
    
    if(![COMMON isInternetReachable])
        return;
    
    if (imgData.length == 0) {
        [AppCommon showAlertWithMessage:@"Please Select Video to upload"];
        return;
        
    }
    else if (!selectedUserArray.count) {
        [AppCommon showAlertWithMessage:@"Please select atleast one user to share"];
        return;
    }
    else if (!txtVideoDate.hasText)
    {
        [AppCommon showAlertWithMessage:@"Please select Date"];
        return;
    }
    else if (!txtKeyword.hasText)
    {
        [AppCommon showAlertWithMessage:@"Please Enter Description or Keywords"];
        return;
    }
    
    
    
    [AppCommon showLoading];
    NSString *URLString =  URL_FOR_RESOURCE(VideoUpload);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * comments = @"";
    NSString * videoCode= @"";
    NSString * sharedUserID = [[selectedUserArray valueForKey:@"sharedUserCode"] componentsJoinedByString:@","];
    
    /*
     plyer code
     teamcode
     category
     type -keyword
     */
    
    selectedTeamCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"CAPTeamcode"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"clientCode"];
    if(createdby)   [dic    setObject:createdby     forKey:@"Createdby"];
    //        if(selectModule)   [dic    setObject:selectModule     forKey:@"moduleCode"];
    //        if(selectGameCode)   [dic    setObject:selectGameCode     forKey:@"gameCode"];
    if(selectedTeamCode)   [dic    setObject:selectedTeamCode     forKey:@"teamCode"];
    
    //    if(selectedPlayerCode)   [dic    setObject:selectedPlayerCode     forKey:@"playerCode"];
    if(txtVideoDate.hasText)   [dic    setObject:txtVideoDate.text     forKey:@"videoDate"];
    //    if(category_lbl.text)   [dic    setObject:category_lbl.text     forKey:@"categoryCode"];
    if(txtKeyword.hasText)   [dic    setObject:txtKeyword.text     forKey:@"keyWords"];
    //    if(comments)   [dic    setObject:@""    forKey:@"comments"];
    
    if(imgFileName)   [dic    setObject:imgFileName  forKey:@"videoFile"];
    if(imgFileName)   [dic    setObject:imgFileName  forKey:@"filename"];
    //
    //    if(videoCode)   [dic    setObject:videoCode  forKey:@"videoCode"];
    
    //            if(sharedUserID) [dic setObject:sharedUserID forKey:@"sharedUserID"];
    
    NSLog(@"USED PARAMS %@ ",dic);
    
    if(imgData) [dic setObject:imgData forKey:@"newmessagephoto"];
    
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    
    [AppCommon showLoading];
    
    [manager POST:URLString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppCommon hideLoading];
        
        NSLog(@"Success: %@", responseObject);
        //        [self resetImageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Update the UI
            [AppCommon hideLoading];
            //                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [appDel.frontNavigationController dismissViewControllerAnimated:YES completion:nil];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
        //        [self resetImageData];
        NSLog(@"SEND MESSAGE ERROR %@ ",error.description);
        [COMMON webServiceFailureError:error];
    }];
}

-(void)uploadSaveAPI:(NSDictionary *)fileInfo
{
    /*
     FILEUPLOADSAVEAMAZON
     
     clientCode;
     fileName;
     teamCode;
     fileDate;
     sharedUserID
     keyWords;
     filePath;
     Createdby;
     */
    
    if(![COMMON isInternetReachable])
        return;
    
    NSString *URLString =  URL_FOR_RESOURCE(@"FILEUPLOADSAVEAMAZON");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    selectedTeamCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"CAPTeamcode"];
    
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString * createdby = [AppCommon GetUsercode];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"clientCode"];
    if(selectedTeamCode)   [dic    setObject:selectedTeamCode     forKey:@"teamCode"];
    if(txtVideoDate.hasText)   [dic    setObject:txtVideoDate.text     forKey:@"fileDate"];
    if(selectedUserArray.count) [dic setObject:[selectedUserArray valueForKey:@"sharedUser"] forKey:@"sharedUserID"];
    if(txtKeyword.hasText)   [dic    setObject:txtKeyword.text     forKey:@"keyWords"];
    if(fileInfo)   [dic    setObject:fileInfo[@"FilePath"]  forKey:@"filePath"];
    if(fileInfo)   [dic    setObject:fileInfo[@"FileType"]  forKey:@"fileType"];

    if(createdby)   [dic    setObject:createdby     forKey:@"Createdby"];

    
    NSLog(@"USED PARAMS %@ ",dic);
    
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppCommon hideLoading];
            });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
        NSLog(@"failed in uploadSaveAPI");
        [COMMON webServiceFailureError:error];
        
    }];

}

-(void)saveImageToServer
{
    // COnvert Image to NSData
    NSData *dataImage = UIImageJPEGRepresentation([UIImage imageNamed:@"yourImage"], 1.0f);
    
    // set your URL Where to Upload Image
    NSString *urlString = @"Your URL HERE";
    
    // set your Image Name
    NSString *filename = @"YourImageFileName";
    
    // Create 'POST' MutableRequest with Data and Other Image Attachment.
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:dataImage]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    // Get Response of Your Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Response  %@",responseString);
}

-(void)uploadStream
{
    /*
     AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://192.168.2.121:85"]];
     
     UIImage *image = [UIImage imageNamed:@"test.jpg"];
     NSData *data = UIImageJPEGRepresentation(image, 0.2);
     NSInputStream *stream = [[[NSInputStream alloc]initWithData:data] retain];
     NSDictionary *parameters = nil;
     
     NSMutableURLRequest *myRequest = [client requestWithMethod:@"POST" path:@"/uploadservice/service1.svc/Upload" parameters:nil];
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:myRequest];
     
     [
     operation
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"success: %@", operation.responseString);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"error: %@", operation.error);
     }
     ];
     
     operation.inputStream = stream; //Thats where you put your stream!
     
     [[[NSOperationQueue alloc] init] addOperation:operation];
     */
    
}

-(void)fileUploadAsBase64
{
    /*
     MOBILE_FILEUPLOADSAVEAMAZON
     
     teamname
     filename
     fileinfo
     */
    
    if(![COMMON isInternetReachable])
        return;
    
    if (imgData.length == 0) {
        [AppCommon showAlertWithMessage:@"Please Select Video to upload"];
        return;
        
    }
    else if (!selectedUserArray.count) {
        [AppCommon showAlertWithMessage:@"Please select atleast one user to share"];
        return;
    }
    else if (!txtVideoDate.hasText)
    {
        [AppCommon showAlertWithMessage:@"Please select Date"];
        return;
    }
    else if (!txtKeyword.hasText)
    {
        [AppCommon showAlertWithMessage:@"Please Enter Description or Keywords"];
        return;
    }
    
    
    
    
    NSString *URLString =  URL_FOR_RESOURCE(@"MOBILE_FILEUPLOADSAVEAMAZON");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];


    NSString* teamName = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
    NSString* fileName = [[videofileURL lastPathComponent]lowercaseString];

    NSDictionary* dict = @{@"teamname":teamName,
                           @"filename":fileName,
                           @"fileinfo":imgData};
    
    [AppCommon showLoading];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];

    [manager POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       
        [formData appendPartWithFileURL:filePath name:@"fileinfo" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSError* error;
//        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject valueForKey:@"message"] isEqualToString:@"Success"]) {

            NSDictionary* dict = responseObject;
            [self uploadSaveAPI:dict];

            [self actionCloseUpload:nil];
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [AppCommon hideLoading];
//        });
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
        //        [self resetImageData];
        NSLog(@"SEND MESSAGE ERROR %@ ",error.description);
        [COMMON webServiceFailureError:error];
    }];

    
    
}

-(void)newUploadAPI
{
    
    
    /*
     
     API URL : /UploadFile?fileName={fileName}
     MIME type : application/octet-stream
     
     */
    
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString * createdby = [AppCommon GetUsercode];
    
    if(![COMMON isInternetReachable])
        return;
    
    if (imgData.length == 0) {
        [AppCommon showAlertWithMessage:@"Please Select Video to upload"];
        return;

    }
    else if (!selectedUserArray.count) {
        [AppCommon showAlertWithMessage:@"Please select atleast one user to share"];
        return;
    }
    else if (!txtVideoDate.hasText)
    {
        [AppCommon showAlertWithMessage:@"Please select Date"];
        return;
    }
    else if (!txtKeyword.hasText)
    {
        [AppCommon showAlertWithMessage:@"Please Enter Description or Keywords"];
        return;
    }
    
    [AppCommon showLoading];
    
    NSString* fileName_teamName = [NSString stringWithFormat:@"%@___%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"],[[videofileURL lastPathComponent]lowercaseString]];
    
//    NSString* teamName = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginedUserTeam"];
//    NSString* fileName = [[videofileURL lastPathComponent]lowercaseString];

    NSString* str = [NSString stringWithFormat:@"UploadFile?fileName=%@",fileName_teamName];
    NSString *URLString =  URL_FOR_RESOURCE(str);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestSerializer* reqSerializer = [AFHTTPRequestSerializer serializer];
//    [reqSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
//    [reqSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

//    AFHTTPRequestOperation* operation1 = [AFHTTPRequestOperation new];
//    NSData* data = [NSData dataWithContentsOfURL:videofileURL];
//    NSInputStream *stream = [[NSInputStream alloc]initWithData:data];
//
//    operation1.inputStream = stream;
//    [manager.operationQueue addOperation:operation1];
//    manager.requestSerializer = reqSerializer;

//    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
//    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

    
    [AppCommon showLoading];
    
    
    [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSError* formDataError;
//        [formData appendPartWithFileURL:videofileURL name:@"fileName" error:&formDataError];
        
//        NSLog(@"DATA FORMED %d ",formData);
//        NSLog(@"ERROR %@",formDataError.description);
        
        NSData* data = [NSData dataWithContentsOfURL:videofileURL];
//        [formData appendPartWithFileURL:videofileURL name:@"fileName" fileName:[[videofileURL lastPathComponent]lowercaseString] mimeType:@"video/quicktime" error:&formDataError];
        
        [formData appendPartWithFileData:data name:@"fileName" fileName:fileName_teamName mimeType:@"video/quicktime"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSError* error;
//        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"Success: %@", responseObject);

        if ([[responseObject valueForKey:@"message"] isEqualToString:@"Success"]) {
            
            [self uploadSaveAPI:responseObject];
            
            [self actionCloseUpload:nil];
        }
        [AppCommon hideLoading];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
        //        [self resetImageData];
        NSLog(@"SEND MESSAGE ERROR %@ ",error.description);
        [COMMON webServiceFailureError:error];
    }];
    

}

- (IBAction)actionUpload:(id)sender {
    
//    [self newUploadAPI];
    [self fileUploadAsBase64];
}

- (IBAction)actionDropDown:(id)sender {
    
    if (tblList.isHidden) {
        
        [tblList setHidden:NO];
        [tblList reloadData];
        
    }
    else{
        [tblList setHidden:YES];
    }
    
}

- (IBAction)actionCloseUpload:(id)sender {
    
    [viewUpload removeFromSuperview];
}

-(void)openVideoUploadViewInTabHomeVC:(NSString *)from
{
    NSLog(@"openVideoUploadViewInTabHomeVC called");
    
    if ([from isEqualToString:@"video"]) {
        lblUploadHeaderName.text = @"Videos";
        txtVideoDate.placeholder = @"Video Date";

    }
    else
    {
        lblUploadHeaderName.text = @"Documents";
        txtVideoDate.placeholder = @"Document Date";
    }
    
    imgData = nil;
    selectedImageView.image = [UIImage imageNamed:@"Video-Icon-crop"];
    lblShareUser.text = @"Share to user";
    [selectedUserArray removeAllObjects];
    txtVideoDate.text =@"";
    txtKeyword.text = @"";
    
    [viewUpload setFrame:self.view.frame];
    [self.view addSubview:viewUpload];
}

-(void)getNotificationsPostService
{
    /*
    API URL    :   http://192.168.0.154:8029/AGAPTService.svc/APT_GETNOTIFICATIONS
     METHOD     :   POST
    PARAMETER  :   {Clientcode}/{ParticipantCode}
    */
    /*
     {
     "Clientcode" : "CLI0000002",
     "ParticipantCode" : "AMR0000031"
     }

     */
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString *userRefcode = [AppCommon GetuserReference];
    
    
    if(![COMMON isInternetReachable])
        return;
    
    NSString *URLString =  URL_FOR_RESOURCE(GetNotifications);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"Clientcode"];
    if(userRefcode)   [dic    setObject:userRefcode     forKey:@"ParticipantCode"];
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            notificationArray = [NSMutableArray new];
            notificationArray = [responseObject valueForKey:@"NotificationsList"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            objCustomNavigation.notificationCountLbl.text = [self checkNSNumber:[responseObject valueForKey:@"count"]];
            NSNumber* number = [NSNumber numberWithInt:[objCustomNavigation.notificationCountLbl.text intValue]];
            [[NSUserDefaults standardUserDefaults] setValue:number forKey:@"badgeCount"];

            if(notificationArray.count > 0){
                
                NSMutableArray* oldCount = [[NSUserDefaults standardUserDefaults] arrayForKey:@"NotificationArray"];
                if (notificationArray.count > oldCount.count || (notificationArray.count == 1 && oldCount.count == 0)) {
                    
                    [appDel scheduleLocalNotifications:notificationArray];
                    [[NSUserDefaults standardUserDefaults] setValue:notificationArray forKey:@"NotificationArray"];

                }
                
            }
            else
            {
                NSLog(@"NO NEW DATA");
                [[NSUserDefaults standardUserDefaults] setValue:notificationArray forKey:@"NotificationArray"];

            }
            
        });
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed %@",error.description);
//        [COMMON webServiceFailureError:error];
        
    }];
}

-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    if (success) {

        if (notificationArray.count) {
            completionHandler(UIBackgroundFetchResultNoData);

            NSLog(@"No new data found.");
        }
        else{

            completionHandler(UIBackgroundFetchResultNewData);

            NSLog(@"New data was fetched.");
        }
    }
    else{
        completionHandler(UIBackgroundFetchResultFailed);

        NSLog(@"Failed to fetch new data.");
    }
}


-(void)FetchvideouploadWebservice
{
    NSString *ClientCode = [AppCommon GetClientCode];
    NSString *UserrefCode = [AppCommon GetuserReference];
    NSString *usercode = [AppCommon GetUsercode];
    
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    NSString *URLString =  URL_FOR_RESOURCE(FetchVideoUpload);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(ClientCode)   [dic    setObject:ClientCode     forKey:@"clientCode"];
    if(UserrefCode)   [dic    setObject:UserrefCode     forKey:@"Userreferencecode"];
    if(usercode)   [dic    setObject:usercode     forKey:@"Usercode"];
    
    
    NSLog(@"parameters : %@",dic);
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response ; %@",responseObject);
        
        if(responseObject >0)
        {
            uploadDropDownArray = [responseObject valueForKey:@"lstVideoUploadUser"];
    
        }
        
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return uploadDropDownArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:(IS_IPAD ? 13.0 : 13.0 )];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [[uploadDropDownArray objectAtIndex:indexPath.row] valueForKey:@"sharedUserName"];
    
        if ([[selectedUserArray valueForKey:@"sharedUserName"] containsObject:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;

        }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* temp = [uploadDropDownArray objectAtIndex:indexPath.row];
    NSString* currentlySelctedName = [temp valueForKey:@"sharedUserName"];

    
        if ([[selectedUserArray valueForKey:@"sharedUserName"] containsObject:currentlySelctedName]) {

            [selectedUserArray removeObject:temp];
        }
        else{
            [selectedUserArray addObject:temp];
        }
    
    [tableView reloadData];
    
    lblShareUser.text = [[selectedUserArray valueForKey:@"sharedUserName"]componentsJoinedByString:@","];

}


-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    
    
//    AVAsset *asset = [AVAsset assetWithURL:filepath];
//    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//    imageGenerator.appliesPreferredTrackTransform = YES;
//    CMTime time = [asset duration];
//    time.value = 0;
//
//    NSError *err = NULL;
//
//        CGImageRef imgRef = [imageGenerator copyCGImageAtTime:CMTimeMake(1, 60) actualTime:NULL error:&err];
//        UIImage* thumbnail = [[UIImage alloc] initWithCGImage:imgRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
    
    

    UIImage* thumbnail = nil;
    return thumbnail;
}

#pragma mark UIImagePickerController Delegates


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSLog(@"info[UIImagePickerControllerMediaType] %@",info[UIImagePickerControllerMediaType]);
    UIImage* image;
    NSData* imgDatas;
    
    if([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        NSString* str = info[@"UIImagePickerControllerImageURL"];
        videofileURL = (NSURL *)[info valueForKey:UIImagePickerControllerImageURL];
        imgDatas = [[NSData alloc] initWithContentsOfFile:str];
        imgFileName = [[info valueForKey:@"UIImagePickerControllerImageURL"] lastPathComponent];
        selectedImageView.image = info[UIImagePickerControllerOriginalImage];
        mimeType = [NSString stringWithFormat:@"image/%@",[[videofileURL pathExtension]lowercaseString]];

    }
    else
    {
//        NSURL* url = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
        
        videofileURL = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
        imgDatas = [[NSData alloc] initWithContentsOfURL:videofileURL];
        
        selectedImageView.image = [self generateThumbImage:videofileURL];
        
        imgFileName = [[info valueForKey:@"UIImagePickerControllerMediaURL"] lastPathComponent];
        
//        image = info[UIImagePickerControllerOriginalImage];
//        mimeType = [NSString stringWithFormat:@"video/%@",[[videofileURL pathExtension]lowercaseString]];
        mimeType = @"video/quicktime";
        
//        videofileURL = [videofileURL URLByDeletingPathExtension];
//        videofileURL = [videofileURL URLByAppendingPathExtension:@"mp4"];
    }
    
    
    imgData = [imgDatas base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (!imgFileName) {
        
        imgFileName = [self getFileName];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        //_ImgViewBottomConst.constant = _imgView.frame.size.height;
//        [_imgView updateConstraintsIfNeeded];
//        selectedImageView.image = image;
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
//    [self.view setFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];
}


- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(NSString *)getFileName
{
    
    /*
     EEEE, MMM d, yyyy
     */
    
    NSString* filename;
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"EEEE_MMM_d_yyyy_HH_mm_ss"];
    
    filename = [df stringFromDate:[NSDate date]];
    filename=[filename stringByAppendingPathExtension:@"png"];
    NSLog(@"file name %@ ",filename);
    
    return filename;
}
#pragma mark- Open Document Picker(Delegate) for PDF, DOC Slection from iCloud


- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode
{
    
//    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    
    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.image", @"public.audio", @"public.movie", @"public.text", @"public.item",@"public.content", @"public.source-code"] inMode:UIDocumentPickerModeImport];

    picker.delegate = self;
    
    picker.modalPresentationStyle = UIModalPresentationPopover;
//    picker.popoverPresentationController.sourceRect = btnGallery.frame;
    picker.popoverPresentationController.sourceView = btnGallery;
    

    [self presentViewController:picker animated:YES completion:nil];
}


-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
  didPickDocumentAtURL:(NSURL *)url
{
    NSLog(@"selected file URL %@",url);
    videofileURL = url;
    imgData = [[NSData alloc] initWithContentsOfURL:url];
    selectedImageView.image = [self generateThumbImage:url];

//    PDFUrl= url;
//    UploadType=@"PDF";
//    [arrimg removeAllObjects];
//    [arrimg addObject:url];
    
}


- (NSString *)checkNSNumber:(id)unknownTypeParameter {
    
    NSString *str;
    if([unknownTypeParameter isKindOfClass:[NSNumber class]])
        {
        
        NSNumber *vv = unknownTypeParameter;
        str = [vv stringValue];
        }
    else
        {
        str = unknownTypeParameter;
        }
    return str;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
