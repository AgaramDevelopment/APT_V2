//
//  ViewController.m
//  APT_V2
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#define  SCREEN_CODE_Rom  @"ASTT001"
#define  SCREEN_CODE_SPECIAL  @"ASTT002"
#define  SCREEN_CODE_MMT  @"ASTT003"
#define  SCREEN_CODE_GAIT  @"ASTT004"
#define  SCREEN_CODE_POSTURE  @"ASTT005"
#define  SCREEN_CODE_S_C  @"ASTT006"
#define  SCREEN_CODE_COACHING  @"ASTT007"
//#define  green [UIColor colorWithRed:0.0 green:144.0/255.0 blue:81.0/255.0 alpha:1.0];
//#define  orange  [UIColor colorWithRed:255.0/255.0 green:147.0/255.0 blue:0.0 alpha:1.0];
//#define  red  [UIColor colorWithRed:255.0/255.0 green:38.0/255.0 blue:0.0 alpha:1.0];


#import "ViewController.h"
#import "TestPropertyCollectionViewCell.h"

@interface ViewController () <SKSTableViewDelegate,selectedDropDown,DatePickerProtocol,UITextFieldDelegate>
{
    NSString * usercode;
    NSString *clientCode;
    BOOL isEdit;
    NSInteger currentlySelectedHeader;
    NSString* currentlySelectedDate;
    NSArray* arrayTestName;
    NSString* version;
    NSString* currentlySelectedTest;
    NSInteger CollectionItem;
    NSArray* dropdownArray;
    NSInteger textFieldIndexPath;
    NSIndexPath* currentlySelectedTestType;
    UIImage* check;
    UIImage* uncheck;
    UIColor* red,* orange,* green;
    BOOL ifSaveBtnClicked;
    
}


@property (nonatomic,strong) NSMutableArray * ObjSelectTestArray;
@property (nonatomic,strong) NSString * usercode;
@property (nonatomic,strong) NSString * clientCode;
@property (nonatomic,strong) NSString * selectedPlayerCode;

@property (nonatomic,strong) NSMutableArray * objContenArray;
@property (nonatomic,strong) NSString * SelectScreenId;
@property (nonatomic,strong) DBAConnection *objDBconnection;

@property (nonatomic,strong) NSDictionary * SelectDetailDic;
@property (nonatomic,strong) NSString * assessmentCodeStr;
@property (nonatomic,strong) NSString * ModuleCodeStr;
@property (nonatomic,strong) NSString * selectDate;

@end

@implementation ViewController

@synthesize tblAssesments,btnDate;

@synthesize tblDropDown;

@synthesize txtTitle,txtModule;

@synthesize assCollection,lblRangeName,lblRangeValue;

@synthesize lblAssessmentName,lblUnitValue,lblUnitName;

@synthesize txtRemarks,popupVC,lblNOData;

@synthesize btnIgnore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    tblAssesments.SKSTableViewDelegate = self;
    
  green = [UIColor colorWithRed:0.0 green:144.0/255.0 blue:81.0/255.0 alpha:1.0];
  orange  = [UIColor colorWithRed:255.0/255.0 green:147.0/255.0 blue:0.0 alpha:1.0];
  red  = [UIColor colorWithRed:255.0/255.0 green:38.0/255.0 blue:0.0 alpha:1.0];

    arrayTestName = @[
                      @{@"TestName":@"Rom",@"TestCode":@"ASTT001"},
                      @{@"TestName":@"Special",@"TestCode":@"ASTT002"},
                      @{@"TestName":@"MMT",@"TestCode":@"ASTT003"},
                      @{@"TestName":@"Gaint",@"TestCode":@"ASTT004"},
                      @{@"TestName":@"Posture",@"TestCode":@"ASTT005"},
                      @{@"TestName":@"Coaching",@"TestCode":@"ASTT006"},
                      @{@"TestName":@"SC",@"TestCode":@"ASTT007"}
                      ];
    
    usercode = [AppCommon GetUsercode];
    clientCode = [AppCommon GetClientCode];
    
//    [self customnavigationmethod];
    currentlySelectedHeader = -1;
    
    [assCollection registerNib:[UINib nibWithNibName:@"TestPropertyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AssessmentCell"];
    
    if (!IS_IPAD) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];

    }
    
    version = @"1";
    self.objDBconnection = [[DBAConnection alloc]init];
    _ObjSelectTestArray = [NSMutableArray new];
    
//    [[NSUserDefaults standardUserDefaults] setObject:athletCode forKey:@"SelectedPlayerCode"];

//    _selectedPlayerCode = @"AMR0000010";
    
    
    check = [UIImage imageNamed:@"check"];
    uncheck = [UIImage imageNamed:@"uncheck"];
    [self customnavigationmethod];
    ifSaveBtnClicked = NO;
    
    if (!currentlySelectedDate) {
        NSDateFormatter* format = [NSDateFormatter new];
        [format setDateFormat:@"dd/MM/yyy"];
        currentlySelectedDate = [format stringFromDate:[NSDate date]];
        [btnDate setTitle:currentlySelectedDate forState:UIControlStateNormal];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectedPlayerCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedPlayerCode"];

}

