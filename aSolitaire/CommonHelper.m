//
//  CommonHelper.m
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonHelper.h"
#import "Constants.h"

@implementation CommonHelper

+(CGPoint) locationFromTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

+(CGPoint) locationFromTouchs:(NSSet *)touchs
{
    return [self locationFromTouch:[touchs anyObject]];
}

+(BOOL) rect:(CGRect)rect MostContainRect:(CGRect) testRect
{
    CGRect intersection = CGRectIntersection(rect, testRect);
    if ((intersection.size.width * intersection.size.height) / (rect.size.width * rect.size.height) > kIntersectionRatio) {
        return YES;
    }
    return NO;
}

+(NSArray*)shuffle:(NSInteger) n
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:n];
    for (int i=0; i<n; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    NSNumber *temp;
    for (int i=n-1; i>0; i--) {
        int r = arc4random() % i;
        temp = [array objectAtIndex:r];
        [array replaceObjectAtIndex:r withObject:[array objectAtIndex:i]];
        [array replaceObjectAtIndex:i withObject:temp];
    }
    return array;
}

+(void) shakeCard:(CCSprite *)card
{
    int angle = (arc4random() % (2 * kCardRotationAngleMax)) - kCardRotationAngleMax;
    [card setRotation:angle];
}

@end
