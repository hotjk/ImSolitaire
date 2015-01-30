//
//  GameLayer.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 ccTouchBegan:withEvent:
    moveCardsFromStockToWaste:(BE)
        moveCardFromStockToWasteDone:data:
    moveCardsFromWasteToStock:(BE)
        moveCardFromWasteToStockDone:data:
    dragStart(B)
    flipTopCard:OfTableau:withDelay:(B)
        flipTopCardOfTableauDone:data:(E)
 ccTouchEnded:withEvent:
    dropTo:Cards:
        dropDone:data:
            flipTopCardOfTableaux(E)
                flipTopCard:OfTableau:withDelay:(B)
                    flipTopCardOfTableauDone:data:(E)
    dropCancel:Cards:
        dropDone:data:
            ...
*/
#import "GameLayer.h"
#import "cocos2d.h"
#import "Card.h"
#import "Constants.h"
#import "HomeLayer.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "LogHelper.h"
#import "UserConfig.h"
#import "DeviceConfig.h"
#import "CommonHelper.h"
#include <stdlib.h>

@implementation GameLayer

@synthesize stockToWasteNum;

static GameLayer *instanceOfGameLayer;

#pragma mark -
#pragma mark Debug

-(void)printSolitaire
{
    if (!kDebug) {
        return;
    }
    
    NSLog(@"--------");
    [LogHelper printCards:stock.cards withTitle:@"Stock "];
    [LogHelper printCards:waste.cards withTitle:@"Waste "];
    for (int i=0; i<tableaux.count; i++) {
        Tableau *tableau = [tableaux objectAtIndex:i];
        [LogHelper printCards:tableau.squaredCards 
                    withTitle:[NSString stringWithFormat:@"Tableau %d squared ", i]];
        [LogHelper printCards:tableau.cards 
                    withTitle:[NSString stringWithFormat:@"Tableau %d fanned ", i]];
    }
}

#pragma mark -
#pragma mark Static

+(GameLayer *) sharedGameLayer
{
    return instanceOfGameLayer;
}



#pragma mark -
#pragma mark Properties

-(void) actionBegin
{
    inAction = YES;
}

-(void)actionEnd
{
    inAction = NO;
}

-(void)animationBegin
{
    inAnimation = YES;
}

-(void)animationEnd
{
    inAnimation = NO;
}

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

#pragma mark -
#pragma mark GameOver

-(void)cardsGoOutDone
{
    [[BonusLayer sharedBonusLayer] start];
}

-(void)cardsGoOut
{
    [[BonusLayer sharedBonusLayer] newFireworks];
    for (Foundation *foundation in foundations) {
        if (foundation.cards.count != 13) {
            return;
        }
    }
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    [stock.placeHolder runAction:[CCFadeOut actionWithDuration:kPlaceHolderFadeOutDuration]];
    for (Foundation *foundation in foundations) {
        [foundation.placeHolder runAction:[CCFadeOut actionWithDuration:kPlaceHolderFadeOutDuration]];
    }
    for (Tableau *tableau in tableaux) {
        [tableau.placeHolder runAction:[CCFadeOut actionWithDuration:kPlaceHolderFadeOutDuration]];
    }
    [menuSprite runAction:[CCFadeOut actionWithDuration:kPlaceHolderFadeOutDuration]];

    int actionIndex = 0;
    for (int f=0; f<foundations.count; f++) {
        Foundation *foundation = [foundations objectAtIndex:f];
        int targetIndex = 0;
        for (int i=foundation.cards.count-1; i>=0; i--) {
            Card *card = [foundation.cards objectAtIndex:i];
            id delay = [CCDelayTime actionWithDuration:actionIndex*kCardsGoOutDelay + kCardsGoOutPrefix];
            id move = [CCMoveBy actionWithDuration:kCardsGoOutDuration position:ccp(-size.width + (targetIndex * size.width / 10), -size.height)];

            id sound = [CCCallFunc actionWithTarget:self selector:@selector(playDropSound)];
            
            if (f == 3 && i== 0) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(cardsGoOutDone)];
                id sequence = [CCSequence actions:delay, sound, move, done, nil];
                [card runAction:sequence];
            }
            else {
                id sequence = [CCSequence actions:delay, sound, move, nil];
                [card runAction:sequence];
            }
            targetIndex++;
            actionIndex++;
        }
    }
}

-(BOOL)gameoverCheck
{
    Foundation* foundation;
    CCARRAY_FOREACH(foundations, foundation) {
        if (foundation.cards.count != 13) {
            return NO;
        }
    }
    [self cardsGoOut];
    return YES;
}

#pragma mark -
#pragma mark Tableau to foundation

-(void) moveCardFromTableauToFoundationDone:(id)sender data:(Card*)card
{
    [card stopAllActions];
    Foundation* foundation = (Foundation*)card.userData;
    [foundation dropEnd];
    card.userData = nil;
    [foundation.cards addObject:card];
    
    [self gameoverCheck];
}

