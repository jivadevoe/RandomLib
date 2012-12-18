//
//  NSMutableArray_Utils.m
//
//  Created by Jiva DeVoe on 2/13/08.
//  Copyright 2008 Random Ideas, LLC. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#import "NSMutableArray+Utils.h"
#import "NSArray+Utils.h"

@implementation NSMutableArray (Utils)

-(void)unique;
{
    NSMutableArray *uniqueContents = [NSArray arrayWithUniqueObjectsFromArray:self];
    [self removeAllObjects];
    [self addObjectsFromArray:uniqueContents];
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from)
    {
        id obj = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];
        if (to >=[self count])
        {
            [self addObject:obj];
        }
        else
        {
            [self insertObject:obj atIndex:to];
        }
    }
}
@end
