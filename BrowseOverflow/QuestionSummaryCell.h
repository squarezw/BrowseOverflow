//
//  QuestionSummaryCell.h
//  BrowseOverflow
//
//  Created by apple on 14-6-19.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionSummaryCell : UITableViewCell

@property (strong) IBOutlet UILabel *titleLabel;
@property (strong) IBOutlet UILabel *scoreLabel;
@property (strong) IBOutlet UILabel *nameLabel;
@property (strong) IBOutlet UIImageView *avatarView;

@end