-(void)reorderCard:(id)sender data:(Card*)card{
    [cardsSpriteBatchNode reorderChild:card z:layerCardZ++];
}
-(void)moveCard:(Card*)card FromTableau:(Tableau*)tableau ToFoundation:(Foundation*)foundation withDelay:(float)delayTime
{
    [tableau.cards removeLastObject];
    card.userData = foundation;

    id delay = [CCDelayTime actionWithDuration:delayTime];
    id move = [CCMoveTo actionWithDuration:kAutoTableauToFoundationDuration position:[foundation nextDropPoint]];
    id ease = [CCEaseOut actionWithAction:move rate:kAutoTableauToFoundationEaseRate];
    id reorder = [CCCallFuncND actionWithTarget:self selector:@selector(reorderCard:data:) data:card];    
    id done = [CCCallFuncND actionWithTarget:self selector:@selector(moveCardFromTableauToFoundationDone:data:) data:card];
    id sound = [CCCallFunc actionWithTarget:self selector:@selector(playDropSound)];
    id sequence = [CCSequence actions:delay, reorder, sound, ease, done, nil];
    [card runAction:sequence];
}

-(BOOL)autoCollection
{
    if (stock.cards.count > 0 || waste.cards.count > 0) {
        return NO;
    }
    
    //[self printSolitaire];
    for (Tableau* tableau in tableaux) {
        if (tableau.squaredCards.count > 0){
            return NO;
        }
    }
    
    [self animationBegin];
    
    int minIndex = 52;
    for (Tableau* tableau in tableaux) {
        Card* card = [tableau.cards lastObject];
        if (card == nil) {
            continue;
        }
        if (card.index < minIndex) {
            minIndex = card.index;
        }
    }
    
    int delayIndex = 0;
    for (int i=minIndex; i<=52; i++) {
        for (Tableau* tableau in tableaux) {
            Card* card = [tableau.cards lastObject];
            Foundation* foundation = nil;
            if (card.index == i) {
                if (card.number == kAce) {
                    for (Foundation* f in foundations) {
                        if (f.cards.count == 0 && f.suit == kDummy) {
                            foundation = f;
                            f.suit = card.suit;
                            break;
                        }
                    }
                } else {
                    for (Foundation* f in foundations) {
                        if (f.suit == card.suit || 
                            (f.cards.count > 0 && [f.cards.lastObject suit] == card.suit)) {
                            foundation = f;
                            break;
                        }
                    }
                }
                [self moveCard:card FromTableau:tableau ToFoundation:foundation withDelay:kAutoTableauToFoundationDelay * (float)delayIndex + kAutoTableauToFoundationPrefix];
                delayIndex++;
                break;
            }
        }
    }
    return YES;
}

#pragma mark -
#pragma mark Tableau flip

-(void) flipTopCardOfTableauDone:(id)sender data:(Card*)card
{
    [card stopAllActions];
    [self removeChild:card cleanup:YES];
    [cardsSpriteBatchNode addChild:card z:layerCardZ];
    
    Tableau *tableau = (Tableau *)card.userData;
    [tableau.cards addObject:card];
    card.userData = nil;
    
    [self actionEnd];
    
    [self autoCollection];
}

