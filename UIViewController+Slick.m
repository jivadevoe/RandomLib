//
//  UIViewController+Slick.m
//
//  Created by Jiva DeVoe on 7/22/10.
//  Copyright 2010-2012 Random Ideas, LLC. All rights reserved.
//

#import "UIViewController+Slick.h"
#import "UIView+Positioning.h"
#import <objc/runtime.h>

@interface UIViewController (Slick_Private)
-(void)slick_darkDismiss:(id)sender;
-(void)slick_show:(BOOL)animated;
-(void)slick_hide:(BOOL)animated;
-(void)slick_animateShow;
-(IBAction)slick_animateRemove;
-(void)slick_animateUp;
-(void)slick_animateUp:(void (^)(BOOL finished))completion;
-(void)slick_animateDown;
-(void)slick_animateDown:(void (^)(BOOL finished))completion;
@end


@implementation UIViewController (Slick)

-(void)slick_darkViewAnimationFinished:(NSString *)inAnimationId finished:(BOOL)inFinished userInfo:(void *)inContext;
{
    id<SlickViewControllerDelegate> delegate = objc_getAssociatedObject(self, @"com.random-ideas.DELEGATE");
    
    UIViewController *controller = objc_getAssociatedObject(self, @"com.random-ideas.FLIPPED_CONTROLLER");

    UIView *darkenView = objc_getAssociatedObject(self, @"com.random-ideas.DARKENED_VIEW");
    [darkenView removeFromSuperview];
    objc_setAssociatedObject(self, @"com.random-ideas.DARKENED_VIEW", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIView *containerView = objc_getAssociatedObject(self, @"com.random-ideas.CONTAINER_VIEW");
    [containerView removeFromSuperview];
    
    objc_setAssociatedObject(self, @"com.random-ideas.FLIPPED_CONTROLLER", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"com.random-ideas.CONTAINER_VIEW", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"com.random-ideas.ORIGIN_RECT", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"com.random-ideas.DELEGATE", nil, OBJC_ASSOCIATION_ASSIGN);
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    if([delegate respondsToSelector:@selector(slickViewControllerDidDismiss:)])
        [delegate slickViewControllerDidDismiss:controller];
    
    //[controller removeFromParentViewController];
    
}

-(void)slick_containerViewAnimationFinished:(NSString *)inAnimationId finished:(BOOL)inFinished userInfo:(void *)inContext;
{
    UIView *containerView = objc_getAssociatedObject(self, @"com.random-ideas.CONTAINER_VIEW");
    UIViewController *controller = objc_getAssociatedObject(self, @"com.random-ideas.FLIPPED_CONTROLLER");
    UIView *darkenView = objc_getAssociatedObject(self, @"com.random-ideas.DARKENED_VIEW");

    if([controller respondsToSelector:@selector(viewWillAppear:)])
        [controller viewWillAppear:NO];
    
    [darkenView addSubview:[controller view]];
    [containerView removeFromSuperview];
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    id<SlickViewControllerDelegate> delegate = objc_getAssociatedObject(self, @"com.random-ideas.DELEGATE");
    if([delegate respondsToSelector:@selector(slickViewControllerDidAppear:)])
        [delegate slickViewControllerDidAppear:controller];

    if([controller respondsToSelector:@selector(viewDidAppear:)])
        [controller viewDidAppear:NO];
}

-(void)slick_darkDismiss:(id)sender;
{
    id<SlickViewControllerDelegate> delegate = objc_getAssociatedObject(self, @"com.random-ideas.DELEGATE");
    UIViewController *controller = objc_getAssociatedObject(self, @"com.random-ideas.FLIPPED_CONTROLLER");
    
    if([sender isKindOfClass:[UIGestureRecognizer class]])
    {
        UIGestureRecognizer *rec = (UIGestureRecognizer *)sender;
        UIView *darkenView = objc_getAssociatedObject(self, @"com.random-ideas.DARKENED_VIEW");
        if(CGRectContainsPoint(controller.view.frame, [rec locationInView:darkenView]))
        {
            return;
        }
    }

    if([delegate respondsToSelector:@selector(slickViewControllerCanDismiss:)])
    {
        if([delegate slickViewControllerCanDismiss:controller])
            [self dismissModalViewControllerWithSlickZoomAnimation:YES toRect:CGRectMake(self.view.boundsCenter.x, self.view.boundsCenter.y, 1, 1)];
    }
    else
        [self dismissModalViewControllerWithSlickZoomAnimation:YES toRect:CGRectMake(self.view.boundsCenter.x, self.view.boundsCenter.y, 1, 1)];
}

-(void)dismissModalViewControllerWithSlickZoomAnimation:(BOOL)inAnimation;
{    
    NSValue *originRectValue = objc_getAssociatedObject(self, @"com.random-ideas.ORIGIN_RECT");
    [self dismissModalViewControllerWithSlickZoomAnimation:inAnimation toRect:[originRectValue CGRectValue]];
}

-(void)dismissModalViewControllerWithSlickZoomAnimation:(BOOL)inAnimation toRect:(CGRect)dismissLoc;
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIView *darkenView = objc_getAssociatedObject(self, @"com.random-ideas.DARKENED_VIEW");
    UIView *containerView = objc_getAssociatedObject(self, @"com.random-ideas.CONTAINER_VIEW");
    UIViewController *controller = objc_getAssociatedObject(self, @"com.random-ideas.FLIPPED_CONTROLLER");
    
    if([controller isEditing])
        [controller setEditing:NO];
    
    if([controller respondsToSelector:@selector(viewWillDisappear:)])
        [controller viewWillDisappear:NO];
    
    [[controller view] removeFromSuperview];
    [darkenView addSubview:containerView];
    containerView.frame = controller.view.frame;
    
    if([controller respondsToSelector:@selector(viewDidDisappear:)])
        [controller viewDidDisappear:NO];
    
    [UIView beginAnimations:@"REMOVINGDARKVIEW" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slick_darkViewAnimationFinished:finished:userInfo:)];
    [darkenView setAlpha:0.0];
    [containerView setFrame:dismissLoc];
    [UIView commitAnimations];
}

