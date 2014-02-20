//
//  LGMResolution.m
//  Streak
//
//  Created by Ludovic Landry on 2/15/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import "LGMResolution.h"
#import "LGMCategory.h"

@implementation LGMResolution

@dynamic identifier;
@dynamic title;
@dynamic category;
@dynamic frequency;
@dynamic streakCount;
@dynamic lastCheckDate;

+ (NSString *)frequencyNameFromFrequency:(LGMResolutionFrequency)frequency {
    switch (frequency) {
        case LGMResolutionFrequencyDaily: return NSLocalizedString(@"Daily", nil); break;
        case LGMResolutionFrequencyWeekly: return NSLocalizedString(@"Weekly", nil); break;
        case LGMResolutionFrequencyMonthly: return NSLocalizedString(@"Monthly", nil); break;
        default: return nil; break;
    }
}

@end
