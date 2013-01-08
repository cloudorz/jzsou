//
//  Utils.m
//  WhoHelp
//
//  Created by cloud on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation Utils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - handling errors
+ (void)helpNotificationForTitle: (NSString *)title forMessage: (NSString *)message
{
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [Notpermitted show];
    [Notpermitted release];
}

+ (void)warningNotification:(NSString *)message
{
    [self helpNotificationForTitle:@"警告" forMessage:message];
}

+ (void)errorNotification:(NSString *)message
{
    [self helpNotificationForTitle:@"错误" forMessage:message];  
}

+ (void)tellNotification:(NSString *)message
{
    [self helpNotificationForTitle:nil forMessage:message];  
}

#pragma makr link the part uri with query string
+ (NSURL *)partURI: (NSString *)uri queryString: (NSString *) query
{
   
    NSString *fill;
    
    NSRange rang = [uri rangeOfString:@"?" options:NSBackwardsSearch];
    if (rang.location != NSNotFound){
        if (rang.location == ([uri length] - 1)){
            fill = @"";
        } else {
            fill = @"&";
        }
    } else{
        fill = @"?";
    }
    
    NSURL *fullURI = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", uri, fill, query]];
    [fill release];
    
    return fullURI;
}

+ (void)updateCounterFor:(NSString *)uri counter:(NSString *)counterName
{

    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:
                                       [NSURL URLWithString:[NSString stringWithFormat:@"%@?f=%@", uri, counterName]]
                                       ];
    NSDictionary *content = [NSDictionary  dictionaryWithObjectsAndKeys:
                             [[[UIDevice currentDevice] uniqueIdentifier] description], counterName, 
                             nil];

    [request appendPostData:[[content JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addRequestHeader:@"Content-Type" value:@"Application/json;charset=utf-8"];
    [request addRequestHeader:@"Authorization" value:TOKEN];
    [request setRequestMethod:@"PUT"];
        
    [request setCompletionBlock:^{
        // Use when fetching text data
        
        NSInteger code = [request responseStatusCode];
        if (code != 200) {
            NSLog(@"update counter error");
        }
        
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Fetch avatar: %@", [error localizedDescription]);

    }];

    [request startAsynchronous];
}

#pragma mark - distance info
//+ (NSString *)postionInfoFrom: (CLLocation *)curPos toLoud:(NSDictionary *)loud
//{
//    NSString *loudcate = [loud objectForKey:@"loudcate"];
//    NSString *addrDesc = nil;
//    NSString *address = [[loud objectForKey:@"address"] isEqual:[NSNull null]] ? @"" : [loud objectForKey:@"address"];
//    if ([loudcate isEqualToString:@"sys"] || [loudcate isEqualToString:@"virtual"]){
//        addrDesc = address;
//    } else{
//        addrDesc = [NSString stringWithFormat:@"%@ %.0f米",
//                    address,
//                    [curPos distanceFromLocation:
//                     [[[CLLocation alloc] initWithLatitude:[[loud objectForKey:@"lat"] doubleValue] 
//                                             longitude:[[loud objectForKey:@"lon"] doubleValue]] autorelease]]
//                ];
//    }
//    
//    return addrDesc;
//    

//}

@end
