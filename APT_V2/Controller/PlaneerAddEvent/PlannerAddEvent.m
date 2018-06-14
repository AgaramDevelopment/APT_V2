//
//  PlannerAddEvent.m
//  AlphaProTracker
//
//  Created by Mac on 28/08/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import "PlannerAddEvent.h"
#import "CustomNavigation.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "AddParticipantCell.h"
#import "PlannerVC.h"
#import "CRTableViewCell.h"
//#import "HomeVC.h"

@interface PlannerAddEvent ()
{
    BOOL isEventType;
    BOOL isEventStatus;
    BOOL isParticipantType;
    BOOL isteam;
    BOOL isParticipant;
    
    BOOL isaddPartcipant;
    
    BOOL isStartDate;
    BOOL isStartTime;
    
    BOOL isDate;
    BOOL isTime;
    
    
    NSString * usercode;
    NSString * cliendcode;
    NSString * selectParticipantType;
    NSString * selectTeam;
    NSString * selectParticipantCode;
    NSString * selectEventTypeCode;
    NSString * selectEventStatusCode;
    UIDatePicker *datePicker;
    
    
    NSMutableArray *selectedMarks;

}

@property (nonatomic,strong) IBOutlet UIView * eventnameView;
@property (nonatomic,strong) IBOutlet UIView * startdateView;
@property (nonatomic,strong) IBOutlet UIView * enddateView;
@property (nonatomic,strong) IBOutlet UIView * startTimeView;
@property (nonatomic,strong) IBOutlet UIView * endTimeView;
@property (nonatomic,strong) IBOutlet UIView * eventTypeView;
@property (nonatomic,strong) IBOutlet UIView * eventStatusView;
@property (nonatomic,strong) IBOutlet UIView * commentView;
@property (nonatomic,strong) IBOutlet UIView * particiTypeView;
@property (nonatomic,strong) IBOutlet UIView * teamView;
@property (nonatomic,strong) IBOutlet UIView * particiView;
@property (nonatomic,strong) IBOutlet UIView * MainEventview;
@property (nonatomic,strong) IBOutlet UIView * mainEventStatusview;
@property (nonatomic,strong) IBOutlet UIView * mainParticipantTypeView;
@property (nonatomic,strong) IBOutlet UIView * mainteamView;
@property (nonatomic,strong) IBOutlet UIView * mainParticipantview;

@property (nonatomic,strong) IBOutlet UITextField * eventnameTxt;
@property (nonatomic,strong) IBOutlet UILabel * startdateLbl;
@property (nonatomic,strong) IBOutlet UILabel * enddateLbl;
@property (nonatomic,strong) IBOutlet UILabel * startTimeLbl;
@property (nonatomic,strong) IBOutlet UILabel * endTimeLbl;
@property (nonatomic,strong) IBOutlet UILabel * eventTypeLbl;
@property (nonatomic,strong) IBOutlet UILabel * eventStatusLbl;
@property (nonatomic,strong) IBOutlet UITextField * commentTxt;
@property (nonatomic,strong) IBOutlet UILabel * particiTypeLbl;
@property (nonatomic,strong) IBOutlet UILabel * teamLbl;
@property (nonatomic,strong) IBOutlet UILabel * particiLbl;

@property (nonatomic,strong) IBOutlet UITableView * participantTbl;

@property (nonatomic,strong) IBOutlet UIScrollView * commonScrollview;



//@property (nonatomic,strong) IBOutlet UIView * participantAddView;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * addeventTblheight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popTblheight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * mainParticipantViewheight;


@property (nonatomic,strong) NSMutableArray * participantsArray;

@property (nonatomic,strong) NSMutableArray * TeamDetailArray;

@property (nonatomic,strong) NSMutableArray * eventStatusArray;

@property (nonatomic,strong) NSMutableArray * eventTypeDetailArray;

@property (nonatomic,strong) NSMutableArray * commonArray;

@property (nonatomic,strong) NSMutableArray * addParticipantArray;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popviewYposition;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popviewXposition;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * popviewWidth;

@property (nonatomic,strong) IBOutlet UITableView * popviewTbl;

@property (nonatomic,strong) IBOutlet UIButton * updateBtn;

@property (nonatomic,strong) IBOutlet UIButton * deleteBtn;
@property (nonatomic,strong) IBOutlet UIButton * AddParticipantBtn;

@property (nonatomic,strong) IBOutlet UIButton * saveBtn;

@property (nonatomic,strong) IBOutlet UIView * comPopview;

@property (nonatomic,strong) IBOutlet UIButton * okBtn;

@property (nonatomic,strong) IBOutlet UIButton * ClearAllBtn;

@property (nonatomic,strong) IBOutlet UIButton * selectAllBtn;

@property (nonatomic,strong) IBOutlet UITableView * multselectTbl;

@end

