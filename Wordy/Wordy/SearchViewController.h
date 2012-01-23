//
//  SearchViewController.h
//  Wordy
//
//  Created by Devon Tivona on 9/22/11.
//  Copyright 2011 University of Colorado, Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface SearchViewController : UIViewController <RKObjectLoaderDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray* data;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;

@end
