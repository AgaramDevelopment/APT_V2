//
//  FFMonthCell.m
//  FFCalendar
//
//  Created by Felipe Rocha on 14/02/14.
//  Copyright (c) 2014 Fernanda G. Geraissate. All rights reserved.
//
//  http://fernandasportfolio.tumblr.com
//

#import "FFMonthCell.h"
#import "AppCommon.h"
#import "FFButtonWithEditAndDetailPopoversForMonthCell.h"
#import "FFImportantFilesForCalendar.h"

@interface FFMonthCell () <FFButtonWithEditAndDetailPopoversForMonthCellProtocol>
@property (nonatomic, strong) NSMutableArray *arrayButtons;
@end

@implementation FFMonthCell

#pragma mark - Synthesize

@synthesize protocol;
@synthesize arrayButtons;
@synthesize arrayEvents;
@synthesize labelDay;
@synthesize imageViewCircle;
@synthesize EventNamelbl;

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initLayout {
    
    if (!imageViewCircle) {
        imageViewCircle = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-32.-3., 3., 32., 32.)];
        [imageViewCircle setAutoresizingMask:AR_LEFT_BOTTOM];
        [self addSubview:imageViewCircle];
        
        labelDay = [[UILabel alloc] initWithFrame:CGRectMake((imageViewCircle.frame.size.width-20.)/2., (imageViewCircle.frame.size.height-20.)/2., 30., 20.)];
        [labelDay setAutoresizingMask:AR_LEFT_BOTTOM];
        [labelDay setTextAlignment:NSTextAlignmentLeft];
        [imageViewCircle addSubview:labelDay];
        
//        EventNamelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewCircle.frame.size.width+2, self.frame.size.width, self.frame.size.height-20)];
//        [EventNamelbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
//        [EventNamelbl setText:@""];
//        [EventNamelbl setNumberOfLines:10];
//        [EventNamelbl setAutoresizingMask:AR_LEFT_BOTTOM];
//        [EventNamelbl setTextAlignment:NSTextAlignmentCenter];
//        [self addSubview:EventNamelbl];
        
    }
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.labelDay setText:@""];
    [self.labelDay setTextColor:[UIColor blackColor]];
    [self.imageViewCircle setImage:nil];
    
    for (UIButton *button in arrayButtons) {
        [button removeFromSuperview];
    }
}

#pragma mark - Custom Layouts

- (void)markAsWeekend {
    
    [self setBackgroundColor:[UIColor lighterGrayCustom]];
    [self.labelDay setTextColor:[UIColor grayColor]];
}

- (void)markAsCurrentDay {
    
    [self.labelDay setTextColor:[UIColor whiteColor]];
    [self.imageViewCircle setImage:[UIImage imageNamed:@"redCircle"]];
}

#pragma mark - Showing Events

- (void)setArrayEvents:(NSMutableArray *)_array {
    NSLog(@"FFMONTH CELL setArrayEvents called");
    arrayEvents = _array;
    arrayButtons = [NSMutableArray new];
//        [self setBackgroundColor:[UIColor blueColor]];
    
    if ([arrayEvents count] > 0) {
        FFEvent *event = [arrayEvents objectAtIndex:0];
        NSLog(@"DATE %@ ",event.color);
        [self setBackgroundColor:[AppCommon colorWithHexString:event.color]];
        

        int maxNumOfButtons = 4;
        CGFloat yFirstButton = imageViewCircle.frame.origin.y+imageViewCircle.frame.size.height;
        CGFloat height = (self.frame.size.height-yFirstButton)/maxNumOfButtons;

        int buttonOfNumber = 0;
        for (int i = 0; i < [arrayEvents count] ; i++) {
            buttonOfNumber++;
            FFButtonWithEditAndDetailPopoversForMonthCell *button = [[FFButtonWithEditAndDetailPopoversForMonthCell alloc] initWithFrame:CGRectMake(0, yFirstButton+(buttonOfNumber-1)*height, self.frame.size.width, height)];
            [button setAutoresizingMask:AR_TOP_BOTTOM | UIViewAutoresizingFlexibleWidth];
            [self addSubview:button];
            [arrayButtons addObject:button];

            if ((buttonOfNumber == maxNumOfButtons) && ([arrayEvents count] - maxNumOfButtons > 0)) {
                [button setTitle:[NSString stringWithFormat:@"%lu more...", (long)[arrayEvents count] - maxNumOfButtons] forState:UIControlStateNormal];
                [button setUserInteractionEnabled:NO];
                break;
            } else {
                FFEvent *event = [arrayEvents objectAtIndex:i];
                [button setTitle:event.stringCustomerName forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setUserInteractionEnabled:NO];
                //[button setEvent:event];
                [button setProtocol:self];
            }
        }
    }
}

#pragma mark - FFButtonWithEditAndDetailPopoversForMonthCell Protocol

- (void)saveEditedEvent:(FFEvent *)eventNew ofButton:(UIButton *)button {
    
    long i = [arrayButtons indexOfObject:button];
    
    if (protocol != nil && [protocol respondsToSelector:@selector(saveEditedEvent:ofCell:atIndex:)]) {
        [protocol saveEditedEvent:eventNew ofCell:self atIndex:i];
    }
}

- (void)deleteEventOfButton:(UIButton *)button {
    
    long i = [arrayButtons indexOfObject:button];
    
    if (protocol != nil && [protocol respondsToSelector:@selector(deleteEventOfCell:atIndex:)]) {
        [protocol deleteEventOfCell:self atIndex:i];
    }
}

@end
