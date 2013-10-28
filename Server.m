//
//  Server.m
//  Lesson 5
//
//  Created by Jiva DeVoe on 9/24/13.
//  Copyright (c) 2013 Random Ideas. All rights reserved.
//

#import "Server.h"

#import <sys/socket.h>
#import <netinet/in.h>

#import <CFNetwork/CFNetwork.h>

@interface Server ()
@property (strong, nonatomic) NSFileHandle *listeningSocketHandle;
@property (nonatomic) CFSocketRef socket;
@property (nonatomic) CFMutableDictionaryRef incomingRequests;
@property (strong, nonatomic) NSMutableDictionary *actions;
@property (strong, nonatomic) NSMutableDictionary *actionsWithDocs;
@end


@implementation Server

-(id)init
{
	if((self = [super init]))
	{
        self.port = 8888;
        self.serveFilesFromDocumentsDir = NO;
        _incomingRequests = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
	return self;
}

- (void)start
{
	self.socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, 0, NULL, NULL);
	if (!self.socket)
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to create socket." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
		return;
	}
    
	int reuse = true;
	int fileDescriptor = CFSocketGetNative(self.socket);
	setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, (void *)&reuse, sizeof(int));
	
	struct sockaddr_in address;
	memset(&address, 0, sizeof(address));
	address.sin_len = sizeof(address);
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = htonl(INADDR_ANY);
	address.sin_port = htons(self.port);
	CFDataRef addressData = CFDataCreate(NULL, (const UInt8 *)&address, sizeof(address));
    CFAutorelease(addressData);
	
	CFSocketSetAddress(self.socket, addressData);
    
	self.listeningSocketHandle = [[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:YES];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingConnection:) name:NSFileHandleConnectionAcceptedNotification object:nil];
	[self.listeningSocketHandle acceptConnectionInBackgroundAndNotify];
    NSLog(@"Server listening.");
}

- (void)stop
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleConnectionAcceptedNotification object:nil];
    
	[self.listeningSocketHandle closeFile];
	self.listeningSocketHandle = nil;
	
    NSDictionary *incRequests = [(NSDictionary *)self.incomingRequests copy];
    
	for (NSFileHandle *incomingFileHandle in incRequests)
	{
        [self closeClientConnectionForFileHandle:incomingFileHandle];
	}
	
	if (self.socket)
	{
		CFSocketInvalidate(self.socket);
		CFRelease(self.socket);
		self.socket = nil;
	}
}

-(void)closeClientConnectionForFileHandle:(NSFileHandle *)fileHandle
{
    [fileHandle closeFile];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleDataAvailableNotification object:fileHandle];
    CFDictionaryRemoveValue(self.incomingRequests, (__bridge const void *)(fileHandle));
}


-(void)handleIncomingConnection:(NSNotification *)inNot
{
	NSFileHandle *incomingFileHandle = [inNot userInfo][NSFileHandleNotificationFileHandleItem];
    
    if(incomingFileHandle)
	{
        CFHTTPMessageRef msgRef = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);
		CFDictionaryAddValue(self.incomingRequests, (__bridge const void *)(incomingFileHandle), msgRef);
		CFAutorelease(msgRef);
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingData:) name:NSFileHandleDataAvailableNotification object:incomingFileHandle];
		
        [incomingFileHandle waitForDataInBackgroundAndNotify];
    }
    
	[self.listeningSocketHandle acceptConnectionInBackgroundAndNotify];
}

-(void)handleIncomingData:(NSNotification *)inNot
{
	NSFileHandle *incomingFileHandle = [inNot object];
	NSData *data = [incomingFileHandle availableData];
	
	if ([data length] == 0)
	{
		[self cancelReceiveForFileHandle:incomingFileHandle];
		return;
	}
    
	CFHTTPMessageRef incomingRequest = (CFHTTPMessageRef)CFDictionaryGetValue(self.incomingRequests, CFBridgingRetain(incomingFileHandle));
	if (!incomingRequest)
	{
		[self closeClientConnectionForFileHandle:incomingFileHandle];
		return;
	}
	
	if (!CFHTTPMessageAppendBytes(incomingRequest, [data bytes], [data length]))
	{
        [self closeClientConnectionForFileHandle:incomingFileHandle];
		return;
	}
    
	if(CFHTTPMessageIsHeaderComplete(incomingRequest))
	{
        [self respondToRequest:incomingRequest fromSocket:incomingFileHandle];

        [self cancelReceiveForFileHandle:incomingFileHandle];

		return;
	}
    
	[incomingFileHandle waitForDataInBackgroundAndNotify];
    
}

- (void)cancelReceiveForFileHandle:(NSFileHandle *)fileHandle
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleDataAvailableNotification object:fileHandle];
	CFDictionaryRemoveValue(self.incomingRequests, (__bridge const void *)(fileHandle));
}

