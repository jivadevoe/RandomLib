//
//  NSArray+Utils.h
//
//  Created by Jiva DeVoe on 12/21/11.
//  Copyright (c) 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FOUtils)
/// C'mon.. everyone has one of these.  Mine works even if the array is zero length.  It returns nil.
-(id)firstObject;
@end
