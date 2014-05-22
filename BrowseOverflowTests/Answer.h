//
//  Answer.h
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Answer : NSObject

@property (strong) NSString *text;
@property (strong) Person *person;
@property (assign) NSInteger score;
@property (getter = isAccepted) BOOL accepted;

- (NSComparisonResult)compare:(Answer*)otherAnswer;

@end
