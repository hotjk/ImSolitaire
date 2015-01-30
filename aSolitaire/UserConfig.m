//
//  UserConfig.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserConfig.h"

#define kUserConfigStartAnim  @"drawAnim"
#define kUserConfigAutoFlip  @"autoFlip"
#define kUserConfigShakeCard  @"shakeCard"
#define kUserConfigDrawCards @"drawCards"
#define kUserConfigPoint  @"point"

@implementation UserConfig
@synthesize startGameAnimation;
@synthesize autoFlipTopCard;
@synthesize shakeCard;
@synthesize drawCards;
@synthesize point;
@synthesize scene;
@synthesize cardBg;

static UserConfig* userConfigInstance;

+(UserConfig*) sharedUserConfig
{
    if (!userConfigInstance) {
        userConfigInstance = [[self alloc] init];
    }
    return userConfigInstance;
}

-(id) init
{
    if (self = [super init]) {
        autoFlipTopCard = YES;
        startGameAnimation = NO;
        shakeCard = YES;
        drawCards = 3;
        point = 0;
        scene = 0;
        cardBg = 0;
    }
    return self;
}

-(void)dealloc
{
    userConfigInstance = nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder { 
    [encoder encodeBool: autoFlipTopCard forKey:kUserConfigAutoFlip]; 
    [encoder encodeBool:startGameAnimation forKey:kUserConfigStartAnim]; 
    [encoder encodeBool:shakeCard forKey:kUserConfigShakeCard];
    [encoder encodeInt:drawCards forKey:kUserConfigDrawCards];
    [encoder encodeInt:point forKey:kUserConfigPoint]; 
}

- (id)initWithCoder:(NSCoder *)decoder { 
    self = [super init];
    if (self != nil) {
        autoFlipTopCard = [decoder decodeBoolForKey:kUserConfigAutoFlip];
        startGameAnimation = [decoder decodeBoolForKey:kUserConfigStartAnim];
        shakeCard = [decoder decodeBoolForKey:kUserConfigShakeCard];
        drawCards = [decoder decodeIntForKey:kUserConfigDrawCards];
        point = [decoder decodeIntForKey:kUserConfigPoint];
    } 
    return self;
}

+(void) load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imSolitaire.plist"];
    
    NSData *readData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
    userConfigInstance = [[unarchiver decodeObjectForKey:@"userConfig"] retain];
    if (userConfigInstance == nil) {
        userConfigInstance = [[self alloc] init];
    }   
    
    [readData release];
    [unarchiver release];
}

+(void) save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imSolitaire.plist"];

    NSMutableData *saveddata = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveddata];
    [archiver encodeObject:userConfigInstance forKey:@"userConfig"];
    [archiver finishEncoding];
    [saveddata writeToFile:filePath atomically:YES];
    
    [saveddata release];
    [archiver release];
}

@end
