//
//  UIButton+Stretch.m
//  Streak
//
//  Created by Ludovic Landry on 12/31/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "UIButton+Stretch.h"

@implementation UIButton (Stretch)

- (void)stretchBackgroundImageWithLeftCapWidth:(NSUInteger)leftCapWidth topCapHeight:(NSUInteger)topCapHeight {
    UIImage *backbgoundImage = [self backgroundImageForState:UIControlStateNormal];
    backbgoundImage = [backbgoundImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    [self setBackgroundImage:backbgoundImage forState:UIControlStateNormal];
}

@end
