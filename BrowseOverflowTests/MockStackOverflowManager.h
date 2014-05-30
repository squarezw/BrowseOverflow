//
//  MockStackOverflowManager.h
//  BrowseOverflow
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"

@interface MockStackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>
{
    NSInteger topicFailureErrorCode;
    NSString *topicSearchString;
}

- (NSInteger)topicFailureErrorCode;

- (NSString *)topicSearchString;

@end
