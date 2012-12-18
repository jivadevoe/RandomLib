//
//  NSMutableArray_Utils.h
//
//  Created by Jiva DeVoe on 2/13/08.
//  Copyright 2008 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Utils)
-(void)unique;
-(void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
@end
