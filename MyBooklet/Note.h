//
//  Note.h
//  MyBooklet
//
//  Created by wangxiaohong on 1/14/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note_attach;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSDate * modifyTime;
@property (nonatomic, retain) NSString * noteId;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *attachList;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addAttachListObject:(Note_attach *)value;
- (void)removeAttachListObject:(Note_attach *)value;
- (void)addAttachList:(NSSet *)values;
- (void)removeAttachList:(NSSet *)values;

@end
