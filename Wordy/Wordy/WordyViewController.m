//
//  WordyViewController.m
//  Wordy
//
//  Created by Devon Tivona on 9/22/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import "WordyViewController.h"
#import "WordyAppDelegate.h"

#import "Definition.h"
#import "Word.h"
#import "RelatedWords.h"
#import "WordOfTheDay.h"
#import "Pronunciation.h"

#import "DefinitionViewController.h"
#import "RelatedViewController.h"
#import "FlipsideTabBarController.h"
#import <RestKit/RestKit.h>
#import "NSString+HTML.h"

@implementation WordyViewController
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize background;
@synthesize currentPronunciation;


#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    hasInternet = YES;
    
    wordOfTheDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0);
    UIImage *buttonImage = [[UIImage imageNamed:@"WordyBasicButton"] resizableImageWithCapInsets:buttonEdgeInsets];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"WordyBasicButtonPressed"] resizableImageWithCapInsets:buttonEdgeInsets];
    
    [wordOfTheDayButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [wordOfTheDayButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    
    wordOfTheDayButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [wordOfTheDayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    wordOfTheDayButton.contentEdgeInsets = UIEdgeInsetsMake(9.0, 12.0, 9.0, 12.0);
    wordOfTheDayButton.hidden = YES;
    
    [wordOfTheDayButton addTarget:self action:@selector(getWordOfTheDayEntry:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:wordOfTheDayButton];
    
    UIEdgeInsets backgroundEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0);    
    searchBar.backgroundImage = [[UIImage imageNamed:@"WDHeaderBackground"] resizableImageWithCapInsets:backgroundEdgeInsets];  
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WordyBackgroundNoise"]];
    
    data = [[NSMutableArray alloc] init];
    
    responseCounter = 0;
    
    // Initialize the tab bar controller for the flip side
    flipsideTabBarController = [[FlipsideTabBarController alloc] init];  
    flipsideTabBarController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    flipsideTabBarController.tabBar.backgroundImage = [[UIImage imageNamed:@"WordyTabBarBackground"] resizableImageWithCapInsets:backgroundEdgeInsets];
    flipsideTabBarController.tabBar.selectedImageTintColor = [UIColor whiteColor];
    flipsideTabBarController.tabBar.tintColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    buttonImage = [[UIImage imageNamed:@"WordyTabBarItemBackground"] resizableImageWithCapInsets:buttonEdgeInsets];
    flipsideTabBarController.tabBar.selectionIndicatorImage = buttonImage;
    
    informationViewController = [[InformationViewController alloc] init];
    informationViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    informationViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WordyInformation"]];
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    [viewControllers insertObject:[NSNull null] atIndex:0];
    [viewControllers insertObject:[NSNull null] atIndex:1];
    [viewControllers insertObject:[NSNull null] atIndex:2];
    [viewControllers insertObject:[NSNull null] atIndex:3];
    
    checkingWOTD = NO;
    
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated 
{
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
    responseCounter = 0;

    [self.searchDisplayController.searchResultsTableView  deselectRowAtIndexPath:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow] animated:animated];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated 
{
    hasInternet = YES;    
    flipsideTabBarController.viewControllers = nil;
    
    [self checkWordOfTheDayEntry];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
    responseCounter = 0;

    [self setSearchBar:nil];
    [self setSearchDisplayController:nil];
    [self setBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - FlipsideViewController Delegate Methods

- (void)flipsideViewControllerDidFinish:(DefinitionViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - WordyViewController  Methods

- (IBAction)informationButtonTapped:(id)sender 
{
    [self presentModalViewController:informationViewController animated:YES];
}

- (IBAction)getWordOfTheDayEntry:(id)sender {
    [self getEntryForWord:wordOfTheDayButton.titleLabel.text];
}

// Make a JSON call Wordnik to get the word of the day
- (void)getWordOfTheDay
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	HUD.square = YES;
    
    [HUD show:YES];
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(handleRequestTimeout)
                                   userInfo:nil
                                    repeats:NO];
    
    NSString *resourcePath = [NSString stringWithFormat:@"/words.json/wordOfTheDay"];
    RKObjectMapping* wordOfTheDayMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[WordOfTheDay class]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:wordOfTheDayMapping delegate:self];
}

// Make a JSON call Wordnik to get the definition for the selected word
- (void)getDefinition:(NSString*)word
{
    NSString *resourcePath = [NSString stringWithFormat:@"/word.json/%@/definitions", word];
    resourcePath = [resourcePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    RKObjectMapping* definitionMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Definition class] ];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:definitionMapping delegate:self];
}

- (void)getPronunciation:(NSString*)word
{    
    NSString *resourcePath = [NSString stringWithFormat:@"/word.json/%@/pronunciations?typeFormat=ahd", word];
    resourcePath = [resourcePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    RKObjectMapping* pronunciationMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Pronunciation class] ];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:pronunciationMapping delegate:self];
}

