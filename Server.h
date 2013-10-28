//
//  Server.h
//  Lesson 5
//
//  Created by Jiva DeVoe on 9/24/13.
//  Copyright (c) 2013 Random Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject
/// If YES, if no action has been configured for the path, the server will search the application's Documents directory for a file to fulfill the request. Default: NO
@property (nonatomic) BOOL serveFilesFromDocumentsDir;
/// The port to listen on.
@property (nonatomic) short port;
/// The action should return an exact string of what you want the server to respond with.
-(void)addAction:(NSString *(^)(NSString *path, NSString *method, NSDictionary *args))action forPath:(NSString *)path withDocString:(NSString *)docString;
/// Remove the given action
-(void)dropActionForPath:(NSString *)path;
/// Start listening for connections.
- (void)start;
/// Stop listening for connections
- (void)stop;
@end
