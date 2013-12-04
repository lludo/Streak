//
//  LGMAppearance.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMAppearance.h"

@implementation LGMAppearance

+ (void)loadAppearance {
    
    // UISegmentedControl
    
    UISegmentedControl *segmentedControlAppearance = [UISegmentedControl appearance];
    
    /* Normal background */
    UIImage *normalBackgroundImage = [UIImage imageNamed:@"switch-background-normal"];
    [segmentedControlAppearance setBackgroundImage:normalBackgroundImage
                                          forState:UIControlStateNormal
                                        barMetrics:UIBarMetricsDefault];
    
    /* Selected background */
    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"switch-background-selected"];
    [segmentedControlAppearance setBackgroundImage:selectedBackgroundImage
                                          forState:UIControlStateSelected
                                        barMetrics:UIBarMetricsDefault];
    
    /* Image between segment selected on the left and normal on the right */
    UIImage *leftSelectedRightNormal = [UIImage imageNamed:@"switch-middle-left-selected-right-normal"];
    [segmentedControlAppearance setDividerImage:leftSelectedRightNormal
                            forLeftSegmentState:UIControlStateSelected
                              rightSegmentState:UIControlStateNormal
                                     barMetrics:UIBarMetricsDefault];
    
    /* Image between segment normal on the left and selected on the right */
    UIImage *leftNormalRightSelected = [UIImage imageNamed:@"switch-middle-left-normal-right-selected"];
    [segmentedControlAppearance setDividerImage:leftNormalRightSelected
                            forLeftSegmentState:UIControlStateNormal
                              rightSegmentState:UIControlStateSelected
                                     barMetrics:UIBarMetricsDefault];
}

@end
