//
//  MockStackOverflowManager.m
//  BrowseOverflow
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "MockStackOverflowManager.h"

@implementation MockStackOverflowManager

- (NSInteger)topicFailureErrorCode {
    return topicFailureErrorCode;
}

- (NSString *)topicSearchString {
    return topicSearchString;
}

- (void)searchingForQuestionsFailedWithError: (NSError *)error {
    topicFailureErrorCode = [error code];
}

- (void)receivedQuestionsJSON:(NSString *)objectNotation {
    topicSearchString = objectNotation;
}

@end
