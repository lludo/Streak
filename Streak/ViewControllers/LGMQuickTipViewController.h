//
//  LGMQuickTipViewController.h
//  Streak
//
//  Created by Ludovic Landry on 2/20/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMQuickTipViewControllerDelegate.h"

@interface LGMQuickTipViewController : UIViewController

- (id)initWithDelegate:(id<LGMQuickTipViewControllerDelegate>)delegate;

@end
