//
//  ColorViewController.h
//  Colorboard
//
//  Created by nuko on 2020/6/14.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorViewController : UIViewController

@property (nonatomic) BOOL existingColor;
@property (nonatomic) ColorDescription *colorDescription;

@end

NS_ASSUME_NONNULL_END
