//
//  IllnessTracker.m
//  APT_V2
//
//  Created by MAC on 26/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "IllnessTracker.h"
#import "CustomNavigation.h"
#import "WebService.h"
#import "Config.h"
#import "AppCommon.h"

@interface IllnessTracker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    WebService * objWebservice;
    NSString * clientCode ;
    NSString * RoleCode;
    NSString * userCode;
    NSString * userRefCode;
    
    BOOL isExpected;
    BOOL isOnset;
    BOOL isAffect;
    BOOL isCause;
    BOOL isMainSymptom;
    BOOL isXray;
    BOOL isCT;
    BOOL isMRI;
    BOOL isBlood;
    
    BOOL isSelectPop;
    
    NSString * selectAffectSystemCode;
    NSString * selectMainSymptomCode;
    NSString * selectCauseCode;
    NSString * selectIllnessCode;
    
    UIDatePicker * datePicker;
    NSString * selectExpertOpinionCode;
    UIImage *imageToPost;
    UITableView *dropDownTblView;
    
    NSString *mrData;
    NSString *ctData;
    NSString *xrData;
    NSString *bloodData;
    
    NSMutableArray *affectArray;
    NSMutableArray* mainSymptomArray;
    NSMutableArray *causeIllnessArray;
}

//@property (nonatomic,strong) NSMutableArray *affectArray;
//@property (nonatomic,strong) NSMutableArray* mainSymptomArray;
//@property (nonatomic,strong) NSMutableArray *causeIllnessArray;
@property (nonatomic,strong) NSMutableArray * commonArray;
@end

@implementation IllnessTracker

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    
    dropDownTblView = [[UITableView alloc]init];
    dropDownTblView.dataSource = self;
    dropDownTblView.delegate = self;
    
        //Navigation View
