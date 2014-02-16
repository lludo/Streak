//
//  LGMAppDelegate.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMAppDelegate.h"
#import "LGMNavigationViewController.h"
#import "LGMDocumentManager.h"
#import "LGMCategory.h"
#import "LGMAppearance.h"
#import "UIColor+Hex.h"

@interface LGMAppDelegate ()

@property (nonatomic, strong) LGMNavigationViewController *menuViewController;

@end

@implementation LGMAppDelegate

@synthesize menuViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Load appearance
    [LGMAppearance loadAppearance];
    
    // Set the tint color
    self.window.tintColor = [UIColor colorWithHexString:@"#fe5953" alpha:1.f];
    
    // Setup the model
    [self setupDataModel];
    
    // Initialize the window and the menu view controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.menuViewController = [[LGMNavigationViewController alloc] init];
    self.window.rootViewController = self.menuViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Setupd data model

- (void)setupDataModel {
    NSManagedObjectContext *managedObjectContext = [LGMDocumentManager sharedDocument].managedObjectContext;
    
    
    // Test if the categories have already been initialized in the model
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    NSArray *categories = [managedObjectContext executeFetchRequest:request error:NULL];
    if ([categories count] != 0) {
        return;
    }
    
    
    // If not already initialized, initialize it
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"business";
        category.title = @"Business";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"challenge";
        category.title = @"Challenge";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"entertainment";
        category.title = @"Entertainment";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"finance";
        category.title = @"Finance";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"fooddrink";
        category.title = @"Food & Drink";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"health";
        category.title = @"Health";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"misc";
        category.title = @"Misc";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"productivity";
        category.title = @"Productivity";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"social";
        category.title = @"Social";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"sport";
        category.title = @"Sport";
    }
    
    {
        LGMCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category"
                                                              inManagedObjectContext:managedObjectContext];
        category.identifier = @"travel";
        category.title = @"Travel";
    }
    
    [[LGMDocumentManager sharedDocument] save];
}

@end
