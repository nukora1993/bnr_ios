//
//  ColorDescription.h
//  Colorboard
//
//  Created by nuko on 2020/6/14.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorDescription : NSObject

@property (nonatomic) UIColor *color;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
