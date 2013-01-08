//
//  UIViewController_msg.m
//  iPhone.hupoz
//
//  Created by tiantian on 5/10/11.
//  Copyright 2011 hupoz.com. All rights reserved.
//

#import "RoundedRect.h"
#import "UIViewController+msg.h"

@implementation UIViewController (msg)

- (BOOL) setMFMailFieldAsFirstResponder:(UIView *)view mfMailField:(NSString *)field
{
	for (UIView *subview in view.subviews) 
	{
        NSString *className = [NSString stringWithFormat:@"%@", [subview class]];

        if ([className isEqualToString:field])
        {
            //Found the sub view we need to set as first responder
            [subview becomeFirstResponder];
            return YES;
        }
		
        if ([subview.subviews count] > 0) 
		{
            if ([self setMFMailFieldAsFirstResponder:subview mfMailField:field]){
                //Field was found and made first responder in a subview
                return YES;
            }
        }
    }
	
    //field not found in this view.
    return NO;
}

- (void)fadeInMsgWithText:(NSString *)text rect:(CGRect)rect
{
	[self showMsgWithTextForm:1.5 middle:1 to:0.2 text:text rect:rect offSetY:0];
}

- (void)fadeInMsgWithText:(NSString *)text rect:(CGRect)rect offSetY:(NSInteger)offSetY
{
    [self showMsgWithTextForm:1.5 middle:1 to:0.2 text:text rect:rect offSetY:offSetY];
}

- (void)fadeOutMsgWithText:(NSString *)text rect:(CGRect)rect
{
	[self showMsgWithTextForm:0.2 middle:1 to:1.5 text:text rect:rect offSetY:0];
}


- (void)fadeOutMsgWithText:(NSString *)text rect:(CGRect)rect offSetY:(NSInteger)offSetY
{
    [self showMsgWithTextForm:0.2 middle:1 to:1.5 text:text rect:rect offSetY:offSetY];
}

- (void)showMsgWithTextForm:(float)fromPoint
                     middle:(float)middlePoint
                         to:(float)toPoint
                       text:(NSString *)text
                       rect:(CGRect)rect 
                    offSetY:(NSInteger)offSetY
{
    RoundedRect *rrect = [[RoundedRect alloc] initWithFrame:rect 
												  andRadius:8
													andText:text];
	rrect.center = self.view.center;
    rrect.frame = CGRectMake(rrect.frame.origin.x, rrect.frame.origin.y-offSetY, rrect.frame.size.width, rrect.frame.size.height);
	[self.view addSubview:rrect];
	[self.view bringSubviewToFront:rrect];
	rrect.transform = CGAffineTransformMakeScale(fromPoint,fromPoint);
	rrect.alpha = 0.9;
	[UIView animateWithDuration:0.2 animations:^(void){
		rrect.transform = CGAffineTransformMakeScale(middlePoint, middlePoint);
	}
					 completion:^(BOOL finished){
						 [UIView beginAnimations:nil context:nil];
						 [UIView setAnimationDelay:1];
						 [UIView setAnimationDuration:0.2];
						 rrect.alpha = 0;
                         rrect.transform = CGAffineTransformMakeScale(toPoint, toPoint);
						 [UIView commitAnimations];
					 }
	 ];
	[rrect release];
}
@end
