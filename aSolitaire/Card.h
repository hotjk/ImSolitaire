//
//  Card.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CommonProtocols.h"

@interface Card : CCSprite {
    CardSuit suit;
    CardColor cColor;
    CardNumber number;
    
    CGRect frontTextureRect_;
    BOOL faceUp_;
}

@property (nonatomic, assign, readonly) CardSuit suit;
@property (nonatomic, assign, readonly) CardColor cColor;
@property (nonatomic, assign, readonly) CardNumber number;
@property (nonatomic, assign, readonly) int index;

+(id) cardWithSuit:(CardSuit)s andNumber:(CardNumber)n;

-(void) switchTextureToFront;

-(void) restore;

@end
