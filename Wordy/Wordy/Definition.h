//
//  Definition.h
//  Wordy
//
//  Created by Devon Tivona on 9/23/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//
//  This object is used by RestKit to map definitions retrieved from 
//  Wordnick (as JSON) to an Objective C object.
//

#import <Foundation/Foundation.h>

@interface Definition : NSObject

@property (nonatomic, retain) NSString* word;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSNumber* score;
@property (nonatomic, retain) NSString* partOfSpeech;
@property (nonatomic, retain) NSString* sourceDictionary;
@property (nonatomic, retain) NSNumber* sequence;

@end

