//
//  Card.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 10/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Card.h"
#import "Constants.h"
#import "GameLayer.h"
#import "UserConfig.h"

@implementation Card
@synthesize suit;
@synthesize number;
@synthesize cColor;

-(int) index
{
    return (number -1) * 4 + suit;
}

-(id) initWithSuit:(CardSuit)s number:(CardNumber)n
{
    NSString *bgfile = [NSString stringWithFormat:kCardBackgroundTextureName, [[UserConfig sharedUserConfig] cardBg]];
    if (self = [super initWithSpriteFrameName:bgfile]) {
        suit = s;
        number = n;
        cColor = suit % 2;
        faceUp_ = NO;
        
        NSString *frontImage = [NSString stringWithFormat:kCardFrontTextureName, 
                                suit + 1, number];
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                      spriteFrameByName:frontImage];
        frontTextureRect_ = spriteFrame.rect;
    }
    return self;
}

+(id) cardWithSuit:(CardSuit)s andNumber:(CardNumber)n
{
    return [[[self alloc] initWithSuit:s number:n] autorelease];
}

-(void) switchTextureToFront
{
    if (faceUp_) {
        NSString *bgfile = [NSString stringWithFormat:kCardBackgroundTextureName, [[UserConfig sharedUserConfig] cardBg]];
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:bgfile];
        [self setTextureRect:spriteFrame.rect];
    } else {
        [self setTextureRect: frontTextureRect_];
    }
    faceUp_ = !faceUp_;
}
-(void) restore
{
    if (faceUp_) {
        NSString *bgfile = [NSString stringWithFormat:kCardBackgroundTextureName, [[UserConfig sharedUserConfig] cardBg]];
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:bgfile];
        [self setTextureRect:spriteFrame.rect];
        faceUp_ = !faceUp_;
    }
}

@end
