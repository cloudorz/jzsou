//
//  roundedRect.h
//  iphone.hupoz
//
//  Created by tiantian on 7/8/10.
//  Copyright 2011 hupoz.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoundedRect : UIView 
{
	CGFloat radius_;
}
- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius andText:(NSString *)text;
@end
