//
//  Foundation.h
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

@interface Foundation : GameArea {
    CardSuit suit;
}

@property (nonatomic, assign) CardSuit suit;

-(Card*) cardClickAtPoint:(CGPoint)point;
-(id) initWithIndex:(int)idx;
-(BOOL) card:(Reserve *)reserve canDropAtPoint:(CGPoint)point;
-(void) dragStart;
-(void) dropEnd;

@end
