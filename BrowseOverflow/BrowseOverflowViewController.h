//
//  BrowseOverflowViewController.h
//  BrowseOverflow
//
//  Created by apple on 14-6-5.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseOverflowViewController : UIViewController

@property (strong) UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;

- (void)userDidSelectTopicNotification: (NSNotification *)note;

@end
