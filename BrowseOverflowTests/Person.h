//
//  Person.h
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (readonly) NSString *name;
@property (readonly) NSURL *avatarURL;

- (id)initWithName:(NSString*)aName avatarLocation:(NSString*)location;

@end
