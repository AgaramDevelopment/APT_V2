//
//  AddWellnessRatingVC.m
//  APT_V2
//
//  Created by Apple on 07/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "AddWellnessRatingVC.h"
#import "AppCommon.h"
#import "WebService.h"
#import "Config.h"
#import "WellnessTrainingBowlingVC.h"
#import "SWRevealViewController.h"
#import "SwipeView.h"
#import "TabHomeVC.h"
@import SCLAlertView_Objective_C;


@interface AddWellnessRatingVC ()
{
    WebService *objWebservice;
    WellnessTrainingBowlingVC *objWell;
    TabHomeVC *tab;
    NSString *fetchedDate;
    NSString *FetchedWorkLoadCode;
    NSString * SelectedDate;
float num1;
float num2;
float num3;
float num4;

NSString *metaSubCode1;
NSString *metaSubCode2;
NSString *metaSubCode3;
NSString *metaSubCode4;
    
    UIDatePicker *datePicker;
    
    NSString *urineColorNum;
}

@property (strong, nonatomic) IBOutlet UISlider *sleepSlider;
@property (strong, nonatomic) IBOutlet UISlider *fatiqueSlider;
@property (strong, nonatomic) IBOutlet UISlider *muscleSlider;
@property (strong, nonatomic) IBOutlet UISlider *stressSlider;

@property (strong, nonatomic)  NSMutableArray *sleeplist;
@property (strong, nonatomic)  NSMutableArray *fatiqlist;
@property (strong, nonatomic)  NSMutableArray *sorelist;
@property (strong, nonatomic)  NSMutableArray *stresslist;

@property (strong, nonatomic)  NSMutableArray *sleeplist1;
@property (strong, nonatomic)  NSMutableArray *fatiqlist1;
@property (strong, nonatomic)  NSMutableArray *sorelist1;
@property (strong, nonatomic)  NSMutableArray *stresslist1;


@end

@implementation AddWellnessRatingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //SWRevealViewController *revealController = [self revealViewController];
    //[revealController.panGestureRecognizer setEnabled:NO];
    //[revealController.tapGestureRecognizer setEnabled:NO];
    
    
    
    objWebservice = [[WebService alloc] init];
    [self.view_datepicker setHidden:YES];
    
 
    _ColorSlider1.colorTrackImageView.image = [UIImage imageNamed:@"SliderBackground"];
    _ColorSlider2.colorTrackImageView.image = [UIImage imageNamed:@"SliderBackground"];
    _ColorSlider3.colorTrackImageView.image = [UIImage imageNamed:@"SliderBackground"];
    _ColorSlider4.colorTrackImageView.image = [UIImage imageNamed:@"SliderBackground"];
    
    self.SaveBtn.hidden = NO;
    self.UpdateBtn.hidden = YES;
    
    [tab.swipeView setScrollEnabled:NO];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"MM-dd-yyyy"];
    SelectedDate = [dateFormat1 stringFromDate:matchdate];
    
    NSString * actualDate = [dateFormat stringFromDate:matchdate];
    self.datelbl.text = actualDate;
    [self metacodeWebservice];
    [self DateWebservice];
    [self customnavigationmethod];
    
    
    
//    if([self.isFromHome isEqualToString:@"NO"])
//    {
//    self.navViewHeight.constant = 0;
//    }
//    else
//    {
//        [self customnavigationmethod];
//    }
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    
    self.bodyWeightTxt.leftView = paddingView;
    self.bodyWeightTxt.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    self.sleepHrTxt.leftView = paddingView1;
    self.sleepHrTxt.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    self.sleepMinTxt.leftView = paddingView2;
    self.sleepMinTxt.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    self.fatTxt.leftView = paddingView3;
    self.fatTxt.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    self.restingHrTxt.leftView = paddingView4;
    self.restingHrTxt.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    self.restingBpMaxTxt.leftView = paddingView5;
    self.restingBpMaxTxt.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,30)];
    self.restingBpMinTxt.leftView = paddingView6;
    self.restingBpMinTxt.leftViewMode = UITextFieldViewModeAlways;
   
}

