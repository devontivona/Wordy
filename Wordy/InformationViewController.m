//
//  InformationViewController.m
//  Wordy
//
//  Created by Devon Tivona on 1/23/12.
//  Copyright (c) 2012 University of Colorado, Boulder. All rights reserved.
//

#import "InformationViewController.h"

@implementation InformationViewController

- (IBAction)wordnikButtonTapped:(id)sender {
    NSString *urlString = @"http://www.wordnik.com";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    if(![[UIApplication sharedApplication] openURL:url]){
        NSLog(@"Failed to open URL");
    }   
}

@end
