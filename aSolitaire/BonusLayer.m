//
//  BonusLayer.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BonusLayer.h"
#import "BonusCard.h"
#import "Constants.h"
#import "UserConfig.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"
#import "CommonHelper.h"
#import "HomeLayer.h"
#import "DeviceConfig.h"

@implementation BonusLayer

static BonusLayer *instanceOfBonusLayer;
static int pointsEasyMode[] = {10,50,100,500};
static int pointsHardMode[] = {20,100,200,1000};
static int bonusRate[] = {1, 2, 3, 10};

#pragma mark -
#pragma mark Sound

-(void) playFlipSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"flip.acf"];
}
-(void) playDropSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"drop.acf"];
}
-(void) playFireSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"fire.acf"];
}

-(void)animationBegin
{
    inAnimation = YES;
}

-(void)animationEnd
{
    inAnimation = NO;
}

-(id)init
{
    if (self = [super init]) {
        instanceOfBonusLayer = self;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[[DeviceConfig sharedDeviceConfig] bonusSpriteFrameFileName]];
        [[CCTextureCache sharedTextureCache] addImage:[[DeviceConfig sharedDeviceConfig] bonusBatchNodeFileName]];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        allCards = [[CCArray alloc] initWithCapacity:4];
        BOOL bShakeCard = [[UserConfig sharedUserConfig] shakeCard];
        for (int i=0; i<4; i++) {
            BOOL easy = ([[GameLayer sharedGameLayer] stockToWasteNum] == 1);
            int* points = easy?pointsEasyMode:pointsHardMode;
            BonusCard *card = [BonusCard cardWithPoint:points[i]];
            [allCards addObject:card];
            [self addChild:card];
            [card setPosition:ccp(0 - size.width * 0.5, size.height * 0.5)];
            if (bShakeCard) [CommonHelper shakeCard:card];
        }
        
        startColors_[0] = ccc4FFromccc4B(ccc4(255, 6, 6, 255));
        startColors_[1] = ccc4FFromccc4B(ccc4(241, 222, 88, 255));
        startColors_[2] = ccc4FFromccc4B(ccc4(149, 245, 107, 255));
        startColors_[3] = ccc4FFromccc4B(ccc4(254, 235, 67, 255));
        startColors_[4] = ccc4FFromccc4B(ccc4(114, 207, 198, 255));
        startColors_[5] = ccc4FFromccc4B(ccc4(240, 81, 217, 255));
        startColors_[6] = ccc4FFromccc4B(ccc4(33, 227, 215, 255));
        startColors_[7] = ccc4FFromccc4B(ccc4(255, 128, 64, 255));
        
        startColorVar_ = ccc4FFromccc4B(ccc4(50,50,50,50));
        endColorVar_ = ccc4FFromccc4B(ccc4(50,50,50,50));
        
        isFinished = NO;
        self.isTouchEnabled = YES;
        self.visible = NO;
        
        //[self start];
    }
    return self;
}

-(void) dealloc
{
    [allCards release];
    
    [super dealloc];
}

+(BonusLayer *) sharedBonusLayer
{
    return instanceOfBonusLayer;
}


-(void)newFirwork
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint position = ccp(arc4random() % (int)(size.width)
                           , (size.height * 0.5) + arc4random() % (int)(size.height * 0.5));
    
    CCParticleSystem *emitter = [CCParticleExplosion node]; 
    emitter.position = position;
    emitter.duration = 0.1;
    emitter.emissionRate = 10000;
    emitter.totalParticles = arc4random() % 150 + 50 ;
    emitter.gravity = ccp(0, -90);
    emitter.speed = 100;
    emitter.speedVar = 30;
    emitter.life = (emitter.totalParticles - 50) /100 + 1;
    emitter.lifeVar = 1;
    
    ccColor4F c = startColors_[arc4random() % 8];
    ccColor4F endColor = {c.r, c.g,c.b,255};
    emitter.startColor = c;
    emitter.startColorVar = startColorVar_;
    emitter.endColor = endColor;
    emitter.endColorVar = endColorVar_;
    
    [self addChild:emitter];
}

-(void) newFireworks
{
    [self animationBegin];
    self.visible = YES;
    for(int i=0;i<6;i++)
    {
        id delay = [CCDelayTime actionWithDuration:0.3f*i + (arc4random() % 10) / 10];
        
        id firework = [CCCallFunc actionWithTarget:self selector:@selector(newFirwork)];
        id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFireSound)];
        id sequence = [CCSequence actions:delay, firework, sound, nil];
        [self runAction:sequence];
    }
}

-(void) flipCard:(id)sender data:(void *)data
{
    BonusCard *card = (BonusCard *)data;
    [card switchTextureToFront];
    if( [[UserConfig sharedUserConfig] shakeCard] ) {
        [CommonHelper shakeCard:card];
    }
}

