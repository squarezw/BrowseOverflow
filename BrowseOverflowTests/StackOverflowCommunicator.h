//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowCommunicator : NSObject

- (void)searchForQuestionsWithTag: (NSString*)tag;

- (void)downloadInformationForQuestionWithID: (NSInteger)identifier;

@end
