//
//  ItemStore.m
//  Homepwner
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"
#import "ImageStore.h"
#import "AppDelegate.h"
@import CoreData;

@interface ItemStore ()


@property (nonatomic) NSMutableArray *privateItems;

@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation ItemStore

+ (instancetype)sharedStore{
    static ItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Signleton" reason:@"Use +[ItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate{
    self = [super init];
    if (self) {
//        _privateItems = [[NSMutableArray alloc] init];
        
//        NSString *path = [self itemArchivePath];
//        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//
//        if (!_privateItems) {
//            _privateItems = [[NSMutableArray alloc] init];
//        }
        
        // for core data
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // sqlite file
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        // psc need model and sql lite file
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        // core data context, created with psc
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        // load from core data
        [self loadAllItems];
    }
    NSLog(@"Item store has been created");
    return self;
}

// notice that we do not have _allItems, because we set it readonly and we implement the getter
- (NSArray *)allItems{
    return self.privateItems;
}

- (Item *)createItem{
//    Item *item = [Item randomItem];
//    Item *item = [[Item alloc] init];
    
    // add use core data
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    }else{
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %ld items, order = %.2f", [self.privateItems count], order);
    
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.valueInDollars = (int)[defaults integerForKey:NextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:NextItemNamePrefsKey];
    
    NSLog(@"defaults = %@", [defaults dictionaryRepresentation]);
    
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(Item *)item{
    NSString *key = item.itemKey;
    
    // sync with image store
    [[ImageStore sharedStore] deleteImageForKey:key];
    
    // it is odd, we can use context delete item, but we need use description to add item...
    [self.context deleteObject:item];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (fromIndex == toIndex) {
        return;
    }
    
    Item *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    [self.privateItems insertObject:item atIndex:toIndex];
    
    // update for core data
    double lowerBound = 0.0;
    
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    }else{
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    }else{
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue];
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    
    // for core data
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges{
//    NSString *path = [self itemArchivePath];
//
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    
    NSError *error;
    // just call save, the item will be save to database if it has been changed, because item is auto managed by core data
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    
    return successful;
}

- (void)dealloc
{
    NSLog(@"Item Store has been destroyed");
}

- (void)loadAllItems{
    if (!self.privateItems) {
        // we need a request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];;
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
        
    }
}

- (NSArray *)allAssetTypes{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"AssetType" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
            
        }
        
        _allAssetTypes = [result mutableCopy];
        
        // for first run, we add 3 asset type
        if ([_allAssetTypes count] == 0) {
            NSManagedObject *type;
            type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:self.context];
            
            // k-v coding
            [type setValue:@"Furniture" forKey:@"label"];
            [_allAssetTypes addObject:type];
            
            type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:self.context];
            
            [type setValue:@"Jewelry" forKey:@"label"];
            [_allAssetTypes addObject:type];
            
            type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:self.context];
            
            [type setValue:@"Electronics" forKey:@"label"];
            [_allAssetTypes addObject:type];
            
            
        }
       
    }
    return _allAssetTypes;
}
@end
