//
//  Tableau.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tableau.h"
#import "Constants.h"
#import "GameLayer.h"
#import "DeviceConfig.h"
#import "CommonHelper.h"


@implementation Tableau

@synthesize squaredCards;
@synthesize squaredOffset;

-(id) initWithIndex:(int)idx
{
    if (self = [super init]) {
        origin = [[DeviceConfig sharedDeviceConfig] tableauOrigin:idx];
        squaredOffset = [[DeviceConfig sharedDeviceConfig] tableauSquaredOffset];
        offset = [[DeviceConfig sharedDeviceConfig] tableauOffset];
        squaredCards = [[CCArray alloc] initWithCapacity:idx + 1];
        cards = [[CCArray alloc] initWithCapacity:13];
        
        [placeHolder setPosition:origin];
    }
    return self;
}

-(void)dealloc
{
    [cards release];
    [squaredCards release];
    [super dealloc];
}

-(Card*) squaredCardClickAtPoint:(CGPoint)point
{
    if (squaredCards.count == 0) {
        return nil;
    }
    if (cards.count != 0) {
        return nil;
    }
    if(CGRectContainsPoint([[squaredCards lastObject] boundingBox], point))
    {
        return [squaredCards lastObject];
    }
    return nil;
}

-(Card*) squaredCard
{
    if (squaredCards.count == 0) {
        return nil;
    }
    if (cards.count != 0) {
        return nil;
    }
    return [squaredCards lastObject];
}

-(CGPoint) nextDropPoint
{
    if (cards.count == 0) {
        if (squaredCards.count == 0) {
            return [placeHolder position];
        }
        else {
            CGPoint pos = [[squaredCards lastObject] position];
            return CGPointMake(pos.x + squaredOffset.width, pos.y + squaredOffset.height);
        }
    } else {
        CGPoint pos = [[cards lastObject] position];
        return CGPointMake(pos.x + offset.width, pos.y + offset.height);
    }
}

-(Card *) cardClickAtPoint:(CGPoint) point
{
    if (cards.count == 0) {
        return nil;
    }
    for (int i=cards.count-1; i>=0; i--) {
        Card * card = [cards objectAtIndex:i];
        if (CGRectContainsPoint(card.boundingBox, point)) {
            return card;
        }
    }
    return nil;
}

-(BOOL) card:(Reserve*)reserve canDropAtPoint:(CGPoint)point
{
    if (cards.count > 0) {
        Card *lastFanned = [cards lastObject];
        if ([CommonHelper rect:[lastFanned boundingBox] MostContainRect:reserve.dragHolder.boundingBox]) {
            if (lastFanned.cColor != reserve.clickCard.cColor && 
                lastFanned.number == reserve.clickCard.number + 1) {
                return YES;
            }
        }
    } else if (squaredCards.count == 0){
        if ([CommonHelper rect:[placeHolder boundingBox] MostContainRect:reserve.dragHolder.boundingBox]) {
            if (reserve.clickCard.number == kKing) {
                return YES;
            }
        }
    }
    return NO;
}

-(void)resetCardsOffset
{
    if (cards.count == 0) {
        return;
    }
    
    CGSize oldOffset = offset;
    if (cards.count > 11) {
        offset = [[DeviceConfig sharedDeviceConfig] tableauMoreThan10Offset];
    } else if (cards.count > 9){
        offset = [[DeviceConfig sharedDeviceConfig] tableauMoreThan8Offset];
    } else {
        offset = [[DeviceConfig sharedDeviceConfig] tableauOffset];
    }
    if (oldOffset.height == offset.height) {
        if (cards.count > 1) {
            Card* card1 = [cards objectAtIndex:(cards.count-1)];
            Card* card2 = [cards objectAtIndex:(cards.count-2)];
            CGFloat offsetY = card2.position.y - card1.position.y;
            if (offsetY == offset.height) {
                return;
            }
        }
        else
        {
            return;
        }
    }
    //NSLog(@"---- Offset change");
    
    CGPoint base = [[cards objectAtIndex:0] position];
    for (int i=1; i<cards.count; i++) {
        CCMoveTo* moveTo = [CCMoveTo actionWithDuration:kResetCardsOffsetDuration 
                                               position:ccp(base.x, base.y + i * offset.height)];
        [[cards objectAtIndex:i] runAction:moveTo];
    }
}

@end
