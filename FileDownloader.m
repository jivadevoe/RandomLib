//
//  FileDownloader.m
//
//  Created by Jiva DeVoe on 3/15/10.
//  Copyright 2010 Random Ideas,LLC. All rights reserved.
//

#import "FileDownloader.h"
#import "NSMutableURLRequest+Posts.h"

@interface FileDownloader ()
@property (nonatomic) int statusCode;
@property (nonatomic) float expectedContentLenght;
@end


@implementation FileDownloader
@synthesize statusCode;
@synthesize delegate;
@synthesize localName;
@synthesize connection;
@synthesize data;
@synthesize url;
@synthesize completionBlock;
@synthesize failureBlock;

+(id)downloadRequest:(NSMutableURLRequest *)inReq toLocalFileNamed:(NSString *)inLocalName completionBlock:(void (^)())inCompletionBlock failureBlock:(void (^)(NSError *))inFailureBlock;
{
    return [[self alloc] initWithRequest:inReq toLocalFileNamed:inLocalName forDelegate:nil completionBlock:inCompletionBlock failureBlock:inFailureBlock];
}

+(id)downloadUrl:(NSURL *)inUrl toLocalFileNamed:(NSString *)inLocalName completionBlock:(void (^)())inCompletionBlock failureBlock:(void (^)(NSError *))inFailureBlock;
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:inUrl];
    [req setTimeoutInterval:180];
    return [[self alloc] initWithRequest:req toLocalFileNamed:inLocalName forDelegate:nil completionBlock:inCompletionBlock failureBlock:inFailureBlock];
}

+(id)downloadUrl:(NSURL *)inUrl toLocalFileNamed:(NSString *)inLocalName forDelegate:(id<FileDownloaderDelegate>)inDelegate;
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:inUrl];
    [req setTimeoutInterval:180];
    return [[self alloc] initWithRequest:req toLocalFileNamed:inLocalName forDelegate:inDelegate];
}

-(id)initWithRequest:(NSMutableURLRequest *)inReq toLocalFileNamed:(NSString *)inLocalName forDelegate:(id<FileDownloaderDelegate>)inDelegate  completionBlock:(void (^)())inCompletionBlock failureBlock:(void (^)(NSError *))inFailureBlock;
{
    if((self = [super init]))
    {
        [self setUrl:[inReq URL]];
        [self setDelegate:inDelegate];
        [self setLocalName:inLocalName];
        [self setCompletionBlock:inCompletionBlock];
        [self setFailureBlock:inFailureBlock];
        
        [self setData:[NSMutableData data]];
        
        connection = [[NSURLConnection alloc] initWithRequest:inReq delegate:self startImmediately:NO];
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [connection start];
        statusCode = 0;
    }
    return self;
}

-(id)initWithRequest:(NSMutableURLRequest *)inReq toLocalFileNamed:(NSString *)inLocalName forDelegate:(id<FileDownloaderDelegate>)inDelegate;
{
    return [self initWithRequest:inReq toLocalFileNamed:inLocalName forDelegate:inDelegate completionBlock:nil failureBlock:nil];
}

-(id)initWithDownloadUrl:(NSURL *)inUrl toLocalFileNamed:(NSString *)inLocalName withUsername:(NSString *)inUserName password:(NSString *)inPassword forDelegate:(id<FileDownloaderDelegate>)inDelegate;
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:inUrl];
    [req addAuthenticationForUsername:inUserName password:inPassword];
    [req setTimeoutInterval:180];
    return [self initWithRequest:req toLocalFileNamed:inLocalName forDelegate:inDelegate];
}

-(void)cancel;
{
    [connection cancel];
}

-(void)dealloc;
{
    [self setData:nil];
    [self setConnection:nil];
    [self setLocalName:nil];
    [self setDelegate:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    self.statusCode = [resp statusCode];
    self.expectedContentLenght = response.expectedContentLength;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.statusCode >= 200 && self.statusCode < 300)
    {
        NSString *dirName = [[self localName] stringByDeletingLastPathComponent];
        if(![[NSFileManager defaultManager] fileExistsAtPath:dirName])
            [[NSFileManager defaultManager] createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];

        [data writeToURL:[NSURL fileURLWithPath:localName] atomically:YES];
        if(completionBlock)
            completionBlock();
        [delegate downloader:self downloadedFileToLocation:localName];        
    }
    else
    {
        NSError *error = nil;
        error = [NSError errorWithDomain:@"Error" code:statusCode userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Server side error: %ld", self.statusCode] forKey:NSLocalizedDescriptionKey]];
        
        if(failureBlock)
            failureBlock(error);
        
        if([delegate respondsToSelector:@selector(downloader:failedWithError:)])
            [delegate downloader:self failedWithError:error];        
    }
    [self setConnection:nil];
    [self setData:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setConnection:nil];
    [self setData:nil];
    if(failureBlock)
        failureBlock(error);
    if([delegate respondsToSelector:@selector(downloader:failedWithError:)])
        [delegate downloader:self failedWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData
{
    [data appendData:inData];
    
    float downloadedLenght = data.length;
    float downloadProgress = downloadedLenght / self.expectedContentLenght;
	
	[self.delegate downloader:self downloadProgressWasUpdatedTo:downloadProgress];
}

@end
