//
//  ColorViewController.m
//  Colorboard
//
//  Created by nuko on 2020/6/14.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ColorViewController.h"


@interface ColorViewController () <UIViewControllerRestoration>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;



@end

@implementation ColorViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder{
    ColorViewController *vc = nil;
    
    UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    
    if (storyboard) {
        vc = (ColorViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ColorViewController"];
        
        vc.restorationIdentifier = [identifierComponents lastObject];
        vc.restorationClass = [ColorViewController class];
    }
    
    return vc;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.existingColor) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)dismiss:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeColor:(id)sender{
    float red = self.redSlider.value;
    float green = self.greenSlider.value;
    float blue = self.blueSlider.value;
    
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.view.backgroundColor = newColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *color = self.colorDescription.color;
    
    double red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    
    
    self.view.backgroundColor = color;
    self.textField.text = self.colorDescription.name;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.colorDescription.name = self.textField.text;
    self.colorDescription.color = self.view.backgroundColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
