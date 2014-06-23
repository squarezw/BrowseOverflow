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
/**
 *  An ordered collection of answers
 */
@property (readonly) NSArray *answers;
/**
 *  A numberic identifier, relating this question object to its source on the website.
 */
@property NSInteger questionID;
/*
 * The person who asked this question on the website.
 */
@property (strong) Person *asker;
/**
 *  Add another answer to this question's collection of answers.
 */
- (void)addAnswer:(Answer*)answer;

@end
