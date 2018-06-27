//
//  InjuryVC.m
//  APT_V2
//
//  Created by Mac on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "InjuryVC.h"
#import "CustomNavigation.h"
#import "SWRevealViewController.h"
#import "InjurySelectionViewController.h"

typedef enum {
    kDelayed,
    kTraumatic
} OnSetType;

@interface InjuryVC () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,InjuryDelegate>
{
    BOOL isOccurrence;
    BOOL isLocation;
    BOOL isSite;
    BOOL isType;
    BOOL isCasuse;
    BOOL isSelectPop;
    NSString* selectsliderValue;
    NSString *mrData;
    NSString *ctData;
    NSString *xrData;
    WebService * objWebservice;
    NSString * selectGameCode;
    NSString * selectTeamCode;
    NSString * selectPlayerCode;
    NSString* selectCauseCode;
    NSString * selectOnsetTypeCode;
    NSString * selectInjuryOccuranceCode;
    NSString * selectInjurySideCode;
    NSString * selectInjuryLocationCode;
    NSString * selectInjurySiteCode;
    NSString * selectExpertOpinionCode;
    NSString * injuryTypeCode;
    NSString * injuryCausecode;
    NSString * selectoccurancecode;
    NSString * selectlocationCode;
    NSString * usercode;
    
    NSString * selectInjuryCode;
    NSString * VasValue;
    UIImage *imageToPost;
    BOOL * currentlySelectedDate;
    
    BOOL isGame;
    BOOL isTeam;
    BOOL isPlayer;
    BOOL isinjuryType;
    BOOL isinjuryCause;
    BOOL isAssessment;
    BOOL isOnset;
    BOOL isExpected;
    BOOL islocation;
    
    BOOL isXray;
    BOOL isCT;
    BOOL isMRI;
    BOOL isBlood;
    NSInteger selectedFileType;
    NSInteger* dateTag;
    NSMutableArray* imageArray;
    NSString* assDate,* onSetDate;
}

@property (weak, nonatomic) IBOutlet UILabel *lblFile1;
@property (weak, nonatomic) IBOutlet UILabel *lblFile2;
@property (weak, nonatomic) IBOutlet UILabel *lblFile3;
@property (weak, nonatomic) IBOutlet UILabel *lblFIle4;
//@property (weak, nonatomic) IBOutlet CustomButton *btnAssment;
//@property (weak, nonatomic) IBOutlet CustomButton *btnOnsetDate;

@property (nonatomic,strong) NSMutableArray * gameArray;
@property (nonatomic,strong) NSMutableArray * TeamArray;
@property (nonatomic,strong) NSMutableArray * playerArray;

@property (nonatomic,strong) NSMutableArray * TrainingArray;
@property (nonatomic,strong) NSMutableArray * competitionArray;
@property (nonatomic,strong) NSMutableArray * headandtruckArray;
@property (nonatomic,strong) NSMutableArray * upperextremityArray;
@property (nonatomic,strong) NSMutableArray * lowerextremityArray;
@property (nonatomic,strong) NSMutableArray * injuryTypeArray;
@property (nonatomic,strong) NSMutableArray * injuryCauseArray;
@property (nonatomic,strong) NSMutableArray * objSelectInjuryArray;

@property (nonatomic,strong) NSMutableArray * SelectOccuranceArray;
@property (nonatomic,strong) NSMutableArray * SelectLocationArray;
@property (nonatomic,assign)  BOOL isUpdate;


@end

@implementation InjuryVC


@synthesize btnF1,btnF2,btnF3,btnF4;

@synthesize TeamCode,txtInjuryName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    objWebservice = [WebService new];
    _MainArray = [NSMutableArray new];
    [self setBorderwidthMethod];
    
    
    self.Slider1.labels = @[@"1", @"2", @"3", @"4", @"5",@"6",@"7"];
    self.Slider1.maxCount = 7;
    self.Slider1.trackHeight = 4;
    self.Slider1.trackCircleRadius = 5;
    self.Slider1.trackColor = [UIColor grayColor];
    self.Slider1.sliderCircleColor = [UIColor redColor];
    self.Slider1.labelColor = [UIColor whiteColor];
    self.Slider1.sliderCircleRadius = self.Slider1.trackCircleRadius+10;
    
    
    self.TrainingArray =[[NSMutableArray alloc]init];
    self.competitionArray =[[NSMutableArray alloc]init];
    self.headandtruckArray =[[NSMutableArray alloc]init];
    self.upperextremityArray =[[NSMutableArray alloc]init];
    self.lowerextremityArray =[[NSMutableArray alloc]init];
    self.injuryTypeArray =[[NSMutableArray alloc]init];
    self.injuryCauseArray =[[NSMutableArray alloc]init];
    
    self.gameArray =[[NSMutableArray alloc]init];
    self.TeamArray =[[NSMutableArray alloc]init];
    self.playerArray =[[NSMutableArray alloc]init];
    _commonArray = [NSMutableArray new];
    
