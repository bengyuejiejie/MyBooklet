//
//  Note_tag.h
//  MyBooklet
//
//  Created by wangxiaohong on 13-3-28.
//  Copyright (c) 2013年 wangxiaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note_tag : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * fpinyin;
@property (nonatomic, retain) NSDate * lastTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pinyin;
@property (nonatomic, retain) NSString * tagId;
@property (nonatomic, retain) NSNumber * useCount;

@end
