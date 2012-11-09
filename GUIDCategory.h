//
//  GUIDCategory.h
//
//  Created by Jiva DeVoe on 3/1/05.
//  Copyright 2005 Random Ideas, LLC. All rights reserved.
//

#if TARGET_OS_IPHONE // iPhone SDK
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

/** For whatever reason, I often have need to generate guids.  I use them as unique identifiers for database rows, object identification, session keys, you name it. This category makes it quick and easy to generate a guid and put it in a string.
*/

@interface NSString (UUID)
/// Create a string containing a unique identifier. Really just a thin wrapper around CFUUIDCreateString.
+ (NSString*)stringWithUUID;
@end
