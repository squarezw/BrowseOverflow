//
//  Person.m
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)initWithName:(NSString *)aName avatarLocation:(NSString *)location
{
    if (self = [super init]) {
        _name = [aName copy];
        _avatarURL = [[NSURL alloc] initWithString:location];
    }
    return self;
}

@end