-(void)customnavigationmethod
{
    CustomNavigation * objCustomNavigation=[[CustomNavigation alloc] initWithNibName:@"CustomNavigation" bundle:nil];
    
   // SWRevealViewController *revealController = [self revealViewController];
    //[revealController panGestureRecognizer];
   // [revealController tapGestureRecognizer];
    
    //    [self.view addSubview:objCustomNavigation.view];
    //    objCustomNavigation.tittle_lbl.text=@"";
    
    UIView* view= self.view.subviews.firstObject;
    [self.navView addSubview:objCustomNavigation.view];
    
    BOOL isBackEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"BACK"];
    isBackEnable = YES;
    if (isBackEnable) {
        objCustomNavigation.menu_btn.hidden =YES;
        objCustomNavigation.btn_back.hidden =NO;
        [objCustomNavigation.btn_back addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        objCustomNavigation.menu_btn.hidden =NO;
        objCustomNavigation.btn_back.hidden =YES;
        //[objCustomNavigation.menu_btn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
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

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
//    if (myTextField) {
//        if ([myTextField canResignFirstResponder]) [myTextField resignFirstResponder];
//    }
//    [super touchesBegan: touches withEvent: event];
}

-(void)viewWillAppear:(BOOL)animated
{
   // SWRevealViewController *revealController = [self revealViewController];
    //[revealController.panGestureRecognizer setEnabled:NO];
   // [revealController.tapGestureRecognizer setEnabled:NO];
    [tab.swipeView setScrollEnabled:NO];
}

-(IBAction)sliderDidChange:(RGSColorSlider *)sender{
    //self.colorView.backgroundColor = sender.color;
    sender.showPreview = NO;
}


- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(0, 0, 100, 30);//change it to any size you want
    return rect;
}

- (IBAction)DateBtnAction:(id)sender {
    
    [self DisplaydatePicker];
    
}

-(BOOL) textFieldShouldReturn:(UITextField*) theTextField{
    [theTextField resignFirstResponder];
    return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   
    if(textField == self.bodyWeightTxt || textField == self.fatTxt)
    {
        NSCharacterSet *myCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
        if ([string rangeOfCharacterFromSet:myCharSet].location != NSNotFound) {
            return NO;
        }
        else if(textField.text.length>=6 && ![string isEqualToString:@""])
        {
            [AppCommon showAlertWithMessage:@"Maximum length should be 6 only"];
            return NO;
        }
    }
    else if(textField == self.sleepMinTxt || textField == self.sleepHrTxt)
    {
        NSCharacterSet *myCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        
        if ([string rangeOfCharacterFromSet:myCharSet].location != NSNotFound) {
            return NO;
        }
        else if(textField.text.length>=2 && ![string isEqualToString:@""])
        {
            [AppCommon showAlertWithMessage:@"Maximum length should be 2 only"];
            return NO;
        }
    }
    else if(textField == self.restingHrTxt || textField == self.restingBpMaxTxt || textField == self.restingBpMinTxt)
    {
        NSCharacterSet *myCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        
        if ([string rangeOfCharacterFromSet:myCharSet].location != NSNotFound) {
            return NO;
        }
        else if(textField.text.length>=3 && ![string isEqualToString:@""])
        {
            [AppCommon showAlertWithMessage:@"Maximum length should be 3 only"];
            return NO;
        }
    }
    

    
    
    return YES;
}

- (IBAction)sliderGesture:(id)sender {
    
    [tab.swipeView setScrollEnabled:NO];
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
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0,0,self.view_datepicker.frame.size.width,100)];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [datePicker setLocale:locale];
    
    // [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker reloadInputViews];
    [self.view_datepicker addSubview:datePicker];
    
}
-(IBAction)showSelecteddate:(id)sender{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *matchdate = [NSDate date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    if([datePicker.date compare:matchdate] == NSOrderedAscending)
    {
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"MM-dd-yyyy"];
        SelectedDate = [dateFormat1 stringFromDate:datePicker.date];
        
        NSString * actualDate = [dateFormat stringFromDate:datePicker.date];
        self.datelbl.text = actualDate;
        [self.view_datepicker setHidden:YES];
        [self DateWebservice];
    }
    else
    {
        [AppCommon showAlertWithMessage:@"Feature Dates Not allowed"];
        [self.view_datepicker setHidden:YES];
    }
    
   
    
}


- (IBAction)urineColorBtn1Action:(id)sender {
    
    urineColorNum = @"1";
    self.UrineColorBtn1.tag =1;
    self.UrineColorBtn2.tag =0;
    self.UrineColorBtn3.tag =0;
    self.UrineColorBtn4.tag =0;
    self.UrineColorBtn5.tag =0;
    self.UrineColorBtn6.tag =0;
    self.UrineColorBtn7.tag =0;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
    
//    self.UrineColorBtn1.layer.borderWidth = 2.0f;
//    self.UrineColorBtn1.layer.borderColor = [UIColor blackColor].CGColor;
}
- (IBAction)urineColorBtn2Action:(id)sender {
    
    urineColorNum = @"2";
    
    
    self.UrineColorBtn1.tag =0;
    self.UrineColorBtn2.tag =1;
    self.UrineColorBtn3.tag =0;
    self.UrineColorBtn4.tag =0;
    self.UrineColorBtn5.tag =0;
    self.UrineColorBtn6.tag =0;
    self.UrineColorBtn7.tag =0;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
    
//    self.UrineColorBtn1.layer.borderWidth = 2.0f;
//    self.UrineColorBtn1.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (IBAction)urineColorBtn3Action:(id)sender {
    
    urineColorNum = @"3";
    self.UrineColorBtn1.tag =0;
    self.UrineColorBtn2.tag =0;
    self.UrineColorBtn3.tag =1;
    self.UrineColorBtn4.tag =0;
    self.UrineColorBtn5.tag =0;
    self.UrineColorBtn6.tag =0;
    self.UrineColorBtn7.tag =0;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
}

