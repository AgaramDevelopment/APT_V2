//
//  ViewController.m
//  APT_V2
//
//  Created by user on 02/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <SKSTableViewDelegate,selectedDropDown>
{
    NSString * usercode;
    NSString *clientCode;
    BOOL isEdit;
    
}

@property (nonatomic,strong) NSMutableArray * objContenArray;
@property (nonatomic,strong) NSString * SelectScreenId;;
@property (nonatomic,strong) DBAConnection *objDBconnection;

@property (nonatomic,strong) NSDictionary * SelectDetailDic;
@property (nonatomic,strong) NSString * assessmentCodeStr;
@property (nonatomic,strong) NSString * ModuleCodeStr;
@property (nonatomic,strong) NSString * selectDate;

@end

@implementation ViewController
@synthesize tblAssesments;

@synthesize tblDropDown;

@synthesize txtTitle,txtModule;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    tblAssesments.SKSTableViewDelegate = self;
    usercode = [AppCommon GetUsercode];
    clientCode = [AppCommon GetClientCode];
    
    [self customnavigationmethod];
}

-(void)viewDidAppear:(BOOL)animated
{
    [txtModule setup];
    [txtTitle setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    objCustomNavigation.btn_back.hidden =YES;
    objCustomNavigation.menu_btn.hidden =NO;
    //        [objCustomNavigation.btn_back addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //        [objCustomNavigation.home_btn addTarget:self action:@selector(HomeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tableValuesMethod
{
    
    self.objDBconnection = [[DBAConnection alloc]init];
    self.objContenArray =[[NSMutableArray alloc]init];
    NSMutableArray * ComArray = [[NSMutableArray alloc]init];
    
    NSMutableArray * TestAsseementArray =  [self.objDBconnection TestByAssessment:clientCode :txtTitle.selectedCode :txtModule.selectedCode];
    
    NSLog(@"%@", TestAsseementArray);
    
    NSMutableArray * AssessmentTypeTest;
    NSMutableArray * AssessmentNameArray;
    NSMutableDictionary * MainDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i <TestAsseementArray.count; i++)
    {
        NSMutableDictionary * tempDict = [[NSMutableDictionary alloc]init];

        AssessmentNameArray =[[NSMutableArray alloc]init];
        [tempDict setValue:[[TestAsseementArray valueForKey:@"TestCode"] objectAtIndex:i] forKey:@"TestTypeCode"];
        [tempDict setValue:[[TestAsseementArray valueForKey:@"TestName"] objectAtIndex:i] forKey:@"TestTypeName"];
        
        NSString *assessmentTestCode = [[TestAsseementArray valueForKey:@"TestCode"] objectAtIndex:i];
        NSString * Screenid =  [self.objDBconnection ScreenId:txtTitle.selectedCode :assessmentTestCode ];
        NSLog(@" ScreenID %@", Screenid);
        [tempDict setValue:Screenid forKey:@"ScreenID"];
        
//        [AssessmentNameArray addObject:MainDic];
        
        NSString * Screencount =  [self.objDBconnection ScreenCount :txtTitle.selectedCode :assessmentTestCode];
        
        int count = [Screencount intValue];
        
        AssessmentTypeTest = [[NSMutableArray alloc]init];
        if(count>0)
        {
            
            AssessmentTypeTest = [self.objDBconnection AssementForm :Screenid :clientCode:txtModule.selectedCode:txtTitle.selectedCode :assessmentTestCode ];
        }
        
        for(int j=0;j<AssessmentTypeTest.count;j++)
        {
            
            NSMutableDictionary * objDic = [[NSMutableDictionary alloc]init];
            
            [objDic setValue:[[AssessmentTypeTest valueForKey:@"TestTypeCode"] objectAtIndex:j] forKey:@"TestTypeCode"];
            [objDic setValue:[[AssessmentTypeTest valueForKey:@"TestTypeName"] objectAtIndex:j] forKey:@"TestTypeName"];
            [objDic setValue:Screenid forKey:@"ScreenID"];
            
            [AssessmentNameArray addObject:objDic];
            
        }
//        [ComArray addObject: AssessmentNameArray];
        [tempDict setObject:AssessmentNameArray forKey:@"TestValues"];
        [self.objContenArray addObject:tempDict];

    }
    
    [tblAssesments reloadData];
    
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.objContenArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifier = @"Header";
    AssesmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"AssesmentTableViewCell" owner:self options:nil];
    if (nil == cell)
    {
        cell = array[1];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.objContenArray objectAtIndex:section] valueForKey:@"TestValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    AssesmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"AssesmentTableViewCell" owner:self options:nil];
    if (nil == cell)
    {
        cell = array[(indexPath.row == 0 ? 1 : 2)];
    }

//    cell.textLabel.text = arrItems[indexPath.row];
    return cell;

}

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [self.objContenArray count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.objContenArray[section] count];
//}
//
//- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.objContenArray[indexPath.section][indexPath.row] count]-1;
//}
//
//- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"SKSTableViewCell";
//
//    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (!cell)
//        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//
//    NSDictionary * objDic = self.objContenArray[indexPath.section][indexPath.row][0];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", [objDic valueForKey:@"TestTypeName"]];
//    cell.textLabel.textColor =[UIColor whiteColor];
//    cell.textLabel.font = (IS_IPAD)? [UIFont fontWithName:@"Helvetica" size:15]:[UIFont fontWithName:@"Helvetica" size:13];
//    cell.expandable = YES;
////    NSInteger row = indexPath.row;
//
////    if (indexPath.section == 0 && (indexPath.row == row))
////        cell.expandable = YES;
////    else
////        cell.expandable = NO;
//    cell.backgroundColor =[UIColor colorWithRed:(17/255.0f) green:(24/255.0f) blue:(67/255.0f) alpha:0.9];
//
//    return cell;
//
////    static NSString *cellIdentifier = @"Header";
////    AssesmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
////    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"AssesmentTableViewCell" owner:self options:nil];
////
////        cell = array[1];
////
////        NSDictionary * objDic = self.objContenArray[indexPath.section][indexPath.row][0];
////        [cell.btnAssTitle setTitle:[objDic valueForKey:@"TestTypeName"] forState:normal];
////        cell.btnAssTitle.tag = indexPath.row;
////        [cell.btnAssTitle addTarget:self action:@selector(AssmentHeaderHeight:) forControlEvents:UIControlEventTouchUpInside];
////
////    return cell;
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    static NSString *CellIdentifier = @"UITableViewCell";
////
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////
////    if (!cell)
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
////
////    NSDictionary * objStr = self.objContenArray [indexPath.section][indexPath.row][indexPath.subRow];
////
////
////    cell.textLabel.text = [NSString stringWithFormat:@"%@",[objStr valueForKey:@"TestTypeName"]] ;//[NSString stringWithFormat:@"%@", self.objContenArray [indexPath.section][indexPath.row][indexPath.subRow]];
////    cell.backgroundColor =[UIColor clearColor];
////    cell.textLabel.textColor =[UIColor blackColor];
////    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size: (IS_IPAD ? 15 : 14)]];
////    return cell;
//
//    static NSString *cellIdentifier = @"Cell";
//    AssesmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"AssesmentTableViewCell" owner:self options:nil];
//    if (indexPath.row == 0 && indexPath.section == 0) {
//        cell = array[2];
//    }
//    else
//    {
//        cell = array[3];
//    }
//
//    NSDictionary * objStr = self.objContenArray [indexPath.section][indexPath.row][indexPath.subRow];
//    NSLog(@"TestTypeName %@ ",[objStr valueForKey:@"TestTypeName"]);
//    //    cell.textLabel.text = [NSString stringWithFormat:@"%@",[objStr valueForKey:@"TestTypeName"]] ;
//    //    [cell.btnAssTitle setTitle:objStr[@"TestTypeName"] forState:normal];
//
//    return cell;
//
//}
//
////- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    return UITableViewAutomaticDimension;
////}
////- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
////{
////    return UITableViewAutomaticDimension;
////}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"didSelectRow");
//    //NSDictionary * objDic = self.objContenArray[indexPath.section][indexPath.row][0];
//    //self.SelectTestCodeStr = [objDic valueForKey:@"TestTypeCode"];
//    //self.SelectTestNameStr = [objDic valueForKey:@"TestTypeName"];
//    //self.SelectScreenId    =[objDic valueForKey:@"ScreenID"];
//
//
//}
//
//- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"didSelectSubRow");
//    NSDictionary * objTitleDic = self.objContenArray[indexPath.section][indexPath.row][0];
//    NSDictionary * objDic  = self.objContenArray[indexPath.section][indexPath.row][indexPath.subRow];
//    NSString * TestTypeCode =[objDic valueForKey:@"TestTypeCode"];
//    NSMutableArray * objArray = [self.objDBconnection getAssessmentEnrtyByDateTestType:[self.SelectDetailDic valueForKey:@"AssessmentCode"] :usercode :self.ModuleCodeStr :[self.SelectDetailDic valueForKey:@"SelectDate"] :clientCode :TestTypeCode :  [objTitleDic valueForKey:@"TestTypeCode"]];
//    isEdit = NO;
//    if(objArray.count>0)
//    {
//        isEdit= YES;
//    }
//
//    //    TestAssessmentEntryVC * objAssessmentVC =[[TestAssessmentEntryVC alloc]init];
//    //    objAssessmentVC = (TestAssessmentEntryVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"TestAssessmentEntryVC"];
//    //    objAssessmentVC.selectAllValueDic =self.SelectDetailDic;
//    //    objAssessmentVC.SectionTestCodeStr = [objTitleDic valueForKey:@"TestTypeCode"];
//    //    objAssessmentVC.SelectTestStr = [objDic valueForKey:@"TestTypeName"];
//    //    objAssessmentVC.ModuleStr = self.ModuleCodeStr;
//    //    objAssessmentVC.IsEdit    =isEdit;
//    //    objAssessmentVC.SelectTestTypecode = TestTypeCode;
//    //    objAssessmentVC.SelectScreenId =[objDic valueForKey:@"ScreenID"];
//    //    [self.navigationController pushViewController:objAssessmentVC animated:YES];
//
//}

