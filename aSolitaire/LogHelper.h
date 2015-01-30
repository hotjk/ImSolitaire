//
//  LogHelper.h
//  aSolitaire
//
//  Created by Weixiao Zhong on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "cocos2d.h"

@interface LogHelper : NSObject
    
+(void)printCards:(CCArray *)cards withTitle:(NSString *)title;

@end
