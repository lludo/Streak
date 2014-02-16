//
//  LGMWalktroughViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/30/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMWalktroughViewController.h"
#import "LGMCategoryCell.h"
#import "LGMCategory.h"

@interface LGMWalktroughViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) IBOutlet UIView *welcomeContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *welcomeLogoImageView;
@property (nonatomic, strong) IBOutlet UILabel *welcomeTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *welcomeSubtitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *createResolutionButton;
@property (nonatomic, strong) IBOutlet UIButton *skipButton;

@property (nonatomic, strong) IBOutlet UIView *resolutionNameContainerView;
@property (nonatomic, strong) IBOutlet UILabel *resolutionNameTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *resolutionNameTextField;
@property (nonatomic, strong) IBOutlet UIView *resolutionKeyboardBackgroundView;
@property (nonatomic, strong) IBOutlet UIButton *resolutionChooseNameButton;

@property (nonatomic, strong) IBOutlet UIView *resolutionCategoryContainerView;
@property (nonatomic, strong) IBOutlet UILabel *resolutionCategoryTitleLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *categoryCollectionView;
@property (nonatomic, strong) IBOutlet UIButton *resolutionChooseCategoryButton;

@property (nonatomic, strong) IBOutlet UIView *resolutionFrequencyContainerView;
@property (nonatomic, strong) IBOutlet UILabel *resolutionFrequencyTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *resolutionFrequencyDailyButton;
@property (nonatomic, strong) IBOutlet UIButton *resolutionFrequencyWeeklyButton;
@property (nonatomic, strong) IBOutlet UIButton *resolutionFrequencyMonthlyButton;
@property (nonatomic, strong) IBOutlet UIButton *resolutionFinishButton;


@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, strong) NSString *resolutionName;
@property (nonatomic, strong) LGMCategory *selectedCategory;
@property (nonatomic, strong) NSString *frequency;

@end

@implementation LGMWalktroughViewController

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customisation
    
    self.welcomeTitleLabel.font = [UIFont streakLightFontOfSize:23.0];
    self.welcomeSubtitleLabel.font = [UIFont streakLightFontOfSize:16.0];
    self.createResolutionButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    self.skipButton.titleLabel.font = [UIFont streakRegularFontOfSize:14.0];
    
    self.resolutionNameTitleLabel.font = [UIFont streakLightFontOfSize:23.0];
    self.resolutionNameTextField.font = [UIFont streakLightFontOfSize:23.0];
    self.resolutionChooseNameButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    
    self.resolutionCategoryTitleLabel.font = [UIFont streakLightFontOfSize:23.0];
    self.resolutionChooseCategoryButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    
    self.resolutionFrequencyTitleLabel.font = [UIFont streakLightFontOfSize:23.0];
    self.resolutionFrequencyDailyButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    self.resolutionFrequencyWeeklyButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    self.resolutionFrequencyMonthlyButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    self.resolutionFinishButton.titleLabel.font = [UIFont streakRegularFontOfSize:18.0];
    
    
    // Configure category list
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(160.0, 198.0);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    [self.categoryCollectionView setCollectionViewLayout:flowLayout];
    [self.categoryCollectionView registerNib:[UINib nibWithNibName:@"LGMCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"kCategoryCellReuseIdentifier"];
    
    self.categories = @[
        [[LGMCategory alloc] initWithName:@"Business"],
        [[LGMCategory alloc] initWithName:@"Challenge"],
        [[LGMCategory alloc] initWithName:@"Entertainment"],
        [[LGMCategory alloc] initWithName:@"Finance"],
        [[LGMCategory alloc] initWithName:@"Food Drink"],
        [[LGMCategory alloc] initWithName:@"Health"],
        [[LGMCategory alloc] initWithName:@"Misc"],
        [[LGMCategory alloc] initWithName:@"Productivity"],
        [[LGMCategory alloc] initWithName:@"Social"],
        [[LGMCategory alloc] initWithName:@"Sport"],
        [[LGMCategory alloc] initWithName:@"Travel"]
    ];
    
    [self.categoryCollectionView reloadData];
    
    [self.resolutionNameTextField addTarget:self action:@selector(textFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.welcomeLogoImageView.alpha = 0.0;
    self.welcomeTitleLabel.alpha = 0.0;
    self.welcomeSubtitleLabel.alpha = 0.0;
    self.createResolutionButton.alpha = 0.0;
    self.skipButton.alpha = 0.0;
    
    self.welcomeLogoImageView.transform = CGAffineTransformMakeTranslation(0.0, 90.0);
    self.resolutionKeyboardBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, 216.0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.welcomeLogoImageView.alpha = 1.0;
        [UIView animateWithDuration:0.6 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.skipButton.alpha = 1.0;
        } completion:NULL];
        [UIView animateWithDuration:0.6 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.createResolutionButton.alpha = 1.0;
        } completion:NULL];
        [UIView animateWithDuration:0.6 delay:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.welcomeSubtitleLabel.alpha = 1.0;
        } completion:NULL];
        [UIView animateWithDuration:0.6 delay:1.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.welcomeTitleLabel.alpha = 1.0;
        } completion:NULL];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.welcomeLogoImageView.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }];
}

