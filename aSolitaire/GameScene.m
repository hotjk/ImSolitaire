//
//  GameScene.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "UserConfig.h"
#import "DeviceConfig.h"

@implementation GameScene
@synthesize gameLayer;
@synthesize gamePauseLayer;
@synthesize bonusLayer;
@synthesize isPause;

static GameScene* gameSceneInstance;

+(GameScene*) sharedScene
{
    return gameSceneInstance;
}

-(id) init
{
    if (self = [super init]) {
        gameSceneInstance = self;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLayer *bgLayer = [CCLayer node];
        int sceneIndex = [[UserConfig sharedUserConfig] scene];
        CCSprite* bg = [CCSprite spriteWithFile:[[DeviceConfig sharedDeviceConfig] bgFileName:sceneIndex]];
        [bg setPosition:CGPointMake(size.width * 0.5, size.height * 0.5)];
        [bgLayer addChild:bg];
        [self addChild:bgLayer];
        
        gameLayer = [GameLayer node];
        [self addChild:gameLayer];
        
        bonusLayer = [BonusLayer node];
        [self addChild:bonusLayer];
        
        gamePauseLayer = [GamePauseLayer node];
        [self addChild:gamePauseLayer];
        gamePauseLayer.isTouchEnabled = NO;
    }
    return self;
}

+(id) scene
{
    GameScene *scene = [[[GameScene alloc] init] autorelease];
    return scene;
}

@end