//    [self customnavigationmethod];
    [self allViewSetBorderMethod];
    
    clientCode = [AppCommon GetClientCode];
    userCode = [AppCommon GetUsercode];
    userRefCode = [AppCommon GetuserReference];
    self.filePopView.hidden = YES;
    objWebservice =[[WebService alloc]init];
    
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
    self.expectedDateTF.inputAccessoryView = toolbar;
    self.onsetDateTF.inputAccessoryView = toolbar;
    [self loadSelectedData];
    [self Fetchillnessloadingwebservice];
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    CustomNavigation *objCustomNavigation=[CustomNavigation new];
    [self.navigationView addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    objCustomNavigation.btn_back.hidden =NO;
    objCustomNavigation.menu_btn.hidden =YES;
    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionBack
{
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
}

-(void)allViewSetBorderMethod
{
    self.illnessNameView.layer.borderWidth =0.5;
    self.illnessNameView.layer.masksToBounds=YES;
    
    self.chiefCompliantView.layer.borderWidth =0.5;
    self.chiefCompliantView.layer.masksToBounds=YES;
    
    self.affectSystemView.layer.borderWidth =0.5;
    self.affectSystemView.layer.masksToBounds=YES;
    
    self.mainSymptomView.layer.borderWidth =0.5;
    self.mainSymptomView.layer.masksToBounds=YES;
    
    self.causeIllnessView.layer.borderWidth =0.5;
    self.causeIllnessView.layer.masksToBounds=YES;
    
    self.investigationsUploadView.layer.borderWidth =0.5;
    self.investigationsUploadView.layer.masksToBounds=YES;
    
}

-(void) cancelButtonAction {
    if(isExpected == YES) {
        self.expectedDateTF.text = @"";
        [self.expectedDateTF resignFirstResponder];
    } else if(isOnset == YES) {
        self.onsetDateTF.text = @"";
        [self.onsetDateTF resignFirstResponder];
    }
    [self.view endEditing:true];
}


-(void) doneButtonAction {
    [self.view endEditing:true];
}

- (void)loadSelectedData {
    
    if(self.isUpdate == YES)
    {
        self.saveBtn.hidden=YES;
        self.updateBtn.hidden =NO;
        self.deleteBtn.hidden =NO;
        /*
         NSString *plycode = [self.objSelectobjIllnessArray valueForKey:@"playerCode"];
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
         self.playerLbl.text =[tt valueForKey:@"athleteName"];
         */
            //self.playerLbl.text =[self.objSelectobjIllnessArray valueForKey:@"playerName"];
        
            //        NSString *Dt =[self checkNull:[self.objSelectobjIllnessArray valueForKey:@"ExpectedDateofRecovery"]];
            //        NSArray *components1 = [Dt componentsSeparatedByString:@" "];
            //        NSString *Dat = components1[0];
        
            //                Date Format
        
        NSString *currentDate1 = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"ExpectedDateofRecovery"]];
        NSDateFormatter *dateFormatters1 = [[NSDateFormatter alloc] init];
        [dateFormatters1 setDateFormat:@"MM/dd/yyyy"];
        NSDate *dates1 = [dateFormatters1 dateFromString:currentDate1];
        
        NSDateFormatter* dfs1 = [[NSDateFormatter alloc]init];
        [dfs1 setDateFormat:@"MM-dd-yyyy"];
        self.expectedDateTF.text  = [dfs1 stringFromDate:dates1];
        
        
            //        self.expectedDateTF.text = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"ExpectedDateofRecovery"]];
        
        
        NSString *currentDate = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"DateofOnset"]];
        NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
        [dateFormatters setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
        NSDate *dates = [dateFormatters dateFromString:currentDate];
        
        NSDateFormatter* dfs = [[NSDateFormatter alloc]init];
        [dfs setDateFormat:@"MM-dd-yyyy"];
        self.onsetDateTF.text = [dfs stringFromDate:dates];
        
        
            //        NSString *DateTime = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"DateofOnset"]];
            //
            //        NSArray *components = [DateTime componentsSeparatedByString:@" "];
            //
            //        NSString *Date = components[0];
            //        self.onsetDateTF.text =Date;
        
        self.illnessNameTF.text = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"IllnessName"]];
        self.chiefCompliantTF.text = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"ChiefCompliant"]];
        
        
        selectAffectSystemCode = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"AffectedSystem"]];
        selectMainSymptomCode = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"MainSymptom"]];
        selectCauseCode = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"Causeofillness"]];
        selectExpertOpinionCode = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"ExpertOpinionTaken"]];
        selectIllnessCode = [self checkNull:[self.objSelectobjIllnessArray valueForKey:@"IllnessCode"]];
        
        if([selectExpertOpinionCode isEqualToString:@"MSC215"]) {
            [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
            [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        } else {
            [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
            [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
        }
    } else {
            self.saveBtn.hidden=NO;
            self.updateBtn.hidden =YES;
            self.deleteBtn.hidden =YES;
        }
}

- (IBAction)expectedDateButtonTapped:(id)sender {
    isExpected =YES;
        //    isOnset =NO;
    [self displayDatePicker];
}

- (IBAction)onsetDateButtonTapped:(id)sender {
    isExpected =NO;
    isOnset =YES;
    [self displayDatePicker];
}

-(void)displayDatePicker
{
    if (isExpected) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        self.expectedDateTF.inputView = datePicker;
        [datePicker addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventValueChanged];
        [self.expectedDateTF addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventEditingDidBegin];
        [self.expectedDateTF becomeFirstResponder];
    } else if (isOnset) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        self.onsetDateTF.inputView = datePicker;
        [datePicker addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventValueChanged];
        [self.onsetDateTF addTarget:self action:@selector(displaySelectedDateAndTime:) forControlEvents:UIControlEventEditingDidBegin];
        [self.onsetDateTF becomeFirstResponder];
    }
}


- (void) displaySelectedDateAndTime:(UIDatePicker*)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //   2016-06-25 12:00:00
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    [datePicker reloadInputViews];
    
    if(isExpected==YES)
    {
        self.expectedDateTF.text = [dateFormatter stringFromDate:[datePicker date]];
    } else if (isOnset) {
            self.onsetDateTF.text = [dateFormatter stringFromDate:[datePicker date]];
    }
}

