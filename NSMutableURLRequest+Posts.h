//
//  NSMutableURLRequest+Posts.h
//
//  Created by Jiva DeVoe on 3/20/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Various utilities for working with NSMutableURLRequests.
*/

@interface NSMutableURLRequest (Posts)

/// Creates an NSMutableURLRequest with headers specifying that the body contains XML and with a body containing the passed XML.
+(id)postRequestForURL:(NSURL *)inURL withXml:(NSString *)inXml;
/// Creates an NSMutableURLRequest with headers specifying that the body contains JSON and with a body containing the passed JSON.
+(id)postRequestForURL:(NSURL *)inURL withJSON:(NSString *)inJSON;

+(id)postRequestForURL:(NSURL *)inURL params:(NSDictionary *)inDictionary;
+(id)putRequestForURL:(NSURL *)inURL params:(NSDictionary *)inDictionary;
+(id)requestWithURL:(NSURL *)inURL params:(NSDictionary *)inDictionary;

/// Adds headers to the request for basic authentication using the given parameters.
-(void)addAuthenticationForUsername:(NSString *)inUsername password:(NSString *)inPassword;

@end
