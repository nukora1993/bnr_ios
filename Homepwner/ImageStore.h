//
//  ImageStore.h
//  Homepwner
//
//  Created by nuko on 2020/6/9.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageStore : NSObject
+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;




@end

NS_ASSUME_NONNULL_END
