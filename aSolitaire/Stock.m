//
//  Stock.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stock.h"
#import "GameLayer.h"
#import "Card.h"
#import "DeviceConfig.h"

@implementation Stock

-(id) init
{
    if (self = [super init]) {
        origin = [[DeviceConfig sharedDeviceConfig] stockOrigin];
        offset = CGSizeMake(0, 0);
        cards = [[CCArray alloc] initWithCapacity:13*4-1-2-3-4-5-6-7];
        [placeHolder setPosition:origin];
    }
    return self;
}

-(void)dealloc
{
    [cards release];
    [super dealloc];
}

-(BOOL) rectContainPoint:(CGPoint)point
{
    return CGRectContainsPoint([placeHolder boundingBox], point);
}

-(CCArray*) popCards:(NSInteger)number
{
    if (cards.count == 0) {
        return nil;
    }
    CCArray *array = [CCArray arrayWithCapacity:number];
    for (NSInteger i=0; i<number; i++) {
        if (cards.count == 0) {
            break;
        }
        Card *card = [cards lastObject];
        [array addObject:card];
        [cards removeLastObject];
    }
    return array;
}

-(CGPoint) nextDropPoint
{
    return placeHolder.position;
}

@end
