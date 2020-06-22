//
//  Item.h
//  RandomItems
//
//  Created by nuko on 2020/6/7.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Item : NSObject <NSCoding>

//{
//    NSString *_itemName;
//    NSString *_serialNumber;
//    int _valueInDollars;
//    NSDate *_dateCreated;
//
//    Item *_containedItem;
//    __weak Item *_container;
//}
//@property (nonatomic, strong) Item *containedItem;
//@property (nonatomic, weak) Item *container;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
// item key for image
@property (nonatomic, copy) NSString *itemKey;
// thumbnail image
@property (nonatomic, strong) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;


+ (instancetype)randomItem;

// designated initializer
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;
//
//- (void)setContainedItem:(Item *)item;
//- (Item *)containedItem;
//
//- (void)setContainer:(Item *)item;
//- (Item *)container;
//
//- (void)setItemName:(NSString *)str;
//- (NSString *)itemName;
//
//- (void)setSerialNumber:(NSString *)str;
//- (NSString *)serialNumber;
//
//- (void)setValueInDollars:(int)v;
//- (int)valueInDollars;
//
//- (NSDate *)dateCreated;
@end

NS_ASSUME_NONNULL_END
