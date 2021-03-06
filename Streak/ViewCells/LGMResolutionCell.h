//
//  LGMResolutionCell.h
//  Streak
//
//  Created by Ludovic Landry on 12/30/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

static NSString * const kResolutionCellReusableIdentifier = @"ResolutionCellReusableIdentifier";

@interface LGMResolutionCell : SWTableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *categoryIconImageView;
@property (nonatomic, strong) IBOutlet UILabel *resolutionTitle;
@property (nonatomic, strong) IBOutlet UILabel *resolutionStreak;
@property (nonatomic, strong) IBOutlet UIImageView *streakIconImageView;

@end
