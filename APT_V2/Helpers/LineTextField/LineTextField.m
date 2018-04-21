//
//  LineTextField.m
//  AUIAutoGrowingTextView
//
//  Created by user on 03/02/18.
//  Copyright © 2018 adamsiton. All rights reserved.
//

#import "LineTextField.h"

@implementation LineTextField
@synthesize selectedCode,button;

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self setup];
//    }
//    
//    return self;
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setup];
//    }
//    
//    return self;
//}
//
//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self layoutSubviews];
////        self = [super initWithFrame:[self frame]];
//        [self setup];
//    }
//    return self;
//}

-(void)setup
{
    UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/3, self.frame.size.height/3, self.frame.size.height/3)];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    [view setImage:[UIImage imageNamed:@"down-arrow"]];
    self.rightView = view;
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self underLine];
    [self setBorderStyle:UITextBorderStyleNone];
    self.clipsToBounds = YES;
    button.frame = self.frame;
    button.backgroundColor = [UIColor redColor];

}

-(void)underLine
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, 1);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self changePlaceHolderSize:5];
    return [self.delegate textFieldShouldBeginEditing:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    [self changePlaceHolderSize:15];

    return [self.delegate textFieldShouldReturn:textField];
}

-(void)changePlaceHolderSize:(CGFloat)size
{
    [self setFont:[UIFont fontWithName:@"Helvetica" size:size]];
}
@end
