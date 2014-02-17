//
//  LGMResolutionListViewController.m
//  Streak
//
//  Created by Ludovic Landry on 12/3/13.
//  Copyright (c) 2013 Little Green Men. All rights reserved.
//

#import "LGMResolutionListViewController.h"
#import "LGMResolutionCreateViewController.h"
#import "LGMDocumentManager.h"
#import "LGMResolutionCell.h"
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

@interface LGMResolutionListViewController () <UITabBarDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) LGMResolutionFrequency frequency;
@property (nonatomic, assign) BOOL isDisplayingTodoResolutions;
@property (nonatomic, strong) NSArray *resolutions;

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
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithTitle:menuButtonTitle style:UIBarButtonItemStyleBordered
                                                                      target:self action:@selector(showMenu:)];
    menuButtonItem.tintColor = [UIColor darkTextColor];
    self.navigationItem.leftBarButtonItem = menuButtonItem;
    
    // Add resolution button
    UIImage *resolutionAddImage = [[UIImage imageNamed:@"resolution-button-add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithImage:resolutionAddImage style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(addResolution:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadResolutions];
    [self.tableView reloadData];
}

- (void)showMenu:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(showMenuAnimated:)]) {
        [_delegate showMenuAnimated:YES];
    }
}

- (void)addResolution:(id)sender {
    LGMResolutionCreateViewController *createViewController = [[LGMResolutionCreateViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)valueChanged:(id)sender {
    UISegmentedControl *filterSegmentedControl = sender;
    self.isDisplayingTodoResolutions = (filterSegmentedControl.selectedSegmentIndex == 0);
    [self.tableView reloadData];
}

- (void)reloadResolutions {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Resolution"];
    request.predicate = [NSPredicate predicateWithFormat:@"frequency == %i", self.frequency];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSManagedObjectContext *managedObjectContext = [LGMDocumentManager sharedDocument].managedObjectContext;
    self.resolutions = [managedObjectContext executeFetchRequest:request error:NULL];
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
    cell.resolutionStreak.text = [resolution.streak stringValue]; //TODO: use number formater here
    
    if (self.isDisplayingTodoResolutions) {
        cell.streakIconImageView.image = [UIImage imageNamed:@"picto_small_streak"];
        cell.resolutionStreak.textColor = [UIColor colorWithWhite:0.737 alpha:1.000];
    } else {
        cell.streakIconImageView.image = [UIImage imageNamed:@"picto_small_streak_selected"];
        cell.resolutionStreak.textColor = [UIColor colorWithHexString:@"#fe5953" alpha:1.f];
    }
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //TODO: manage selection here
}

#pragma mark - SWTableViewCell delegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (self.isDisplayingTodoResolutions) {
        switch (index) {
            case LGMResolutionListTodoActionTrash: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trash" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case LGMResolutionListTodoActionReminder: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case LGMResolutionListTodoActionCheck: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            default: break;
        }
    } else {
        switch (index) {
            case LGMResolutionListDoneActionTrash: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trash" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            case LGMResolutionListDoneActionUndo: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo" message:@"//TODO: in developement"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                break;
            }
            default: break;
        }
    }
    
    [cell hideUtilityButtonsAnimated:YES];
}

@end