-(void)viewDidAppear:(BOOL)animated
{
    //    [txtModule setup];
    //    [txtTitle setup];
    
    [[NSNotificationCenter defaultCenter]removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter]removeObserver:UIKeyboardWillHideNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"%f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    NSInteger keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //    [NSLayoutConstraint deactivateConstraints:self.centerY];
    //    [NSLayoutConstraint activateConstraints:self.centerY];
    //    [self.bottomConstant setActive:YES];
    //    [self.centerY setActive:NO];
    if (notification.name == UIKeyboardWillHideNotification) {
        //        self.bottomConstant.constant = (CGRectGetMidY(self.popupVC.view.frame) - self.Shadowview.frame.size.height) / 2;
        self.bottomConstant.constant = (CGRectGetHeight(self.popupVC.view.frame) - self.Shadowview.frame.size.height) / 2;
        
    }
    else
    {
        self.bottomConstant.constant = keyboardHeight+1;
    }
    
    [self.Shadowview updateConstraintsIfNeeded];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //    [self.view addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
    UIView* view= self.view.subviews.firstObject;
    [view addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //    objCustomNavigation.btn_back.hidden =isBackEnable;
    //
    //    objCustomNavigation.menu_btn.hidden = objCustomNavigation.btn_back.isHidden;
    //    [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)actionBack
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BACK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [appDel.frontNavigationController popViewControllerAnimated:YES];
    
}


-(void)tableValuesMethod
{
    
    if (!txtTitle.hasText || !txtModule.hasText) {
        
        NSLog(@"input required");
        return;
    }
    
//    [self.objDBconnection];
    
//    -(NSMutableArray *)AssessmentEntryByDate: (NSString *) AssessmentCode :(NSString *) Usercode:(NSString *) moduleCode:(NSString *) date:(NSString *) Clientcode{

    NSMutableArray * AssessmentEntry =  [self.objDBconnection AssessmentEntryByDate :txtTitle.selectedCode  :usercode :txtModule.selectedCode:currentlySelectedDate:clientCode];
    
    NSMutableArray * TestAsseementArray;
    self.objContenArray =[[NSMutableArray alloc]init];
    NSMutableArray * ComArray = [[NSMutableArray alloc]init];
    
    if (AssessmentEntry.count) {
        
        TestAsseementArray =  [self.objDBconnection TestByAssessment:clientCode :txtTitle.selectedCode :txtModule.selectedCode:currentlySelectedDate];
        
        if (!self.selectedPlayerCode) {
            [AppCommon showAlertWithMessage:@"Please select Any player to Retrive Data"];
            return;
        }
    }
    else {
        
        TestAsseementArray = [self.objDBconnection TestByAssessmentAll:clientCode:txtTitle.selectedCode :txtModule.selectedCode];

    }
    
    NSLog(@"%@", TestAsseementArray);
    
    NSMutableArray * AssessmentTypeTest;
    NSMutableArray * AssessmentNameArray;
    NSMutableDictionary * MainDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i <TestAsseementArray.count; i++)
    {
        NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];
        
        AssessmentNameArray =[[NSMutableArray alloc]init];
        [tempDict setValue:[[TestAsseementArray valueForKey:@"TestCode"] objectAtIndex:i] forKey:@"TestCode"];
        [tempDict setValue:[[TestAsseementArray valueForKey:@"TestName"] objectAtIndex:i] forKey:@"TestName"];
        [tempDict setValue:[[TestAsseementArray valueForKey:@"TestCode"] objectAtIndex:i] forKey:@"AssessmentTestCode"];

        NSString *assessmentTestCode = [[TestAsseementArray valueForKey:@"TestCode"] objectAtIndex:i];
        NSDictionary * Screenid =  [self.objDBconnection ScreenId:txtTitle.selectedCode :assessmentTestCode];
        NSLog(@" ScreenID %@", Screenid);
        [tempDict setValue:Screenid[@"ScreenID"] forKey:@"ScreenID"];
        [tempDict setValue:Screenid[@"version"] forKey:@"version"];
        
        NSString * Screencount =  [self.objDBconnection ScreenCount :txtTitle.selectedCode :assessmentTestCode];
        
        int count = [Screencount intValue];
        
        AssessmentTypeTest = [[NSMutableArray alloc]init];
        if(count>0)
        {
            
            AssessmentTypeTest = [self.objDBconnection AssementForm :Screenid[@"ScreenID"] :clientCode:txtModule.selectedCode:txtTitle.selectedCode :assessmentTestCode ];
        }
        
        for(int j=0;j<AssessmentTypeTest.count;j++)
        {
            NSMutableDictionary* infoDictionary = [NSMutableDictionary new];
            NSMutableDictionary * objDic = [[NSMutableDictionary alloc]init];
            
            [objDic setValue:[[AssessmentTypeTest valueForKey:@"TestTypeCode"] objectAtIndex:j] forKey:@"TestTypeCode"];
            [objDic setValue:[[AssessmentTypeTest valueForKey:@"TestTypeName"] objectAtIndex:j] forKey:@"TestTypeName"];
            [objDic setValue:Screenid[@"ScreenID"] forKey:@"ScreenID"];
            [objDic setValue:Screenid[@"version"] forKey:@"version"];
            
            //            [infoDictionary addEntriesFromDictionary:objDic];
            [infoDictionary setObject:[tempDict valueForKey:@"TestCode"] forKey:@"TestCode"];
            [infoDictionary setObject:[objDic valueForKey:@"TestTypeCode"] forKey:@"TestTypeCode"];
            [infoDictionary setObject:[objDic valueForKey:@"ScreenID"] forKey:@"ScreenID"];
            [infoDictionary setObject:[objDic valueForKey:@"version"] forKey:@"version"];
            
            
            NSDictionary* temp1 = [self getTestAttributesForScreenID:infoDictionary];
            
            if(temp1.count)
            {
                [objDic addEntriesFromDictionary:temp1];
            }
            
            [objDic setValue:[tempDict valueForKey:@"AssessmentTestCode"] forKey:@"AssessmentTestCode"];

            
            //            NSMutableArray * objArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:[self.SelectDetailDic valueForKey:@"AssessmentCode"] :usercode :self.ModuleCodeStr :[self.SelectDetailDic valueForKey:@"SelectDate"] :clientCode :TestTypeCode : self.SelectTestCodeStr];
            
            //            currentlySelectedDate = [currentlySelectedDate stringByAppendingString:@" 12:00:00 AM"];
            //            NSMutableArray * objArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:txtTitle.selectedCode :usercode :txtModule.selectedCode : currentlySelectedDate:currentlySelectedDate :[tempDict valueForKey:@"TestTypeCode"] : [objDic valueForKey:@"TestTypeCode"]];
            
            [AssessmentNameArray addObject:objDic];
            
        }
        [tempDict setObject:AssessmentNameArray forKey:@"TestValues"];
        [self.objContenArray addObject:tempDict];
        
    }
    
    [tblAssesments reloadData];
    
    if (ifSaveBtnClicked) {
        
        DBMANAGERSYNC * objCaptransactions = [DBMANAGERSYNC sharedManager];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic = [objCaptransactions AssessmentEntrySyncBackground];
        NSMutableArray *reqList = [[NSMutableArray alloc]init];
        reqList = [dic valueForKey:@"LstAssessmententry"];
        if(reqList.count>0 ){
            [appDel PushWebservice:dic];
        }
        
        ifSaveBtnClicked = NO; // whatever it may be we have to reset value

    }

}

-(NSMutableDictionary *)getTestAttributesForScreenID:(NSDictionary *)infoDictionary
{
    
    //    NSMutableArray * objArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:txtTitle.selectedCode :usercode :txtModule.selectedCode : currentlySelectedDate:currentlySelectedDate :[tempDict valueForKey:@"TestTypeCode"] : [objDic valueForKey:@"TestTypeCode"]];
    
    
    NSMutableArray* tempArray = [NSMutableArray new];
    
    NSString* AssTestCode = [infoDictionary valueForKey:@"TestCode"];
    NSString* AssTestTypeCode = [infoDictionary valueForKey:@"TestTypeCode"];
    NSString* ScreenID = [infoDictionary valueForKey:@"ScreenID"];
    NSString* testVersion = [infoDictionary valueForKey:@"version"];
    
    isEdit = NO;
    
    //    -(NSMutableArray *)getAssessmentEnrtyByDateTestType:(NSString *) assessmentCode:(NSString *) userCode:(NSString *) moduleCode :(NSString *) date:(NSString *) clientCode:(NSString *) testTypeCode:(NSString *) testCode
    
    
    NSMutableArray* isEditArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:txtTitle.selectedCode :usercode :txtModule.selectedCode :currentlySelectedDate :clientCode :AssTestTypeCode :AssTestCode];
    
    if (isEditArray.count) {
        isEdit = YES;
    }
    
    if ([SCREEN_CODE_Rom isEqualToString:ScreenID]) {
        
        if (isEdit) {
            //            -(NSMutableArray *)GetRomWithEntry:(NSString *)version:(NSString *)assessmentCode:(NSString *)moduleCode:(NSString *)assessmentTestCode:(NSString *)clientCode:(NSString *)createdBy:(NSString *)player:(NSString *)assessmentDate:(NSString *)TestTypeCode
            
            //            self.ObjSelectTestArray =[self.objDBConnection GetRomWithEntry:self.version :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.ModuleStr : self.SectionTestCodeStr :clientCode :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :self.SelectTestTypecode];
            
            tempArray = [self.objDBconnection GetRomWithEntry: testVersion : txtTitle.selectedCode :txtModule.selectedCode :AssTestCode :clientCode :usercode :_selectedPlayerCode :currentlySelectedDate :AssTestTypeCode];
            
            
        }
        else {
            
            //            -(NSMutableArray*)getRomWithoutEntry:(NSString *)version:(NSString*)assessmentCode:(NSString *)moduleCode:(NSString *)assessmentTestCode:(NSString*)clientCode:(NSString *)testTypeCode
            
            tempArray = [self.objDBconnection getRomWithoutEntry:testVersion :txtTitle.selectedCode :txtModule.selectedCode :AssTestCode :clientCode :AssTestTypeCode];
        }
        
    }
    else if ([SCREEN_CODE_SPECIAL isEqualToString:ScreenID]) {
        
        if (isEdit) {
            
            //            -(NSMutableArray *) getSpecWithEnrty:(NSString*) version:(NSString*) assessmentCode:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode: (NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString*) testTypeCode {
            
            tempArray = [self.objDBconnection getSpecWithEnrty:testVersion : txtTitle.selectedCode :txtModule.selectedCode :AssTestCode :clientCode :usercode :_selectedPlayerCode :currentlySelectedDate :AssTestTypeCode];
            
        }else
        {
            //            -(NSMutableArray *)getSpecWithoutEnrty: (NSString*) version:(NSString*) assessmentCode:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) testTypeCode {
            
            tempArray = [self.objDBconnection getSpecWithoutEnrty:testVersion :txtTitle.selectedCode :txtModule.selectedCode :AssTestCode :clientCode :AssTestTypeCode];
            
        }
        
    }
    else if ([SCREEN_CODE_MMT isEqualToString:ScreenID]) {
        
        if (isEdit) {
            
            //            -(NSMutableArray *) getMMTWithEnrty:(NSString *) version:(NSString *) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) assessmentCode:(NSString *) createdBy:(NSString *)  player:(NSString *) assessmentDate:(NSString *) testTypeCode
            
            tempArray = [self.objDBconnection getMMTWithEnrty:testVersion : txtModule.selectedCode :AssTestCode :clientCode :txtTitle.selectedCode :usercode :_selectedPlayerCode :currentlySelectedDate :AssTestTypeCode];
            
        }
        else
        {
            //            -(NSMutableArray *) getMMTWithoutEnrty:(NSString *) version:(NSString *) moduleCode:(NSString *) assessmentTestCode: (NSString *) clientCode:(NSString *) assessmentCode:(NSString *) testTypeCode
            
            tempArray = [self.objDBconnection getMMTWithoutEnrty:testVersion :txtModule.selectedCode :AssTestCode :clientCode :txtTitle.selectedCode  :AssTestTypeCode];
            
        }
        
        
    }
    else if ([SCREEN_CODE_GAIT isEqualToString:ScreenID]) {
        
        if (isEdit) {
            
            //            -(NSMutableArray *) getGaintWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode: (NSString*) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) assessmentDate:(NSString*) player:(NSString*) testTypeCode
            
            tempArray = [self.objDBconnection getGaintWithEnrty:testVersion  :txtModule.selectedCode :AssTestCode :clientCode : txtTitle.selectedCode :usercode :currentlySelectedDate :_selectedPlayerCode :AssTestTypeCode];
            
        }
        else
        {
            //            -(NSMutableArray*) getGaintWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:( NSString *) clientCode:(NSString*) assessmentCode:(NSString*) testTypeCode
            
            tempArray = [self.objDBconnection getGaintWithoutEnrty:testVersion :txtModule.selectedCode :AssTestCode :clientCode :txtTitle.selectedCode :AssTestTypeCode];
        }
        
        
    }
    else if ([SCREEN_CODE_POSTURE isEqualToString:ScreenID]) {
        
        
        if (isEdit) {
            
            //            -(NSMutableArray *) getPostureWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString*) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString*) testTypeCode
            
            tempArray = [self.objDBconnection getPostureWithEnrty:testVersion  :txtModule.selectedCode :AssTestCode :clientCode : txtTitle.selectedCode:usercode :_selectedPlayerCode :currentlySelectedDate :AssTestTypeCode];
        }
        else
        {
            //            -(NSMutableArray *) getPostureWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString*) clientCode:(NSString*) assessmentCode:(NSString*) testTypeCode
            
            tempArray = [self.objDBconnection getPostureWithoutEnrty:testVersion :txtModule.selectedCode :AssTestCode :clientCode :txtTitle.selectedCode :AssTestTypeCode];
            
        }
        
        
        
    }
    else if ([SCREEN_CODE_S_C isEqualToString:ScreenID]) {
        if (isEdit) {
            
            //            -(NSMutableArray *) getSCWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *)clientCode:(NSString *) assessmentCode:(NSString *) createdBy:(NSString*) assessmentDate:(NSString*) player:(NSString*) testTypeCode
            
            //            self.ObjSelectTestArray = [self.objDBConnection getSCWithEnrty:self.version :self.ModuleStr :self.SectionTestCodeStr :clientCode :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :usercode :[self.selectAllValueDic valueForKey:@"SelectDate"] :[self.selectAllValueDic valueForKey:@"PlayerCode"] :self.SelectTestTypecode];
            
            
            tempArray = [self.objDBconnection getSCWithEnrty:testVersion :txtModule.selectedCode :AssTestCode :clientCode :txtTitle.selectedCode :usercode :currentlySelectedDate :_selectedPlayerCode :AssTestTypeCode];
            
        }else
        {
            
            //            -(NSMutableArray *) getSCWithoutEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString *) assessmentCode:(NSString*) testTypeCode
            
            tempArray = [self.objDBconnection getSCWithoutEnrty:testVersion :txtModule.selectedCode :AssTestCode :clientCode:txtTitle.selectedCode :AssTestTypeCode];
            
        }
        
        
    }
    else if ([SCREEN_CODE_COACHING isEqualToString:ScreenID]) {
        
        if (isEdit) {
            //            -(NSMutableArray*) getTestCoachWithEnrty:(NSString*) version:(NSString*) moduleCode:(NSString*) assessmentTestCode:(NSString *) clientCode:(NSString*) assessmentCode:(NSString*) createdBy:(NSString*) player:(NSString*) assessmentDate:(NSString *) testTypeCode
            
            //            self.ObjSelectTestArray =[self.objDBConnection getTestCoachWithEnrty:self.version :self.ModuleStr :self.SectionTestCodeStr :clientCode :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"]:self.SelectTestTypecode];
            
            
            tempArray = [self.objDBconnection getTestCoachWithEnrty:testVersion : txtModule.selectedCode :AssTestCode :clientCode :txtTitle.selectedCode :usercode :_selectedPlayerCode :currentlySelectedDate :AssTestTypeCode];
            
        }
        else
        {
            //            -(NSMutableArray *) getTestCoachWithoutEnrty:(NSString *) version:(NSString*) moduleCode:(NSString*) assessmentTestCode: (NSString *) clientCode:(NSString *) assessmentCode:(NSString *) testTypeCode
            
            tempArray = [self.objDBconnection getTestCoachWithoutEnrty:testVersion :txtModule.selectedCode :AssTestCode :clientCode:txtTitle.selectedCode :AssTestTypeCode];
            
        }
        
        
    }
    
    NSMutableDictionary* resultDict = [NSMutableDictionary new];
    [resultDict addEntriesFromDictionary:tempArray.firstObject];
    
    return resultDict;
}

