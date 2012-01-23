//
//  SearchViewController.m
//  Wordy
//
//  Created by Devon Tivona on 9/22/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import "SearchViewController.h"
#import "WordyAppDelegate.h"
#import "Definition.h"
#import "Word.h"

@implementation SearchViewController
@synthesize searchBar;
@synthesize searchDisplayController;

- (void)getDefinition:(NSString*)word
{
    NSString *resourcePath = [NSString stringWithFormat:@"/word.json/%@/definitions", word];
    RKObjectMapping* definitionMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Definition class] ];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:definitionMapping delegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    
    NSString *word = [data objectAtIndex:indexPath.row];
    [self getDefinition:word];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // This method prevents the table from reloading and starts the search!
    // [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(mockSearch:) userInfo:searchString repeats:NO];
    
    NSString *query = self.searchBar.text;
    NSString *resourcePath = [NSString stringWithFormat:@"/words.json/search?query=%@", query];
    RKObjectMapping* wordMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Word class]];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath objectMapping:wordMapping delegate:self];
    
    return NO;
}

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    NSString *word = self.searchBar.text;
    [self getDefinition:word]; 
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {    
    if (objectLoader.objectMapping == [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[Word class]]) {
        [data removeAllObjects];
                
        for (Word *currentWord in objects) {
            [data addObject:currentWord.wordString];
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    } else {
        Definition *definition = [objects objectAtIndex:0];
        NSLog(@"Loaded Definition of %@: %@, part of speech is %@", definition.word, definition.text, definition.partOfSpeech);
        
        WordyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:2];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    data = [[NSMutableArray alloc] init];

    RKObjectMapping *definitionMapping = [RKObjectMapping mappingForClass:[Definition class]];
    [definitionMapping mapKeyPath:@"word" toAttribute:@"word"];
    [definitionMapping mapKeyPath:@"text" toAttribute:@"text"];
    [definitionMapping mapKeyPath:@"score" toAttribute:@"score"];
    [definitionMapping mapKeyPath:@"partOfSpeech" toAttribute:@"partOfSpeech"];
    [definitionMapping mapKeyPath:@"sourceDictionary" toAttribute:@"sourceDictionary"];
    [definitionMapping mapKeyPath:@"sequence" toAttribute:@"sequence"];
    
    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
    [wordMapping mapKeyPath:@"count" toAttribute:@"count"];
    [wordMapping mapKeyPath:@"wordstring" toAttribute:@"wordString"];
    
    [[RKObjectManager sharedManager].mappingProvider addObjectMapping:definitionMapping];
    [[RKObjectManager sharedManager].mappingProvider addObjectMapping:wordMapping];
    [[RKObjectManager sharedManager].client setValue:@"ac9d04f07652a7302f40e07dae60954fa3dd46ab3650f5081" forHTTPHeaderField:@"api_key"];

    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setSearchDisplayController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [searchBar release];
    [searchDisplayController release];
    [data release];
    [super dealloc];
}
@end
