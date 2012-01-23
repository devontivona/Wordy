//
//  Word.h
//  Wordy
//
//  Created by Devon Tivona on 9/27/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//
//  This object is used by RestKit to map word suggestions retrieved from 
//  Wordnick (as JSON) to an Objective C object.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject
@property (nonatomic, retain) NSNumber* count;
@property (nonatomic, retain) NSString* wordString;

@end