//
//  LGMWalktroughWelcomeViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/30/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMWalktroughWelcomeViewController.h"
#import "LGMWalktroughResolutionNameViewController.h"
#import "UIButton+Stretch.h"

@interface LGMWalktroughWelcomeViewController ()

@property (nonatomic, strong) IBOutlet UIButton *createResolutionButton;

@end

@implementation LGMWalktroughWelcomeViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger leftCapWidth = self.createResolutionButton.bounds.size.height / 2;
    [self.createResolutionButton stretchBackgroundImageWithLeftCapWidth:leftCapWidth topCapHeight:0];
}

- (IBAction)createResolution:(id)sender {
    LGMWalktroughResolutionNameViewController *resolutionNameViewController = [[LGMWalktroughResolutionNameViewController alloc] init];
    [self.navigationController pushViewController:resolutionNameViewController animated:YES];
}

- (IBAction)skip:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
