//
//  VideoPlayerUploadVC.m
//  APT_V2
//
//  Created by Apple on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "VideoPlayerUploadVC.h"
#import "Config.h"
#import "AppCommon.h"
#import "WebService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CRTableViewCell.h"
#import "SWRevealViewController.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import "HeaderTableViewCell.h"

// AVFoundation.AVAssetImageGenerato

@interface VideoPlayerUploadVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate, UIPopoverPresentationControllerDelegate>
{
    WebService * objWebService;
    BOOL isPlayer;
    BOOL isCategory;
    BOOL isShare;
    BOOL isModule;
    NSString *imgData,* imgFileName;
    NSMutableArray* mainArray;
    NSMutableArray* chatArray;
    NSString *plyCode;
    UIImagePickerController *videoPicker;
    NSString * selectPlayer;
    NSString * selectCategory;
    NSString * selectModule;
    NSString * selectTeamCode;
    NSString * selectGameCode,*SelectedcategoryCode;
    NSInteger* buttonTag;
    NSString* correspondingTeamCode;
    
    //AlertView Properties
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *alertFailed;
    Boolean isPickerOpned;

}
@property (nonatomic,strong) NSMutableArray * objTeamArray;
@property (nonatomic,strong) NSMutableArray * objPlayerArray;
@property (nonatomic,strong) NSMutableArray * objCategoryArray;
@property (nonatomic,strong) NSMutableArray * sharetouserArray;
@property (nonatomic,strong) NSMutableArray * commonArray;
@property (nonatomic,strong) IBOutlet UITableView * popTbl;
@property (nonatomic,strong) IBOutlet UIView * date_view;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popTblYposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popTblwidthposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popTblXposition;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (strong, nonatomic)  NSMutableArray *selectedMarks;
@property (strong,nonatomic) NSMutableArray * ModuleArray;

@end

@implementation VideoPlayerUploadVC

@synthesize module_lbl,player_lbl,category_lbl,objKeyword_Txt;

@synthesize popTbl,teamView,playerView,CategoryView,keywordsView;

@synthesize datepickerView,DatePicker,sharetoUserView,selectedImageView;

@synthesize tapView,MainView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objWebService = [[WebService alloc]init];
    [self FetchvideouploadWebservice];
    
//    if (!appDel.ArrayIPL_teamplayers.count) {
//        [AppCommon getTeamAndPlayerCode];
//    }
    
    [self.view setFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];

    // Do any additional setup after loading the view from its nib.
    
    self.shadowView.layer.cornerRadius = 2.0f;
    self.shadowView.layer.borderWidth = 1.0f;
    self.shadowView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.shadowView.layer.masksToBounds = YES;

    self.commonView.layer.shadowRadius  = 1.5f;
    self.commonView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.commonView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.commonView.layer.shadowOpacity = 0.9f;
    self.commonView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.commonView.bounds, shadowInsets)];
    self.commonView.layer.shadowPath    = shadowPath.CGPath;

    self.teamView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.teamView.layer.borderWidth = 1.0f;
    
    self.playerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.playerView.layer.borderWidth = 1.0f;
    
    self.videoDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.videoDateView.layer.borderWidth = 1.0f;
    
    self.CategoryView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.CategoryView.layer.borderWidth = 1.0f;
    
    self.keywordsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.keywordsView.layer.borderWidth = 1.0f;
    
    self.sharetoUserView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sharetoUserView.layer.borderWidth = 1.0f;
    [self.date_view setHidden:YES];
    self.popTbl.hidden = YES;
    self.selectedMarks = [[NSMutableArray alloc]init];
    NSMutableDictionary *coachdict = [[NSMutableDictionary alloc]initWithCapacity:2];
    [coachdict setValue:@"Coach" forKey:@"ModuleName"];
    [coachdict setValue:@"MSC084" forKey:@"ModuleCode"];
    
    NSMutableDictionary *physiodict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [physiodict setValue:@"Physio" forKey:@"ModuleName"];
    [physiodict setValue:@"MSC085" forKey:@"ModuleCode"];
    
    NSMutableDictionary *Sandcdict = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [Sandcdict setValue:@"S and C" forKey:@"ModuleName"];
    [Sandcdict setValue:@"MSC086" forKey:@"ModuleCode"];
    
    [DatePicker addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventValueChanged];
    
    self.ModuleArray = [[NSMutableArray alloc]initWithObjects:coachdict,physiodict,Sandcdict, nil];
    [self.txtVideoDate setInputView:datepickerView];
    
    //Video or Document Upload Title
    if ([self.titleString isEqualToString:@"Videos"]) {
        self.titleLbl.text = self.titleString;
        self.txtVideoDate.placeholder = @"Video date";
        
        alertTitle = @"Videos";
        alertMessage = @"Video Uploaded Successfully";
        alertFailed = @"Video Upload failed";
    } else {
        self.titleLbl.text = self.titleString;
        self.txtVideoDate.placeholder = @"Document date";
        alertTitle = @"Documents";
        alertMessage = @"Document Uploaded Successfully";
        alertFailed = @"Document Upload failed";
    }
    
    [tapView setHidden:YES];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        SWRevealViewController *revealController = [self revealViewController];
        [revealController.panGestureRecognizer setEnabled:YES];
        [revealController.tapGestureRecognizer setEnabled:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
    
}