- (IBAction)urineColorBtn4Action:(id)sender {
    
    urineColorNum = @"4";
    self.UrineColorBtn1.tag =0;
    self.UrineColorBtn2.tag =0;
    self.UrineColorBtn3.tag =0;
    self.UrineColorBtn4.tag =1;
    self.UrineColorBtn5.tag =0;
    self.UrineColorBtn6.tag =0;
    self.UrineColorBtn7.tag =0;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
}

- (IBAction)urineColorBtn5Action:(id)sender {
    
    urineColorNum = @"5";
    self.UrineColorBtn1.tag =0;
    self.UrineColorBtn2.tag =0;
    self.UrineColorBtn3.tag =0;
    self.UrineColorBtn4.tag =0;
    self.UrineColorBtn5.tag =1;
    self.UrineColorBtn6.tag =0;
    self.UrineColorBtn7.tag =0;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
}

- (IBAction)urineColor6BtnAction:(id)sender {
    
    urineColorNum = @"6";
    self.UrineColorBtn1.tag =0;
    self.UrineColorBtn2.tag =0;
    self.UrineColorBtn3.tag =0;
    self.UrineColorBtn4.tag =0;
    self.UrineColorBtn5.tag =0;
    self.UrineColorBtn6.tag =1;
    self.UrineColorBtn7.tag =0;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
}

- (IBAction)urineColorBtn7Action:(id)sender {
    
    urineColorNum = @"7";
    self.UrineColorBtn1.tag =0;
    self.UrineColorBtn2.tag =0;
    self.UrineColorBtn3.tag =0;
    self.UrineColorBtn4.tag =0;
    self.UrineColorBtn5.tag =0;
    self.UrineColorBtn6.tag =0;
    self.UrineColorBtn7.tag =1;
    self.UrineRatinglbl.text = [NSString stringWithFormat:@"%@/7",urineColorNum];
    [self setborder];
}


- (IBAction)CancelAction:(id)sender {
    
//    objWell=[[WellnessTrainingBowlingVC alloc]init];
//    //[objWell reloaddataVC];
//    objWell.topviewHeight.constant = 270;
//    objWell.traingViewHeight.constant = 350;
    [self.view removeFromSuperview];
    [self.Delegate closeWellnessSource];
}

-(void)setborder
{
    NSArray *arr = @[self.UrineColorBtn1,self.UrineColorBtn2,self.UrineColorBtn3,self.UrineColorBtn4,self.UrineColorBtn5,self.UrineColorBtn6,self.UrineColorBtn7];
    
    for (UIButton *btn in arr) {
        if(btn.tag == 1)
        {
            btn.layer.borderWidth = 2.0f;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
        }
        else
        {
            btn.layer.borderWidth = 0.0f;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
    }
}

-(void)SaveWebservice
{
    [AppCommon showLoading ];
    
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    NSString *usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    NSString *playerCode;
    if([AppCommon isCoach])
    {
        
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    
    if([self.bodyWeightTxt.text isEqualToString:@""] || [self.bodyWeightTxt.text isEqual:[NSNull null]])
    {
        self.bodyWeightTxt.text =@"0";
    }
    
    if([self.sleepHrTxt.text isEqualToString:@""] || [self.sleepHrTxt.text isEqual:[NSNull null]])
    {
        self.sleepHrTxt.text =@"0";
    }
    if([self.sleepMinTxt.text isEqualToString:@""] || [self.sleepMinTxt.text isEqual:[NSNull null]])
    {
        self.sleepMinTxt.text =@"0";
    }
    
    if([self.fatTxt.text isEqualToString:@""] || [self.fatTxt.text isEqual:[NSNull null]] )
    {
        self.fatTxt.text =@"0";
    }
    
    if([self.restingHrTxt.text isEqualToString:@""] || [self.restingHrTxt.text isEqual:[NSNull null]])
    {
        self.restingHrTxt.text =@"0";
    }
    
    if([self.restingBpMaxTxt.text isEqualToString:@""] || [self.restingBpMaxTxt.text isEqual:[NSNull null]])
    {
        self.restingBpMaxTxt.text =@"0";
    }
    
    if([self.restingBpMinTxt.text isEqualToString:@""] || [self.restingBpMinTxt.text isEqual:[NSNull null]])
    {
        self.restingBpMinTxt.text =@"0";
    }
    
    if([urineColorNum isEqualToString:@""] || [urineColorNum isEqual:[NSNull null]])
    {
        urineColorNum =@"0";
    }
    
    int sleepHour = [self.sleepHrTxt.text intValue];
    int sleepMintues = [self.sleepMinTxt.text intValue];
    
    int totalSleepCount = (sleepHour*60)+sleepMintues;
    
    NSString *sleepHRtotalSting = [NSString stringWithFormat:@"%d",totalSleepCount];
    
    [objWebservice submit  :recordInsert :ClientCode :usercode:SelectedDate:playerCode:metaSubCode1:metaSubCode2:metaSubCode3:metaSubCode4 :self.bodyWeightTxt.text : sleepHRtotalSting : self.fatTxt.text : self.restingHrTxt.text : self.restingBpMaxTxt.text :self.restingBpMinTxt.text:urineColorNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            BOOL Status = [responseObject valueForKey:@"Status"];
            if(Status == YES)
            {
                NSLog(@"success");
                [self ShowAlterMsg:@"Wellness Rating Inserted Successfully"];
                //objWell = [[WellnessTrainingBowlingVC alloc] init];
                //objWell.topviewHeight.constant = 280;
                
//                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:300];
//
//                UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
//                [alert showCustom:self image:[UIImage imageNamed:@"Wellness"] color:color title:@"Wellness" subTitle:@"Wellness Rating Inserted Successfully" closeButtonTitle:@"OK" duration:10.0f];
            
                if([self.isFromHome isEqualToString:@"NO"])
                {

                    [self.view removeFromSuperview];
                    [self.Delegate closeWellnessSource];
                }
            else
                {
                
                 [appDel.frontNavigationController popViewControllerAnimated:YES];
                }
                
                // [self.pieChartRight reloadData];
                
            
            }
            
        }
        
        [AppCommon hideLoading];
        
        
        
    }
        failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [COMMON webServiceFailureError:error];
        }];
    
}

