//
//  InjurySelectionViewController.m
//  APT_V2
//
//  Created by user on 23/02/18.
//  Copyright © 2018 user. All rights reserved.
//

/*
 #import <UIKit/UIKit.h>
 IB_DESIGNABLE
 @interface LOLView : UIView
 @property (nonatomic) IBInspectable UIColor *someColor;
 @end
 */

#import "InjurySelectionViewController.h"
#import "UIImage+GetPoints.h"

@interface InjurySelectionViewController ()
{
    CALayer *blueLayer;
    CALayer *redLayer;
    CALayer *yellowLayer;
    CALayer *greenLayer;
    NSArray* tagArray;
    NSDictionary* injuryCodeDict;
}

@end

@implementation InjurySelectionViewController

@synthesize FrontView,BackView,Buttons,injuryDelegate;

@synthesize injuryCodeArray,selectedImageArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"injury" ofType:@"json"];
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    NSError* error;
    NSDictionary* dict;
    
    @try{
        injuryCodeDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingAllowFragments error:&error];

    }
    @catch(NSException *exception){
        NSLog(@"exeception %@",exception.reason);
        NSLog(@"error %@",error.description);
        
    }
    
    injuryCodeArray = [NSMutableArray new];
    
    
    for (CustomButton* temp in Buttons) {
        [temp addTarget:self action:@selector(multipleTap:andEvents:) forControlEvents:UIControlEventTouchDownRepeat];
        [temp addTarget:self action:@selector(multipleTap:andEvents:) forControlEvents:UIControlEventTouchDown];
        NSString* strTag = [NSString stringWithFormat:@"%ld",(long)[temp tag]];
        [temp setInjuryCode:[injuryCodeDict valueForKey:strTag]];
    }

    if (selectedImageArray.count) {
        [injuryCodeArray addObjectsFromArray:selectedImageArray];
        [self loadSelectedImages];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadSelectedImages{
    
    for (NSString* injuryCode in [selectedImageArray valueForKey:@"InjuryLocationCode"]) {
        for (CustomButton* temp in Buttons) {
            if ([injuryCode isEqualToString:temp.injuryCode]) {
                NSString* imgName = [NSString stringWithFormat:@"%ld-%@",[temp tag],temp.injuryCode];
                [temp setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(IBAction)multipleTap:(CustomButton *)sender andEvents:(UIEvent *)event{
    UITouch* touch = [[[event allTouches] allObjects] firstObject];
    
    if (touch.tapCount == 2) {
        NSLog(@"double tap");
        [self multiTouch:sender];
    }
    else if (touch.tapCount == 1){
        NSLog(@"single tap");
        [self singleTouch:sender];
    }
}

- (void)singleTouch:(CustomButton *)sender {
    
    NSString* str = [NSString stringWithFormat:@"%ld",(long)[sender tag]];
    NSString* InjuryLocationCode = [injuryCodeDict valueForKey:str];

//    id selectedObject = @{@"InjuryLocationCode" :   InjuryLocationCode,
//                          @"InjurySiteCode"     :   @"MSC165",
//                          @"buttonTag"          :   str
//                          };
    
    id selectedObject = @{@"InjuryLocationCode" :   sender.injuryCode,
                          @"InjurySiteCode"     :   @"MSC165"
                          };

    NSUInteger selctedIndex = [[injuryCodeArray valueForKey:@"InjuryLocationCode"] indexOfObject:InjuryLocationCode];

    NSLog(@"injurySelectionAction called");
    if ([sender currentImage]) {
        
        if([[[injuryCodeArray valueForKey:@"InjurySiteCode"] objectAtIndex:selctedIndex]isEqualToString:@"MSC167"]){
            [injuryCodeArray removeObjectAtIndex:selctedIndex];
            [injuryCodeArray addObject:selectedObject];
            
        }else{
            NSLog(@"DE SELECT");
            [sender setImage:nil forState:UIControlStateNormal];
            [injuryCodeArray removeObjectAtIndex:selctedIndex];
        }

        
    }
    else {
        
        NSLog(@"SELECT");//file name  "Human outline-25.png"
        NSString* imgName = [NSString stringWithFormat:@"%ld-%@",[sender tag],sender.injuryCode];
        [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        if([[injuryCodeArray valueForKey:@"InjuryLocationCode"]containsObject:InjuryLocationCode]){
            [injuryCodeArray removeObjectAtIndex:selctedIndex];
        }
        [injuryCodeArray addObject:selectedObject];

    }
    
}
- (void)multiTouch:(CustomButton *)sender {
    
    
    NSString* str = [NSString stringWithFormat:@"%ld",(long)[sender tag]];
    NSString* InjuryLocationCode = [injuryCodeDict valueForKey:str];
    
    
//    id selectedObject = @{@"InjuryLocationCode" : [injuryCodeDict valueForKey:str],
//                          @"InjurySiteCode"     : @"MSC167",
//                          @"buttonTag"          : str
//                          };
    
    id selectedObject = @{@"InjuryLocationCode" : sender.injuryCode,
                          @"InjurySiteCode"     : @"MSC167"
                          };


    if ([[injuryCodeArray valueForKey:@"InjuryLocationCode"] containsObject:InjuryLocationCode]) {
        
        NSUInteger selctedIndex = [[injuryCodeArray valueForKey:@"InjuryLocationCode"] indexOfObject:InjuryLocationCode];
//        [injuryCodeArray replaceObjectAtIndex:selectedObject withObject:selectedObject];
        [injuryCodeArray removeObjectAtIndex:selctedIndex];
        [sender setImage:nil forState:UIControlStateNormal];

    }
    else if(![injuryCodeArray containsObject:selectedObject]){
        
        NSString* imgName = [NSString stringWithFormat:@"%ld-%@",[sender tag],sender.injuryCode];
        [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [injuryCodeArray addObject:selectedObject];
    }
    

}



- (IBAction)actionFlipSelection:(id)sender {
    
    if (![sender tag]) {
        // show Back side
        self.BackView.frame = CGRectMake(0, 0, FrontView.frame.size.width, FrontView.frame.size.height);
        [FrontView addSubview:self.BackView];
    }
    else // show front side
    {
        [self.BackView removeFromSuperview];
    }
}

- (IBAction)actionDone:(id)sender {
    
    [appDel.frontNavigationController dismissViewControllerAnimated:YES completion:^{
        [injuryDelegate didFinishPickedWithInjryLocationWithOptions:injuryCodeArray];
    }];
    
}




@end
