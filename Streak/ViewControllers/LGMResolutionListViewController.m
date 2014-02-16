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

@interface LGMResolutionListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) LGMResolutionFrequency frequency;
@property (nonatomic, strong) NSArray *resolutions;

@end

@implementation LGMResolutionListViewController

- (id)initWithFrequency:(LGMResolutionFrequency)frequency delegate:(id<LGMResolutionListViewControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        _frequency = frequency;
        _delegate = delegate;
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
    
    //TODO to finish
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
    LGMResolution *resolution = [self.resolutions objectAtIndex:indexPath.row];
    cell.categoryIcon.image = [resolution.category iconSmallPressed:NO];
    cell.resolutionTitle.text = resolution.title;
    cell.resolutionStreak.text = [resolution.streak stringValue]; //TODO: user number formater here
    
    /*
    [cell setAppearanceWithBlock:^{
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
        
        cell.rightUtilityButtons = rightUtilityButtons;
    } force:NO];
    */
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //TODO: manage selection here
}

@end
