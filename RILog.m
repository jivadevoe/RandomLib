//
//  RILog.m
//
//  Created by Jiva DeVoe on 11/22/12.
//  Copyright (c) 2012 Random Ideas, LLC. All rights reserved.
//

#import "RILog.h"

@implementation RILog

+(id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    if((self = [super init]))
    {
        self.logLevel = RI_LOG_ERROR;
    }
    return self;
}

-(void)logMessageAtLevel:(RILogLevel)inLogLevel withFormat:(NSString *)format, ...;
{
    if(inLogLevel <= self.logLevel)
    {
        va_list ap;
        NSString *print;
        va_start(ap,format);
        print = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        
        NSLog(@"%@", print);
    }
}

-(BOOL)isLoggingEnabledOfType:(RILogLevel)type;
{
    return (type <= self.logLevel);
}

@end