-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        
        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            //[objCustomNavigation.btn_back addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
        {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        }
    [self.headerView addSubview:objCustomNavigation.view];
        //    objCustomNavigation.tittle_lbl.text=@"";
    
}

-(IBAction)didClickBackBtn:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [appDel.frontNavigationController popViewControllerAnimated:YES];
}


-(void)FetchvideouploadWebservice
{
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    NSString *usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    
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
            self.objTeamArray = [NSMutableArray new];
            self.objPlayerArray =[[NSMutableArray alloc]init];
            self.objCategoryArray = [[NSMutableArray alloc]init];
            self.sharetouserArray = [[NSMutableArray alloc]init];
        
            self.objTeamArray =[responseObject valueForKey:@"lstVideoUploadTeam"];
            self.objPlayerArray =[responseObject valueForKey:@"lstVideoUploadPlayer"];
            self.objCategoryArray =[responseObject valueForKey:@"lstVideoUploadCategory"];
            self.sharetouserArray = [responseObject valueForKey:@"lstVideoUploadUser"];
            
        }
        
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        [AppCommon hideLoading];
        
    }];
}

-(IBAction)didClickModule:(id)sender
{
    self.popTblYposition.constant = self.teamView.frame.origin.y-20;
    self.popTblwidthposition.constant = self.teamView.frame.size.width;
    self.popTblXposition.constant = -310;
    if(isModule== NO)
    {
    
            self.popTbl.hidden = NO;
            self.commonArray = [[NSMutableArray alloc]init];
            self.commonArray = self.ModuleArray;
            [self.popTbl reloadData];
            isModule = YES;
    
    }
    else
    {
        self.popTbl.hidden = YES;
        isPlayer = NO;
        isCategory = NO;
        isShare = NO;
        isModule = NO;
        
    }
}

-(IBAction)didClickPlayerList:(id)sender
{
    self.popTblYposition.constant = self.playerView.frame.origin.y-20;
    self.popTblwidthposition.constant = self.playerView.frame.size.width;
    self.popTblXposition.constant = 10;

    if(isPlayer== NO)
    {
    
            self.popTbl.hidden = NO;
            self.commonArray = [[NSMutableArray alloc]init];
            self.commonArray = self.objPlayerArray;
            [self.popTbl reloadData];
            isPlayer = YES;
    
    }
    else
    {
        self.popTbl.hidden = YES;
        isPlayer = NO;
        isCategory = NO;
        isShare = NO;
        isModule = NO;
    }
}

-(IBAction)didClickCategoryList:(id)sender
{
    self.popTblYposition.constant = self.CategoryView.frame.origin.y-10;
    self.popTblwidthposition.constant = self.CategoryView.frame.size.width;
    self.popTblXposition.constant = 10;

    if(isCategory== NO)
    {
    
            self.popTbl.hidden = NO;
            self.commonArray = [[NSMutableArray alloc]init];
//            self.commonArray = self.objCategoryArray;
        
        
//        category_lbl.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"categoryName"];
//        SelectedcategoryCode = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"categoryCode"];

        self.commonArray = @[@{@"categoryName":@"Batting",@"categoryCode":@"MSC356"},
                             @{@"categoryName":@"Bowling",@"categoryCode":@"MSC357"}];
            [self.popTbl reloadData];
            isCategory = YES;
    
    }
    else
    {
        self.popTbl.hidden = YES;
        isCategory = NO;
        isPlayer = NO;
        isShare = NO;
        isModule = NO;
    }
}

