//
//  CustomBarButtonItem.m
//  WhoHelp
//
//  Created by Dai Cloud on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomBarButtonItem.h"

@implementation CustomBarButtonItem

-(id)initBackBarButtonItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    self = [super init];
    if (self != nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 51, 30);
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];

        [button setTitle:[NSString stringWithFormat:@"  %@", title] 
                forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] 
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"backBtnD.png"] 
                          forState:UIControlStateHighlighted];
        [button addTarget:target 
                   action:action 
         forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = button;
    }
    
    return self;
}

-(id)initConfirmBarButtonItemWithTarget:(id)target action:(SEL)action title:(NSString *)title
{
    self = [super init];
    if (self != nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 51, 30);
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [button setTitle:title 
                forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"confirmBtn.png"] 
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"confirmBtnD.png"] 
                          forState:UIControlStateHighlighted];
        [button addTarget:target 
                   action:action 
         forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = button;
    }
    
    return self; 
}

@end
