//
//  GeneralUtil.m
//  ExpressIphone
//
//  Created by wangxiaohong on 1/22/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import "GeneralUtil.h"
#import "GTMBase64.h"
#import "MBProgressHUD.h"

@implementation GeneralUtil

+ (NSString *)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString *)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
}

+ (void)showToast:(NSString *)infoStr 
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;   // 获得根窗口的UIWindow对象实例
    [window addSubview:HUD];
    
    HUD.labelText = infoStr;
    HUD.mode = MBProgressHUDModeText;
    HUD.yOffset = -50.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
}

+ (void)showToast:(NSString *)infoStr delegate:(id)sender completionSel:(SEL)completion
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;   // 获得根窗口的UIWindow对象实例
    [window addSubview:HUD];
    
    HUD.labelText = infoStr;
    HUD.mode = MBProgressHUDModeText;
    HUD.yOffset = -50.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [sender performSelector:completion];
        [HUD removeFromSuperview];
    }];
}

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (NSString *)getDocumentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

@end
