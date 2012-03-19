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
#import "JZListCateCell.h"
#import "LocationController.h"
#import "ASIHTTPRequest.h"
#import "Utils.h"
#import "Config.h"

@interface JZCateListViewController ()
-(void)setButtonTitle:(NSString *)title;
-(void)fakeGetLocation;
@end

@implementation JZCateListViewController

@synthesize searchBar=_searchBar;
@synthesize button=_button;
@synthesize currentCity=_currentCity;

- (void)dealloc
{
    [_searchBar release];
    [_button release];
    [_listCates release];
    [_dictCity release];
    [_currentCity release];

    [super dealloc];
}

- (NSDictionary *)dictCity
{
    if (_dictCity == nil){
        // read the plist loud category configure
        NSString *myFile = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        _dictCity = [[NSDictionary dictionaryWithContentsOfFile:myFile] retain];
        
    }
    
    return _dictCity;
}

- (NSArray *)listCates
{
    if (_listCates == nil){
        // read the plist loud category configure
        NSString *myFile = [[NSBundle mainBundle] pathForResource:@"cates" ofType:@"plist"];
        NSDictionary *cates = [NSDictionary dictionaryWithContentsOfFile:myFile];
        NSArray *sortedArray = [[cates allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *d1, NSDictionary *d2){
            int dnum1 = [[d1 objectForKey:@"no"] intValue];
            int dnum2 = [[d2 objectForKey:@"no"] intValue];
            return dnum1 > dnum2;
        }];
        
        _listCates = [[NSArray alloc] initWithObjects: sortedArray, nil]; 
        
    }
    
    return _listCates;
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
    
    // init table cell
    self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0 
                                                     green:253/255.0 
                                                      blue:251/255.0 
                                                     alpha:1.0];

//    [self setButtonTitle:[[self.dictCity objectForKey:@"hangzhou"] objectForKey:@"name"]];

}

-(void)buttonAction:(id)sender
{
    if (nil != self.currentCity){
        JZCityListViewController *jzcvc = [[JZCityListViewController alloc] initWithNibName:@"JZCityListViewController" bundle:nil];
        jzcvc.currentCity = self.currentCity;
        jzcvc.cateListViewController = self;
        [self presentModalViewController:jzcvc animated:YES];
        [jzcvc release];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (nil == self.currentCity){
        [self fakeGetLocation];
    } else {

        [self setButtonTitle:[self.currentCity objectForKey:@"name"]];
    }
    
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
    return [self.listCates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.listCates objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    JZListCateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[JZListCateCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier] autorelease];
    } 
    // Configure the cell...
    NSDictionary *cate = [[self.listCates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.name.text = [cate objectForKey:@"name"];
    cell.logo.image = [UIImage imageNamed:[cate objectForKey:@"logo"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (nil != self.currentCity){
        JZEntryListViewController *detailViewController = [[JZEntryListViewController alloc] initWithNibName:@"JZEntryListViewController" bundle:nil];
         // ...
         // Pass the selected object to the new view controller.
        detailViewController.curCity = self.currentCity;
        detailViewController.cate = [[self.listCates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
     
}

- (void)fakeGetLocation
{
    if ([CLLocationManager locationServicesEnabled]){
        [[LocationController sharedInstance].locationManager startUpdatingLocation];
        
        [self performSelector:@selector(getLocation) withObject:nil afterDelay:1.0];
    } else {
        NSDictionary *city = [self.dictCity objectForKey:@"hangzhou"];
        self.currentCity = city;
        [self setButtonTitle:[self.currentCity objectForKey:@"name"]];
    }   
}

- (void)getLocation
{
    
    if (NO == [LocationController sharedInstance].allow){
        NSDictionary *city = [self.dictCity objectForKey:@"hangzhou"];
        self.currentCity = city;
        [self setButtonTitle:[self.currentCity objectForKey:@"name"]];
        return;
    }
    
    // make json data for post
    CLLocationCoordinate2D curloc = [LocationController sharedInstance].location.coordinate;
    [[LocationController sharedInstance].locationManager stopUpdatingLocation];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@/city/%f,%f", LOCHOST, curloc.latitude, curloc.longitude]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSDictionary *city = [self.dictCity objectForKey:@"hangzhou"];
    NSError *error = [request error];
    if (!error) {
        if (200 == [request responseStatusCode]){
            NSString *locLabel = [request responseString];
            NSDictionary *maybeCity = [self.dictCity objectForKey:locLabel];
            
            if (![locLabel isEqualToString:@""] && maybeCity){
                
                city = maybeCity;

            }
        }
    }
    self.currentCity = city;
    [self setButtonTitle:[self.currentCity objectForKey:@"name"]];
}

#pragma mark - search delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    if (nil != self.currentCity){
        JZEntryListViewController *detailViewController = [[JZEntryListViewController alloc] initWithNibName:@"JZEntryListViewController" bundle:nil];

        detailViewController.curCity = self.currentCity;
        detailViewController.q = self.searchBar.text;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

    self.searchBar.showsCancelButton = YES;
    // change the title
    for (UIView *subview in [self.searchBar subviews]) {
        CGRect bouds = [subview bounds];
        CGSize size = bouds.size;
        
        if (size.width == 48 && size.height == 30){
            [subview performSelector:@selector(setTitle:) withObject:@"取消"];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

@end
