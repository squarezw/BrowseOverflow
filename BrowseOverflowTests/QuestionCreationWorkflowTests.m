//
//  QuestionCreationTests.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StackOverflowManager.h"
#import "MockStackOverflowManagerDelegate.h"
#import "MockStackOverflowCommunicator.h"
#import "Topic.h"
#import "FakeQuestionBuilder.h"

@interface QuestionCreationWorkflowTests : XCTestCase

@end

@implementation QuestionCreationWorkflowTests
{
@private
    StackOverflowManager *mgr;
    MockStackOverflowManagerDelegate *_delegate;
    NSError *_underlyingError;
    NSArray *_questionArray;
    FakeQuestionBuilder *_questionBuilder;
    Question *_questionToFetch;
    MockStackOverflowCommunicator *_communicator;
}

- (void)setUp
{
    [super setUp];
    mgr = [[StackOverflowManager alloc] init];
    _delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = _delegate;
    _underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    // ...
    Question *question = [[Question alloc] init];
    _questionArray = [NSArray arrayWithObject:question];
    
    _questionBuilder = [[FakeQuestionBuilder alloc] init];
    mgr.questionBuilder = _questionBuilder;
    
    // ...
    _questionToFetch = [[Question alloc] init];
    _questionToFetch.questionID = 1234;
    _questionArray = [NSArray arrayWithObject:_questionToFetch];
    _communicator = [[MockStackOverflowCommunicator alloc] init];
    mgr.communicator = _communicator;
    
}

- (void)tearDown
{
    [super tearDown];
    mgr = nil;
    _delegate = nil;
    _underlyingError = nil;
    _questionArray = nil;
    _questionToFetch = nil;
    _communicator = nil;
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails{
    FakeQuestionBuilder *builder = [[FakeQuestionBuilder alloc] init];
    builder.arrayToReturn = nil;
    builder.errorToSet = _underlyingError;
    mgr.questionBuilder = builder;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertNotNil([[[_delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey], @"The delegate should have found out about the error");
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(mgr.delegate = (id <StackOverflowManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't conform to the delegate protocol");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(mgr.delegate = nil, @"It should be acceptable to use nil as an object's delegate");
}

- (void)testConformingObjectCanBeDelegate
{
    id <StackOverflowManagerDelegate> delegate = [[MockStackOverflowManagerDelegate alloc] init];
    XCTAssertNoThrow(mgr.delegate = delegate, @"Object conforming to the delegate protocol should be used as the delegate");
}

- (void)testAskingForQuestionsMeansRequestingData
{
    MockStackOverflowCommunicator *communicator = [[MockStackOverflowCommunicator alloc] init];
    mgr.communicator = communicator;
    Topic *topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iPhone"];
    [mgr fetchQuestionsOnTopic:topic];
    XCTAssertTrue([communicator wasAskedToFetchQuestions], @"The communicator should need to fetch data.");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    MockStackOverflowManagerDelegate *delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    NSError *underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    
    XCTAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    MockStackOverflowManagerDelegate *delegate = [[MockStackOverflowManagerDelegate alloc] init];
    mgr.delegate = delegate;
    NSError *underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    [mgr searchingForQuestionsFailedWithError: underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

- (void)testQuestionJSONIsPassedToQuestionBuilder
{
    FakeQuestionBuilder *builder = [[FakeQuestionBuilder alloc] init];
    mgr.questionBuilder = builder;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects(builder.JSON, @"Fake JSON", @"Downloaded JSON is sent to the builder");
    mgr.questionBuilder = nil;
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived
{
    _questionBuilder.arrayToReturn = _questionArray;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertNil([_delegate fetchError], @"No error should be received on success");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager
{
    _questionBuilder.arrayToReturn = _questionArray;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects([_delegate receivedQuestions], _questionArray, @"The manager should have sent its questions to the delegate");
}

- (void)testEmptyArrayIsPassedToDelegate
{
    _questionBuilder.arrayToReturn = [NSArray array];
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects([_delegate receivedQuestions], [NSArray array], @"Returning an empty array is not an error");
}

- (void)testAskingForQuestionBodyMeansRequestingData
{
    [mgr fetchBodyForQuestion: _questionToFetch];
    XCTAssertTrue([_communicator wasAskedToFetchBody], @"The communicator should need to retrieve data for the question body");
}

- (void)testDelegateNotfiedOfFailureToFetchQuestion
{
    [mgr fetchingQuestionBodyFailedWithError: _underlyingError];
    XCTAssertNotNil([[[_delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey], @"Delegate should have found out about this error");
}

- (void)testManagerPassesRetrievedQuestionBodyToQuestionBuilder
{
    [mgr receivedQuestionBodyJSON: @"Fake JSON"];
    XCTAssertEqualObjects(_questionBuilder.JSON, @"Fake JSON", @"Successfully-retrieved data should be passed to the builder");
}

- (void)testManagerPassesQuestionItWasSentToQuestionBuilderForFillingIn
{
    [mgr fetchBodyForQuestion: _questionToFetch];
    [mgr receivedQuestionBodyJSON: @"Fake JSON"];
    XCTAssertEqualObjects(_questionBuilder.questionToFill, _questionToFetch, @"The question should have been passed to the builder");
}

@end
