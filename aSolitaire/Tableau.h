//
//  Tableau.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"
#import "GameArea.h"
#import "Reserve.h"

@interface Tableau : GameArea {
    CCArray *squaredCards;
    CGSize squaredOffset;
}

@property (nonatomic, assign, readonly) CCArray *squaredCards;
@property (nonatomic, assign, readonly) CGSize squaredOffset;

-(BOOL) card:(Reserve*)reserve canDropAtPoint:(CGPoint)point;

-(id) initWithIndex:(int)idx;
-(Card*) squaredCardClickAtPoint:(CGPoint)point;

-(Card*) squaredCard;
-(Card *) cardClickAtPoint:(CGPoint) point;
-(void) resetCardsOffset;

@end
