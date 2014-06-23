//
//  QuestionListTableDataSource.h
//  BrowseOverflow
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Topic;
@class QuestionSummaryCell;
@class AvatarStore;

@interface QuestionListTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong) Topic *topic;
@property (weak) IBOutlet QuestionSummaryCell *summaryCell;
@property (strong) AvatarStore *avatarStore;
@property (weak) UITableView *tableView;
@property (strong) NSNotificationCenter *notificationCenter;

- (void)registerForUpdatesToAvatarStore: (AvatarStore *)store;
- (void)removeObservervationOfUpdatesToAvatarStore:(AvatarStore *)store;
- (void)avatarStoreDidUpdateContent: (NSNotification *)notification;

@end