-(void) flipTopCardOfTableau:(id)sender data:(void *)data
{
    Tableau* tableau = (Tableau*)data;
    [self actionBegin];
    Card *card = [[tableau squaredCards] lastObject];
    [card retain];
    [cardsSpriteBatchNode removeChild:card cleanup:YES];
    [self addChild:card z:layerCardZ++];
    [card release];
    [tableau.squaredCards removeObject:card];
    card.userData = tableau;
    
    id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
    id flipFirstHalf = [CCOrbitCamera actionWithDuration:kTableauFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
    id zoomIn = [CCScaleTo actionWithDuration:kTableauFlipDuration*0.25f scale:kFlipScaleRate];
    id zoomInAndFlip = [CCSpawn actions:zoomIn, flipFirstHalf, nil];
    id flipSecondHalf = [CCOrbitCamera actionWithDuration:kTableauFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:90 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
    id zoomOut = [CCScaleTo actionWithDuration:kTableauFlipDuration*0.25f scale:1.0f];
    id zoomOutAndflip = [CCSpawn actions:flipSecondHalf, zoomOut, nil];
    id switchTextureAction = [CCCallFuncND actionWithTarget:self selector:@selector(flipCard:data:) data:card];
    id flip = [CCSequence actions:zoomInAndFlip, switchTextureAction, zoomOutAndflip, nil];
    id restoreCardToSpriteBatchNode = [CCCallFuncND actionWithTarget:self selector:@selector(flipTopCardOfTableauDone:data:) data:card];
        id flipAndRestore = [CCSequence actions:sound, flip, restoreCardToSpriteBatchNode, nil];
        [card runAction:flipAndRestore];
}

-(void) flipTopCard:(Card*) card OfTableau:(Tableau*)tableau withDelay:(float) delay
{
    [self actionBegin];
    
    [card retain];
    [cardsSpriteBatchNode removeChild:card cleanup:YES];
    [self addChild:card z:layerCardZ++];
    [card release];
    [tableau.squaredCards removeObject:card];
    card.userData = tableau;
    
    id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
    id flipFirstHalf = [CCOrbitCamera actionWithDuration:kTableauFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
    id zoomIn = [CCScaleTo actionWithDuration:kTableauFlipDuration*0.25f scale:kFlipScaleRate];
    id zoomInAndFlip = [CCSpawn actions:zoomIn, flipFirstHalf, nil];
    id flipSecondHalf = [CCOrbitCamera actionWithDuration:kTableauFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:90 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
    id zoomOut = [CCScaleTo actionWithDuration:kTableauFlipDuration*0.25f scale:1.0f];
    id zoomOutAndflip = [CCSpawn actions:flipSecondHalf, zoomOut, nil];
    id switchTextureAction = [CCCallFuncND actionWithTarget:self selector:@selector(flipCard:data:) data:card];
    id flip = [CCSequence actions:zoomInAndFlip, switchTextureAction, zoomOutAndflip, nil];
    id restoreCardToSpriteBatchNode = [CCCallFuncND actionWithTarget:self selector:@selector(flipTopCardOfTableauDone:data:) data:card];
    if (delay > 0) {
        id d = [CCDelayTime actionWithDuration:delay];
        id flipAndRestore = [CCSequence actions:d, sound, flip, restoreCardToSpriteBatchNode, nil];        
        [card runAction:flipAndRestore];
    }
    else {
        id flipAndRestore = [CCSequence actions:sound, flip, restoreCardToSpriteBatchNode, nil];
        [card runAction:flipAndRestore];
    }
}


#pragma mark -
#pragma mark Init

-(void) releaseGameObjects
{
    if (stock != nil) {
        [stock release];
        stock = nil;
    }
    if (waste != nil) {
        [waste release];
        waste = nil;
    }
    if (foundations != nil) {
        [foundations release];
        foundations = nil;
    }
    if (tableaux != nil) {
        [tableaux release];
        tableaux = nil;
    }
    if (allCards != nil) {
        [allCards release];
        allCards = nil;
    }
}

-(void) initGameObjects
{
    //menuSprite = [CCSprite spriteWithFile:@"menu.png"];
    menuSprite = [CCSprite spriteWithSpriteFrameName:@"btn_menu.png"];
    [menuSprite setPosition:[[DeviceConfig sharedDeviceConfig] menuButtonPosition]];
    [self addChild:menuSprite];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[[DeviceConfig sharedDeviceConfig] cardsSpriteFrameFileName]];
    cardsSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:[[DeviceConfig sharedDeviceConfig] cardsBatchNodeFileName] capacity:100];
    
    [self addChild:cardsSpriteBatchNode z:kGameLayerCardsSpriteBatchNodeZ];
    
    NSString *bgfile = [NSString stringWithFormat:kCardBackgroundTextureName, [[UserConfig sharedUserConfig] cardBg]];
    CCSprite *temp = [[CCSprite alloc] initWithSpriteFrameName:bgfile];
    cardSize_ = temp.boundingBox.size;
    
    [self releaseGameObjects];
    
    stock = [[Stock alloc] init];
    waste = [[Waste alloc] init];
    
    if (stockToWasteNum == 1) {
        [waste noOffset];
    }
    
    foundations = [[CCArray alloc] initWithCapacity:4];
    for (NSInteger i=0; i<4; i++) {
        Foundation *foundation = [[Foundation alloc] initWithIndex:i];
        [foundations addObject:foundation];
        [foundation release];
    }
    tableaux = [[CCArray alloc] initWithCapacity:7];
    for (NSInteger i=0; i<7; i++) {
        Tableau *tableau = [[Tableau alloc] initWithIndex:i];
        [tableaux addObject:tableau];   
        [tableau release];
    }

    allCards = [[CCArray alloc] initWithCapacity:13*4];
    for (NSInteger suit = kSpade; suit <= kClub; suit++) {
        for (NSInteger number = kAce; number <= kKing; number++) {
            Card *card = [Card cardWithSuit:suit andNumber:number];
            [allCards addObject:card];
        }
    }
}

-(void) cleanupGameObjects
{
    [cardsSpriteBatchNode removeAllChildrenWithCleanup:YES];
    [[stock cards] removeAllObjects];
    [[waste cards] removeAllObjects];
    for (Foundation* foundation in foundations) {
        [[foundation cards] removeAllObjects];
    }
    for (Tableau *tableau in tableaux) {
        [[tableau squaredCards] removeAllObjects];
        [[tableau cards] removeAllObjects];
    }
}

-(void) newGameInitPlaceHolder
{
    [cardsSpriteBatchNode addChild:stock.placeHolder z:kGameLayerPlaceHolderZ];
    for (Foundation* foundation in foundations) {
        [cardsSpriteBatchNode addChild:foundation.placeHolder z:kGameLayerPlaceHolderZ];
    }
    for (Tableau *tableau in tableaux) {
        [cardsSpriteBatchNode addChild:tableau.placeHolder z:kGameLayerPlaceHolderZ];
    }
}

-(void) flipTopCardOfTableaux
{
    if (![[UserConfig sharedUserConfig] autoFlipTopCard]) {
        [self actionEnd];
        return;
    }
    int index = 0;
    for (Tableau* tableau in tableaux) {
        Card * card = tableau.squaredCard;
        if (card != nil) {
            [self flipTopCard:card 
                    OfTableau:tableau withDelay: (index++) * kStartGameAutoFlipInterval];
        }
    }
    if (index == 0) {
        [self actionEnd];
    }
}

-(void) cardsComeIn
{
    [self animationBegin];
    
    BOOL skipAnim = ![[UserConfig sharedUserConfig] startGameAnimation];
    
    CGPoint cardSource = [[DeviceConfig sharedDeviceConfig] cardSourcePoint];
    CGSize size = [[CCDirector sharedDirector] winSize]; 
    int actionIndex = 0;
    NSInteger cardIndex = cardsSpriteBatchNode.children.count - 13*4;
    for (NSInteger i=0; i<7; i++) {
        Tableau *tableau = [tableaux objectAtIndex:i];
        for (NSInteger j=0; j<i+1; j++) {
            Card *card = [cardsSpriteBatchNode.children objectAtIndex:cardIndex++];
            [tableau.squaredCards addObject:card];

            CGPoint target = ccp(tableau.origin.x, 
                                 tableau.origin.y + j * tableau.squaredOffset.height);
            if (skipAnim) {
                [card setPosition:target];
            } else {
                CGPoint source = CGPointMake(cardSource.x-size.width, cardSource.y);
                [card setPosition:source];
                id move = [CCMoveTo actionWithDuration:kStartGameAnimationDuration position:target];
                //id ease = [CCEaseOut actionWithAction:move rate:kEaseOutRate];
                id delay = [CCDelayTime actionWithDuration: kSceneSwitchDuration + kStartGameAnimationPrefix + kStartGameAnimationDelay * actionIndex++];
                id sound = [CCCallFunc actionWithTarget:self selector:@selector(playDropSound)];
                id sequence = [CCSequence actions:delay, move, sound, nil];
                [card runAction:sequence];
            }
        }
        actionIndex = actionIndex + 5;
    }
    for (NSInteger i=0; i<13*4-1-2-3-4-5-6-7; i++) {
        Card *card = [cardsSpriteBatchNode.children objectAtIndex:cardIndex++];
        [stock.cards addObject:card];
        
        if (skipAnim) {
            [card setPosition:stock.origin];
        } else {
            [card setPosition:cardSource];
            id move = [CCMoveTo actionWithDuration:kStartGameAnimationDuration * 0.25 position:stock.origin];
            //id ease = [CCEaseOut actionWithAction:move rate:kEaseOutRate];
            if (i < 10) {
                id delay = [CCDelayTime actionWithDuration: kSceneSwitchDuration + kStartGameStockComeInPrefix + kStartGameAnimationDelay * actionIndex++];
                id sound = [CCCallFunc actionWithTarget:self selector:@selector(playDropSound)];
                id sequence = [CCSequence actions:delay, move, sound,nil];
                [card runAction:sequence];
            } else {
                id delay = [CCDelayTime actionWithDuration: kSceneSwitchDuration + kStartGameStockComeInPrefix + kStartGameAnimationDelay * actionIndex];
                if (i != (13*4-1-2-3-4-5-6-7) - 1) {
                    id sequence = [CCSequence actions:delay, move, nil];
                    [card runAction:sequence];
                }
                else { // last card
                    id d = [CCDelayTime actionWithDuration: kStartGameAutoFlipDelay];
                    id autoflip = [CCCallFunc actionWithTarget:self selector:@selector(flipTopCardOfTableaux)];
                    id d2 = [CCDelayTime actionWithDuration:7 * kStartGameAutoFlipInterval + kTableauFlipDuration];
                    id actionDone = [CCCallFunc actionWithTarget:self selector:@selector(animationEnd)];
                    id sequance = [CCSequence actions:delay, move, d, autoflip, d2, actionDone, nil];
                    [card runAction:sequance];
                }
            }
        }
    }
    if (skipAnim) {
        id d = [CCDelayTime actionWithDuration:kStartGameAutoFlipDelay];
        id autoflip = [CCCallFunc actionWithTarget:self selector:@selector(flipTopCardOfTableaux)];
        id d2 = [CCDelayTime actionWithDuration:7 * kStartGameAutoFlipInterval];
        id actionDone = [CCCallFunc actionWithTarget:self selector:@selector(animationEnd)];
        id sequance = [CCSequence actions: d, autoflip, d2, actionDone, nil];
        [self runAction:sequance];
    }
}

-(void) cardsComeIn_TEST
{   
    NSInteger cardIndex = cardsSpriteBatchNode.children.count - 13*4;
    for (NSInteger i=0; i<4; i++) {
        Tableau *tableau = [tableaux objectAtIndex:i];
        for(int j=0 ;j<13;j++){
            if (i == 3 && j == 12 ) {
                break;
            }
            Card *card = [cardsSpriteBatchNode.children objectAtIndex:cardIndex++];
            [card switchTextureToFront];
            
            [tableau.cards addObject:card];
            CGPoint target = ccp(tableau.origin.x, 
                                 tableau.origin.y + j * (-12));
            [card setPosition:target];
        }
    }
    Tableau *tableau = [tableaux objectAtIndex:4];
    Card *card = [cardsSpriteBatchNode.children objectAtIndex:cardIndex++];
    [tableau.squaredCards addObject:card];
    CGPoint target = ccp(tableau.origin.x, tableau.origin.y);
    [card setPosition:target];
    
    [self animationEnd];
    [self actionEnd];
    //[self printSolitaire];
}


-(void) newGame
{
    Card* card;
    CCARRAY_FOREACH(allCards, card)
    {
        if (card) {
            [card restore];
        }
    }
    
    layerCardZ = kGameLayerCardsZFrom;
    
    [self cleanupGameObjects];
    
    if (randomArray == nil) {
        randomArray = [CommonHelper shuffle:13*4];
        [randomArray retain];
    }
    BOOL bShakeCard = [[UserConfig sharedUserConfig] shakeCard];
    for (NSNumber *n in randomArray) {
        Card* card = [allCards objectAtIndex:n.intValue];
        if (bShakeCard) [CommonHelper shakeCard:card];
        [cardsSpriteBatchNode addChild: card z:layerCardZ++];
    }
    
    [self newGameInitPlaceHolder];
    [self cardsComeIn];
}

-(void) newGame_TEST
{
    layerCardZ = kGameLayerCardsZFrom;
    
    [self cleanupGameObjects];
    BOOL bShakeCard = [[UserConfig sharedUserConfig] shakeCard];
    for (int i = 0; i<4; i++) {
        for (int j=12; j>=0; j--) {
            Card* card = [allCards objectAtIndex:i * 13 + j];
            if (bShakeCard) [CommonHelper shakeCard:card];
            [cardsSpriteBatchNode addChild: card z:layerCardZ++];
        }
        
    }
    
    [self newGameInitPlaceHolder];
    [self cardsComeIn_TEST];
}

-(id) init
{
    if (self == [super init]) {
        instanceOfGameLayer = self;
        [self actionBegin];
        stockToWasteNum = [[UserConfig sharedUserConfig] drawCards];
        
        [self initGameObjects];
        [self newGame];
        //[self newGame_TEST];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

+(id) node
{
    return [[[GameLayer alloc] init] autorelease];
}

-(void) dealloc
{
    cardsSpriteBatchNode = nil;
    instanceOfGameLayer = nil;
    [randomArray release];
    [allCards release];
    
    if (stock != nil) {
        [stock release];
        stock = nil;
    }
    if (waste != nil) {
        [waste release];
        waste = nil;
    }
    if (foundations != nil) {
        [foundations release];
        foundations = nil;
    }
    if (tableaux != nil) {
        [tableaux release];
        tableaux = nil;
    }
    
    [super dealloc];
}

#pragma mark -
#pragma mark General

-(void) flipCard:(id)sender data:(void *)data
{
    Card *card = (Card *)data;
    [card switchTextureToFront];
    [self reorderChild:card z:layerCardZ++];
    if( [[UserConfig sharedUserConfig] shakeCard] ) {
        [CommonHelper shakeCard:card];
    }
}

#pragma mark -
#pragma mark Waste to stock

-(void)gatherWasteCards
{
    for (int i=waste.cards.count-1; i>=0; i--) {
        Card* card = [waste.cards objectAtIndex:i];
        if (CGPointEqualToPoint(card.position,waste.origin)) {
            break;
        } else {
            id move = [CCMoveTo actionWithDuration:kWasteOffsetDuration position:waste.origin];
            [card runAction:move];
        }
    }
}

-(void)moveCardFromWasteToStockDone:(id)sender data:(Card*)card
{
    [card stopAllActions];
    [self removeChild:card cleanup:YES];
    [cardsSpriteBatchNode addChild:card z:layerCardZ];
    [stock.cards addObject:card];
    //[self printSolitaire];
}

-(void)moveCardsFromWasteToStock:(CCArray*) cards
{
    [self actionBegin];
    for (NSInteger i=0; i<cards.count; i++) {
        Card *card = [cards objectAtIndex:i];
        [cardsSpriteBatchNode removeChild:card cleanup:YES];
        [self addChild:card z:layerCardZ++];
        
        id offset = [CCMoveTo actionWithDuration:kWasteOffsetDuration position:waste.origin];
        id flipFirstHalf = [CCOrbitCamera actionWithDuration:kFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:90 angleX:0 deltaAngleX:0];
        id zoomIn = [CCScaleTo actionWithDuration:kFlipDuration*0.25f scale:kFlipScaleRate];
        id zoomInAndFlip = [CCSpawn actions:zoomIn, flipFirstHalf, nil];
        id easeIn = [CCEaseIn actionWithAction:zoomInAndFlip rate:0.5f];
        id flipSecondHalf = [CCOrbitCamera actionWithDuration:kFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:-90 deltaAngleZ:90 angleX:0 deltaAngleX:0];
        id zoomOut = [CCScaleTo actionWithDuration:kFlipDuration*0.25 scale:1.0f];
        id zoomOutAndflip = [CCSpawn actions:flipSecondHalf, zoomOut, nil];
        id easeOut = [CCEaseOut actionWithAction:zoomOutAndflip rate:0.5f];
        id switchTextureAction = [CCCallFuncND actionWithTarget:self selector:@selector(flipCard:data:) data:card];
        id flip = [CCSequence actions:easeIn, switchTextureAction, easeOut, nil];
        id move = [CCMoveTo actionWithDuration:kFlipBackDuration position: stock.origin];
        id flipAndMove = [CCSpawn actions:flip, move, nil];
        id delay = [CCDelayTime actionWithDuration:kFlipBackDelay * (cards.count-1-i)];
        id restoreCardToSpriteBatchNode = [CCCallFuncND actionWithTarget:self selector:@selector(moveCardFromWasteToStockDone:data:) data:card];
        id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
        
        if (i == 0) {
            id done = [CCCallFunc actionWithTarget:self selector:@selector(actionEnd)];
            id flipAndMoveAfterDelay = [CCSequence actions: offset, delay, flipAndMove, sound, restoreCardToSpriteBatchNode, done, nil];
            [card runAction:flipAndMoveAfterDelay];
        }
        else {
            id flipAndMoveAfterDelay = [CCSequence actions: offset, delay, flipAndMove, sound, restoreCardToSpriteBatchNode, nil];
            [card runAction:flipAndMoveAfterDelay];
        }
    }
}

#pragma mark -
#pragma mark Stock to waste

-(void)moveCardFromStockToWasteDone:(id)sender data:(Card*)card
{
    [card stopAllActions];
    [self removeChild:card cleanup:YES];
    [cardsSpriteBatchNode addChild:card z:layerCardZ];
    [waste.cards addObject:card];
    //[self printSolitaire];
}

-(void) moveCardsFromStockToWaste:(CCArray*)cards
{
    [self actionBegin];
    layerCardZ += cards.count;
    for (NSInteger i=0; i<cards.count; i++) {
        Card *card = [cards objectAtIndex:i];
        [cardsSpriteBatchNode removeChild:card cleanup:YES];
        [self addChild:card z:layerCardZ-i];
        
        id flipFirstHalf = [CCOrbitCamera actionWithDuration:kFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:0 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
        id zoomIn = [CCScaleTo actionWithDuration:kFlipDuration*0.25f scale:kFlipScaleRate];
        id zoomInAndFlip = [CCSpawn actions:zoomIn, flipFirstHalf, nil];
        id flipSecondHalf = [CCOrbitCamera actionWithDuration:kFlipDuration*0.5f radius:1 deltaRadius:0 angleZ:90 deltaAngleZ:-90 angleX:0 deltaAngleX:0];
        id zoomOut = [CCScaleTo actionWithDuration:kFlipDuration*0.25 scale:1.0f];
        id zoomOutAndflip = [CCSpawn actions:flipSecondHalf, zoomOut, nil];
        id switchTextureAction = [CCCallFuncND actionWithTarget:self selector:@selector(flipCard:data:) data:card];
        id flip = [CCSequence actions:zoomInAndFlip, switchTextureAction, zoomOutAndflip, nil];
        id move = [CCMoveTo actionWithDuration:kFlipDuration position: waste.origin];
        id flipAndMove = [CCSpawn actions:flip, move, nil];
        id sound = [CCCallFunc actionWithTarget:self selector:@selector(playFlipSound)];
        id soundDelay = [CCDelayTime actionWithDuration:kFlipDuration * 0.5];
        id soundWithDelay = [CCSequence actions:soundDelay, sound, nil];
        
        if (stockToWasteNum > 1) {
            id offsetDelay = [CCDelayTime actionWithDuration:kWasteOffsetDelay-kFlipDuration*0.25f*i];
            id offset = [CCMoveTo actionWithDuration:kWasteOffsetDuration 
                                            position:[waste cardOrigin:i]];
            id delay = [CCDelayTime actionWithDuration:kFlipDelay * i];
            id restoreCardToSpriteBatchNode = [CCCallFuncND actionWithTarget:self selector:@selector(moveCardFromStockToWasteDone:data:) data:card];
            if (i == cards.count - 1) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(actionEnd)];
                id flipAndMoveAfterDelay = [CCSequence actions:delay, [CCSpawn actions:soundWithDelay, flipAndMove, nil], offsetDelay, offset, restoreCardToSpriteBatchNode, done, nil];
                [card runAction:flipAndMoveAfterDelay];
            }
            else {
                id flipAndMoveAfterDelay = [CCSequence actions:delay, [CCSpawn actions:soundWithDelay, flipAndMove, nil], offsetDelay, offset, restoreCardToSpriteBatchNode, nil];
                [card runAction:flipAndMoveAfterDelay];
            }
        } else {
            id delay = [CCDelayTime actionWithDuration:kFlipDelay * i];
            id restoreCardToSpriteBatchNode = [CCCallFuncND actionWithTarget:self selector:@selector(moveCardFromStockToWasteDone:data:) data:card];
            if (i == cards.count - 1) {
                id done = [CCCallFunc actionWithTarget:self selector:@selector(actionEnd)];
                id flipAndMoveAfterDelay = [CCSequence actions:delay, [CCSpawn actions:soundWithDelay, flipAndMove, nil], restoreCardToSpriteBatchNode, done, nil];
                [card runAction:flipAndMoveAfterDelay];
            }
            else
            {
                id flipAndMoveAfterDelay = [CCSequence actions:delay, sound, flipAndMove, restoreCardToSpriteBatchNode, nil];
                [card runAction:flipAndMoveAfterDelay];
            }
        }
    }
}



#pragma mark -
#pragma mark Drag

-(void)dragStart
{
    [self actionBegin];
    
    if ([reserve.dragFrom isKindOfClass:[Foundation class]]) {
        [((Foundation*)reserve.dragFrom) dragStart];
    }
    
    for (NSInteger i=0; i<reserve.cards.count; i++) {
        Card *card = [reserve.cards objectAtIndex:i];
        [cardsSpriteBatchNode removeChild:card cleanup:YES];
    }
    
    CCSprite *dragSprite = [[CCSprite alloc] initWithSpriteFrameName:kCardDragHolderTextureName];
    [dragSprite setPosition:reserve.clickCard.position];
    [cardsSpriteBatchNode addChild:dragSprite z:layerCardZ];
    reserve.dragHolder = dragSprite;
    for (int i =0; i<reserve.cards.count; i++) {
        Card *card = [reserve.cards objectAtIndex:i];
        [dragSprite addChild:card];
        [card setPosition:ccp(cardSize_.width * 0.5,
                              cardSize_.height * 0.5 + i * reserve.dragFromCardsOffset.height)];
    }

    CCScaleTo *scale = [CCScaleTo actionWithDuration:kDragScaleDuration scale:kDragScaleRate];
    //id ease = [CCEaseIn actionWithAction:scale rate:kEaseInRate];
    CCEaseBackOut *ease = [CCEaseBackOut actionWithAction:scale];
    [dragSprite runAction:ease];
    
    [self playFlipSound];
}

-(void) dropDone:(id)sender data:(CCArray*)targetCards
{
    [self playDropSound];
    
    [reserve.dragHolder stopAllActions];
    [reserve.dragHolder removeAllChildrenWithCleanup:YES];
    
    if (reserve.cards.count > 0)
    {
        for (int i=0; i<reserve.cards.count; i++) {
            Card *card = [reserve.cards objectAtIndex:i];
            [cardsSpriteBatchNode addChild:card z:layerCardZ++];
            [targetCards addObject:card];
            CGSize offset = reserve.dragFromCardsOffset;
            [card setPosition:ccp(reserve.dragHolder.position.x, 
                                          reserve.dragHolder.position.y + i * offset.height)];
        }
    }
    
    [reserve.dragHolder removeFromParentAndCleanup:YES];
    
    if ([reserve.dragFrom isKindOfClass:[Tableau class]]) {
        [((Tableau*)reserve.dragFrom) resetCardsOffset];
        
    }
    if ([reserve.dropTo isKindOfClass:[Tableau class]]) {
        [((Tableau*)reserve.dropTo) resetCardsOffset];
    }
        
    [reserve release];
    reserve = nil;
    
    if ([self gameoverCheck]) {
    }
    else 
    {
        [self autoCollection];
    }
    [self flipTopCardOfTableaux];
    
    //[self printSolitaire];
}

-(void)dropTo:(CGPoint)dropPoint cards:(CCArray *)targetCards
{
    if ([reserve.dropTo isKindOfClass:[Foundation class]]) {
        [((Foundation*)reserve.dropTo) dropEnd];
    }

    id scale = [CCScaleTo actionWithDuration:kDragScaleDuration scale:1.0f];
    id move = [CCMoveTo actionWithDuration:kDragDropDuration position:dropPoint];
    id ease = [CCEaseOut actionWithAction:move rate:kEaseOutRate];
    id spawn = [CCSpawn actions:scale, ease, nil];
    id callCompleteFuncAction = [CCCallFuncND actionWithTarget:self 
                                                      selector:@selector(dropDone:data:) 
                                                          data:targetCards];
    CCAction* sequance = [CCSequence actions:spawn, callCompleteFuncAction, nil];
    [reserve.dragHolder runAction:sequance];
}

-(void)dropCancel:(CCArray *)targetCards
{
    if ([reserve.dragFrom isKindOfClass:[Foundation class]]) {
        [((Foundation*)reserve.dragFrom) dropEnd];
    }
    
    id scale = [CCScaleTo actionWithDuration:kDragScaleDuration scale:1.0f];
    id move = [CCMoveTo actionWithDuration:kDragCancelDuration 
                                         position:[reserve.dragFrom nextDropPoint]];
    id ease = [CCEaseOut actionWithAction:move rate:kEaseOutRate];
    id spawn = [CCSpawn actions:scale, ease, nil];
    id callCompleteFuncAction = [CCCallFuncND actionWithTarget:self 
                                                      selector:@selector(dropDone:data:) 
                                                          data:targetCards];
    CCAction* sequance = [CCSequence actions:spawn, callCompleteFuncAction, nil];
    [reserve.dragHolder runAction:(sequance)];
}


#pragma mark -
#pragma mark Touch

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [CommonHelper locationFromTouch:touch];
    if (CGRectContainsPoint(menuSprite.boundingBox, location)) {
        [menuSprite setColor:ccc3(0, 255, 255)];
        id restore = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
        [menuSprite runAction:restore];
        [[[GameScene sharedScene] gamePauseLayer] pauseGame];
        [self cancelTouch];
        return NO;
    }
    
    if (inAnimation || inAction) {
        return YES; // fix a bug will hung the UI
    }
    if ([GameScene sharedScene].isPause) {
        return NO;
    }
    
    if ([stock rectContainPoint:location]) {
        CCArray *cards = [stock popCards:stockToWasteNum];
        if (cards.count > 0) {
            [self gatherWasteCards];
            [self moveCardsFromStockToWaste:cards];
        } else {
            CCArray *cards = [waste popAllCards];
            if (cards.count > 0) {
                [self moveCardsFromWasteToStock:cards];
            }
        }
        return NO;
    }
    
    Card* card = [waste cardClickAtPoint:location];
    if (card != nil) {
        reserve = [[Reserve alloc] initWithDragPoint:location 
                                             andCard:card 
                                         andGameArea:waste];
        [self dragStart];
        return YES;
    }
    
    Foundation *foundation;
    CCARRAY_FOREACH(foundations, foundation) {
        Card *card = [foundation cardClickAtPoint:location];
        if (card != nil) {
            reserve = [[Reserve alloc] initWithDragPoint:location 
                                                 andCard:card 
                                             andGameArea:foundation];
            [self dragStart];
            return YES;
        }
    }
    
    Tableau *tableau;
    CCARRAY_FOREACH(tableaux, tableau) {
        Card* card = [tableau squaredCardClickAtPoint:location];
        if (card != nil) {
            //[self actionBegin];
            [self flipTopCard:(Card*) card OfTableau:(Tableau*)tableau withDelay:0.0f];
            return NO;
        }

        card = [tableau cardClickAtPoint:location];
        if (card != nil) {
            reserve = [[Reserve alloc] initWithDragPoint:location 
                                                 andCard:card 
                                             andGameArea:tableau];
            [self dragStart];
            return YES;
        }
    }
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (reserve == nil) {
        return;
    }

    CGPoint location = [CommonHelper locationFromTouch:touch];
    CGPoint position = ccpAdd(location, reserve.clickPointOffset);
    [reserve.dragHolder setPosition:position];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [CommonHelper locationFromTouch:touch];
    
    if (reserve.cards.count == 1) {
        for (Foundation *foundation in foundations) {
            if ([foundation card:reserve canDropAtPoint:location]) {
                reserve.dropTo = foundation;
                [self dropTo:[foundation origin] cards:foundation.cards];
                return;
            }
        }
    }
    
    for (Tableau* tableau in tableaux) {
        if ([tableau card:reserve canDropAtPoint:location]) {
            reserve.dropTo = tableau;
            [self dropTo:[tableau nextDropPoint] cards:tableau.cards];
            return;
        }
    }

    [self dropCancel:reserve.dragFromCards];
}

-(void)cancelTouch
{
    if (reserve != nil) {
        [self dropCancel:reserve.dragFromCards];;
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
