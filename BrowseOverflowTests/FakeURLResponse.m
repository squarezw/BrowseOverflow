//
//  FakeURLResponse.m
//  BrowseOverflow
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "FakeURLResponse.h"

@implementation FakeURLResponse

- (id)initWithStatusCode:(NSInteger)code {
    if ((self = [super init])) {
        statusCode = code;
    }
    return self;
}

- (NSInteger)statusCode {
    return statusCode;
}

@end