-(void)assmentValues:(NSString *)TestTypeCode
{
    //    NSString * TestTypeCode =[objDic valueForKey:@"TestTypeCode"];
    //    NSMutableArray * objArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:[self.SelectDetailDic valueForKey:@"AssessmentCode"] :usercode :self.ModuleCodeStr :[self.SelectDetailDic valueForKey:@"SelectDate"] :clientCode :TestTypeCode : self.SelectTestCodeStr];
    
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    [lblNOData setHidden:self.objContenArray.count];
    return self.objContenArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
//    self.plannerTblHeight.constant = (self.plannerTblHeight.constant == 0 ? 175 : 0);
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.eventTbl layoutIfNeeded];
//    }];
    
    [UIView animateWithDuration:0.6 animations:^{
        
    }];

    if (currentlySelectedHeader == section) {
        return IS_IPAD ? 90 :  70;
    }
    else {
        return IS_IPAD ? 50 : 45;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifier = @"Header";
    AssesmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"AssesmentTableViewCell" owner:self options:nil];
    if (nil == cell)
    {
        cell = array[0];
    }
    
    NSString* title = [[self.objContenArray objectAtIndex:section] valueForKey:@"TestName"];
    [cell.btnAssTitle setTitle:title forState:UIControlStateNormal];
    cell.btnAssTitle.tag = section;
    [cell.btnAssTitle addTarget:self action:@selector(AssmentHeaderHeight:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"viewForHeaderInSection section %ld ",(long)section);
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentlySelectedHeader == section) {
        NSLog(@"numberOfRowsInSection open %ld ",(long)section);
        return [[[self.objContenArray objectAtIndex:currentlySelectedHeader] valueForKey:@"TestValues"] count];
    }
    else
    {
        NSLog(@"numberOfRowsInSection close %ld ",(long)section);
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = IS_IPAD ? 40 : 35;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    AssesmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array;
    
    if(cell == nil)
    {
        array = [[NSBundle mainBundle] loadNibNamed:@"AssesmentTableViewCell" owner:self options:nil];
    }
    
    cell = array[3];
    cell.lblTestName.text = [[[[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestValues"] objectAtIndex:indexPath.row] valueForKey:@"TestTypeName"];
    cell.tag = [[[[[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestValues"] objectAtIndex:indexPath.row] valueForKey:@"ScreenID"] integerValue];
    cell.lblInjured.text = [[[[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestValues"] objectAtIndex:indexPath.row] valueForKey:@"Remarks"];
    cell.lblInference.text = [[[[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestValues"] objectAtIndex:indexPath.row] valueForKey:@"Inference"];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString* ignore_str = [[[[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestValues"] objectAtIndex:indexPath.row] valueForKey:@"Ignore"];
    
    if ([ignore_str.lowercaseString isEqualToString:@"false"] || ignore_str.length == 0) {
        cell.imgCheck.image = uncheck;
    }
    else
    {
        cell.imgCheck.image = check;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(BOOL)isIgnorePlayer:(NSString *)Value
{
    BOOL isCheck = NO;
    
    
    return isCheck;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lblUnitName.text = @"";
    lblUnitValue.text = @"";
    lblRangeName.text = @"";
    lblRangeValue.text = @"";
    lblAssessmentName.text = @"";
    txtRemarks.text = @"";
    
    NSArray* currentIndexArray = [[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestValues"];
    
    lblAssessmentName.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"TestTypeName"];
    NSString* ScreenID = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"ScreenID"];
    
    NSString* TestCode = [[self.objContenArray objectAtIndex:indexPath.section] valueForKey:@"TestCode"];
    
    NSString* TestTypeCode = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"TestTypeCode"];
    
    currentlySelectedTest = ScreenID;
    
    NSMutableArray* isEditArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:txtTitle.selectedCode :usercode :txtModule.selectedCode :currentlySelectedDate :clientCode :TestTypeCode :TestCode];
    
    if (isEditArray.count) {
        isEdit = YES;
    }
    else {
        isEdit = NO;
    }

    
    self.Shadowview.layer.masksToBounds = NO;
    self.Shadowview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.Shadowview.layer.shadowOffset = CGSizeZero;
    self.Shadowview.layer.shadowRadius = 10.0f;
    self.Shadowview.layer.shadowOpacity = 1.0f;
    
    lblRangeValue.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lblRangeValue.layer.borderWidth = 0.3;
    lblUnitValue.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lblUnitValue.layer.borderWidth = 0.3;
    
    NSMutableArray* array = [NSMutableArray new];
    
    currentlySelectedTestType = indexPath;
//    [lblRangeValue setHidden:YES];
//    [lblUnitValue setHidden:YES];

    NSString* ignore_str = @"";
    if ([SCREEN_CODE_Rom isEqualToString:ScreenID]) {
        
        NSString* romSideName = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"SideName"];
        
        if ([romSideName isEqualToString:@"RIGHT & LEFT"]) {
            CollectionItem = 2;
        }
        else if([romSideName isEqualToString:@"CENTRAL"])
        {
            CollectionItem = 1;
        }
        
        lblRangeName.text = @"Normal Range";
        lblRangeValue.text = [NSString stringWithFormat:@"%@ - %@",[[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"MinimumRange"],[currentIndexArray.firstObject valueForKey:@"MaximumRange"]];
        lblUnitName.text =@"Unit";
        lblUnitValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"UnitName"];
    }
    else if ([SCREEN_CODE_SPECIAL isEqualToString:ScreenID]) {
        
        NSString* romSideName = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"SideName"];
        
        if ([romSideName isEqualToString:@"RIGHT & LEFT"]) {
            CollectionItem = 2;
        }
        else {
            
            CollectionItem = 1;
        }
        
        lblRangeName.text = @"Region";
        lblRangeValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Region"];
        
        lblUnitName.text = @"ResultName";
        lblUnitValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"ResultName"];

        
    }
    else if ([SCREEN_CODE_MMT isEqualToString:ScreenID]) {
        
        
        CollectionItem = 1;
        
        lblRangeName.text = @"Muscle";
        lblRangeValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Muscle"];
        
        lblUnitName.text = @"Motion";
        lblUnitValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Motion"];

        
    }
    else if ([SCREEN_CODE_GAIT isEqualToString:ScreenID]) {
        
        
        CollectionItem = 1;
        lblRangeName.text = @"Plane";
        lblRangeValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Plane"];
        
        lblUnitName.text = @"Unit";
        lblUnitValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"UnitName"];

        
    }
    else if ([SCREEN_CODE_POSTURE isEqualToString:ScreenID]) {
        
        CollectionItem = 1;
        lblRangeName.text = @"Region";
        lblRangeValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Region"];
        
        lblUnitName.text = @"Unit";
        lblUnitValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"UnitName"];

    }
    else if ([SCREEN_CODE_S_C isEqualToString:ScreenID]) {
        
        
        NSString* romSideName = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"SideName"];
        CollectionItem = [[[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Nooftrials"] integerValue];
        
        
        lblRangeName.text = @"No Of Trials";
        lblRangeValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Nooftrials"];
        
        lblUnitName.text = @"Unit";
        lblUnitValue.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"UnitName"];

        
        
    }
    else if ([SCREEN_CODE_COACHING isEqualToString:ScreenID]) {
        
        CollectionItem = 1;
        
        lblRangeName.text = @"Normal Range";
        lblRangeValue.text = @"-";
        
        lblUnitName.text = @"Unit";
        lblUnitValue.text = @"-";

        
    }
    

    txtRemarks.text = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Remarks"];
    ignore_str = [[currentIndexArray objectAtIndex:indexPath.row] valueForKey:@"Ignore"];
    
    if ([ignore_str.lowercaseString isEqualToString:@"false"] || ignore_str.length == 0 || [ignore_str isEqualToString:@"0"]) {
        [btnIgnore setImage:uncheck forState:UIControlStateNormal];
        [btnIgnore setTag:0];
    }
    else
    {
        [btnIgnore setImage:check forState:UIControlStateNormal];
        [btnIgnore setTag:1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.assCollection reloadData];
    });

    [self presentViewController:popupVC animated:YES completion:^{
        self.bottomConstant.constant = (CGRectGetHeight(self.popupVC.view.frame) - self.Shadowview.frame.size.height) / 2;
        [self.Shadowview updateConstraintsIfNeeded];
    }];
    
}

-(IBAction)closePopup:(id)sender
{
    [popupVC dismissViewControllerAnimated:YES completion:nil];
}
-(void)AssmentHeaderHeight:(UIButton *)sender
{
    
    if (currentlySelectedHeader == sender.tag) {
        currentlySelectedHeader = -1;
        
    }
    else {
        currentlySelectedHeader = sender.tag;
    }

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tblAssesments reloadData];
//        [tblAssesments reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _objContenArray.count)] withRowAnimation:UITableViewRowAnimationTop];
    });
}



-(IBAction)openDropDown:(id)sender
{
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    
    
    if ([sender tag] == 0) {
        
        NSMutableDictionary *coachdict = [[NSMutableDictionary alloc]initWithCapacity:2];
        [coachdict setValue:@"Coach" forKey:@"ModuleName"];
        [coachdict setValue:@"MSC084" forKey:@"ModuleCode"];
        
        NSMutableDictionary *physiodict = [[NSMutableDictionary alloc]initWithCapacity:2];
        
        [physiodict setValue:@"Physio" forKey:@"ModuleName"];
        [physiodict setValue:@"MSC085" forKey:@"ModuleCode"];
        
        NSMutableDictionary *Sandcdict = [[NSMutableDictionary alloc]initWithCapacity:2];
        
        [Sandcdict setValue:@"S and C" forKey:@"ModuleName"];
        [Sandcdict setValue:@"MSC086" forKey:@"ModuleCode"];
        
        dropVC.array = @[coachdict,physiodict,Sandcdict];
        dropVC.key = @"ModuleName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX([sender superview].frame), CGRectGetMaxY([sender superview].frame)+70, CGRectGetWidth([sender frame]), 200)];
        
    }
    else
    {
        DBAConnection *Db = [[DBAConnection alloc]init];
        NSString *clientCode = [AppCommon GetClientCode];
        NSString *userCode = [AppCommon GetUsercode];
        
        dropVC.array = [Db AssessmentTestType:clientCode :userCode :txtModule.selectedCode];
        dropVC.key = @"AssessmentName";
        [dropVC.tblDropDown setFrame:CGRectMake(CGRectGetMinX([sender superview].frame), CGRectGetMaxY([sender superview].frame)+70, CGRectGetWidth([sender frame]), 300)];
        
        
    }
    
        [self presentViewController:dropVC animated:YES completion:nil];
    
}


-(void)selectedValue:(NSMutableArray *)array andKey:(NSString *)key andIndex:(NSIndexPath *)Index
{
    if([key isEqualToString:@"AssessmentName"])
    {
        txtTitle.text = [[array objectAtIndex:Index.row] valueForKey:key];
        txtTitle.selectedCode = [[array objectAtIndex:Index.row] valueForKey:@"AssessmentCode"];
    }
    else
    {
        txtModule.text = [[array objectAtIndex:Index.row] valueForKey:key];
        txtModule.selectedCode = [[array objectAtIndex:Index.row] valueForKey:@"ModuleCode"];
        txtTitle.text = @"";

    }
    
    
    [self tableValuesMethod];
    
}

-(void)selectedDate:(NSString *)Date
{
    currentlySelectedDate = Date;
    NSLog(@"selectedDate %@ ",Date);
    [self tableValuesMethod];
    [btnDate setTitle:currentlySelectedDate forState:UIControlStateNormal];
    
}

- (IBAction)actionOpenDate:(id)sender {
    
    CalendarViewController  * objTabVC = [CalendarViewController new];
    //    objTabVC.datePickerFormat = @"yyy-MM-dd"; // 2/9/2018 12:00:00 AM
    objTabVC.datePickerFormat = @"dd/MM/yyy";
    objTabVC.datePickerDelegate = self;
    objTabVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    objTabVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [objTabVC.view setBackgroundColor:[UIColor clearColor]];
    [self presentViewController:objTabVC animated:YES completion:nil];
    
}
- (IBAction)actionAssessmentSave:(id)sender {
    
    ifSaveBtnClicked = YES;
    
    NSDictionary* collectionValues = [self collectEnteredValues];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    NSDictionary* currentIndexArray = [[[self.objContenArray objectAtIndex:currentlySelectedTestType.section] valueForKey:@"TestValues"] objectAtIndex:currentlySelectedTestType.row];
    
    if ([currentlySelectedTest isEqualToString:SCREEN_CODE_Rom])
    {
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];
        
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];
        
        [dict setValue:currentIndexArray[@"Inference"] forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"Value"] forKey:@"Value"];
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];
        
        [dict setValue:@0 forKey:@"Left1"];
        [dict setValue:@0 forKey:@"Right1"];
        [dict setValue:@0 forKey:@"Central1"];
        [dict setValue:@0 forKey:@"Left2"];
        [dict setValue:@0 forKey:@"Right2"];
        [dict setValue:@0 forKey:@"Central2"];
        [dict setValue:@0 forKey:@"Left3"];
        [dict setValue:@0 forKey:@"Right3"];
        [dict setValue:@0 forKey:@"Central3"];
        
        [dict setValue:@0 forKey:@"Left4"];
        [dict setValue:@0 forKey:@"Right4"];
        [dict setValue:@0 forKey:@"Central4"];
        [dict setValue:@0 forKey:@"Left5"];
        [dict setValue:@0 forKey:@"Right5"];
        [dict setValue:@0 forKey:@"Central5"];
        [dict setValue:@0 forKey:@"Left6"];
        [dict setValue:@0 forKey:@"Right6"];
        [dict setValue:@0 forKey:@"Central6"];
        
        [dict setValue:@0 forKey:@"Left7"];
        [dict setValue:@0 forKey:@"Right7"];
        [dict setValue:@0 forKey:@"Central7"];
        [dict setValue:@0 forKey:@"Left8"];
        [dict setValue:@0 forKey:@"Right8"];
        [dict setValue:@0 forKey:@"Central8"];
        [dict setValue:@0 forKey:@"Left9"];
        [dict setValue:@0 forKey:@"Right9"];
        [dict setValue:@0 forKey:@"Central9"];
        [dict setValue:@0 forKey:@"issync"];
        
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_SPECIAL])
    {
        // special
        //        NSDictionary * objDic = [self.ObjSelectTestArray objectAtIndex:0];
        //
        //            [self.objDBConnection UPDATEAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"]  :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        //            [self.objDBConnection INSERTAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];
        
        
        //        [dict setValue: forKey:@"userCode"];
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:currentIndexArray[@"Value"] forKey:@"Value"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:@"" forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];
        
        
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];
        
        
        [dict setValue:@0 forKey:@"Left1"];
        [dict setValue:@0 forKey:@"Right1"];
        [dict setValue:@0 forKey:@"Central1"];
        [dict setValue:@0 forKey:@"Left2"];
        [dict setValue:@0 forKey:@"Right2"];
        [dict setValue:@0 forKey:@"Central2"];
        [dict setValue:@0 forKey:@"Left3"];
        [dict setValue:@0 forKey:@"Right3"];
        [dict setValue:@0 forKey:@"Central3"];
        
        [dict setValue:@0 forKey:@"Left4"];
        [dict setValue:@0 forKey:@"Right4"];
        [dict setValue:@0 forKey:@"Central4"];
        [dict setValue:@0 forKey:@"Left5"];
        [dict setValue:@0 forKey:@"Right5"];
        [dict setValue:@0 forKey:@"Central5"];
        [dict setValue:@0 forKey:@"Left6"];
        [dict setValue:@0 forKey:@"Right6"];
        [dict setValue:@0 forKey:@"Central6"];
        
        [dict setValue:@0 forKey:@"Left7"];
        [dict setValue:@0 forKey:@"Right7"];
        [dict setValue:@0 forKey:@"Central7"];
        [dict setValue:@0 forKey:@"Left8"];
        [dict setValue:@0 forKey:@"Right8"];
        [dict setValue:@0 forKey:@"Central8"];
        [dict setValue:@0 forKey:@"Left9"];
        [dict setValue:@0 forKey:@"Right9"];
        [dict setValue:@0 forKey:@"Central9"];
        [dict setValue:@0 forKey:@"issync"];
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_MMT]) { // MMT
        //        NSDictionary * objDic = [self.ObjSelectTestArray objectAtIndex:0];
        //
        //            [self.objDBConnection UPDATEAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"]  :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"":@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        //            [self.objDBConnection INSERTAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];
        
        
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:currentIndexArray[@"romValue"] forKey:@"Value"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:@"" forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];
        
        
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];

        
        [dict setValue:@0 forKey:@"Left1"];
        [dict setValue:@0 forKey:@"Right1"];
        [dict setValue:@0 forKey:@"Central1"];
        [dict setValue:@0 forKey:@"Left2"];
        [dict setValue:@0 forKey:@"Right2"];
        [dict setValue:@0 forKey:@"Central2"];
        [dict setValue:@0 forKey:@"Left3"];
        [dict setValue:@0 forKey:@"Right3"];
        [dict setValue:@0 forKey:@"Central3"];
        
        
        [dict setValue:@0 forKey:@"Left4"];
        [dict setValue:@0 forKey:@"Right4"];
        [dict setValue:@0 forKey:@"Central4"];
        [dict setValue:@0 forKey:@"Left5"];
        [dict setValue:@0 forKey:@"Right5"];
        [dict setValue:@0 forKey:@"Central5"];
        [dict setValue:@0 forKey:@"Left6"];
        [dict setValue:@0 forKey:@"Right6"];
        [dict setValue:@0 forKey:@"Central6"];
        
        
        [dict setValue:@0 forKey:@"Left7"];
        [dict setValue:@0 forKey:@"Right7"];
        [dict setValue:@0 forKey:@"Central7"];
        [dict setValue:@0 forKey:@"Left8"];
        [dict setValue:@0 forKey:@"Right8"];
        [dict setValue:@0 forKey:@"Central8"];
        [dict setValue:@0 forKey:@"Left9"];
        [dict setValue:@0 forKey:@"Right9"];
        [dict setValue:@0 forKey:@"Central9"];
        [dict setValue:@0 forKey:@"issync"];

        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_GAIT]) { // Gait
        
        //        NSDictionary * objDic = [self.ObjSelectTestArray objectAtIndex:0];
        //
        //            [self.objDBConnection UPDATEAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"]  :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        //            [self.objDBConnection INSERTAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"":@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];

        
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:currentIndexArray[@"romValue"] forKey:@"Value"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:@"" forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];

        
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];
        
        
        [dict setValue:@0 forKey:@"Left1"];
        [dict setValue:@0 forKey:@"Right1"];
        [dict setValue:@0 forKey:@"Central1"];
        [dict setValue:@0 forKey:@"Left2"];
        [dict setValue:@0 forKey:@"Right2"];
        [dict setValue:@0 forKey:@"Central2"];
        [dict setValue:@0 forKey:@"Left3"];
        [dict setValue:@0 forKey:@"Right3"];
        [dict setValue:@0 forKey:@"Central3"];
        
        [dict setValue:@0 forKey:@"Left4"];
        [dict setValue:@0 forKey:@"Right4"];
        [dict setValue:@0 forKey:@"Central4"];
        [dict setValue:@0 forKey:@"Left5"];
        [dict setValue:@0 forKey:@"Right5"];
        [dict setValue:@0 forKey:@"Central5"];
        [dict setValue:@0 forKey:@"Left6"];
        [dict setValue:@0 forKey:@"Right6"];
        [dict setValue:@0 forKey:@"Central6"];
        
        [dict setValue:@0 forKey:@"Left7"];
        [dict setValue:@0 forKey:@"Right7"];
        [dict setValue:@0 forKey:@"Central7"];
        [dict setValue:@0 forKey:@"Left8"];
        [dict setValue:@0 forKey:@"Right8"];
        [dict setValue:@0 forKey:@"Central8"];
        [dict setValue:@0 forKey:@"Left9"];
        [dict setValue:@0 forKey:@"Right9"];
        [dict setValue:@0 forKey:@"Central9"];
        [dict setValue:@0 forKey:@"issync"];

        
        
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_POSTURE]) { // Posture
        //
        //            [self.objDBConnection UPDATEAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"]  :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        //            [self.objDBConnection INSERTAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];
        
        
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:currentIndexArray[@"romValue"] forKey:@"Value"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:@"" forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];
        
        
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];
        
        
        [dict setValue:@0 forKey:@"Left1"];
        [dict setValue:@0 forKey:@"Right1"];
        [dict setValue:@0 forKey:@"Central1"];
        [dict setValue:@0 forKey:@"Left2"];
        [dict setValue:@0 forKey:@"Right2"];
        [dict setValue:@0 forKey:@"Central2"];
        [dict setValue:@0 forKey:@"Left3"];
        [dict setValue:@0 forKey:@"Right3"];
        [dict setValue:@0 forKey:@"Central3"];
        
        [dict setValue:@0 forKey:@"Left4"];
        [dict setValue:@0 forKey:@"Right4"];
        [dict setValue:@0 forKey:@"Central4"];
        [dict setValue:@0 forKey:@"Left5"];
        [dict setValue:@0 forKey:@"Right5"];
        [dict setValue:@0 forKey:@"Central5"];
        [dict setValue:@0 forKey:@"Left6"];
        [dict setValue:@0 forKey:@"Right6"];
        [dict setValue:@0 forKey:@"Central6"];
        
        [dict setValue:@0 forKey:@"Left7"];
        [dict setValue:@0 forKey:@"Right7"];
        [dict setValue:@0 forKey:@"Central7"];
        [dict setValue:@0 forKey:@"Left8"];
        [dict setValue:@0 forKey:@"Right8"];
        [dict setValue:@0 forKey:@"Central8"];
        [dict setValue:@0 forKey:@"Left9"];
        [dict setValue:@0 forKey:@"Right9"];
        [dict setValue:@0 forKey:@"Central9"];
        [dict setValue:@0 forKey:@"issync"];
        
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_S_C]) { // S & C
        
        //            [self.objDBConnection UPDATEAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"]  :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[objDic valueForKey:@"left"] :[objDic valueForKey:@"Right"] :[objDic valueForKey:@"Center"] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :[objDic valueForKey:@"left1"] :[objDic valueForKey:@"Right1"] :[objDic valueForKey:@"Center1"] :[objDic valueForKey:@"left2"] :[objDic valueForKey:@"Right2"] :[objDic valueForKey:@"Center2"] :[objDic valueForKey:@"left3"] :[objDic valueForKey:@"Right3"] :[objDic valueForKey:@"Center3"] :[objDic valueForKey:@"left4"] :[objDic valueForKey:@"Right4"] :[objDic valueForKey:@"Center4"] :[objDic valueForKey:@"left5"] :[objDic valueForKey:@"Right5"] :[objDic valueForKey:@"Center5"] :[objDic valueForKey:@"left6"] :[objDic valueForKey:@"Right6"] :[objDic valueForKey:@"Center6"] :[objDic valueForKey:@"left7"] :[objDic valueForKey:@"Right7"] :[objDic valueForKey:@"Center7"] :[objDic valueForKey:@"left8"] :[objDic valueForKey:@"Right8"] :[objDic valueForKey:@"Center8"] :[objDic valueForKey:@"left9"] :[objDic valueForKey:@"Right9"] :[objDic valueForKey:@"Center9"] :@"0"];
        
        //            [self.objDBConnection INSERTAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[objDic valueForKey:@"left"] :[objDic valueForKey:@"Right"] :[objDic valueForKey:@"Center"] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :[objDic valueForKey:@"left1"] :[objDic valueForKey:@"Right1"] :[objDic valueForKey:@"Center1"] :[objDic valueForKey:@"left2"] :[objDic valueForKey:@"Right2"] :[objDic valueForKey:@"Center2"] :[objDic valueForKey:@"left3"] :[objDic valueForKey:@"Right3"] :[objDic valueForKey:@"Center3"] :[objDic valueForKey:@"left4"] :[objDic valueForKey:@"Right4"] :[objDic valueForKey:@"Center4"] :[objDic valueForKey:@"left5"] :[objDic valueForKey:@"Right5"] :[objDic valueForKey:@"Center5"] :[objDic valueForKey:@"left6"] :[objDic valueForKey:@"Right6"] :[objDic valueForKey:@"Center6"] :[objDic valueForKey:@"left7"] :[objDic valueForKey:@"Right7"] :[objDic valueForKey:@"Center7"] :[objDic valueForKey:@"left8"] :[objDic valueForKey:@"Right8"] :[objDic valueForKey:@"Center8"] :[objDic valueForKey:@"left9"] :[objDic valueForKey:@"Right9"] :[objDic valueForKey:@"Center9"] :@"0" ];
        
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];
        
        
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:currentIndexArray[@"romValue"] forKey:@"Value"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:@"" forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];
        
        
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];
        
        
        [dict setValue:collectionValues[@"left1"]  forKey:@"Left1"];
        [dict setValue:collectionValues[@"right1"]  forKey:@"Right1"];
        [dict setValue:collectionValues[@"center1"]  forKey:@"Central1"];
        [dict setValue:collectionValues[@"left2"]  forKey:@"Left2"];
        [dict setValue:collectionValues[@"right2"]  forKey:@"Right2"];
        [dict setValue:collectionValues[@"central2"]  forKey:@"Central2"];
        [dict setValue:collectionValues[@"left3"]  forKey:@"Left3"];
        [dict setValue:collectionValues[@"right3"]  forKey:@"Right3"];
        [dict setValue:collectionValues[@"central3"]  forKey:@"Central3"];
        
        [dict setValue:collectionValues[@"left4"]  forKey:@"Left4"];
        [dict setValue:collectionValues[@"right4"]  forKey:@"Right4"];
        [dict setValue:collectionValues[@"central4"]  forKey:@"Central4"];
        [dict setValue:collectionValues[@"left5"]  forKey:@"Left5"];
        [dict setValue:collectionValues[@"right5"]  forKey:@"Right5"];
        [dict setValue:collectionValues[@"central5"]  forKey:@"Central5"];
        [dict setValue:collectionValues[@"left6"]  forKey:@"Left6"];
        [dict setValue:collectionValues[@"right6"]  forKey:@"Right6"];
        [dict setValue:collectionValues[@"central6"]  forKey:@"Central6"];
        
        [dict setValue:collectionValues[@"left7"]  forKey:@"Left7"];
        [dict setValue:collectionValues[@"right7"]  forKey:@"Right7"];
        [dict setValue:collectionValues[@"central7"]  forKey:@"Central7"];
        [dict setValue:collectionValues[@"left8"]  forKey:@"Left8"];
        [dict setValue:collectionValues[@"right8"]  forKey:@"Right8"];
        [dict setValue:collectionValues[@"central8"]  forKey:@"Central8"];
        [dict setValue:collectionValues[@"left9"]  forKey:@"Left9"];
        [dict setValue:collectionValues[@"right9"]  forKey:@"Right9"];
        [dict setValue:collectionValues[@"central9"]  forKey:@"Central9"];
        [dict setValue:@"0"  forKey:@"issync"];

        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_COACHING]) { // coach
        
        //        NSDictionary * objDic = [self.ObjSelectTestArray objectAtIndex:0];
        //
        //            [self.objDBConnection UPDATEAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"]  :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        //            [self.objDBConnection INSERTAssessmentEntry:clientCode :@"" :self.ModuleStr :[self.selectAllValueDic valueForKey:@"AssessmentCode"] :self.SectionTestCodeStr :self.SelectTestTypecode :self.SelectScreenId :self.version :usercode :[self.selectAllValueDic valueForKey:@"PlayerCode"] :[self.selectAllValueDic valueForKey:@"SelectDate"] :[NSString stringWithFormat:@"%@",self.left_lbl.text] :[NSString stringWithFormat:@"%@",self.right_lbl.text] :[NSString stringWithFormat:@"%@",self.centeral_Txt.text] :self.valueTxt.text :self.remark_Txt.text :@"" :@"" :self.description_lbl.text :@"MSC001" :usercode :[objDic valueForKey:@"CreatedDate"] :usercode :[objDic valueForKey:@"ModifiedDate"] :self.ingnoreStatus :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@0 :@"0"];
        
        [dict setValue:clientCode forKey:@"Clientcode"];
        [dict setValue:txtModule.selectedCode forKey:@"Modulecode"];
        [dict setValue:txtTitle.selectedCode forKey:@"Assessmentcode"];
        [dict setValue:currentIndexArray[@"AssessmentEntrycode"] forKey:@"AssessmentEntrycode"];
        [dict setValue:currentIndexArray[@"AssessmentTestCode"] forKey:@"Assessmenttestcode"];
        [dict setValue:currentIndexArray[@"TestTypeCode"] forKey:@"Assessmenttesttypecode"];
        [dict setValue:currentIndexArray[@"ScreenID"] forKey:@"Assessmenttesttypescreencode"];
        [dict setValue:currentIndexArray[@"version"] forKey:@"Version"];
        [dict setValue:usercode forKey:@"Assessor"];
        [dict setValue:_selectedPlayerCode forKey:@"Playercode"];
        [dict setValue:currentlySelectedDate forKey:@"Assessmententrydate"];
        
        
        [dict setValue:collectionValues[@"left"] forKey:@"Left"];
        [dict setValue:collectionValues[@"right"] forKey:@"Right"];
        [dict setValue:collectionValues[@"center"] forKey:@"Central"];
        [dict setValue:currentIndexArray[@"romValue"] forKey:@"Value"];
        [dict setValue:collectionValues[@"remark"] forKey:@"Remarks"];
        [dict setValue:@"" forKey:@"Inference"];
        [dict setValue:currentIndexArray[@"UnitName"] forKey:@"Units"];
        
        
        [dict setValue:@"" forKey:@"Description"];
        [dict setValue:@"MSC001" forKey:@"Recordstatus"];
        [dict setValue:usercode forKey:@"Createdby"];
        [dict setValue:currentlySelectedDate forKey:@"Createddate"];
        [dict setValue:usercode forKey:@"Modifiedby"];
        [dict setValue:currentlySelectedDate forKey:@"Modifieddate"];
        [dict setValue:collectionValues[@"ignore"]  forKey:@"isIgnored"];
        
        
        [dict setValue:@0 forKey:@"Left1"];
        [dict setValue:@0 forKey:@"Right1"];
        [dict setValue:@0 forKey:@"Central1"];
        [dict setValue:@0 forKey:@"Left2"];
        [dict setValue:@0 forKey:@"Right2"];
        [dict setValue:@0 forKey:@"Central2"];
        [dict setValue:@0 forKey:@"Left3"];
        [dict setValue:@0 forKey:@"Right3"];
        [dict setValue:@0 forKey:@"Central3"];
        
        [dict setValue:@0 forKey:@"Left4"];
        [dict setValue:@0 forKey:@"Right4"];
        [dict setValue:@0 forKey:@"Central4"];
        [dict setValue:@0 forKey:@"Left5"];
        [dict setValue:@0 forKey:@"Right5"];
        [dict setValue:@0 forKey:@"Central5"];
        [dict setValue:@0 forKey:@"Left6"];
        [dict setValue:@0 forKey:@"Right6"];
        [dict setValue:@0 forKey:@"Central6"];
        
        [dict setValue:@0 forKey:@"Left7"];
        [dict setValue:@0 forKey:@"Right7"];
        [dict setValue:@0 forKey:@"Central7"];
        [dict setValue:@0 forKey:@"Left8"];
        [dict setValue:@0 forKey:@"Right8"];
        [dict setValue:@0 forKey:@"Central8"];
        [dict setValue:@0 forKey:@"Left9"];
        [dict setValue:@0 forKey:@"Right9"];
        [dict setValue:@0 forKey:@"Central9"];
        [dict setValue:@0 forKey:@"issync"];

    }
    
    if(isEdit){
        [self.objDBconnection updateAssessmentEntry:dict];
    }
    else{
        [self.objDBconnection insertAssessmentEntry:dict];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self tableValuesMethod];
    }];
    
}



