//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"

@interface StackOverflowCommunicator : NSObject <NSURLConnectionDataDelegate>
{
@protected
    NSURL *fetchingURL;
    NSURLConnection *fetchingConnection;
    NSMutableData *receivedData;
@private
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSString *);
}

@property (weak) id <StackOverflowCommunicatorDelegate> delegate;

- (void)fetchContentAtURL:(NSURL*)url;

- (void)searchForQuestionsWithTag: (NSString*)tag;

- (void)downloadInformationForQuestionWithID: (NSInteger)identifier;

- (void)downloadAnswersToQuestionWithID: (NSInteger)identifier;

- (void)cancelAndDiscardURLConnection;

@end

extern NSString *StackOverflowCommunicatorErrorDomain;
