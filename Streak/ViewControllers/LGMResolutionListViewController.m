//
//  LGMResolutionListViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMResolutionListViewController.h"
#import "LGMResolutionCreateViewController.h"
#import "LGMQuickTipViewControllerDelegate.h"
#import "LGMQuickTipViewController.h"
#import "LGMDocumentManager.h"
#import "LGMResolutionCell.h"
#import "LGMAppDelegate.h"
#import "LGMCategory.h"
#import "UIColor+Hex.h"

typedef NS_ENUM(NSUInteger, LGMResolutionListTodoAction) {
    LGMResolutionListTodoActionTrash = 0,
    LGMResolutionListTodoActionReminder,
    LGMResolutionListTodoActionCheck
};

typedef NS_ENUM(NSUInteger, LGMResolutionListDoneAction) {
    LGMResolutionListDoneActionTrash = 0,
    LGMResolutionListDoneActionUndo
};

@interface LGMResolutionListViewController () <UITabBarDelegate, UITableViewDataSource, SWTableViewCellDelegate, LGMQuickTipViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *emptyListTodoView;
@property (nonatomic, strong) IBOutlet UILabel *emptyListTodoTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *emptyListTodoSubtitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *emptyListTodoCreateButton;

@property (nonatomic, strong) IBOutlet UIView *emptyListDoneView;
@property (nonatomic, strong) IBOutlet UILabel *emptyListDoneTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *emptyListDoneSubtitleLabel;

@property (nonatomic, assign) LGMResolutionFrequency frequency;
@property (nonatomic, assign) BOOL isDisplayingTodoResolutions;
@property (nonatomic, strong) NSMutableArray *resolutions;

@end

@implementation LGMResolutionListViewController

