//
//  Definition.m
//  Wordy
//
//  Created by Devon Tivona on 9/27/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import "Definition.h"
#import "NSString+HTML.h"

@implementation Definition

@synthesize word;
@synthesize text;
@synthesize score;
@synthesize partOfSpeech;
@synthesize sourceDictionary;
@synthesize sequence;

- (NSString *)formatedSourceDictionary 
{
    NSString *formattedSourceDictionary;
    
    if ([self.sourceDictionary isEqualToString:@"ahd"] || [self.sourceDictionary isEqualToString:@"ahd-legacy"]) {
        formattedSourceDictionary = @"American Heritage Dictionary";
    } else if ([self.sourceDictionary isEqualToString:@"wiktionary"] || [self.sourceDictionary isEqualToString:@"wordnet"]) {
        formattedSourceDictionary = [[self.sourceDictionary stringByDecodingHTMLEntities] capitalizedString];
    } else if ([self.sourceDictionary isEqualToString:@"webster"]) {
        formattedSourceDictionary = @"Merriam-Webster Dictionary";
    } else if ([self.sourceDictionary isEqualToString:@"century"]) {
        formattedSourceDictionary = @"Century Dictionary";
    } else {
        formattedSourceDictionary = [[sourceDictionary stringByDecodingHTMLEntities] uppercaseString];
    }
    
    
    return formattedSourceDictionary;
}

@end