#pragma mark UICOLLECTIONVIEW DELAGATES

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CollectionItem;
}

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//    // 120, 100
//
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TestPropertyCollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"AssessmentCell" forIndexPath:indexPath];
    
    cell.txtField.delegate = self;
    NSString* SideCode = @"";
    NSArray* currentIndexArray = [[self.objContenArray objectAtIndex:currentlySelectedTestType.section] valueForKey:@"TestValues"];
    cell.txt1_SC.text = @"";
    cell.txt2_SC.text = @"";
    cell.txtField.text = @"";
    cell.txtDropDown.text = @"";
    cell.txtDropDown.tag = indexPath.item;
    cell.txtField.tag = indexPath.item;
    cell.txt1_SC.tag = indexPath.item;
    cell.txt2_SC.tag = indexPath.item;
    
    if ([currentlySelectedTest isEqualToString:SCREEN_CODE_S_C])
    {
        [cell.SC_view setHidden:NO];
        [cell.txtDropDown setHidden:YES];
        [cell.txtField setHidden:YES];
        cell.txt1_SC.tag = indexPath.row;
        cell.txt2_SC.tag = indexPath.row;
        cell.txt1_SC.keyboardType = UIKeyboardTypeNumberPad;
        cell.txt2_SC.keyboardType = UIKeyboardTypeNumberPad;
        //            SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"Side"];
        
        cell.txt1_SC.placeholder = [NSString stringWithFormat:@"left%ld",(long)indexPath.item+1];
        cell.txt2_SC.placeholder = [NSString stringWithFormat:@"right%ld",(long)indexPath.item+1];
        cell.lblBottom.text = [NSString stringWithFormat:@"Trail %ld",(long)indexPath.item+1];
        
    }
    else
    {
        [cell.SC_view setHidden:YES];
        [cell.txtDropDown setHidden:NO];
        [cell.txtField setHidden:YES];
        cell.txtDropDown.delegate = self;
        [cell.txtDropDown setInputView:_pickerMainView];
        
        if ([currentlySelectedTest isEqualToString:SCREEN_CODE_Rom]) {
            //                [cell.SC_view setHidden:YES];
            [cell.txtDropDown setHidden:YES];
            [cell.txtField setHidden:NO];
            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
            //                SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"romSide"];
            
        }
        else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_SPECIAL])
        {
            //                SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"SpecialSide"];
            
        }
        else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_MMT])
        {
            //                SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"MmtSide"];
            
        }
        else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_GAIT])
        {
            //                SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"Side"];
            
        }
        else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_POSTURE])
        {
            //                SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"Side"];
            
        }
        else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_COACHING])
        {
            //                SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"Side"];
            
        }
        
        SideCode = [[currentIndexArray objectAtIndex:currentlySelectedTestType.item] valueForKey:@"Side"];
        
        if([SideCode isEqualToString:@"MSC004"])
        {
            cell.lblBottom.text = @"Center";
            cell.txtField.strParamName = @"center";
            cell.txtField.text = [[currentIndexArray firstObject] valueForKey:@"Center"];
            
        }
        else if([SideCode isEqualToString:@"MSC003"] && indexPath.item == 0)
        {
            cell.lblBottom.text = @"Right";
            cell.txtField.strParamName = @"right";
            cell.txtField.text = [[currentIndexArray firstObject] valueForKey:@"Right"];

        }
        else
        {
            cell.lblBottom.text = @"Left";
            cell.txtField.strParamName = @"left";
            cell.txtField.text = [[currentIndexArray firstObject] valueForKey:@"Left"];
        }
        
        
    }
    
    
    
    return cell;
    
}

