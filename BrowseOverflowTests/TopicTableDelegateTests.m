//
//  TopicTableDelegateTests.m
//  BrowseOverflow
//
//  Created by apple on 14-6-17.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TopicTableDataSource.h"
#import "Topic.h"

@interface TopicTableDelegateTests : XCTestCase

@end

@implementation TopicTableDelegateTests
{
    NSNotification *receivedNotification;
    TopicTableDataSource *dataSource;
    Topic *iPhoneTopic;
}

- (void)setUp
{
    [super setUp];
    
    dataSource = [[TopicTableDataSource alloc] init];
    iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    [dataSource setTopics:[NSArray arrayWithObject:iPhoneTopic]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:TopicTableDidSelectTopicNotification object:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    receivedNotification = nil;
    dataSource = nil;
    iPhoneTopic = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveNotification: (NSNotification*)note{
    receivedNotification = note;
}

- (void)testDelegatePostsNotificationOnSelectionShowingWhichTopicWasSelected
{
    NSIndexPath *selection = [NSIndexPath indexPathForRow:0 inSection:0];
    [dataSource tableView:nil didSelectRowAtIndexPath:selection];
    XCTAssertEqualObjects([receivedNotification name], @"TopicTableDidSelectTopicNotification", @"The delegate should notify that a topic was selected");
    XCTAssertEqualObjects([receivedNotification object], iPhoneTopic, @"The notification should indicate which topic was selected");
}

@end