- (id)initWithFrequency:(LGMResolutionFrequency)frequency delegate:(id<LGMResolutionListViewControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        _frequency = frequency;
        _delegate = delegate;
        _isDisplayingTodoResolutions = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Build the segmented control for filter
    
    NSArray *items = @[[UIImage imageNamed:@"switch-mask-all"], [UIImage imageNamed:@"switch-mask-done"]];
    UISegmentedControl *filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    [filterSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    filterSegmentedControl.frame = CGRectMake(0, 0, 126, 30);
    filterSegmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = filterSegmentedControl;
    
    
    // Build the menu button
    
    NSString *menuButtonTitle = [[LGMResolution frequencyNameFromFrequency:self.frequency] uppercaseString];
    
    UIButton *menuButtonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButtonButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [menuButtonButton setTitleColor:[UIColor colorWithWhite:0.696 alpha:1.000] forState:UIControlStateHighlighted];
    menuButtonButton.titleLabel.font = [UIFont streakBoldFontOfSize:12.0];
    [menuButtonButton setTitle:menuButtonTitle forState:UIControlStateNormal];
    [menuButtonButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menuButtonButton sizeToFit];
    
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonButton];
    self.navigationItem.leftBarButtonItem = menuButtonItem;
    
    
    // Add resolution button
    
    UIImage *resolutionAddImage = [[UIImage imageNamed:@"resolution-button-add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithImage:resolutionAddImage style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(addResolution:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    
    // Customisation
    
    self.emptyListTodoTitleLabel.font = [UIFont streakLightFontOfSize:21.0];
    self.emptyListTodoSubtitleLabel.font = [UIFont streakRegularFontOfSize:15.0];
    self.emptyListTodoCreateButton.titleLabel.font = [UIFont streakRegularFontOfSize:15.0];
    
    self.emptyListDoneTitleLabel.font = [UIFont streakLightFontOfSize:21.0];
    self.emptyListDoneSubtitleLabel.font = [UIFont streakRegularFontOfSize:15.0];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadResolutions];
    [self.tableView reloadData];
    [self displayEmpltyViewIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    BOOL hasSeenQuickTip = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenQuickTip"];
    if (!hasSeenQuickTip) {
        LGMQuickTipViewController *quickTipViewController = [[LGMQuickTipViewController alloc] initWithDelegate:self];
    
        [self.navigationController addChildViewController:quickTipViewController];
        quickTipViewController.view.frame = self.navigationController.view.frame;
        [self.navigationController.view addSubview:quickTipViewController.view];
        [quickTipViewController didMoveToParentViewController:self.navigationController];
    
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"hasSeenQuickTip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)showMenu:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(showMenuAnimated:)]) {
        [_delegate showMenuAnimated:YES];
    }
}

- (IBAction)addResolution:(id)sender {
    LGMResolutionCreateViewController *createViewController = [[LGMResolutionCreateViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)valueChanged:(id)sender {
    UISegmentedControl *filterSegmentedControl = sender;
    self.isDisplayingTodoResolutions = (filterSegmentedControl.selectedSegmentIndex == 0);
    [self reloadResolutions];
    [self.tableView reloadData];
    [self displayEmpltyViewIfNeeded];
}

- (void)reloadResolutions {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *todayDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSString *predicateFormat = (self.isDisplayingTodoResolutions) ? @"frequency == %i AND (lastCheckDate == nil OR lastCheckDate != %@)" : @"frequency == %i AND lastCheckDate == %@";
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Resolution"];
    request.predicate = [NSPredicate predicateWithFormat:predicateFormat, self.frequency, todayDate];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSManagedObjectContext *managedObjectContext = [LGMDocumentManager sharedDocument].managedObjectContext;
    self.resolutions = [[managedObjectContext executeFetchRequest:request error:NULL] mutableCopy];
}

- (void)displayEmpltyViewIfNeeded {
    [self.emptyListTodoView removeFromSuperview];
    [self.emptyListDoneView removeFromSuperview];
    
    if ([self.resolutions count] == 0) {
        UIView *emptyListView = (self.isDisplayingTodoResolutions) ? self.emptyListTodoView : self.emptyListDoneView;
        [self.view addSubview:emptyListView];
    }
}

#pragma mark - LGMQuickTipViewController delegate

- (void)dismissQuickTip:(LGMQuickTipViewController *)quickTip {
    [quickTip willMoveToParentViewController:nil];
    [quickTip.view removeFromSuperview];
    [quickTip removeFromParentViewController];
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resolutions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    LGMResolutionCell *cell = [tableView dequeueReusableCellWithIdentifier:kResolutionCellReusableIdentifier];
    if (!cell) {
        UINib *tableViewCellNib = [UINib nibWithNibName:NSStringFromClass([LGMResolutionCell class]) bundle:nil];
        [self.tableView registerNib:tableViewCellNib forCellReuseIdentifier:kResolutionCellReusableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:kResolutionCellReusableIdentifier];
    }
    
    
    // Configure the cell
    
    __weak LGMResolutionCell *weakCell = cell;
    [cell setAppearanceWithBlock:^{
        weakCell.containingTableView = tableView;
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        if (self.isDisplayingTodoResolutions) {
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithWhite:0.251 alpha:1.000] icon:[UIImage imageNamed:@"picto_trash"]];
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithWhite:0.251 alpha:1.000] icon:[UIImage imageNamed:@"picto_reminder"]];
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithWhite:0.251 alpha:1.000] icon:[UIImage imageNamed:@"picto_check"]];
        } else {
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithWhite:0.251 alpha:1.000] icon:[UIImage imageNamed:@"picto_trash"]];
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithWhite:0.251 alpha:1.000] icon:[UIImage imageNamed:@"picto_undo"]];
        }
        
        weakCell.rightUtilityButtons = rightUtilityButtons;
        weakCell.delegate = self;
        
        weakCell.resolutionTitle.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        weakCell.resolutionTitle.font = [UIFont streakRegularFontOfSize:15.0];
        weakCell.resolutionStreak.font = [UIFont streakBoldFontOfSize:11.0];
    } force:YES];
    
    [cell setCellHeight:cell.frame.size.height];
    
    LGMResolution *resolution = [self.resolutions objectAtIndex:indexPath.row];
    cell.categoryIconImageView.image = [resolution.category iconSmallPressed:!self.isDisplayingTodoResolutions];
    cell.resolutionTitle.text = resolution.title;
    cell.resolutionStreak.text = [resolution.streakCount stringValue]; //TODO: use number formater here
    
    if (self.isDisplayingTodoResolutions) {
        cell.streakIconImageView.image = [UIImage imageNamed:@"picto_small_streak"];
        cell.resolutionStreak.textColor = [UIColor colorWithWhite:0.737 alpha:1.000];
    } else {
        cell.streakIconImageView.image = [UIImage imageNamed:@"picto_small_streak_selected"];
        cell.resolutionStreak.textColor = [UIColor colorWithHexString:@"#fe5953" alpha:1.f];
    }
    
    // Position on the right
    [cell.resolutionStreak sizeToFit];
    CGFloat resolutionStreakOriginX = cell.frame.size.width - cell.resolutionStreak.frame.size.width - 14;
    [cell.resolutionStreak setFrame:CGRectMake(resolutionStreakOriginX, cell.resolutionStreak.frame.origin.y,
                                               cell.resolutionStreak.frame.size.width, cell.resolutionStreak.frame.size.height)];
    CGFloat streakIconOriginX = resolutionStreakOriginX - 14;
    [cell.streakIconImageView setFrame:CGRectMake(streakIconOriginX, cell.streakIconImageView.frame.origin.y,
                                                  cell.streakIconImageView.frame.size.width, cell.streakIconImageView.frame.size.height)];
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //TODO: manage selection here
}