@implementation PlannerAddEvent

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBorderwithView];
    
    self.popviewTbl.hidden=YES;
    self.updateBtn.hidden=YES;
    self.deleteBtn.hidden =YES;
    self.saveBtn.hidden =NO;
    
    selectedMarks=[[NSMutableArray alloc]init];
    
    if(_isEdit == YES)
    {
        
        
        if([_isNotification isEqualToString:@"yes"])
        {
            if([AppCommon isCoach])
            {
                self.updateBtn.hidden=NO;
                self.deleteBtn.hidden =NO;
                self.saveBtn.hidden =YES;
                self.AddParticipantBtn.hidden =NO;
            }
            else
            {
                
                self.updateBtn.hidden=YES;
                self.deleteBtn.hidden =YES;
                self.saveBtn.hidden =YES;
                self.AddParticipantBtn.hidden =YES;
            }
            
            
            [self editFetchWebservice:self.eventType :@"0" :@"false"];
            
        }
        else
        {
            if([AppCommon isCoach])
            {
                self.updateBtn.hidden=NO;
                self.deleteBtn.hidden =NO;
                self.saveBtn.hidden =YES;
                self.AddParticipantBtn.hidden =NO;
            }
            else
            {
                self.updateBtn.hidden=YES;
                self.deleteBtn.hidden =YES;
                self.saveBtn.hidden =YES;
                self.AddParticipantBtn.hidden =YES;
            }
            
        [self editFetchWebservice:[self.objSelectEditDic valueForKey:@"id"] :@"0" :@"false"];
        }
    }
    else
    {
        if([AppCommon isCoach])
        {
            self.startdateLbl.text =self.selectDateStr;
            self.enddateLbl.text =self.selectDateStr;
        }
        else
            {
            self.updateBtn.hidden=YES;
            self.deleteBtn.hidden =YES;
            self.saveBtn.hidden =YES;
            self.AddParticipantBtn.hidden =YES;
            }
            
    }
    self.view_datepicker.hidden=YES;
    self.comPopview.hidden =YES;
    
    usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self customnavigationmethod];
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
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        [objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navi_View addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == self.eventnameTxt)
    {
   
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength>25)
        {
            [AppCommon showAlertWithMessage:@"Maximum length should be 25 only"];
        }
    return newLength <= 25;
    }
    else if(textField == self.commentTxt)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength>50)
        {
            [AppCommon showAlertWithMessage:@"Maximum length should be 50 only"];
        }
        return newLength <= 50;
    }
    return nil;
}
-(void)setBorderwithView
{
    self.eventnameView.layer.borderWidth=0.5;
    self.eventnameView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.startdateView.layer.borderWidth=0.5;
    self.startdateView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.startTimeView.layer.borderWidth=0.5;
    self.startTimeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.enddateView.layer.borderWidth=0.5;
    self.enddateView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.endTimeView.layer.borderWidth=0.5;
    self.endTimeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.eventTypeView.layer.borderWidth=0.5;
    self.eventTypeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.eventStatusView.layer.borderWidth=0.5;
    self.eventStatusView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.commentView.layer.borderWidth=0.5;
    self.commentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.particiTypeView.layer.borderWidth=0.5;
    self.particiTypeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.teamView.layer.borderWidth=0.5;
    self.teamView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.particiView.layer.borderWidth=0.5;
    self.particiView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
}

#pragma All Button Action