#pragma mark Welcome View

- (IBAction)createResolution:(id)sender {
    
    // Transitions out
    
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.welcomeLogoImageView.transform = CGAffineTransformMakeTranslation(-100.0, 0.0);
        self.welcomeLogoImageView.alpha = 0.0;
        self.createResolutionButton.transform = CGAffineTransformMakeTranslation(-100.0, 0.0);
        self.createResolutionButton.alpha = 0.0;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.skipButton.transform = CGAffineTransformMakeTranslation(-100.0, 0.0);
        self.skipButton.alpha = 0.0;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.welcomeTitleLabel.transform = CGAffineTransformMakeTranslation(-100.0, 0.0);
        self.welcomeTitleLabel.alpha = 0.0;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.welcomeSubtitleLabel.transform = CGAffineTransformMakeTranslation(-100.0, 0.0);
        self.welcomeSubtitleLabel.alpha = 0.0;
    } completion:NULL];
    
    
    // Transitions in
    
    self.resolutionNameTitleLabel.alpha = 0.0;
    self.resolutionNameTextField.alpha = 0.0;
    self.resolutionChooseNameButton.alpha = 0.0;
    self.resolutionNameTitleLabel.transform = CGAffineTransformMakeTranslation(100, 0);
    self.resolutionNameTextField.transform = CGAffineTransformMakeTranslation(100, 0);
    [self.view addSubview:self.resolutionNameContainerView];
    
    [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionNameTitleLabel.alpha = 1.0;
        self.resolutionNameTitleLabel.transform = CGAffineTransformIdentity;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionNameTextField.alpha = 1.0;
        self.resolutionNameTextField.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.resolutionNameTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    }];
}

- (IBAction)skip:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Resolution Name View

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.resolutionKeyboardBackgroundView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.resolutionKeyboardBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, 216.0);
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

- (IBAction)textFieldDidChange:(id)sender {
    BOOL isEmpty = [self.resolutionNameTextField.text length] == 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.resolutionChooseNameButton.alpha = (!isEmpty) ? 1 : 0;
    }];
}

- (IBAction)chooseName:(id)sender {
    
    // Transitions out
    
    [self.resolutionNameTextField resignFirstResponder];
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.resolutionNameTitleLabel.alpha = 0.0;
        self.resolutionNameTitleLabel.transform = CGAffineTransformMakeTranslation(-100, 0);;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.resolutionNameTextField.alpha = 0.0;
        self.resolutionNameTextField.transform = CGAffineTransformMakeTranslation(-100, 0);;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.resolutionChooseNameButton.alpha = 0.0;
        self.resolutionChooseNameButton.transform = CGAffineTransformMakeTranslation(-100, 0);;
    } completion:NULL];
    
    
    // Transitions in
    
    self.resolutionCategoryTitleLabel.alpha = 0.0;
    self.categoryCollectionView.alpha = 0.0;
    self.resolutionChooseCategoryButton.alpha = 0.0;
    self.resolutionCategoryTitleLabel.transform = CGAffineTransformMakeTranslation(100, 0);
    self.categoryCollectionView.transform = CGAffineTransformMakeTranslation(100, 0);
    [self.view addSubview:self.resolutionCategoryContainerView];
    
    [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionCategoryTitleLabel.alpha = 1.0;
        self.resolutionCategoryTitleLabel.transform = CGAffineTransformIdentity;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.categoryCollectionView.alpha = 1.0;
        self.categoryCollectionView.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

#pragma mark Resolution Category View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGMCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCategoryCellReuseIdentifier" forIndexPath:indexPath];
    LGMCategory *category = [self.categories objectAtIndex:indexPath.row];
    
    BOOL isSelected = (self.selectedCategory == category);
    
    cell.categoryNameLabel.text = category.name;
    cell.categoryNameLabel.font = [UIFont streakRegularFontOfSize:16.0];
    cell.categoryImageView.image = [category iconWalkthroughPressed:isSelected];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LGMCategory *category = [self.categories objectAtIndex:indexPath.row];
    self.selectedCategory = (self.selectedCategory == category) ? nil : category;
    
    [self.categoryCollectionView reloadData];
    [self refreshCategoryButtonsState];
}