-(NSDictionary *)dictionaryFromPostParamsString:(NSString *)stringData
{
    NSMutableDictionary *ret = [@{} mutableCopy];
    NSArray *parts = [stringData componentsSeparatedByString:@"&"];
    for(NSString *part in parts)
    {
        NSArray *components = [part componentsSeparatedByString:@"="];
        if([components count] < 2)
            continue;
        NSString *key = [components[0] stringByRemovingPercentEncoding];
        NSString *value = [components[1] stringByRemovingPercentEncoding];
        ret[key] = value;
    }
    return ret;
}

-(void)respondToRequest:(CFHTTPMessageRef)request fromSocket:(NSFileHandle *)fileHandle
{
    NSURL *requestURL = (__bridge NSURL *)(CFHTTPMessageCopyRequestURL(request));
    NSString *method = CFBridgingRelease(CFHTTPMessageCopyRequestMethod(request));
    if([method isEqualToString:@"GET"])
    {
        NSString *path = [requestURL path];
        if(self.actions[path])
        {
            NSDictionary *params = [self dictionaryFromPostParamsString:[requestURL query]];
            NSString *(^action)(NSString *path, NSString *method, NSDictionary *params) = self.actions[path];
            [self sendString:action(path, method, params) toSocket:fileHandle];
        }
        else if([path isEqualToString:@"/"] || [path isEqualToString:@"/index.html"])
        {
            NSMutableString *ret = [@"<html><body>\n" mutableCopy];
            [ret appendString:@"<dl>"];
            for(NSString *path in self.actionsWithDocs)
            {
                NSString *docString = self.actionsWithDocs[path];
                docString = [[[docString stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
                              stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
                             stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
                [ret appendFormat:@"<dt><a href=\"%@\">%@</a></dt><dd>%@</dd>", path, path, docString];
            }
            [ret appendString:@"</dl>"];
            [ret appendString:@"</body></html>"];
            [self sendString:ret toSocket:fileHandle];
        }
        else if([path isEqualToString:@"/index.json"])
        {
            NSString *ret = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.actionsWithDocs options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            [self sendString:ret toSocket:fileHandle];
        }
        else
        {
            if(!self.serveFilesFromDocumentsDir)
                [self sendNotFoundErrorToFileHandle:fileHandle];
            else
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *docsDir = paths[0];
                NSString *filePath = [docsDir stringByAppendingPathComponent:path];
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    [self sendFileAtPath:filePath toFileHandle:fileHandle];
                }
                else
                {
                    [self sendNotFoundErrorToFileHandle:fileHandle];
                }
            }
        }
        
    }
    else if([method isEqualToString:@"POST"])
    {
        NSData *data = (__bridge NSData *)(CFHTTPMessageCopyBody(request));
        NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *params = [self dictionaryFromPostParamsString:stringData];
        NSString *path = [requestURL path];
        if(self.actions[path])
        {
            NSString *(^action)(NSString *path, NSString *method, NSDictionary *params) = self.actions[path];
            [self sendString:action(path, method, params) toSocket:fileHandle];
        }
    }
}

-(void)sendString:(NSString *)str toSocket:(NSFileHandle *)fileHandle
{
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Connection", (CFStringRef)@"close");
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	CFHTTPMessageSetBody(response, (__bridge CFDataRef)data);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
    [fileHandle writeData:(__bridge NSData *)headerData];
    CFRelease(headerData);
    CFRelease(response);
    [self closeClientConnectionForFileHandle:fileHandle];
}

-(void)sendFileAtPath:(NSString *)filePath toFileHandle:(NSFileHandle *)fileHandle
{
    NSString *data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self sendString:data toSocket:fileHandle];
}

-(void)sendNotFoundErrorToFileHandle:(NSFileHandle *)fileHandle
{
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 404, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Connection", (CFStringRef)@"close");
    NSData *data = [@"404 not found" dataUsingEncoding:NSUTF8StringEncoding];
	CFHTTPMessageSetBody(response, (__bridge CFDataRef)data);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
    @try
    {
        [fileHandle writeData:(__bridge NSData *)headerData];
    }
    @catch (NSException *exception)
    {
        // you can ignore exceptions here, it just means the client reset the connection.
    }
    @finally
    {
        CFRelease(headerData);
        CFRelease(response);
        [self closeClientConnectionForFileHandle:fileHandle];

    }
}

-(void)addAction:(NSString *(^)(NSString *path, NSString *method, NSDictionary *args))action forPath:(NSString *)path withDocString:(NSString *)docString;
{
    if(!self.actions)
    {
        self.actions = [@{} mutableCopy];
        self.actionsWithDocs = [@{} mutableCopy];
    }
    self.actions[path] = action;
    self.actionsWithDocs[path] = docString;
}

-(void)dropActionForPath:(NSString *)path;
{
    [self.actions removeObjectForKey:path];
}

@end
