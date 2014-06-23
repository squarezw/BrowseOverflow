//
//  QuestionListTableDataSource.m
//  BrowseOverflow
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import "QuestionListTableDataSource.h"
#import "QuestionSummaryCell.h"
#import "Topic.h"
#import "Question.h"
#import "Person.h"
#import "AvatarStore.h"

@implementation QuestionListTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_topic recentQuestions] count]? : 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([_topic.recentQuestions count]) {
        Question *question = [_topic.recentQuestions objectAtIndex:indexPath.row];
        _summaryCell = [tableView dequeueReusableCellWithIdentifier:@"question"];
        if (!_summaryCell) {
            [[NSBundle bundleForClass:[self class]] loadNibNamed:@"QuestionSummaryCell" owner:self options:nil];
        }
        _summaryCell.titleLabel.text = question.title;
        _summaryCell.scoreLabel.text = [NSString stringWithFormat:@"%d", question.score];
        _summaryCell.nameLabel.text = question.asker.name;
        
        NSData *avatarData = [_avatarStore dataForURL:question.asker.avatarURL];
        if (avatarData) {
            _summaryCell.avatarView.image = [UIImage imageWithData:avatarData];
        }
        
        cell = _summaryCell;
        _summaryCell = nil;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"placeholder"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeholder"];
        }
        cell.textLabel.text = @"There was a problem.";
    }
    return cell;
}

- (void)registerForUpdatesToAvatarStore:(AvatarStore *)store
{
    [_notificationCenter addObserver:self selector:@selector(avatarStoreDidUpdateContent:) name:AvatarStoreDidUpdateContentNotification object:store];
}

- (void)removeObservervationOfUpdatesToAvatarStore:(AvatarStore *)store
{
    [_notificationCenter removeObserver:self name:AvatarStoreDidUpdateContentNotification object:store];
}

- (void)avatarStoreDidUpdateContent:(NSNotification *)notification
{
    [_tableView reloadData];
}

@end
