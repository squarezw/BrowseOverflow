//
//  TopicTableDataSourceTests.m
//  BrowseOverflow
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TopicTableDataSource.h"
#import "Topic.h"

@interface TopicTableDataSourceTests : XCTestCase

@end

@implementation TopicTableDataSourceTests
{
    TopicTableDataSource *dataSource;
    NSArray *topicsList;
}

- (void)setUp
{
    [super setUp];
    dataSource = [[TopicTableDataSource alloc] init];
    Topic *sampleTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    
    topicsList = [NSArray arrayWithObject:sampleTopic];
    [dataSource setTopics:topicsList];
}

- (void)tearDown
{
    dataSource = nil;
    topicsList = nil;
    [super tearDown];
}

- (void)testOneTableRowForOneTopic
{
    XCTAssertEqual([topicsList count], [dataSource tableView:nil numberOfRowsInSection:0], @"As there's one topic, there should be one row in the table");
}

- (void)testTwoTableRowsForTwoTopics
{
    Topic *topic1 = [[Topic alloc] initWithName:@"Mac OS X" tag:@"macosx"];
    Topic *topic2 = [[Topic alloc] initWithName:@"Cocoa" tag:@"cocoa"];
    
    NSArray *twoTopicsList = [NSArray arrayWithObjects:topic1, topic2, nil];
    [dataSource setTopics:twoTopicsList];
    
    XCTAssertEqual([twoTopicsList count], [dataSource tableView:nil numberOfRowsInSection:0], @"There should be two rows in the table for two topics");
}

- (void)testOneSectionInTheTableView
{
    XCTAssertThrows([dataSource tableView:nil numberOfRowsInSection:1], @"Data source doesn't allow asking about additional section");
}

- (void)testTopicDataSourceCanReceiveAListOfTopics
{
    XCTAssertNoThrow([dataSource setTopics: topicsList], @"The data source needs a list of topics");
}

- (void)testDataSourceCellCreationExpectsOneSection
{
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow:0 inSection:1];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:secondSection], @"Data source will not prepare cells for unexpected section");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasTopics
{
    NSIndexPath *afterLastTopic = [NSIndexPath indexPathForRow:[topicsList count] inSection:0];
    XCTAssertThrows([dataSource tableView:nil cellForRowAtIndexPath:afterLastTopic], @"Data source will not prepare more cells than there are topics");
}

- (void)testCellCreatedByDataSourceContainsTopicTitleAsTextLabel
{
    NSIndexPath *firstTopic = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *firstCell = [dataSource tableView:nil cellForRowAtIndexPath:firstTopic];
    
    NSString *cellTitle = firstCell.textLabel.text;
    XCTAssertEqualObjects(@"iPhone", cellTitle, @"Cell's title should be equal to the topic's title");
}

- (void)testDataSourceIndicatesWhichTopicIsRepresentedForAnIndexPath
{
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    
    Topic *firstTopic = [dataSource topicForIndexPath:firstRow];
    XCTAssertEqualObjects(firstTopic.tag, @"iphone", @"The iPhone Topic is at row 0");
    
}

@end
