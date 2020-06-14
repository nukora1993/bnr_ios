//
//  WebViewController.h
//  Nerdfeed
//
//  Created by nuko on 2020/6/11.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
