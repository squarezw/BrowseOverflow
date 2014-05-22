//
//  UserBuilder.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface UserBuilder : NSObject

+ (Person *) personFromDictionary: (NSDictionary *) ownerValues;

@end
