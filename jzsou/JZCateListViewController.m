//
//  JZCateListViewController.m
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZCateListViewController.h"
#import "JZCityListViewController.h"
#import "JZEntryListViewController.h"

@interface JZCateListViewController ()
-(void)setButtonTitle:(NSString *)title;
@end

@implementation JZCateListViewController

@synthesize searchBar=_searchBar;
@synthesize button=_button;

- (void)dealloc
{
    [_searchBar release];
    [_button release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // search bar config
    [self.tableView.tableHeaderView addSubview:self.searchBar];
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage imageNamed:@"bgSearch.png"];
    searchBar.tintColor = [UIColor colorWithRed:77/255.0 green:66/255.0 blue:61/255.0 alpha:1.0];
    searchBar.placeholder = @"家政搜索";
    self.searchBar = searchBar;
    self.tableView.tableHeaderView = searchBar;
    
    // navigation bar item title view config
    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectMake(20, 4, 280, 36)] autorelease];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(77, 2, 125, 32);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    button.backgroundColor = [UIColor clearColor]; 
    [button setBackgroundImage:[UIImage imageNamed:@"btndown.png"] forState:UIControlStateHighlighted];
//    [button setTitle:@"杭州湾" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(80, 11, 40, 13)] autorelease];
    label.tag =1;
    label.text = @"家政搜";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    self.button = button;
    [titleView addSubview:button];

    self.navigationItem.titleView = titleView;

    [self setButtonTitle:@"杭州湾"];
}

-(void)buttonAction:(id)sender
{

    JZCityListViewController *jzcvc = [[JZCityListViewController alloc] initWithNibName:@"JZCityListViewController" bundle:nil];
    [self presentModalViewController:jzcvc animated:YES];
    [jzcvc release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setButtonTitle:(NSString *)title
{
    UILabel *label = (UILabel *)[self.button viewWithTag:1];
    
    CGFloat width = [title sizeWithFont:
                     [UIFont boldSystemFontOfSize:18]                              
                      constrainedToSize:CGSizeMake(100, CGFLOAT_MAX) 
                        lineBreakMode:UILineBreakModeWordWrap].width;
    [self.button setTitle:[NSString stringWithFormat:@"%@       ", title] forState:UIControlStateNormal];
    CGRect labelFrame = label.frame;
    labelFrame.origin.x = 62 + width/2 + 2 - 18;
    label.frame = labelFrame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier] autorelease];
    } 
    // Configure the cell...
    cell.textLabel.text = @"fcuk this world";
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     JZEntryListViewController *detailViewController = [[JZEntryListViewController alloc] initWithNibName:@"JZEntryListViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}

#pragma mark - search delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search this world");
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

@end
