//
//  BonusCard.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BonusCard.h"
#import "Constants.h"


@implementation BonusCard

@synthesize point;

-(id) initWithPoint:(int)pt
{
    if (self = [super initWithSpriteFrameName:kBonusBackgroundTextureName]) {
        faceUp_ = NO;
        point = pt;
    }
    return self;
}

+(id) cardWithPoint:(int)pt
{
    return [[self alloc] initWithPoint:pt];
}

-(void) switchTextureToFront
{
    if (faceUp_) {
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:kBonusBackgroundTextureName];
        [self setTextureRect:spriteFrame.rect];
    } else {
        NSString *frontImage = [NSString stringWithFormat:kBonusFrontTextureName, point];
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:frontImage];
        [self setTextureRect:spriteFrame.rect];
    }
    faceUp_ = !faceUp_;
}

@end
