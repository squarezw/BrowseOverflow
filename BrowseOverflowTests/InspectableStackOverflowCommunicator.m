//
//  InspectableStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "InspectableStackOverflowCommunicator.h"

@implementation InspectableStackOverflowCommunicator

- (NSURL*)URLToFetch
{
    return fetchingURL;
}

- (NSURLConnection *)currentURLConnection
{
    return fetchingConnection;
}


@end
