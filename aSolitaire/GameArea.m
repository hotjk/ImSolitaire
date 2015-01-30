//
//  GameArea.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameArea.h"
#import "Constants.h"


@implementation GameArea

@synthesize origin;
@synthesize cards;
@synthesize placeHolder;
@synthesize offset;

-(id) init
{
    if (self = [super init]) {
        NSString *phfile = [NSString stringWithFormat:kCardPlaceHolderTextureName, arc4random()%4];
        placeHolder = [[CCSprite alloc] initWithSpriteFrameName:phfile];
    }
    return self;
}

-(void) dealloc
{
    [placeHolder release];
    [super dealloc];
}

-(CGPoint) nextDropPoint
{
    return ccp(0, 0); // should override by subclass
}

-(CCArray *) popCardsStartWith:(Card*)fromCard
{
    if (cards.count == 0) {
        return nil;
    }
    int found = -1;
    for (int i=cards.count-1; i>=0; i--) {
        Card * card = [cards objectAtIndex:i];
        if (card == fromCard) {
            found = i;
            break;
        }
    }
    if (found == -1) {
        return nil;
    }
    CCArray *array = [CCArray arrayWithCapacity:13];
    for (int i=found; i<cards.count; i++) {
        [array addObject:[cards objectAtIndex:i]];
    }
    [cards removeObjectsInArray:array];
    return array;
}

@end
