//
//  FlipsideViewController.h
//  Wordy
//
//  Created by Devon Tivona on 9/27/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DefinitionViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(DefinitionViewController *)controller;
@end

@interface DefinitionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UINavigationItem *_navigationTitle;
    NSArray *_definitions;
    UITableView *_definitionsTable;
    
    UITableViewCell *definitionCell;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationTitle;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) NSArray *definitions;
@property (nonatomic, retain) IBOutlet UITableView *definitionsTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *definitionCell;

- (void)done:(id)sender;

@end
