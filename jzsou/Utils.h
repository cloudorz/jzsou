//
//  Utils.h
//  WhoHelp
//
//  Created by cloud on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject

+ (void)helpNotificationForTitle: (NSString *)title forMessage: (NSString *)message;
+ (void)errorNotification:(NSString *)message;
+ (void)warningNotification:(NSString *)message;
+ (void)tellNotification:(NSString *)message;


+ (NSURL *)partURI: (NSString *)uri queryString: (NSString *) query;
+ (void)updateCounterFor:(NSString *)uri counter:(NSString *)counterName;

@end
