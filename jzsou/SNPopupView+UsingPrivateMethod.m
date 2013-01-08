/*
 * PopupView
 * SNPopupView+UsingPrivateMethod.m
 *
 * Copyright (c) Yuichi YOSHIDA, 11/10/10.
 * All rights reserved.
 * 
 * BSD License
 *
 * Redistribution and use in source and binary forms, with or without modification, are 
 * permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, this list of
 *  conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list
 *  of conditions and the following disclaimer in the documentation and/or other materia
 * ls provided with the distribution.
 * - Neither the name of the "Yuichi Yoshida" nor the names of its contributors may be u
 * sed to endorse or promote products derived from this software without specific prior 
 * written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY E
 * XPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES O
 * F MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SH
 * ALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENT
 * AL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROC
 * UREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS I
 * NTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRI
 * CT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF T
 * HE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SNPopupView+UsingPrivateMethod.h"

@interface SNPopupView(UsingPrivateMethod_Private)
- (void)createAndAttachTouchPeekView;
@end

@implementation SNPopupView(UsingPrivateMethod)

- (void)presentModalFromBarButtonItem:(UIBarButtonItem*)barButtonItem inView:(UIView*)inView {
	animatedWhenAppering = YES;
	[self createAndAttachTouchPeekView];
	[self showFromBarButtonItem:barButtonItem inView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)presentModalFromBarButtonItem:(UIBarButtonItem*)barButtonItem inView:(UIView*)inView animated:(BOOL)animated {
	animatedWhenAppering = animated;
	[self createAndAttachTouchPeekView];
	[self showFromBarButtonItem:barButtonItem inView:[[UIApplication sharedApplication] keyWindow] animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem*)barButtonItem inView:(UIView*)inView {
	[self showFromBarButtonItem:barButtonItem inView:inView animated:YES];
}

- (void)showFromBarButtonItem:(UIBarButtonItem*)barButtonItem inView:(UIView*)inView animated:(BOOL)animated {
	
	if(![barButtonItem respondsToSelector:@selector(view)]) {
		// error
		return;
	}
	
	UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
	UIView *targetSuperview = [targetView superview];
	
	BOOL isOnNavigationBar = YES;
	
	if ([targetSuperview isKindOfClass:[UINavigationBar class]]) {
		isOnNavigationBar = YES;
	}
	else if ([targetSuperview isKindOfClass:[UIToolbar class]]) {
		isOnNavigationBar = NO;
	}
	else {
		// error
		return;
	}
	
	CGRect rect = [targetSuperview convertRect:targetView.frame toView:inView];
	
	CGPoint p;
	p.x = rect.origin.x + (int)rect.size.width/2;
	
	if (isOnNavigationBar)
		p.y = rect.origin.y + rect.size.height + BAR_BUTTON_ITEM_UPPER_MARGIN;
	else
		p.y = rect.origin.y - BAR_BUTTON_ITEM_BOTTOM_MARGIN;
	
	[self showAtPoint:p inView:inView animated:animated];
}

- (void)showFromBarButtonItemCustomView:(UIButton*)buttonItem inView:(UIView*)inView animated:(BOOL)animated {
	

	UIView *targetSuperview = [buttonItem superview];

	CGRect rect = [targetSuperview convertRect:buttonItem.frame toView:inView];
	
	CGPoint p;
	p.x = rect.origin.x + (int)rect.size.width/2;
    p.y = rect.origin.y + rect.size.height + BAR_BUTTON_ITEM_UPPER_MARGIN - 15;

	
	[self showAtPoint:p inView:inView animated:animated];
}

@end
