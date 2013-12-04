//
//  LGMMenuViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMMenuViewController.h"

@interface LGMMenuViewController ()

@property (nonatomic, strong) NSArray *resolutionViewControllerList;

@end

@implementation LGMMenuViewController

- (id)init {
    self = [super init];
    if (self) {
        LGMResolutionListViewController *resolutionListDaily = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeDaily delegate:self];
        UINavigationController *resolutionListDailyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListDaily];
        
        LGMResolutionListViewController *resolutionListViewWeekly = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeWeekly delegate:self];
        UINavigationController *resolutionListWeeklyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListViewWeekly];
        
        LGMResolutionListViewController *resolutionListViewMonthly = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeMonthly delegate:self];
        UINavigationController *resolutionListMonthlyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListViewMonthly];
        
        LGMResolutionListViewController *resolutionListViewYearly = [[LGMResolutionListViewController alloc] initWithType:LGMResolutionListTypeYearly delegate:self];
        UINavigationController *resolutionListYearlyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListViewYearly];
        
        _resolutionViewControllerList = @[resolutionListDailyNav, resolutionListWeeklyNav, resolutionListMonthlyNav, resolutionListYearlyNav];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)didSelectYearly:(id)sender {
    [self presentResolutionListWithType:LGMResolutionListTypeYearly animated:YES];
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
