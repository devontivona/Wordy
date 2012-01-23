//
//  WordyAppDelegate.h
//  Wordy
//
//  Created by Devon Tivona on 9/22/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//
//  Wordy uses one third party library called RestKit. The library abstracts
//  REST calls into Objective C calls. This library makes it so that I neve
//  have to touch the HTTP calls to the server.
//
//  Wordy makes its API calls to a dictionary provider called Wordnik. This
//  API is what provides the search suggestions as well as the definitions.
//
//  All other code was either from myself, Apple, or RestKit documentation.
//

#import <UIKit/UIKit.h>

@class WordyViewController;

@interface WordyAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WordyViewController *viewController;

+ (UIButton *)texturedBackButtonWithTitle:(NSString*)title;
+ (UIButton *)texturedButtonWithTitle:(NSString*)title;
+ (UIButton *)texturedButtonWithImage:(UIImage*)image;
+ (UIButton *)texturedButton;

@end