//    NSDictionary* occurance = @{@"occurance":@[@"Training",@"Competition"]};
//    NSDictionary* location = @{@"location":@[@"Header & Trunk",@"Upper Extremity",@"Lower Extremity"]};
//    NSDictionary* injurySite = @{@"injurysite":@[@"Anterior",@"Posterior",@"Medical",@"Lateral"]};
    [self startFetchTeamPlayerGameService];
    selectsliderValue = 0;
    
    [self setInningsBySelection:@"1"];
    [self setInningsBySelection:@"6"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SWRevealViewController *revealController = [self revealViewController];
    [revealController.panGestureRecognizer setEnabled:NO];
    [revealController.tapGestureRecognizer setEnabled:NO];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(NSArray *)getInjurySite
{
    NSArray* arr = @[@{@"name":@"Anterior",@"code":@"MSC165"},
                     @{@"name":@"Posterier",@"code":@"MSC167"},
                     @{@"name":@"Medical",@"code":@"MSC166"},
                     @{@"name":@"Lateral",@"code":@"MSC168"},
                     ];
    return arr;
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [self.navigation_view addSubview:objCustomNavigation.view];
    
    objCustomNavigation.btn_back.hidden =NO;
    objCustomNavigation.menu_btn.hidden =YES;
            [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}


-(void)actionBack
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [appDel.frontNavigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setBorderwidthMethod
{
    self.compliant_Txt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.compliant_Txt.layer.borderWidth = 1.0;
    self.compliant_Txt.layer.masksToBounds = YES;
    
    self.comfirmatory_Txt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.comfirmatory_Txt.layer.borderWidth = 1.0;
    self.comfirmatory_Txt.layer.masksToBounds = YES;
    
    self.diagnosis_Txt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.diagnosis_Txt.layer.borderWidth = 1.0;
    self.diagnosis_Txt.layer.masksToBounds = YES;
    
    self.delay_Btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.delay_Btn.layer.borderWidth = 1.0;
    self.delay_Btn.layer.masksToBounds = YES;
    
    self.tur_Btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tur_Btn.layer.borderWidth = 1.0;
    self.tur_Btn.layer.masksToBounds = YES;
    
    self.right_Btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.right_Btn.layer.borderWidth = 1.0;
    self.right_Btn.layer.masksToBounds = YES;
    
    self.left_Btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.left_Btn.layer.borderWidth = 1.0;
    self.left_Btn.layer.masksToBounds = YES;
    
    self.expectedright_Btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.expectedright_Btn.layer.borderWidth = 1.0;
    self.expectedright_Btn.layer.masksToBounds = YES;
    
    self.expectedLeft_Btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.expectedLeft_Btn.layer.borderWidth = 1.0;
    self.expectedLeft_Btn.layer.masksToBounds = YES;
    
    self.date_lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.date_lbl.layer.borderWidth = 1.0;
    self.date_lbl.layer.masksToBounds = YES;
    
    self.pop_Tbl.layer.borderColor = [UIColor brownColor].CGColor;
    self.pop_Tbl.layer.borderWidth = 1.0;
    self.pop_Tbl.layer.masksToBounds = YES;
    
    self.pop_Tbl.layer.cornerRadius = 10;
    self.pop_Tbl.layer.masksToBounds =YES;
    
    self.pop_Tbl.hidden= YES;
}

-(IBAction)didClickOccurrencePopBtn:(id)sender
{
    [self.pop_Tbl setHidden:NO];
    self.popviewYposition.constant = CGRectGetMaxY(self.occurancelbl.frame)-50;
    self.popviewXposition.constant = CGRectGetMinX(self.occurancelbl.superview.frame);
    self.popviewWidth.constant = CGRectGetWidth(self.occurancelbl.superview.frame);
    [self.pop_Tbl updateConstraintsIfNeeded];
    
    
    
    
    isOccurrence = YES;
    isCasuse = NO;
    islocation = NO;
    isSite = NO;
    isType = NO;
    
    self.commonArray =[[NSMutableArray alloc]init];
    // _commonArray = [_MainArray valueForKey:@"Training"];
    
    _commonArray = [_MainArray valueForKey:@"lstInjuryOccurance"];
    
    [self.pop_Tbl reloadData];
    [self showAnimate];
    
}

-(IBAction)didClickLocationPopBtn:(id)sender
{
    [self.pop_Tbl setHidden:NO];
    self.popviewYposition.constant = CGRectGetMaxY(self.locationlbl.frame);
    self.popviewXposition.constant = CGRectGetMinX(self.locationlbl.superview.frame);
    self.popviewWidth.constant = CGRectGetWidth(self.locationlbl.superview.frame);
    [self.pop_Tbl updateConstraintsIfNeeded];

    
    islocation = YES;
    isCasuse = NO;
    isOccurrence = NO;
    isSite = NO;
    isType = NO;
    

    self.commonArray =[[NSMutableArray alloc]init];
   // _commonArray = [_MainArray valueForKey:@"Training"];
    _commonArray = [_MainArray valueForKey:@"lstInjuryLocation"];
    
        [self.pop_Tbl reloadData];
        [self showAnimate];
    
}

-(IBAction)didClicksitePopBtn:(id)sender
{
    [self.pop_Tbl setHidden:NO];
    self.popviewYposition.constant = CGRectGetMaxY(self.sitelbl.frame)+100;
    self.popviewXposition.constant = CGRectGetMinX(self.sitelbl.superview.frame);
    self.popviewWidth.constant = CGRectGetWidth(self.sitelbl.superview.frame);
    [self.pop_Tbl updateConstraintsIfNeeded];

   
    
    

    isSite = YES;
    isCasuse = NO;
    isOccurrence = NO;
    islocation = NO;
    isType = NO;
    
    self.commonArray =[[NSMutableArray alloc]init];
    // _commonArray = [self getInjurySite];
    
    _commonArray = [_MainArray valueForKey:@"lstInjurySite"];
    
    [self.pop_Tbl reloadData];
    [self showAnimate];
}

-(IBAction)didClickTypeBtn:(id)sender
{
    
    [self.pop_Tbl setHidden:NO];
//    self.popviewYposition.constant = CGRectGetMaxY(self.type_view.frame);
    self.popviewYposition.constant = self.TypeAndCaseView.frame.origin.y-100;
    self.popviewXposition.constant = CGRectGetMinX(self.typelbl.superview.frame);
    self.popviewWidth.constant = CGRectGetWidth(self.typelbl.superview.frame);
    
    [self.pop_Tbl updateConstraintsIfNeeded];
//    [self.pop_Tbl.topAnchor constraintEqualToAnchor:self.typelbl.bottomAnchor constant:0];
//    [self.pop_Tbl.leadingAnchor constraintEqualToAnchor:self.typelbl.superview.leadingAnchor];
//    [self.pop_Tbl.widthAnchor constraintEqualToAnchor:self.typelbl.superview.widthAnchor];
//    [self.pop_Tbl.heightAnchor constraintEqualToConstant:200];
//    [self.pop_Tbl setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    

//    self.popviewYposition.constant = CGRectGetMaxY(self.occurrence_view.frame)+5;
//    self.popviewXposition.constant = CGRectGetMinX(self.occurrence_view.frame);
//    self.popviewWidth.constant = CGRectGetWidth(self.occurrence_view.frame);
//    [self.pop_Tbl updateConstraintsIfNeeded];


    isType = YES;
    isCasuse = NO;
    isOccurrence = NO;
    islocation = NO;
    isSite = NO;
    
    self.commonArray =[[NSMutableArray alloc]init];
   // _commonArray = [_MainArray valueForKey:@"InjuryType"];
     _commonArray = [_MainArray valueForKey:@"lstInjuryType"];
    
    [self.pop_Tbl reloadData];
    [self showAnimate];
    
}
-(IBAction)didClickCasuseBtn:(id)sender
{
    [self.pop_Tbl setHidden:NO];
   // self.popviewYposition.constant = CGRectGetMaxY(self.casuse_view.frame);
    self.popviewYposition.constant = self.TypeAndCaseView.frame.origin.y-100;
    self.popviewXposition.constant = CGRectGetMinX(self.causelbl.superview.frame);
    self.popviewWidth.constant = CGRectGetWidth(self.causelbl.superview.frame);
    [self.pop_Tbl updateConstraintsIfNeeded];


    isCasuse = YES;
    isType = NO;
    isOccurrence = NO;
    islocation = NO;
    isSite = NO;
    self.commonArray =[[NSMutableArray alloc]init];
//    _commonArray = [_MainArray valueForKey:@"InjuryCause"];
    _commonArray = [_MainArray valueForKey:@"lstInjuryCase"];
    
    [self.pop_Tbl reloadData];
    [self showAnimate];
    
}

-(IBAction)didClickDelayBtn:(id)sender
{
    [self setInningsBySelection:@"1"];
}

-(IBAction)didClickTramaticBtn:(id)sender
{
    [self setInningsBySelection:@"2"];
}
-(IBAction)didClicksideLeftBtn:(id)sender
{
    [self setInningsBySelection:@"3"];
}
-(IBAction)didClickSideRightBtn:(id)sender
{
    [self setInningsBySelection:@"4"];
}
-(IBAction)didClickExpectedLeftBtn:(id)sender
{
    [self setInningsBySelection:@"5"];
}
-(IBAction)didClickExpectedRightBtn:(id)sender
{
    [self setInningsBySelection:@"6"];
}

-(IBAction)didClickfilePopview:(id)sender
{
    
    self.fileView.frame = self.view.frame;
    self.filepopview.frame = CGRectMake(self.filepopview.frame.origin.x, self.view.frame.size.height+self.filepopview.frame.size.height, self.fileView.frame.size.height, self.filepopview.frame.size.height);
    
    [self.view addSubview:self.fileView];

    [self animationB2T];
}

-(void)animationB2T
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            
                            self.filepopview.frame = CGRectMake(self.filepopview.frame.origin.x, self.view.frame.size.height-self.filepopview.frame.size.height, self.fileView.frame.size.height, self.fileView.frame.size.height);
                            
                            
                        } completion:^(BOOL finished) {
                            
                        }];

}

