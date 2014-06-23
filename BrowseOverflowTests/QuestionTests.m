//
//  QuestionTests.m
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Question.h"
#import "Answer.h"

@interface QuestionTests : XCTestCase
{
    Question *question;
    Answer *lowScore;
    Answer *highScore;
    Person *asker;
}
@end

@implementation QuestionTests

- (void)setUp
{
    [super setUp];
    question = [[Question alloc] init];
    question.date = [NSDate distantFuture];
    question.title = @"Do iPhone also dream of electric sheep?";
    question.score = 42;
    
    Answer *accepted = [[Answer alloc] init];
    accepted.score = 1;
    accepted.accepted = YES;
    [question addAnswer: accepted];
    
    lowScore = [[Answer alloc] init];
    lowScore.score = -4;
    [question addAnswer:lowScore];
    
    highScore = [[Answer alloc] init];
    highScore.score = 4;
    [question addAnswer:highScore];
    
    asker = [[Person alloc] initWithName:@"Square" avatarLocation:@"http://example.com/avatar.png"];
    question.asker = asker;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    question = nil;
    lowScore = nil;
    highScore = nil;
}

- (void)testQuestionHasADate{
    NSDate *testDate = [NSDate distantFuture];
    question.date = testDate;
    XCTAssertEqualObjects(question.date, testDate, @"Question needs to provide its date");
}

- (void)testQuestionsKeepScore{
    XCTAssertEqual(question.score, 42, @"Questions need a numeric score");
}

- (void)testQuestionHasATitle{
    XCTAssertEqualObjects(question.title, @"Do iPhone also dream of electric sheep?", @"Question should know its title");
}

- (void)testQuestionCanHaveAnswersAdded {
    Answer *myAnswer = [[Answer alloc] init];
    XCTAssertNoThrow([question addAnswer:myAnswer], @"Must be able to add answers");
}

- (void)testAcceptedAnswerIsFirst {
    XCTAssertTrue([[question.answers objectAtIndex:0] isAccepted], @"Accepted answer comes first");
}

- (void)testHighScoreAnswerBeforeLow {
    NSArray *answers = question.answers;
    NSInteger highIndex = [answers indexOfObject: highScore];
    NSInteger lowIndex = [answers indexOfObject:lowScore];
    
    XCTAssertTrue(highIndex < lowIndex, @"High-scoring answer comes first");
}

- (void)testQuestionWasAskedBySomeone
{
    XCTAssertEqualObjects(question.asker, asker, @"Question should keep track of who asked it.");
}

@end
