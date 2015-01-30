//
//  UserConfig.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfig : NSObject
{
    BOOL autoFlipTopCard;
    BOOL startGameAnimation;
    BOOL shakeCard;
    int drawCards;
    int point;
    int scene;
    int cardBg;
}

@property (nonatomic, assign) BOOL autoFlipTopCard;
@property (nonatomic, assign) BOOL startGameAnimation;
@property (nonatomic, assign) BOOL shakeCard;
@property (nonatomic, assign) int drawCards;
@property (nonatomic, assign) int point;
@property (nonatomic, assign) int scene;
@property (nonatomic, assign) int cardBg;

+(UserConfig*) sharedUserConfig;

+(void) load;
+(void) save;

@end