-(CCAction*)flipSequence:(BonusCard*)card
{
    //id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
    id flipFirstHalf = [CCOrbitCamera actionWithDuration:kTableauFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
    id zoomIn = [CCScaleTo actionWithDuration:kTableauFlipDuration*0.25f scale:kFlipScaleRate];
    id zoomInAndFlip = [CCSpawn actions:zoomIn, flipFirstHalf, nil];
    id flipSecondHalf = [CCOrbitCamera actionWithDuration:kTableauFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:90 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
    id zoomOut = [CCScaleTo actionWithDuration:kTableauFlipDuration*0.25f scale:1.0f];
    id zoomOutAndflip = [CCSpawn actions:flipSecondHalf, zoomOut, nil];
    id switchTextureAction = [CCCallFuncND actionWithTarget:self selector:@selector(flipCard:data:) data:card];
    id flip = [CCSequence actions:zoomInAndFlip, switchTextureAction, zoomOutAndflip, nil];
    return flip;
    //return [CCSequence actions:sound, flip, nil];
}

-(void)shakeBounsCards
{
    if ([[UserConfig sharedUserConfig] shakeCard]) {
        for (BonusCard* card in allCards) {
            [CommonHelper shakeCard:card];
        }
    }
}

-(void)randomBonusCards
{
    BOOL easy = ([[GameLayer sharedGameLayer] stockToWasteNum] == 1);
    int* points = easy?pointsEasyMode:pointsHardMode;
    int point = points[0];
    for(int i=3;i>=0;i--){
        if (0 == arc4random() % bonusRate[i])
        {
            point = points[i];
            break;
        }
    }
    
    for (BonusCard *card in allCards) {
        card.point = point;
    }
}

-(void)start
{
    [self animationBegin];
    self.visible = YES;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    float inteval = size.width / 5;
    
    for (int i=0; i<4; i++) {
        BonusCard *card = [allCards objectAtIndex:i];
        id comeIn = [CCMoveTo actionWithDuration:1.0f 
                                        position:ccp((i+1)*inteval, size.height*0.5)];
        id ComeInEase = [CCEaseInOut actionWithAction:comeIn rate:kEaseOutRate];
        id flipDelay = [CCDelayTime actionWithDuration:2.0f];
        id collect = [CCMoveTo actionWithDuration:0.5f 
                                         position:ccp(size.width * 0.5, size.height * 0.5)];
        id collectEase = [CCEaseInOut actionWithAction:collect rate:kEaseOutRate];
        id shake = [CCCallFunc actionWithTarget:self selector:@selector(shakeBounsCards)];
        id collectDelay = [CCDelayTime actionWithDuration:0.5f];
        
        CGPoint magicPoint = ccp(card.boundingBox.size.width * ((i%2==0)?1:-1), 0);
        id move1 = [CCMoveBy actionWithDuration:0.1f position:magicPoint];
        id move1Back = [CCMoveTo actionWithDuration:0.1f 
                                           position:ccp(size.width * 0.5, size.height * 0.5)];
        id moveSequence = [CCSequence actions:move1, move1Back, nil];
        id repeat = [CCRepeat actionWithAction:moveSequence times:5];
        
        id disperse = [CCMoveTo actionWithDuration:0.5f 
                                          position:ccp((i+1)*inteval, size.height*0.5)];
        id disperseEase = [CCEaseInOut actionWithAction:disperse rate:kEaseOutRate];
        
        id randomBonusCards = [CCCallFunc actionWithTarget:self selector:@selector(randomBonusCards)];
        
        id done = [CCCallFunc actionWithTarget:self selector:@selector(animationEnd)];
        
        id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
        
        if (i==0) {
            id sequence = [CCSequence actions:ComeInEase, 
                           sound, [self flipSequence:card], flipDelay, 
                           sound, [self flipSequence:card], 
                           collectEase, shake, collectDelay,
                           repeat,
                           disperseEase,
                           randomBonusCards,
                           //[self flipSequence:card],
                           done, nil];
            [card runAction:sequence];
        }
        else {
            id sequence = [CCSequence actions:ComeInEase, 
                       [self flipSequence:card], flipDelay, 
                       [self flipSequence:card], 
                       collectEase, shake, collectDelay,
                       repeat,
                       disperseEase,
                       randomBonusCards,
                       //[self flipSequence:card],
                       done, nil];
            [card runAction:sequence];
        }
    }
}

-(void) selectBonusCardDone:(id)sender data:(BonusCard *)data
{
    [UserConfig sharedUserConfig].point = [UserConfig sharedUserConfig].point + data.point;
    [UserConfig save];
    
    //[self newFireworks];
    
    isFinished = YES;
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isFinished) {
        CCScene *homeLayer = [HomeLayer scene];
        CCTransitionFade *tran = [CCTransitionFade transitionWithDuration:kSceneSwitchDuration scene:homeLayer withColor:ccWHITE];
        [[CCDirector sharedDirector] replaceScene:tran];
        return NO;
    }
    if (inAnimation) {
        return NO;
    }
    
    CGPoint location = [CommonHelper locationFromTouch:touch];
    for (BonusCard* card in allCards) {
        if (CGRectContainsPoint(card.boundingBox, location)) {
            [self animationBegin];
            id done = [CCCallFuncND actionWithTarget:self
                                            selector:@selector(selectBonusCardDone:data:) data:card];
            id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
            id sequence = [CCSequence actions:sound, [self flipSequence:card], done, nil];
            [card runAction:sequence];
        }
    }
    
    return NO;
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
