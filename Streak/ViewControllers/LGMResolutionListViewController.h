//
//  LGMResolutionListViewController.h
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGMResolutionListViewControllerDelegate.h"

typedef NS_ENUM(NSUInteger, LGMResolutionListType) {
    LGMResolutionListTypeDaily = 0,
    LGMResolutionListTypeWeekly,
    LGMResolutionListTypeMonthly
};

@interface LGMResolutionListViewController : UIViewController

@property (nonatomic, strong) id<LGMResolutionListViewControllerDelegate> delegate;

@property (nonatomic, assign, readonly) LGMResolutionListType type;

- (id)initWithType:(LGMResolutionListType)type delegate:(id<LGMResolutionListViewControllerDelegate>)delegate;

@end
