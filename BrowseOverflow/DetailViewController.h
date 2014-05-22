//
//  DetailViewController.h
//  BrowseOverflow
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 square. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
