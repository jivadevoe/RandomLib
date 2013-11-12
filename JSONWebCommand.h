//
//  JSONWebCommand.h
//
//  Created by Jiva DeVoe on 9/22/10.
//  Copyright (c) 2010 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONWebCommand : NSObject

@property (strong, nonatomic)  NSOperationQueue *parseOpQueue;
@property (assign, nonatomic)  BOOL showsNetworkActivity;
@property (copy, nonatomic) void (^completionBlock)(id result);
@property (copy, nonatomic) void (^threadedCompletionBlock)(id result);

@property (copy, nonatomic) void (^failureBlock)(NSError *error);
@property (copy, nonatomic) void (^finallyBlock)(void);

@property (strong, nonatomic) NSString * commandStatus;
@property (strong, nonatomic) NSDictionary * resultDict;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;

-(id)initWithRequest:(NSURLRequest *)inRequest;
-(id)initForPostToUrl:(NSString *)inUrlString withParams:(NSDictionary *)inParams;

-(void)start;
-(void)cancel;

@end
