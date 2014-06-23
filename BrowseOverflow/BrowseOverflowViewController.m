//
//  BrowseOverflowViewController.m
//  BrowseOverflow
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "BrowseOverflowViewController.h"
#import "TopicTableDataSource.h"
#import "QuestionListTableDataSource.h"
#import <objc/runtime.h>

@interface BrowseOverflowViewController ()

@end

@implementation BrowseOverflowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    objc_property_t tableViewProperty = class_getProperty([_dataSource class], "tableView");
    if (tableViewProperty) {
        [_dataSource setValue:_tableView forKey: @"tableView"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelectTopicNotification:) name:TopicTableDidSelectTopicNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TopicTableDidSelectTopicNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidSelectTopicNotification: (NSNotification *)note
{
    Topic *selectedTopic = (Topic *)[note object];
    BrowseOverflowViewController *nextViewController = [[BrowseOverflowViewController alloc] init];
    QuestionListTableDataSource *questionDataSource = [[QuestionListTableDataSource alloc] init];
    questionDataSource.topic = selectedTopic;
    nextViewController.dataSource = questionDataSource;
    [[self navigationController] pushViewController:nextViewController animated:YES];
}

@end
