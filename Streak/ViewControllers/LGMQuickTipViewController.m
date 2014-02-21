//
//  LGMQuickTipViewController.m
//  Streak
//
//  Created by Ludovic Landry on 2/20/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import "LGMQuickTipViewController.h"

@interface LGMQuickTipViewController ()

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;

@property (nonatomic, assign) id<LGMQuickTipViewControllerDelegate> delegate;

@end

@implementation LGMQuickTipViewController

- (id)initWithDelegate:(id<LGMQuickTipViewControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont streakLightFontOfSize:21.0];
    self.subtitleLabel.font = [UIFont streakRegularFontOfSize:15.0];
    self.doneButton.titleLabel.font = [UIFont streakLightFontOfSize:21.0];
    
    self.doneButton.alpha = 0.0;
    self.view.backgroundColor = [UIColor clearColor];
    self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.frame.origin.y - self.contentView.frame.size.height);
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.878 alpha:0.800];
    } completion:NULL];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.doneButton.alpha = 1.0;
        } completion:NULL];
    }];
}

- (IBAction)didClickDone:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.doneButton.alpha = 0.0;
    } completion:NULL];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.frame.origin.y + self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(dismissQuickTip:)]) {
            [self.delegate dismissQuickTip:self];
        }
    }];
}

@end
