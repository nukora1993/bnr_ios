//
//  CourseViewController.h
//  Nerdfeed
//
//  Created by nuko on 2020/6/11.
//  Copyright © 2020 nuko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// gosh, if we forget ;, the Xcode will not warning us...
@class WebViewController;

@interface CourseViewController : UITableViewController

@property (nonatomic) WebViewController *webViewController;


@end

NS_ASSUME_NONNULL_END
