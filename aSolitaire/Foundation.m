//
//  Foundation.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Foundation.h"
#import "Constants.h"
#import "DeviceConfig.h"
#import "GameLayer.h"
#import "CommonHelper.h"

@implementation Foundation
@synthesize suit;

-(id) initWithIndex:(int)idx
{
    if (self = [super init]) {
        suit = kDummy;
        origin = [[DeviceConfig sharedDeviceConfig] foundationOrigin:idx];
        offset = CGSizeMake(0, 0);
        cards = [[CCArray alloc] initWithCapacity:13];
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

-(BOOL) card:(Reserve*)reserve canDropAtPoint:(CGPoint)point
{
    if (cards.count > 0) {
        Card *lastCard = [cards lastObject];
        if ([CommonHelper rect:[lastCard boundingBox] MostContainRect:reserve.dragHolder.boundingBox]) {
            if (lastCard.suit == reserve.clickCard.suit && lastCard.number == reserve.clickCard.number - 1) {
                return YES;
            }
        }
    } else if (cards.count == 0){
        if ([CommonHelper rect:[placeHolder boundingBox] MostContainRect:reserve.dragHolder.boundingBox]) {
            if (reserve.clickCard.number == kAce) {
                return YES;
            }
        }
    }
    return NO;
}

-(CGPoint) nextDropPoint
{
    return placeHolder.position;
}

-(void) dragStart
{
    if (cards.count == 0) {
        self.suit = kDummy;
    }
}
-(void) dropEnd
{
}

@end
