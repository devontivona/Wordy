//
//  NSBundle+YAJL.h
//  YAJL
//
//  Created by Gabriel Handford on 7/23/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "YAJLParser.h"

@interface NSBundle (YAJL)

/*!
 Load JSON from bundle. 
 Throws an YAJLParserException on parse error.
 @param resource Resource name with extension, for example, file.json
 */
- (id)yajl_JSONFromResource:(NSString *)resource;

/*!
 Load JSON from bundle.
 @param resource Resource name with extension, for example, file.json
 @param options Parser options
 @param error Out error
 @result JSON value (NSArray, NSDictionary) or nil if errored
 */
- (id)yajl_JSONFromResource:(NSString *)resource options:(YAJLParserOptions)options error:(NSError **)error;

@end