-(IBAction)didClickShareUserList:(id)sender
{
    self.popTblYposition.constant = self.sharetoUserView.frame.origin.y-20;
    self.popTblwidthposition.constant = self.sharetoUserView.frame.size.width;
    self.popTblXposition.constant = -410;

    if(isShare== NO)
    {
    
            self.popTbl.hidden = NO;
            self.commonArray = [[NSMutableArray alloc]init];
            self.commonArray = self.sharetouserArray;
            [self.popTbl reloadData];
            isShare = YES;
    
    }
    else
    {
        self.popTbl.hidden = YES;
        isCategory = NO;
        isPlayer = NO;
        isShare = NO;
        isModule = NO;
        
    }
}

-(IBAction)didClickDatePicker:(id)sender
{
    [self DisplaydatePicker];
}

# pragma Date Picker

-(void)DisplaydatePicker
{
    if(self.datePicker!= nil)
    {
        [self.datePicker removeFromSuperview];
        
    }
    self.date_view.hidden=NO;
    //isStartDate =YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    self.datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.date_view.frame.origin.y-230,self.view.frame.size.width,100)];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [self.datePicker setLocale:locale];
    
    // [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self.datePicker reloadInputViews];
    [self.date_view addSubview:self.datePicker];
    
}

-(IBAction)showSelecteddate:(id)sender{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString * actualDate = [dateFormat stringFromDate:DatePicker.date];
    
    _txtVideoDate.text = actualDate;
    [self.view endEditing:true];
//    [_txtVideoDate resignFirstResponder];
}

- (IBAction)datePickerAction:(id)sender {
    
    _txtVideoDate.text = @"";
        //    [_txtVideoDate resignFirstResponder];
    [self.view endEditing:true];
}


- (void) displaySelectedDateAndTime:(UIDatePicker*)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString * actualDate = [dateFormat stringFromDate:DatePicker.date];
    
    _txtVideoDate.text = actualDate;
}

-(IBAction)didClickCameraBtn:(id)sender
{
   
    videoPicker = [[UIImagePickerController alloc]init];
    videoPicker.delegate = self;
    videoPicker.allowsEditing = YES;
    
    videoPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    if([self.titleLbl.text isEqualToString:@"Videos"]){
        videoPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//        videoPicker.showsCameraControls = NO;
        videoPicker.videoMaximumDuration = 30;
        videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;

    }
    else{
        videoPicker.showsCameraControls = YES;
        videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

    }

//    [appDel.frontNavigationController presentViewController:videoPicker animated:YES completion:nil];

    [self presentViewController:videoPicker animated:YES completion:nil];
    
}
-(IBAction)didClickGalleryBtn:(id)sender
{
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    if([self.titleLbl.text isEqualToString:@"Videos"]){
        
        imagePicker.mediaTypes =@[(NSString *) kUTTypeMovie,(NSString *) kUTTypeVideo];
    }
    else{
        imagePicker.mediaTypes =@[(NSString *) kUTTypeImage,(NSString *) kUTTypePDF ,(NSString *)kUTTypeRTFD];
    }
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)didClickCloudDrive:(id)sender {
    
    [self showDocumentPickerInMode:UIDocumentPickerModeOpen];

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
        imgDatas = [[NSData alloc] initWithContentsOfFile:str];
        imgFileName = [[info valueForKey:@"UIImagePickerControllerImageURL"] lastPathComponent];
        selectedImageView.image = info[UIImagePickerControllerOriginalImage];

    }
    else
    {
        NSURL* videofileURL = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
        imgDatas = [[NSData alloc] initWithContentsOfURL:videofileURL];
        selectedImageView.image = [self generateThumbImage:videofileURL];
        imgFileName = [[info valueForKey:@"UIImagePickerControllerMediaURL"] lastPathComponent];
        
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    
    imgData = [imgDatas base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (!imgFileName) {
        
        imgFileName = [self getFileName];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        //_ImgViewBottomConst.constant = _imgView.frame.size.height;
        [_imgView updateConstraintsIfNeeded];
        self.currentlySelectedImage.image = image;
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.view setFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.frame))];
}


- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark- Open Document Picker(Delegate) for PDF, DOC Slection from iCloud


- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode
{
    
    //    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    
    NSArray* DocType = @[@"public.image",@"public.text",@"com.adobe.pdf "];
    if([self.titleLbl.text isEqualToString:@"Videos"]){
        DocType = @[@"public.movie"];
    }

    
//    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.image", @"public.audio", @"public.movie", @"public.text", @"public.item",@"public.content", @"public.source-code"] inMode:UIDocumentPickerModeImport];
    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:NSRTFTextDocumentType inMode:UIDocumentPickerModeImport];

    
    picker.delegate = self;
    
    picker.modalPresentationStyle = UIModalPresentationPopover;
    //    picker.popoverPresentationController.sourceRect = btnGallery.frame;
    picker.popoverPresentationController.sourceView = self.btnCloud;
    
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    NSLog(@"selected file URL %@",url);
//    videofileURL = url;
    imgData = [[NSData alloc] initWithContentsOfURL:url];
    selectedImageView.image = [self generateThumbImage:url];
    
    //    PDFUrl= url;
    //    UploadType=@"PDF";
    //    [arrimg removeAllObjects];
    //    [arrimg addObject:url];
    
}

-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    AVAsset *asset = [AVAsset assetWithURL:filepath];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    
    NSError *err = NULL;
    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:CMTimeMake(1, 60) actualTime:NULL error:&err];
    UIImage* thumbnail = [[UIImage alloc] initWithCGImage:imgRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
    
//    UIImage* thumbnail = nil;
    return thumbnail;
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
- (void)showAnimate
{
    self.popTbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.popTbl.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.popTbl.alpha = 1;
        self.popTbl.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.popTbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.popTbl.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            // [self.popTblView removeFromSuperview];
            self.popTbl.hidden = YES;
        }
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return buttonTag == 4 ? 45 : 0;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(buttonTag == 4)
    {
    static NSString *cellIdentifier = @"Header";
    HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"HeaderTableViewCell" owner:self options:nil];
    if (cell == nil)
    {
        cell = array[0];
    }
    
    [cell.Donebtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
        
    }
    else{
        return  nil;
    }
}

