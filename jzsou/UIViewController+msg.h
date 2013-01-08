//
//  UIViewController_msg.m
//  iPhone.hupoz
//
//  Created by tiantian on 5/10/11.
//  Copyright 2011 hupoz.com. All rights reserved.
//


/*
 * UIViewController's category
 */

@interface UIViewController (msg)
- (BOOL) setMFMailFieldAsFirstResponder:(UIView *)view mfMailField:(NSString *)field;
- (void)showMsgWithTextForm:(float)fromPoint
                     middle:(float)middlePoint
                         to:(float)toPoint
                       text:(NSString *)text
                       rect:(CGRect)rect 
                    offSetY:(NSInteger)offSetY;

- (void)fadeInMsgWithText:(NSString *)text rect:(CGRect)rect;
- (void)fadeInMsgWithText:(NSString *)text rect:(CGRect)rect offSetY:(NSInteger)offSetY;
- (void)fadeOutMsgWithText:(NSString *)text rect:(CGRect)rect;
- (void)fadeOutMsgWithText:(NSString *)text rect:(CGRect)rect offSetY:(NSInteger)offSetY;
@end


//a category for NSObject to perform block after a delay
@interface NSObject(PerformBlockAfterDelay)
- (void)performBlock:(void (^)(void))block 
          afterDelay:(NSTimeInterval)theDelay;
- (void)fireBlockAfterDelay:(void (^)(void))block;
@end


@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block 
          afterDelay:(NSTimeInterval)theDelay 
{
    block = [[block copy] autorelease];
    [self performSelector:@selector(fireBlockAfterDelay:) 
               withObject:block 
               afterDelay:theDelay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end
