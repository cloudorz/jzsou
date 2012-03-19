//
//  JZCateListViewController.h
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZCateListViewController : UITableViewController <UISearchBarDelegate>
{
    NSArray *_listCates;
    NSDictionary *_dictCity;
}

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic, readonly) NSArray *listCates;
@property (strong, nonatomic, readonly) NSDictionary *dictCity;
@property (strong, nonatomic) NSDictionary *currentCity;

@end