#pragma mark UITextField DELAGATES

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([currentlySelectedTest isEqualToString:SCREEN_CODE_SPECIAL])
    {
        dropdownArray =[self.objDBconnection getPositiveNegative];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_MMT])
    {
        dropdownArray =[self.objDBconnection getWithMmtCombo];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_GAIT])
    {
        dropdownArray =[self.objDBconnection getResultCombo];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_POSTURE])
    {
        dropdownArray =[self.objDBconnection getwithPostureRESULTS];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_COACHING])
    {
        
    }
    textFieldIndexPath = textField.tag;
    
    return YES;
}

-(void)setTopIndicatorColor
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    

    TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell *)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:textFieldIndexPath inSection:0]];
    
    NSInteger value = [[textField.text stringByAppendingString:string] integerValue];
    
    if (textField.text.length == 1 && string.length == 0) {
        value = 0;
    }
    
    if ([currentlySelectedTest isEqualToString:SCREEN_CODE_Rom])
    {
        NSArray* minMaxValue;
        if ([lblRangeName.text isEqualToString:@"Normal Range"]) {
            minMaxValue = [lblRangeValue.text componentsSeparatedByString:@"-"];
            
            if (minMaxValue.count) {
                
                if (value < [[minMaxValue firstObject] integerValue]) // Below Normal
                {
                    cell.lblTopIndicator.backgroundColor = [UIColor lightGrayColor];
                }
                else if (value >= [[minMaxValue firstObject] integerValue] && value <= [[minMaxValue objectAtIndex:1] integerValue]) // Normal
                {
                    [cell.lblTopIndicator setBackgroundColor:orange];

                }
                else if (value >= [[minMaxValue objectAtIndex:1] integerValue]) // Above normal
                {
                    cell.lblTopIndicator.backgroundColor = green;
                }
            }
        }
    
        //        dropdownArray =[self.objDBconnection getPositiveNegative];
        //        cell.txtField.text = textField.text;
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_SPECIAL])
    {
        dropdownArray =[self.objDBconnection getPositiveNegative];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_MMT])
    {
        dropdownArray =[self.objDBconnection getWithMmtCombo];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_GAIT])
    {
        dropdownArray =[self.objDBconnection getResultCombo];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_POSTURE])
    {
        dropdownArray =[self.objDBconnection getwithPostureRESULTS];
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_COACHING])
    {
        
    }
    
        if ([currentlySelectedTest isEqualToString:SCREEN_CODE_Rom])
        {
    //        dropdownArray =[self.objDBconnection getPositiveNegative];
    //        cell.txtField.text = textField.text;
    
        }
        else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_S_C])
        {
    //        dropdownArray =[self.objDBconnection getWithMmtCombo];
    //        cell.txt1_SC.text = textField.text;
        }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)actionIgnore:(id)sender {
    
    if ([[sender currentImage]isEqual:check]) {
        [sender setImage:uncheck forState:UIControlStateNormal];
        [sender setTag:0];
    }
    else
    {
        [sender setImage:check forState:UIControlStateNormal];
        [sender setTag:1];
    }
}

