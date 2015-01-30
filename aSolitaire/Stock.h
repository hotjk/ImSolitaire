//
//  Stock.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameArea.h"
#import "Card.h"

@interface Stock : GameArea {
}

-(BOOL) rectContainPoint:(CGPoint)point;
-(CCArray *)popCards:(NSInteger)number;

@end