-(void)actionDone{
    
[self closeDropDownView:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.commonArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(buttonTag == 4)
//    {
//
//
//
//            static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
//            CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
//
//            if (cell == nil) {
//                cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRTableViewCellIdentifier];
//            }
//
//            plyCode = [self.commonArray objectAtIndex:indexPath.row];
//            NSString *text = [[self.commonArray valueForKey:@"sharedUserName"] objectAtIndex:[indexPath row]];
//            cell.isSelected = [self.selectedMarks containsObject:plyCode] ? YES : NO;
//            cell.textLabel.text = text;
//            return cell;
//
//
//    }
    static NSString *MyIdentifier = @"CategoryCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (buttonTag == 0) // team
    {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
    }
    else if (buttonTag == 1) // player
    {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"PlayerName"];
    }
    else if (buttonTag == 2) // category
    {
        cell.textLabel.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"categoryName"];
    }
    else if (buttonTag == 3) // type
    {
        cell.textLabel.text = [self.commonArray objectAtIndex:indexPath.row];
    }
    else if(buttonTag == 4){
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.text = [[self.commonArray valueForKey:@"sharedUserName"] objectAtIndex:indexPath.row];
        
        plyCode = [self.commonArray objectAtIndex:indexPath.row];
//        NSString *text = [[self.commonArray valueForKey:@"sharedUserName"] objectAtIndex:[indexPath row]];
//        cell.isSelected = [self.selectedMarks containsObject:plyCode] ? YES : NO;
        
        if ([self.selectedMarks containsObject:plyCode]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    
    return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (buttonTag == 0) // team
    {
        module_lbl.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamName"];
        correspondingTeamCode = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"TeamCode"];
        [self closeDropDownView:nil];
    }
    else if (buttonTag == 1) // player
    {
        player_lbl.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"PlayerName"];
        selectPlayer = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"PlayerCode"];
        [self closeDropDownView:nil];
    }
    else if (buttonTag == 2) // category
    {
        category_lbl.text = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"categoryName"];
        SelectedcategoryCode = [[self.commonArray objectAtIndex:indexPath.row] valueForKey:@"categoryCode"];
        [self closeDropDownView:nil];
    }
    else if (buttonTag == 3) // type
    {
        objKeyword_Txt.text = [self.commonArray objectAtIndex:indexPath.row];
        [self closeDropDownView:nil];
    }
    else if (buttonTag == 4)
    {
        
        plyCode = [self.commonArray objectAtIndex:indexPath.row];
        if ([self.selectedMarks containsObject:plyCode])// Is selected?
            [self.selectedMarks removeObject:plyCode];
        else
            [self.selectedMarks addObject:plyCode];
        
        
        self.shareuser_lbl.text = [[self.selectedMarks valueForKey:@"sharedUserName"] componentsJoinedByString:@","];
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
        
//        CRTableViewCell *cell = (CRTableViewCell *)[self.popTbl dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
//        cell.isSelected = [self.selectedMarks containsObject:plyCode] ? YES : NO;
//
//
//
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//        int a = self.selectedMarks.count;
//        if(a == 0)
//        {
//            //NSString *b = [NSString stringWithFormat:@"%d", a];
//            self.shareuser_lbl.text = @"";
//        }
//        if(a == 1)
//        {
//            //NSString *b = [NSString stringWithFormat:@"%d", a];
//            self.shareuser_lbl.text = [NSString stringWithFormat:@"%d item selected", a];
//        }
//        else
//        {
//            self.shareuser_lbl.text = [NSString stringWithFormat:@"%d items selected", a];
//        }
//        isShare = NO;
    }
    
//    self.popTbl.hidden = YES;
//    [tapView setHidden:YES];
    //self.catagory_lbl.text = [[self.commonArray valueForKey:@"CategoryName"] objectAtIndex:indexPath.row];
    
    
}

