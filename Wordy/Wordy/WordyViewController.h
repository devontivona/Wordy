//
//  WordyViewController.h
//  Wordy
//
//  Created by Devon Tivona on 9/22/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "DefinitionViewController.h"
#import "WordyUISearchBar.h"
#import "MBProgressHUD.h"
#import "InformationViewController.h"
#import "Pronunciation.h"

@interface WordyViewController : UIViewController <RKObjectLoaderDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, FlipsideViewControllerDelegate, MBProgressHUDDelegate, RKRequestQueueDelegate> {
    WordyUISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray* data;
    
    UITabBarController *flipsideTabBarController;
    InformationViewController *informationViewController;
    
    NSMutableArray *viewControllers;
    
    NSString *currentWord;
    
    UIButton *wordOfTheDayButton;
    
    int responseCounter;

    BOOL hasInternet;
    BOOL shouldError;
    BOOL checkingWOTD;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet WordyUISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (retain, nonatomic) IBOutlet UIImageView *background;

@property (strong, nonatomic) Pronunciation *currentPronunciation;

- (IBAction)getWordOfTheDayEntry:(id)sender;
- (IBAction)informationButtonTapped:(id)sender; 

- (void)checkWordOfTheDayEntry;

@end
