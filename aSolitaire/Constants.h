//
//  Constants.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef aSolitaire_Constants_h
#define aSolitaire_Constants_h

#define kCardFrontTextureName @"a%d_b%d.png"
#define kCardBackgroundTextureName @"bg%d.png"
#define kCardPlaceHolderTextureName @"ph%d.png"
#define kCardDragHolderTextureName @"dh.png"
#define kBonusFrontTextureName @"bonus_%d.png"
#define kBonusBackgroundTextureName @"bonus_bg.png"
#define kCardRotationAngleMax 5
#define kFlipDuration 0.6f
#define kFlipScaleRate 1.1f
#define kFlipDelay 0.15f
#define kFlipBackDuration 0.6f
#define kFlipBackDelay 0.1f
#define kWasteOffsetDelay 0.3f
#define kWasteOffsetDuration 0.2f
#define kTableauFlipDuration 0.2f
#define kDragScaleDuration 0.1f
#define kDragScaleRate 1.4f
#define kDragCancelDuration 0.2f
#define kDragDropDuration 0.1f
#define kIntersectionRatio 0.4f
#define kResetCardsOffsetDuration 0.1f
#define kGamePauseLayerFadeDuration 0.5f
#define kSceneSwitchDuration 0.5f
#define kStartGameAnimationDuration 2.0f
#define kStartGameAnimationPrefix (-1.8f)
#define kStartGameAnimationDelay 0.05f
#define kStartGameStockComeInPrefix 0.25f
#define kAutoFlipDelay 0.2f
#define kStartGameAutoFlipDelay 0.5f
#define kStartGameAutoFlipInterval 0.1f
#define kAutoTableauToFoundationPrefix 0.3f
#define kAutoTableauToFoundationDuration 1.0f
#define kAutoTableauToFoundationDelay 0.2f
#define kAutoTableauToFoundationEaseRate 3.0f
#define kCardsGoOutPrefix 1.5f
#define kCardsGoOutDuration 2.0f
#define kCardsGoOutDelay 0.1f
#define kPlaceHolderFadeOutDuration 0.5f
#define kEaseOutRate 3.0f
#define kEaseInRate 3.0f
#define kEaseInOutRate 3.0f
#define kHomeStateChangeDuration 0.5f
#define kDebug YES

enum gameLayerZOrder {
    kGameLayerCardsSpriteBatchNodeZ = 0,
    kGameLayerPlaceHolderZ = 1,
    kGameLayerCardsZFrom = 2,
};

#define kGameLayerDragZ 99999
#define kGameLayerMenuZ 100000


#endif
