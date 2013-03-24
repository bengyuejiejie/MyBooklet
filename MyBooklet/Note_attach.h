//
//  Note_attach.h
//  MyBooklet
//
//  Created by wangxiaohong on 3/24/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Note_attach : NSManagedObject

@property (nonatomic, retain) NSString * attachId;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * noteId;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Note *inNote;

@end
