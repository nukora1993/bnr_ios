//
//  DetailViewController.h
//  Homepwner
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic, strong) Item *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end

NS_ASSUME_NONNULL_END
