//
//  NSData_Base64.h
//
//  Created by Jiva DeVoe on 12/16/08.
//  Copyright 2008 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Category that serializes and deserializes an NSData to/from a base64 encoded string.
*/
@interface NSData (Base64)
/// Convert a base64 encoded string to an NSData object.
+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
/// Convert self to a base64 encoded string.
- (NSString *)base64Encoding;
@end

