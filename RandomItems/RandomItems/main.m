//
//  main.m
//  RandomItems
//
//  Created by nuko on 2020/6/7.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        NSLog(@"Hello, World!");
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [items addObject:@"One"];
        [items addObject:@"Two"];
        [items addObject:@"Three"];
        
        [items insertObject:@"Zero" atIndex:0];
        
        for (NSString *item in items) {
            NSLog(@"%@", item);
        }
        
//        Item *item = [[Item alloc] init];
        
//        [item setItemName:@"Red sofa"];
//        item.itemName = @"Red sofa";
        
//        [item setSerialNumber:@"A1B2C"];
//        item.serialNumber = @"A1B2C";
        
        
//        [item setValueInDollars:100];
//        item.valueInDollars = 100;
        
//        NSLog(@"%@ %@ %@ %d", [item itemName], [item dateCreated], [item serialNumber], [item valueInDollars]);
        
//        Item *item = [[Item alloc] initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
//
//        NSLog(@"%@", item);
//
//        Item *itemWithName = [[Item alloc] initWithItemName:@"Blue sofa"];
//        NSLog(@"%@", itemWithName);
//
//        Item *itemWithNone = [[Item alloc] init];
//        NSLog(@"%@", itemWithNone);
        
//        for (int i=0; i<10; i++) {
//            Item *item = [Item randomItem];
//            [items addObject:item];
//        }
        
//        id lastObj = [items lastObject];
//        [lastObj count];
        
        Item *backpack = [[Item alloc] initWithItemName:@"BackPack"];
        [items addObject:backpack];
        
        Item *calculator = [[Item alloc] initWithItemName:@"Calculator"];
        [items addObject:calculator];
        
        backpack.containedItem = calculator;
        
        backpack = nil;
        calculator = nil;
        
        for (Item *item in items) {
            NSLog(@"%@", item);
        }
        
        NSLog(@"Setting items to nil...");
        items=nil;
    }
    return 0;
}
