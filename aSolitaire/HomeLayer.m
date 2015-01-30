//
//  HomeLayer.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeLayer.h"
#import "GameScene.h"
#import "Constants.h"
#import "CommonHelper.h"
#import "DeviceConfig.h"
#import "UserConfig.h"

@implementation HomeLayer

static int pointsScene[] = {0,100,1000,10000};

+(id) scene
{
    CCScene *scene = [CCScene node];
    //CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
    //[scene addChild:bg];
    
    HomeLayer *layer = [HomeLayer node];
    [scene addChild:layer];
    return scene;
}

-(void)changeStateToHome
{
    state = kStateHome;
}
-(void)changeStateToAbout
{
    state = kStateAbout;
}
-(void)changeStateToSettings
{
    state = kStateSettings;
}
-(void)changeStateToScene
{
    state = kStateScene;
}

-(void)animateSuit:(id)sender
{
    CCSprite *suit = (CCSprite*)sender;
    
    [suit stopAllActions];
    CGSize size = [[CCDirector sharedDirector] winSize];

    int direction = arc4random() % 2 * 2 - 1; // -1 or 1
    int distance = arc4random() % (int)(size.width / 20) + (int)(size.width / 20); 
    int duration = arc4random() % 10 / 7 + 0.3; // 0.5 -- 2.5 
    int height = arc4random() % 20 + 10;
    id jump = [CCJumpBy actionWithDuration:duration 
                                  position:ccp(distance * direction, 0) 
                                    height:height jumps:1];
    id reverse = [jump reverse];
    id done = [CCCallFuncN actionWithTarget:self selector:@selector(animateSuit:)];
    id sequence = [CCSequence actions:jump, reverse, done, nil];

    [suit runAction:sequence];
}

-(void) initBackground
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint center = ccp(size.width * 0.5, size.height * 0.5);
    
    CCSprite *bg = [CCSprite spriteWithFile:[[DeviceConfig sharedDeviceConfig] homeBgImageFileName]];
    [bg setPosition:center];
    [self addChild:bg z:kBackground];
    
    homePanel = [CCSprite spriteWithFile:[[DeviceConfig sharedDeviceConfig] homePanelImageFileName]];
    int imageHeight = [homePanel boundingBox].size.height;
    [homePanel setPosition:ccp(size.width * 0.5, size.height - imageHeight * 0.5)];
    [self addChild:homePanel z:kPanel];
    
    CCSprite *spade = [CCSprite spriteWithSpriteFrameName:@"home_spade.png"];
    CCSprite *heart = [CCSprite spriteWithSpriteFrameName:@"home_heart.png"];
    CCSprite *diamond = [CCSprite spriteWithSpriteFrameName:@"home_diamond.png"];
    CCSprite *club = [CCSprite spriteWithSpriteFrameName:@"home_club.png"];
    
    CGSize suitSize = [spade boundingBox].size;
    [spade setPosition:ccp(size.width * 0.5 - suitSize.width * 0.3
                           , size.height - suitSize.height * 0.4)];
    [club setPosition:ccp(size.width * 0.5 + suitSize.width * 0.3
                          , size.height - suitSize.height * 0.47)];
    [heart setPosition:ccp(size.width * 0.5 - suitSize.width * 0.9
                           , size.height - suitSize.height * 0.52)];
    [diamond setPosition:ccp(size.width * 0.5 + suitSize.width * 1.0
                             , size.height - suitSize.height * 0.38)];
    
    [self addChild:spade z:kSuitSpade];
    [self addChild:heart z:kSuitHeart];
    [self addChild:diamond z:kSuitDiamond];
    [self addChild:club z:kSuitClub];
    
    [self animateSuit:spade];
    [self animateSuit:heart];
    [self animateSuit:diamond];
    [self animateSuit:club];
}

