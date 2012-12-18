//
//  NSArray+Utils.m
//
//  Created by Jiva DeVoe on 12/21/11.
//  Copyright (c) 2011 Random Ideas, LLC. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)
-(id)firstObject
{
    return ([self count] > 0) ? [self objectAtIndex:0] : nil;
}

+(id)arrayWithUniqueObjectsFromArray:(NSMutableArray *)otherArray;
{
    NSMutableArray *ret = [NSMutableArray array];
    for(id item in otherArray)
    {
        if(![ret containsObject:item])
            [ret addObject:item];
    }
    return ret;
}
+(id)arrayWithCount:(int)count string:(NSString *)templateObject;
{
    NSMutableArray *ret = [NSMutableArray array];
    for(int n = 0; n < count; ++n)
    {
        [ret addObject:templateObject];
    }
    return ret;
}

-(NSArray *)twoDimensionalArrayWithDepth:(NSInteger)inDepth;
{
    NSMutableArray *ret = [NSMutableArray array];
    
    NSMutableArray *row = [NSMutableArray array];
    
    for(NSInteger n = 0; n < [self count]; ++n)
    {
        [row addObject:[self objectAtIndex:n]];
        
        if(((n+1) % inDepth) == 0)
        {
            [ret addObject:row];
            row = [NSMutableArray array];
        }
    }
    if([row count] > 0 && [row count] < inDepth)
    {
        for(NSUInteger n = [row count]; n < inDepth; ++n)
        {
            [row addObject:[NSNull null]];
        }
        [ret addObject:row];
    }
    
    return ret;
}

@end
