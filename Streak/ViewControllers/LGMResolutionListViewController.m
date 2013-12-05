//
//  LGMResolutionListViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMResolutionListViewController.h"

@interface LGMResolutionListViewController ()

@property (nonatomic, assign) LGMResolutionListType type;

@end

@implementation LGMResolutionListViewController

- (id)initWithType:(LGMResolutionListType)aType delegate:(id<LGMResolutionListViewControllerDelegate>)aDelegate {
    self = [super init];
    if (self) {
        _type = aType;
        _delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Build the segmented control for filter
    NSArray *items = @[[UIImage imageNamed:@"switch-mask-all"], [UIImage imageNamed:@"switch-mask-done"]];
    UISegmentedControl *filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [filterSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    filterSegmentedControl.frame = CGRectMake(0, 0, 126, 30);
    filterSegmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = filterSegmentedControl;
    
    // Build the menu button
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self action:@selector(showMenu:)];
    self.navigationItem.leftBarButtonItem = menuButtonItem;
}

- (void)showMenu:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(showMenuAnimated:)]) {
        [_delegate showMenuAnimated:YES];
    }
}

- (void)valueChanged:(id)sender {
    
    //TODO to finish
}

@end
