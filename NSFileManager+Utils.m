//
//  NSFileManager+Utils.m
//
//  Created by Jiva DeVoe on 12/21/11.
//  Copyright (c) 2011 Random Ideas, LLC. All rights reserved.
//

#import "NSFileManager+Utils.h"
#import "NSArray+Utils.h"

@implementation NSFileManager (Utils)

-(NSString *)cacheDirectoryPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

-(NSString *)documentsDirectoryPath;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

-(NSArray *)pathsToFilesInDirectoryAtPath:(NSString *)inPath withExtension:(NSString *)inExtension error:(NSError **)outError;
{
    NSDirectoryEnumerator *dirEnumerator = [self enumeratorAtPath:inPath];
    
    //NSDirectoryEnumerator *dirEnumerator = [self enumeratorAtURL:[NSURL fileURLWithPath:inPath] includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey,nil] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    NSMutableArray *ret = [NSMutableArray array];
    
    for(NSString *fileName in dirEnumerator)
    {
        NSString *fullPath = [inPath stringByAppendingPathComponent:fileName];
        
        if([[fullPath pathExtension] isEqualToString:inExtension])
            [ret addObject:fullPath];
    }
    
    return ret;
}

-(NSString *)pathInDocumentsOrBundleForResourceNamed:(NSString *)inResourceName withExtension:(NSString *)inExtension
{
    NSArray *items = [self pathsToFilesInDirectoryAtPath:[self documentsDirectoryPath] withExtension:inExtension error:nil];
    items = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) 
                                                {
                                                    NSString *item = (NSString *)evaluatedObject;
                                                    NSString *fileName = [[item lastPathComponent] stringByDeletingPathExtension];
                                                    return [fileName isEqualToString:inResourceName];
                                                }]];
    if([items count] != 0)
        return [items firstObject];
    return [[NSBundle mainBundle] pathForResource:inResourceName ofType:inExtension];
}

-(NSString *)pathInCachesOrBundleForResourceNamed:(NSString *)inResourceName withExtension:(NSString *)inExtension
{
    NSArray *items = [self pathsToFilesInDirectoryAtPath:[self cacheDirectoryPath] withExtension:inExtension error:nil];
    items = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) 
                                                {
                                                    NSString *item = (NSString *)evaluatedObject;
                                                    NSString *fileName = [[item lastPathComponent] stringByDeletingPathExtension];
                                                    return [fileName isEqualToString:inResourceName];
                                                }]];
    if([items count] != 0)
        return [items firstObject];
    return [[NSBundle mainBundle] pathForResource:inResourceName ofType:inExtension];
}

@end
