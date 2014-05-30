//
//  NonNetworkedStackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicator.h"

@interface NonNetworkedStackOverflowCommunicator : StackOverflowCommunicator

@property (copy) NSData *receivedData;

@end
