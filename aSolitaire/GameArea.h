//
//  GameArea.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"

@interface GameArea : CCNode {
    CGPoint origin;
    CCArray *cards;
    CCSprite *placeHolder;
    CGSize offset;
}

@property (nonatomic, assign, readonly) CCArray *cards;
@property (nonatomic, assign, readonly) CGPoint origin;
@property (nonatomic, assign, readonly) CCSprite *placeHolder;
@property (nonatomic, assign, readonly) CGSize offset;

-(CGPoint) nextDropPoint;
-(CCArray *) popCardsStartWith:(Card*)fromCard;

@end
