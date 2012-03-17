//
//  CustomBarButtonItem.h
//  WhoHelp
//
//  Created by Dai Cloud on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBarButtonItem : UIBarButtonItem

-(id)initBackBarButtonItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;
-(id)initConfirmBarButtonItemWithTarget:(id)target action:(SEL)action title:(NSString *)title;

@end
