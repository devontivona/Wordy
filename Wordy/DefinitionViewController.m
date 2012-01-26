//
//  FlipsideViewController.m
//  Wordy
//
//  Created by Devon Tivona on 9/27/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import "DefinitionViewController.h"
#import "Definition.h"
#import "Pronunciation.h"

#import "WordyAppDelegate.h"
#import "NSString+HTML.h"
#import "FlipsideTabBarController.h"
#import "WordyViewController.h"
#import "SSLabel.h"

@implementation DefinitionViewController

@synthesize delegate = _delegate;
@synthesize navigationTitle = _navigationTitle;
@synthesize navigationBar = _navigationBar;
@synthesize definitions = _definitions;
@synthesize definitionsTable = _definitionsTable;

@synthesize definitionCell;

// Remove dashes, replace them with spaces and capitalize the string
- (NSString *)convertPartOfSpeech:(NSString *)partOfSpeech {
    if ([partOfSpeech isEqualToString:@""] || (partOfSpeech == nil)) {
        return @"Word";
    } else {
        NSString *string = [[partOfSpeech stringByReplacingOccurrencesOfString:@"-" withString:@" "] capitalizedString];
        return string;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Pronunciation *currentPronunciation = ((WordyViewController *)self.delegate).currentPronunciation;
    
    if (![currentPronunciation.string isEqualToString:@""] && currentPronunciation != nil) {
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.text = currentPronunciation.string;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        headerLabel.shadowColor = [UIColor blackColor];
        headerLabel.textAlignment = UITextAlignmentCenter;
        headerLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        headerLabel.font = [UIFont boldSystemFontOfSize:15];
        return headerLabel;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    Pronunciation *currentPronunciation = ((WordyViewController *)self.delegate).currentPronunciation;
    if ([currentPronunciation.string isEqualToString:@""] || currentPronunciation == nil) {
        return 0;
    } else {
        return 34;
    }
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.definitions count];
}

// Calculate the size of the table cells based upon the size of the definition string
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    Definition *currentDefinition = [self.definitions objectAtIndex:indexPath.row];
    CGSize cellSize = [[currentDefinition.text stringByDecodingHTMLEntities] sizeWithFont:[UIFont fontWithName:@"HoeflerText-Roman" size:15] constrainedToSize: maximumLabelSize lineBreakMode: UILineBreakModeWordWrap];
    return cellSize.height+55;
}

// Return the correct part of speech and definition for each row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *subview in cell.subviews) 
    {
        [subview removeFromSuperview];
    }
    
    Definition *currentDefinition = [self.definitions objectAtIndex:indexPath.row];
    
    SSLabel *label = [[SSLabel alloc] init];
    label.text = [self convertPartOfSpeech:currentDefinition.partOfSpeech];
    label.font = [UIFont fontWithName:@"HoeflerText-BoldItalic" size:20];
    label.frame = CGRectMake(20, 11, 280, 25);
    label.backgroundColor = [UIColor clearColor];
    
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    CGSize cellSize = [[currentDefinition.text stringByDecodingHTMLEntities] sizeWithFont:[UIFont fontWithName:@"HoeflerText-Roman" size:15] constrainedToSize: maximumLabelSize lineBreakMode: UILineBreakModeWordWrap];

    SSLabel *definition = [[SSLabel alloc] init];
    definition.text = [currentDefinition.text stringByDecodingHTMLEntities];
    definition.font = [UIFont fontWithName:@"HoeflerText-Roman" size:15];
    definition.numberOfLines = 10;
    definition.frame = CGRectMake(20, 43, 280, cellSize.height);
    definition.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row != 0) {
        UIView *dividerTop = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
        dividerTop.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:dividerTop];
        UIView *dividerBottom = [[UIView alloc] initWithFrame:CGRectMake(20, 1, 280, 1)];
        dividerBottom.backgroundColor = [UIColor whiteColor];
        [cell addSubview:dividerBottom];
    }

    [cell addSubview:label];
    [cell addSubview:definition];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the title of the naviation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HoeflerText-BoldItalic" size:20];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, -1.0);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationTitle.titleView = label;
    label.text = ((Definition*)[_definitions objectAtIndex:0]).word;
    [label sizeToFit];
    label.frame = CGRectInset(label.frame, -10.0, 0.0);    
    
    // self.navigationTitle.title = @"Definitions";
    
    UIEdgeInsets backgroundEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0);    
    [_navigationBar setBackgroundImage:[[UIImage imageNamed:@"WDHeaderBackground"] resizableImageWithCapInsets:backgroundEdgeInsets] forBarMetrics:UIBarMetricsDefault]; 
   
    // Customize the background color of the view 
    _definitionsTable.backgroundColor = [UIColor clearColor];
    _definitionsTable.opaque = NO;
    _definitionsTable.backgroundView = nil;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WordyBackgroundNoise"]];
    
    UIButton *searchButton = [WordyAppDelegate texturedButtonWithTitle:@"Back"];
    [searchButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationTitle.leftBarButtonItem = searchButtonItem;
}

- (void)viewDidUnload
{
    [self setNavigationTitle:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
