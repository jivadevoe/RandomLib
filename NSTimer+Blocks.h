//
//  NSTimer+Blocks.h
//
//  Created by Jiva DeVoe on 1/14/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Adds blocks to the NSTimer class.
*/
@interface NSTimer (Blocks)
/// Creates and schedules an NSTimer specified to fire after the given time interval and which will execute the given block.
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
/// Creates an NSTimer specified to fire after the given time interval and which will execute the given block.
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
@end
