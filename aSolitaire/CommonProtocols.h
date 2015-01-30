//
//  CommonProtocols.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef aSolitaire_CommonProtocols_h
#define aSolitaire_CommonProtocols_h

typedef enum 
{
    kDummy = -1,
    kSpade = 0,
    kHeart = 1,
    kDiamond = 2,
    kClub = 3,
} CardSuit;

typedef enum {
    kBlack = 0,
    kRed = 1,
} CardColor;

typedef enum {
    kAce = 1,
    k2,
    k3,
    k4,
    k5,
    k6,
    k7,
    k8,
    k9,
    k10,
    kJack,
    kQueen,
    kKing = 13,
} CardNumber;

#endif
