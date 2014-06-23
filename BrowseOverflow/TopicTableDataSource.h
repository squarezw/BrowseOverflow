//
//  EmptyTableViewDataSource.h
//  BrowseOverflow
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Topic;

@interface TopicTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (void)setTopics: (NSArray *)newTopics;

- (Topic *)topicForIndexPath:(NSIndexPath *)indexPath;

@end

extern NSString *TopicTableDidSelectTopicNotification;