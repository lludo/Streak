//
//  LGMCategory.h
//  Streak
//
//  Created by Ludovic Landry on 2/9/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMCategory : NSObject

@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString *)name;

- (UIImage *)iconWalkthroughPressed:(BOOL)isPressed;
- (UIImage *)iconSmallPressed:(BOOL)isPressed;
- (UIImage *)iconBigPressed:(BOOL)isPressed;

@end