-(NSMutableDictionary *)collectEnteredValues
{
    
    NSArray* arr = @[@"left",@"right",@"center"];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    if ([currentlySelectedTest isEqualToString:SCREEN_CODE_Rom])
    {
        for (NSInteger i = 0; i< CollectionItem; i++) {
            TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell *)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            [dict setValue:cell.txtField.text forKey:[cell.lblBottom.text lowercaseString]];
            
        }
        
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""] || ![dict.allKeys containsObject:keys])
            {
                [dict setValue:@"0" forKey:keys];
            }

        }
        
        
//        if (![dict.allKeys containsObject:@"left"]) {
//            [dict setValue:@"" forKey:@"left"];
//        }
//
//        if (![dict.allKeys containsObject:@"right"]) {
//            [dict setValue:@"" forKey:@"right"];
//        }
//
//        if (![dict.allKeys containsObject:@"center"]) {
//            [dict setValue:@"" forKey:@"center"];
//        }
        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
        
    }
    else if([currentlySelectedTest isEqualToString:SCREEN_CODE_SPECIAL])
    {
        //        NSMutableDictionary* dict = [NSMutableDictionary new];
        for (NSInteger i = 0; i< CollectionItem; i++) {
            TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell *)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            //            if (cell.txtDropDown.text.length == 0) {
            //                cell.txtDropDown.text = @"";
            //            }
            [dict setValue:cell.txtDropDown.text forKey:[cell.lblBottom.text lowercaseString]];
            
        }
        
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""]) {
                [dict setValue:@"0" forKey:keys];
            }
            
        }