-(void)sendReplyMessageWebService
{
    
    if(![COMMON isInternetReachable])
        return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [AppCommon showLoading];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * url = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",SendMessageKey]];
    
    NSLog(@"USED API URL %@",url);
    NSLog(@"USED PARAMS %@ ",dic);
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        [self resetImageData];
        
        mainArray = [NSMutableArray new];
        mainArray = responseObject;
        chatArray = [NSMutableArray new];
        chatArray = [mainArray valueForKey:@"lstallmessages"];
        dispatch_async(dispatch_get_main_queue(), ^{
           // _ImgViewBottomConst.constant = -_imgView.frame.size.height;
            [_imgView updateConstraintsIfNeeded];
            _currentlySelectedImage.image = nil;
            
            if (chatArray.count == 0) {
                return ;
            }
            
           // [self.tblChatList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:chatArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            //[self.tblChatList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        });
        
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppCommon hideLoading];
        [self resetImageData];
        NSLog(@"SEND MESSAGE ERROR %@ ",error.description);
        //[COMMON webServiceFailureError];
    }];
    
    
}
-(void)resetImageData
{
    imgData = @"";
    imgFileName = @"";
   
    
}
-(IBAction)didClickUpload:(id)sender
{
    if([self.player_lbl.text isEqualToString:@""] || self.player_lbl.text == nil)
    {
        [self altermsg:@"Please select player"];
    }
    else if ([self.category_lbl.text isEqualToString:@""] || self.category_lbl.text == nil)
    {
        [self altermsg:@"Please select category"];

    }
//    else if ([self.date_lbl.text isEqualToString:@""] || self.date_lbl.text == nil)
//    {
//        [self altermsg:@"Please select date"];
//
//    }
    else if ([self.objKeyword_Txt.text isEqualToString:@""] || self.objKeyword_Txt.text == nil)
    {
        [self altermsg:@"Please Type keyword"];

    }
    else if ([self.shareuser_lbl.text isEqualToString:@""] || self.shareuser_lbl.text == nil)
    {
        [self altermsg:@"Please Select Shareuser"];

    }
    else
    {
    
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString * createdby = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    if(![COMMON isInternetReachable])
        return;
    
    [AppCommon showLoading];
    
     NSString *URLString;
    
    if ([self.titleString isEqualToString:@"Videos"]) {
        URLString =  URL_FOR_RESOURCE(VideoUpload);
    } else {
        URLString =  URL_FOR_RESOURCE(DocumentUpload);
    }
   
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
        NSString * comments = @"";
        NSString * videoCode= @"";
        NSString * sharedUserID = [[self.selectedMarks valueForKey:@"sharedUserCode"] componentsJoinedByString:@","];
        
    /*
     plyer code
     teamcode
     category
     type -keyword
     */
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ClientCode)   [dic    setObject:ClientCode     forKey:@"clientCode"];
        if(createdby)   [dic    setObject:createdby     forKey:@"Createdby"];
        
        selectModule = @"MSC084 "; // MSC084 moduleCode - coach
    
        if ([self.titleString isEqualToString:@"Videos"]) {
            if(selectModule)   [dic    setObject:selectModule     forKey:@"moduleCode"];
            if(self.txtVideoDate.text)   [dic    setObject:self.txtVideoDate.text     forKey:@"videoDate"];
//            if(imgFileName)   [dic    setObject:imgFileName  forKey:@"documentFile"];
            
             if(imgFileName)   [dic    setObject:imgFileName  forKey:@"videoFile"];
            if(correspondingTeamCode)   [dic    setObject:correspondingTeamCode     forKey:@"teamCode"];
            if(self.objKeyword_Txt.text)   [dic    setObject:self.objKeyword_Txt.text     forKey:@"keyWords"];
        } else {
            if(selectModule)   [dic    setObject:selectModule     forKey:@"Modulecode"];
            if(self.txtVideoDate.text)   [dic    setObject:self.txtVideoDate.text     forKey:@"Uploaddate"];
             if(imgFileName)   [dic    setObject:imgFileName  forKey:@"DocumentFilename"];
            if(correspondingTeamCode)   [dic    setObject:correspondingTeamCode     forKey:@"TeamCode"];
            if(self.objKeyword_Txt.text)   [dic    setObject:self.objKeyword_Txt.text     forKey:@"KeyWords"];
        }
    
        //    if(selectGameCode)   [dic    setObject:selectGameCode     forKey:@"gameCode"];
        
        //        correspondingTeamCode = @"TEA0000004";
        if(imgFileName)   [dic    setObject:imgFileName  forKey:@"filename"];
    
        
        //        selectPlayer = @"AMR0000001";
        if(selectPlayer)   [dic    setObject:selectPlayer     forKey:@"playerCode"];
    
        if(SelectedcategoryCode)   [dic    setObject:SelectedcategoryCode     forKey:@"categoryCode"];
    
        //    if(comments)   [dic    setObject:@""    forKey:@"comments"];
    
    
        //
        //    if(videoCode)   [dic    setObject:videoCode  forKey:@"videoCode"];
        //        sharedUserID = @"AMR0000059,AMR000005";
        if(sharedUserID) [dic setObject:sharedUserID forKey:@"shareduserid"];
        NSLog(@"USED PARAMS %@ ",dic);
        
        if(imgData) [dic setObject:imgData forKey:@"newmessagephoto"];
        
        NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];

        [AppCommon showLoading];
        NSLog(@"USED PARAMS %@ ",dic);
        
        [manager POST:URLString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppCommon hideLoading];

            NSLog(@"Success: %@", responseObject);
            [self resetImageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Update the UI
                [AppCommon hideLoading];
                
                if([[responseObject valueForKey:@"Status"] integerValue] == 1)
                {
                    
                    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:alertTitle message:[NSString stringWithFormat:alertMessage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    objaltert.tag = 501;
                    [objaltert show];
                [appDel.frontNavigationController popViewControllerAnimated:YES];
                    //                [appDel.frontNavigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                 
                    [self altermsg:alertFailed];
                }
                
            });

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppCommon hideLoading];
            [self resetImageData];
            NSLog(@"SEND MESSAGE ERROR %@ ",error.description);
            [COMMON webServiceFailureError:error];
        }];
    }
}