// Make a JSON call Wordnik to get synonyms for the selected word
- (void)getRelated:(NSString*)word ofRelationship:(NSString*)relationship
{
    NSString *resourcePath = [NSString stringWithFormat:@"/word.json/%@/related?type=%@", word, relationship];
    resourcePath = [resourcePath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    RKObjectMapping* relatedWordsMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[RelatedWords class] ];
    
    RKObjectLoader *objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:resourcePath delegate:self];
    
    objectLoader.params = [NSDictionary dictionaryWithObject:relationship forKey:@"type"];
    objectLoader.objectMapping = relatedWordsMapping;
    
    [objectLoader send];
    //[[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:relatedWordsMapping delegate:self];
}

- (void)getEntryForWord:(NSString *)word {
    hasInternet = YES;
    shouldError = YES;
    
    [self.view endEditing:YES];
    	
    if (self.view.window) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:HUD];
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:flipsideTabBarController.view.window];
        [flipsideTabBarController.view.window addSubview:HUD];
    }
	
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	HUD.square = YES;
    
    [HUD show:YES];
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(handleRequestTimeout)
                                   userInfo:nil
                                    repeats:NO];

    
    responseCounter = 0;
    currentWord = [word copy];
    
    [self getDefinition:word];
    [self getPronunciation:word];
    [self getRelated:word ofRelationship:@"synonym"];
    [self getRelated:word ofRelationship:@"antonym"];
    [self getRelated:word ofRelationship:@"cross-reference"];
}


- (void)checkWordOfTheDayEntry
{    
    if (checkingWOTD == NO) {
        checkingWOTD = YES;

        // Get the word of the day
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDate *wordOfTheDayTimestamp = [defaults objectForKey:@"wordOfTheDayTimestamp"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *storedDate = [dateFormatter stringFromDate:wordOfTheDayTimestamp];
        NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
        
        NSLog([NSString stringWithFormat:@"Old: %@, New: %@", storedDate, todayDate]);
        
        if ([todayDate isEqualToString:storedDate]) {
            NSLog(@"I am going to use a cached word");
            
            NSString *wordOfTheDay = [defaults objectForKey:@"wordOfTheDay"];
            [wordOfTheDayButton setTitle:wordOfTheDay forState:UIControlStateNormal];
            [wordOfTheDayButton sizeToFit];
            wordOfTheDayButton.frame = CGRectMake(floorf(160 - wordOfTheDayButton.frame.size.width/2), 225, wordOfTheDayButton.frame.size.width, wordOfTheDayButton.frame.size.height);
            wordOfTheDayButton.hidden = NO;
            checkingWOTD = NO;
        } else {
            [self getWordOfTheDay];
        }
    }
}

- (NSString *)getCurrentWord {
    return currentWord;
}

#pragma mark - Search Display Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // This method prevents the table from reloading and starts the search!    
    NSString *query = self.searchBar.text;
    NSString *resourcePath = [NSString stringWithFormat:@"/words.json/search?query=%@", query];
    resourcePath = [resourcePath stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    RKObjectMapping* wordMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Word class]];
    
    if(![searchString isEqualToString:@""]) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:wordMapping delegate:self];
    }
    return NO;
}

// Is called when the search button is clicked
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {    
    NSString *word = self.searchBar.text;
    [self getEntryForWord:word];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSString *word = [data objectAtIndex:indexPath.row];
    [self getEntryForWord:word];
}

#pragma mark - Object Loader Helper Methods

