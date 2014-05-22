//
//  Topic.m
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "Topic.h"

@implementation Topic
{
    NSArray *questions;
}

- (id)initWithName:(NSString *)newName tag:(NSString *)newTag{
    if (self = [super init]) {
        _name = [newName copy];
        _tag = [newTag copy];
        questions = [[NSArray alloc] init];
    }
    return self;
}

- (NSArray*)recentQuestions
{
    return [self sortQuestionsLatestFirst:questions];
}

- (void)addQuestion: (Question *)question
{
    NSArray *newQuestions = [questions arrayByAddingObject:question];
    if ([newQuestions count] > 20) {
        newQuestions = [self sortQuestionsLatestFirst:newQuestions];
        newQuestions = [newQuestions subarrayWithRange:NSMakeRange(0, 20)];
    }
    questions = newQuestions;
}

- (NSArray*)sortQuestionsLatestFirst: (NSArray*)questionList {
    return [questions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Question *q1 = (Question*)obj1;
        Question *q2 = (Question*)obj2;
        return [q2.date compare:q1.date];
    }];
}

@end
