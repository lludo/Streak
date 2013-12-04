//
//  LGMMenuViewController.h
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMResolutionListViewController.h"
#import "LGMResolutionListViewControllerDelegate.h"

@interface LGMMenuViewController : UIViewController <LGMResolutionListViewControllerDelegate>

- (void)showMenuAnimated:(BOOL)animated;
- (void)presentResolutionListWithType:(LGMResolutionListType)type animated:(BOOL)animated;

@end
