//
//  CustomTextField.m
//  APT_V2
//
//  Created by MAC on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(NSString *)getText
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self.text stringByTrimmingCharactersInSet:whitespace];
    
    self.text = [trimmed stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    return self.text;
}

@end
