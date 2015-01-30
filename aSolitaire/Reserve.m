//
//  Reserve.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Reserve.h"


@implementation Reserve

@synthesize cards;
@synthesize dragFromCards;
@synthesize clickCard;
@synthesize clickPointOffset;
@synthesize dragFromCardsOffset;
@synthesize dragFrom;
@synthesize dropTo;
@synthesize dragHolder;

-(void) dealloc
{
    [cards release];
    [super dealloc];
}

-(id)initWithDragPoint:(CGPoint)point andCard:(Card*)card andGameArea:(GameArea*)area
{
    if (self = [super init]) {
        clickCard = card;
        dragFromCards = area.cards;
        clickPointOffset = ccpSub(card.position, point);
        cards = [[area popCardsStartWith:card] retain];
        dragFromCardsOffset = area.offset;
        dragFrom = area;
    }
    return self;
}

@end
