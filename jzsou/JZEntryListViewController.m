//
//  JZEntryListViewController.m
//  jzsou
//
//  Created by Dai Cloud on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZEntryListViewController.h"
#import "CustomBarButtonItem.h"
#import "JZEntryDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "Utils.h"
#import "Config.h"
#import "SBJson.h"
#import "LocationController.h"
#import "JZEntryCell.h"
#import "NSString+URLEncoding.h"
#import "UIViewController+msg.h"

@interface JZEntryListViewController ()
- (void)fetchEntryList:(NSString *) urlStr;
- (void)fakeFetchEntryListWithLoc;
- (void)fetchEntryListWithLoc;
- (void)fetchEntryListWithTag;
- (void)fetchEntryListWithQ;
- (void)fetchNextLoudList;
- (void)fetchEntryListWithQOrTag;
@end

@implementation JZEntryListViewController

@synthesize cate=_cate;
@synthesize curCity=_curCity;
@synthesize etag=_etag;
@synthesize curCollection=_curCollection;
@synthesize entries=_entries;
@synthesize q=_q;
@synthesize canLoad=_canLoad;

- (void)dealloc
{
    [_cate release];
    [_curCity release];
    [_etag release];
    [_entries release];
    [_curCollection release];
    [_q release];
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


    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] 
                                             initBackBarButtonItemWithTarget:self 
                                                                      action:@selector(backAction:) 
                                                                       title:@"返回"] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] 
                                               initConfirmBarButtonItemWithTarget:self 
                                               action:@selector(nearbyAction:)
                                               title:@"附近"] autorelease];
    
    self.navigationItem.title = [self.cate objectForKey:@"name"];

    
    if (NO == [LocationController sharedInstance].allow){
        self.navigationItem.rightBarButtonItem.enabled = NO;

    }
    
    // init list
    [self fetchEntryListWithQOrTag];
    
    // init can load next entries list
    self.canLoad = YES;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nearbyAction:(id)sender
{
    [self fakeFetchEntryListWithLoc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    JZEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[JZEntryCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
    } 
    
    NSDictionary *entry = [self.entries objectAtIndex:indexPath.row];
    cell.title.text =[entry objectForKey:@"title"];
    cell.subTitle.text = [entry objectForKey:@"address"];
    // may be distance
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    JZEntryDetailViewController *detailViewController = [[JZEntryDetailViewController alloc] initWithNibName:@"JZEntryDetailViewController" bundle:nil];
     // ...
    NSMutableDictionary *entry = [self.entries objectAtIndex:indexPath.row];
    detailViewController.entry = entry;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.entries.count - 1 &&
        nil != self.entries &&
        [self.curCollection objectForKey:@"next"] &&
        self.canLoad) {
        
        [self fetchNextLoudList];
    }
}

#pragma mark - RESTful request
- (void)fakeFetchEntryListWithLoc
{
    if ([CLLocationManager locationServicesEnabled]){

        [[LocationController sharedInstance].locationManager startUpdatingLocation];
        [self performSelector:@selector(fetchEntryListWithLoc) withObject:nil afterDelay:1.5];        
        
    } else {
        [self fetchEntryListWithQOrTag];
    }
    
}

-(void)fetchEntryListWithQOrTag
{
    if (nil != self.cate){
        [self fetchEntryListWithTag];
    } else if (nil != self.q) {
        [self fetchEntryListWithQ];
    }
}

- (void)fetchEntryListWithLoc
{
    
    if (NO == [LocationController sharedInstance].allow){
        [self fetchEntryListWithQOrTag];
        return;
    }
    
    CLLocationCoordinate2D curloc = [LocationController sharedInstance].location.coordinate;
    [[LocationController sharedInstance].locationManager stopUpdatingLocation];
    

    
    // init list
    NSString *url=nil;
    if (nil != self.cate){

        url = [NSString stringWithFormat:@"%@/%@/s?q=tag:%@&pos=%f,%f&st=%d&qn=%d", 
                         HOST, 
                         [self.curCity objectForKey:@"label"],
                         [self.cate objectForKey:@"label"],
                         curloc.latitude, curloc.longitude,
                         0, 20
                         ];
    } else if (nil != self.q) {
        url = [NSString stringWithFormat:@"%@/%@/s?q=key:%@&pos=%f,%f&st=%d&qn=%d", 
                         HOST, 
                         [self.curCity objectForKey:@"label"],
                         [self.q URLEncodedString],
                         curloc.latitude, curloc.longitude,
                         0, 20
                         ];
    }
    
    if (url != nil) {
        [self fetchEntryList:url];
    }
    
}


- (void)fetchEntryListWithTag
{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/s?q=tag:%@&st=%d&qn=%d", 
                                       HOST, 
                                       [self.curCity objectForKey:@"label"],
                                       [self.cate objectForKey:@"label"],
                                       0, 20
                                       ];
    [self fetchEntryList:url];

}

- (void)fetchEntryListWithQ
{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/s?q=key:%@&st=%d&qn=%d", 
                                       HOST, 
                                       [self.curCity objectForKey:@"label"],
                                       [self.q URLEncodedString],
                                       0, 20
                                       ];
    [self fetchEntryList:url];
}

- (void)fetchEntryList:(NSString *) urlStr
{
    

    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    if (nil != self.etag){
        [request addRequestHeader:@"If-None-Match" value:self.etag];
    }
    //[request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestListDone:)];
    [request setDidFailSelector:@selector(requestListWentWrong:)];
    [request addRequestHeader:@"Authorization" value:TOKEN];
    [request startAsynchronous];
}


- (void)requestListDone:(ASIHTTPRequest *)request
{
    NSInteger code = [request responseStatusCode];
    if (200 == code){
        NSString *body = [request responseString];
        
        //NSLog(@"body: %@", body);
        // create the json parser 
        NSMutableDictionary * collection = [body JSONValue];
        
        
        self.curCollection = collection;
        self.entries = [collection objectForKey:@"entries"];
        self.etag = [[request responseHeaders] objectForKey:@"Etag"];
        
        // reload the tableview data
        [self.tableView reloadData];

        if ([[collection objectForKey:@"total"] intValue] == 0) {
            [self fadeInMsgWithText:@"无信息" rect:CGRectMake(0, 0, 80, 70)];
        }
        
        
    } else if (304 == code){
        // do nothing
    } else{
        [Utils warningNotification:@"获取数据失败"];
        
    }
}

- (void)requestListWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"request loud list: %@", [error localizedDescription]);
    [Utils warningNotification:@"网络链接错误"];
    
}

#pragma mark - next here
- (void)fetchNextLoudList
{
    
    self.canLoad = NO;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[self.curCollection objectForKey:@"next"]]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestNextListDone:)];
    [request setDidFailSelector:@selector(requestNextListWentWrong:)];
    [request addRequestHeader:@"Authorization" value:TOKEN];
    [request startAsynchronous];
    
}

- (void)requestNextListDone:(ASIHTTPRequest *)request
{
    NSInteger code = [request responseStatusCode];
    if (200 == code){
        
        NSString *body = [request responseString];
        // create the json parser 
        NSMutableDictionary *collection = [body JSONValue];
        
        self.curCollection = collection;
        [self.entries addObjectsFromArray:[collection objectForKey:@"entries"]];
        
        // reload the tableview data
        [self.tableView reloadData];
        
    }
    
    self.canLoad = YES;
    
}

- (void)requestNextListWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"request next loud list: %@", [error localizedDescription]);
    self.canLoad = YES;
    
}

@end
