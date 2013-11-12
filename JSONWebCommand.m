//
//  JSONWebCommand.m
//
//  Created by Jiva DeVoe on 9/22/10.
//  Copyright (c) 2010 Random Ideas, LLC. All rights reserved.
//

#import "JSONWebCommand.h"
#import "NSMutableURLRequest+Posts.h"

@interface JSONWebCommand ()
@property (nonatomic) int statusCode;
@end


@implementation JSONWebCommand
@synthesize request;
@synthesize connection;
@synthesize data;
@synthesize resultDict;
@synthesize commandStatus;
@synthesize completionBlock;
@synthesize failureBlock;
@synthesize finallyBlock;
@synthesize showsNetworkActivity;
@synthesize threadedCompletionBlock;
@synthesize parseOpQueue;

-(id)initWithRequest:(NSMutableURLRequest *)inRequest;
{
    if((self = [super init]))
    {
        [self setRequest:inRequest];
        [self setShowsNetworkActivity:YES];
        
        parseOpQueue = [[NSOperationQueue alloc] init];
        [self.parseOpQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

-(id)initForPostToUrl:(NSString *)inUrlString withParams:(NSDictionary *)inParams
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inParams options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:inUrlString];
    NSMutableURLRequest *req = [NSMutableURLRequest postRequestForURL:url withJSON:json];

    return [self initWithRequest:req];
}

-(void)start;
{
    assert(!(completionBlock && threadedCompletionBlock)); // only one or the other should be set, never both!
        
    [connection cancel];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self setData:[NSMutableData data]];
    [connection start];
}

-(void)cancel;
{
    [connection cancel];
    [self setConnection:nil];

    if(finallyBlock)
        finallyBlock();

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    self.statusCode = [resp statusCode];
}

-(void)finishLoadingResult
{

    [self setConnection:nil];
    
    if(finallyBlock)
        finallyBlock();
    
}

-(void)handleSuccessfulResult:(NSDictionary *)inResult
{
    if(threadedCompletionBlock)
    {
        NSOperation *completionOp = [NSBlockOperation blockOperationWithBlock:^
                                     {
                                         self.threadedCompletionBlock(inResult);
                                         [self performSelectorOnMainThread:@selector(finishLoadingResult) withObject:nil waitUntilDone:YES];
                                     }];
        
        [[self parseOpQueue] addOperation:completionOp];
        
        return;
    }
    else if(completionBlock)
        completionBlock(inResult);

    [self finishLoadingResult];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.statusCode >= 200 && self.statusCode < 300)
    {
        NSOperation *parseOperation = [NSBlockOperation blockOperationWithBlock:^
        {
            NSError *error = nil;
            
            [self setResultDict:[NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error]];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 if(self.resultDict)
                 {
                     [self handleSuccessfulResult:self.resultDict];
                 }
                 else
                 {
                     if(failureBlock)
                         failureBlock(error);
                     [self finishLoadingResult];
                 }
             }];
        }];
        
        [[self parseOpQueue] addOperation:parseOperation];
        
        return;
    }
    else
    {
        NSError *error = nil;

        [self setResultDict:[NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error]];

        if(resultDict)
        {
            NSError *serverError = [NSError errorWithDomain:@"com.randomideas.shibui.network" code:self.statusCode userInfo:resultDict];
            if(failureBlock)
                failureBlock(serverError);
        }
        else
        {
            NSString *errorMsg = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
            NSError *serverError = [NSError errorWithDomain:@"com.randomideas.shibui.network" code:self.statusCode userInfo:dict];
            if(failureBlock)
                failureBlock(serverError);
        }
        [self finishLoadingResult];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(failureBlock)
        failureBlock(error);
    [self setConnection:nil];

    if(finallyBlock)
        finallyBlock();
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData
{
    [data appendData:inData];
}


@end
