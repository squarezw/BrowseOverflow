//
//  Question.h
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class Answer;

@interface Question : NSObject
{
    NSMutableSet *answerSet;
}

@property (strong) NSDate *date;
@property (copy) NSString *title;
@property (copy) NSString *body;
@property NSInteger score;
@property (readonly) NSArray *answers;
@property NSInteger questionID;
@property (strong) Person *asker;

- (void)addAnswer:(Answer*)answer;

@end
