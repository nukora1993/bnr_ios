//
//  Item.h
//  Homepwner
//
//  Created by nuko on 2020/6/12.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@import CoreData;
@interface Item : NSManagedObject

@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *itemKey;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
