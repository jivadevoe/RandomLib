//
//  UIView_Positioning.m
//  Mindfulness
//
//  Created by Jiva DeVoe on 8/4/09.
//  Copyright 2009 Random Ideas, LLC. All rights reserved.
//

#import "UIView+Positioning.h"


@implementation UIView (Positioning)

@dynamic x;
@dynamic y;
@dynamic top;
@dynamic left;
@dynamic right;
@dynamic width;
@dynamic height;
@dynamic bottom;
@dynamic topLeft;
@dynamic topRight;
@dynamic bottomLeft;
@dynamic bottomRight;

@dynamic boundsCenter;
@dynamic topLeftBounds;
@dynamic topRightBounds;
@dynamic bottomLeftBounds;
@dynamic bottomRightBounds;

-(CGPoint)boundsCenter;
{
    CGPoint ret = [self bounds].origin;
    ret.x += [self bounds].size.width/2;
    ret.y += [self bounds].size.height/2;
    return ret;
}

- (CGPoint) topLeftBounds
{
    CGPoint topLeft = [self bounds].origin;
    return topLeft;
}
- (CGPoint) bottomLeftBounds
{
    CGPoint bottomLeft = [self bounds].origin;
    bottomLeft.y += [self bounds].size.height;
    return bottomLeft;
}
- (CGPoint) topRightBounds
{
    CGPoint topRight = [self bounds].origin;
    topRight.x += [self bounds].size.width;
    return topRight;
}

- (CGPoint) bottomRightBounds 
{
    CGPoint bottomRight = [self bounds].origin;
    bottomRight.x += [self bounds].size.width;
    bottomRight.y += [self bounds].size.height;
    return bottomRight;
}


- (CGPoint) topLeft 
{
    CGPoint topLeft = [self frame].origin;
    return topLeft;
}
- (CGPoint) bottomLeft 
{
    CGPoint bottomLeft = [self frame].origin;
    bottomLeft.y += [self frame].size.height;
    return bottomLeft;
}
- (CGPoint) topRight 
{
    CGPoint topRight = [self frame].origin;
    topRight.x += [self frame].size.width;
    return topRight;
}

- (CGPoint) bottomRight 
{
    CGPoint bottomRight = [self frame].origin;
    bottomRight.x += [self frame].size.width;
    bottomRight.y += [self frame].size.height;
    return bottomRight;
}

//+(void)beginRemoveViewAnimationForView:(UIView *)inView
//{
//[self beginAnimations:@"REMOVINGSUBVIEW" context:inView];
//[self setAnimationDelegate:self];
//[self setAnimationDidStopSelector:@selector(removalAnimationFinished:finished:userInfo:)];
//}
//
//+(void)removalAnimationFinished:(NSString *)inAnimationId finished:(BOOL)inFinished userInfo:(void *)inContext;
//{
//UIView *view = (UIView *)inContext;
//[view removeFromSuperview];
//}
-(void)evenlyDistributeHorizontallySubviewsInArray:(NSArray *)inSubviews;
{
    CGFloat myWidth = self.bounds.size.width;
    CGFloat itemWidth = myWidth/[inSubviews count];

    for(NSInteger n = 0; n < [inSubviews count]; ++n)
    {
        id subview = [inSubviews objectAtIndex:n];
        if([subview isKindOfClass:[UIView class]])
        {
            CGFloat location = (itemWidth * n)+(itemWidth/2);
            [subview setX:location];            
        }
    }
}

-(void)spreadSubviewsIntoGrid:(NSArray *)inGridOfSubviews; // columns:(NSInteger)inColumns; // rows:(NSInteger)rows;
{
    NSUInteger rows = [inGridOfSubviews count];
    CGFloat myHeight = self.bounds.size.height;
    CGFloat itemHeight = myHeight/rows;
    
    for(NSUInteger n = 0; n < [inGridOfSubviews count]; ++n)
    {
        NSArray *row = [inGridOfSubviews objectAtIndex:n];
        
        CGFloat location = (itemHeight * n)+(itemHeight/2);
        
        for(id subview in row)
        {
            if([subview isKindOfClass:[UIView class]])
                [subview setY:location];
        }
        [self evenlyDistributeHorizontallySubviewsInArray:row];
    }
}

-(CGFloat)y;
{
    return self.center.y;
}

-(CGFloat)x;
{
    return self.center.x;
}

-(void)setY:(CGFloat)inY;
{
    [self setCenter:CGPointMake(self.center.x, inY)];
}

-(void)setX:(CGFloat)inX;
{
    [self setCenter:CGPointMake(inX, self.center.y)];
}

-(CGFloat)top;
{
    return self.frame.origin.y;
}

-(CGFloat)left;
{
    return self.frame.origin.x;
}

-(void)setTop:(CGFloat)inY;
{
    CGRect frame = [self frame];
    frame.origin.y = inY;
    [self setFrame:frame];
}

-(void)setLeft:(CGFloat)inX;
{
    CGRect frame = [self frame];
    frame.origin.x = inX;
    [self setFrame:frame];
}

-(CGFloat)right;
{
    return self.left + self.width;
}

-(void)setRight:(CGFloat)inRight;
{
    self.left = inRight - self.width;
}

-(CGFloat)width;
{
    return self.frame.size.width;
}

-(CGFloat)height;
{
    return self.frame.size.height;
}

-(CGFloat)bottom
{
    return self.top + self.height;
}

-(void)setBottom:(CGFloat)inBottom;
{
    self.top = inBottom - self.height;
}

-(void)setWidth:(CGFloat)inWidth;
{
    CGRect frame = [self frame];
    frame.size.width = inWidth;
    [self setFrame:frame];
}

-(void)setHeight:(CGFloat)inHeight;
{
    CGRect frame = [self frame];
    frame.size.height = inHeight;
    [self setFrame:frame];    
}

-(CGRect)frameInRelationToView:(UIView *)inView;
{
    return [self convertRect:[self frame] toView:inView];
}
                                

@end
