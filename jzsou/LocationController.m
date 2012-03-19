//
//  LocationController.m
//  WhoHelp
//
//  Created by cloud on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"
//#import "Utils.h"

static LocationController* sharedCLDelegate = nil;

@implementation LocationController
@synthesize locationManager, location, delegate, allow;

- (id)init
{
 	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return self;
}

- (void)dealloc
{
    [delegate release];
    [location release];
    [locationManager release];
    [super dealloc];
    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
		   fromLocation:(CLLocation*)oldLocation
{
    self.location = self.locationManager.location;
    self.allow = YES;
    //NSLog(@"%f,%f", self.location.coordinate.latitude, self.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager*)manager
	   didFailWithError:(NSError*)error
{
    [self.locationManager stopUpdatingLocation];
//    NSString *errorString;        
    // We handle CoreLocation-related errors here
    switch ([error code]) {
            // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
            // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
        case kCLErrorDenied:
//            errorString = @"需要获取你位置信息的许可，以便提供给你周边的求助信息。";
//            [Utils tellNotification:errorString];
            break;
        case kCLErrorLocationUnknown:
//            errorString = @"获取位置信息出现未知错误";
//            [Utils tellNotification:errorString];
            break;
            
        default:
            break;
    }
    self.allow = NO;
}

#pragma mark -
#pragma mark Singleton Object Methods

+ (LocationController*)sharedInstance {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            [[self alloc] init];
        }
    }
    return sharedCLDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end