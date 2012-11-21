//
//  FileDownloader.h
//
//  Created by Jiva DeVoe on 3/15/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileDownloader;

/** The file downloader delegate specifies the methods that will be called by a file downloader when certain events occur as part of downloading files.
*/

@protocol FileDownloaderDelegate <NSObject>
/// This method is called when the file has downloaded successfully.
-(void)downloader:(FileDownloader *)inDownloader downloadedFileToLocation:(NSString *)inLocation;

@optional
/// This method is called in the event of an error.
-(void)downloader:(FileDownloader *)inDownloader failedWithError:(NSError *)inError;

/// This method is called when a data packet is received. Only available for protocols implementations that report the content length as part of the response.
-(void)downloader:(FileDownloader *)inDownloader downloadProgressWasUpdatedTo:(float)downloadProgress;

@end

/** The file downloader class makes downloading files from the Internet a breeze. You simply specify the location that you want to download the file to on the local file system and specify the URL from which to download the file and it will let you know when it's finished.
*/

@interface FileDownloader : NSObject
/// The URL to download from.
@property (nonatomic, retain) NSURL *url;
/// The data received.
@property (nonatomic, retain) NSMutableData * data;
/// The connection used to download.
@property (nonatomic, retain) NSURLConnection * connection;
/// The local file name the file is downloaded to.
@property (nonatomic, retain) NSString * localName;
/// Delegate. Instance of id<FileDownloaderDelegate> Use this OR blocks to know when the download completes.
@property (unsafe_unretained, nonatomic) id<FileDownloaderDelegate> delegate;
/// Completion block.  Called when the download completes successfully.
@property (copy, nonatomic) void (^completionBlock)();
/// Failure block. Called if the download fails.  Error contains why.
@property (copy, nonatomic) void (^failureBlock)(NSError *inError);

/// @name Initializers

/// Downloads using the request given to the local file given.
+(id)downloadRequest:(NSMutableURLRequest *)inReq toLocalFileNamed:(NSString *)inLocalName completionBlock:(void (^)())inCompletionBlock failureBlock:(void (^)(NSError *))inFailureBlock;

/// Downloads the resource from the given URL to the local file using blocks.
+(id)downloadUrl:(NSURL *)inUrl toLocalFileNamed:(NSString *)inLocalName completionBlock:(void (^)())inCompletionBlock failureBlock:(void (^)(NSError *))inFailureBlock;

/// Downloads resource from the given URL to the local file using a delegate.
+(id)downloadUrl:(NSURL *)inUrl toLocalFileNamed:(NSString *)inLocalName forDelegate:(id<FileDownloaderDelegate>)inDelegate;

-(id)initWithDownloadUrl:(NSURL *)inUrl toLocalFileNamed:(NSString *)inLocalName withUsername:(NSString *)inUserName password:(NSString *)inPassword forDelegate:(id<FileDownloaderDelegate>)inDelegate;
-(id)initWithRequest:(NSMutableURLRequest *)inReq toLocalFileNamed:(NSString *)inLocalName forDelegate:(id<FileDownloaderDelegate>)inDelegate;
-(id)initWithRequest:(NSMutableURLRequest *)inReq toLocalFileNamed:(NSString *)inLocalName forDelegate:(id<FileDownloaderDelegate>)inDelegate  completionBlock:(void (^)())inCompletionBlock failureBlock:(void (^)(NSError *))inFailureBlock;

@end
