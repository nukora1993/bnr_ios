//
//  ItemsViewController.m
//  Homepwner
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemStore.h"
#import "Item.h"
#import "DetailViewController.h"
#import "ItemCell.h"
#import "ImageStore.h"
#import "ImageViewController.h"
@interface ItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>
// we set it as strong because header view is top level in xib
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation ItemsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.tableView reloadData];
    [self updateTableViewForDynamicTypeSize];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view{
    NSString *identifier = nil;
    
    if (idx && view) {
        Item *item = [[ItemStore sharedStore] allItems][idx.row];
        identifier = item.itemKey;
    }
    
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view{
    NSIndexPath *indexPath = nil;
    
    if (identifier && view) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        for (Item *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                long row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    
    return indexPath;
}

- (void)updateTableViewForDynamicTypeSize{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{
            UIContentSizeCategoryExtraSmall : @44,
            UIContentSizeCategorySmall : @44,
            UIContentSizeCategoryMedium : @44,
            UIContentSizeCategoryLarge : @44,
            UIContentSizeCategoryExtraLarge : @55,
            UIContentSizeCategoryExtraExtraLarge : @65,
            UIContentSizeCategoryExtraExtraExtraLarge : @75
        };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    // set row height
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    Item *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

# pragma mark -header button
- (IBAction)addNewItem:(id)sender{
//    NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    // we create and store item in item store
    Item *newItem = [[ItemStore sharedStore] createItem];
    
//    NSInteger lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:newItem];
//
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    // restoration id, but has no class
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
//    navController.modalPresentationStyle = UIModalPresentationPageSheet;
//    navController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    self.definesPresentationContext = YES;
    
    [self presentViewController:navController animated:YES completion:nil];
}

//- (IBAction)toggleEditingMode:(id)sender{
//    if (self.isEditing) {
//        
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        
//        [self setEditing:NO animated:YES];
//    }else{
//        
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        
//        [self setEditing:YES animated:YES];
//    }
//}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder{
    return [[self alloc] init];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        Item *item = items[indexPath.row];
        [[ItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//- (UIView *)headerView{
//    if (!_headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//
//    return _headerView;
//}





// we set our designated initializer
- (instancetype)init{
    // call super designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//        for (int i=0; i<5; i++) {
//            [[ItemStore sharedStore] createItem];
//        }
        UINavigationItem *navItem = self.navigationItem;
//        navItem.title = @"Homepwner";
        
        navItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
        
        // restoration id
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // nav bar button item
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        [nc addObserver:self selector:@selector(localeChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)localeChanged:(NSNotification *)note{
    [self.tableView reloadData];
}

- (void)dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    // call our designated initializer
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // we custom our cell, so we need load it
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // alert view test
//    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Title" message:@"message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
//    [a show];
    
    // some view can also has restoration id, just like vc, we just give it id
    self.tableView.restorationIdentifier = @"ItemsViewControllerTableView";
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ItemStore sharedStore] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"UITableViewCell"];
    
    // get from reuse pool
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    Item *item = items[indexPath.row];
    
//    cell.textLabel.text = [item description];
    
    // configure custom cell view
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    // localize
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
//    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    
    cell.thumbnailView.image = item.thumbnail;
    
    // prevent ref loop
    __weak ItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        // prevent from being destroyed when running
        ItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            
            UIImage *img = [[ImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
//            CGRect rect = [self.view convertRect:cell.thumbnailView.bounds toView:cell.thumbnailView];
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds toView:strongCell.thumbnailView];
            
            ImageViewController *ivc = [[ImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            
        }
    };
    
    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.imagePopover = nil;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