- (void)refreshCategoryButtonsState {
    [UIView animateWithDuration:0.3 animations:^{
        self.resolutionChooseCategoryButton.alpha = (self.selectedCategory != nil) ? 1 : 0;
    }];
}

- (IBAction)chooseCategory:(id)sender {
    
    // Transitions out
    
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.resolutionCategoryTitleLabel.alpha = 0.0;
        self.resolutionCategoryTitleLabel.transform = CGAffineTransformMakeTranslation(-100, 0);;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.categoryCollectionView.alpha = 0.0;
        self.categoryCollectionView.transform = CGAffineTransformMakeTranslation(-100, 0);;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.resolutionChooseCategoryButton.alpha = 0.0;
        self.resolutionChooseCategoryButton.transform = CGAffineTransformMakeTranslation(-100, 0);;
    } completion:NULL];
    
    
    // Transitions in
    
    self.resolutionFrequencyTitleLabel.alpha = 0.0;
    self.resolutionFrequencyDailyButton.alpha = 0.0;
    self.resolutionFrequencyWeeklyButton.alpha = 0.0;
    self.resolutionFrequencyMonthlyButton.alpha = 0.0;
    self.resolutionFinishButton.alpha = 0.0;
    self.resolutionFrequencyTitleLabel.transform = CGAffineTransformMakeTranslation(100, 0);
    self.resolutionFrequencyDailyButton.transform = CGAffineTransformMakeTranslation(100, 0);
    self.resolutionFrequencyWeeklyButton.transform = CGAffineTransformMakeTranslation(100, 0);
    self.resolutionFrequencyMonthlyButton.transform = CGAffineTransformMakeTranslation(100, 0);
    [self.view addSubview:self.resolutionFrequencyContainerView];
    
    [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionFrequencyTitleLabel.alpha = 1.0;
        self.resolutionFrequencyTitleLabel.transform = CGAffineTransformIdentity;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.63 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionFrequencyDailyButton.alpha = 1.0;
        self.resolutionFrequencyDailyButton.transform = CGAffineTransformIdentity;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.66 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionFrequencyWeeklyButton.alpha = 1.0;
        self.resolutionFrequencyWeeklyButton.transform = CGAffineTransformIdentity;
    } completion:NULL];
    [UIView animateWithDuration:0.6 delay:0.60 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.resolutionFrequencyMonthlyButton.alpha = 1.0;
        self.resolutionFrequencyMonthlyButton.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

#pragma mark Resolution Frequency View

- (IBAction)chooseDailyButton:(id)sender {
    self.frequency = @"daily";
    [self refreshFrequencyButtonsState];
    [self refreshFinishButtonState];
}

- (IBAction)chooseWeeklyButton:(id)sender {
    self.frequency = @"weekly";
    [self refreshFrequencyButtonsState];
    [self refreshFinishButtonState];
}

- (IBAction)chooseMonthlyButton:(id)sender {
    self.frequency = @"monthly";
    [self refreshFrequencyButtonsState];
    [self refreshFinishButtonState];
}

- (void)setFrequency:(NSString *)frequency {
    _frequency = ([_frequency isEqualToString:frequency]) ? nil : frequency;
}

- (void)refreshFrequencyButtonsState {
    if ([self.frequency isEqualToString:@"daily"]) {
        self.resolutionFrequencyDailyButton.selected = YES;
        self.resolutionFrequencyWeeklyButton.selected = NO;
        self.resolutionFrequencyMonthlyButton.selected = NO;
    } else if ([self.frequency isEqualToString:@"weekly"]) {
        self.resolutionFrequencyDailyButton.selected = NO;
        self.resolutionFrequencyWeeklyButton.selected = YES;
        self.resolutionFrequencyMonthlyButton.selected = NO;
    } else if ([self.frequency isEqualToString:@"monthly"]) {
        self.resolutionFrequencyDailyButton.selected = NO;
        self.resolutionFrequencyWeeklyButton.selected = NO;
        self.resolutionFrequencyMonthlyButton.selected = YES;
    } else {
        self.resolutionFrequencyDailyButton.selected = NO;
        self.resolutionFrequencyWeeklyButton.selected = NO;
        self.resolutionFrequencyMonthlyButton.selected = NO;
    }
}

- (void)refreshFinishButtonState {
    [UIView animateWithDuration:0.3 animations:^{
        self.resolutionFinishButton.alpha = (self.frequency != nil) ? 1 : 0;
    }];
}

- (IBAction)finish:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
