//
//  HomeLayer.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    kStateChanging = 0,
    kStateHome,
    kStateSettings,
    kStateAbout,
    kStateScene
} HomeState;

enum homeLayerZOrder {
    kBackground = 0,
    kSuitSpade,
    kSuitHeart,
    kSuitClub,
    kSuitDiamond,
    kSceneBatchNode,
    kMyScore,
    kPanel,
    kBatchNode
};

@interface HomeLayer : CCLayer {
    CCSpriteBatchNode *spriteBatchNode;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    CCSprite *homePanel;
    CCSprite *homeLogo;
    CCSprite *homeStart;
    CCSprite *homeSettings;
    CCSprite *homeAbout;
    
    CCSprite *aboutStaff;
    CCSprite *aboutMenu;
    
    CCSprite *settingsFlip;
    CCSprite *settingsAnimation;
    CCSprite *settingsAutoFlip;
    CCSprite *settingsShakeCard;
    CCSprite *settingsMenu;
    
    CCSprite *settingsFlipValue;
    CCSprite *settingsAnimationValue;
    CCSprite *settingsAutoFlipValue;
    CCSprite *settingsShakeCardValue;
    
    CCArray *homeControls;
    CCArray *aboutControls;
    CCArray *settingsControls;
    
    CCArray *sceneStartButtons;
    CCSprite *sceneMenu;
    
    HomeState state;
    CGSize winSize;
}

+(id) scene;

@end
