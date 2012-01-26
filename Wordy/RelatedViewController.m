//
//  SynonymViewController.m
//  Wordy
//
//  Created by Devon Tivona on 12/29/11.
//  Copyright (c) 2011 University of Colorado, Boulder. All rights reserved.
//

#import "RelatedViewController.h"
#import "WordyAppDelegate.h"
#import "MBProgressHUD.h"
#import "FlipsideTabBarController.h"
#import "Pronunciation.h"
#import "WordyViewController.h"

@implementation RelatedViewController

@synthesize delegate = _delegate;
@synthesize words = _words;
@synthesize relationshipType = _relationshipType;
@synthesize navigationTitle = _navigationTitle;
@synthesize navigationBar = _navigationBar;
@synthesize relatedTable = _relatedTable;
@synthesize emptyLabel = _emptyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.words count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath 
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell"];
    }
    
    cell.textLabel.text = [_words objectAtIndex: indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *selectedWord = [_words objectAtIndex:indexPath.row];
    [self.delegate getEntryForWord:selectedWord];
    
    NSIndexPath *currentSelection = [self.relatedTable indexPathForSelectedRow];
    [self.relatedTable performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:currentSelection afterDelay:0.05];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    UIEdgeInsets backgroundEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0);    
    [_navigationBar setBackgroundImage:[[UIImage imageNamed:@"WDHeaderBackground"] resizableImageWithCapInsets:backgroundEdgeInsets] forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton *searchButton = [WordyAppDelegate texturedButtonWithTitle:@"Back"];
    [searchButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationTitle.leftBarButtonItem = searchButtonItem;

    // Customize the background color of the view 
    _relatedTable.backgroundColor = [UIColor clearColor];
    _relatedTable.opaque = NO;
    _relatedTable.backgroundView = nil;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WordyBackgroundNoise"]];
    
    if (self.words == nil) {
        self.emptyLabel.text = [[NSString alloc] initWithFormat:@"There are no %@s available for this word.", self.relationshipType];
        [self.relatedTable setHidden:TRUE];
    } else {
        [self.emptyLabel setHidden:TRUE];
    }
    
    // Initialize the title of the naviation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HoeflerText-BoldItalic" size:20];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, -1.0);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationTitle.titleView = label;
    label.text = [self.delegate getCurrentWord];    
    [label sizeToFit];
    label.frame = CGRectInset(label.frame, -10.0, 0.0);    

    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setEmptyLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
