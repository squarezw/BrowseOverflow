//
//  StackOverflowCommunicatorTests.m
//  BrowseOverflow
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StackOverflowCommunicator.h"
#import "InspectableStackOverflowCommunicator.h"
#import "NonNetworkedStackOverflowCommunicator.h"
#import "FakeURLResponse.h"
#import "MockStackOverflowManager.h"

@interface StackOverflowCommunicatorTests : XCTestCase
{
    InspectableStackOverflowCommunicator *communicator;
    NonNetworkedStackOverflowCommunicator *nnCommunicator;
    FakeURLResponse *fourOhFourResponse;
    MockStackOverflowManager *manager;
    NSData *receivedData;
}
@end

@implementation StackOverflowCommunicatorTests

- (void)setUp
{
    [super setUp];

    communicator = [[InspectableStackOverflowCommunicator alloc] init];
    nnCommunicator = [[NonNetworkedStackOverflowCommunicator alloc] init];
    manager = [[MockStackOverflowManager alloc] init];
    nnCommunicator.delegate = manager;
    fourOhFourResponse = [[FakeURLResponse alloc] initWithStatusCode: 404];
    receivedData = [@"Result" dataUsingEncoding: NSUTF8StringEncoding];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    communicator = nil;
    nnCommunicator = nil;
}

- (void)testSearchingForQuestionsOnTopicCallsTopicAPI
{
    [communicator searchForQuestionsWithTag: @"ios"];
    NSURL *url = [communicator URLToFetch];
    XCTAssertEqualObjects([url absoluteString], @"http://api.stackoverflow.com/1.1/search?tagged=ios&pagesize=20", @"Use the search API to find questions with a particular tag");
}

- (void)testFillingInQuestionBodyCallsQuestionAPI
{
    [communicator downloadInformationForQuestionWithID:12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/questions/12345?body=true", @"Use the question API to get the body for a question");
}

- (void)testFetchingAnswersToQuestionCallsQuestionAPI
{
    [communicator downloadAnswersToQuestionWithID:12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/questions/12345/answers?body=true", @"Use the question API to get answers on a given question");
}

- (void)testSearchingForQuestionsCreatesURLConnection
{
    [communicator searchForQuestionsWithTag:@"iOS"];
    XCTAssertNotNil([communicator currentURLConnection], @"There should be a URL connection in-flight now.");
    
    [communicator cancelAndDiscardURLConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection
{
    [communicator searchForQuestionsWithTag:@"iOS"];
    NSURLConnection *firstConnection = [communicator currentURLConnection];
    [communicator searchForQuestionsWithTag:@"cocoa"];
    XCTAssertFalse([[communicator currentURLConnection] isEqual:firstConnection], @"The communicator needs to replace its URL connection to start a new one");
    [communicator cancelAndDiscardURLConnection];
}

- (void)testReceivingResponseDiscardsExistingData
{
    nnCommunicator.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator connection:nil didReceiveResponse:nil];
    XCTAssertEqual([nnCommunicator.receivedData length], (NSUInteger)0, @"Data should have been discarded");
}

- (void)testReceivingResponseWith404StatusPassesErrorToDelegate
{
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)fourOhFourResponse];
    XCTAssertEqual([manager topicFailureErrorCode], 404, @"Fetch failure was passed through to delegate");
}

- (void)testNoErrorReceivedOn200Status
{
    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode:200];
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)twoHundredResponse];
    XCTAssertFalse([manager topicFailureErrorCode] == 200, @"No need for error on 200 response");
}

- (void)testConnectionFailingPassesErrorToDelegate
{
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:12345 userInfo:nil];
    [nnCommunicator connection:nil didFailWithError:error];
    XCTAssertEqual([manager topicFailureErrorCode], 12345, @"Failure to connect should get passed to the delegate");
}

- (void)testSuccessfulQuestionSearchPassesDataToDelegate
{
    [nnCommunicator searchForQuestionsWithTag:@"ios"];
    [nnCommunicator setReceivedData:receivedData];
    [nnCommunicator connectionDidFinishLoading:nil];
    XCTAssertEqualObjects([manager topicSearchString], @"Result", @"The delegate should have received data on success");
}

- (void)testAdditionalDataAppendedToDownload
{
    [nnCommunicator setReceivedData:receivedData];
    NSData *extraData = [@" appended" dataUsingEncoding:NSUTF8StringEncoding];
    [nnCommunicator connection:nil didReceiveData:extraData];
    NSString *combinedString = [[NSString alloc] initWithData:[nnCommunicator receivedData] encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(combinedString, @"Result appended", @"Received data should be appended to the downloaded data");
}

@end
