//
//  DeviceConfig.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceConfig : NSObject
{
    BOOL isIPad;
    BOOL isRetina;
    BOOL isChinese;
    
    CGSize winSize;
}

+(DeviceConfig*) sharedDeviceConfig;
@property (nonatomic, readonly) BOOL isIPad;
@property (nonatomic, readonly) BOOL isRetina;
@property (nonatomic, readonly) BOOL isChinese;

-(NSString*)homeBgImageFileName;
-(NSString*)homePanelImageFileName;
-(NSString*)cardsBatchNodeFileName;
-(NSString*)cardsSpriteFrameFileName;
-(NSString*)homeBatchNodeFileName;
-(NSString*)homeSpriteFrameFileName;
-(NSString*)bonusBatchNodeFileName;
-(NSString*)bonusSpriteFrameFileName;
-(NSString*)sceneBatchNodeFileName;
-(NSString*)sceneSpriteFrameFileName;
-(NSString*)bgFileName:(int)index;

-(CGPoint)cardSourcePoint;
-(CGPoint)stockOrigin;
-(CGPoint)wasteOrigin;
-(CGSize)wasteOffset;
-(CGPoint)foundationOrigin:(int)index;
-(CGPoint)tableauOrigin:(int)index;
-(CGSize)tableauOffset;
-(CGSize)tableauMoreThan8Offset;
-(CGSize)tableauMoreThan10Offset;
-(CGSize)tableauSquaredOffset;

-(CGPoint)homeStartPosition;
-(CGPoint)homeLogoPosition;
-(CGPoint)homeSettingsPosition;
-(CGPoint)homeAboutPosition;

-(CGPoint)aboutStaffPosition;
-(CGPoint)aboutMenuPosition;

-(CGPoint)settingsFlipPosition;
-(CGPoint)settingsAnimationPosition;
-(CGPoint)settingsAutoFlipPosition;
-(CGPoint)settingsShakeCardPosition;
-(CGPoint)settingsMenuPosition;

-(CGPoint)settingsFlipValuePosition;
-(CGPoint)settingsAnimationValuePosition;
-(CGPoint)settingsAutoFlipValuePosition;
-(CGPoint)settingsShakeCardValuePosition;

-(CGPoint)pausePanelPosition;
-(CGPoint)pauseResumePosition;
-(CGPoint)pauseRestartPosition;
-(CGPoint)pauseReturnPosition;
-(CGPoint)pauseMovePosition;
-(CGPoint)pauseMoveOutPosition;

-(CGPoint)menuButtonPosition;

-(CGPoint)myScorePosition;
-(CGPoint)scenePosition:(int)index;
-(CGPoint)sceneScorePosition:(int)index;
-(CGPoint)sceneMenuPosition;

@end