- (void)showAnimate
{
    self.pop_Tbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.pop_Tbl.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.pop_Tbl.alpha = 1;
        self.pop_Tbl.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.pop_Tbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.pop_Tbl.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.pop_Tbl.hidden = YES;
        }
    }];
}

-(void) setInningsBySelection: (NSString*) innsNo{
    
//    [self setInningsButtonUnselect:self.delay_Btn];
//    [self setInningsButtonUnselect:self.tur_Btn];
//    [self setInningsButtonUnselect:self.right_Btn];
//    [self setInningsButtonUnselect:self.left_Btn];
//    [self setInningsButtonUnselect:self.expectedright_Btn];
//    [self setInningsButtonUnselect:self.expectedLeft_Btn];

    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonUnselect:self.tur_Btn];

        [self setInningsButtonSelect:self.delay_Btn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonUnselect:self.delay_Btn];

        [self setInningsButtonSelect:self.tur_Btn];
    }
    else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonUnselect:self.right_Btn];

        [self setInningsButtonSelect:self.left_Btn];
    }
    else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonUnselect:self.left_Btn];

        [self setInningsButtonSelect:self.right_Btn];
    }
    else if([innsNo isEqualToString:@"5"]){
        [self setInningsButtonUnselect:self.expectedright_Btn];

        [self setInningsButtonSelect:self.expectedLeft_Btn];
    }
    else if([innsNo isEqualToString:@"6"]){
        [self setInningsButtonUnselect:self.expectedLeft_Btn];
        [self setInningsButtonSelect:self.expectedright_Btn];
    }
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}

-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2CA7DB"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    innsBtn.tag = 1;
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#FFFFFF"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    innsBtn.tag = 0;
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

-(void)FetchInjuryListWebService
{
    if(![COMMON isInternetReachable])
        return;
    
        
        NSString *URLString =  URL_FOR_RESOURCE(FetchInjuryList);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        NSString* cliendCode = [AppCommon GetClientCode];
        NSString* userRefcode = [AppCommon GetuserReference];

        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(cliendCode)   [dic    setObject:cliendCode     forKey:@"ClientCode"];
        if(userRefcode)   [dic    setObject:userRefcode     forKey:@"Userreferencecode"];
        
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                _MainArray = responseObject;
//                self.InjuryListArray =[[NSMutableArray alloc] init];
//                self.InjuryListArray =[responseObject valueForKey:@"InjuryWebs"];
//                if(self.InjuryListArray.count>0)
//                {
////                    [self.injuryTbl reloadData];
//                    
//                    
//                }
            }
            
            [AppCommon hideLoading];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            
        }];
    
}

- (IBAction)actionVisualSelection:(id)sender {
    
    InjurySelectionViewController* selectedVC = [InjurySelectionViewController new];
    selectedVC.selectedImageArray = imageArray;
    selectedVC.injuryDelegate = self;
    [appDel.frontNavigationController presentViewController:selectedVC animated:YES completion:nil];
    
}

-(NSString* )getOnSetType
{
    NSString* str = @"";
    NSArray* arr = @[_delay_Btn,_tur_Btn];
    for (UIButton* btn in arr) {
        if (btn.tag) {
            str = btn.titleLabel.text;
            break;
        }
    }
    
    return str;
}

- (IBAction)getSliderValue_VAS:(id)sender {
    
    selectsliderValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.Slider1.index];
}

-(NSString *)getExpertOption
{
    NSString* str = @"";
    NSArray* arr = @[_left_Btn,_right_Btn];
    for (UIButton* btn in arr) {
        if (btn.tag) {
            str = btn.titleLabel.text;
            break;
        }
    }
    
    return str;
}


- (IBAction)actionOpenDate:(id)sender {
    
    CalendarViewController  * objTabVC = [CalendarViewController new];
    //    objTabVC.datePickerFormat = @"yyy-MM-dd"; // 2/9/2018 12:00:00 AM // 06-22-2018
    objTabVC.datePickerFormat = @"MM-dd-yyy";
    objTabVC.datePickerDelegate = self;
    objTabVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    objTabVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [objTabVC.view setBackgroundColor:[UIColor clearColor]];
    
    [self presentViewController:objTabVC animated:YES completion:^{
        dateTag = [sender tag];
    }];
    
}

