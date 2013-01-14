//
//  GUIDCategory.mm
//
//  Created by Jiva DeVoe on 3/1/05.
//  Copyright 2005 Random Ideas, LLC. All rights reserved.
//

#import "GUIDCategory.h"

@implementation NSString (UUID)
+ (NSString*)stringWithUUID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString* str = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return str;
}

@end
