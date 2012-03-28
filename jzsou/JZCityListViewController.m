//
//  JZCityListViewController.m
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZCityListViewController.h"
#import "CustomBarButtonItem.h"
#import "LocationController.h"
#import "Utils.h"
#import "Config.h"
#import "ASIHTTPRequest.h"

@interface JZCityListViewController ()

@end

@implementation JZCityListViewController

@synthesize tableView=_tableView;
@synthesize navigationBar=_navigationBar;
@synthesize myNavigationItem=_myNavigationItem;
@synthesize currentCity=_currentCity;
@synthesize curLocCell=_curLocCell;
@synthesize cateListViewController=_cateListViewController;

- (void)dealloc
{
    [_tableView release];
    [_navigationBar release];
    [_myNavigationItem release];
    [_listCity release];
    [_dictCity release];
    [_currentCity release];
    [_cateListViewController release];
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

- (NSArray *)listCity
{
    if (_listCity == nil){
        // read the plist loud category configure
        NSString *myFile = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        NSDictionary *cates = [NSDictionary dictionaryWithContentsOfFile:myFile];
        NSArray *sortedArray = [[cates allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *d1, NSDictionary *d2){
            int dnum1 = [[d1 objectForKey:@"no"] intValue];
            int dnum2 = [[d2 objectForKey:@"no"] intValue];
            return dnum1 > dnum2;
        }];
        
        NSMutableArray *firstSection = [NSMutableArray arrayWithObject:
                                        [NSDictionary dictionaryWithObject:@"加载中..." 
                                                                    forKey:@"name"]];

        _listCity = [[NSArray alloc] initWithObjects: firstSection, sortedArray, nil]; 
        
    }
    
    return _listCity;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myNavigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] 
                                                initBackBarButtonItemWithTarget:self 
                                                action:@selector(backAction:) 
                                                title:@"返回"] autorelease];
    
}

- (void)backAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fakeGetLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [self.listCity count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[self.listCity objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;

    } 
    // Configure the cell...
    NSDictionary *city = [[self.listCity objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [city objectForKey:@"name"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section){
        return @"定位所在城市";
    } else if (1 == section) {
        return @"可选城市";
    }
    return @"";
}

- (void)fakeGetLocation
{
    if ([CLLocationManager locationServicesEnabled]){
        [[LocationController sharedInstance].locationManager startUpdatingLocation];
        
        [self performSelector:@selector(getLocation) withObject:nil afterDelay:1.5];
    }  
}

- (void)getLocation
{
    
    if (NO == [LocationController sharedInstance].allow){
        return;
    }
    
    // make json data for post
    CLLocationCoordinate2D curloc = [LocationController sharedInstance].location.coordinate;
    [[LocationController sharedInstance].locationManager stopUpdatingLocation];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@/city/%f,%f", LOCHOST, curloc.latitude, curloc.longitude]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        if (200 == [request responseStatusCode]){
            NSString *locLabel = [request responseString];
            NSDictionary *maybeCity = [self.dictCity objectForKey:locLabel];

            if (![locLabel isEqualToString:@""] && maybeCity){


                [[self.listCity objectAtIndex:0] setObject:maybeCity atIndex:0];
                [self.tableView reloadData];
                
            }
        }
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *city = [[self.listCity objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (nil != [city objectForKey:@"label"]){
        self.cateListViewController.currentCity = city;
        [self dismissModalViewControllerAnimated:YES];
    }

}

@end