-(void)selectedDate:(NSString *)Date
{
    if (dateTag == 0) {
//        NSString* str_date = [NSString stringWithFormat:@"Assessment Date \n %@",Date];
        self.btnAssment.titleLabel.text = Date;
        assDate = Date;
    }
    else if(dateTag == 1)
    {
//        NSString* str_date = [NSString stringWithFormat:@"Onset Date \n %@",Date];
        self.btnOnsetDate.titleLabel.text = Date;
        onSetDate = Date;
    }
    else
    {
        self.date_lbl.text = Date;

    }
    
    NSLog(@"selectedDate %@ ",Date);
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(void)opengallery
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * objPath =[[picker valueForKey:@"mediaTypes"] objectAtIndex:0];
    NSString *savedImagePath =   [documentsDirectory stringByAppendingPathComponent:objPath];
    imageToPost = image;
    
    if(isXray ==YES)
    {
//        self.imgFile1.image = image;
        [btnF1 setBackgroundImage:image forState:UIControlStateNormal];
        xrData = [self encodeToBase64String:imageToPost];
    }
    else if (isCT ==YES)
    {
        [btnF2 setImage:image forState:UIControlStateNormal];
        ctData = [self encodeToBase64String:imageToPost];
    }
    else if (isMRI ==YES)
    {
        [btnF3 setImage:image forState:UIControlStateNormal];
        mrData = [self encodeToBase64String:imageToPost];
    }
//    else if (isBlood ==YES)
//    {
//    [btnF4 setImage:image forState:UIControlStateNormal];
//        self.BloodTestLbl.text =savedImagePath;
//        bloodData = [self encodeToBase64String:imageToPost];
//    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)loadData:(NSArray *)array
{
    /*
     BloodTestName = "";
     CTScansName = "";
     ChiefCompliant = "p[op[o";
     ClientCode = "<null>";
     CreatedBy = USM0000002;
     DateOfAssessment = "09/01/2017";
     ExpectedDateOfRecovery = "09/16/2017";
     ExpertOptionTakenCode = MSC215;
     GameCode = "";
     InjuaryLocationCode = "<null>";
     InjuaryOccuranceCode = MSC130;
     InjuaryOccuranceSubCode = MSC133;
     InjuryCaseCode1 = "<null>";
     InjuryCauseCode = MSC213;
     InjuryCode = INJ0000002;
     InjuryLocationCode = MSC138;
     InjuryLocationSubCode = MSC141;
     InjuryLocationSubCode1 = "<null>";
     InjuryName = "oip[o";
     InjurySide1 = "<null>";
     InjurySideCode = MSC170;
     InjurySite1 = "<null>";
     InjurySiteCode = MSC168;
     InjuryTypeCode = MSC187;
     InjuryTypeCode1 = "<null>";
     Message = "<null>";
     MriScansName = "";
     MultiInjury = No;
     OnSetDate = "09/08/2017";
     OnSetType = MSC128;
     PlayerCode = AMR0000010;
     PlayerName = RohanKunnummal;
     Status = 0;
     TeamCode = "";
     Vas = 3;
     XRaysName = "";
     */
    NSString* str_ass_date = [NSString stringWithFormat:@"Assessment Date %@",[array valueForKey:@"DateOfAssessment"]];
    NSString* str_onSet_date = [NSString stringWithFormat:@"OnSet Date %@",[array valueForKey:@"OnSetDate"]];
    NSString* str_chiefComplaint = [NSString stringWithFormat:@"%@",[array valueForKey:@"ChiefCompliant"]];
    NSString* str_onsetType = [NSString stringWithFormat:@"%@",[array valueForKey:@"OnSetType"]];
    NSString* str_occurance = [NSString stringWithFormat:@"%@",[array valueForKey:@"InjuaryOccuranceCode"]];
    NSString* str_location = [NSString stringWithFormat:@"%@",[array valueForKey:@"InjuryLocationCode"]];
    NSString* str_side = [NSString stringWithFormat:@"%@",[array valueForKey:@"InjurySideCode"]];
    NSString* str_site = [NSString stringWithFormat:@"%@",[array valueForKey:@"InjurySiteCode"]];
    NSString* str_VAS = [NSString stringWithFormat:@"%@",[array valueForKey:@"Vas"]];
    NSString* str_type = [NSString stringWithFormat:@"%@",[array valueForKey:@"InjuryTypeCode"]];
    NSString* str_cause = [NSString stringWithFormat:@"%@",[array valueForKey:@"InjuryCauseCode"]];
    NSString* str_export_option = [NSString stringWithFormat:@"%@",[array valueForKey:@"ExpertOptionTakenCode"]];
    NSString* str_DOR = [NSString stringWithFormat:@"%@",[array valueForKey:@"ExpectedDateOfRecovery"]];

    
}

-(void)newInjuryService {
    
    /*
     {
     "CTSCANSFILE" : "",
     "CTScansName" : "Ctscan.png",
     "ChiefCompliant" : " test",
     "ClientCode" : "CLI0000004",
     "CreatedBy" : "USM0000110",
     "DateOfAssessment" : "06-27-2018",
     "ExpectedDateOfRecovery" : "06-27-2018",
     "GameCode" : "",
     "InjuaryOccuranceCode" : "MSC129",
     "InjuaryOccuranceSubCode" : "",
     "InjuryCauseCode": "MSC203",
     "InjuryName" : "",
     "InjurySiteCode" : "",
     "InjuryTypeCode" : "MSC171",
     "MRISCANSFILE" : "",
     "MriScansName" : "Mriscan.png",
     "OnSetDate" : "06-27-2018",
     "OnSetType":"",
     "ExpertOptionTakenCode":"YES",
     "PlayerCode" : "AMR0000107",
     "TeamCode" : "TEA0000003",
     "Vas" : "2",
     "XRAYSFILE" : "",
     "XRaysName" : "Xray.png",
     "lstInjuryLocations" :     [
                                 {
                                 "InjuryLocationCode" : "FRU55",
                                 "InjurySiteCode" : "MSC165"
                                 },
                                 {
                                 "InjuryLocationCode" : "FLU40",
                                 "InjurySiteCode" : "MSC165"
                                 },
                                 {
                                 "InjuryLocationCode" : "FRL74",
                                 "InjurySiteCode" : "MSC165"
                                 }
                            ]
     }
     
     URL : /AGAPTService.svc/INSERTINJURIES
     */
    
    if(![COMMON isInternetReachable])
        return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString* cliendcode = [AppCommon GetClientCode];
    if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
    
    NSString* RoleCode = [AppCommon GetUserRoleCode];
    NSString* selectTeamCode = self.TeamCode;
    NSString* selectPlayerCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedPlayerCode"];
    NSString* userCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserCode"];
    
    if(userCode)   [dic setObject:userCode forKey:@"CreatedBy"];
    [dic setObject:@"" forKey:@"GameCode"];
    if(selectTeamCode)   [dic setObject:selectTeamCode forKey:@"TeamCode"];
    if(selectPlayerCode)   [dic setObject:selectPlayerCode forKey:@"PlayerCode"];
    
    if(selectOnsetTypeCode)   [dic setObject:selectOnsetTypeCode forKey:@"OnSetType"];
    else [AppCommon showAlertWithMessage:@"Please select OnSet Type"]; return;
    
    if(txtInjuryName.text.length > 0)[dic setObject:txtInjuryName.text forKey:@"InjuryName"];
    else [AppCommon showAlertWithMessage:@"Please Enter Injury Name"]; return;
    
    if(assDate) [dic setObject:assDate forKey:@"DateOfAssessment"];
    else [AppCommon showAlertWithMessage:@"Please Select Assessment Date"]; return;
    
    if(onSetDate) [dic setObject:onSetDate forKey:@"OnSetDate"];
    else [AppCommon showAlertWithMessage:@"Please Select Onset Date"]; return;


    if(self.compliant_Txt.hasText)   [dic    setObject:self.compliant_Txt.text     forKey:@"ChiefCompliant"];
    if(selectsliderValue)   [dic    setObject:selectsliderValue     forKey:@"Vas"];
    if(selectoccurancecode)   [dic    setObject:selectoccurancecode     forKey:@"InjuaryOccuranceCode"];
     [dic setObject:@"" forKey:@"InjuaryOccuranceSubCode"];
     [dic setObject:@"" forKey:@"InjurySiteCode"];

    if(injuryTypeCode)   [dic    setObject:injuryTypeCode forKey:@"InjuryTypeCode"];
    else [AppCommon showAlertWithMessage:@"Please Select Assessment Date"]; return;

    if(injuryCausecode)   [dic    setObject:injuryCausecode forKey:@"InjuryCauseCode"];
    if(selectExpertOpinionCode)   [dic    setObject:selectExpertOpinionCode forKey:@"ExpertOptionTakenCode"];
    
    if(imageArray.count) [dic setObject:imageArray forKey:@"lstInjuryLocations"];
    else [AppCommon showAlertWithMessage:@"Please Select Injury location"]; return;

    if(self.date_lbl.text)   [dic    setObject:self.date_lbl.text     forKey:@"ExpectedDateOfRecovery"];
    else [AppCommon showAlertWithMessage:@"Please Select Expected Recovery Date"]; return;

    if(usercode)   [dic    setObject:usercode forKey:@"CreatedBy"];
    
    [dic setObject:(self.expectedright_Btn.tag == 1 ? @"YES" : @"NO") forKey:@"ExpertOptionTakenCode"];
    [dic setObject:(self.delay_Btn.tag == 1 ? @"" : @"") forKey:@"OnSetType"];

    if(xrData == nil)
    {
        [dic setObject:@"" forKey:@"XRAYSFILE"];
    }
    else {
        [dic    setObject:xrData     forKey:@"XRAYSFILE"];
    }
    [dic    setObject:@"Xray.png"     forKey:@"XRaysName"];
    
    
    
    if(ctData == nil)
    {
        [dic    setObject:@""     forKey:@"CTSCANSFILE"];
    }
    else
    {
        [dic    setObject:ctData     forKey:@"CTSCANSFILE"];
    }
    [dic    setObject:@"Ctscan.png"     forKey:@"CTScansName"];
    
    
    
    if(mrData == nil)
    {
        [dic    setObject:@""     forKey:@"MRISCANSFILE"];
    }
    else
    {
        [dic    setObject:mrData     forKey:@"MRISCANSFILE"];;
    }
    [dic    setObject:@"Mriscan.png"     forKey:@"MriScansName"];
    
    NSLog(@"parameters : %@",dic);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSString * url = URL_FOR_RESOURCE(@"INSERTINJURIES");
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        BOOL status = [responseObject valueForKey:@"Status"];
        if(status == YES)
        {
            [AppCommon showAlertWithMessage:@"Injury Inserted Successfully"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [AppCommon hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [COMMON webServiceFailureError:error];
    }];
    

}



-(void)InsertWebservice
{
    
       if(![COMMON isInternetReachable])
        return;
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString* cliendcode = [AppCommon GetClientCode];
        if(cliendcode)   [dic    setObject:cliendcode     forKey:@"CLIENTCODE"];
    
    NSString* RoleCode = [AppCommon GetUserRoleCode];
    NSString* selectGameCode = [AppCommon GetUserRoleCode];
    NSString* selectTeamCode = [AppCommon GetUserRoleCode];
    NSString* selectPlayerCode = [AppCommon GetUserRoleCode];

        if([RoleCode isEqualToString:@"ROL0000003"])
        {
            if(selectGameCode)   [dic setObject:selectGameCode forKey:@"GAMECODE"];
            if(selectTeamCode)   [dic setObject:selectTeamCode forKey:@"TEAMCODE"];
            if(selectPlayerCode)   [dic setObject:selectPlayerCode forKey:@"PLAYERCODE"];
        }
        else{
            [dic setObject:@"" forKey:@"GAMECODE"];
            [dic setObject:@"" forKey:@"TEAMCODE"];
            [dic setObject:@"" forKey:@"PLAYERCODE"];
        }
    
//    NSString*
    
//        if(self.assessmentLbl.text)   [dic    setObject:self.assessmentLbl.text     forKey:@"DATEOFASSESSMENT"];
//        if(self.onSetLbl.text)   [dic    setObject:self.onSetLbl.text     forKey:@"ONSETDATE"];
        if(selectOnsetTypeCode)   [dic    setObject:selectOnsetTypeCode     forKey:@"ONSETTYPE"];
//        if(self.injuryNameTxt.text)   [dic    setObject:self.injuryNameTxt.text    forKey:@"INJURYNAME"];
    
        if(self.compliant_Txt.hasText)   [dic    setObject:self.compliant_Txt.text     forKey:@"CHIEFCOMPLIANT"];
    
        if(selectsliderValue)   [dic    setObject:selectsliderValue     forKey:@"VAS"];
        if(selectInjuryOccuranceCode)   [dic    setObject:selectInjuryOccuranceCode     forKey:@"INJURYOCCURANCECODE"];
        if(selectoccurancecode)   [dic    setObject:selectoccurancecode     forKey:@"INJURYOCCURANCESUBCODE"];
        if(selectInjuryLocationCode)   [dic    setObject:selectInjuryLocationCode     forKey:@"INJURYLOCATIONCODE"];
        if(selectlocationCode)   [dic    setObject:selectlocationCode     forKey:@"INJURYLOCATIONSUBCODE"];
        if(selectInjurySiteCode)   [dic    setObject:selectInjurySiteCode     forKey:@"INJURYSITECODE"];
        if(selectInjurySideCode)   [dic    setObject:selectInjurySideCode     forKey:@"INJURYSIDECODE"];
        if(injuryTypeCode)   [dic    setObject:injuryTypeCode     forKey:@"INJURYTYPECODE"];
        if(injuryCausecode)   [dic    setObject:injuryCausecode     forKey:@"INJURYCAUSECODE"];
        if(selectExpertOpinionCode)   [dic    setObject:selectExpertOpinionCode     forKey:@"EXPERTOPTIONTAKENCODE"];
    
    
        if(xrData==nil)
        {
            [dic    setObject:@""     forKey:@"XRAYSFILE"];
        }
        else{
            [dic    setObject:xrData     forKey:@"XRAYSFILE"];
        }
        [dic    setObject:@"Xray.png"     forKey:@"XRAYSFILENAME"];



        if(ctData==nil)
        {
            [dic    setObject:@""     forKey:@"CTSCANSFILE"];
        }
        else
        {
            [dic    setObject:ctData     forKey:@"CTSCANSFILE"];
        }
        [dic    setObject:@"Ctscan.png"     forKey:@"CTSCANSFILENAME"];



        if(mrData==nil)
        {
            [dic    setObject:@""     forKey:@"MRISCANSFILE"];
        }
        else
        {
            [dic    setObject:mrData     forKey:@"MRISCANSFILE"];;
        }
        [dic    setObject:@"Mriscan.png"     forKey:@"MRISCANSFILENAME"];


//        if(bloodData==nil)
//        {
//            [dic    setObject:@""     forKey:@"BLOODTESTFILE"];
//        }
//        else
//        {
//            [dic    setObject:bloodData     forKey:@"BLOODTESTFILE"];;
//        }
//        [dic    setObject:@"Bloodtest.png"     forKey:@"BLOODTESTFILENAME"];

        if(self.date_lbl.text)   [dic    setObject:self.date_lbl.text     forKey:@"EXPECTEDDATEOFRECOVERY"];
        if(usercode)   [dic    setObject:usercode     forKey:@"CREATEDBY"];
    
    
        NSLog(@"parameters : %@",dic);
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //NSDictionary *parameters = @{@"foo": @"bar"};
        NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        NSString * url = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",injuryInsert]];
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            BOOL status=[responseObject valueForKey:@"Status"];
            if(status == YES)
            {
                [AppCommon showAlertWithMessage:@"Injury Inserted Successfully"];
                
//                UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Add Injury" message:[NSString stringWithFormat:@"Injury Inserted Successfully"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                objaltert.tag = 201;
//                [objaltert show];
                
//                self.xrayLbl.text = @"";
//                self.CTScanLbl.text = @"";
//                self.BloodTestLbl.text = @"";
//                self.MRILbl.text = @"";
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
//                [self altermsg:@"Injury Insert failed"];
            }
            [AppCommon hideLoading];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [COMMON webServiceFailureError:error];
        }];
    
    
}

