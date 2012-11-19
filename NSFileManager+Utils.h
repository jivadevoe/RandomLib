//
//  NSFileManager+Utils.h
//
//  Created by Jiva DeVoe on 12/21/11.
//  Copyright (c) 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A collection of utilities related to specific filesystem paths. */

@interface NSFileManager (Utils)
/// The users documents directory.
-(NSString *)documentsDirectoryPath;
/// ~/Library/Caches
-(NSString *)cacheDirectoryPath;

/// This method will find all files with the given extension inside the directory at the given path. It is not recursive.
-(NSArray *)pathsToFilesInDirectoryAtPath:(NSString *)inPath withExtension:(NSString *)inExtension error:(NSError **)outError;
/// This method finds the file with the given name And extension anywhere inside the applications bundle or the users documents directory.  It favors the documents directory first. If the file is not found in the documents directory that falls back to the application bundle.
-(NSString *)pathInDocumentsOrBundleForResourceNamed:(NSString *)inResourceName withExtension:(NSString *)inExtension;

/// This method finds the file with the given name and extension anywhere inside the applications bundle or the users cache directory. It favors the cache directory. If the file is not found in the cache directory that falls back to the application bundle.
-(NSString *)pathInCachesOrBundleForResourceNamed:(NSString *)inResourceName withExtension:(NSString *)inExtension;
@end