-(void) initHomeInterface
{
    homeStart = [CCSprite spriteWithSpriteFrameName:@"home_start.png"];
    [homeStart setPosition:[[DeviceConfig sharedDeviceConfig] homeStartPosition]];
    [spriteBatchNode addChild:homeStart];
    
    homeLogo = [CCSprite spriteWithSpriteFrameName:@"home_logo.png"];
    [homeLogo setPosition:[[DeviceConfig sharedDeviceConfig] homeLogoPosition]];
    [spriteBatchNode addChild:homeLogo];
    
    homeSettings = [CCSprite spriteWithSpriteFrameName:@"home_settings.png"];
    [homeSettings setPosition:[[DeviceConfig sharedDeviceConfig] homeSettingsPosition]];
    [spriteBatchNode addChild:homeSettings];
    
    homeAbout = [CCSprite spriteWithSpriteFrameName:@"home_about.png"];
    [homeAbout setPosition:[[DeviceConfig sharedDeviceConfig] homeAboutPosition]];
    [spriteBatchNode addChild:homeAbout];
    
    homeControls = [[CCArray alloc] init];
    [homeControls addObject:homeLogo];
    [homeControls addObject:homeStart];
    [homeControls addObject:homeSettings];
    [homeControls addObject:homeAbout];
}

-(void) initAboutInterface
{
    aboutStaff = [CCSprite spriteWithSpriteFrameName:@"about.png"];
    [aboutStaff setPosition:[[DeviceConfig sharedDeviceConfig] aboutStaffPosition]];
    [spriteBatchNode addChild:aboutStaff];
 
    aboutMenu = [CCSprite spriteWithSpriteFrameName:@"btn_menu.png"];
    [aboutMenu setPosition:[[DeviceConfig sharedDeviceConfig] aboutMenuPosition]];
    [spriteBatchNode addChild:aboutMenu];
    
    aboutControls = [[CCArray alloc] init];
    [aboutControls addObject:aboutStaff];
    [aboutControls addObject:aboutMenu];
    
    for (CCSprite *control in aboutControls) {
        [control setPosition:ccpAdd([control position], ccp(winSize.width, 0))];
    }
}

-(void) initSettingsInterface
{
    settingsFlip = [CCSprite spriteWithSpriteFrameName:@"settings_flip.png"];
    [settingsFlip setPosition:[[DeviceConfig sharedDeviceConfig] settingsFlipPosition]];
    [spriteBatchNode addChild:settingsFlip];
    
    settingsAnimation = [CCSprite spriteWithSpriteFrameName:@"settings_animation.png"];
    [settingsAnimation setPosition:[[DeviceConfig sharedDeviceConfig] settingsAnimationPosition]];
    [spriteBatchNode addChild:settingsAnimation];
    
    settingsAutoFlip = [CCSprite spriteWithSpriteFrameName:@"settings_autoflip.png"];
    [settingsAutoFlip setPosition:[[DeviceConfig sharedDeviceConfig] settingsAutoFlipPosition]];
    [spriteBatchNode addChild:settingsAutoFlip];
    
    settingsShakeCard = [CCSprite spriteWithSpriteFrameName:@"settings_shakecard.png"];
    [settingsShakeCard setPosition:[[DeviceConfig sharedDeviceConfig] settingsShakeCardPosition]];
    [spriteBatchNode addChild:settingsShakeCard];
    
    settingsMenu = [CCSprite spriteWithSpriteFrameName:@"btn_menu.png"];
    [settingsMenu setPosition:[[DeviceConfig sharedDeviceConfig] settingsMenuPosition]];
    [spriteBatchNode addChild:settingsMenu];
    
    settingsFlipValue = [CCSprite spriteWithSpriteFrameName:
                         ([[UserConfig sharedUserConfig] drawCards] == 1)?@"settings_flip_1.png":@"settings_flip_3.png"];
    [settingsFlipValue setPosition:[[DeviceConfig sharedDeviceConfig] settingsFlipValuePosition]];
    [spriteBatchNode addChild:settingsFlipValue];
    
    settingsAnimationValue = [CCSprite spriteWithSpriteFrameName:
                              ([[UserConfig sharedUserConfig] startGameAnimation])?@"settings_on.png":@"settings_off.png"];
    [settingsAnimationValue setPosition:[[DeviceConfig sharedDeviceConfig] settingsAnimationValuePosition]];
    [spriteBatchNode addChild:settingsAnimationValue];
    
    settingsAutoFlipValue = [CCSprite spriteWithSpriteFrameName:
                              ([[UserConfig sharedUserConfig] autoFlipTopCard])?@"settings_on.png":@"settings_off.png"];
    [settingsAutoFlipValue setPosition:[[DeviceConfig sharedDeviceConfig] settingsAutoFlipValuePosition]];
    [spriteBatchNode addChild:settingsAutoFlipValue];
    
    settingsShakeCardValue = [CCSprite spriteWithSpriteFrameName:
                              ([[UserConfig sharedUserConfig] shakeCard])?@"settings_on.png":@"settings_off.png"];
    [settingsShakeCardValue setPosition:[[DeviceConfig sharedDeviceConfig] settingsShakeCardValuePosition]];
    [spriteBatchNode addChild:settingsShakeCardValue];
    
    settingsControls = [[CCArray alloc] init];
    [settingsControls addObject:settingsFlip];
    [settingsControls addObject:settingsFlipValue];
    [settingsControls addObject:settingsAnimation];
    [settingsControls addObject:settingsAnimationValue];
    [settingsControls addObject:settingsAutoFlip];
    [settingsControls addObject:settingsAutoFlipValue];
    [settingsControls addObject:settingsShakeCard];
    [settingsControls addObject:settingsShakeCardValue];
    [settingsControls addObject:settingsMenu];
    
    for (CCSprite *control in settingsControls) {
        [control setPosition:ccpAdd([control position], ccp(-winSize.width, 0))];
    }
}