-(void)startFetchTeamPlayerGameService
{
    if(![COMMON isInternetReachable])
        return;
    
    NSString* cliendcode = [AppCommon GetClientCode];

        [objWebservice getFetchGameandTeam:FetchGameTeam :cliendcode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                self.gameArray =[responseObject valueForKey:@"fetchGame"];
                self.TeamArray =[responseObject valueForKey:@"fetchTeam"];
                self.playerArray =[responseObject valueForKey:@"fetchAthlete"];
                
                if(self.isUpdate == YES)
                {
//                    self.saveBtn.hidden=YES;
//                    self.updateBtn.hidden =NO;
//                    self.deleteBtn.hidden =NO;
                    
//                            self.gameLbl.text =[self.objSelectInjuryArray valueForKey:@"PLAYERCODE"];
//                            self.TeamLbl.text =[self.objSelectInjuryArray valueForKey:@"teamName"];
//                            self.playerLbl.text =[self.objSelectInjuryArray valueForKey:@"playerName"];
                    
                    NSString *plycode = [self.objSelectInjuryArray valueForKey:@"PlayerCode"];

                    NSMutableArray *selectedPlayer;
                    selectedPlayer = [[NSMutableArray alloc]init];
                    for(int i=0;i<self.playerArray.count;i++)
                    {
                        NSDictionary *players = [[NSDictionary alloc]init];
                        players = [self.playerArray objectAtIndex:i];
                        NSString *plyscode = [players valueForKey:@"athleteCode"];

                        if([plycode isEqualToString:plyscode])
                        {
                            [selectedPlayer addObject:players];
                        }
                    }


                    NSMutableArray *tt=[[NSMutableArray alloc]init];
                    tt=[selectedPlayer objectAtIndex:0];
//                    self.playerLbl.text =[tt valueForKey:@"athleteName"];
                    NSString *teamcode = [tt valueForKey:@"teamCode"];

                    NSMutableArray *selectedTeam;
                    for(int i=0;i<self.TeamArray.count;i++)
                    {
                        NSDictionary *Team = [[NSDictionary alloc]init];
                        Team = [self.TeamArray objectAtIndex:i];
                        NSString *tcode = [Team valueForKey:@"teamCode"];

                        if([teamcode isEqualToString:tcode])
                        {
                            selectedTeam = [[NSMutableArray alloc]init];
                            [selectedTeam addObject:Team];
                        }
                    }



                    NSMutableArray *gg=[[NSMutableArray alloc]init];
                    gg=[selectedTeam objectAtIndex:0];
//                    self.TeamLbl.text =[gg valueForKey:@"teamName"];
                    NSString *gamecode = [gg valueForKey:@"gameCode"];

                    NSMutableArray *selectedGame;
                    for(int i=0;i<self.gameArray.count;i++)
                    {
                        NSDictionary *game = [[NSDictionary alloc]init];
                        game = [self.gameArray objectAtIndex:i];

                        NSString *gcode = [game valueForKey:@"gameCode"];

                        if([gamecode isEqualToString:gcode])
                        {
                            selectedGame = [[NSMutableArray alloc]init];
                            [selectedGame addObject:game];
                        }
                    }

                    NSMutableArray *ggg=[[NSMutableArray alloc]init];
                    ggg=[selectedGame objectAtIndex:0];

//                    self.gameLbl.text =[ggg valueForKey:@"gameName"];



                    self.btnAssment.titleLabel.text =[self.objSelectInjuryArray valueForKey:@"DateOfAssessment"];
//
                    self.btnOnsetDate.titleLabel.text =[self.objSelectInjuryArray valueForKey:@"OnSetDate"];
                    
                    //self.injurytypeLbl.text =[self.objSelectInjuryArray valueForKey:@"mainSymptomName"];
                    //self.injuryCauseLbl.text =[self.objSelectInjuryArray valueForKey:@"causeOfIllnessName"];
                    
                    self.date_lbl.text =[self.objSelectInjuryArray valueForKey:@"ExpectedDateOfRecovery"];
//                    self.injuryNameTxt.text =[self.objSelectInjuryArray valueForKey:@"InjuryName"];
                    self.compliant_Txt.text =[self.objSelectInjuryArray valueForKey:@"ChiefCompliant"];
                    selectGameCode =[self.objSelectInjuryArray valueForKey:@"GameCode"];
                    selectTeamCode =[self.objSelectInjuryArray valueForKey:@"TeamCode"];
                    selectPlayerCode =[self.objSelectInjuryArray valueForKey:@"PlayerCode"];
                    injuryTypeCode =[self.objSelectInjuryArray valueForKey:@"InjuryTypeCode"] ;
                    injuryCausecode =[self.objSelectInjuryArray valueForKey:@"InjuryCauseCode"];
                    
                    selectCauseCode =[self.objSelectInjuryArray valueForKey:@"causeOfIllnessCode"];
                    
                    selectExpertOpinionCode =[self.objSelectInjuryArray valueForKey:@"ExpertOptionTakenCode"];
                    selectOnsetTypeCode =[self.objSelectInjuryArray valueForKey:@"OnSetType"];
                    selectInjuryOccuranceCode =[self.objSelectInjuryArray valueForKey:@"InjuaryOccuranceCode"];
                    selectInjuryLocationCode = [self.objSelectInjuryArray valueForKey:@"InjuryLocationCode"];
                    selectInjurySiteCode = [self.objSelectInjuryArray valueForKey:@"InjurySiteCode"];
                    selectInjurySideCode = [self.objSelectInjuryArray valueForKey:@"InjurySideCode"];

                    selectInjuryCode  = [self.objSelectInjuryArray valueForKey:@"InjuryCode"];

                    VasValue = [self.objSelectInjuryArray valueForKey:@"Vas"];

                    int a = [VasValue intValue];
                    self.Slider1.index = a-1;
                    [self getSliderValue_VAS:@0];
                    
                    
                    
                }
                
                //[self FetchMetadatawebservice];
                [self FetchInjuryListWebService];
                
            }
            [AppCommon hideLoading];
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            [COMMON webServiceFailureError:error];
        }];
        
    
}

