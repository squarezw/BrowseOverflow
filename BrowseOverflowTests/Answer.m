//
//  Answer.m
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (NSComparisonResult)compare:(Answer*)otherAnswer{
    if (_accepted && !(otherAnswer.accepted)) {
        return NSOrderedAscending;
    } else if (!_accepted && otherAnswer.accepted){
        return NSOrderedDescending;
    }
    
    if (_score > otherAnswer.score) {
        return NSOrderedAscending;
    } else if (_score < otherAnswer.score){
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end