//        if (![dict.allKeys containsObject:@"left"]) {
//            [dict setValue:@"" forKey:@"left"];
//        }
//
//        if (![dict.allKeys containsObject:@"right"]) {
//            [dict setValue:@"" forKey:@"right"];
//        }
//
//        if (![dict.allKeys containsObject:@"center"]) {
//            [dict setValue:@"" forKey:@"center"];
//        }
        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        //        NSNumber* num = [NSNumber numberWithInteger:btnIgnore.tag];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_MMT])
    {
        for (NSInteger i = 0; i< CollectionItem; i++) {
            TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell *)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            //            [dict setValue:cell.txtDropDown.text forKey:cell.txtDropDown.strParamName];
            [dict setObject:cell.txtDropDown.text forKey:[cell.lblBottom.text lowercaseString]];
            
            
            //            NSString* trail = [NSString stringWithFormat:@"%@ - %@",cell.txt1_SC.text,cell.txt2_SC.text];
            //            [dict setValue:trail forKey:arr[i]];
            
        }
        
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""]) {
                [dict setValue:@"0" forKey:keys];
            }
            
        }

//        if (![dict.allKeys containsObject:@"left"]) {
//            [dict setValue:@"" forKey:@"left"];
//        }
//
//        if (![dict.allKeys containsObject:@"right"]) {
//            [dict setValue:@"" forKey:@"right"];
//        }
//
//        if (![dict.allKeys containsObject:@"center"]) {
//            [dict setValue:@"" forKey:@"center"];
//        }
        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_GAIT])
    {
        for (NSInteger i = 0; i< CollectionItem; i++) {
            TestPropertyCollectionViewCell* cell =(TestPropertyCollectionViewCell *) [assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            //            [dict setValue:cell.txtDropDown.text forKey:cell.txtDropDown.strParamName];
            [dict setObject:cell.txtDropDown.text forKey:[cell.lblBottom.text lowercaseString]];
            
            
            //            NSString* trail = [NSString stringWithFormat:@"%@ - %@",cell.txt1_SC.text,cell.txt2_SC.text];
            //            [dict setValue:trail forKey:arr[i]];
            
            
        }
        
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""]) {
                [dict setValue:@"0" forKey:keys];
            }
            
        }

