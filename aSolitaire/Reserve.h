//
//  Reserve.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"
#import "GameArea.h"

@interface Reserve : CCNode {
    CGPoint clickPointOffset;
    
    CCArray *cards;
    Card *clickCard; // click card should be the first of cards
    
    CCArray *dragFromCards;
    CGSize dragFromCardsOffset;
    GameArea *dragFrom;
    GameArea *dropTo;
    
    CCSprite *dragHolder; // drag holder is a dump card as the parent of drag cards
}

@property (nonatomic, retain) CCArray *cards;
@property (nonatomic, assign) CCArray *dragFromCards;
@property (nonatomic, assign) Card *clickCard;
@property (nonatomic, assign) CGPoint clickPointOffset;
@property (nonatomic, assign) CGSize dragFromCardsOffset;
@property (nonatomic, assign) GameArea *dragFrom;
@property (nonatomic, assign) GameArea *dropTo;
@property (nonatomic, assign) CCSprite *dragHolder;

-(id)initWithDragPoint:(CGPoint)point andCard:(Card*)card andGameArea:(GameArea*)area;

@end