-(void)altermsg:(NSString *)msg
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Alert"
                                message:msg
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)didClickCancelBtnAction:(id)sender
{
    
    
//    [appDel.frontNavigationController dismissViewControllerAnimated:YES completion:nil];
    [appDel.frontNavigationController popViewControllerAnimated:YES];
   
}
- (IBAction)actionShowDropDown:(id)sender {
    [popTbl setHidden:NO];
    [tapView setHidden:NO];

    buttonTag = [sender tag];
    
    if ([sender tag] == 0) // team
    {
//        self.commonArray = appDel.ArrayTeam;
        self.commonArray = self.objTeamArray;
        [popTbl setFrame:CGRectMake(CGRectGetMinX(self.teamView.frame)+10, CGRectGetMaxY(self.teamView.superview.frame)-80, CGRectGetWidth(self.teamView.frame), self.commonArray.count >= 5? 200:45*self.commonArray.count)];

    }
    else if ([sender tag] == 1) // player
    {
        self.commonArray = [self getCorrespoingPlayerForthisTeamCode:correspondingTeamCode];
        [popTbl setFrame:CGRectMake(CGRectGetMinX(self.playerView.frame)+10, CGRectGetMaxY(self.playerView.superview.frame)-80, CGRectGetWidth(self.playerView.frame), self.commonArray.count >= 5? 200:45*self.commonArray.count)];

    }
    else if ([sender tag] == 2) // category
    {
        NSArray* arr1 = @[@{@"categoryName":@"Batting",@"categoryCode":@"MSC356"},
                        @{@"categoryName":@"Bowling",@"categoryCode":@"MSC357"}];

        self.commonArray = arr1;
        [popTbl setFrame:CGRectMake(CGRectGetMinX(self.CategoryView.frame)+10, CGRectGetMaxY(self.CategoryView.superview.frame)-20, CGRectGetWidth(self.CategoryView.frame), self.commonArray.count >= 5? 200:45*self.commonArray.count)];

    }
    else if ([sender tag] == 3) // type
    {
        NSArray* arr1 = @[@"Beaten",@"Boundaires",@"Dotballs",@"Dismissals"];
        NSArray* arr2 = @[@"Beaten",@"Boundaires",@"Dotballs",@"Variations"];
    
        if ([category_lbl.text isEqualToString:@"Batting"]) {
            self.commonArray = arr1;
        }
        else {
            self.commonArray = arr2;
        }
    
        popTbl.frame = CGRectMake(keywordsView.frame.origin.x+10, CGRectGetMaxY(keywordsView.superview.frame)+15, keywordsView.frame.size.width, self.commonArray.count >= 5? 200:45*self.commonArray.count);

    }
    else if ([sender tag] == 4) // share to user
    {
    
    isShare = YES;
        self.commonArray = self.sharetouserArray;
        popTbl.frame = CGRectMake(sharetoUserView.frame.origin.x+10, CGRectGetMaxY(sharetoUserView.superview.frame)+55, sharetoUserView.frame.size.width, self.commonArray.count >= 5? 200:45*self.commonArray.count);
    
    }
//    [popTbl removeFromSuperview];
//    [tapView addSubview:popTbl];
    [popTbl reloadData];
   
}

-(NSArray *)getCorrespoingPlayerForthisTeamCode:(NSString* )teamcode
{
    NSArray* result;
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"TeamCode == %@", teamcode];
//    result = [appDel.ArrayIPL_teamplayers filteredArrayUsingPredicate:resultPredicate];
    result = [self.objPlayerArray filteredArrayUsingPredicate:resultPredicate];
    
    return result;
}

- (IBAction)didClickType:(id)sender {
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == [alertView cancelButtonIndex])
        {
        alertView.hidden=YES;
        }
    else if (alertView.tag == 501)
        {
        self.module_lbl.text =@"";
        self.player_lbl.text =@"";
        self.txtVideoDate.text =@"";
        self.category_lbl.text =@"";
        self.objKeyword_Txt.text =@"";
        self.shareuser_lbl.text =@"";
        }
}

-(IBAction)closeDropDownView:(id)sender{
    
    [tapView setHidden:YES];
    [popTbl setHidden:YES];
    
}

@end
