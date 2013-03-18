//
//  NoteDataModelUtil.h
//  MyBooklet
//
//  Created by wangxiaohong on 3/17/13.
//  Copyright (c) 2013 wangxiaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Note;

@interface NoteDataModelUtil : NSObject
{
    NSMutableArray *noteList;
}

+ (NoteDataModelUtil *) sharedInstance;

- (NSMutableArray *)getNoteListFromDB;
- (NSMutableArray *)getNoteList;
- (void)deleteNote:(Note *)note;
- (void)addNote:(Note *)note;

@end
