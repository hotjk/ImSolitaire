//
//  DeviceConfig.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceConfig.h"
#import "cocos2d.h"

@implementation DeviceConfig
@synthesize isIPad;
@synthesize isRetina;
@synthesize isChinese;

#define kIPadLargeThanIPhoneX ((1024-960)*0.5)
#define kIPadLargeThanIPhoneY ((768-640)*0.5)
#define kStockOriginX 45
#define kStockOriginY 270
#define kWasteOriginX 140
#define kWasteOriginY 270
#define kWasteOffsetX 16
#define kFoundationOriginX 237
#define kFoundationOriginY 270
#define kFoundationInterval 64
#define kTableauOriginX 45
#define kTableauOriginY 190
#define kTableauInterval 64
#define kTableauOffsetY (-20)
#define kTableauMoreThan8OffsetY (-15)
#define kTableauMoreThan10OffsetY (-12)
#define kTableauSquaredOffsetY (-6)
#define kCardSourceOffset (-100)


static DeviceConfig* deviceConfigInstance;

+(DeviceConfig*) sharedDeviceConfig
{
    if (!deviceConfigInstance) {
        deviceConfigInstance = [[self alloc] init];
    }
    return deviceConfigInstance;
}

-(id)init{
    if (self = [super init]) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        isIPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(@"%@", language);
        isChinese = ([language compare:@"zh-Hans"] == 0);
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] 
            && [[UIScreen mainScreen] scale] == 2.0 ) {
            isRetina = YES;
        }
        else {
            isRetina = NO;
        }
    }
    return self;
}



-(NSString*)homeBgImageFileName
{
    return isIPad?@"home_bg-hd.png":@"home_bg.png";
}

-(NSString*)homePanelImageFileName
{
    return isIPad?@"home_panel-hd.png":@"home_panel.png";
}

-(NSString*)cardsBatchNodeFileName
{
    return isIPad?@"card-hd.png":@"card.png";
}

-(NSString*)cardsSpriteFrameFileName
{
    return isIPad?@"card-hd.plist":@"card.plist";
}

-(NSString*)homeBatchNodeFileName
{
    if (isChinese) {
        return isIPad?@"home-hd.png":@"home.png";
    }
    else
    {
        return isIPad?@"home_eng-hd.png":@"home_eng.png";
    }
}

-(NSString*)homeSpriteFrameFileName
{
    if (isChinese) {
        return isIPad?@"home-hd.plist":@"home.plist";
    }
    else
    {
        return isIPad?@"home_eng-hd.plist":@"home_eng.plist";
    }
}

-(NSString*)bonusBatchNodeFileName
{
    return isIPad?@"bonus-hd.png":@"bonus.png";
}

-(NSString*)bonusSpriteFrameFileName
{
    return isIPad?@"bonus-hd.plist":@"bonus.plist";
}

-(NSString*)sceneBatchNodeFileName
{
    return isIPad?@"scene-hd.png":@"scene.png";
}

-(NSString*)sceneSpriteFrameFileName
{
    return isIPad?@"scene-hd.plist":@"scene.plist";
}


-(NSString*)bgFileName:(int)index
{
    if (isIPad) {
        return [NSString stringWithFormat:@"b%d-hd.png", index];
    }
    return [NSString stringWithFormat:@"b%d.png", index];
}
-(CGPoint)cardSourcePoint
{
    return isIPad?ccp(kStockOriginX*2+kCardSourceOffset*2+kIPadLargeThanIPhoneX, kStockOriginY*2+kIPadLargeThanIPhoneY):ccp(kStockOriginX + kCardSourceOffset, kStockOriginY);
}

-(CGPoint)stockOrigin
{
    return isIPad?ccp(kStockOriginX*2+kIPadLargeThanIPhoneX, kStockOriginY*2+kIPadLargeThanIPhoneY):ccp(kStockOriginX,kStockOriginY);
}

-(CGPoint)wasteOrigin
{
    return isIPad?ccp(kWasteOriginX*2+kIPadLargeThanIPhoneX, kWasteOriginY*2+kIPadLargeThanIPhoneY):ccp(kWasteOriginX,kWasteOriginY);
}

-(CGSize)wasteOffset
{
    return isIPad?CGSizeMake(kWasteOffsetX*2, 0):CGSizeMake(kWasteOffsetX, 0);
}

-(CGPoint)foundationOrigin:(int)index
{
    if (isIPad) {
        return ccp(kFoundationInterval*index*2+kFoundationOriginX*2+kIPadLargeThanIPhoneX,
                   kFoundationOriginY*2+kIPadLargeThanIPhoneY);
    } else {
        return ccp(kFoundationInterval * index + kFoundationOriginX, kFoundationOriginY);
    }
}
-(CGPoint)tableauOrigin:(int)index
{
    if (isIPad) {
        return ccp(kTableauInterval*index*2+kTableauOriginX*2+kIPadLargeThanIPhoneX,
                   kTableauOriginY*2+kIPadLargeThanIPhoneY);
    } else {
        return ccp(kTableauInterval * index + kTableauOriginX, kTableauOriginY);
    }
}
-(CGSize)tableauOffset
{
    return isIPad?CGSizeMake(0, kTableauOffsetY*2):CGSizeMake(0, kTableauOffsetY);
}
-(CGSize)tableauMoreThan8Offset
{
    return isIPad?CGSizeMake(0, kTableauMoreThan8OffsetY*2):CGSizeMake(0, kTableauMoreThan8OffsetY);
}
-(CGSize)tableauMoreThan10Offset
{
    return isIPad?CGSizeMake(0, kTableauMoreThan10OffsetY*2):CGSizeMake(0, kTableauMoreThan10OffsetY);
}
-(CGSize)tableauSquaredOffset
{
    return isIPad?CGSizeMake(0, kTableauSquaredOffsetY*2):CGSizeMake(0, kTableauSquaredOffsetY);
}

