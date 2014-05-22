//
//  Question.m
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "Question.h"
#import "Answer.h"
#import "Person.h"

@implementation Question

- (id)init{
    if (self = [super init]) {
        answerSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addAnswer:(Answer *)answer
{
    [answerSet addObject:answer];
}

- (NSArray*)answers
{
    return [[answerSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

@end
