//
//  UIView_Positioning.h
//
//  Created by Jiva DeVoe on 8/4/09.
//  Copyright 2009 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// These category methods are probably pretty dangerous.  Their purpose is to allow you to quickly and easily position your view within another view.

@interface UIView (Positioning)

// WARNING: Remember these are all acting on the FRAME, which is the coordinates within the parent view!

/// @name Operations on the CENTER property of the view

/// Sets the x coordinate of center.
@property CGFloat x;
/// Sets the y coordinate of center.
@property CGFloat y;

/// @name Operations on the edges of the view.

/// Sets the top edge of the view
@property CGFloat top;
/// Sets the left edge of the view
@property CGFloat left;

/// Sets the width of the view
@property CGFloat width;
/// Sets the height of the view
@property CGFloat height;

// @name set/get right/bottom sides of view - will move origin to position right/bottom at location

/// Sets the right edge of the view to the given location by moving origin appropriately. Does not change width.
@property CGFloat right;
/// Sets the bottom edge of the view to the given location by moving origin appropriately. Does not change height.
@property CGFloat bottom;

/// Gets the center of the view's bounds.
@property (readonly) CGPoint boundsCenter;

/// Gets the top left corner of the view's frame.
@property (readonly) CGPoint topLeft;
/// Gets the top right corner of the view's frame.
@property (readonly) CGPoint topRight;
/// Gets the bottom left corner of the view's frame.
@property (readonly) CGPoint bottomLeft;
/// Gets the bottom right corner of the view's frame.
@property (readonly) CGPoint bottomRight;

/// Gets the top left corner of the view's bounds.
@property (readonly) CGPoint topLeftBounds;
/// Gets the top right corner of the view's bounds.
@property (readonly) CGPoint topRightBounds;
/// Gets the bottom left corner of the view's bounds.
@property (readonly) CGPoint bottomLeftBounds;
/// Gets the bottom right corner of the view's bounds.
@property (readonly) CGPoint bottomRightBounds;

//+(void)beginRemoveViewAnimationForView:(UIView *)inView;

/// Given an array of subviews, adjust their frames to evenly distribute them within the parent view.
-(void)evenlyDistributeHorizontallySubviewsInArray:(NSArray *)inSubviews;
/// Given a two dimensional array of arrays of subviews, distribute them evenly within the receiver. All rows must have all the same number of elements. If you have a row with fewer elements, fill with NSNull to pad the row.
-(void)spreadSubviewsIntoGrid:(NSArray *)inGridOfSubviews;

/// Returns the frame of the receiver within the coordinate system of the given view.
-(CGRect)frameInRelationToView:(UIView *)inView;

@end
