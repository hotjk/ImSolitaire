//
//  BonusLayer.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BonusLayer : CCLayer {
    CCArray *allCards;
    
    BOOL inAnimation;
    BOOL isFinished;
    
    ccColor4F startColors_[8];
    ccColor4F startColorVar_;
    ccColor4F endColorVar_;
}

+(BonusLayer*) sharedBonusLayer;

-(void)start;
-(void) newFireworks;

@end
