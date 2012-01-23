//
//  RKDefinition.h
//  Wordy
//
//  Created by Devon Tivona on 9/23/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

@interface RKDefinition : NSObject

@property (nonatomic, retain) NSString* word;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* partOfSpeech;

@end

@implementation RKDefinition

@synthesize word;
@synthesize text;
@synthesize partOfSpeech;

@end