//        if (![dict.allKeys containsObject:@"left"]) {
//            [dict setValue:@"" forKey:@"left"];
//        }
//
//        if (![dict.allKeys containsObject:@"right"]) {
//            [dict setValue:@"" forKey:@"right"];
//        }
//
//        if (![dict.allKeys containsObject:@"center"]) {
//            [dict setValue:@"" forKey:@"center"];
//        }
        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_POSTURE])
    {
        for (NSInteger i = 0; i< CollectionItem; i++) {
            TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell *)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            //            [dict setValue:cell.txtDropDown.text forKey:cell.txtDropDown.strParamName];
            [dict setObject:cell.txtDropDown.text forKey:[cell.lblBottom.text lowercaseString]];
            
            
            
            //            NSString* trail = [NSString stringWithFormat:@"%@ - %@",cell.txt1_SC.text,cell.txt2_SC.text];
            //            [dict setValue:trail forKey:arr[i]];
            
        }
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""]) {
                [dict setValue:@"0" forKey:keys];
            }
            
        }

//        if (![dict.allKeys containsObject:@"left"]) {
//            [dict setValue:@"" forKey:@"left"];
//        }
//
//        if (![dict.allKeys containsObject:@"right"]) {
//            [dict setValue:@"" forKey:@"right"];
//        }
//
//        if (![dict.allKeys containsObject:@"center"]) {
//            [dict setValue:@"" forKey:@"center"];
//        }
        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_S_C])
    {
        for (NSInteger i = 0; i< CollectionItem; i++) {

            TestPropertyCollectionViewCell* cell = [assCollection.dataSource collectionView:assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            NSLog(@"indexpath %ld",(long)i);
            
            [dict setValue:cell.txt1_SC.text forKey:cell.txt1_SC.placeholder];
            [dict setValue:cell.txt2_SC.text forKey:cell.txt2_SC.placeholder];
            
        }
        
        NSArray* arr = @[@"left1",@"right1",@"left2",@"right2",@"right3",@"left3",@"left4",@"right4",@"left5",@"right5",@"left6",@"right6",@"left7",@"right7",@"left8",@"right8"];
        
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""]) {
                [dict setValue:@"0" forKey:keys];
            }
        }

        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_COACHING])
    {
        for (NSInteger i = 0; i< CollectionItem; i++) {
            TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell *)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            [dict setValue:cell.txtDropDown.text forKey:[cell.lblBottom.text lowercaseString]];
            
        }
        for (id keys in arr) {
            
            if ([[dict valueForKey:keys] isEqualToString:@""]) {
                [dict setValue:@"0" forKey:keys];
            }
            
        }

//        if (![dict.allKeys containsObject:@"left"]) {
//            [dict setValue:@"" forKey:@"left"];
//        }
//
//        if (![dict.allKeys containsObject:@"right"]) {
//            [dict setValue:@"" forKey:@"right"];
//        }
//
//        if (![dict.allKeys containsObject:@"center"]) {
//            [dict setValue:@"" forKey:@"center"];
//        }
        
        [dict setValue:txtRemarks.text forKey:@"remark"];
        NSString* ignoreValue = [NSString stringWithFormat:@"%ld",(long)btnIgnore.tag];
        [dict setValue:ignoreValue forKey:@"ignore"];
        
    }
    
    //    NSDictionary* result = dict;
    return dict;
}

#pragma mark UIPickerView DELAGATES

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dropdownArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[dropdownArray objectAtIndex:row] valueForKey:@"ResultName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    NSLog(@"%@\n %@",[[dropdownArray objectAtIndex:row] valueForKey:@"Result"],[[dropdownArray objectAtIndex:row] valueForKey:@"ResultName"]);
    
    TestPropertyCollectionViewCell* cell = (TestPropertyCollectionViewCell*)[assCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:textFieldIndexPath inSection:0]];
    cell.txtDropDown.text = [[dropdownArray objectAtIndex:row] valueForKey:@"ResultName"];
    
    [cell.txtDropDown setStrTestCode:[[dropdownArray objectAtIndex:row] valueForKey:@"Result"]];
    
    if ([currentlySelectedTest isEqualToString:SCREEN_CODE_Rom])
    {
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_SPECIAL])
    {
        if ([lblUnitValue.text isEqualToString:cell.txtDropDown.text]) {
            cell.lblTopIndicator.backgroundColor = green;
        }
        else
        {
            [cell.lblTopIndicator setBackgroundColor:orange];

        }
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_MMT])
    {
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_GAIT])
    {
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_POSTURE])
    {
        
    }
    else if ([currentlySelectedTest isEqualToString:SCREEN_CODE_COACHING])
    {
        
    }

    
}


- (IBAction)actionCancelDropDown:(id)sender {
    
    if ([sender tag]) // Done
    {
    }
    
    [self.popupVC.view endEditing:YES];
    [self.assCollection endEditing:YES];
}
@end

