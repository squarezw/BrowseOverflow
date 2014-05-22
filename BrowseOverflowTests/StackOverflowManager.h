//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"
#import "StackOverflowCommunicator.h"
#import "QuestionBuilder.h"

@class Topic;
@class Question;

@interface StackOverflowManager : NSObject

@property (weak, nonatomic) id<StackOverflowManagerDelegate> delegate;

@property (strong) StackOverflowCommunicator *communicator;
@property (strong) QuestionBuilder *questionBuilder;
@property (strong) Question *questionNeedingBody;

- (void)fetchQuestionsOnTopic:(Topic*)topic;

- (void)fetchBodyForQuestion: (Question *)question;

- (void)searchingForQuestionsFailedWithError:(NSError*)error;

- (void)receivedQuestionsJSON:(NSString*)objectNotation;

- (void)fetchingQuestionBodyFailedWithError: (NSError *)error;

- (void)receivedQuestionBodyJSON: (NSString *)objectNotation;

@end

extern NSString *StackOverflowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode,
    StackOverflowManagerErrorQuestionBodyFetchCode,
};