-(void)presentModalViewControllerWithSlickZoomAnimation:(UIViewController *)inModalViewController fromRect:(CGRect)inOriginRect withDelegate:(id<SlickViewControllerDelegate>)inDelegate;
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIView *parentView = [self view]; // [[UIApplication sharedApplication] keyWindow];

    CGRect parentFrame = [parentView bounds];
    parentFrame.size.width *= 2;
    parentFrame.size.height *= 2;
    
    UIView *darkenView = [[UIView alloc] initWithFrame:parentFrame];
    //darkenView.center = parentView.boundsCenter;
    UIGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slick_darkDismiss:)];
    rec.cancelsTouchesInView = NO;
    [darkenView addGestureRecognizer:rec];
    
    [darkenView setBackgroundColor:[UIColor blackColor]];
    [darkenView setAlpha:0.0];
    [darkenView setOpaque:NO];
    [parentView addSubview:darkenView];
    
    UIView *container = nil;
    if([inDelegate respondsToSelector:@selector(backgroundViewForSlickViewControllerPresentation:)])
    {
        container = [inDelegate backgroundViewForSlickViewControllerPresentation:self];
    }
    else
    {
        container = [[UIView alloc] initWithFrame:inOriginRect];
        [container setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [container setOpaque:YES];        
    }
    
    if([inDelegate respondsToSelector:@selector(backgroundColorForSlickViewControllerPresentation:)])
        [container setBackgroundColor:[inDelegate backgroundColorForSlickViewControllerPresentation:self]];
    else
        [container setBackgroundColor:inModalViewController.view.backgroundColor];
    
    [parentView addSubview:container];
    
    [UIView beginAnimations:@"ADDINGCONTAINER" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slick_containerViewAnimationFinished:finished:userInfo:)];
    CGPoint newCenter = [parentView boundsCenter];
    
    newCenter.x -= inModalViewController.view.frame.size.width/2;
    newCenter.y -= inModalViewController.view.frame.size.height/2;
    [container setFrame:CGRectMake(inModalViewController.view.frame.origin.x, inModalViewController.view.frame.origin.y, inModalViewController.view.frame.size.width, inModalViewController.view.frame.size.height)];

    //[darkenView setAlpha:0.3];
    [darkenView setAlpha:1.0];
    [darkenView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    [UIView commitAnimations];
    
    //[self addChildViewController:inModalViewController];
    
    objc_setAssociatedObject(self, @"com.random-ideas.FLIPPED_CONTROLLER", inModalViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"com.random-ideas.CONTAINER_VIEW", container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"com.random-ideas.ORIGIN_RECT", [NSValue valueWithCGRect:inOriginRect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @"com.random-ideas.DELEGATE", inDelegate, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @"com.random-ideas.DARKENED_VIEW", darkenView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)slick_show:(BOOL)animated
{
	if (animated)
		[self slick_animateShow];
	else
	{
		NSInteger startHeight = [[UIApplication sharedApplication] isStatusBarHidden]?0:20;
		CGSize windowSize = [[[self view] superview] bounds].size;
		[[self view] setFrame:CGRectMake(0, startHeight, windowSize.width, windowSize.height-startHeight)];
	}
}

- (void)slick_hide:(BOOL)animated
{
	if (animated)
		[self slick_animateRemove];
	else
	{
		CGSize windowSize = [[[self view] superview] bounds].size;
		[[self view] setFrame:CGRectMake(0, windowSize.height, windowSize.width, windowSize.height)];
	}
}

-(void)slick_animateShow
{
	CGSize windowSize = [[[self view] superview] bounds].size;
	
	[[self view] setFrame:CGRectMake(0, windowSize.height, windowSize.width, windowSize.height)];
	[self slick_animateUp:nil];
}

-(void)slick_animateRemove
{
	NSInteger startHeight = [[UIApplication sharedApplication] isStatusBarHidden]?0:20;
	CGSize windowSize = [[[self view] superview] bounds].size;
	
	[[self view] setFrame:CGRectMake(0, startHeight, windowSize.width, windowSize.height-startHeight)];
	[self slick_animateDown:nil];
}

-(void)slick_animateUp
{
	[self slick_animateUp:nil];
}

-(void)slick_animateUp:(void (^)(BOOL finished))completion
{
	NSInteger startHeight = [[UIApplication sharedApplication] isStatusBarHidden]?0:20;
	CGSize windowSize = [[[self view] superview] bounds].size;
	
	[UIView animateWithDuration:.3 delay:0 options:UIViewAnimationCurveEaseIn animations:^{[[self view] setFrame:CGRectMake(0, startHeight, windowSize.width, windowSize.height-startHeight)];} completion:completion];
}

-(void)slick_animateDown
{
	[self slick_animateDown:nil];
}

-(void)slick_animateDown:(void (^)(BOOL finished))completion
{
	CGSize windowSize = [[[self view] superview] bounds].size;
	
	[UIView animateWithDuration:.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{[[self view] setFrame:CGRectMake(0, windowSize.height, windowSize.width, windowSize.height)];} completion:completion];
}

@end
