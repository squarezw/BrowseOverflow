//
//  FakeURLResponse.h
//  BrowseOverflow
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeURLResponse : NSObject
{
    NSInteger statusCode;
}

- (id)initWithStatusCode: (NSInteger)code;
- (NSInteger)statusCode;


@end
