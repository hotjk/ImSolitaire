//
//  GamePauseLayer.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GamePauseLayer : CCLayer {
    CCSpriteBatchNode *menuSpriteBatchNode;
    
    CCSprite *pauseBg;
    CCSprite *pausePanel;
    CCSprite *pauseResume;
    CCSprite *pauseRestart;
    CCSprite *pauseReturn;
    CCSprite *pauseTips;
    CCSprite *pauseSmoke;
}

-(void)pauseGame;

@end
