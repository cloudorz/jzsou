//
//  JZEntryListViewController.h
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZEntryListViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *cate, *curCity;
@property (strong, nonatomic) NSString *etag, *q;
@property (strong, nonatomic) NSMutableDictionary *curCollection;
@property (strong, nonatomic) NSMutableArray *entries;

@end
