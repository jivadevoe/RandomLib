//
//  NSDate_Utils.m
//
//  Created by Jiva DeVoe on 8/3/08.
//  Copyright 2008 Random Ideas, LLC. All rights reserved.
//

#import "NSDate+Utils.h"



@implementation NSDate (Utils)

+(id)todayAtMidnight
{
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    return [cal dateFromComponents:components];
}

+(id)tomorrowAtMidnight
{
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    [components setDay:[components day] + 1];
    return [cal dateFromComponents:components];
}

+(id)dateWithISO8601Date:(NSString *)inDateString;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    NSArray *formatsToTry = [NSArray arrayWithObjects:@"yyyy-MM-dd'T'HH:mm:ssZ", 
                             @"yyyy-MM-dd'T'HH:mm:ss'Z'",
                             @"yyyy-MM-dd",
                             @"yyyy'-'MM'-'dd'T'HH':'mm':'ssz':'00", // this is a hack for '2011-04-13T12:00:00+0700' supposedly this is incorrect, but kinda works.
                             nil];
    
    NSDate *ret = nil;
    
    for(NSString *format in formatsToTry)
    {
        [dateFormatter setDateFormat:format];
        ret = [dateFormatter dateFromString:inDateString];
        if(ret)
            break;
    }
    
    return ret;
}

+(id)dateWithYYYYMMDD:(NSString *)inDateString
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter dateFromString:inDateString];
}

-(NSDate *)dateAtMidnight
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self];
    return [cal dateFromComponents:components];    
}

-(BOOL)sameDayAsDate:(NSDate *)inDate;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self];
    NSDateComponents *components2 = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:inDate];
    return ([components day] == [components2 day] && 
            [components month] == [components2 month] && 
            [components year] == [components2 year]);
}

-(NSString *)toYYYYMMDD;
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter stringFromDate:self];
}

-(NSString *)toYYYYMMDDhhmmss;
{
    NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
	return [formatter stringFromDate:self];
}

+(id)dateWithYYYYMMDDhhmmss:(NSString *)inDateString;
{
    NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"yyyyMMddHHmmssSSSS"];
	return [formatter dateFromString:inDateString];
}

// WARNING: These may need some things done WRT locale.  See: http://stackoverflow.com/questions/399527/parsing-unsupported-date-formats-in-via-cocoas-nsdate
-(NSString *)toISO8601;
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormatter stringFromDate:self];
}

-(NSDate *)dateByAddingDays:(NSInteger)inDays;
{
    static NSCalendar *cal;
    static dispatch_once_t once;
    dispatch_once(&once, ^
    {
        cal = [NSCalendar currentCalendar];
    });
    
    NSDateComponents *components = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self];
    [components setDay:[components day] + inDays];
    return [cal dateFromComponents:components];    
}

-(NSString *)niceDescriptionWithTime;
{
    NSString *dayComponent = nil;
    
    NSDate *today = [NSDate todayAtMidnight];
    NSDate *yesterday = [today dateByAddingDays:-1];
    NSDate *dateAtMidnight = [self dateAtMidnight];
    NSDate *oneWeekAgo = [today dateByAddingDays:-7];

    if([self sameDayAsDate:today])
        dayComponent = NSLocalizedString(@"Today", nil);
    else if([self sameDayAsDate:yesterday])
        dayComponent = NSLocalizedString(@"Yesterday", nil);
    else if([dateAtMidnight laterDate:oneWeekAgo] == dateAtMidnight)
    {
        NSDateFormatter *thisWeekFormat = [NSDateFormatter new];
        [thisWeekFormat setDateFormat:@"EEEE"];
        dayComponent = [thisWeekFormat stringFromDate:dateAtMidnight];
    }
    
    
    if(!dayComponent)
    {
        NSDateFormatter *everythingElseFormatter = [NSDateFormatter new];
        
        // FIXME: add european locale
        [everythingElseFormatter setDateFormat:@"MMM d, yyyy @ hh:mm"];
        return [everythingElseFormatter stringFromDate:self];        
    }

    NSDateFormatter *everythingElseFormatter = [NSDateFormatter new];
    
    [everythingElseFormatter setDateFormat:@"h:mm a"];
    
    NSString *ret = [NSString stringWithFormat:@"%@ @ %@", dayComponent, [everythingElseFormatter stringFromDate:self]];
    
    return ret;        
    
}

-(NSString *)niceDescription;
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [formatter dateFromString:[formatter stringFromDate:self]];
    
    NSDate *today = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    if([date isEqual:today])
        return NSLocalizedString(@"Today", nil);
    
    NSDate *yesterday = [today dateByAddingDays:-1];
    if([date isEqual:yesterday])
        return NSLocalizedString(@"Yesterday", nil);
    
    NSDate *oneWeekAgo = [today dateByAddingDays:-7];
    
    NSDate *tomorrow = [today dateByAddingDays:1];
    
    if(([date laterDate:oneWeekAgo] == date) && ([date laterDate:tomorrow] == tomorrow))
    {
        NSDateFormatter *thisWeekFormat = [NSDateFormatter new];
        [thisWeekFormat setDateFormat:@"EEEE"];
        return [thisWeekFormat stringFromDate:date];
    }
    
    NSDateFormatter *everythingElseFormatter = [NSDateFormatter new];
    
    // FIXME: add european locale
    [everythingElseFormatter setDateFormat:@"MMM d, yyyy"];
    return [everythingElseFormatter stringFromDate:date];    
}

-(BOOL)isLaterThanDate:(NSDate *)otherDate;
{
    return (([self laterDate:otherDate] == self) && ![self isEqualToDate:otherDate]);
}

-(BOOL)isEarlierThanDate:(NSDate *)otherDate;
{
    return (([self earlierDate:otherDate] == self) && ![self isEqualToDate:otherDate]);
}

@end
