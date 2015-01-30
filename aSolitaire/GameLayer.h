//
//  GameLayer.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Stock.h"
#import "Waste.h"
#import "Tableau.h"
#import "Reserve.h"
#import "Foundation.h"
#import "GamePauseLayer.h"

@interface GameLayer : CCLayer {
    CGSize cardSize_;
    CCSpriteBatchNode *cardsSpriteBatchNode;
    
    Stock *stock;
    Waste *waste;
    CCArray *foundations;
    CCArray *tableaux;
    Reserve *reserve;
    
    CCSprite *menuSprite;

    
    CCArray *allCards;
    NSArray *randomArray;
    
    NSInteger layerCardZ;
    NSInteger stockToWasteNum;
    BOOL inAction;
    BOOL inAnimation;
}

@property(nonatomic, assign) NSInteger stockToWasteNum;

+(GameLayer*) sharedGameLayer;
+(id) node;

-(void) newGame;
-(void)cancelTouch;

@end