- (IBAction)didClickExpertYesOpinion:(id)sender {
    
    if([self.expertYesBtn.currentImage isEqual:[UIImage imageNamed:@"radio_off"]])
    {
        [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
        [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        
        selectExpertOpinionCode=@"MSC215";
    }
}


- (IBAction)didClickExpertNoOpinion:(id)sender {
    
    if([self.expertNoBtn.currentImage isEqual:[UIImage imageNamed:@"radio_off"]])
    {
        [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
        
        selectExpertOpinionCode=@"MSC216";
    }
}

- (IBAction)didClickAffectSystem:(id)sender {
    
    if(dropDownTblView != nil) {
        [dropDownTblView removeFromSuperview];
    }
    
    if (!isAffect) {
        [self resetDropDownIllnesstatus];
        isAffect = YES;
        
        self.commonArray =[[NSMutableArray alloc]init];
        self.commonArray = affectArray;
        
        if (IS_IPAD) {
            dropDownTblView.frame = CGRectMake(self.affectSystemView.frame.origin.x, self.affectSystemView.frame.origin.y+self.affectSystemView.frame.size.height+288, self.affectSystemView.frame.size.width, self.commonArray.count >= 5 ? 150 : self.commonArray.count*45);
        } else {
            dropDownTblView.frame = CGRectMake(self.affectSystemView.frame.origin.x, self.affectSystemView.frame.origin.y+self.affectSystemView.frame.size.height+270, self.affectSystemView.frame.size.width, self.commonArray.count >= 5 ? 150 : self.commonArray.count*45);
        }
        
        
        dropDownTblView.backgroundColor=[UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        [self.view addSubview:dropDownTblView];
        [dropDownTblView reloadData];
    } else {
        [self resetDropDownIllnesstatus];
    }
    
}

- (IBAction)didClickMainSymptom:(id)sender {
    
    if(dropDownTblView != nil) {
        [dropDownTblView removeFromSuperview];
    }
    
    if (!isMainSymptom) {
        [self resetDropDownIllnesstatus];
        isMainSymptom = YES;
        
        self.commonArray =[[NSMutableArray alloc]init];
        self.commonArray = mainSymptomArray;
        if (IS_IPAD) {
            dropDownTblView.frame = CGRectMake(self.mainSymptomView.frame.origin.x, self.mainSymptomView.frame.origin.y+self.mainSymptomView.frame.size.height+335, self.mainSymptomView.frame.size.width, self.commonArray.count >= 5 ? 150 : self.commonArray.count*45);
        } else {
            dropDownTblView.frame = CGRectMake(self.mainSymptomView.frame.origin.x, self.mainSymptomView.frame.origin.y+self.mainSymptomView.frame.size.height+318, self.mainSymptomView.frame.size.width, self.commonArray.count >= 5 ? 150 : self.commonArray.count*45);
        }
        
        
        dropDownTblView.backgroundColor=[UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        [self.view addSubview:dropDownTblView];
        [dropDownTblView reloadData];
    } else {
        [self resetDropDownIllnesstatus];
    }
    
}
- (IBAction)didClickCauseOfIllness:(id)sender {
    
    if(dropDownTblView != nil){
        [dropDownTblView removeFromSuperview];
    }
    
    if (!isCause) {
        [self resetDropDownIllnesstatus];
        isCause = YES;
        
        self.commonArray =[[NSMutableArray alloc]init];
        self.commonArray = causeIllnessArray;
        if (IS_IPAD) {
            dropDownTblView.frame = CGRectMake(self.causeIllnessView.frame.origin.x, self.causeIllnessView.frame.origin.y+self.causeIllnessView.frame.size.height+385, self.causeIllnessView.frame.size.width, self.commonArray.count >= 5 ? 150 : self.commonArray.count*45);
        } else {
            dropDownTblView.frame = CGRectMake(self.causeIllnessView.frame.origin.x, self.causeIllnessView.frame.origin.y+self.causeIllnessView.frame.size.height+367, self.causeIllnessView.frame.size.width, self.commonArray.count >= 5 ? 150 : self.commonArray.count*45);
        }
        
        dropDownTblView.backgroundColor=[UIColor colorWithRed:(13/255.0f) green:(43/255.0f) blue:(129/255.0f) alpha:1.0f];
        [self.view addSubview:dropDownTblView];
        [dropDownTblView reloadData];
    } else {
        [self resetDropDownIllnesstatus];
    }
    
}

- (void)resetDropDownIllnesstatus {
    isAffect =NO;
    isMainSymptom =NO;
    isCause   =NO;
}

- (IBAction)didClickInvestigationsUpload:(id)sender {
    
    if(isSelectPop == NO)
    {
        self.filePopView.hidden = NO;
        isSelectPop = YES;
            //        [self showAnimate];
    }
    else
    {
        self.filePopView.hidden = YES;
        isSelectPop = NO;
        /*
         self.xrayLbl = @"";
         self.CTScanLbl = @"";
         self.MRILbl = @"";
         self.BloodTestLbl = @"";
         */
            //        [self removeAnimate];
    }
    
}

- (IBAction)didClickSave:(id)sender {
    [self validation];
}

- (IBAction)didClickUpdate:(id)sender {
    [self validation];
}

- (IBAction)didClickDelete:(id)sender {
    
    UIAlertView *objAlter =[[UIAlertView alloc]initWithTitle:@"Add Illness" message:@"Do you want to delete" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    objAlter.tag = 300;
    [objAlter show];
}

- (IBAction)didClickctXScan:(id)sender {
    
    isXray =YES;
    isCT =NO;
    isMRI =NO;
    isBlood =NO;
    [self opengallery];
    
}

- (IBAction)didClickCTScans:(id)sender {
    
    isXray =NO;
    isCT =YES;
    isMRI =NO;
    isBlood =NO;
    [self opengallery];
}

- (IBAction)didClickMRIScan:(id)sender {
    
    isXray =NO;
    isCT =NO;
    isMRI =YES;
    isBlood =NO;
    [self opengallery];
}

- (IBAction)didClickBloodScan:(id)sender {
    
    isXray =NO;
    isCT =NO;
    isMRI =NO;
    isBlood =YES;
    [self opengallery];
}

- (IBAction)uploadFilesButtonTapped:(id)sender {
    self.filePopView.hidden = YES;
}

-(void)validation
{
    if ([self.expectedDateTF.text isEqualToString:@""]) {
        [self altermsg:@"Please Select Expected Date of Recovery"];
    } else if ([self.onsetDateTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select Date of Onset"];
    } else if ([self.illnessNameTF.text isEqualToString:@""]) {
        [self altermsg:@"Please Enter IllnessName"];
    } else if ([self.chiefCompliantTF.text isEqualToString:@""]) {
        [self altermsg:@"Please Enter Chief Compliant"];
    } else if ([self.affectSystemTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select Affect System"];
    } else if ([self.mainSymptomTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select Main Syptom"];
    } else if ([self.causeOfIllnessTF.text isEqualToString:@""]) {
        [self altermsg:@"Please select Cause Illness"];
    } else if ([selectExpertOpinionCode isEqualToString:@""]) {
        [self altermsg:@"Please select Expert Opinion Taken"];
    } else {
        if(self.isUpdate ==YES) {
            [self UpdateWebservice];
        } else {
            [self InsertWebservice];
        }
    }
}

-(void)UpdateWebservice
{
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
        if(userCode)   [dic    setObject:userCode     forKey:@"CREATEDBY"];
        
        /*
        if([RoleCode isEqualToString:@"ROL0000003"])
            {
            if(selectGameCode)   [dic    setObject:selectGameCode     forKey:@"GAMECODE"];
            if(selectTeamCode)   [dic    setObject:selectTeamCode     forKey:@"TEAMCODE"];
            if(selectPlayerCode)   [dic    setObject:selectPlayerCode     forKey:@"PLAYERCODE"];
            
            }
        else{
            [dic    setObject:@""     forKey:@"GAMECODE"];
            [dic    setObject:@""     forKey:@"TEAMCODE"];
            [dic    setObject:@""     forKey:@"PLAYERCODE"];
        }
        */
        
        [dic    setObject:@""     forKey:@"GAMECODE"];
        [dic    setObject:@""     forKey:@"TEAMCODE"];
        [dic    setObject:@""     forKey:@"PLAYERCODE"];
        
        if(self.expectedDateTF.text)   [dic    setObject:self.expectedDateTF.text     forKey:@"EXPECTEDDATEOFRECOVERY"];
        if(self.onsetDateTF.text)   [dic    setObject:self.onsetDateTF.text     forKey:@"DATEONSET"];
        if(self.illnessNameTF.text)   [dic    setObject:self.illnessNameTF.text    forKey:@"ILLNESSNAME"];
        
        if(self.chiefCompliantTF.text)   [dic    setObject:self.chiefCompliantTF.text     forKey:@"CHIEFCOMPLIANT"];
        if(selectAffectSystemCode)   [dic    setObject:selectAffectSystemCode     forKey:@"AFFECTEDSYSTEMCODE"];
        if(selectMainSymptomCode)   [dic    setObject:selectMainSymptomCode     forKey:@"MAINSYMPTOMCODE"];
        if(selectCauseCode)   [dic    setObject:selectCauseCode     forKey:@"CAUSEOFILLNESSSYMPTOMCODE"];
        if(selectExpertOpinionCode)   [dic    setObject:selectExpertOpinionCode     forKey:@"EXPERTOPINIONTAKEN"];
        if(selectIllnessCode)   [dic    setObject:selectIllnessCode     forKey:@"ILLNESSCODE"];
        
        if(xrData == nil)
        {
            [dic    setObject:@""     forKey:@"XRAYSFILE"];
        } else {
            [dic    setObject:xrData     forKey:@"XRAYSFILE"];
        }
        [dic    setObject:@"Xray.png"     forKey:@"XRAYSFILENAME"];
        
        
        
        if(ctData == nil)
        {
            [dic    setObject:@""     forKey:@"CTSCANSFILE"];
        } else {
            [dic    setObject:ctData     forKey:@"CTSCANSFILE"];
        }
        [dic    setObject:@"Ctscan.png"     forKey:@"CTSCANSFILENAME"];
        
        
        
        if(mrData == nil)
        {
            [dic    setObject:@""     forKey:@"MRISCANSFILE"];
        } else {
            [dic    setObject:mrData     forKey:@"MRISCANSFILE"];;
        }
        [dic    setObject:@"Mriscan.png"     forKey:@"MRISCANSFILENAME"];
        
        
        if(bloodData == nil)
        {
            [dic    setObject:@""     forKey:@"BLOODTESTFILE"];
        } else {
            [dic    setObject:bloodData     forKey:@"BLOODTESTFILE"];;
        }
        [dic    setObject:@"Bloodtest.png"     forKey:@"BLOODTESTFILENAME"];
        
        
        NSLog(@"parameters : %@",dic);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //NSDictionary *parameters = @{@"foo": @"bar"};
        NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        NSString * url = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",UpdateIllness]];
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"XRAYSFILE" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            BOOL status=[responseObject valueForKey:@"Status"];
            if(status == YES)
            {
            
            UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Add Illness" message:[NSString stringWithFormat:@"Illness Updated Successfully"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            objaltert.tag = 301;
            [objaltert show];
                    // Illness Updated Successfully
//                [self altermsg:@"Illness Updated Successfully"];
            
            
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self altermsg:@"Illness Update failed"];
            }
            
            [AppCommon hideLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [COMMON webServiceFailureError:error];
        }];
    }
}

-(void)InsertWebservice
{
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(clientCode)   [dic    setObject:clientCode     forKey:@"CLIENTCODE"];
        if(userCode)   [dic    setObject:userCode     forKey:@"CREATEDBY"];
        
        /*
         if([RoleCode isEqualToString:@"ROL0000003"])
         {
         if(selectGameCode)   [dic    setObject:selectGameCode     forKey:@"GAMECODE"];
         if(selectTeamCode)   [dic    setObject:selectTeamCode     forKey:@"TEAMCODE"];
         if(selectPlayerCode)   [dic    setObject:selectPlayerCode     forKey:@"PLAYERCODE"];
         
         } else {
         //        [[NSUserDefaults standardUserDefaults] setObject:[responseObject valueForKey:@"Userreferencecode"] forKey:@"Userreferencecode"];
         
         [dic    setObject:@""     forKey:@"GAMECODE"];
         [dic    setObject:@""     forKey:@"TEAMCODE"];
         [dic    setObject: [[NSUserDefaults standardUserDefaults] valueForKey:@"Userreferencecode"]    forKey:@"PLAYERCODE"];
         }
         */
        
        [dic    setObject:@""     forKey:@"GAMECODE"];
        [dic    setObject:@""     forKey:@"TEAMCODE"];
        [dic    setObject:userRefCode    forKey:@"PLAYERCODE"];
        
        if(self.expectedDateTF.text)   [dic    setObject:self.expectedDateTF.text     forKey:@"EXPECTEDDATEOFRECOVERY"];
        if(self.onsetDateTF.text)   [dic    setObject:self.onsetDateTF.text     forKey:@"DATEONSET"];
        if(self.illnessNameTF.text)   [dic    setObject:self.illnessNameTF.text    forKey:@"ILLNESSNAME"];
        
        if(self.chiefCompliantTF.text)   [dic    setObject:self.chiefCompliantTF.text     forKey:@"CHIEFCOMPLIANT"];
        if(selectAffectSystemCode)   [dic    setObject:selectAffectSystemCode     forKey:@"AFFECTEDSYSTEMCODE"];
        if(selectMainSymptomCode)   [dic    setObject:selectMainSymptomCode     forKey:@"MAINSYMPTOMCODE"];
        if(selectCauseCode)   [dic    setObject:selectCauseCode     forKey:@"CAUSEOFILLNESSSYMPTOMCODE"];
        if(selectExpertOpinionCode)   [dic    setObject:selectExpertOpinionCode     forKey:@"EXPERTOPINIONTAKEN"];
        
        if(xrData==nil)
        {
            [dic    setObject:@""     forKey:@"XRAYSFILE"];
        } else {
                [dic    setObject:xrData     forKey:@"XRAYSFILE"];
        }
        [dic    setObject:@"Xray.png"     forKey:@"XRAYSFILENAME"];
        
        if(ctData==nil)
        {
            [dic    setObject:@""     forKey:@"CTSCANSFILE"];
        } else {
                [dic    setObject:ctData     forKey:@"CTSCANSFILE"];
        }
        [dic    setObject:@"Ctscan.png"     forKey:@"CTSCANSFILENAME"];
        
        
        
        if(mrData==nil)
        {
            [dic    setObject:@""     forKey:@"MRISCANSFILE"];
        } else {
                [dic    setObject:mrData     forKey:@"MRISCANSFILE"];;
        }
        [dic    setObject:@"Mriscan.png"     forKey:@"MRISCANSFILENAME"];
        
        
        if(bloodData==nil)
        {
            [dic    setObject:@""     forKey:@"BLOODTESTFILE"];
        } else {
                [dic    setObject:bloodData     forKey:@"BLOODTESTFILE"];;
        }
        [dic    setObject:@"Bloodtest.png"     forKey:@"BLOODTESTFILENAME"];
        
        
        
        NSLog(@"parameters : %@",dic);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //NSDictionary *parameters = @{@"foo": @"bar"};
        NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        NSString * url = [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",inesertIllness]];
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            
            if(responseObject >0)
            {
                BOOL status=[responseObject valueForKey:@"Status"];
                if(status == YES)
                {
                    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Add Illness" message:[NSString stringWithFormat:@"Illness Inserted Successfully"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    objaltert.tag = 301;
                    [objaltert show];
                        //            [self altermsg:[NSString stringWithFormat:@"Illness Insert %@",[responseObject valueForKey:@"Message"]]];
                        //
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                        [self altermsg:@"Illness Insert failed"];
                    }
            }
            [AppCommon hideLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [COMMON webServiceFailureError:error];
        }];
    }
}

-(void)opengallery
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
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
    if(isXray ==YES) {
        self.xrayLbl.text =savedImagePath;
    } else if (isCT ==YES) {
        self.CTScanLbl.text =savedImagePath;
    } else if (isMRI ==YES) {
        self.MRILbl.text =savedImagePath;
    } else if (isBlood ==YES) {
        self.BloodTestLbl.text =savedImagePath;
    }
    imageToPost = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource
    // number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    // number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commonArray.count;
}
    // the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"illmnessCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (tableView == dropDownTblView) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(8/255.0f) green:(26/255.0f) blue:(77/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        if (isAffect == YES) {
            cell.textLabel.text = [[self.commonArray valueForKey:@"IlnessMetaDataTypeCode"] objectAtIndex:indexPath.row];
        } else if (isCause == YES) {
            cell.textLabel.text = [[self.commonArray valueForKey:@"IlnessMetaDataTypeCode"] objectAtIndex:indexPath.row];
        } else if (isMainSymptom == YES) {
            cell.textLabel.text = [[self.commonArray valueForKey:@"IlnessMetaDataTypeCode"] objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
    // when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == dropDownTblView) {
        
        if (isAffect) {
            self.affectSystemTF.text = [[self.commonArray valueForKey:@"IlnessMetaDataTypeCode"] objectAtIndex:indexPath.row];
            selectAffectSystemCode = [[self.commonArray valueForKey:@"IllnessMetaSubCode"] objectAtIndex:indexPath.row];
        } else if (isMainSymptom) {
            self.mainSymptomTF.text = [[self.commonArray valueForKey:@"IlnessMetaDataTypeCode"] objectAtIndex:indexPath.row];
            selectMainSymptomCode = [[self.commonArray valueForKey:@"IllnessMetaSubCode"] objectAtIndex:indexPath.row];
        } else if (isCause) {
            self.causeOfIllnessTF.text = [[self.commonArray valueForKey:@"IlnessMetaDataTypeCode"] objectAtIndex:indexPath.row];
            selectCauseCode = [[self.commonArray valueForKey:@"IllnessMetaSubCode"] objectAtIndex:indexPath.row];
        }
        
        if(dropDownTblView != nil){
            [dropDownTblView removeFromSuperview];
        }
        [self resetDropDownIllnesstatus];
    }
}

-(void)Fetchillnessloadingwebservice
{
        //[COMMON loadingIcon:self.view];
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        [objWebservice getFetchMetadataList :illnessFetchload success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                affectArray =[[NSMutableArray alloc]init];
                mainSymptomArray =[[NSMutableArray alloc]init];
                causeIllnessArray =[[NSMutableArray alloc]init];
                
                
                affectArray =[responseObject valueForKey:@"AffectedSystem"];
                
                mainSymptomArray =[responseObject valueForKey:@"MainSymptoms"];
                
                causeIllnessArray =[responseObject valueForKey:@"CauseOfIllness"];
                
                /*
                 if(self.isUpdate == YES)
                 {
                 
                 
                 NSString *CauseOfillnessCode = [self.objSelectobjIllnessArray valueForKey:@"causeOfIllnessCode"];
                 
                 NSMutableArray *selectedCause;
                 selectedCause = [[NSMutableArray alloc]init];
                 for(int i=0;i<self.causeillnessArray.count;i++)
                 {
                 NSDictionary *players = [[NSDictionary alloc]init];
                 players = [self.causeillnessArray objectAtIndex:i];
                 NSString *Cascode = [players valueForKey:@"IllnessMetaSubCode"];
                 
                 if([CauseOfillnessCode isEqualToString:Cascode])
                 {
                 [selectedCause addObject:players];
                 }
                 }
                 
                 NSMutableArray *tt=[[NSMutableArray alloc]init];
                 tt=[selectedCause objectAtIndex:0];
                 
                 self.CauseLbl.text =[tt valueForKey:@"IlnessMetaDataTypeCode"];
                 
                 
                 }
                 */
                
                if (self.isUpdate ) {
                        //Affected System
                    for (id key in affectArray) {
                        if ([selectAffectSystemCode isEqualToString:[key valueForKey:@"IllnessMetaSubCode"]]) {
                            self.affectSystemTF.text = [key valueForKey:@"IlnessMetaDataTypeCode"];
                        }
                    }
                        //Main Symptoms
                    for (id key in mainSymptomArray) {
                        if ([selectMainSymptomCode isEqualToString:[key valueForKey:@"IllnessMetaSubCode"]]) {
                            self.mainSymptomTF.text = [key valueForKey:@"IlnessMetaDataTypeCode"];
                        }
                    }
                    
                        //Cause Of Illness
                    for (id key in causeIllnessArray) {
                        if ([selectCauseCode isEqualToString:[key valueForKey:@"IllnessMetaSubCode"]]) {
                            self.causeOfIllnessTF.text = [key valueForKey:@"IlnessMetaDataTypeCode"];
                        }
                    }
                }
                
            }
            [AppCommon hideLoading];
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            [COMMON webServiceFailureError:error];
        }];
    }
}