#pragma mark - SWTableViewCell delegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // Retrieve the cell and the resolution
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    LGMResolution *resolution = [self.resolutions objectAtIndex:cellIndexPath.row];
    
    if (self.isDisplayingTodoResolutions) {
        switch (index) {
            case LGMResolutionListTodoActionTrash: {
                [cell hideUtilityButtonsAnimated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trash" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case LGMResolutionListTodoActionReminder: {
                [cell hideUtilityButtonsAnimated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case LGMResolutionListTodoActionCheck: {
                
                // Check the resolution
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
                NSDate *todayDate = [[NSCalendar currentCalendar] dateFromComponents:components];
                
                resolution.lastCheckDate = todayDate;
                resolution.streakCount = @([resolution.streakCount integerValue] + 1);
                [[LGMDocumentManager sharedDocument] save];
                
                // Set pressed state
                [cell.rightUtilityButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
                    [button setBackgroundColor:[UIColor colorWithHexString:@"#fe5953" alpha:1.f]];
                    button.enabled = (index == idx);
                }];
                
                // Remove it from the list
                [self.resolutions removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self performSelector:@selector(displayEmpltyViewIfNeeded) withObject:nil afterDelay:0.3];
                
                break;
            }
            default: break;
        }
    } else {
        switch (index) {
            case LGMResolutionListDoneActionTrash: {
                [cell hideUtilityButtonsAnimated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trash" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case LGMResolutionListDoneActionUndo: {
                
                // Unheck the resolution
                resolution.lastCheckDate = nil;
                resolution.streakCount = @([resolution.streakCount integerValue] - 1);
                [[LGMDocumentManager sharedDocument] save];
                
                // Set pressed state
                [cell.rightUtilityButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
                    [button setBackgroundColor:[UIColor colorWithHexString:@"#fe5953" alpha:1.f]];
                    button.enabled = (index == idx);
                }];
                
                // Remove it from the list
                [self.resolutions removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self performSelector:@selector(displayEmpltyViewIfNeeded) withObject:nil afterDelay:0.3];
                
                break;
            }
            default: break;
        }
    }
}

@end
