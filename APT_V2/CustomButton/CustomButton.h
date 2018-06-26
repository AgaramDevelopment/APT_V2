//
//  CustomButton.h
//  sampleTable
//
//  Created by user on 07/01/18.
//  Copyright © 2018 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (readwrite) NSInteger secondTag;
@property (strong,nonatomic) NSString* SelctedDate;
@property (strong,nonatomic) NSString* SelctedCode;
@property (strong,atomic) NSString* injuryCode;

@end
