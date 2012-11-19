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
@end
