//
//  SynonymViewController.h
//  Wordy
//
//  Created by Devon Tivona on 12/29/11.
//  Copyright (c) 2011 University of Colorado, Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class RelatedViewController;

@protocol FlipsideViewControllerDelegate <NSObject>

- (void)flipsideViewControllerDidFinish:(RelatedViewController *)controller;
- (void)getEntryForWord:(NSString *)word; 
- (NSString *)getCurrentWord;

@end

@interface RelatedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    UINavigationItem *_navigationTitle;
    NSArray *_words;
    NSString *_relationshipType;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *words;
@property (nonatomic, retain) NSString *relationshipType;

@property (nonatomic, retain) IBOutlet UINavigationItem *navigationTitle;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UITableView *relatedTable;
@property (retain, nonatomic) IBOutlet UILabel *emptyLabel;

- (void)done:(id)sender;

@end
