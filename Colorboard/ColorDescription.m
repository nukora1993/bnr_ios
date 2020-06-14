//
//  ColorDescription.m
//  Colorboard
//
//  Created by nuko on 2020/6/14.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ColorDescription.h"

@implementation ColorDescription

- (instancetype)init{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        _name = @"Blue";
    }
    
    return self;
}

@end
