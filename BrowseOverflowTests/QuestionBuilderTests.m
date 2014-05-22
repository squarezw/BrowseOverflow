//
//  QuestionBuilderTests.m
//  BrowseOverflow
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"

// 在 StackOverflow v2.2 接口中，默认是不返回 body 一项的，所以这里的body 数据只是模拟用

static NSString *questionJSON = @"{"
@"\"items\":["
@"{"
@"\"tags\":["
@"\"ios\","
@"\"iphone\","
@"\"objective-c\","
@"\"xcode\""
@"],"
@"\"owner\":{"
@"\"reputation\":6,"
@"\"user_id\":3655174,"
@"\"user_type\":\"registered\","
@"\"profile_image\":\"https://www.gravatar.com/avatar/1ef9609dcf73580a404c708b6451bbc7?s=128&d=identicon&r=PG&f=1\","
@"\"display_name\":\"user3655174\","
@"\"link\":\"http://stackoverflow.com/users/3655174/user3655174\""
@"},"
@"\"is_answered\":false,"
@"\"view_count\":14,"
@"\"answer_count\":3,"
@"\"score\":0,"
@"\"last_activity_date\":1400739108,"
@"\"creation_date\":1400738137,"
@"\"last_edit_date\":1400738243,"
@"\"question_id\":23798808,"
@"\"link\":\"http://stackoverflow.com/questions/23798808/how-to-display-telugu-font-in-uitextveiw-in-ios\","
@"\"title\":\"How to display Telugu font in UITextveiw in ios?\""
@"}"
@"],"
@"\"has_more\":true,"
@"\"quota_max\":300,"
@"\"quota_remaining\":295"
@"}";

static NSString *stringIsNotJSON = @"Not JSON";
static NSString *noQuestionsJSONString = @"{ \"noquestions\": true }";

@interface QuestionBuilderTests : XCTestCase
{
    QuestionBuilder *_questionBuilder;
    Question *_question;
}
@end

@implementation QuestionBuilderTests

- (void)setUp
{
    [super setUp];
    _questionBuilder = [[QuestionBuilder alloc] init];
    _question = [[_questionBuilder questionsFromJSON:questionJSON error:NULL] objectAtIndex:0];
}

- (void)tearDown
{
    [super tearDown];
    _questionBuilder = nil;
    _question = nil;
}

- (void)testThatNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([_questionBuilder questionsFromJSON:nil error:NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([_questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [_questionBuilder questionsFromJSON:@"Not JSON" error:&error];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([_questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutQuestionsArrayIsError
{
    NSString *jsonString = @"{\"noquestions\":true}";
    XCTAssertNil([_questionBuilder questionsFromJSON:jsonString error:NULL], @"No questions to parse in this JSON");
}

- (void)testJSONWithOneQuestionReturnsOneQuestionObject
{
    NSError *error = nil;
    NSArray *questions = [_questionBuilder questionsFromJSON:questionJSON error:&error];
    XCTAssertEqual([questions count], (NSUInteger)1, @"The builder should have created a question");
}

- (void)testQuestionCreatedFromJSONHasPropertiesPresentedInJSON
{
    XCTAssertEqual(_question.questionID, 23798808, @"The question ID should match the data we sent");
    XCTAssertEqual([_question.date timeIntervalSince1970], (NSTimeInterval)1400738137, @"The date of the question should match the data");
    XCTAssertEqualObjects(_question.title, @"How to display Telugu font in UITextveiw in ios?", @"Title should match the provided data");
    XCTAssertEqual(_question.score, 0, @"Score should match the data");
    Person *asker = _question.asker;
    
    XCTAssertEqualObjects(asker.name, @"user3655174", @"Looks like i should have asked this question");
    XCTAssertEqualObjects([asker.avatarURL absoluteString], @"https://www.gravatar.com/avatar/1ef9609dcf73580a404c708b6451bbc7?s=128&d=identicon&r=PG&f=1", @"The avatar URL should be based on the supplied email hash");
}

- (void)testQuestionCreatedFromEmptyObjectIsStillValidObject
{
    NSString *emptyQuestion = @"{\"items\":[{}]}";
    NSArray *questions = [_questionBuilder questionsFromJSON:emptyQuestion error:NULL];
    XCTAssertEqual([questions count], (NSUInteger)1, @"QuestionBuilder must handle partial input");
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried
{
    XCTAssertThrows([_questionBuilder fillInDetailsForQuestion: _question fromJSON:nil], @"Not receiving data should have been handled earlier");
}

- (void)testBuildingQuestionBodyWithNoQuestionCannotBeTried
{
    XCTAssertThrows([_questionBuilder fillInDetailsForQuestion: nil fromJSON: questionJSON], @"No reason to expect that a nil question is passed");
}

- (void)testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion
{
    [_questionBuilder fillInDetailsForQuestion: _question fromJSON: stringIsNotJSON];
    XCTAssertNil(_question.body, @"Body should not have been added");
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded
{
    [_questionBuilder fillInDetailsForQuestion: _question fromJSON: noQuestionsJSONString];
    XCTAssertNil(_question.body, @"There was no body to add");
}

@end