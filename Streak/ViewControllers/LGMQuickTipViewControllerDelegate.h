//
//  LGMQuickTipViewControllerDelegate.h
//  Streak
//
//  Created by Ludovic Landry on 2/20/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGMQuickTipViewController;

@protocol LGMQuickTipViewControllerDelegate <NSObject>

- (void)dismissQuickTip:(LGMQuickTipViewController *)quickTip;

@end