-(void) initSceneInterface
{
    //[UserConfig sharedUserConfig].point = 123456;
    int score = [[UserConfig sharedUserConfig] point];
    CCSprite *myScore = [CCSprite spriteWithSpriteFrameName:@"my_score.png"];
    [myScore setPosition:[[DeviceConfig sharedDeviceConfig] myScorePosition]];
    [self addChild:myScore z:kMyScore];
    
    sceneStartButtons = [[CCArray alloc] initWithCapacity:4];
    
    for (int i=0; i< sizeof(pointsScene)/sizeof(int); i++) {
        if (score >= pointsScene[i]) {
            CCSprite *scene = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"scene_%d.png", i+1]];
            [scene setPosition:[[DeviceConfig sharedDeviceConfig] scenePosition:i]];
            [sceneSpriteBatchNode addChild:scene];
            CCSprite *sceneButton = [CCSprite spriteWithSpriteFrameName:@"scene_play.png"];
            [sceneButton setPosition:[[DeviceConfig sharedDeviceConfig] scenePosition:i]];
            [sceneSpriteBatchNode addChild:sceneButton];
            [sceneStartButtons addObject:sceneButton];
        } else {
            CCSprite *scene = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"scene_lock_%d.png", i+1]];
            [scene setPosition:[[DeviceConfig sharedDeviceConfig] scenePosition:i]];
            [sceneSpriteBatchNode addChild:scene];
            if (pointsScene[i] > 0) {
                CCSprite *sceneScore = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"score_%d.png", pointsScene[i]]];
                [sceneScore setPosition:[[DeviceConfig sharedDeviceConfig] sceneScorePosition:i]];
                [sceneSpriteBatchNode addChild:sceneScore];
            }
            
        }
    }
    
    NSString *strScore = [NSString stringWithFormat:@"%d", score];
    int offset = 0;
    for (int i=0; i<strScore.length; i++) {
        unichar c = [strScore characterAtIndex:i];
        NSString *filename = [NSString stringWithFormat:@"font_%c.png", c];
        CCSprite *s = [CCSprite spriteWithSpriteFrameName:filename];
        CGPoint p = ccp(myScore.position.x + myScore.boundingBox.size.width * 0.5 
                        + offset + s.boundingBox.size.width * 0.5
                        , myScore.position.y);
        offset += s.boundingBox.size.width * 0.75;
        [s setPosition:p];
        [sceneSpriteBatchNode addChild:s];
    }
    
    
    sceneMenu = [CCSprite spriteWithSpriteFrameName:@"btn_menu_1.png"];
    [sceneMenu setPosition:[[DeviceConfig sharedDeviceConfig] sceneMenuPosition]];
    [sceneSpriteBatchNode addChild:sceneMenu];
}

-(void) initGameObjects
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[[DeviceConfig sharedDeviceConfig] sceneSpriteFrameFileName]];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[[DeviceConfig sharedDeviceConfig] sceneBatchNodeFileName] capacity:40];
    [self addChild:sceneSpriteBatchNode z:kSceneBatchNode];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[[DeviceConfig sharedDeviceConfig] homeSpriteFrameFileName]];
    spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[[DeviceConfig sharedDeviceConfig] homeBatchNodeFileName] capacity:40];
    [self addChild:spriteBatchNode z:kBatchNode];
    
    [self initBackground];
    [self initHomeInterface];
    [self initAboutInterface];
    [self initSettingsInterface];
    [self initSceneInterface];
}