-(void)altermsg:(NSString *) message
{
    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Add Illness" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objaltert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        alertView.hidden=YES;
    }
    else if (alertView.tag == 300)
    {
        if (buttonIndex == 1) {
            [self startDeleteInjuryService:userCode :selectIllnessCode];
        }
    }
    else if (alertView.tag == 301)
    {
        self.expectedDateTF.text =@"";
        self.onsetDateTF.text =@"";
        self.illnessNameTF.text =@"";
        self.chiefCompliantTF.text =@"";
        self.affectSystemTF.text =@"";
        self.mainSymptomTF.text =@"";
        self.causeOfIllnessTF.text =@"";
        
        selectAffectSystemCode =@"" ;
        selectMainSymptomCode =@"";
        selectCauseCode =@"";
        selectExpertOpinionCode =@"";
        selectIllnessCode = @"";
        selectExpertOpinionCode=@"";
        
        [self.expertYesBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [self.expertNoBtn setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        
        self.xrayLbl.text =@"";
        self.CTScanLbl.text =@"";
        self.MRILbl.text =@"";
        self.BloodTestLbl.text=@"";
    }
    else
    {
            //Do something else
    }
}

-(void)startDeleteInjuryService :(NSString *) Usercode :(NSString *)selectillnessCode
{
    if([COMMON isInternetReachable])
    {
        [AppCommon showLoading];
        [objWebservice getinjuryDelete:deleteIllness :selectillnessCode :Usercode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                
                NSLog(@"%@",responseObject);
                BOOL status=[responseObject valueForKey:@"Status"];
                if(status == YES)
                {
                    [self altermsg:[NSString stringWithFormat:@"Illness Deleted Successfully"]];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else {
                    [self altermsg:@"Delete failed"];
                }
                
            }
            [AppCommon hideLoading];
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            [COMMON webServiceFailureError:error];
        }];
    }
}

    // press return to hide keyboard
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.illnessNameTF) {
        [self.chiefCompliantTF becomeFirstResponder];
        
    } else if(textField == self.chiefCompliantTF) {
        [textField resignFirstResponder];
        [self didClickAffectSystem:self.affectSystemBtn];
        
    } else if(textField == self.affectSystemTF) {
        [textField resignFirstResponder];
        [self didClickMainSymptom:self.mainSymptomBtn];
        
    } else if(textField == self.mainSymptomTF) {
        [textField resignFirstResponder];
        [self didClickCauseOfIllness:self.causeBtn];
        
    } else if(textField == self.causeOfIllnessTF) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (NSString *)checkNull:(NSString *)_value
{
    if ([_value isEqual:[NSNull null]] || _value == nil || [_value isEqual:@"<null>"]) {
        _value=@"";
    }
    return _value;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==self.illnessNameTF || textField==self.chiefCompliantTF){
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,_-# "];
        for (int i = 0; i < [string length]; i++)
            {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
                {
                if (textField==self.illnessNameTF) {
                    [self alertStatus:@"Illness Name allows only Alpha Numeric and Special Characters" :@"Ilness Failed" :0];
                }
                if (textField==self.chiefCompliantTF) {
                    [self alertStatus:@"Chief Compliant allows only Alpha Numeric and Special Characters" :@"Illness Failed" :0];
                }
                return NO;
                }
            }
        
        if (textField==self.illnessNameTF){
            
            if (newString.length>250) {
                [self alertStatus:@"Illness Name must be minimum of 1-250 Alpha Numeric and Special Characters" :@"Illness Failed" :0];
                return NO;
            }
        }
        
        if (textField==self.chiefCompliantTF){
            
            if (newString.length>250) {
                [self alertStatus:@"Chief Compliant must be minimum of 1-250 Alpha Numeric and Special Characters" :@"Illness Failed" :0];
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

@end