-(void)DateWebservice
{
    [AppCommon showLoading ];
    
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    NSString *playerCode;
    if([AppCommon isCoach])
    {
        
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    
    // NSString *urinecolor= @"0";
    
    [objWebservice fetchWellness :FetchrecordWellness : playerCode :SelectedDate success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        arr=responseObject;
        if(arr.count >0)
        {
            if( ![[[responseObject valueForKey:@"BodyWeight"] objectAtIndex:0] isEqual:[NSNull null]])
            {
                self.fetchArray = [[NSMutableArray alloc]init];
                self.fetchArray = [responseObject objectAtIndex:0];
                if(self.fetchArray.count>0)
                {
                    self.isFetch = @"yes";
                    [self setFetch];
                }
            }
            
        }
        else
        {
            self.sleepSlider.value =0;
            self.fatiqueSlider.value =0;
            self.muscleSlider.value =0;
            self.stressSlider.value =0;
            
            [self SleepSliderAction:0];
            [self FatiqueSliderAction:0];
            [self MuscleSliderAction:0];
            [self StressSliderAction:0];
            
            self.bodyWeightTxt.text = @"";
            self.sleepHrTxt.text = @"";
            self.sleepMinTxt.text = @"";
            self.fatTxt.text = @"";
            self.restingHrTxt.text = @"";
            self.restingBpMaxTxt.text = @"";
            self.restingBpMinTxt.text = @"";
            
            
            self.UrineColorBtn1.tag =0;
            self.UrineColorBtn2.tag =0;
            self.UrineColorBtn3.tag =0;
            self.UrineColorBtn4.tag =0;
            self.UrineColorBtn5.tag =0;
            self.UrineColorBtn6.tag =0;
            self.UrineColorBtn7.tag =0;
            
            self.SaveBtn.hidden = NO;
            self.UpdateBtn.hidden = YES;
            [self setborder];
            
        }
        [AppCommon hideLoading];
        
    }
                          failure:^(AFHTTPRequestOperation *operation, id error) {
                              NSLog(@"failed");
                              [COMMON webServiceFailureError:error];
                          }];
    
}

