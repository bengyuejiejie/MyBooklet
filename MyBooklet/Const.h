//
//  Const.h
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-28.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth

@end
