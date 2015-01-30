//
//  Waste.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"
#import "GameArea.h"

@interface Waste : GameArea {
}

-(Card*) cardClickAtPoint:(CGPoint)point;
-(CGPoint) cardOrigin:(NSInteger)number;
-(CCArray*) popAllCards;
-(void) noOffset;

@end
