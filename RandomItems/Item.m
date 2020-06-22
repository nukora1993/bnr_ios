//
//  Item.m
//  RandomItems
//
//  Created by nuko on 2020/6/7.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "Item.h"

@implementation Item
+ (instancetype)randomItem{
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    NSArray *randomNounList =@[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
//    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
//                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
//                            [randomNounList objectAtIndex:nounIndex]];
    
    NSString *randomName= [NSString stringWithFormat:@"%@ %@",
                          randomAdjectiveList[adjectiveIndex],
                          randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 10,
                                    '0' + arc4random() % 10
                                    ];
    
    Item *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

//- (void)setContainedItem:(Item *)item{
//    _containedItem = item;
//
//    item.container = self;
//}
//
//- (Item *)containedItem{
//    return _containedItem;
//}
//
//- (void)setContainer:(Item *)item{
//    _container = item;
//}
//
//- (Item *)container{
//    return _container;
//}

- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber{
    self = [super init];
    if (self){
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        _dateCreated = [[NSDate alloc] init];
        
        // create uuid for item key
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
    
}

- (instancetype)initWithItemName:(NSString *)name{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

- (instancetype)init{
    return [self initWithItemName:@"Item"];
}


//- (void)setItemName:(NSString *)str{
//    _itemName = str;
//}
//
//- (NSString *)itemName{
//    return _itemName;
//}
//
//-(void)setSerialNumber:(NSString *)str{
//    _serialNumber = str;
//}
//
//-(NSString *)serialNumber{
//    return _serialNumber;
//}
//
//- (void)setValueInDollars:(int)v{
//    _valueInDollars = v;
//}
//
//- (int)valueInDollars{
//    return _valueInDollars;
//}
//
//- (NSDate *)dateCreated{
//    return _dateCreated;
//}

//- (void)setContainedItem:(Item *)containedItem{
//    _containedItem = containedItem;
//    self.containedItem.container = self;
//}

- (NSString *)description{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                             self.itemName,
                             self.serialNumber,
                             self.valueInDollars,
                             self.dateCreated];
    return descriptionString;
}

- (void)dealloc{
    NSLog(@"Destroyed: %@", self);
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.itemName forKey:@"itemName"];
    [coder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [coder encodeObject:self.itemKey forKey:@"itemKey"];
    [coder encodeObject:self.thumbnail forKey:@"thumbnail"];
    
    [coder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        _itemName = [coder decodeObjectForKey:@"itemName"];
        _serialNumber = [coder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [coder decodeObjectForKey:@"dateCreated"];
        _itemKey = [coder decodeObjectForKey:@"itemKey"];
        _thumbnail = [coder decodeObjectForKey:@"thumbnail"];
        
        _valueInDollars = [coder decodeIntForKey:@"valueInDollars"];
        
    }
    return self;
}

- (void)setThumbnailFromImage:(UIImage *)image{
    CGSize origImageSize = image.size;
    
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.width / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    UIGraphicsEndImageContext();
}







@end
