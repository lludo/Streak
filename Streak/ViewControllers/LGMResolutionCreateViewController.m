//
//  LGMResolutionCreateViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/30/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMResolutionCreateViewController.h"

@interface LGMResolutionCreateViewController ()

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation LGMResolutionCreateViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Build the calcel button
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self action:@selector(cancel:)];
    cancelButtonItem.tintColor = [UIColor darkTextColor];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    // Build the done button
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
