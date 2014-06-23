//
//  QuestionListTableDataSourceTests.m
//  BrowseOverflow
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QuestionListTableDataSource.h"
#import "Topic.h"
#import "Question.h"
#import "Person.h"
#import "QuestionSummaryCell.h"
#import "AvatarStore.h"
#import "AvatarStore+TestingExtensions.h"
#import "FakeNotificationCenter.h"
#import "ReloadDataWatcher.h"

@interface QuestionListTableDataSourceTests : XCTestCase

@end

@implementation QuestionListTableDataSourceTests
{
    QuestionListTableDataSource *dataSource;
    Topic *iPhoneTopic;
    NSIndexPath *firstCell;
    Question *question1, *question2;
    Person *asker1;
    AvatarStore *store;
    NSNotification *receivedNotification;
}

- (void)didReceiveNotification: (NSNotification*)note
{
    receivedNotification = note;
}

- (void)setUp
{
    [super setUp];
    
    dataSource = [[QuestionListTableDataSource alloc] init];
    iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    dataSource.topic = iPhoneTopic;
    firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    question1 = [[Question alloc] init];
    question1.title = @"Question One";
    question1.score = 2;
    question2 = [[Question alloc] init];
    question2.title = @"Question Two";
    
    asker1 = [[Person alloc] initWithName:@"Square" avatarLocation:@"http://www.gravatar.com/avatar/7b0fa634b6bebcb5703d025376cf611b.png"];
    question1.asker = asker1;
    
    store = [[AvatarStore alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    dataSource = nil;
    iPhoneTopic = nil;
    firstCell = nil;
    question1 = nil;
    question2 = nil;
    asker1 = nil;
    
    store = nil;
    receivedNotification = nil;
}

- (void)testCellGetsImageFromAvatarStore {
    dataSource.avatarStore = store;
    NSURL *imageURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"square" withExtension:@"jpeg"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    [store setData: imageData forLocation:@"http://www.gravatar.com/avatar/7b0fa634b6bebcb5703d025376cf611b.png"];
    [iPhoneTopic addQuestion:question1];
    QuestionSummaryCell *cell = (QuestionSummaryCell*)[dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertNotNil(cell.avatarView.image, @"The avatar store should supply the avatar images");
}

- (void)testQuestionListStopsRegisteringForAvatarNotifications {
    FakeNotificationCenter *center = [[FakeNotificationCenter alloc] init];
    dataSource.notificationCenter = (NSNotificationCenter *)center;
    [dataSource registerForUpdatesToAvatarStore:store];
    [dataSource removeObservervationOfUpdatesToAvatarStore:store];
    XCTAssertFalse([center hasObject: dataSource forNotification: AvatarStoreDidUpdateContentNotification], @"The data source should no longer listen to avatar store");
}

- (void)testQuestionListCausesTableReloadOnAvatarNotification {
    ReloadDataWatcher *fakeTableView = [[ReloadDataWatcher alloc] init];
    dataSource.tableView = (UITableView*)fakeTableView;
    [dataSource avatarStoreDidUpdateContent:nil];
    XCTAssertTrue([fakeTableView didReceiveReloadData], @"Data source should get the table view to reload when new data is available");
}

- (void)testQuestionListRegistersForAvatarNotifications {
    FakeNotificationCenter *center = [[FakeNotificationCenter alloc] init];
    dataSource.notificationCenter = (NSNotificationCenter*)center;
    [dataSource registerForUpdatesToAvatarStore:store];
    XCTAssertTrue([center hasObject: dataSource forNotification: AvatarStoreDidUpdateContentNotification], @"The data source should know when new images have been downloaded");
}

- (void)testTopicWithNoQuestionsLeadsToOneRowInTheTable {
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)1, @"The table view needs a 'no data yet' placeholder cell");
}

- (void)testTopicWithQuestionsResultsInOneRowPerQuestionInTheTable {
    [iPhoneTopic addQuestion:question1];
    [iPhoneTopic addQuestion:question2];
    XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)2, @"Two questions in the topic means two rows in the table");
}

- (void)testContentOfPlaceholderCell {
    UITableViewCell *placeholderCell = [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertEqualObjects(placeholderCell.textLabel.text, @"There was a problem.", @"The placeholder cell ought to display a placeholder message");
}

- (void)testPlaceholderCellNotReturnedWhenQuestionsExist {
    [iPhoneTopic addQuestion:question1];
    UITableViewCell *cell = [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertFalse([cell.textLabel.text isEqualToString:@"There was a problem connecting to the network."], @"Placeholder should only be shown when there's no content");
}

- (void)testCellPropertiesAreTheSameAsTheQuestion {
    [iPhoneTopic addQuestion:question1];
    QuestionSummaryCell *cell = (QuestionSummaryCell*)[dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    XCTAssertEqualObjects(cell.titleLabel.text, @"Question One", @"Question cells display the question's title");
    XCTAssertEqualObjects(cell.scoreLabel.text, @"2", @"Question cells display the question's score");
    XCTAssertEqualObjects(cell.nameLabel.text, @"Square", @"Question cells display the asker's name");
}

@end
