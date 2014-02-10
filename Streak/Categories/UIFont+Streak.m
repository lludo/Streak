//
//  UIFont+Streak.m
//  Streak
//
//  Created by Ludovic Landry on 2/9/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import "UIFont+Streak.h"

@implementation UIFont (Streak)

+ (UIFont *)streakRegularFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
}

+ (UIFont *)streakBoldFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
}

+ (UIFont *)streakLightFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"ProximaNova-Light" size:fontSize];
}

@end
