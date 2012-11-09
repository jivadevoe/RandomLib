//
//  NSMutableURLRequest+Posts.m
//
//  Created by Jiva DeVoe on 3/20/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import "NSMutableURLRequest+Posts.h"
#import "NSData+Base64.h"

@implementation NSMutableURLRequest (Posts)

+(id)postRequestForURL:(NSURL *)inURL withXml:(NSString *)inXml;
{
    id req = [self requestWithURL:inURL];
        
    NSString *msgLength = [NSString stringWithFormat:@"%d", [inXml length]];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[inXml dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}

+(id)postRequestForURL:(NSURL *)inURL withJSON:(NSString *)inJSON;
{
    id req = [self requestWithURL:inURL];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [inJSON length]];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[inJSON dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}

+(id)requestWithURL:(NSURL *)inURL params:(NSDictionary *)inDictionary;
{
    id req = [self requestWithURL:inURL];
    
    NSMutableString *paramString = [NSMutableString string];
    
    for(NSString *key in [inDictionary allKeys])
    {
        [paramString appendString:[NSString stringWithFormat:@"%@=%@&", key, [inDictionary objectForKey:key]]];
    }
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [paramString length]];
    [req addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}

+(id)postRequestForURL:(NSURL *)inURL params:(NSDictionary *)inDictionary;
{
    id req = [self requestWithURL:inURL params:inDictionary];
    [req setHTTPMethod:@"POST"];
    return req;

//    id req = [self requestWithURL:inURL];
//    
//    NSMutableString *paramString = [NSMutableString string];
//    
//    for(NSString *key in [inDictionary allKeys])
//    {
//        [paramString appendString:[NSString stringWithFormat:@"%@=%@&", key, [inDictionary objectForKey:key]]];
//    }
//    
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [paramString length]];
//    [req addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [req setHTTPMethod:@"POST"];
//    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [req setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
//    return req;
}

+(id)putRequestForURL:(NSURL *)inURL params:(NSDictionary *)inDictionary;
{
    id req = [self requestWithURL:inURL params:inDictionary];
    [req setHTTPMethod:@"PUT"];
    return req;
}

-(void)addAuthenticationForUsername:(NSString *)inUsername password:(NSString *)inPassword
{
    NSString *tmp = [NSString stringWithFormat:@"%@:%@", inUsername, inPassword];
    NSString *data = [[NSData dataWithBytes:[tmp UTF8String] length:[tmp length]] base64Encoding];
    [self addValue:[NSString stringWithFormat:@"Basic %@", data] forHTTPHeaderField:@"Authorization"];
}


@end