// We got a responce from Wordnik! If it is a word suggestion array, then put that array in the 
// search result table. If it is a definition, flip to the FlipSideView and display the definitions.
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {  
    
    hasInternet = YES;
        
    if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Word class]]) {
        [data removeAllObjects];
                
        for (Word *word in objects) {
            [data addObject:word.wordString];
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    } else if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[WordOfTheDay class]]) {
        [HUD hide:YES];
            
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        for (WordOfTheDay *word in objects) {
            
            [wordOfTheDayButton setTitle:word.word forState:UIControlStateNormal];
            [wordOfTheDayButton sizeToFit];

            wordOfTheDayButton.frame = CGRectMake(floorf(160 - wordOfTheDayButton.frame.size.width/2), 225, wordOfTheDayButton.frame.size.width, wordOfTheDayButton.frame.size.height);
                        
            wordOfTheDayButton.hidden = NO;
            [defaults setObject:word.word forKey:@"wordOfTheDay"];
            [defaults setObject:[NSDate date] forKey:@"wordOfTheDayTimestamp"];
        }
        
        [defaults synchronize];
        checkingWOTD = NO;
            
    } else if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Definition class]]) {
        if (objects.count) { 
            responseCounter++;

            DefinitionViewController *definitionViewController = [[DefinitionViewController alloc] initWithNibName:@"DefinitionView" bundle:nil];
            definitionViewController.definitions = objects;
            definitionViewController.delegate = self;        
            definitionViewController.title = @"Definitions";
            [definitionViewController.tabBarItem setImage:[UIImage imageNamed:@"WordyDefinitionIcon"]];
            
            [viewControllers replaceObjectAtIndex:0 withObject:definitionViewController];
        } else {
            [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self]; 
            responseCounter = 0;
            [HUD hide:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                                message:@"That word is not in the dictionary. Try another word?"
                                                               delegate:nil 
                                                      cancelButtonTitle:nil 
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    } else if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[RelatedWords class]]) {
        responseCounter++;
        
        NSDictionary *responseParams = (NSDictionary *)objectLoader.params;
        NSString *requestType = (NSString *)[responseParams objectForKey:@"type"];
        if ([requestType isEqualToString:@"cross-reference"]) {
            requestType = @"reference";
        }
        
        RelatedViewController *relatedViewController = [[RelatedViewController alloc] initWithNibName:@"RelatedView" bundle:nil];
        relatedViewController.relationshipType = requestType;
        relatedViewController.delegate = self;  
        relatedViewController.title = [relatedViewController.relationshipType capitalizedString];
        relatedViewController.navigationTitle.title = currentWord;
        
        if ([relatedViewController.relationshipType isEqualToString:@"synonym"]) {
            [relatedViewController.tabBarItem setImage:[UIImage imageNamed:@"WordySynonymIcon"]];
        } else if ([relatedViewController.relationshipType isEqualToString:@"antonym"]) {
            [relatedViewController.tabBarItem setImage:[UIImage imageNamed:@"WordyAntonymIcon"]];
        } else if ([relatedViewController.relationshipType isEqualToString:@"reference"]) {
            [relatedViewController.tabBarItem setImage:[UIImage imageNamed:@"WordyReferenceIcon"]];
        }

        if (objects.count) { 
            relatedViewController.words = ((RelatedWords*)[objects objectAtIndex:0]).words;
        } else {
            relatedViewController.words = nil;            
        }
        
        if ([relatedViewController.relationshipType isEqualToString:@"synonym"]) {
            [viewControllers replaceObjectAtIndex:1 withObject:relatedViewController];
        } else if ([relatedViewController.relationshipType isEqualToString:@"antonym"]) {
            [viewControllers replaceObjectAtIndex:2 withObject:relatedViewController];
        } else {
            [viewControllers replaceObjectAtIndex:3 withObject:relatedViewController];
        }
        
    } else if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Pronunciation class]]) {
        responseCounter++;
        if (objects.count) {
            currentPronunciation = (Pronunciation *)[objects objectAtIndex:0];
        }
    }
    
    if (responseCounter == 5) {
        [HUD hide:YES];
        
        shouldError = NO;
        responseCounter = 0;
        [flipsideTabBarController setViewControllers:viewControllers];
        
        if(![self modalViewController]) {
            [self presentModalViewController:flipsideTabBarController animated:YES];
        } else {
            flipsideTabBarController.selectedIndex = 0;
            [self.searchBar cancel];
        }
    } 

}

// Something went wrong... Log the error and stop the spinner
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [HUD hide:YES];
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self]; 
    responseCounter = 0;
    
    if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[WordOfTheDay class]]) {
        checkingWOTD = NO;
    }
    
    NSLog(@"Encountered an error: %@", error);
    if (error.code == 2 && hasInternet) {
        hasInternet = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                            message:@"I am having difficulty contacting the server. Are you connected to the internet?"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void)handleRequestTimeout {
    checkingWOTD = NO;

    [HUD hide:YES];
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self]; 
    responseCounter = 0;

    if (hasInternet && shouldError) {
        hasInternet = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                            message:@"I am having difficulty contacting the server. Are you connected to the internet?"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
