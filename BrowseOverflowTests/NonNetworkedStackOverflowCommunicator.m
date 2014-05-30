//
//  NonNetworkedStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "NonNetworkedStackOverflowCommunicator.h"

@implementation NonNetworkedStackOverflowCommunicator

- (void)setReceivedData:(NSData *)data {
    receivedData = [data mutableCopy];
}

- (NSData *)receivedData {
    return [receivedData copy];
}

@end