-(CGPoint)homeStartPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5, winSize.height * 0.5 - 20);
    }
    return ccp(winSize.width * 0.5, winSize.height * 0.5 - 10);
}
-(CGPoint)homeLogoPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5, winSize.height * 0.5 + 100);
    }
    return ccp(winSize.width * 0.5, winSize.height * 0.5 + 50);
}
-(CGPoint)homeSettingsPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5, winSize.height * 0.5 - 120);
    }
    return ccp(winSize.width * 0.5, winSize.height * 0.5 - 60);
}
-(CGPoint)homeAboutPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5, winSize.height * 0.5 - 220);
    }
    return ccp(winSize.width * 0.5, winSize.height * 0.5 - 110);
}

-(CGPoint)aboutStaffPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5-20, winSize.height * 0.5-80);
    }
    return ccp(winSize.width * 0.5-10, winSize.height * 0.5-40);
}
-(CGPoint)aboutMenuPosition
{
    if (isIPad) {
        return ccp(60, 60);
    }
    return ccp(30, 30);
}

-(CGPoint)settingsFlipPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 - 100, winSize.height * 0.5 + 100);
    }
    return ccp(winSize.width * 0.5 - 50, winSize.height * 0.5 + 50);
}
-(CGPoint)settingsAnimationPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 - 100, winSize.height * 0.5);
    }
    return ccp(winSize.width * 0.5 - 50, winSize.height * 0.5);
}
-(CGPoint)settingsAutoFlipPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 - 100, winSize.height * 0.5 - 100);
    }
    return ccp(winSize.width * 0.5 - 50, winSize.height * 0.5 - 50);
}
-(CGPoint)settingsShakeCardPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 - 100, winSize.height * 0.5 - 200);
    }
    return ccp(winSize.width * 0.5 - 50, winSize.height * 0.5 - 100);
}
-(CGPoint)settingsMenuPosition
{
    if (isIPad) {
        return ccp(60, 60);
    }
    return ccp(30, 30);
}

-(CGPoint)settingsFlipValuePosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 + 140, winSize.height * 0.5 + 100);
    }
    return ccp(winSize.width * 0.5 + 70, winSize.height * 0.5 + 50);
}
-(CGPoint)settingsAnimationValuePosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 + 140, winSize.height * 0.5);
    }
    return ccp(winSize.width * 0.5 + 70, winSize.height * 0.5);
}
-(CGPoint)settingsAutoFlipValuePosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 + 140, winSize.height * 0.5 - 100);
    }
    return ccp(winSize.width * 0.5 + 70, winSize.height * 0.5 - 50);
}
-(CGPoint)settingsShakeCardValuePosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 + 140, winSize.height * 0.5 - 200);
    }
    return ccp(winSize.width * 0.5 + 70, winSize.height * 0.5 - 100);
}

-(CGPoint)pausePanelPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5, 0 - 100);
    }
    return ccp(winSize.width * 0.5, 0 - 50);
}
-(CGPoint)pauseResumePosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 - 240, 0 - 110);
    }
    return ccp(winSize.width * 0.5 - 120, 0 - 55);
}
-(CGPoint)pauseRestartPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5, 0 - 110);
    }
    return ccp(winSize.width * 0.5, 0 - 55);
}
-(CGPoint)pauseReturnPosition
{
    if (isIPad) {
        return ccp(winSize.width * 0.5 + 240, 0 - 110);
    }
    return ccp(winSize.width * 0.5 + 120, 0 - 55);
}
-(CGPoint)pauseMovePosition
{
    if (isIPad) {
        return ccp(0, 160);
    }
    return ccp(0, 80);
}
-(CGPoint)pauseMoveOutPosition
{
    if (isIPad) {
        return ccp(0, -160);
    }
    return ccp(0, -80);
}

-(CGPoint)menuButtonPosition
{
    if (isIPad) {
        return ccp(45,41);
    }
    return ccp(12, 12);
}

-(CGPoint)myScorePosition
{
    if (isIPad) {
        return ccp(140,768-216);
    }
    return ccp(58, 320-100);
}

-(CGPoint)scenePosition:(int)index
{
    if (isIPad) {
        switch (index) {
            case 0:
                return ccp(400,768-344);
            case 1:
                return ccp(650,768-344);
            case 2:
                return ccp(390,768-568);
            case 3:
                return ccp(650,768-568);
        }
    }
    switch (index) {
        case 0:
            return ccp(180,320-140);
        case 1:
            return ccp(310,320-140);
        case 2:
            return ccp(175,320-250);
        case 3:
            return ccp(310,320-250);
    }
    return ccp(0,0);
}
-(CGPoint)sceneScorePosition:(int)index
{
    if (isIPad) {
        switch (index) {
            case 0:
                return ccp(400,768-464+34);
            case 1:
                return ccp(650,768-464+34);
            case 2:
                return ccp(390,768-688+34);
            case 3:
                return ccp(650,768-688+34);
        }
    }
    switch (index) {
        case 0:
            return ccp(180,320-140-42);
        case 1:
            return ccp(310,320-140-42);
        case 2:
            return ccp(175,320-250-42);
        case 3:
            return ccp(310,320-250-42);
    }
    return ccp(0,0);
}

-(CGPoint)sceneMenuPosition
{
    if (isIPad) {
        return ccp(60, 60);
    }
    return ccp(30, 30);
}


@end
