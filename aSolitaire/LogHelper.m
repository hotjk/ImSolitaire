//
//  LogHelper.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LogHelper.h"

@implementation LogHelper

static NSString* kCardColors = @"♤♡♧♢";
static NSString* kCardNumbers = @"_A234567890JQK";

+(void)printCards:(CCArray *)cards withTitle:(NSString *)title
{
    NSMutableString *string = [NSMutableString stringWithCapacity:200];
    [string appendString:title];
    Card *card;
    CCARRAY_FOREACH(cards, card)
    {
        [string appendFormat:@"%@%@ ", 
         [kCardColors substringWithRange:NSMakeRange(card.cColor, 1)], 
         [kCardNumbers substringWithRange:NSMakeRange(card.number, 1)]];
    }
    NSLog(@"%@", string);
}

@end
