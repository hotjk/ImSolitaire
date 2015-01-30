//
//  CommonHelper.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CommonHelper : NSObject

+(CGPoint) locationFromTouch:(UITouch *)touch;
+(CGPoint) locationFromTouchs:(NSSet *)touchs;

+(BOOL) rect:(CGRect)rect MostContainRect:(CGRect)testRect;
+(NSArray*)shuffle:(NSInteger) n;
+(void) shakeCard:(CCSprite *)card;

@end
