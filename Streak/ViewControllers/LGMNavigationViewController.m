//
//  LGMNavigationViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMNavigationViewController.h"
#import "LGMSettingsViewController.h"
#import "LGMWalktroughViewController.h"
#import "LGMDocumentManager.h"

@interface LGMNavigationViewController ()

@property (nonatomic, strong) NSArray *resolutionViewControllerList;

@end

@implementation LGMNavigationViewController

- (id)init {
    self = [super init];
    if (self) {
        LGMResolutionListViewController *resolutionListDaily = [[LGMResolutionListViewController alloc] initWithFrequency:LGMResolutionFrequencyDaily delegate:self];
        UINavigationController *resolutionListDailyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListDaily];
        
        LGMResolutionListViewController *resolutionListViewWeekly = [[LGMResolutionListViewController alloc] initWithFrequency:LGMResolutionFrequencyWeekly delegate:self];
        UINavigationController *resolutionListWeeklyNav = [[UINavigationController alloc] initWithRootViewController:resolutionListViewWeekly];
        
        LGMResolutionListViewController *resolutionListViewMonthly = [[LGMResolutionListViewController alloc] initWithFrequency:LGMResolutionFrequencyMonthly delegate:self];
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
    
    
    // Present the walktrough if the database contains no resolutions
    
    NSManagedObjectContext *managedObjectContext = [LGMDocumentManager sharedDocument].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Resolution"];
    [request setIncludesSubentities:NO];
    
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    if (count == 0) {
        LGMWalktroughViewController *walktroughViewController = [[LGMWalktroughViewController alloc] init];
        [self presentViewController:walktroughViewController animated:NO completion:NULL];
    }
}

- (IBAction)didSelectDaily:(id)sender {
    [self presentResolutionListWithFrequency:LGMResolutionFrequencyDaily animated:YES];
}

- (IBAction)didSelectWeekly:(id)sender {
    [self presentResolutionListWithFrequency:LGMResolutionFrequencyWeekly animated:YES];
}

- (IBAction)didSelectMonthly:(id)sender {
    [self presentResolutionListWithFrequency:LGMResolutionFrequencyMonthly animated:YES];
}

- (IBAction)didSelectSettings:(id)sender {
    LGMSettingsViewController *settingsViewController = [[LGMSettingsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)presentResolutionListWithFrequency:(LGMResolutionFrequency)type animated:(BOOL)animated {
    
    //TODO: temporary
    UIViewController *viewController = [_resolutionViewControllerList objectAtIndex:type];
    [self presentViewController:viewController animated:animated completion:NULL];
}

- (void)showMenuAnimated:(BOOL)animated {
    
    //TODO: temporary
    [self.presentedViewController dismissViewControllerAnimated:animated completion:NULL];
}

@end