-(void)UpdateWebservice
{
    [AppCommon showLoading ];
    
    NSString *ClientCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    NSString *UserrefCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    //NSString *playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    NSString *usercode = [[NSUserDefaults standardUserDefaults]stringForKey:@"UserCode"];
    
    
    NSString *playerCode;
    if([AppCommon isCoach])
    {
        
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedPlayerCode"];
    }
    else
    {
        playerCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"Userreferencecode"];
    }
    
    
    
    
    if([self.bodyWeightTxt.text isEqualToString:@""] || [self.bodyWeightTxt.text isEqual:[NSNull null]])
    {
        self.bodyWeightTxt.text =@"0";
    }
    if([self.sleepHrTxt.text isEqualToString:@""] || [self.sleepHrTxt.text isEqual:[NSNull null]])
    {
        self.sleepHrTxt.text =@"0";
    }
    
    if([self.sleepMinTxt.text isEqualToString:@""] || [self.sleepMinTxt.text isEqual:[NSNull null]])
    {
        self.sleepMinTxt.text =@"0";
    }
    
    if([self.fatTxt.text isEqualToString:@""] || [self.fatTxt.text isEqual:[NSNull null]] )
    {
        self.fatTxt.text =@"0";
    }
    
    if([self.restingHrTxt.text isEqualToString:@""] || [self.restingHrTxt.text isEqual:[NSNull null]])
    {
        self.restingHrTxt.text =@"0";
    }
    
    if([self.restingBpMaxTxt.text isEqualToString:@""] || [self.restingBpMaxTxt.text isEqual:[NSNull null]])
    {
        self.restingBpMaxTxt.text =@"0";
    }
    
    if([self.restingBpMinTxt.text isEqualToString:@""] || [self.restingBpMinTxt.text isEqual:[NSNull null]])
    {
        self.restingBpMinTxt.text =@"0";
    }
    
    if([urineColorNum isEqualToString:@""] || [urineColorNum isEqual:[NSNull null]])
    {
        urineColorNum =@"0";
    }
    
    int sleepHour = [self.sleepHrTxt.text intValue];
    int sleepMintues = [self.sleepMinTxt.text intValue];
    
    int totalSleepCount = (sleepHour*60)+sleepMintues;
    
    NSString *sleepHRtotalSting = [NSString stringWithFormat:@"%d",totalSleepCount];
    
    [objWebservice UpdateWellness  :updateRecord :ClientCode :usercode :FetchedWorkLoadCode :SelectedDate:playerCode:metaSubCode1:metaSubCode2:metaSubCode3:metaSubCode4 :self.bodyWeightTxt.text : sleepHRtotalSting : self.fatTxt.text : self.restingHrTxt.text : self.restingBpMaxTxt.text :self.restingBpMinTxt.text:urineColorNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            BOOL Status = [responseObject valueForKey:@"Status"];
            if(Status == YES)
            {
                NSLog(@"success");
                [self ShowAlterMsg:@"Wellness Rating Updated Successfully"];
                //[self.view removeFromSuperview];
                //[self.Delegate closeWellnessSource];
                //[appDel.frontNavigationController popViewControllerAnimated:YES];
                
//                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:300];
//
//                UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
//                [alert showCustom:self image:[UIImage imageNamed:@"Wellness"] color:color title:@"Wellness" subTitle:@"Updated Successfully" closeButtonTitle:@"OK" duration:10.0f];
              
            
            if([self.isFromHome isEqualToString:@"NO"])
                {
                
                    [self.view removeFromSuperview];
                    [self.Delegate closeWellnessSource];
                }
            else
                {
                
                    [appDel.frontNavigationController popViewControllerAnimated:YES];
                }
            
                
            }
            
        }
        
        [AppCommon hideLoading];
        
        
        
    }
                    failure:^(AFHTTPRequestOperation *operation, id error) {
                        NSLog(@"failed");
                        [COMMON webServiceFailureError:error];
                    }];
    
}



-(void)metacodeWebservice
{
    
    [AppCommon showLoading];
    NSString *cliendcode = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClientCode"];
    
    NSString *Rc=@"RC14";
    
    
    
    [objWebservice getmetacodelist :metasubKey :cliendcode :Rc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        if(responseObject >0)
        {
            self.sleeplist = [[NSMutableArray alloc]init];
            self.fatiqlist = [[NSMutableArray alloc]init];
            self.sorelist = [[NSMutableArray alloc]init];
            self.stresslist = [[NSMutableArray alloc]init];
            
            
            self.sleeplist = [responseObject valueForKey:@"Sleeps"];
            self.fatiqlist = [responseObject valueForKey:@"Fatigues"];
            self.sorelist = [responseObject valueForKey:@"MuscleSoreNesses"];
            self.stresslist = [responseObject valueForKey:@"Stresses"];
            
            self.sleeplist1 = ([[self.sleeplist valueForKey:@"MetaSubCode"] isEqual:[NSNull null]])?@"":[self.sleeplist valueForKey:@"MetaSubCode"];
            
            self.fatiqlist1 = ([[self.fatiqlist valueForKey:@"MetaSubCode"] isEqual:[NSNull null]])?@"":[self.fatiqlist valueForKey:@"MetaSubCode"];
            
            self.sorelist1 = ([[self.sorelist valueForKey:@"MetaSubCode"] isEqual:[NSNull null]])?@"":[self.sorelist valueForKey:@"MetaSubCode"];
            
            self.stresslist1 = ([[self.stresslist valueForKey:@"MetaSubCode"] isEqual:[NSNull null]])?@"":[self.stresslist valueForKey:@"MetaSubCode"];
            [self setFetch];
            
        }
        [AppCommon hideLoading];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"failed");
        [AppCommon hideLoading];
        [COMMON webServiceFailureError:error];
    }];
   
}

