//
//  StackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface StackOverflowCommunicator ()

- (void)fetchContentAtURL: (NSURL *)url errorHandler: (void(^)(NSError *error))errorBlock successHandler: (void(^)(NSString *objectNotation)) successBlock;

@end

@implementation StackOverflowCommunicator

- (void)dealloc
{
    [fetchingConnection cancel];
}

- (void)launchConnectionForRequest: (NSURLRequest *)request {
    [self cancelAndDiscardURLConnection];
    
    fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)fetchContentAtURL:(NSURL *)url
{
    fetchingURL = url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    
    [fetchingConnection cancel];
    fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)fetchContentAtURL:(NSURL *)url
             errorHandler:(void (^)(NSError *))errorBlock
           successHandler:(void (^)(NSString *))successBlock
{
    fetchingURL = url;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    
    [self launchConnectionForRequest:request];
    
}

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/search?tagged=%@&pagesize=20", tag]]
               errorHandler:^(NSError *error) {
                   [_delegate searchingForQuestionsFailedWithError:error];
               }
             successHandler:^(NSString *objectNotation) {
                 [_delegate receivedQuestionsJSON:objectNotation];
             }
     ];
}

- (void)downloadInformationForQuestionWithID:(NSInteger)identifier
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d?body=true", identifier]]];
}

- (void)downloadAnswersToQuestionWithID:(NSInteger)identifier
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackoverflow.com/1.1/questions/%d/answers?body=true", identifier]]];
}

- (void)cancelAndDiscardURLConnection
{
    [fetchingConnection cancel];
    fetchingConnection = nil;
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    receivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain: StackOverflowCommunicatorErrorDomain code: [httpResponse statusCode] userInfo: nil];
        errorHandler(error);
        [self cancelAndDiscardURLConnection];
    }
    else {
        receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    receivedData = nil;
    fetchingConnection = nil;
    fetchingURL = nil;
    errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    fetchingConnection = nil;
    fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData: receivedData
                                                   encoding: NSUTF8StringEncoding];
    receivedData = nil;
    successHandler(receivedText);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

@end

NSString *StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";