-(void)FetchMetadatawebservice
{
    if(![COMMON isInternetReachable])
        return;
    
        [objWebservice getFetchMetadataList:FetchMetadata success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"API URL %@",URL_FOR_RESOURCE(FetchMetadata));
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject)
            {
                _MainArray = responseObject;
                
                self.TrainingArray =[responseObject valueForKey:@"Training"];
                
                self.competitionArray =[responseObject valueForKey:@"Competition"];
                
                self.headandtruckArray =[responseObject valueForKey:@"HeadAndTrunk"];
                
                self.upperextremityArray =[responseObject valueForKey:@"UpperExtremity"];
                
                self.lowerextremityArray =[responseObject valueForKey:@"LowerExtremity"];
                
                self.injuryTypeArray =[responseObject valueForKey:@"InjuryType"];
                
                self.injuryCauseArray =[responseObject valueForKey:@"InjuryCause"];
                
                if(self.isUpdate == YES)
                {
                    selectInjuryOccuranceCode =[self.objSelectInjuryArray valueForKey:@"InjuaryOccuranceCode"];//trainingarray,competion
                    selectInjuryLocationCode = [self.objSelectInjuryArray valueForKey:@"InjuryLocationCode"];//headandtruckArray,upperextremityArray,lowerextremityArray
                    injuryTypeCode =[self.objSelectInjuryArray valueForKey:@"InjuryTypeCode"] ;
                    injuryCausecode =[self.objSelectInjuryArray valueForKey:@"InjuryCauseCode"];
                    
                    selectoccurancecode=[self.objSelectInjuryArray valueForKey:@"InjuaryOccuranceSubCode"];
                    
//                    selectlocationCode = [self.objSelectInjuryArray valueForKey:@"InjuryLocationSubCode"];
                    
//                    if([[self.objSelectInjuryArray valueForKey:@"MultiInjury"] isEqualToString:@"Yes"])
//                    {
//                        [self.multiInjuryBtn setImage:[UIImage imageNamed:@"rightMark"] forState:UIControlStateNormal];
//                        self.multiInjuryFetchBtn.hidden = NO;
//                    }
//
//                    if([selectOnsetTypeCode isEqualToString:@"MSC127"])
//                    {
//                        [self.traumaticBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.delayedBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//
//                    }
//                    else
//                    {
//                        [self.traumaticBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.delayedBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//
//                    }
                    
                    if([selectoccurancecode isEqualToString:@"MSC131"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.TrainingArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.TrainingArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                        }
                        
                    }
                    else if([selectoccurancecode isEqualToString:@"MSC132"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.TrainingArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.TrainingArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                        }
                        
                    }
                    else if([selectoccurancecode isEqualToString:@"MSC133"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.competitionArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.competitionArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectoccurancecode isEqualToString:@"MSC134"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.competitionArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.competitionArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectoccurancecode isEqualToString:@"MSC135"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.competitionArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.competitionArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectoccurancecode isEqualToString:@"MSC136"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.competitionArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.competitionArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectoccurancecode isEqualToString:@"MSC137"])
                    {
//                        [self.TrainingBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.CompetitionBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.competitionArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.competitionArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectoccurancecode isEqualToString:OccCode])
                            {
                                self.occurancelbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                    if([selectlocationCode isEqualToString:@"MSC141"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC142"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                        
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC143"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    else if([selectlocationCode isEqualToString:@"MSC144"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    else if([selectlocationCode isEqualToString:@"MSC145"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                        
                    }
                    
                    else if([selectlocationCode isEqualToString:@"MSC146"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    
                    else if([selectlocationCode isEqualToString:@"MSC147"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    
                    else if([selectlocationCode isEqualToString:@"MSC148"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.headandtruckArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.headandtruckArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    
                    if([selectlocationCode isEqualToString:@"MSC149"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC150"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC151"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC152"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC153"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC154"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC155"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC156"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.upperextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.upperextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    
                    
                    if([selectlocationCode isEqualToString:@"MSC157"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC158"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC159"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC160"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC161"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC162"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC163"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    else if([selectlocationCode isEqualToString:@"MSC164"])
                    {
//                        [self.headerBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.upperBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lowerBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                        
                        
                        for(int i=0;i<self.lowerextremityArray.count;i++)
                        {
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic=[self.lowerextremityArray objectAtIndex:i];
                            NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                            
                            if([selectlocationCode isEqualToString:OccCode])
                            {
                                self.locationlbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
//                    if([selectInjurySiteCode isEqualToString:@"MSC165"])
//                    {
//                        [self.anteriorBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.posteriorBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.medicalBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lateralBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//
//                    }
//                    else if([selectInjurySiteCode isEqualToString:@"MSC167"])
//                    {
//                        [self.anteriorBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.posteriorBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.medicalBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lateralBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//
//                    }
//                    else if([selectInjurySiteCode isEqualToString:@"MSC166"])
//                    {
//                        [self.anteriorBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.posteriorBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.medicalBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.lateralBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//
//                    }
//                    else if([selectInjurySiteCode isEqualToString:@"MSC168"])
//                    {
//                        [self.anteriorBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.posteriorBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.medicalBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.lateralBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//
//                    }
                    
                    
                    
                    if([selectInjurySideCode isEqualToString:@"MSC169"])
                    {
//                        [self.rightBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.leftBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                    }
                    else
                    {
//                        [self.rightBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.leftBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
                    }
                    
                    for(int i=0;i<self.injuryTypeArray.count;i++)
                    {
                        NSDictionary *dic = [[NSDictionary alloc]init];
                        dic=[self.injuryTypeArray objectAtIndex:i];
                        NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                        
                        if([injuryTypeCode isEqualToString:OccCode])
                        {
//                            self.injurytypeLbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            
                        }
                    }
                    
                    for(int i=0;i<self.injuryCauseArray.count;i++)
                    {
                        NSDictionary *dic = [[NSDictionary alloc]init];
                        dic=[self.injuryCauseArray objectAtIndex:i];
                        NSString *OccCode = [dic valueForKey:@"InjuryMetaSubCode"];
                        
                        if([injuryCausecode isEqualToString:OccCode])
                        {
//                            self.injuryCauseLbl.text = [dic valueForKey:@"InjuryMetaDataTypeCode"];
                            
                        }
                    }
                    
                    
//                    if([selectExpertOpinionCode isEqualToString:@"MSC215"])
//                    {
//                        [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                        [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                    }
//                    else
//                    {
//                        [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
//                        [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
//                    }
                    
                    
                    
                    NSString* RoleCode = [AppCommon GetUserRoleCode];

                    if([RoleCode isEqualToString:@"ROL0000003"])
                    {
//                        self.playerview.hidden=NO;
//                        self.coachViewYposition.constant =10;
//
//                        self.XRayView.hidden = NO;
//                        self.CTScansView.hidden = NO;
//                        self.MRIScansView.hidden = NO;
//                        self.BloodTestView.hidden = NO;
                        
                    }
                    else{
//                        self.playerview.hidden=YES;
//                        self.coachViewYposition.constant = -160;
//
//                        self.XRayView.hidden = YES;
//                        self.CTScansView.hidden = YES;
//                        self.MRIScansView.hidden = YES;
//                        self.BloodTestView.hidden = YES;
//
//                        self.expectedViewYposition.constant = -150;
//
//                        self.updateBtn.hidden = YES;
//                        self.deleteBtn.hidden = YES;
                    }
                    
//                    if([self.TrainingBtn.currentImage isEqual:[UIImage imageNamed:@"radio_off"]] && [self.CompetitionBtn.currentImage isEqual:[UIImage imageNamed:@"radio_off"]])
//                    {
//                        self.occurrenceviewHeight.constant =120;
//                        self.locationviewHeight.constant  =130;
//                        self.occurranceselectview.hidden =YES;
//                        self.locationselectview.hidden =YES;
//                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            [COMMON webServiceFailureError:error];
        }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.commonArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddInjury";
    
    UITableViewCell * Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (Cell == nil)
    {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    if(isGame)
    {
        Cell.textLabel.text =[[self.commonArray valueForKey:@"gameName"] objectAtIndex:indexPath.row];
    }
    else if (isTeam)
    {
        Cell.textLabel.text =[[self.commonArray valueForKey:@"teamName"] objectAtIndex:indexPath.row];
        
    }
    else if (isPlayer)
    {
        Cell.textLabel.text =[[self.commonArray valueForKey:@"athleteName"] objectAtIndex:indexPath.row];
        
    }
    else if (isType)
    {
//        Cell.textLabel.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
        
        Cell.textLabel.text =[[self.commonArray valueForKey:@"InjuryTypeName"] objectAtIndex:indexPath.row];
        
    }
    else if (isCasuse)
    {
        //Cell.textLabel.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
        Cell.textLabel.text =[[self.commonArray valueForKey:@"InjuryCaseName"] objectAtIndex:indexPath.row];
        
    }
    else if (isOccurrence)
    {
       // Cell.textLabel.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
        Cell.textLabel.text =[[self.commonArray valueForKey:@"MetaSubCodeDescription"] objectAtIndex:indexPath.row];
        
    }
    else if (islocation)
    {
        //Cell.textLabel.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
        
        Cell.textLabel.text =[[self.commonArray valueForKey:@"MetaSubCodeDescription"] objectAtIndex:indexPath.row];
        
    }
    else if(isSite)
    {
        //Cell.textLabel.text =[[self.commonArray valueForKey:@"name"] objectAtIndex:indexPath.row];
        Cell.textLabel.text =[[self.commonArray valueForKey:@"InjurySiteName1"] objectAtIndex:indexPath.row];

    }
    
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isGame ==YES)
    {
//        self.gameLbl.text =[[self.commonArray valueForKey:@"gameName"] objectAtIndex:indexPath.row];
//        selectGameCode =[[self.commonArray valueForKey:@"gameCode"] objectAtIndex:indexPath.row];
    }
    else if (isTeam ==YES)
    {
//        self.TeamLbl.text =[[self.commonArray valueForKey:@"teamName"] objectAtIndex:indexPath.row];
//        selectTeamCode =[[self.commonArray valueForKey:@"teamCode"] objectAtIndex:indexPath.row];
        
    }
    else if (isPlayer ==YES)
    {
//        self.playerLbl.text =[[self.commonArray valueForKey:@"athleteName"] objectAtIndex:indexPath.row];
//        selectPlayerCode = [[self.commonArray valueForKey:@"athleteCode"] objectAtIndex:indexPath.row];
    }
    else if (isType)
    {
//        self.typelbl.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
//        injuryTypeCode =[[self.commonArray valueForKey:@"InjuryMetaSubCode"] objectAtIndex:indexPath.row];
        
        self.typelbl.text =[[self.commonArray valueForKey:@"InjuryTypeName"] objectAtIndex:indexPath.row];
        injuryTypeCode =[[self.commonArray valueForKey:@"InjuryTypeCode"] objectAtIndex:indexPath.row];
    }
    else if (isCasuse)
    {
//        self.causelbl.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
//        injuryCausecode=[[self.commonArray valueForKey:@"InjuryMetaSubCode"] objectAtIndex:indexPath.row];
        
        self.causelbl.text =[[self.commonArray valueForKey:@"InjuryCaseName"] objectAtIndex:indexPath.row];
        injuryCausecode=[[self.commonArray valueForKey:@"InjuryCaseCode"] objectAtIndex:indexPath.row];
    }
    else if (isOccurrence)
    {
        self.occurancelbl.text =[[self.commonArray valueForKey:@"MetaSubCodeDescription"] objectAtIndex:indexPath.row];
        selectoccurancecode=[[self.commonArray valueForKey:@"InjuryOccuranceCode"] objectAtIndex:indexPath.row];
    }
    else if (islocation)
    {
//        self.locationlbl.text =[[self.commonArray valueForKey:@"InjuryMetaDataTypeCode"] objectAtIndex:indexPath.row];
//        selectlocationCode=[[self.commonArray valueForKey:@"InjuryMetaSubCode"] objectAtIndex:indexPath.row];
        self.locationlbl.text =[[self.commonArray valueForKey:@"MetaSubCodeDescription"] objectAtIndex:indexPath.row];
        selectlocationCode=[[self.commonArray valueForKey:@"InjuryLocationCode"] objectAtIndex:indexPath.row];
    }
    else if (isSite)
    {
//        self.sitelbl.text =[[self.commonArray valueForKey:@"name"] objectAtIndex:indexPath.row];
//        selectInjurySiteCode=[[self.commonArray valueForKey:@"code"] objectAtIndex:indexPath.row];
        
        self.sitelbl.text =[[self.commonArray valueForKey:@"InjurySiteName1"] objectAtIndex:indexPath.row];
        selectInjurySiteCode=[[self.commonArray valueForKey:@"InjurySite"] objectAtIndex:indexPath.row];
        
        
    }
    
    isOccurrence = NO;
    isCasuse = NO;
    isLocation = NO;
    isSite = NO;
    isType = NO;
    self.pop_Tbl.hidden=YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)actionFileUpload:(id)sender {
    
    if ([sender tag] == 0) { // File type 1
        isXray =YES;
        isCT =NO;
        isMRI =NO;
        isBlood =NO;
        
    }
    else if ([sender tag] == 1) { // File type 2
        isXray =NO;
        isCT =NO;
        isMRI =YES;
        isBlood =NO;
        
    }
    else if ([sender tag] == 2) { // File type 3
        isXray =NO;
        isCT =NO;
        isMRI =NO;
        isBlood =YES;
        
    }
    else if ([sender tag] == 3) { // File type 4
        
    }
    
    [self opengallery];

    
}


- (IBAction)actionUPDATE:(id)sender {
    
//    [self InsertWebservice];
    [self newInjuryService];
    
}

-(IBAction)hideFileView:(id)sender
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            
                            self.filepopview.frame = CGRectMake(self.filepopview.frame.origin.x, self.view.frame.size.height+self.filepopview.frame.size.height, self.fileView.frame.size.height, self.fileView.frame.size.height);
                            
                            
                        } completion:^(BOOL finished) {
                            [self.fileView removeFromSuperview];
                        }];

    
}
-(IBAction)showCloseButton:(id)sender
{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==self.compliant_Txt || textField==self.comfirmatory_Txt || textField==self.diagnosis_Txt){
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,_-# "];
        for (int i = 0; i < [string length]; i++)
            {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
                {
                if (textField==self.compliant_Txt) {
                    [self alertStatus:@"Chief Compliant allows only Alpha Numeric and Special Characters" :@"Injury Failed" :0];
                }
                if (textField==self.comfirmatory_Txt) {
                    [self alertStatus:@"Confirmatory Test allows only Alpha Numeric and Special Characters" :@"Injury Failed" :0];
                }
                if (textField==self.diagnosis_Txt) {
                    [self alertStatus:@"Diagnosis allows only Alpha Numeric and Special Characters" :@"Injury Failed" :0];
                }
                return NO;
                }
            }
        
        if (textField==self.compliant_Txt){
            
            if (newString.length>250) {
                [self alertStatus:@"Chief Compliant must be minimum of 1-250 Alpha Numeric and Special Characters" :@"Injury Failed" :0];
                return NO;
            }
        }
        
        
        if (textField==self.comfirmatory_Txt){
            
            if (newString.length>250) {
                [self alertStatus:@"Confirmatory Test must be minimum of 1-250 Alpha Numeric and Special Characters" :@"Injury Failed" :0];
                return NO;
            }
        }
        
        if (textField==self.diagnosis_Txt){
            
            if (newString.length>250) {
                [self alertStatus:@"Diagnosis must be minimum of 1-250 Alpha Numeric and Special Characters" :@"Injury Failed" :0];
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UIAlertView Delegate Method
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg  delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                   [alertView show];
                   });
}

-(void)didFinishPickedWithInjryLocationWithOptions:(NSArray *)options {
    
    NSLog(@"didFinishPickedWithInjryLocationWithOptions %@",options);
    imageArray = options;
}


@end

