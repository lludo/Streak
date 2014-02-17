//
//  LGMCategory.m
//  Streak
//
//  Created by Ludovic Landry on 2/15/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import "LGMCategory.h"
#import "LGMResolution.h"

@implementation LGMCategory

@dynamic identifier;
@dynamic title;
@dynamic resolutionSet;

- (UIImage *)iconWalkthroughPressed:(BOOL)isPressed {
    return [self iconSize:@"walkthrough" statePressed:isPressed];
}

- (UIImage *)iconSmallPressed:(BOOL)isPressed {
    return [self iconSize:@"small" statePressed:isPressed];
}

- (UIImage *)iconBigPressed:(BOOL)isPressed {
    return [self iconSize:@"big" statePressed:isPressed];
}

- (UIImage *)iconSize:(NSString *)size statePressed:(BOOL)isPressed {
    if ([size isEqualToString:@"small"]) {
        NSString *pressed = (isPressed) ? @"pink" : @"grey";
        NSString *iconName = [NSString stringWithFormat:@"icon_%@_small_%@", self.identifier, pressed];
        return [UIImage imageNamed:iconName];
    } else {
        NSString *pressed = (isPressed) ? @"_press" : @"";
        NSString *iconName = [NSString stringWithFormat:@"icon_%@_%@_pink%@", self.identifier, size, pressed];
        return [UIImage imageNamed:iconName];
    }
}

@end
