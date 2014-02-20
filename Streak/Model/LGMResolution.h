//
//  LGMResolution.h
//  Streak
//
//  Created by Ludovic Landry on 2/15/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, LGMResolutionFrequency) {
    LGMResolutionFrequencyDaily = 0,
    LGMResolutionFrequencyWeekly,
    LGMResolutionFrequencyMonthly
};

@class LGMCategory;

@interface LGMResolution : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) LGMCategory *category;
@property (nonatomic, strong) NSNumber *frequency;
@property (nonatomic, strong) NSNumber *streakCount;
@property (nonatomic, strong) NSDate *lastCheckDate;

+ (NSString *)frequencyNameFromFrequency:(LGMResolutionFrequency)frequency;

@end
