//
//  LGMSettingsViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/30/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMSettingsViewController.h"

@interface LGMSettingsViewController ()

@end

@implementation LGMSettingsViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    
    // Build the menu button
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self action:@selector(hideSettings:)];
    self.navigationItem.leftBarButtonItem = menuButtonItem;
}

- (void)hideSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
