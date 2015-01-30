//
//  GamePauseLayer.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GamePauseLayer.h"
#import "Constants.h"
#import "HomeLayer.h"
#import "GameScene.h"
#import "Constants.h"
#import "CommonHelper.h"
#import "DeviceConfig.h"

@implementation GamePauseLayer

-(id)init
{
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[[DeviceConfig sharedDeviceConfig] homeSpriteFrameFileName]];
        menuSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[[DeviceConfig sharedDeviceConfig] homeBatchNodeFileName] capacity:100];
        [self addChild:menuSpriteBatchNode z:kGameLayerMenuZ];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint center = ccp(size.width * 0.5, size.height * 0.5);
        
        pauseBg = [CCSprite spriteWithSpriteFrameName:@"pause_bg.png"];
        pauseBg.scale = 32;
        [pauseBg setPosition:center];
        [menuSpriteBatchNode addChild:pauseBg];
        
        pausePanel = [CCSprite spriteWithSpriteFrameName:@"pause_panel.png"];
        [pausePanel setPosition:[[DeviceConfig sharedDeviceConfig] pausePanelPosition]];
        [menuSpriteBatchNode addChild:pausePanel];
        
        pauseResume = [CCSprite spriteWithSpriteFrameName:@"pause_resume.png"];
        [pauseResume setPosition:[[DeviceConfig sharedDeviceConfig] pauseResumePosition]];
        [menuSpriteBatchNode addChild:pauseResume];
        
        pauseRestart = [CCSprite spriteWithSpriteFrameName:@"pause_restart.png"];
        [pauseRestart setPosition:[[DeviceConfig sharedDeviceConfig] pauseRestartPosition]];
        [menuSpriteBatchNode addChild:pauseRestart];
        
        pauseReturn = [CCSprite spriteWithSpriteFrameName:@"pause_exit.png"];
        [pauseReturn setPosition:[[DeviceConfig sharedDeviceConfig] pauseReturnPosition]];       
        [menuSpriteBatchNode addChild:pauseReturn];
        
        pauseTips = [CCSprite spriteWithSpriteFrameName:@"pause_tips.png"];
        [pauseTips setPosition:center];
        [menuSpriteBatchNode addChild:pauseTips];
        

        pauseSmoke = [CCSprite spriteWithSpriteFrameName:@"pause_smoke.png"];
        if ([[DeviceConfig sharedDeviceConfig] isIPad]) {
            [pauseSmoke setPosition:ccp(size.width * 0.5 - pauseTips.boundingBox.size.width * 0.5 + 50, size.height * 0.5 + 70)];
        }
        else
        {
            [pauseSmoke setPosition:ccp(size.width * 0.5 - pauseTips.boundingBox.size.width * 0.5 + 25, size.height * 0.5 + 35)];
        }
        //[pauseSmoke setPosition:center];
        [menuSpriteBatchNode addChild:pauseSmoke];
        
        [GameScene sharedScene].isPause = NO;
        
        self.visible = NO;
    }
    return self;
}

-(void)pauseGame
{
    [pausePanel setPosition:[[DeviceConfig sharedDeviceConfig] pausePanelPosition]];
    [pauseResume setPosition:[[DeviceConfig sharedDeviceConfig] pauseResumePosition]];
    [pauseRestart setPosition:[[DeviceConfig sharedDeviceConfig] pauseRestartPosition]];
    [pauseReturn setPosition:[[DeviceConfig sharedDeviceConfig] pauseReturnPosition]];
    
    self.visible = YES;
    [GameScene sharedScene].isPause = YES;
    [pauseResume setColor:ccWHITE];
    [pauseRestart setColor:ccWHITE];
    [pauseReturn setColor:ccWHITE];
    pauseBg.opacity = 0;
    [pauseBg runAction:[CCFadeIn actionWithDuration:kGamePauseLayerFadeDuration]];
    pauseTips.opacity = 0;
    [pauseTips runAction:[CCFadeIn actionWithDuration:kGamePauseLayerFadeDuration]];
    pauseSmoke.opacity = 0;
    [pauseSmoke runAction:[CCFadeIn actionWithDuration:kGamePauseLayerFadeDuration]];
    
    [pausePanel runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMovePosition]]];
    [pauseResume runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMovePosition]]];
    [pauseRestart runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMovePosition]]];
    [pauseReturn runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMovePosition]]];
    self.isTouchEnabled = YES;
}

-(void)resumeGameDone
{
    [GameScene sharedScene].isPause = NO;
    self.isTouchEnabled = NO;
}

-(void)resumeGame
{  
    [pauseResume setColor:ccc3(0, 255, 255)];
    id fade = [CCFadeOut actionWithDuration:kGamePauseLayerFadeDuration];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resumeGameDone)];
    [pauseBg runAction: [CCSequence actions:fade, done, nil]];
    [pauseTips runAction:[CCFadeOut actionWithDuration:kGamePauseLayerFadeDuration]];
    [pauseSmoke runAction:[CCFadeOut actionWithDuration:kGamePauseLayerFadeDuration]];
    [pausePanel runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
    [pauseResume runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
    [pauseRestart runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
    [pauseReturn runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];    
}
-(void)exitGame
{
    [pauseReturn setColor:ccc3(0, 255, 255)];
    CCScene *homeLayer = [HomeLayer scene];
    CCTransitionFade *tran = [CCTransitionFade transitionWithDuration:kSceneSwitchDuration scene:homeLayer withColor:ccWHITE];
    [[CCDirector sharedDirector] replaceScene:tran];
}

-(void)restartGameDone
{
    [GameScene sharedScene].isPause = NO;
    self.isTouchEnabled = NO;
    [[GameLayer sharedGameLayer] newGame];
}
-(void)restartGame
{
    [pauseRestart setColor:ccc3(0, 255, 255)];
    id fade = [CCFadeOut actionWithDuration:kGamePauseLayerFadeDuration];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(restartGameDone)];
    [pauseBg runAction: [CCSequence actions:fade, done, nil]];
    [pauseTips runAction:[CCFadeOut actionWithDuration:kGamePauseLayerFadeDuration]];
    [pauseSmoke runAction:[CCFadeOut actionWithDuration:kGamePauseLayerFadeDuration]];
    [pausePanel runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
    [pauseResume runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
    [pauseRestart runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
    [pauseReturn runAction:[CCMoveBy actionWithDuration:kGamePauseLayerFadeDuration position:[[DeviceConfig sharedDeviceConfig] pauseMoveOutPosition]]];
}


-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [CommonHelper locationFromTouch:touch];
    
    if (CGRectContainsPoint(pauseResume.boundingBox, location)) {
        [self resumeGame];
    }
    else if (CGRectContainsPoint(pauseReturn.boundingBox, location)) {
        [self exitGame];
    }
    else if (CGRectContainsPoint(pauseRestart.boundingBox, location)) {
        [self restartGame];
    }
    else
    {
        [self resumeGame];
    }
    
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}



@end
