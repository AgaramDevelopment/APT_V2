//
//  InjurySelectionViewController.h
//  APT_V2
//
//  Created by user on 23/02/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"


//#import <UIKit/UIKit.h>
//IB_DESIGNABLE
//@interface cBtn : UIView
//@property (nonatomic,assign) IBInspectable NSString* injuryCode;
//@end


@protocol InjuryDelegate < NSObject>

-(void)didFinishPickedWithInjryLocationWithOptions:(NSArray* )options;
@end

@interface InjurySelectionViewController : UIViewController
@property (nonatomic,assign) IBInspectable NSString* injuryCode;
@property (nonatomic,strong) id<InjuryDelegate> injuryDelegate;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
- (IBAction)injurySelectionAction:(CustomButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *FrontView;
@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) NSMutableArray* injuryCodeArray;
@property (strong, nonatomic) NSMutableArray* selectedImageArray;
- (IBAction)actionFlipSelection:(id)sender;
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *Buttons;

@end
