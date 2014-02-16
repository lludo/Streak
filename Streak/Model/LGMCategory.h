//
//  LGMCategory.h
//  Streak
//
//  Created by Ludovic Landry on 2/15/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LGMResolution;

@interface LGMCategory : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSSet *resolutionSet;

- (UIImage *)iconWalkthroughPressed:(BOOL)isPressed;
- (UIImage *)iconSmallPressed:(BOOL)isPressed;
- (UIImage *)iconBigPressed:(BOOL)isPressed;

@end

@interface LGMCategory (CoreDataGeneratedAccessors)

- (void)addResolutionSetObject:(LGMResolution *)value;
- (void)removeResolutionSetObject:(LGMResolution *)value;
- (void)addResolutionSet:(NSSet *)values;
- (void)removeResolutionSet:(NSSet *)values;

@end
