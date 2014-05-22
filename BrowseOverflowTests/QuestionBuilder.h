//
//  QuestionBuilder.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

enum {
    QuestionBuilderInvalidJSONError,
    QuestionBuilderMissingDataError,
};

@interface QuestionBuilder : NSObject

- (NSArray*)questionsFromJSON: (NSString*)objectNotation
                        error: (NSError **)error;

- (void)fillInDetailsForQuestion: (Question *)question fromJSON: (NSString *)objectNotation;

@end

extern NSString *QuestionBuilderErrorDomain;