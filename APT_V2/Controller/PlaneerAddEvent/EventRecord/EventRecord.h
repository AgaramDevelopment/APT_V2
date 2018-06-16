//
//  EventRecord.h
//  AlphaProTracker
//
//  Created by Mac on 06/11/17.
//  Copyright © 2017 agaraminfotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventRecord : NSObject

@property (nonatomic, strong) NSString *stringCustomerName;
@property (nonatomic, strong) NSNumber *numCustomerID;
@property (nonatomic, strong) NSDate *dateDay;
@property (nonatomic, strong) NSDate *EnddateDay;
@property (nonatomic, strong) NSDate *dateTimeBegin;
@property (nonatomic, strong) NSDate *dateTimeEnd;
@property (nonatomic, strong) NSMutableArray *arrayWithGuests;

@property (nonatomic, strong) NSString *color;

@end
