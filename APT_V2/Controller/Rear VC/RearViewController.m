//
//  RearViewController.m
//  APT_V2
//
//  Created by user on 03/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "RearViewController.h"
#import "Header.h"
#import "InjuryVC.h"
#import "SchResStandVC.h"
#import "TabHomeVC.h"
#import "MyStatsBattingVC.h"
#import "MatchCenterTBC.h"
#import "TrainingLoadUpdateVC.h"
#import "FoodDiaryVC.h"
#import "ReportsVC.h"
#import "PlannerVC.h"
#import "RearTableViewCell.h"
#import "ChangePasswordVC.h"
#import "LandingViewController.h"
#import "VideoGalleryVC.h"
#import "DocumentViewController.h"
#import "TeamsReportsHistoryVC.h"
#import "NewVideoDocumentVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RearViewController ()<passwordChangedNotification>
{
    NSIndexPath* PreviouslySelectedIndex;
}

@end

@implementation RearViewController
@synthesize arrItems,userImageView,lblimgBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    PreviouslySelectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];

//    userImageView.layer.cornerRadius = userImageView.frame.size.height/2;
//    userImageView.layer.masksToBounds = YES;
    
    UIBezierPath* imgCorner = [UIBezierPath bezierPathWithRoundedRect:lblimgBackground.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:userImageView.frame.size];
    CAShapeLayer* imgLayer = [[CAShapeLayer alloc] init];
    imgLayer.frame = userImageView.bounds;
    imgLayer.path = imgCorner.CGPath;
    userImageView.layer.mask = imgLayer;
    userImageView.layer.masksToBounds = YES;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lblimgBackground.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:lblimgBackground.frame.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = lblimgBackground.bounds;
    maskLayer.path  = maskPath.CGPath;
    lblimgBackground.layer.mask = maskLayer;
    lblimgBackground.layer.masksToBounds = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    if([AppCommon isCoach])
    {
        arrItems = @[@{@"name":@"Home",@"img":@"Home"},
                     @{@"name":@"Planner",@"img":@"Planner"},
                     @{@"name":@"Teams",@"img":@"Team"},
                     @{@"name":@"Cricket Center",@"img":@"Match centre"},
                     @{@"name":@"Videos",@"img":@"Video"},
                     @{@"name":@"Documents",@"img":@"Document"},
                     @{@"name":@"Sync",@"img":@"Sync"},
                     @{@"name":@"Change Password",@"img":@"Change Password"},
                     @{@"name":@"Logout",@"img":@"Logout"}];
    }
    else
    {
        arrItems = @[@{@"name":@"Home",@"img":@"Home"},
                     @{@"name":@"Planner",@"img":@"Planner"},
                     @{@"name":@"History",@"img":@"History"},
                     @{@"name":@"Cricket Center",@"img":@"Match centre"},
                     @{@"name":@"Videos",@"img":@"Video"},
                     @{@"name":@"Documents",@"img":@"Document"},
                    // @{@"name":@"Food Diary",@"img":@"APT_Food Dairy"},
                     @{@"name":@"Change Password",@"img":@"Change Password"},
                     @{@"name":@"Logout",@"img":@"Logout"}];
    }
    
    [self.RearTableView reloadData];
    self.lblName.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserName"];
    
