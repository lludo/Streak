//
//  LGMResolutionListViewController.h
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMResolutionListViewControllerDelegate.h"
#import "LGMResolution.h"

@interface LGMResolutionListViewController : UIViewController

@property (nonatomic, strong) id<LGMResolutionListViewControllerDelegate> delegate;
@property (nonatomic, assign, readonly) LGMResolutionFrequency frequency;

- (id)initWithFrequency:(LGMResolutionFrequency)frequency delegate:(id<LGMResolutionListViewControllerDelegate>)delegate;

- (IBAction)addResolution:(id)sender;

@end
