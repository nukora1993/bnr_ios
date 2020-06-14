//
//  ImageStore.m
//  Homepwner
//
//  Created by nuko on 2020/6/9.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation ImageStore

+ (instancetype)sharedStore{
    static ImageStore *sharedStore = nil;
    
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    // for thread safe, make sure only execute once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [ImageStore sharedStore]" userInfo:nil];
    
    return nil;
}

// designated initializer
- (instancetype)initPrivate{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)clearCache:(NSNotification *)note{
    NSLog(@"flushing %ld image out of the cache", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key{
//    [self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image;
    
    // write image to file
    NSString *imagePath = [self imagePathForKey:key];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key{
//    return [self.dictionary objectForKey:key];
//    return self.dictionary[key];
    // we first get from memory
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if(result){
            self.dictionary[key] = result;
        }else{
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    // delete file
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
}

- (NSString *)imagePathForKey:(NSString *)key{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}



@end
