//
//  WordyUISearchBar.h
//  Wordy
//
//  Created by Devon Tivona on 12/30/11.
//  Copyright (c) 2011 University of Colorado, Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordyUISearchBar : UISearchBar {
    id cancelTarget;
    SEL cancelSelector;
}

- (void)addSubview:(UIView *)view;
- (void)cancel;

@end
