//
//  Topic.h
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface Topic : NSObject
@property (readonly) NSString *name;
@property (readonly) NSString *tag;

- (id)initWithName:(NSString*)newName tag:(NSString*)newTag;

- (NSArray*)recentQuestions;

- (void)addQuestion: (Question *)question;

@end
