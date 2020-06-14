//
//  ItemStore.h
//  Homepwner
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item;


NS_ASSUME_NONNULL_BEGIN

@interface ItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;



+ (instancetype)sharedStore;
- (Item *)createItem;
- (void)removeItem:(Item *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

- (NSArray *)allAssetTypes;

- (BOOL)saveChanges;

@end

NS_ASSUME_NONNULL_END