-(void)setFetch
{
    
    
    if([self.isFetch isEqualToString:@"yes"])
    {
        NSString *sleepValue = [self.fetchArray valueForKey:@"SleepRatingDescription"];
        NSArray *component = [sleepValue componentsSeparatedByString:@" "];
        
        NSString *fatiqueRating = [self.fetchArray valueForKey:@"FatigueRatingDescription"];
        NSArray *component1 = [fatiqueRating componentsSeparatedByString:@" "];
        
        NSString *muscleRating = [self.fetchArray valueForKey:@"SoreNessRatingDescription"];
        NSArray *component2 = [muscleRating componentsSeparatedByString:@" "];
        
        NSString *stressRating = [self.fetchArray valueForKey:@"StressRatingDescription"];
        NSArray *component3 = [stressRating componentsSeparatedByString:@" "];
        
        
        self.sleepSlider.value =[component[0] intValue];
        self.fatiqueSlider.value =[component1[0] intValue];
        self.muscleSlider.value =[component2[0] intValue];
        self.stressSlider.value =[component3[0] intValue];
        
        [self SleepSliderAction:0];
        [self FatiqueSliderAction:0];
        [self MuscleSliderAction:0];
        [self StressSliderAction:0];
        
        if(self.sleepSlider.value ==1)
        {
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:0];
            
        }
        if(self.sleepSlider.value ==2)
        {
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:1];
            
        }
        
        if(self.sleepSlider.value ==3)
        {
            
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:2];
            
        }
        
        if(self.sleepSlider.value ==4)
        {
            
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:3];
            
        }
        
        if(self.sleepSlider.value ==5)
        {
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:4];
            
        }
        if(self.sleepSlider.value ==6)
        {
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:5];
            
        }
       if(self.sleepSlider.value ==7)
        {
            
            metaSubCode1 = [self.sleeplist1 objectAtIndex:6];
            
        }
        
        
        
        
        if(self.fatiqueSlider.value ==1)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:0];
            
        }
        if(self.fatiqueSlider.value ==2)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:1];
            
        }
        if(self.fatiqueSlider.value ==3)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:2];
            
        }
        if(self.fatiqueSlider.value ==4)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:3];
            
        }
        if(self.fatiqueSlider.value ==5)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:4];
            
        }
        if(self.fatiqueSlider.value ==6)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:5];
            
        }
        if(self.fatiqueSlider.value ==7)
        {
            
            metaSubCode2 = [self.fatiqlist1 objectAtIndex:6];
            
        }
        
        
        
        
        if(self.muscleSlider.value ==1)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:0];
            
        }
        if(self.muscleSlider.value ==2)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:1];
            
        }
        if(self.muscleSlider.value ==3)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:2];
            
        }
        if(self.muscleSlider.value ==4)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:3];
            
        }
        if(self.muscleSlider.value ==5)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:4];
            
        }
        if(self.muscleSlider.value ==6)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:5];
            
        }
        if(self.muscleSlider.value ==7)
        {
            
            metaSubCode3 = [self.sorelist1 objectAtIndex:6];
            
        }
        
        
        
        
        if(self.stressSlider.value ==1)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:0];
            
        }
        if(self.stressSlider.value ==2)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:1];
            
        }
        if(self.stressSlider.value ==3)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:2];
            
        }
        if(self.stressSlider.value ==4)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:3];
            
        }
        if(self.stressSlider.value ==5)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:4];
            
        }
        if(self.stressSlider.value ==6)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:5];
            
        }
        if(self.stressSlider.value ==7)
        {
            
            metaSubCode4 = [self.stresslist1 objectAtIndex:6];
            
        }
        
        
        
        NSString *urineColor = [self.fetchArray valueForKey:@"URINECOLOUR"];
        if([urineColor isEqualToString:@"1"])
        {
            [self.UrineColorBtn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([urineColor isEqualToString:@"2"])
        {
            [self.UrineColorBtn2 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([urineColor isEqualToString:@"3"])
        {
            [self.UrineColorBtn3 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([urineColor isEqualToString:@"4"])
        {
            [self.UrineColorBtn4 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([urineColor isEqualToString:@"5"])
        {
            [self.UrineColorBtn5 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([urineColor isEqualToString:@"6"])
        {
            [self.UrineColorBtn6 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([urineColor isEqualToString:@"7"])
        {
            [self.UrineColorBtn7 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        if(![[self.fetchArray valueForKey:@"BodyWeight"] isEqualToString:@"0"])
        {
        self.bodyWeightTxt.text = [self.fetchArray valueForKey:@"BodyWeight"];
        }
        else
        {
            self.bodyWeightTxt.text = @"";
        }
        
        int sleepHour = [[self.fetchArray valueForKey:@"SleepHours"] intValue];
        
        if(sleepHour >60 && sleepHour != 0)
        {
            
            float splittedvalue = sleepHour/60;
            
            NSString *totalTime = [NSString stringWithFormat:@"%f.",splittedvalue];
            NSArray *arr = [totalTime componentsSeparatedByString:@"."];
            self.sleepHrTxt.text = arr[0];
            
            int hoursCount = [arr[0] intValue];
            int totalhours = hoursCount*60;
            int minutes = sleepHour-totalhours;
            NSString *totalMinutes = [NSString stringWithFormat:@"%d",minutes];
            self.sleepMinTxt.text = totalMinutes;
            
            
            
        }
        else
        {
            if(![[self.fetchArray valueForKey:@"SleepHours"] isEqualToString:@"0"])
            {
                self.sleepMinTxt.text = [self.fetchArray valueForKey:@"SleepHours"];
                self.sleepHrTxt.text = @"0";
            }
            else
            {
                self.sleepHrTxt.text = @"0";
            }
            
        }
        
    
        
        if(![[self.fetchArray valueForKey:@"Fat"] isEqualToString:@"0"])
        {
            self.fatTxt.text = [self.fetchArray valueForKey:@"Fat"];
        }
        else
        {
            self.fatTxt.text = @"";
        }
        
        
        
        if(![[self.fetchArray valueForKey:@"RestingGHR"] isEqualToString:@"0"])
        {
            self.restingHrTxt.text = [self.fetchArray valueForKey:@"RestingGHR"];
        }
        else
        {
            self.restingHrTxt.text = @"";
        }
        
        
        if(![[self.fetchArray valueForKey:@"RestingBPMAX"] isEqualToString:@"0"])
        {
            self.restingBpMaxTxt.text = [self.fetchArray valueForKey:@"RestingBPMAX"];
        }
        else
        {
            self.restingBpMaxTxt.text = @"";
        }
        
        if(![[self.fetchArray valueForKey:@"RestingBPMIN"] isEqualToString:@"0"])
        {
            self.restingBpMinTxt.text = [self.fetchArray valueForKey:@"RestingBPMIN"];
        }
        else
        {
            self.restingBpMinTxt.text = @"";
        }
        
        
//        self.sleepHrTxt.text = [self.fetchArray valueForKey:@"SleepHours"];
//        self.fatTxt.text = [self.fetchArray valueForKey:@"Fat"];
//        self.restingHrTxt.text = [self.fetchArray valueForKey:@"RestingGHR"];
//        self.restingBpMaxTxt.text = [self.fetchArray valueForKey:@"RestingBPMAX"];
//        self.restingBpMinTxt.text = [self.fetchArray valueForKey:@"RestingBPMIN"];
        
        
        NSString *datee = [self.fetchArray valueForKey:@"WorkLoadDate"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSDate *matchdate = [dateFormat dateFromString:datee];
        self.datelbl.text = [dateFormat stringFromDate:matchdate];
        
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"MM-dd-yyyy"];
        NSDate *matchdate1 = [dateFormat dateFromString:datee];
        fetchedDate = [dateFormat1 stringFromDate:matchdate1];
        
        
        FetchedWorkLoadCode = [self.fetchArray valueForKey:@"WorkLoadCode"];
        
        self.SaveBtn.hidden = YES;
        self.UpdateBtn.hidden = NO;
        
        
    }
}
-(void)ShowAlterMsg:(NSString*) MsgStr
{
    UIAlertView *objAlter =[[UIAlertView alloc]initWithTitle:@"" message:MsgStr delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [objAlter show];
    
}

- (IBAction)submitAction:(id)sender {
    
   
     if([self.datelbl.text isEqualToString:@""])
    {
        [self ShowAlterMsg:@"Please Select Date"];
    }
    else if(self.sleepSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select Sleep"];
    }
    else if(self.fatiqueSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select Fatique"];
    }
    else if(self.muscleSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select MuscleSoreness"];
    }
    else if(self.stressSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select Stress"];
    }
    else
    {
        [self SaveWebservice];
        
        self.sleepSlider.value =0;
        self.fatiqueSlider.value =0;
        self.muscleSlider.value =0;
        self.stressSlider.value =0;
        
        [self SleepSliderAction:0];
        [self FatiqueSliderAction:0];
        [self MuscleSliderAction:0];
        [self StressSliderAction:0];
        
        self.datelbl.text = @"";
        
    }
    
}

- (IBAction)UpdateAction:(id)sender {
    
    
//    if([self.datelbl.text isEqualToString:@""])
//    {
//        [self ShowAlterMsg:@"Please Select Date"];
//    }
     if(self.sleepSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select Sleep"];
    }
    else if(self.fatiqueSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select Fatique"];
    }
    else if(self.muscleSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select MuscleSoreness"];
    }
    else if(self.stressSlider.value ==0)
    {
        [self ShowAlterMsg:@"Please Select Stress"];
    }
    else
    {
        [self UpdateWebservice];
        
        self.sleepSlider.value =0;
        self.fatiqueSlider.value =0;
        self.muscleSlider.value =0;
        self.stressSlider.value =0;
        
        [self SleepSliderAction:0];
        [self FatiqueSliderAction:0];
        [self MuscleSliderAction:0];
        [self StressSliderAction:0];
        
        self.datelbl.text = @"";
        
    }
    
}

- (IBAction)SleepSliderAction:(id)sender {
    
    NSLog(@"%.f",self.sleepSlider.value);
    // value1 = [NSString stringWithFormat:@"%.f",self.sleepSlider.value];
    
    num1 = [self.sleepSlider value];
    
    NSLog(@"%f",num1);
    
    if(num1 ==0)
    {
        
    }
    
    if(num1 >0.1 && num1 <=1 )
    {
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:0];
        
        
    }
    if(num1 >1.1 && num1 <= 2)
    {
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:1];
        
    }
    
    if(num1 >2.1 && num1 <= 3)
    {
        
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:2];
        
    }
    
    if(num1 > 3.1 && num1 <= 4 )
    {
        
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:3];
        
    }
    
    if(num1 >4.1 && num1 <= 5 )
    {
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:4];
        
    }
    if(num1 >5.1 && num1 <= 6)
    {
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:5];
        
    }
    if(num1 >6.1 && num1 <= 7)
    {
        
        metaSubCode1 = [self.sleeplist1 objectAtIndex:6];
        
    }
    
    
    
    self.SleepRatinglbl.text = [NSString stringWithFormat:@"%d/7",(int)self.sleepSlider.value];
    
}

- (IBAction)FatiqueSliderAction:(id)sender {
    
    
    num2 = [self.fatiqueSlider value];
    
    
    NSLog(@"%f",num2);
    
    if(num2 ==0)
    {
        
    }
    
    if(num2 >0.1 && num2 <=1 )
    {
        
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:0];
        
        
    }
    if(num2 >1.1 && num2 <= 2)
    {
        
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:1];
        
    }
    
    if(num2 >2.1 && num2 <= 3)
    {
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:2];
        
    }
    
    if(num2 > 3.1 && num2 <= 4 )
    {
        
        
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:3];
        
    }
    
    if(num2 >4.1 && num2 <= 5 )
    {
        
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:4];
        
    }
    if(num2 >5.1 && num2 <= 6)
    {
        
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:5];
        
    }
    if(num2 >6.1 && num2 <= 7)
    {
        
        metaSubCode2 = [self.fatiqlist1 objectAtIndex:6];
        
    }
    
    self.FatiqueRatinglbl.text = [NSString stringWithFormat:@"%d/7",(int)self.fatiqueSlider.value];
    
    
    
}

- (IBAction)MuscleSliderAction:(id)sender {
    
    
    num3 = [self.muscleSlider value];
    NSLog(@"%f",num2);
    
    if(num3 ==0)
    {
        
    }
    
    if(num3 >0.1 && num3 <=1 )
    {
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:0];
        
    }
    if(num3 >1.1 && num3 <= 2)
    {
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:1];
        
    }
    
    if(num3 >2.1 && num3 <= 3)
    {
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:2];
        
    }
    
    if(num3 > 3.1 && num3 <= 4 )
    {
        
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:3];
        
    }
    
    if(num3 >4.1 && num3 <= 5 )
    {
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:4];
        
    }
    if(num3 >5.1 && num3 <= 6)
    {
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:5];
        
    }
    if(num3 >6.1 && num3 <= 7)
    {
        
        metaSubCode3 = [self.sorelist1 objectAtIndex:6];
        
    }
    
    
    self.MuscleRatinglbl.text = [NSString stringWithFormat:@"%d/7",(int)self.muscleSlider.value];
    
}

- (IBAction)StressSliderAction:(id)sender {
    
    num4 = [self.stressSlider value];
    NSLog(@"%f",num4);
    
    if(num4 ==0)
    {
        
    }
    
    if(num4 >0.1 && num4 <=1 )
    {
        
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:0];
        
        
        
        
    }
    if(num4 >1.1 && num4 <= 2)
    {
        
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:1];
        
    }
    
    if(num4 >2.1 && num4 <= 3)
    {
        
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:2];
        
    }
    
    if(num4 > 3.1 && num4 <= 4 )
    {
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:3];
        
    }
    
    if(num4 >4.1 && num4 <= 5 )
    {
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:4];
        
    }
    if(num4 >5.1 && num4 <= 6)
    {
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:5];
        
    }
    if(num4 >6.1 && num4 <= 7)
    {
        
        metaSubCode4 = [self.stresslist1 objectAtIndex:6];
        
    }
     self.StressRatinglbl.text = [NSString stringWithFormat:@"%d/7",(int)self.stressSlider.value];
    
}




@end