//    PhotoPath
    NSURL* url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults]stringForKey:@"PhotoPath"]];
    [userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Default_userimage"]];
    

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
#pragma mark - UITableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (IS_IPAD ? 60.0 : 50.0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    RearTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arrCell;
    if (!cell)
    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        arrCell = [[NSBundle mainBundle] loadNibNamed:@"RearTableViewCell" owner:self options:nil];
    }
    
    cell = arrCell[0];

    cell.lblName.text = [[arrItems objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.img.image = [UIImage imageNamed:[[arrItems objectAtIndex:indexPath.row] valueForKey:@"img"]];
    
    if (indexPath == PreviouslySelectedIndex) {
        cell.lblName.textColor = [UIColor colorWithRed:(37.0/255.0) green:(176.0/255.0) blue:(240.0/255.0) alpha:1.0];
        [cell.lblName setFont:[UIFont fontWithName:@"Montserrat-SemiBold" size:(IS_IPAD ? 19 : 17)]];
    }
    else{
        cell.lblName.textColor = [UIColor lightGrayColor];
        [cell.lblName setFont:[UIFont fontWithName:@"Montserrat-light" size:(IS_IPAD ? 17 : 15)]];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
    //Old-Code
/*
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = arrItems[indexPath.row];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    return cell;
    
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == PreviouslySelectedIndex) {
        return;
    }
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = appDel.revealViewController;
    UIViewController* newFrontController;
    
    
    if([AppCommon isCoach])
    {
        if(indexPath.row == 0){
            
            newFrontController= [LandingViewController new];
        }
        else if(indexPath.row == 1){
            
            newFrontController= [PlannerVC new];
        }
        else if(indexPath.row == 2){
            
            newFrontController= [TeamsVC new];
        }
        else if(indexPath.row == 3){
            
            newFrontController= [MatchCenterTBC new];
        }
        else if(indexPath.row == 4){
            
            newFrontController= [VideoGalleryVC new];
        }
        else if(indexPath.row == 5){
            
//            newFrontController= [DocumentViewController new];
            newFrontController= [NewVideoDocumentVC new];
        }
        else if(indexPath.row == 6){
            
            DBMANAGERSYNC * objCaptransactions = [DBMANAGERSYNC sharedManager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = [objCaptransactions AssessmentEntrySyncBackground];
            NSMutableArray *reqList = [[NSMutableArray alloc]init];
            reqList = [dic valueForKey:@"LstAssessmententry"];
            [self synDataMethod];
        }
        else if(indexPath.row == 7){
            
            newFrontController= [ChangePasswordVC new];
            ChangePasswordVC* vc = newFrontController;
            vc.passwordDelegate = self;
        }

        else if (indexPath.row == arrItems.count -1){
            
            [self actionLogOut];
        }
    }
    else
    {
        if(indexPath.row == 0){
            
            newFrontController= [LandingViewController new];
        }
        else if(indexPath.row == 1){
            
            newFrontController= [PlannerVC new];
        }
        else if(indexPath.row == 2){
            
            newFrontController= [TeamsReportsHistoryVC new];
            TeamsReportsHistoryVC* VC = newFrontController;
            VC.isBackBtnEnable = NO;
        }
        else if(indexPath.row == 3){
            
            newFrontController= [MatchCenterTBC new];
        }
        else if(indexPath.row == 4){
            
            newFrontController= [VideoGalleryVC new];
        }
        else if(indexPath.row == 5){
            
//            newFrontController= [DocumentViewController new];
            newFrontController= [NewVideoDocumentVC new];
        }
//        else if(indexPath.row == 6){
//
//            newFrontController= [FoodDiaryVC new];
//        }
        else if(indexPath.row == 6){
            
            newFrontController= [ChangePasswordVC new];
            ChangePasswordVC* vc = newFrontController;
            vc.passwordDelegate = self;
        }
        else if (indexPath.row == arrItems.count -1){
            
            [self actionLogOut];
            
        }
    }

    
    
    
    if (newFrontController == nil) {
        return;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [navigationController setNavigationBarHidden:YES];
    appDel.frontNavigationController = navigationController;
    [revealController pushFrontViewController:navigationController animated:YES];
    PreviouslySelectedIndex = indexPath;
    
}


-(void)notifyPasswordChanged{
    NSLog(@"notifyPasswordChanged called");
    PreviouslySelectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];

}

-(void)actionLogOut
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:APP_NAME message:@"Are you sure, you want to Logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionNo = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* actionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        PreviouslySelectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];

        arrItems=[NSArray new];
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        UIViewController* newFrontController= [LoginVC new];

        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
        appDel.frontNavigationController = navigationController;
        [navigationController setNavigationBarHidden:YES];
        [appDel.revealViewController pushFrontViewController:navigationController animated:YES];
        
        NSArray* tblName = @[@"ASSESSMENT",@"ASSESSMENTENTRY",@"ASSESSMENTENTRYACTIONPLAN",@"ASSESSMENTENTRYKEYFINDINGS",@"ASSESSMENTREGISTER",@"ASSESSMENTTESTMASTER",@"ASSOCIATIONGAMEMASTER",@"ASSOCIATIONMASTER",@"ASSOCIATIONMEMBERQUALIFICATIONS",@"ASSOCIATIONMEMBERREGISTRATION",@"ATHLETEINFO",@"ATHLETEINFODETAILS",@"ATHLETEINFOGAME",@"ATHLETEINFOTEAM",@"CLIENTGAMES",@"CLIENTMASTER",@"CLIENTMODULES",@"DASHBOARD",@"DASHBOARDMETADATA",@"DASHBOARDWIDGETS",@"DOCUMENT",@"DOCUMENTNOTIFICATION",@"DOCUMENTSETTING",@"DOCUMENTTEMPLATE",@"EVENTPARTICIPANTSDETAILS",@"EVENTTEMPLATEDETAILS",@"EVENTTEMPLATEPARTICIPANTSDETAILS",@"EXERCISEMASTER",@"EXERCISEPARAMETER",@"GAMEATTRIBUTEMETADATA",@"ILLNESSDETAILS",@"INJURYDETAILS",@"LOGINDETAILS",@"MEDICALSURGERY",@"MEDICATION",@"METADATA",@""];
            }];
    
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [appDel.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

-(void)synDataMethod
{
    if(![COMMON isInternetReachable])
        return;
        
        [AppCommon showLoading];

        NSString *URLString =  URL_FOR_RESOURCE(synData);

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        NSString * cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(cliendcode)   [dic    setObject:cliendcode     forKey:@"Clientcode"];
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            DBMANAGERSYNC *Dbm = [DBMANAGERSYNC sharedManager];

            if(responseObject >0)
            {
                NSMutableArray * lstAssessment =[[NSMutableArray alloc]init];
                NSMutableArray *  lstSession  =[[NSMutableArray alloc]init];
                NSMutableArray *  lstROM =[[NSMutableArray alloc]init];
                NSMutableArray * lstSpecial =[[NSMutableArray alloc]init];
                NSMutableArray * lstmmt     =[[NSMutableArray alloc]init];
                NSMutableArray * lstGaint  =[[NSMutableArray alloc]init];
                NSMutableArray * lstPosture =[[NSMutableArray alloc]init];
                NSMutableArray * lstsandc   =[[NSMutableArray alloc]init];
                NSMutableArray * lstCoaching =[[NSMutableArray alloc]init];
                NSMutableArray * lstMetaData  =[[NSMutableArray alloc]init];
                NSMutableArray * lstAtheletInfo =[[NSMutableArray alloc]init];
                NSMutableArray * lstAssessmentreg =[[NSMutableArray alloc]init];
                NSMutableArray * lstAtheletememberReg =[[NSMutableArray alloc]init];
                NSMutableArray * lstAtheleteinfoteam =[[NSMutableArray alloc]init];
                NSMutableArray * lstSupportStaffteam =[[NSMutableArray alloc]init];
                NSMutableArray * lstRoledetail =[[NSMutableArray alloc]init];
                NSMutableArray * AssessmentEntry =[[NSMutableArray alloc]init];
                NSMutableArray * lstatheleteinfodetaul =[[NSMutableArray alloc]init];
                NSMutableArray * lstgameattributemetadata =[[NSMutableArray alloc]init];
                NSMutableArray * lstTestcGoal =[[NSMutableArray alloc]init];
                NSMutableArray * LstUserrolemap =[[NSMutableArray alloc]init];
                NSMutableArray * LstUserdetail =[[NSMutableArray alloc]init];
                NSMutableArray * lstTeamListArray = [[NSMutableArray alloc]init];
                NSMutableArray * lstSupportStaff = [[NSMutableArray alloc]init];
                NSMutableArray * lstAssementEntryArray = [[NSMutableArray alloc]init];
                
                if (![[AppCommon checkNull:[responseObject valueForKey:@"LstAssessment"]] isKindOfClass:[NSString class]]) {
                    lstAssessment = [responseObject valueForKey:@"LstAssessment"];
                }
                
//                lstAssessment = [responseObject valueForKey:@"LstAssessment"];
                lstSession =[responseObject valueForKey:@"LstSession"];
                lstROM =[responseObject valueForKey:@"LstROM"];
                lstSpecial =[responseObject valueForKey:@"Lstspecial"];
                lstmmt =[responseObject valueForKey:@"LstMmt"];
                lstGaint =[responseObject valueForKey:@"LstGaint"];
                lstPosture =[responseObject valueForKey:@"LstPosture"];
                lstsandc =[responseObject valueForKey:@"LstSandC"];
                lstCoaching =[responseObject valueForKey:@"LstCoaching"];
                lstMetaData =[responseObject valueForKey:@"LstMetadata"];
                lstAtheletInfo =[responseObject valueForKey:@"LstAtheleteinfo"];
                lstAssessmentreg =[responseObject valueForKey:@"LstAssessmentreg"];
                lstAtheletememberReg =[responseObject valueForKey:@"LstAtheletememberrag"];
                lstAtheleteinfoteam =[responseObject valueForKey:@"LstAtheleteinfoteam"];
                lstSupportStaffteam =[responseObject valueForKey:@"LstSupportstaffteams"];
                lstRoledetail =[responseObject valueForKey:@"LstRoledetails"];
                LstUserdetail =[responseObject valueForKey:@"LstUserdetails"];
                
                LstUserrolemap =[responseObject valueForKey:@"LstUserrolemap"];
                
                if (![[AppCommon checkNull:[responseObject valueForKey:@"LstAssessmententry"]] isKindOfClass:[NSString class]]) {
                    AssessmentEntry =[responseObject valueForKey:@"LstAssessmententry"];
                }

                lstatheleteinfodetaul =[responseObject valueForKey:@"LstAthleteinfodetails"];
                lstgameattributemetadata =[responseObject valueForKey:@"LstGameattributemetadata"];
                lstTestcGoal =[responseObject valueForKey:@"LstTestscgoal"];
                lstTeamListArray = [responseObject valueForKey:@"LstTeam"];
                lstSupportStaff = [responseObject valueForKey:@"LstSupportStaff"];
                
                lstAssementEntryArray = [responseObject valueForKey:@"LstAssessmententryCurrDate"];
                
                for(int i= 0;i<lstAssessment.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstAssessment objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Modulecode =[arr1 valueForKey:@"Modulecode"];
                    NSString * Assessmentcode =[arr1 valueForKey:@"Assessmentcode"];
                    NSString * Assessmentname =[arr1 valueForKey:@"Assessmentname"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    NSMutableArray *AssemntValues = [[NSMutableArray alloc] initWithObjects:Clientcode,Modulecode,Assessmentcode,Assessmentname,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    
                    Dbm.Assmnt = AssemntValues;
                    [Dbm SELECTASSESSMENT:Assessmentcode];
                }
                
                
                for(int i= 0;i<lstSession.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstSession objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Modulecode =[arr1 valueForKey:@"Modulecode"];
                    NSString * Assessmentcode =[arr1 valueForKey:@"Assessmentcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Testname =[arr1 valueForKey:@"Testname"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Modulecode,Assessmentcode,Testcode,Testname,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    
                    Dbm.AssmntTestMaster = Values;
                    [Dbm SELECTASSESSMENTTESTMASTER:Testcode];

//                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//                        [Dbm SELECTASSESSMENTTESTMASTER:Testcode];
//                        dispatch_async(dispatch_get_main_queue(), ^(void){
//                            //Run UI Updates
//                        });
//                    });
                    
                }
                
                for(int i= 0;i<lstROM.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstROM objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Joint =[arr1 valueForKey:@"Joint"];
                    NSString * Movement =[arr1 valueForKey:@"Movement"];
                    NSString * Side =[arr1 valueForKey:@"Side"];
                    NSString * Minimumrange =[arr1 valueForKey:@"Minimumrange"];
                    NSString * Maximumrange =[arr1 valueForKey:@"Maximumrange"];
                    NSString * Unit =[arr1 valueForKey:@"Unit"];
                    NSString * Inputtype =[arr1 valueForKey:@"Inputtype"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,Joint,Movement,Side,Minimumrange,Maximumrange,Unit,Inputtype,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.RangeOfMotion = Values;
                    [Dbm SELECTRANGEOFMOTION:Testcode];
                    
                }
                
                
                for(int i= 0;i<lstSpecial.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstSpecial objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Region =[arr1 valueForKey:@"Region"];
                    NSString * Testname =[arr1 valueForKey:@"Testname"];
                    NSString * Side =[arr1 valueForKey:@"Side"];
                    NSString * Result =[arr1 valueForKey:@"Result"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,Region,Testname,Side,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.TestSplArray = Values;
                    [Dbm TESTSPECIAL:Testcode];
                    
                }
                
                for(int i= 0;i<lstmmt.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstmmt objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Joint =[arr1 valueForKey:@"Joint"];
                    NSString * Motion =[arr1 valueForKey:@"Motion"];
                    NSString * Muscle =[arr1 valueForKey:@"Muscle"];
                    NSString * Side =[arr1 valueForKey:@"Side"];
                    NSString * Result =[arr1 valueForKey:@"Result"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,Joint,Motion,Muscle,Side,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.Testmmt = Values;
                    [Dbm TESTmmt:Testcode];
                    
                }
                
                for(int i= 0;i<lstGaint.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstGaint objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Plane =[arr1 valueForKey:@"Plane"];
                    NSString * Testname =[arr1 valueForKey:@"Testname"];
                    NSString * Side =[arr1 valueForKey:@"Side"];
                    NSString * Units =[arr1 valueForKey:@"Units"];
                    NSString * Result =[arr1 valueForKey:@"Result"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,Plane,Testname,Side,Units,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.TestgaintArray = Values;
                    [Dbm SELECTTESTGAINT:Testcode];
                    
                }
                
                
                for(int i= 0;i<lstPosture.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstPosture objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * View =[arr1 valueForKey:@"View"];
                    NSString * Region =[arr1 valueForKey:@"Region"];
                    NSString * Side =[arr1 valueForKey:@"Side"];
                    NSString * Units =[arr1 valueForKey:@"Units"];
                    NSString * Result =[arr1 valueForKey:@"Result"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,View,Region,Side,Units,Result,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.TestpostureArray = Values;
                    [Dbm SELECTTESTPosture:Testcode];
                    
                }
                
                for(int i= 0;i<lstsandc.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstsandc objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Component =[arr1 valueForKey:@"Component"];
                    NSString * Testname =[arr1 valueForKey:@"Testname"];
                    NSString * Side =[arr1 valueForKey:@"Side"];
                    NSString * Nooftrials =[arr1 valueForKey:@"Nooftrials"];
                    NSString * Units =[arr1 valueForKey:@"Units"];
                    NSString * Scoreevaluation =[arr1 valueForKey:@"Scoreevaluation"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,Component,Testname,Side,Nooftrials,Units,Scoreevaluation,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.TestSCArray = Values;
                    [Dbm SELECTTESTSC:Testcode];
                    
                }
                
                
                
                for(int i= 0;i<lstCoaching.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstCoaching objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Kpi =[arr1 valueForKey:@"Kpi"];
                    NSString * Description =[arr1 valueForKey:@"Description"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Testcode,Kpi,Description,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.TestCoachArray = Values;
                    [Dbm SELECTTESTCoaching:Testcode];
                    
                }
                
                
                for(int i= 0;i<lstMetaData.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstMetaData objectAtIndex:i];
                    
                    NSString * Metasubcode =[arr1 valueForKey:@"Metasubcode"];
                    NSString * Metadatatypecode =[arr1 valueForKey:@"Metadatatypecode"];
                    NSString * Metadatatypedescription =[arr1 valueForKey:@"Metadatatypedescription"];
                    NSString * Metasubcodedescription =[arr1 valueForKey:@"Metasubcodedescription"];
                    NSString * Metasubcodevalue =[arr1 valueForKey:@"Metasubcodevalue"];
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Metasubcode,Metadatatypecode,Metadatatypedescription,Metasubcodedescription,Metasubcodevalue, nil];
                    
                    Dbm.metadataArray = Values;
                    [Dbm SELECTmetadata:Metasubcode];
                    
                }
                
                for(int i= 0;i<lstAtheletInfo.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstAtheletInfo objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Athletecode =[arr1 valueForKey:@"Athletecode"];
                    NSString * Height =[arr1 valueForKey:@"Height"];
                    NSString * Weight =[arr1 valueForKey:@"Weight"];
                    NSString * Allergies =[arr1 valueForKey:@"Allergies"];
                    NSString * Orthotics =[arr1 valueForKey:@"Orthotics"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Athletecode,Height,Weight,Allergies,Orthotics,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.SportsInfoArray = Values;
                    [Dbm SELECTSportsInfo:Athletecode];
                    
                }
                
                for(int i= 0;i<lstAssessmentreg.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstAssessmentreg objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Assessmentregistercode =[arr1 valueForKey:@"Assessmentregistercode"];
                    NSString * Modulecode =[arr1 valueForKey:@"Modulecode"];
                    NSString * Assessmentcode =[arr1 valueForKey:@"Assessmentcode"];
                    NSString * Assessmenttesttypescreencode =[arr1 valueForKey:@"Assessmenttesttypescreencode"];
                    NSString * Assessmenttestcode =[arr1 valueForKey:@"Assessmenttestcode"];
                    NSString * Assessmenttesttypecode =[arr1 valueForKey:@"Assessmenttesttypecode"];
                    NSString * Version =[arr1 valueForKey:@"Version"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Assessmentregistercode,Modulecode,Assessmentcode,Assessmenttesttypescreencode,Assessmenttestcode,Assessmenttesttypecode,Version,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.AssessmentRegisterArray = Values;
                    [Dbm SELECTAssementRegister:Assessmentregistercode];
                    
                }
                
                
                for(int i= 0;i<lstAtheletememberReg.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstAtheletememberReg objectAtIndex:i];
                    
                    
                    NSString * Associationmemberid =[arr1 valueForKey:@"Associationmemberid"];
                    
                    //NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Assessmentregistercode,Modulecode,Assessmentcode,Assessmenttesttypescreencode,Assessmenttestcode,Assessmenttesttypecode,Version,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.AtheleteMemRegArray = arr1;
                    [Dbm SELECTAtheleteMemReg:Associationmemberid];
                    
                }
                
                
                
                for(int i= 0;i<lstAtheleteinfoteam.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstAtheleteinfoteam objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Athletecode =[arr1 valueForKey:@"Athletecode"];
                    NSString * Teamcode =[arr1 valueForKey:@"Teamcode"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Athletecode,Teamcode,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.AtheleteInfoTeamArray = Values;
                    [Dbm SELECTAtheleteInfoTeam:Athletecode];
                    
                }
                
                
                for(int i= 0;i<lstSupportStaffteam.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstSupportStaffteam objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Code =[arr1 valueForKey:@"Code"];
                    NSString * Teamcode =[arr1 valueForKey:@"Teamcode"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Code,Teamcode,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    Dbm.SupportStaffInfoArray = Values;
                    [Dbm SELECTSupportStaffInfo:Code:Teamcode];
                    
                }
                
                for(int i= 0;i<lstRoledetail.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstRoledetail objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Rolecode =[arr1 valueForKey:@"Rolecode"];
                    NSString * Role =[arr1 valueForKey:@"Role"];
                    NSString * Ischecked =[arr1 valueForKey:@"Ischecked"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Rolecode,Role,Ischecked,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    Dbm.RoleDetailsArray = Values;
                    [Dbm SELECTRoleDetails:Rolecode];
                    
                }
                
                
                for(int i= 0;i<LstUserdetail.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [LstUserdetail objectAtIndex:i];
                    
                    
                    NSString * Usercode =[arr1 valueForKey:@"Usercode"];
                    
                    //NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Assessmentregistercode,Modulecode,Assessmentcode,Assessmenttesttypescreencode,Assessmenttestcode,Assessmenttesttypecode,Version,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    
                    Dbm.UserDetailsArray = arr1;
                    [Dbm SELECTUserDetails:Usercode];
                    
                }
                
                for(int i= 0;i<LstUserrolemap.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [LstUserrolemap objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Usercode =[arr1 valueForKey:@"Usercode"];
                    NSString * Rolecode =[arr1 valueForKey:@"Rolecode"];
                    NSString * Isdefaultrole =[arr1 valueForKey:@"Isdefaultrole"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Usercode,Rolecode,Isdefaultrole,Recordstatus,Createdby,Createddate,Modifiedby,Modifieddate, nil];
                    Dbm.UserRolemapArray = Values;
                    [Dbm SELECTUserRoleMap:Usercode:Rolecode];
                    
                }
                
                
                [Dbm DleteAthleteinfodetails];
                
                for(int i= 0;i<lstatheleteinfodetaul.count;i++)
                {
                    
                    
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstatheleteinfodetaul objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Athletecode =[arr1 valueForKey:@"Athletecode"];
                    NSString * Gamecode =[arr1 valueForKey:@"Gamecode"];
                    NSString * Teamcode =[arr1 valueForKey:@"Teamcode"];
                    NSString * Attributevaluecode =[arr1 valueForKey:@"Attributevaluecode"];
                    NSString * Attributevaluedescription =[arr1 valueForKey:@"Attributevaluedescription"];
                    NSString * Inputtype =[arr1 valueForKey:@"Inputtype"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    
                    
                    
                    [Dbm InsertAthleteinfodetails: Clientcode: Athletecode: Gamecode: Teamcode: Attributevaluecode: Attributevaluedescription: Inputtype: Recordstatus: Createdby: Createddate: Modifiedby: Modifieddate];
                    
                }
                
                
                
                
                [Dbm DletegameAttribute];
                for(int i= 0;i<lstgameattributemetadata.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstgameattributemetadata objectAtIndex:i];
                    
                    NSString * Attributevaluecode =[arr1 valueForKey:@"Attributevaluecode"];
                    NSString * Attributevaluedescription =[arr1 valueForKey:@"Attributevaluedescription"];
                    NSString * Gametype =[arr1 valueForKey:@"Gametype"];
                    NSString * Attributecode =[arr1 valueForKey:@"Attributecode"];
                    NSString * Attributedescription =[arr1 valueForKey:@"Attributedescription"];
                    NSString * Inputtype =[arr1 valueForKey:@"Inputtype"];
                    
                    
                    
                    [Dbm InsertgameAttribute: Attributevaluecode: Attributevaluedescription: Gametype: Attributecode: Attributedescription: Inputtype];
                    
                }
                
                
                
                [Dbm DleteTestGoal];
                
                for(int i= 0;i<lstTestcGoal.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstTestcGoal objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Testcode =[arr1 valueForKey:@"Testcode"];
                    NSString * Min =[arr1 valueForKey:@"Min"];
                    NSString * Max =[arr1 valueForKey:@"Max"];
                    NSString * Recordstatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * Createdby =[arr1 valueForKey:@"Createdby"];
                    NSString * Createddate =[arr1 valueForKey:@"Createddate"];
                    NSString * Modifiedby =[arr1 valueForKey:@"Modifiedby"];
                    NSString * Modifieddate =[arr1 valueForKey:@"Modifieddate"];
                    
                    [Dbm InsertTestGoal: Clientcode: Testcode: Min: Max: Recordstatus: Createdby:Createddate:Modifiedby:Modifieddate];
                    
                }
                
                for(int i= 0;i<lstTeamListArray.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstTeamListArray objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"ClientCode"];
                    NSString * Teamcode =[arr1 valueForKey:@"TeamCode"];
                    NSString * TeamName =[arr1 valueForKey:@"TeamName"];
                    NSString * TeamShortName =[arr1 valueForKey:@"TeamShortName"];
                    NSString * Game =[arr1 valueForKey:@"Game"];
                    NSString * RecordStatus =[arr1 valueForKey:@"RecordStatus"];
                    NSString * CreatedBy =[arr1 valueForKey:@"CreatedBy"];
                    NSString * CreatedDate =[arr1 valueForKey:@"CreatedDate"];
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Teamcode,TeamName,TeamShortName,Game,RecordStatus,CreatedBy,CreatedDate, nil];
                    
                    Dbm.TeamListDetailArray = Values;
                    [Dbm SELECTTEAM:Teamcode];
                    
                }
                
                for(int i= 0;i<lstSupportStaff.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstSupportStaff objectAtIndex:i];
                    
                    NSString * Clientcode =[arr1 valueForKey:@"Clientcode"];
                    NSString * Membercode =[arr1 valueForKey:@"MemberCode"];
                    NSString * StaffType =[arr1 valueForKey:@"StaffType"];
                    NSString * level =[arr1 valueForKey:@"Levels"];
                    NSString * recordStatus =[arr1 valueForKey:@"Recordstatus"];
                    NSString * CreateBy =[arr1 valueForKey:@"Createdby"];
                    NSString * CreatedDate =[arr1 valueForKey:@"Createddate"];
                    NSString * ModifiedBy =[arr1 valueForKey:@"Modifiedby"];
                    NSString * ModifiedDate =[arr1 valueForKey:@"Modifieddate"];
                    
                    NSMutableArray *Values = [[NSMutableArray alloc] initWithObjects:Clientcode,Membercode,StaffType,level,recordStatus,CreateBy,CreatedDate,ModifiedBy,ModifiedDate, nil];
                    
                    Dbm.SupportStaffArray = Values;
                    [Dbm SELECTSupportStaff:Membercode];
                    
                }
                
                for(int i= 0;i<lstAssementEntryArray.count;i++)
                {
                    
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    arr1 = [lstAssementEntryArray objectAtIndex:i];
                    
                    NSString * entrycode =[arr1 valueForKey:@"Assessmententrycode"];
                    
                    Dbm.AssessmentEntyArray = arr1;
                    [Dbm SELECTAssementEntry:entrycode];
                    
                }
                [AppCommon showAlertWithMessage:@"Sync Successful"];
                
            }
            
            [AppCommon hideLoading];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [COMMON webServiceFailureError:error];
            [AppCommon showAlertWithMessage:@"Sync Failed"];
            [AppCommon hideLoading];
        }];
    
}



@end

