//
//  ImageTransformer.m
//  Homepwner
//
//  Created by nuko on 2020/6/11.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation ImageTransformer

+ (Class)transformedValueClass{
    return [NSData class];
}

- (id)transformedValue:(id)value{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value{
    return [UIImage imageWithData:value];
}

@end