-(id) init
{
    if (self == [super init]) {
        
        winSize = [[CCDirector sharedDirector] winSize];
        state = kStateHome;
        [self initGameObjects];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)dealloc
{
    [homeControls release];
    [aboutControls release];
    [settingsControls release];
    [sceneStartButtons release];

    [super dealloc];
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(void) touchInStateHome:(CGPoint)location
{
    if (CGRectContainsPoint([homeStart boundingBox], location)) {
        state = kStateChanging;
        homeStart.color = ccc3(0, 255, 255);
        
        sceneMenu.color = ccWHITE;
        id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(0, -winSize.height)];
        id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
        id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToScene)];
        id sequ = [CCSequence actions:ease, done, nil];
        [homePanel runAction:sequ];
        
        for (CCSprite *control in homeControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(0, -winSize.height)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            [control runAction:ease];
        }
        
    }
    else if (CGRectContainsPoint([homeAbout boundingBox], location)) {
        state = kStateChanging;
        homeAbout.color = ccc3(0, 255, 255);
        aboutMenu.color = ccWHITE;
        
        for (CCSprite *control in homeControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(-winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            if (control == homeLogo) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToAbout)];
                id sequ = [CCSequence actions:ease, done, nil];
                [control runAction:sequ];
            }
            else {
                [control runAction:ease];
            }
        }
        for (CCSprite *control in aboutControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(-winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            [control runAction:ease];
        }
    }
    else if (CGRectContainsPoint([homeSettings boundingBox], location)) {
        state = kStateChanging;
        homeSettings.color = ccc3(0, 255, 255);
        settingsMenu.color = ccWHITE;
        
        for (CCSprite *control in homeControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            if (control == homeLogo) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToSettings)];
                id sequ = [CCSequence actions:ease, done, nil];
                [control runAction:sequ];
            }
            else {
                [control runAction:ease];
            }
        }
        for (CCSprite *control in settingsControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            [control runAction:ease];
        }
    }
}

-(void) touchInStateAbout:(CGPoint)location
{
    if (CGRectContainsPoint([aboutMenu boundingBox], location)) {
        state = kStateChanging;
        aboutMenu.color = ccc3(0, 255, 255);
        
        homeAbout.color = ccWHITE;
        for (CCSprite *control in homeControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            if (control == homeLogo) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToHome)];
                id sequ = [CCSequence actions:ease, done, nil];
                [control runAction:sequ];
            }
            else {
                [control runAction:ease];
            }
        }
        for (CCSprite *control in aboutControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            [control runAction:ease];
        }
    }
}

-(void) changeTexture:(id)sender data:(NSString*) texture
{
    CCSprite *sprite = (CCSprite*)sender;
    CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:texture];
    [sprite setTextureRect:spriteFrame.rect];
}

