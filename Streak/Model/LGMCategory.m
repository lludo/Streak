//
//  LGMCategory.m
//  Streak
//
//  Created by Ludovic Landry on 2/9/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import "LGMCategory.h"

@implementation LGMCategory

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

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
    
    NSString *nameParameter = [[self.name stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    NSString *pressedParameter = (isPressed) ? @"_press" : @"";
    
    NSString *iconName = [NSString stringWithFormat:@"icon_%@_%@_pink%@", nameParameter, size, pressedParameter];
    return [UIImage imageNamed:iconName];
}

@end
