//
//  BonusCard.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BonusCard : CCSprite {
    BOOL faceUp_;
    int point;
}

+(id) cardWithPoint:(int)pt;

@property (nonatomic,assign) int point;
-(void) switchTextureToFront;

@end
