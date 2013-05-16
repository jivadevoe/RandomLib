//
//  RILog.h
//
//  Created by Jiva DeVoe on 11/22/12.
//  Copyright (c) 2012 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, RILogLevel)
{
    RI_LOG_NONE = 0,
    RI_LOG_ERROR = 100,
    RI_LOG_INFO = 200,
    RI_LOG_DEBUG = 300
};

@interface RILog : NSObject
@property RILogLevel logLevel;
+(id)sharedInstance;
-(void)logMessageAtLevel:(RILogLevel)inLogLevel withFormat:(NSString *)format, ...;
-(BOOL)isLoggingEnabledOfType:(RILogLevel)type;
@end

#define RILOG(logLevel, ...) [[RILog sharedInstance] logMessageAtLevel:logLevel withFormat:__VA_ARGS__];
#define INFOLOG(...) [[RILog sharedInstance] logMessageAtLevel:RI_LOG_NONE withFormat:__VA_ARGS__];
#define DEBUGLOG(...) [[RILog sharedInstance] logMessageAtLevel:RI_LOG_DEBUG withFormat:__VA_ARGS__];
#define ERRORLOG(...) [[RILog sharedInstance] logMessageAtLevel:RI_LOG_ERROR withFormat:__VA_ARGS__];
