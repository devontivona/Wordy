//
//  WordyAppDelegate.m
//  Wordy
//
//  Created by Devon Tivona on 9/22/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import "WordyAppDelegate.h"
#import "WordyViewController.h"
#import <RestKit/RestKit.h>
#import "Definition.h"
#import "Word.h"
#import "WordOfTheDay.h"
#import "RelatedWords.h"

@implementation WordyAppDelegate

@synthesize window = _window;
@synthesize viewController= _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Initialize RestKit and declare the base URL
    NSString* baseUrl = @"http://api.wordnik.com/v4";
    RKClient* client = [RKClient clientWithBaseURL:baseUrl];    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:baseUrl];
    
    NSURL *apiKeyUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WordnikApiKey" ofType:@"txt"]]; 
    
    NSString *apiKey = [NSString stringWithContentsOfURL:apiKeyUrl encoding:NSUTF8StringEncoding error:NULL];
    
    NSAssert(apiKey != nil && ![apiKey isEqualToString:@""], @"Place your worknik API key in a txt file in the root folder with the name WordnikApiKey.txt");
    
    [client setValue:apiKey forHTTPHeaderField:@"api_key"];
    
    // Provide the mapping to JSON to Objective C for the definition class.
    RKObjectMapping *definitionMapping = [RKObjectMapping mappingForClass:[Definition class]];
    [definitionMapping mapKeyPath:@"word" toAttribute:@"word"];
    [definitionMapping mapKeyPath:@"text" toAttribute:@"text"];
    [definitionMapping mapKeyPath:@"score" toAttribute:@"score"];
    [definitionMapping mapKeyPath:@"partOfSpeech" toAttribute:@"partOfSpeech"];
    [definitionMapping mapKeyPath:@"sourceDictionary" toAttribute:@"sourceDictionary"];
    [definitionMapping mapKeyPath:@"sequence" toAttribute:@"sequence"];
    
    // Provide the mapping to JSON to Objective C for the word suggestion class.
    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
    [wordMapping mapKeyPath:@"count" toAttribute:@"count"];
    [wordMapping mapKeyPath:@"wordstring" toAttribute:@"wordString"];
    
    // Provide the mapping to JSON to Objective C for the word suggestion class.
    RKObjectMapping *relatedWordsMapping = [RKObjectMapping mappingForClass:[RelatedWords class]];
    [relatedWordsMapping mapKeyPath:@"words" toAttribute:@"words"];
    [relatedWordsMapping mapKeyPath:@"relationshipType" toAttribute:@"relationshipType"];
    
    // Provide the mapping to JSON to Objective C for the word of the day.
    RKObjectMapping *wordOfTheDayMapping = [RKObjectMapping mappingForClass:[WordOfTheDay class]];
    [wordOfTheDayMapping mapKeyPath:@"word" toAttribute:@"word"];
    
    // Provide the mapping to JSON to Objective C for pronunciations.
    RKObjectMapping *pronunciationMapping = [RKObjectMapping mappingForClass:[Pronunciation class]];
    [pronunciationMapping mapKeyPath:@"raw" toAttribute:@"string"];
    
    // Add the mappings to the RKObjectManager and provide my API key in the HTTP header.
    [manager.mappingProvider addObjectMapping:definitionMapping];
    [manager.mappingProvider addObjectMapping:wordMapping];
    [manager.mappingProvider addObjectMapping:relatedWordsMapping];
    [manager.mappingProvider addObjectMapping:wordOfTheDayMapping];
    [manager.mappingProvider addObjectMapping:pronunciationMapping];

    [RKObjectManager setSharedManager:manager];
    [RKClient setSharedClient:client];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Toolbar Button Methods

+ (UIButton *)texturedBackButtonWithTitle:(NSString*)title {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    button.contentMode = UIViewContentModeLeft;
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(7.0, 12.0, 8.0, 7.0);
    [button sizeToFit];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"ERNavigationButtonBack.png"]
                                stretchableImageWithLeftCapWidth:13.0 topCapHeight:2.0];
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    UIImage *backButtonImagePressed = [[UIImage imageNamed:@"ERNavigationButtonBackPressed.png"]
                                       stretchableImageWithLeftCapWidth:13.0 topCapHeight:2.0];
    [button setBackgroundImage:backButtonImagePressed forState:UIControlStateHighlighted];
    
    return button;
}

+ (UIButton *)texturedButtonWithTitle:(NSString*)title {
    
    UIButton* button = [self.class texturedButton];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    button.contentMode = UIViewContentModeCenter;
    
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 9.0, 0.0, 9.0);
    [button sizeToFit];
    
    return button;
}

+ (UIButton *)texturedButtonWithImage:(UIImage*)image {
    
    UIButton* button = [self.class texturedButton];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    
    button.contentMode = UIViewContentModeCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0, 9.0, 0.0, 9.0);
    
    [button sizeToFit];
    return button;
}

+ (UIButton *)texturedButton {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *buttonImage;
    UIImage *buttonImagePressed;
    
    UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0);
    buttonImage = [[UIImage imageNamed:@"ERNavigationButtonSquare.png"] resizableImageWithCapInsets:buttonEdgeInsets];
    buttonImagePressed = [[UIImage imageNamed:@"ERNavigationButtonSquarePressed.png"] resizableImageWithCapInsets:buttonEdgeInsets];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    
    return button;
}


@end
