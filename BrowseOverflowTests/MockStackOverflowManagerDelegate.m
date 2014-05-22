//
//  MockStackOverflowManagerDelegate.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"
#import "Question.h"

@implementation MockStackOverflowManagerDelegate

- (void)fetchingQuestionsFailedWithError:(NSError *)error
{
    self.fetchError = error;
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)didReceiveQuestions:(NSArray *)questions
{
    _receivedQuestions = questions;
}

- (void)bodyReceivedForQuestion:(Question *)question {
    self.bodyQuestion = question;
}

@end
