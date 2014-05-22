//
//  UserBuilder.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "UserBuilder.h"
#import "Person.h"

@implementation UserBuilder

+ (Person *) personFromDictionary: (NSDictionary *) ownerValues  {
    NSString *name = [ownerValues objectForKey: @"display_name"];
    NSString *avatarURL = [NSString stringWithFormat:@"%@",[ownerValues objectForKey: @"profile_image"]];
    Person *owner = [[Person alloc] initWithName: name avatarLocation: avatarURL];
    return owner;
}

@end