-(void) touchInStateSettings:(CGPoint)location
{
    if (CGRectContainsPoint([settingsMenu boundingBox], location)) {
        state = kStateChanging;
        settingsMenu.color = ccc3(0, 255, 255);
        
        homeSettings.color = ccWHITE;
        for (CCSprite *control in homeControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(-winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            if (control == homeLogo) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToHome)];
                id sequ = [CCSequence actions:ease, done, nil];
                [control runAction:sequ];
            }
            else {
                [control runAction:ease];
            }
        }
        for (CCSprite *control in settingsControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(-winSize.width, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            [control runAction:ease];
        }
        
        [UserConfig save];
    }
    else if (CGRectContainsPoint([settingsFlipValue boundingBox], location)
             || CGRectContainsPoint([settingsFlip boundingBox], location)) {
        state = kStateChanging;
        int drawCards = [[UserConfig sharedUserConfig] drawCards];
        if (drawCards == 1) {
            drawCards = 3;
        } else {
            drawCards = 1;
        }
        [UserConfig sharedUserConfig].drawCards = drawCards;
        
        id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:0];
        id change = [CCCallFuncND actionWithTarget:self selector:@selector(changeTexture:data:) data:(drawCards==1)?@"settings_flip_1.png":@"settings_flip_3.png"];
        id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:1];
        id ease = [CCEaseBackOut actionWithAction:zoomOut];
        id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToSettings)];
        id sequ = [CCSequence actions:zoomIn, change, ease, done, nil];
        [settingsFlipValue runAction:sequ];
    }
    else if (CGRectContainsPoint([settingsAnimationValue boundingBox], location)
             || CGRectContainsPoint([settingsAnimation boundingBox], location)) {
        state = kStateChanging;
        [UserConfig sharedUserConfig].startGameAnimation = ![UserConfig sharedUserConfig].startGameAnimation;

        id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:0];
        id change = [CCCallFuncND actionWithTarget:self selector:@selector(changeTexture:data:) data:([UserConfig sharedUserConfig].startGameAnimation)?@"settings_on.png":@"settings_off.png"];
        id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:1];
        id ease = [CCEaseBackOut actionWithAction:zoomOut];
        id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToSettings)];
        id sequ = [CCSequence actions:zoomIn, change, ease, done, nil];
        [settingsAnimationValue runAction:sequ];
    }
    else if (CGRectContainsPoint([settingsAutoFlipValue boundingBox], location)
             || CGRectContainsPoint([settingsAutoFlip boundingBox], location)) {
        state = kStateChanging;
        [UserConfig sharedUserConfig].autoFlipTopCard = ![UserConfig sharedUserConfig].autoFlipTopCard;
        
        id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:0];
        id change = [CCCallFuncND actionWithTarget:self selector:@selector(changeTexture:data:) data:([UserConfig sharedUserConfig].autoFlipTopCard)?@"settings_on.png":@"settings_off.png"];
        id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:1];
        id ease = [CCEaseBackOut actionWithAction:zoomOut];
        id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToSettings)];
        id sequ = [CCSequence actions:zoomIn, change, ease, done, nil];
        [settingsAutoFlipValue runAction:sequ];
    }
    else if (CGRectContainsPoint([settingsShakeCardValue boundingBox], location)
             || CGRectContainsPoint([settingsShakeCard boundingBox], location)) {
        state = kStateChanging;
        [UserConfig sharedUserConfig].shakeCard = ![UserConfig sharedUserConfig].shakeCard;
        
        id zoomIn = [CCScaleTo actionWithDuration:0.1f scale:0];
        id change = [CCCallFuncND actionWithTarget:self selector:@selector(changeTexture:data:) data:([UserConfig sharedUserConfig].shakeCard)?@"settings_on.png":@"settings_off.png"];
        id zoomOut = [CCScaleTo actionWithDuration:0.1f scale:1];
        id ease = [CCEaseBackOut actionWithAction:zoomOut];
        id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToSettings)];
        id sequ = [CCSequence actions:zoomIn, change, ease, done, nil];
        [settingsShakeCardValue runAction:sequ];
    }
}

-(void) touchInStateScene:(CGPoint)location
{
    if (CGRectContainsPoint([sceneMenu boundingBox], location)) {
        state = kStateChanging;
        sceneMenu.color = ccc3(0, 255, 255);
        
        homeStart.color = ccWHITE;
        id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(0, winSize.height)];
        id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
        id done = [CCCallFunc actionWithTarget:self selector:@selector(changeStateToHome)];
        id sequ = [CCSequence actions:ease, done, nil];
        [homePanel runAction:sequ];
        
        for (CCSprite *control in homeControls) {
            id move = [CCMoveBy actionWithDuration:kHomeStateChangeDuration position:ccp(0, winSize.height)];
            id ease = [CCEaseInOut actionWithAction:move rate:kEaseInOutRate];
            [control runAction:ease];
        }
    }
    
    for (int i=0; i<sceneStartButtons.count; i++) {
        CCSprite *button = [sceneStartButtons objectAtIndex:i];
        if (CGRectContainsPoint([button boundingBox], location)) {
            button.color = ccc3(0, 255, 255);
            [UserConfig sharedUserConfig].scene = i;
            [UserConfig sharedUserConfig].cardBg = i;
             CCScene *scene = [GameScene scene];
             CCTransitionFade *tran = [CCTransitionFade transitionWithDuration:kSceneSwitchDuration
             scene:scene withColor:ccWHITE];
             [[CCDirector sharedDirector] replaceScene:tran];
            
            return;
        }
    }
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [CommonHelper locationFromTouch:touch];
    if (state == kStateHome) {
        [self touchInStateHome:location];
    } 
    else if (state == kStateAbout) {
        [self touchInStateAbout:location];
    }
    else if (state == kStateSettings) {
        [self touchInStateSettings:location];
    }
    else if (state == kStateScene) {
        [self touchInStateScene:location];
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
