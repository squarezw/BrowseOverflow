//
//  MockStackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"

@class Question;

@interface MockStackOverflowManagerDelegate : NSObject <StackOverflowManagerDelegate>

@property (strong) NSError *fetchError;

@property (strong) NSArray *receivedQuestions;

@property (strong) Question *bodyQuestion;

@end
