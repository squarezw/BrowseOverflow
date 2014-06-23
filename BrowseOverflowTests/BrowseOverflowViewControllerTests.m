//
//  BrowseOverflowViewControllerTests.m
//  BrowseOverflow
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "BrowseOverflowViewController.h"
#import "QuestionListTableDataSource.h"
#import "TopicTableDataSource.h"
#import "Topic.h"

static const char *notificationKey = "BrowseOverflowViewControllerTestsAssociatedNotificationKey";
static const char *viewDidAppearKey = "BrowseOverflowViewControllerTestsViewDidAppearKey";
static const char *viewWillDisappearKey = "BrowseOverflowControllerTestsViewWillDisappearKey";

@implementation UIViewController (TestSuperclassCalled)

- (void)browseOverflowViewControllerTests_viewDidAppear: (BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, viewDidAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)browseOverflowViewControllerTests_viewWillDisappear: (BOOL)animated
{
    NSNumber *parameter = [NSNumber numberWithBool:animated];
    objc_setAssociatedObject(self, viewWillDisappearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation BrowseOverflowViewController (TestNotificationDelivery)

- (void)browseOverflowControllerTests_userDidSelectTopicNotification:(NSNotification*)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

@end

@interface BrowseOverflowViewControllerTests : XCTestCase

@end

@implementation BrowseOverflowViewControllerTests
{
    BrowseOverflowViewController *viewController;
    UITableView *tableView;
    id <UITableViewDataSource, UITableViewDelegate> dataSource;
    
    SEL realViewDidAppear, testViewDidAppear;
    SEL realViewWillDisappear, testViewWillDisappear;
    SEL realUserDidSelectTopic, testUserDidSelectTopic;
    
    UINavigationController *navController;
}

+ (void)swapInstanceMethodsForClass: (Class)cls selector:(SEL)sel1 andSelector:(SEL)sel2
{
    Method method1 = class_getInstanceMethod(cls, sel1);
    Method method2 = class_getInstanceMethod(cls, sel2);
    method_exchangeImplementations(method1, method2);
}

- (void)setUp
{
    [super setUp];
    
    viewController = [[BrowseOverflowViewController alloc] init];
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
    dataSource = [[TopicTableDataSource alloc] init];
    viewController.dataSource = dataSource;
    
    objc_removeAssociatedObjects(viewController);
    
    realViewDidAppear = @selector(viewDidAppear:);
    testViewDidAppear = @selector(browseOverflowViewControllerTests_viewDidAppear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    
    realViewWillDisappear = @selector(viewWillDisappear:);
    testViewWillDisappear = @selector(browseOverflowViewControllerTests_viewWillDisappear:);
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    
    realUserDidSelectTopic = @selector(userDidSelectTopicNotification:);
    testUserDidSelectTopic = @selector(browseOverflowControllerTests_userDidSelectTopicNotification:);
    
    navController = [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (void)tearDown
{
    objc_removeAssociatedObjects(viewController);
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewDidAppear andSelector:testViewDidAppear];
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[UIViewController class] selector:realViewWillDisappear andSelector:testViewWillDisappear];
    
    navController = nil;
}

- (void)testViewControllerHasATableViewProperty
{
    objc_property_t tableViewProperty =
    class_getProperty([viewController class], "tableView");
    
    XCTAssertTrue(tableViewProperty != NULL, @"BrowseOverflowViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty
{
    objc_property_t dataSourceProperty =
    class_getProperty([viewController class], "dataSource");
    
    XCTAssertTrue(dataSourceProperty != NULL, @"View Controller needs a data source");
}

- (void)testViewControllerConnectsDataSourceInViewdidLoad
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set the table view's data source");
}

- (void)testViewControllerConnectsDelegateInViewDidLoad
{
    [viewController viewDidLoad];
    XCTAssertEqualObjects([tableView delegate], dataSource, @"View controller should have set the table view's delegate");
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications {
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received beofore -viewDidAppear");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear {
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
    [viewController viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewWillDisappear: is called, the view controller should no longer respond to topic selection notifications");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear {
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
    [viewController viewDidAppear:NO];
    [viewController viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:nil userInfo:nil];
    XCTAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewWillDisappear: is called, the view controller should no longer respond to topic selection notifications");
    [BrowseOverflowViewControllerTests swapInstanceMethodsForClass:[BrowseOverflowViewController class] selector:realUserDidSelectTopic andSelector:testUserDidSelectTopic];
}

- (void)testViewControllerCallsSuperViewDidAppear {
    [viewController viewDidAppear:NO];
    
    XCTAssertNotNil(objc_getAssociatedObject(viewController, viewDidAppearKey), @"-viewDidAppear: should call through to superclass implementation");
}

- (void)testViewControllerCallsSuperViewWillDisappear {
    [viewController viewWillDisappear:NO];
    XCTAssertNotNil(objc_getAssociatedObject(viewController, viewWillDisappearKey), @"-viewWillAppear: should call through to superclass implementation");
}

- (void)testSelectingTopicPushNewViewController {
    [viewController userDidSelectTopicNotification:nil];
    UIViewController *currentTopVC = navController.topViewController;
    XCTAssertFalse([currentTopVC isEqual:viewController], @"New view controller should be pushed onto the stack");
    XCTAssertTrue([currentTopVC isKindOfClass:[BrowseOverflowViewController class]], @"New view Controller should be a BrowseOverflowViewController");
}

- (void)testNewViewControllerHasAQuestionListDataSourceForTheSelectedTopic {
    Topic *iPhoneTopic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
    
    NSNotification *iPhoneTopicSelectedNotification = [NSNotification notificationWithName:TopicTableDidSelectTopicNotification object:iPhoneTopic];
    [viewController userDidSelectTopicNotification:iPhoneTopicSelectedNotification];
    BrowseOverflowViewController *nextViewController = (BrowseOverflowViewController*)navController.topViewController;
    XCTAssertTrue([nextViewController.dataSource isKindOfClass:[QuestionListTableDataSource class]], @"Selecting a topic should push a list of questions");
    XCTAssertEqualObjects([(QuestionListTableDataSource*)nextViewController.dataSource topic], iPhoneTopic, @"The questions to display should come from the selected topic");
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad {
    QuestionListTableDataSource *questionDataSource = [[QuestionListTableDataSource alloc] init];
    viewController.dataSource = questionDataSource;
    [viewController viewDidLoad];
    XCTAssertEqualObjects(questionDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
}

@end
