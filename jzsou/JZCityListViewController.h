//
//  JZCityListViewController.h
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZCateListViewController.h"

@interface JZCityListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_listCity;
    NSDictionary *_dictCity;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (strong, nonatomic, readonly) NSArray *listCity;
@property (strong, nonatomic) UITableViewCell *curLocCell;
@property (strong, nonatomic) JZCateListViewController *cateListViewController;

@end
