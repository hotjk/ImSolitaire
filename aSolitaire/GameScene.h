//
//  GameScene.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GamePauseLayer.h"
#import "GameLayer.h"
#import "BonusLayer.h"

@interface GameScene : CCScene {
    GameLayer *gameLayer;
    GamePauseLayer *gamePauseLayer;
    BonusLayer *bonusLayer;
    
    BOOL isPause;
}

@property (nonatomic, readonly) GameLayer* gameLayer;
@property (nonatomic, readonly) GamePauseLayer *gamePauseLayer;
@property (nonatomic, readonly) BonusLayer *bonusLayer;
@property (nonatomic, assign) BOOL isPause;

+(GameScene*) sharedScene;
+(id) scene;

@end
