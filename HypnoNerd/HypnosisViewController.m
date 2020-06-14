//
//  HypnosisViewController.m
//  HypnoNerd
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@interface HypnosisViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;

@end

@implementation HypnosisViewController

- (void)drawHypnoticMessage:(NSString *)message{
    for (int i=10; i<20; i++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.text = message;
        
        [messageLabel sizeToFit];
        
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        // set the alpha animation
        messageLabel.alpha = 0.0;
        
        // animate
//        [UIView animateWithDuration:0.5 animations:^{
//            messageLabel.alpha = 1.0;
//        }];
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{messageLabel.alpha = 1.0;} completion:nil];
        
        // key frame
//        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
//                messageLabel.center = self.view.center;
//            }];
//
//            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
//                int x = arc4random() % width;
//                int y = arc4random() % height;
//                messageLabel.center = CGPointMake(x, y);
//            }];
//
//
//        } completion:nil];
        
        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
                messageLabel.center = self.view.center;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                int x = arc4random() % width;
                int y = arc4random() % height;
                messageLabel.center = CGPointMake(x, y);
            }];
            
            
        } completion:^(BOOL finished){
            NSLog(@"Animation finished");
        }];
        
        // add motion effect
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"HypnosisViewController loaded its view");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"Hypnotize";
        
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)loadView{
    HypnosisView *backgroundView = [[HypnosisView alloc] init];
    
//    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    // hint
    textField.placeholder = @"Hypnotize me";
    // keyboard return type
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate = self;
    
    self.textField = textField;
    
    [backgroundView addSubview:textField];
    
    
    
    self.view = backgroundView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.25 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect frame = CGRectMake(40, 70, 240, 30);
        self.textField.frame = frame;
                                  } completion:nil];
}

# pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"%@", textField.text);
    [self drawHypnoticMessage:textField.text];
    
    textField.text = @"";
    // hide keyboard
    [textField resignFirstResponder];
    return YES;
}

@end
