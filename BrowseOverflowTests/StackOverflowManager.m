//
//  StackOverflowManager.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "StackOverflowManager.h"
#import "Topic.h"

@implementation StackOverflowManager

- (void)setDelegate:(id<StackOverflowManagerDelegate>)newDelegate
{
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil] raise];
    }
    _delegate = newDelegate;
}

- (void)fetchQuestionsOnTopic:(Topic *)topic
{
    [_communicator searchForQuestionsWithTag:[topic tag]];
}

- (void)fetchBodyForQuestion: (Question *)question {
    self.questionNeedingBody = question;
    [_communicator downloadInformationForQuestionWithID: question.questionID];
}

- (void)searchingForQuestionsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    NSDictionary *errorInfo = nil;
    if (error) {
        errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: StackOverflowManagerError code: StackOverflowManagerErrorQuestionBodyFetchCode userInfo:errorInfo];
    [_delegate fetchingQuestionBodyFailedWithError: reportableError];
    self.questionNeedingBody = nil;
}

- (void)receivedQuestionsJSON:(NSString *)objectNotation
{
    NSError *error = nil;
    NSArray *questions = [_questionBuilder questionsFromJSON:objectNotation error:&error];
    if (!questions) {
        [self tellDelegateAboutQuestionSearchError:error];
    } else {
        [_delegate didReceiveQuestions:questions];
    }
}

- (void)tellDelegateAboutQuestionSearchError:(NSError*)error
{
    NSDictionary *errorInfo = nil;
    if (error) {
        errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError
                                errorWithDomain:StackOverflowManagerError
                                code:StackOverflowManagerErrorQuestionSearchCode
                                userInfo:errorInfo];
    [_delegate fetchingQuestionsFailedWithError:reportableError];
}

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation {
    [_questionBuilder fillInDetailsForQuestion: self.questionNeedingBody fromJSON: objectNotation];
    [_delegate bodyReceivedForQuestion: self.questionNeedingBody];
    self.questionNeedingBody = nil;
}

@end

NSString *StackOverflowManagerError = @"StackOverflowManagerError";
