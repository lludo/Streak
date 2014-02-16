//
//  LGMNavigationViewController.h
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMResolutionListViewController.h"
#import "LGMResolutionListViewControllerDelegate.h"

@interface LGMNavigationViewController : UIViewController <LGMResolutionListViewControllerDelegate>

- (void)showMenuAnimated:(BOOL)animated;
- (void)presentResolutionListWithFrequency:(LGMResolutionFrequency)frequency animated:(BOOL)animated;

@end
