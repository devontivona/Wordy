//
//  FlipsideTabBarController.m
//  Wordy
//
//  Created by Devon Tivona on 1/1/12.
//  Copyright (c) 2012 University of Colorado, Boulder. All rights reserved.
//

#import "FlipsideTabBarController.h"

@implementation FlipsideTabBarController

-(void)viewWillAppear:(BOOL)animated {
    for (UITabBarItem *currentItem in self.tabBar.items) {
        [currentItem setTitlePositionAdjustment:UIOffsetMake(0.0, -4.0)];
    }
    
    [super viewWillAppear:animated];
}

- (void)setViewControllers:(NSArray *)viewControllers 
{
    [super setViewControllers:viewControllers];

    for (UITabBarItem *currentItem in self.tabBar.items) {
        [currentItem setTitlePositionAdjustment:UIOffsetMake(0.0, -4.0)];
    }    
}

@end
