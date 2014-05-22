//
//  FakeQuestionBuilder.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "FakeQuestionBuilder.h"

@implementation FakeQuestionBuilder

- (NSArray*)questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error
{
    self.JSON = objectNotation;
    *error = _errorToSet;
    return _arrayToReturn;
}

- (void)fillInDetailsForQuestion:(Question *)question fromJSON:(NSString *)objectNotation {
    self.JSON = objectNotation;
    self.questionToFill = question;
}

@end
