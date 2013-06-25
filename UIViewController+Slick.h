//
//  UIViewController+Slick.h
//
//  Created by Jiva DeVoe on 7/22/10.
//  Copyright 2010-2012 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlickViewControllerDelegate <NSObject>

@optional
-(void)slickViewControllerDidDismiss:(UIViewController *)inController;
-(BOOL)slickViewControllerCanDismiss:(UIViewController *)inController;
-(void)slickViewControllerDidAppear:(UIViewController *)inController;
-(UIColor *)backgroundColorForSlickViewControllerPresentation:(UIViewController *)inController;
-(UIView *)backgroundViewForSlickViewControllerPresentation:(UIViewController *)inController;

@end

@interface UIViewController (Slick)

-(void)presentModalViewControllerWithSlickZoomAnimation:(UIViewController *)inModalViewController fromRect:(CGRect)inOriginRect withDelegate:(id<SlickViewControllerDelegate>)inDelegate;
-(void)dismissModalViewControllerWithSlickZoomAnimation:(BOOL)inAnimation;
-(void)dismissModalViewControllerWithSlickZoomAnimation:(BOOL)inAnimation toRect:(CGRect)dismissLoc;

@end
