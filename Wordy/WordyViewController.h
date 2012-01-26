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
        
    UITabBarController *flipsideTabBarController;
    InformationViewController *informationViewController;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *viewControllers;
    
    NSString *currentWord;
    
    UIButton *wordOfTheDayButton;
    UIAlertView *alertView;
    WordyUISearchBar *searchBar;
    UIActivityIndicatorView *activityIndicator;
    
    int responseCounter;
    BOOL checkingWOTD;
    NSTimer *requestTimer;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet WordyUISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) IBOutlet UIImageView *background;

@property (nonatomic, retain) NSMutableArray* data;
@property (strong, nonatomic) Pronunciation *currentPronunciation;

- (void)checkWordOfTheDayEntry;
- (void)getWordOfTheDayEntry:(id)sender;

- (IBAction)informationButtonTapped:(id)sender; 


@end
