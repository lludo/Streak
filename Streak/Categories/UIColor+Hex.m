//
//  UIColor+Hex.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    // Convert hex string to an integer
    unsigned int hexInt = [UIColor intFromHexString:hexString];
    
    // Create color object, specifying alpha as well
    UIColor *color = [UIColor colorWithRed:((CGFloat) ((hexInt & 0xFF0000) >> 16))/255
                                     green:((CGFloat) ((hexInt & 0xFF00) >> 8))/255
                                      blue:((CGFloat) (hexInt & 0xFF))/255
                                     alpha:alpha];
    
    return color;
}

+ (unsigned int)intFromHexString:(NSString *)hexStr {
    
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

@end
