//
//  StackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@protocol StackOverflowManagerDelegate <NSObject>

- (void)fetchingQuestionsFailedWithError: (NSError*)error;

- (void)didReceiveQuestions: (NSArray*)questions;

- (void)fetchingQuestionBodyFailedWithError: (NSError *)error;

- (void)bodyReceivedForQuestion: (Question *)question;

@end
