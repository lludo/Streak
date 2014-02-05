//
//  LGMNavigationViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMNavigationViewController.h"
#import "LGMSettingsViewController.h"
#import "LGMWalktroughWelcomeViewController.h"

@interface LGMNavigationViewController ()

@property (nonatomic, strong) NSArray *resolutionViewControllerList;

@end

@implementation LGMNavigationViewController

- (id)init {
    self = [super init];
    if (self) {
        LGMResolutionListViewController *resolutionListDaily = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeDaily delegate:self];
        UINavigationController *resolutionListDailyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListDaily];
        
        LGMResolutionListViewController *resolutionListViewWeekly = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeWeekly delegate:self];
        UINavigationController *resolutionListWeeklyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListViewWeekly];
        
        LGMResolutionListViewController *resolutionListViewMonthly = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeMonthly delegate:self];
        UINavigationController *resolutionListMonthlyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListViewMonthly];
        
        _resolutionViewControllerList = @[resolutionListDailyNav, resolutionListWeeklyNav, resolutionListMonthlyNav];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //LGMWalktroughWelcomeViewController *walktroughWelcomeViewController = [[LGMWalktroughWelcomeViewController alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:walktroughWelcomeViewController];
    //[self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)didSelectDaily:(id)sender {
    [self presentResolutionListWithType:LGMResolutionListTypeDaily animated:YES];
}

- (IBAction)didSelectWeekly:(id)sender {
    [self presentResolutionListWithType:LGMResolutionListTypeWeekly animated:YES];
}

- (IBAction)didSelectMonthly:(id)sender {
    [self presentResolutionListWithType:LGMResolutionListTypeMonthly animated:YES];
}

- (IBAction)didSelectSettings:(id)sender {
    LGMSettingsViewController *settingsViewController = [[LGMSettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)presentResolutionListWithType:(LGMResolutionListType)type animated:(BOOL)animated {
    
    //TODO: temporary
    UIViewController *viewController = [_resolutionViewControllerList objectAtIndex:type];
    [self presentViewController:viewController animated:animated completion:NULL];
}

- (void)showMenuAnimated:(BOOL)animated {
    
    //TODO: temporary
    [self.presentedViewController dismissViewControllerAnimated:animated completion:NULL];
}

@end
