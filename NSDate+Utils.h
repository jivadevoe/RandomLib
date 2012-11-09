//
//  NSDate_Utils.h
//
//  Created by Jiva DeVoe on 8/3/08.
//  Copyright 2008 Random Ideas, LLC. All rights reserved.
//

#if TARGET_OS_IPHONE // iPhone SDK
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

/** Various utilities for NSDate. Some of these are fairly specific to some needs I had.  Many could be improved.  Your mileage may vary.  Offer void where prohibited by law.
*/

@interface NSDate (Utils)
/// Returns a date set to midnight today.
+(id)todayAtMidnight;
/// returns a date set to midnight tomorrow.
+(id)tomorrowAtMidnight;
/// Converts a string of the form YYYYMMDD to an NSDate
+(id)dateWithYYYYMMDD:(NSString *)inDateString;
/// Converts a string of the form YYYYMMDDhhmmss to an NSDate.
+(id)dateWithYYYYMMDDhhmmss:(NSString *)inDateString;
/// Converts a string formatted using in compliance with ISO8601 to an NSDate
+(id)dateWithISO8601Date:(NSString *)inDateString;

/// Returns a new NSDate object with the same date as the receiver, but with the time set to midnight.
-(NSDate *)dateAtMidnight;

/** Returns a string designed to be used for user interaction.  

    If the receiver is the same date as today, it will return "Today"
    If the receiver is yesterday, it'll return "Yesterday"
    If the receiver is within 1 week prior to today, it'll return the day of the week (Monday, Tuesday, etc)
    Otherwise, it returns the date printed according to the locale settings.

*/
-(NSString *)niceDescription;

/// Returns the same thing as -niceDescription but includes the time.
-(NSString *)niceDescriptionWithTime;

/// Converts the receiver to a string of the form YYYYMMDD
-(NSString *)toYYYYMMDD;
/// Converts the receiver to a string of the form YYYYMMDDhhmmss
-(NSString *)toYYYYMMDDhhmmss;
/// Converts the receiver to a string in compliance with ISO8601
-(NSString *)toISO8601;

/// Returns an NSDate which is inDays (+/-) days different from sender. 
-(NSDate *)dateByAddingDays:(NSInteger)inDays;

/// Returns YES if inDate is the same date as the receiver.
-(BOOL)sameDayAsDate:(NSDate *)inDate;
/// Returns YES if otherDate is later in time than the receiver.
-(BOOL)isLaterThanDate:(NSDate *)otherDate;
/// Returns YES if otherDate is earlier in time than the receiver.
-(BOOL)isEarlierThanDate:(NSDate *)otherDate;
@end
