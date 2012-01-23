//
//  WordyUISearchBar.m
//  Wordy
//
//  Created by Devon Tivona on 12/30/11.
//  Copyright (c) 2011 University of Colorado, Boulder. All rights reserved.
//

#import "WordyUISearchBar.h"
#import "WordyAppDelegate.h"

@implementation WordyUISearchBar

- (void) addSubview:(UIView *)view 
{
    
    if ([view isKindOfClass:UIButton.class]) {        
        UIImage *buttonImage;
        UIImage *buttonImagePressed;
        
        UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0.0, 6.0, 0.0, 6.0);
        buttonImage = [[UIImage imageNamed:@"ERNavigationButtonSquare.png"] resizableImageWithCapInsets:buttonEdgeInsets];
        buttonImagePressed = [[UIImage imageNamed:@"ERNavigationButtonSquarePressed.png"] resizableImageWithCapInsets:buttonEdgeInsets];
        
        [((UIButton *)view) setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [((UIButton *)view) setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        
        cancelTarget = [((UIButton *)view).allTargets anyObject];
        NSArray *allActions = [((UIButton *)view) actionsForTarget:cancelTarget forControlEvent:UIControlEventTouchUpInside];
        cancelSelector = NSSelectorFromString([allActions objectAtIndex:0]);
    }
    
    [super addSubview:view];
}

- (void)cancel 
{    
    [cancelTarget performSelector:cancelSelector];
}

@end