-(IBAction)openDropDown:(id)sender
{
    DropDownTableViewController* dropVC = [[DropDownTableViewController alloc] init];
    dropVC.protocol = self;
    
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
        
    }
    else
    {
        DBAConnection *Db = [[DBAConnection alloc]init];
        NSString *clientCode = [AppCommon GetClientCode];
        NSString *userCode = [AppCommon GetUsercode];
        
        dropVC.array = [Db AssessmentTestType:clientCode :userCode :txtModule.selectedCode];
        dropVC.key = @"AssessmentName";
        
    }
    CGFloat yposition = [sender superview].frame.origin.y + CGRectGetMaxY([sender frame]);
    
    dropVC.tblDropDown.frame = CGRectMake([sender frame].origin.x,yposition, 200, 200);
    dropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    dropVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [dropVC.view setBackgroundColor:[UIColor clearColor]];
    [self presentViewController:dropVC animated:YES completion:nil];
    
}


-(void)selectedValue:(NSMutableArray *)array andKey:(NSString *)key andIndex:(NSIndexPath *)Index
{
    if([key isEqualToString:@"AssessmentName"])
    {
        txtTitle.text = [[array objectAtIndex:Index.row] valueForKey:key];
        txtTitle.selectedCode = [[array objectAtIndex:Index.row] valueForKey:@"AssessmentCode"];
        [self tableValuesMethod];
    }
    else
    {
        txtModule.text = [[array objectAtIndex:Index.row] valueForKey:key];
        txtModule.selectedCode = [[array objectAtIndex:Index.row] valueForKey:@"ModuleCode"];
        
    }
    
    
}

@end
