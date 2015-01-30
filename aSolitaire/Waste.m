//
//  Waste.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Waste.h"
#import "GameLayer.h"
#import "DeviceConfig.h"


@implementation Waste

-(id) init
{
    if (self = [super init]) {
        origin = [[DeviceConfig sharedDeviceConfig] wasteOrigin];
        offset = [[DeviceConfig sharedDeviceConfig] wasteOffset];
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


-(Card*) cardClickAtPoint:(CGPoint)point
{
    if (cards.count == 0) {
        return nil;
    }
    if(CGRectContainsPoint([[cards lastObject] boundingBox], point))
    {
        return [cards lastObject];
    }
    return nil;
}

-(CGPoint) cardOrigin:(NSInteger)number
{
    return ccp(origin.x + offset.width * number, origin.y + offset.height * number);
}

-(CCArray*) popAllCards
{
    if (cards.count == 0) {
        return nil;
    }
    CCArray *array = [CCArray arrayWithArray:cards];
    [cards removeAllObjects];
    return array;
}

-(CGPoint) nextDropPoint
{
    if (cards.count == 0) {
        return placeHolder.position;
    }
    Card* card = [cards lastObject];
    return ccp(card.position.x + offset.width, card.position.y + offset.height);
}

-(void) noOffset
{
    offset = CGSizeMake(0, 0);
}

@end