-(IBAction)didClickSaveBtn:(id)sender
{
    if([self.eventnameTxt.text isEqualToString:@"Select"] || [self.eventnameTxt.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EventName"];
    }
    else if ([self.startdateLbl.text isEqualToString:@"Select"] || [self.startdateLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter StartDate"];
    }
    else if ([self.enddateLbl.text isEqualToString:@"Select"] || [self.enddateLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EndDate"];
    }
    else if ([self.startTimeLbl.text isEqualToString:@"Select"] || [self.startTimeLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter StartTime"];
    }
    else if ([self.endTimeLbl.text isEqualToString:@"Select"] || [self.endTimeLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EndTime"];
    }
    else if ([self.eventTypeLbl.text isEqualToString:@"Select"] || [self.eventTypeLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EventType"];
    }
    else if ([self.eventStatusLbl.text isEqualToString:@"Select"] || [self.eventStatusLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EventStatus"];
    }
//    else if ([self.particiTypeLbl.text isEqualToString:@"Select"] || [self.particiTypeLbl.text isEqualToString:@""])
//    {
//        [self altermsg:@"Please Add Participant"];
//    }
//    else if ([self.teamLbl.text isEqualToString:@"Select"] || [self.teamLbl.text isEqualToString:@""])
//    {
//        [self altermsg:@"Please Add Participant"];
//    }
//    else if ([self.particiLbl.text isEqualToString:@"Select"] || [self.particiLbl.text isEqualToString:@""])
//    {
//        [self altermsg:@"Please Add Participant"];
//    }
    else if (isaddPartcipant==NO){
         [self altermsg:@"Please Add Participant"];
    }
    else
    {
        [self InserPlannerWebService];
    }
}

-(void)altermsg:(NSString *) message
{
    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Planner" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objaltert show];
}



-(IBAction)didClickStartDatepicker:(id)sender
{

    isDate=YES;
    isTime =NO;
    isStartDate =YES;
    
    [self DisplaydatePicker];
    
}
-(void)DisplaydatePicker
{
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    self.view_datepicker.hidden=NO;
    //isStartDate =YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.startdateView.frame.origin.y,self.view.frame.size.width,100)];
    datePicker.backgroundColor = [UIColor lightGrayColor];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    
   // [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.datePickerMode = UIDatePickerModeDate;

    [datePicker reloadInputViews];
    [self.view_datepicker addSubview:datePicker];
    [self.eventnameTxt resignFirstResponder];
    [self.commentTxt resignFirstResponder];

}
-(IBAction)didClickEndDate:(id)sender
{
    isDate=YES;
    isTime =NO;
    isStartDate =NO;
    [self DisplaydatePicker];
}
-(void)DisplayTime
{
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    self.view_datepicker.hidden=NO;
    //isStartDate =YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"hh:mm a"];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.startdateView.frame.origin.y,self.view.frame.size.width,100)];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    
    // [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.backgroundColor = [UIColor lightGrayColor];
    
    [datePicker reloadInputViews];
    [self.view_datepicker addSubview:datePicker];
    [self.eventnameTxt resignFirstResponder];
    [self.commentTxt resignFirstResponder];
}
-(IBAction)didClickStartTime:(id)sender
{
    isDate=NO;
    isTime =YES;
    isStartTime=YES;
    [self DisplayTime];
}
-(IBAction)didClickEndTime:(id)sender
{
    isDate=NO;
    isTime =YES;
    isStartTime=NO;
    [self DisplayTime];
}
-(IBAction)didClickcloseDate:(id)sender
{
    [self.view_datepicker setHidden:YES];
}
-(IBAction)showSelecteddate:(id)sender{
    
    if(isDate==YES)
    {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    if(isStartDate==YES)
    {
        self.startdateLbl.text=[dateFormat stringFromDate:datePicker.date];
        
        NSLog(@"%@", self.startdateLbl.text);
    }
    else
    {
        self.enddateLbl.text=[dateFormat stringFromDate:datePicker.date];
    }
    }
    else{
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDate *matchdate = [NSDate date];
        [dateFormat setDateFormat:@"hh:mm a"];
        // for minimum date
        [datePicker setMinimumDate:matchdate];
        
        // for maximumDate
        int daysToAdd = 1;
        NSDate *newDate1 = [matchdate dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        [datePicker setMaximumDate:newDate1];
        
        if(isStartTime==YES)
        {
            self.startTimeLbl.text=[dateFormat stringFromDate:datePicker.date];
        }
        else
        {
            self.endTimeLbl.text=[dateFormat stringFromDate:datePicker.date];
        }

    }
    [self.view_datepicker setHidden:YES];
    
}

-(IBAction)didClickeventType:(id)sender
{
    
    if(isEventType ==NO)
    {
        self.popviewTbl.hidden =NO;
        
        self.popviewYposition.constant =self.eventTypeView.frame.origin.y+30;
        self.popviewXposition.constant =self.eventTypeView.frame.origin.x;
        self.popviewWidth.constant =self.eventTypeView.frame.size.width;
        
        self.commonArray =[[NSMutableArray alloc]init];
//        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//        [mutableDict setObject:@"" forKey:@"EventTypeColor"];
//        [mutableDict setObject:@"" forKey:@"EventTypeCode"];
//        [mutableDict setObject:@"Select" forKey:@"EventTypename"];
//
//        [self.commonArray addObject:mutableDict];
        
        for(int i=0; self.ListeventTypeArray.count>i;i++)
        {
            NSMutableDictionary * objDic =[self.ListeventTypeArray objectAtIndex:i];
            [self.commonArray addObject:objDic];
        }
        
        
        isEventType =YES;
        isEventStatus =NO;
        isParticipant =NO;
        isParticipantType=NO;
        isteam =NO;
        isaddPartcipant=NO;
    
        [self.popviewTbl reloadData];
        
       // self.popTblheight.constant =self.popviewTbl.contentSize.height-100;
    }
    else{
        self.popviewTbl.hidden =YES;
        
        isEventType =NO;
    }
}
-(IBAction)didClickeventStatus:(id)sender
{
    if(isEventStatus == NO)
    {
        self.popviewTbl.hidden = NO;
        
        self.popviewYposition.constant =self.eventStatusView.frame.origin.y+30;
        self.popviewXposition.constant =self.eventStatusView.frame.origin.x;
        self.popviewWidth.constant =self.eventStatusView.frame.size.width;
        
        self.commonArray =[[NSMutableArray alloc]init];
        
//        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//        [mutableDict setObject:@"" forKey:@"EventStatusCode"];
//        [mutableDict setObject:@"Select" forKey:@"EventStatusname"];
//
//
//        [self.commonArray addObject:mutableDict];
        
        for(int i=0; self.ListeventStatusArray.count>i;i++)
        {
            NSMutableDictionary * objDic =[self.ListeventStatusArray objectAtIndex:i];
            [self.commonArray addObject:objDic];
        }
        
        
        //self.commonArray =self.ListeventStatusArray;
        
        isEventType =NO;
        isEventStatus =YES;
        isParticipant =NO;
        isParticipantType=NO;
        isteam =NO;
        isaddPartcipant=NO;
    
        [self.popviewTbl reloadData];
    
        //self.popTblheight.constant =self.popviewTbl.contentSize.height-100;
    }
    else{
        self.popviewTbl.hidden =YES;
        isEventStatus =NO;
    }
}
-(IBAction)didClickparticipantType:(id)sender
{
    if(isParticipantType == NO)
    {
        self.popviewTbl.hidden=NO;
        
        
        self.popviewYposition.constant =self.mainParticipantTypeView.frame.origin.y-200;
        self.popviewWidth.constant =self.particiTypeView.frame.size.width;
        self.popviewXposition.constant = self.mainParticipantTypeView.frame.origin.x+5;
        
        self.commonArray =[[NSMutableArray alloc]init];
        
//        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//        [mutableDict setObject:@"" forKey:@"ParticipantTypecode"];
//        [mutableDict setObject:@"Select" forKey:@"ParticipantTypename"];
//
//
//        [self.commonArray addObject:mutableDict];
        
        for(int i=0; self.ListparticipantTypeArray.count>i;i++)
        {
            NSMutableDictionary * objDic =[self.ListparticipantTypeArray objectAtIndex:i];
            [self.commonArray addObject:objDic];
        }
        
        
        // self.commonArray =self.ListparticipantTypeArray;
        
        isEventType =NO;
        isEventStatus =NO;
        isParticipant =NO;
        isParticipantType=YES;
        isteam =NO;
        isaddPartcipant=NO;
    
        [self.popviewTbl reloadData];
    
        //self.popTblheight.constant =self.popviewTbl.contentSize.height-100;
    }
    else{
        self.popviewTbl.hidden=YES;
        isParticipantType=NO;
    }
}
-(IBAction)didClickTeam:(id)sender
{
    if(isteam ==NO)
    {
        self.popviewTbl.hidden =NO;
        self.popviewYposition.constant =self.mainParticipantTypeView.frame.origin.y-200;
        self.popviewXposition.constant =self.teamView.frame.origin.x;
        self.popviewWidth.constant =self.teamView.frame.size.width;
        
        self.commonArray =[[NSMutableArray alloc]init];
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
        [mutableDict setObject:@"" forKey:@"Teamcode"];
        [mutableDict setObject:@"Select" forKey:@"Teamname"];
        
        
        [self.commonArray addObject:mutableDict];
        
        for(int i=0; self.TeamDetailArray.count>i;i++)
        {
            NSMutableDictionary * objDic =[self.TeamDetailArray objectAtIndex:i];
            [self.commonArray addObject:objDic];
        }
        
        
        // self.commonArray =self.TeamDetailArray;
        
        
        isEventType =NO;
        isEventStatus =NO;
        isParticipant =NO;
        isParticipantType=NO;
        isteam =YES;
        isaddPartcipant=NO;
    
        [self.popviewTbl reloadData];
    
    }
    else{
        self.popviewTbl.hidden=YES;
        isteam =NO;
    }
}
-(IBAction)didclickparticipant:(id)sender
{
    //selectedMarks =[[NSMutableArray alloc]init];
//    if(isParticipant==NO)
//    {
    
        self.popviewTbl.hidden =YES;
        //self.popviewYposition.constant =self.mainParticipantview.frame.origin.y-310;
        //self.popviewWidth.constant =self.particiView.frame.size.width;
        self.comPopview.hidden =NO;
        self.commonArray =[[NSMutableArray alloc]init];
//        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//        [mutableDict setObject:@"" forKey:@"Participantcode"];
//        [mutableDict setObject:@"Select" forKey:@"Participantname"];
//        [mutableDict setObject:@"" forKey:@"Participanttype"];
//
//
//        [self.commonArray addObject:mutableDict];
    
        for(int i=0; self.participantsArray.count>i;i++)
        {
            NSMutableDictionary * objDic =[self.participantsArray objectAtIndex:i];
            [self.commonArray addObject:objDic];
        }
        
        //selectedMarks = [[NSMutableArray alloc]init];
//        for( int i=1;i<self.commonArray.count;i++)
//        {
//            
//            selectParticipantCode =[[self.commonArray valueForKey:@"Participantcode"] objectAtIndex:i];
//           // Excode = [self.ArrayEX objectAtIndex:i];
//            
//            
//            if ([selectedMarks containsObject:selectParticipantCode])// Is selected?
//                [selectedMarks removeObject:selectParticipantCode];
//            else
//                [selectedMarks addObject:selectParticipantCode];
//        }
//        
//        
//        static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
//        CRTableViewCell *cell = (CRTableViewCell *)[self.multselectTbl dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
//        cell.isSelected = [selectedMarks containsObject:selectParticipantCode] ? YES : NO;
        
        isEventType =NO;
        isEventStatus =NO;
        isParticipant =YES;
        isParticipantType=NO;
        isaddPartcipant=NO;
        isteam =NO;
    
        [self.multselectTbl reloadData];
    
//    }
//    else{
//        self.comPopview.hidden=YES;
//        isParticipant=NO;
//        [self.multselectTbl reloadData];
//        
//    }
    
}
-(IBAction)didClickOKBtn:(id)sender
{
    self.comPopview.hidden =YES;
    //self.multselectTbl.hidden =YES;
    
    NSLog(@"%@", selectedMarks);
    
   // self.commonView.hidden = YES;
    
    //static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
    
    static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
    
    CRTableViewCell *cell = (CRTableViewCell *)[self.multselectTbl dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
    cell.isSelected = [selectedMarks containsObject:selectParticipantCode] ? YES : NO;
    
   // self.addParticipantArray = selectedMarks;
    
    [self.multselectTbl reloadData];
    
}

-(IBAction)didClickClearAllBtn:(id)sender
{
    [selectedMarks removeAllObjects];
    int a = selectedMarks.count;
    if(a == 0)
    {
        //NSString *b = [NSString stringWithFormat:@"%d", a];
        self.particiLbl.text = @"";
    }
    if(a == 1)
    {
        //NSString *b = [NSString stringWithFormat:@"%d", a];
        self.particiLbl.text = [NSString stringWithFormat:@"%d item selected", a];
    }
    else
    {
        self.particiLbl.text = [NSString stringWithFormat:@"%d items selected", a];
    }
    
    [self.multselectTbl reloadData];
    
}
-(IBAction)didClickSelectAll:(id)sender
{
    selectedMarks=[[NSMutableArray alloc]init];
    selectedMarks =self.commonArray;
    
    int a = selectedMarks.count;
    if(a == 0)
    {
        //NSString *b = [NSString stringWithFormat:@"%d", a];
        self.particiLbl.text = @"";
    }
    if(a == 1)
    {
        //NSString *b = [NSString stringWithFormat:@"%d", a];
        self.particiLbl.text = [NSString stringWithFormat:@"%d item selected", a];
    }
    else
    {
        self.particiLbl.text = [NSString stringWithFormat:@"%d items selected", a];
    }
    
    [self.multselectTbl reloadData];
    
}
-(IBAction)didClickUpdateBtnAction:(id)sender
{
    if(self.addParticipantArray.count>0)
    {
    [self UpdatePlannerWebservice];
    }
    else
    {
        [self altermsg:@"Please Select Participants"];
    }
}

-(IBAction)didClickDeleteAction:(id)sender
{
    UIAlertView * objaltert =[[UIAlertView alloc]initWithTitle:@"Planner" message:@"Do you want to delete this event" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    objaltert.tag =100;
    [objaltert show];
    
    
    
}




#pragma participant addbtn Action

-(IBAction)didClickPlusBtn:(id)sender
{
    if([self.particiTypeLbl.text isEqualToString:@""] || [self.particiTypeLbl.text isEqualToString:@"Select"])
    {
        [self altermsg:@"Please Select Participant Type"];
        
    }
    else if ([self.teamLbl.text isEqualToString:@""] || [self.teamLbl.text isEqualToString:@"Select"])
    {
        [self altermsg:@"Please Select Team"];
        
    }
    else if ([self.particiLbl.text isEqualToString:@""] || [self.particiLbl.text isEqualToString:@"Select"])
    {
        [self altermsg:@"Please Add Participant"];
        
    }
    else if([self.eventnameTxt.text isEqualToString:@"Select"] || [self.eventnameTxt.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EventName"];
    }
    else if ([self.startdateLbl.text isEqualToString:@"Select"] || [self.startdateLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter StartDate"];
    }
    else if ([self.enddateLbl.text isEqualToString:@"Select"] || [self.enddateLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EndDate"];
    }
    else if ([self.startTimeLbl.text isEqualToString:@"Select"] || [self.startTimeLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter StartTime"];
    }
    else if ([self.endTimeLbl.text isEqualToString:@"Select"] || [self.endTimeLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EndTime"];
    }
    else if ([self.eventTypeLbl.text isEqualToString:@"Select"] || [self.eventTypeLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EventType"];
    }
    else if ([self.eventStatusLbl.text isEqualToString:@"Select"] || [self.eventStatusLbl.text isEqualToString:@""])
    {
        [self altermsg:@"Please Enter EventStatus"];
    }
    
    
    NSString * date1 =self.startdateLbl.text;
    NSDate *today = [NSDate date];
    NSString * date2 =self.enddateLbl.text;

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDate *dat1= [formatter dateFromString:date1];
    NSDate *dat2 = [formatter dateFromString:date2];
    

    int addDaysCount = 1;

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:addDaysCount];
    
    
    NSDate *newDate1 = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dat1 options:0];
    
    NSDate *newDate2 = [[NSCalendar currentCalendar]
                        dateByAddingComponents:dateComponents
                        toDate:dat2 options:0];

    
    NSComparisonResult result = [today compare:newDate1];
    NSComparisonResult result1 = [today compare:newDate2];
    if(result == NSOrderedDescending)
    {
        [self altermsg:@"past date not allowed in state date"];
    }
    else if(result1 == NSOrderedDescending)
    {
        [self altermsg:@"past date not allowed in end date"];
    }
    else if(result == NSOrderedAscending && result1 == NSOrderedAscending){
        if(![self.particiTypeLbl.text isEqualToString:@"Select"] && ![self.teamLbl.text isEqualToString:@"Select"] && ![self.particiLbl.text isEqualToString:@"Select"] && ![self.particiTypeLbl.text isEqualToString:@""] && ![self.teamLbl.text isEqualToString:@""] && ![self.particiLbl.text isEqualToString:@""] )
        {
            NSMutableArray *a1 = [[NSMutableArray alloc]init];
            a1 = selectedMarks;
            
            BOOL isdata ;
            isdata = YES;
            for(int i=0;i<selectedMarks.count;i++)
            {
                NSString *ppcode = [[a1 valueForKey:@"Participantcode"] objectAtIndex:i];
                NSMutableArray *add = [[NSMutableArray alloc]init];
                for( int j=0;j<self.addParticipantArray.count;j++)
                {
                    NSString *reCode = [[self.addParticipantArray valueForKey:@"Participantcode"] objectAtIndex:j];
                    [add addObject:reCode];
                }
            
                if([add containsObject:ppcode])
                {
                    [self altermsg:@"Please select different Participant"];
                    isdata = YES;
                    return;
                }
                else
                {
                    isdata = NO;
                }
            }
            if(!isdata)
            {
            [self ParticipantAddMethod];
            }
                
//                if(self.addParticipantArray.count ==0)
//                {
//                    [self ParticipantAddMethod];
//                }
//                else
//                {
//                    for(int j=0;j<self.addParticipantArray.count;j++)
//                    {
//         NSString *ppcode1 = [[self.addParticipantArray valueForKey:@"Participantcode"] objectAtIndex:j];
//                    
//                        if([ppcode1 isEqualToString:ppcode])
//                        {
//                            [self altermsg:@"Please select different Participant"];
//                        }
//                        else
//                        {
//                            [self ParticipantAddMethod];
//                        }
//                    }
//                }
                
            }
                
                
            }
}


#pragma participantAdd method
-(void)ParticipantAddMethod
{
    isEventType =NO;
    isEventStatus =NO;
    isParticipant =NO;
    isParticipantType=NO;
    isaddPartcipant=YES;
    isteam =NO;
    if(selectedMarks.count>0)
    {
        
        
        if(self.addParticipantArray.count>0)
        {
            NSLog(@"Data avaialable");
        }
        else
        {
        self.addParticipantArray =[[NSMutableArray alloc]init];
        }
        
        NSMutableArray *pname = [[NSMutableArray alloc]init];
        NSMutableArray *ptype = [[NSMutableArray alloc]init];
        NSMutableArray *pcode = [[NSMutableArray alloc]init];
        
        pname=[selectedMarks valueForKey:@"Participantname"];
        ptype=[selectedMarks valueForKey:@"Participanttype"];
        pcode=[selectedMarks valueForKey:@"Participantcode"];
        
        
        for(int i=0;i<selectedMarks.count;i++)
        {
            NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
            [mutableDict setObject:@"YES" forKey:@"IsAvailable"];
            [mutableDict setObject:[pname objectAtIndex:i] forKey:@"Participantname"];
            [mutableDict setObject:[ptype objectAtIndex:i] forKey:@"ParticipantTypename"];
            [mutableDict setObject:selectParticipantType forKey:@"ParticipantTypecode"];
            [mutableDict setObject:[pcode objectAtIndex:i] forKey:@"Participantcode"];
    
            [self.addParticipantArray addObject:mutableDict];
        }
    }
    else
    {
//        self.addParticipantArray =[[NSMutableArray alloc]init];
//        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
//        [mutableDict setObject:@"YES" forKey:@"IsAvailable"];
//        [mutableDict setObject:self.particiLbl.text forKey:@"Participantname"];
//        [mutableDict setObject:self.particiTypeLbl.text forKey:@"ParticipantTypename"];
//        [mutableDict setObject:selectParticipantType forKey:@"ParticipantTypecode"];
//        [mutableDict setObject:selectParticipantCode forKey:@"Participantcode"];
        
        [self altermsg:@"Please Add Participant"];
        
        
        //[self.addParticipantArray addObject:mutableDict];
    }
    
    [self.participantTbl reloadData];

    self.addeventTblheight.constant =self.participantTbl.contentSize.height;
    
    self.commonScrollview.contentSize = CGSizeMake(self.commonScrollview.frame.size.width,self.commonScrollview.frame.size.height+self.addeventTblheight.constant-200);
    self.mainParticipantViewheight.constant = self.participantTbl.contentSize.height+200;
    
    //self.popTblheight.constant =self.popviewTbl.contentSize.height-100;
    

    self.particiLbl.text =@"Select";
    self.particiTypeLbl.text =@"Select";
    self.teamLbl.text =@"Select";
    
}

#pragma Webservice methods
-(void)startFetchTeamByParticipantType:(NSString *)ParticipantType
{
    [AppCommon showLoading];
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",FetchParticipantType]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(ParticipantType)   [dic    setObject:ParticipantType     forKey:@"ParticipantType"];
        if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
        if(usercode)   [dic    setObject:usercode     forKey:@"CreatedBy"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                NSMutableArray * objTeamArray =[responseObject valueForKey:@"ListPlayerTeamDetails"];
                
                self.TeamDetailArray =[[NSMutableArray alloc]init];
                self.TeamDetailArray =objTeamArray;
                
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
             
            
        }];
    }
    
    
}

-(void)startFetchPlayerByTeamAndParticipantType :(NSString *) participantType
{
    [AppCommon showLoading];
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",FetchParticipantPlayerDetail]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
       // NSString *team = [[NSUserDefaults standardUserDefaults]stringForKey:@"APTTeamcode"];

        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(participantType)   [dic    setObject:participantType     forKey:@"ParticipantType"];
        if(selectTeam)   [dic    setObject:selectTeam     forKey:@"TeamCode"];
        if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
        
        
        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                
                self.participantsArray =[[NSMutableArray alloc]init];
                self.participantsArray =[responseObject valueForKey:@"ListParticipantsDetails"];
                
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
             
            
        }];
    }
    
}

-(void)InserPlannerWebService
{
    [AppCommon showLoading];
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",PlannerInsert]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        NSMutableArray *pcode = [[NSMutableArray alloc]init];
        NSMutableArray *pType = [[NSMutableArray alloc]init];
    
        pcode= [self.addParticipantArray valueForKey:@"Participantcode"];
        pType= [self.addParticipantArray valueForKey:@"ParticipantTypecode"];
        
        
        NSMutableDictionary * rootObj =[[NSMutableDictionary alloc]init];
        NSMutableArray * objArray =[[NSMutableArray alloc]init];
        for (int i=0; i<self.addParticipantArray.count;i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

            if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
            if([pType objectAtIndex:i])   [dic    setObject:[pType objectAtIndex:i]     forKey:@"ParticipantTypecode"];
            if([pcode objectAtIndex:i])   [dic    setObject:[pcode objectAtIndex:i]       forKey:@"Participantcode"];
            if(usercode) [dic setObject:usercode forKey:@"CreatedBy"];
            [objArray addObject:dic];
        }
        
        [rootObj setObject:cliendcode forKey:@"ClientCode"];
        [rootObj setObject:self.eventnameTxt.text forKey:@"EventName"];
        [rootObj setObject:self.startdateLbl.text forKey:@"StartDate"];
        [rootObj setObject:self.enddateLbl.text forKey:@"EndDate"];
        [rootObj setObject:self.startTimeLbl.text forKey:@"StartTime"];
        [rootObj setObject:self.endTimeLbl.text forKey:@"EndTime"];
        [rootObj setObject:selectEventTypeCode forKey:@"EventTypeCode"];
        [rootObj setObject:selectEventStatusCode forKey:@"EventStatusCode"];
        [rootObj setObject:self.commentTxt.text forKey:@"Comments"];
        [rootObj setObject:self.commentTxt.text forKey:@"Eventvenue"];
        [rootObj setObject:usercode forKey:@"CreatedBy"];
        [rootObj setObject:objArray forKey:@"lstEventTemplateParticipants"];


        //NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:rootObj success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                BOOL status=[responseObject valueForKey:@"result"];
                        if(status == YES)
                        {
                           
                            [self altermsg:@"Event Inserted Successfully"];
                            [self.navigationController popViewControllerAnimated:YES];

                        }
                        else{
                            [self altermsg:@"Event Inserted Failed"];
                        }
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
             
            
        }];
    }

}

-(void)editFetchWebservice :(NSString *) eventCode :(NSString *) duration :(NSString *)drop
{
    [AppCommon showLoading];
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",FetchEditPlanner]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if(eventCode)   [dic    setObject:eventCode     forKey:@"EventCode"];
        if(duration)   [dic    setObject:duration     forKey:@"IntervalDuration"];
        if(drop)   [dic    setObject:drop     forKey:@"IsDrop"];
         if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
        if(usercode)   [dic    setObject:usercode     forKey:@"CreatedBy"];

        NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                
                NSDictionary * objDic = [responseObject valueForKey:@"ListEventTemplateDetails"];
                
                self.startdateLbl.text =[[objDic valueForKey:@"StartDate"] objectAtIndex:0];
                self.enddateLbl.text =[[objDic valueForKey:@"EndDate"] objectAtIndex:0];
                self.eventnameTxt.text= [[objDic valueForKey:@"EventName"] objectAtIndex:0];
                self.startTimeLbl.text=[[objDic valueForKey:@"StartTime"] objectAtIndex:0];
                self.endTimeLbl.text=[[objDic valueForKey:@"EndTime"] objectAtIndex:0];
                self.eventTypeLbl.text=[[objDic valueForKey:@"EventTypename"] objectAtIndex:0];
                self.eventStatusLbl.text=[[objDic valueForKey:@"EventStatusname"] objectAtIndex:0];
                self.commentTxt.text=[[objDic valueForKey:@"Comments"] objectAtIndex:0];
                selectEventTypeCode =[[objDic valueForKey:@"EventTypeCode"] objectAtIndex:0];
                selectEventStatusCode=[[objDic valueForKey:@"EventStatusCode"] objectAtIndex:0];
                self.addParticipantArray =[[NSMutableArray alloc]init];
                NSMutableArray * objArray=[responseObject valueForKey:@"ListEventTemplateParticipantsDetails"];
                for(int i=0; objArray.count>i;i++)
                {
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
                    [mutableDict setObject:[[objArray valueForKey:@"IsAvailable"] objectAtIndex:i] forKey:@"IsAvailable"];
                    [mutableDict setObject:[[objArray valueForKey:@"Participantname"] objectAtIndex:i] forKey:@"Participantname"];
                    [mutableDict setObject:[[objArray valueForKey:@"ParticipantTypename"] objectAtIndex:i] forKey:@"ParticipantTypename"];
                    [mutableDict setObject:[[objArray valueForKey:@"ParticipantTypecode"] objectAtIndex:i] forKey:@"ParticipantTypecode"];
                    [mutableDict setObject:[[objArray valueForKey:@"Participantcode"] objectAtIndex:i] forKey:@"Participantcode"];
                    
                    
                    [self.addParticipantArray addObject:mutableDict];
                }
                self.particiLbl.text =@"Select";
                self.particiTypeLbl.text=@"Select";
                
                self.teamLbl.text =@"Select";
                
                isEventType =NO;
                isEventStatus =NO;
                isParticipant =NO;
                isParticipantType=NO;
                isaddPartcipant=YES;
                isteam =NO;
            
                [self.participantTbl reloadData];
                
                self.addeventTblheight.constant =self.participantTbl.contentSize.height;
                //self.popTblheight.constant =self.popviewTbl.contentSize.height-100;
                
                self.commonScrollview.contentSize = CGSizeMake(self.commonScrollview.frame.size.width,self.commonScrollview.frame.size.height+self.addeventTblheight.constant-200);
                self.mainParticipantViewheight.constant = self.participantTbl.contentSize.height+200;
                
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
             
            
        }];
    }
    
}


-(void)UpdatePlannerWebservice
{
    [AppCommon showLoading];
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",UpdatePlanner]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
        NSMutableArray *pcode = [[NSMutableArray alloc]init];
        NSMutableArray *pType = [[NSMutableArray alloc]init];
        
        pcode= [self.addParticipantArray valueForKey:@"Participantcode"];
        pType= [self.addParticipantArray valueForKey:@"ParticipantTypecode"];
        
        NSMutableDictionary * rootObj =[[NSMutableDictionary alloc]init];
        NSMutableArray * objArray =[[NSMutableArray alloc]init];
        for (int i=0; i<self.addParticipantArray.count;i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            if(cliendcode)   [dic    setObject:cliendcode     forKey:@"ClientCode"];
            if([pType objectAtIndex:i])   [dic    setObject:[pType objectAtIndex:i]     forKey:@"ParticipantTypecode"];
            if([pcode objectAtIndex:i])   [dic    setObject:[pcode objectAtIndex:i]       forKey:@"Participantcode"];
            if(usercode) [dic setObject:usercode forKey:@"CreatedBy"];
            [objArray addObject:dic];
        }
        
        NSString *eventCode = [self.objSelectEditDic valueForKey:@"id"];
        
        [rootObj setObject:cliendcode forKey:@"ClientCode"];
        [rootObj setObject:eventCode forKey:@"EventCode"];
        [rootObj setObject:self.eventnameTxt.text forKey:@"EventName"];
        [rootObj setObject:self.eventnameTxt.text forKey:@"EventName"];
        [rootObj setObject:self.startdateLbl.text forKey:@"StartDate"];
        [rootObj setObject:self.enddateLbl.text forKey:@"EndDate"];
        [rootObj setObject:self.startTimeLbl.text forKey:@"StartTime"];
        [rootObj setObject:self.endTimeLbl.text forKey:@"EndTime"];
        [rootObj setObject:selectEventTypeCode forKey:@"EventTypeCode"];
        [rootObj setObject:selectEventStatusCode forKey:@"EventStatusCode"];
        [rootObj setObject:self.commentTxt.text forKey:@"Comments"];
        [rootObj setObject:self.commentTxt.text forKey:@"Eventvenue"];
        [rootObj setObject:usercode forKey:@"CreatedBy"];
        [rootObj setObject:usercode forKey:@"CreatedBy"];
        [rootObj setObject:objArray forKey:@"lstEventTemplateParticipants"];
        
        NSLog(@"%@", rootObj);
        [manager POST:URLString parameters:rootObj success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                BOOL status=[responseObject valueForKey:@"result"];
                if(status == YES)
                {
                    [self altermsg:@"Update successfully"];
                    
//                    PlannerVC  * objPlannerlist=[[PlannerVC alloc]init];
//
//                    objPlannerlist = (PlannerVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"Planner"];
//                    [self.navigationController pushViewController:objPlannerlist animated:YES];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }
                else{
                    [self altermsg:@"Update failed"];
                }
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
             
            
        }];
    }

}

-(void)deletePlannerWebservice
{
    [AppCommon showLoading];
    if([COMMON isInternetReachable])
    {
        
        
        NSString *URLString =  [URL_FOR_RESOURCE(@"") stringByAppendingString:[NSString stringWithFormat:@"%@",DeletePlanner]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.requestSerializer = requestSerializer;
        
        
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            if([self.objSelectEditDic valueForKey:@"id"])   [dic    setObject:[self.objSelectEditDic valueForKey:@"id"]     forKey:@"EventCode"];
            if(usercode) [dic setObject:usercode forKey:@"CreatedBy"];
        
        
        //NSLog(@"parameters : %@",dic);
        [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response ; %@",responseObject);
            
            if(responseObject >0)
            {
                NSLog(@"%@",responseObject);
                BOOL status=[responseObject valueForKey:@"result"];
                if(status == YES)
                {
                    [self altermsg:@"Delete successfully"];
                    PlannerVC  * objPlannerlist=[[PlannerVC alloc]init];
                    objPlannerlist = [[PlannerVC alloc] initWithNibName:@"PlannerVC" bundle:nil];
                   // objPlannerlist = (PlannerVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlannerVC"];
                    [self.navigationController pushViewController:objPlannerlist animated:YES];

                    
                }
                else{
                    [self altermsg:@"Delete failed"];
                }
            }
            
            [AppCommon hideLoading];
             
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
            [AppCommon hideLoading];
             
            
        }];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isaddPartcipant==YES)
    {
        return [self.addParticipantArray count];
    }
    else
    {
        if(isParticipant ==YES)
        {
            tableView =self.multselectTbl;
        }
        else{
            tableView =self.popviewTbl;
        }
        return [self.commonArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isaddPartcipant==YES)
    {
        return 40;
    }
    else
    {
        return 30;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isaddPartcipant==YES)
    {
        static NSString *CellIdentifier = @"AddParticipant";
        
        AddParticipantCell * objCell = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (objCell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"AddParticipantCell" owner:self options:nil];
            objCell = self.participantCell;
        }
        
        objCell.participationTypeLbl.text =[[self.addParticipantArray valueForKey:@"ParticipantTypename"] objectAtIndex:indexPath.row];
        objCell.participantLbl.text =[[self.addParticipantArray valueForKey:@"Participantname"] objectAtIndex:indexPath.row];
        objCell.availableLbl.text= [[self.addParticipantArray valueForKey:@"IsAvailable"] objectAtIndex:indexPath.row];
        if([AppCommon isCoach])
        {
            [objCell.deleteBtn addTarget:self action:@selector(didClickDeleteParticipantAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        
        
        
        return objCell;
    }
    else if (isParticipant ==YES)
    {
        static NSString *CRTableViewCellIdentifier = @"cellIdentifier";

        CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
        
        if (cell == nil) {
            cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRTableViewCellIdentifier];
        }
    
        
        selectParticipantCode =[[self.commonArray valueForKey:@"Participantcode"] objectAtIndex:indexPath.row];
        // Check if the cell is currently selected (marked)
        NSString *text = [[self.commonArray valueForKey:@"Participantname"] objectAtIndex:[indexPath row]];
        cell.isSelected = [[selectedMarks  valueForKey:@"Participantcode" ]containsObject:selectParticipantCode] ? YES : NO;
        cell.textLabel.text = text;
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:46.0/255.0 blue:125.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:(IS_IPAD ? 13.0 : 13.0 )];
        if(IS_IPHONE_DEVICE)
        {
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }else
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        
//        cell.imageView.layer.masksToBounds=YES;
//        cell.imageView.layer.borderWidth=2.0;
//        cell.imageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.numberOfLines = 2;
        
        
        //cell.contentView.backgroundColor = [UIColor lightGrayColor];
        
        return cell;

    }
    else{
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        
        if(isEventType)
        {
            cell.textLabel.text = [[self.commonArray valueForKey:@"EventTypename"] objectAtIndex:indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
        }
        else if (isEventStatus)
        {
            cell.textLabel.text = [[self.commonArray valueForKey:@"EventStatusname"] objectAtIndex:indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else if (isParticipantType)
        {
            cell.textLabel.text = [[self.commonArray valueForKey:@"ParticipantTypename"] objectAtIndex:indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else if (isteam)
        {
            cell.textLabel.text = [[self.commonArray valueForKey:@"Teamname"] objectAtIndex:indexPath.row];
            
        }
//        else if(isParticipant)
//        {
            //if([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
               // cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            } else {
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
            //cell.textLabel.text = [[self.commonArray valueForKey:@"Participantname"] objectAtIndex:indexPath.row];


       // }
        
        
        //cell.backgroundColor = [UIColor clearColor];
        
       // cell.contentView.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:26.0/255.0 blue:68.0/255.0 alpha:1.0];
        cell.contentView.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:46.0/255.0 blue:125.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:(IS_IPAD ? 13.0 : 13.0 )];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.numberOfLines = 2;
        
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isEventType)
    {
        self.eventTypeLbl.text =[[self.commonArray valueForKey:@"EventTypename"] objectAtIndex:indexPath.row];
        selectEventTypeCode =[[self.commonArray valueForKey:@"EventTypeCode"] objectAtIndex:indexPath.row];
        self.popviewTbl.hidden =YES;
    }
    else if (isEventStatus)
    {
        self.eventStatusLbl.text =[[self.commonArray valueForKey:@"EventStatusname"] objectAtIndex:indexPath.row];
        selectEventStatusCode =[[self.commonArray valueForKey:@"EventStatusCode"] objectAtIndex:indexPath.row];
        self.popviewTbl.hidden =YES;
    }
    else if (isParticipantType)
    {
        self.particiTypeLbl.text =[[self.commonArray valueForKey:@"ParticipantTypename"] objectAtIndex:indexPath.row];
        selectParticipantType =[[self.commonArray valueForKey:@"ParticipantTypecode"] objectAtIndex:indexPath.row];
        [self startFetchTeamByParticipantType:selectParticipantType];
         //[self startFetchPlayerByTeamAndParticipantType:selectParticipantType];
        self.popviewTbl.hidden =YES;
    }
    else if (isteam)
    {
        self.teamLbl.text =[[self.commonArray valueForKey:@"Teamname"] objectAtIndex:indexPath.row];
        selectTeam  =[[self.commonArray valueForKey:@"Teamcode"] objectAtIndex:indexPath.row];
        [self startFetchPlayerByTeamAndParticipantType:selectParticipantType];
        self.popviewTbl.hidden =YES;
    }
    else if (isParticipant)
    {
        NSDictionary *dic = [self.commonArray objectAtIndex:[indexPath row]];
        
        if ([selectedMarks containsObject:dic])// Is selected?
            [selectedMarks removeObject:dic];
        else
            [selectedMarks addObject:dic];
        self.particiLbl.text = @"";
        
        int a = selectedMarks.count;
        if(a == 0)
        {
            //NSString *b = [NSString stringWithFormat:@"%d", a];
            self.particiLbl.text = @"";
        }
        if(a == 1)
        {
            //NSString *b = [NSString stringWithFormat:@"%d", a];
            self.particiLbl.text = [NSString stringWithFormat:@"%d item selected", a];
        }
        else
        {
            self.particiLbl.text = [NSString stringWithFormat:@"%d items selected", a];
        }

        //self.particiLbl.text =[[self.commonArray valueForKey:@"Participantname"] objectAtIndex:indexPath.row];
        selectParticipantCode =[[self.commonArray valueForKey:@"Participantcode"] objectAtIndex:indexPath.row];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        self.multselectTbl.hidden =NO;
        
        //isaddPartcipant=NO;
    }
    
    
    
}


-(IBAction)didClickDeleteParticipantAction:(id)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.participantTbl];
    
    NSIndexPath *indexPath = [self.participantTbl indexPathForRowAtPoint:touchPoint];
    
    [self.addParticipantArray removeObjectAtIndex:indexPath.row];
    
    
    [self.participantTbl reloadData];
    
    self.addeventTblheight.constant =self.participantTbl.contentSize.height;
    self.commonScrollview.contentSize = CGSizeMake(self.commonScrollview.frame.size.width,self.commonScrollview.frame.size.height+self.addeventTblheight.constant-200);
    self.mainParticipantViewheight.constant = self.participantTbl.contentSize.height+200;
}
-(IBAction)didClickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        alertView.hidden=YES;
    }
    else
    {
        if (alertView.tag == 100)
        {
            [self deletePlannerWebservice];
        }
        else
        {
            
        }

     }
    
    
}
-(IBAction)HomeBtnAction:(id)sender
{
//    HomeVC  * objTabVC=[[HomeVC alloc]init];
//    objTabVC = (HomeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//    [self.navigationController pushViewController:objTabVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
