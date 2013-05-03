//
//  GeneralUtil.h
//  ExpressIphone
//
//  Created by wangxiaohong on 1/22/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface GeneralUtil : NSObject

// 字符串用Base64编码
+ (NSString*)encodeBase64String:(NSString * )input;

// Base64编码字符串解码
+ (NSString*)decodeBase64String:(NSString * )input;

// 界面下方显示通用提示信息
+ (void)showToast:(NSString *)infoStr;

// 生成缩略图 自动缩放到指定大小
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

// 保持原来的长宽比，生成一个缩略图显示缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;


// 获取document目录
+ (NSString *)getDocumentDirectory;

@end
