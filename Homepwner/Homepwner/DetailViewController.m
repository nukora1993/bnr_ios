//
//  DetailViewController.m
//  Homepwner
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"
#import "ItemStore.h"
#import "AssetTypeViewController.h"
#import "AppDelegate.h"

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;



@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@end

@implementation DetailViewController

// this method will be called when first appear or view change size
//- (void)viewDidLayoutSubviews{
//    for (UIView *subview in self.view.subviews) {
//        // check is there any ambiguous view
//        if ([subview hasAmbiguousLayout]) {
//            NSLog(@"AMBIGUOUS: %@", subview);
//        }
//    }
//}
- (IBAction)showAssetTypePicker:(id)sender {
    [self.view endEditing:YES];
    
    AssetTypeViewController *avc = [[AssetTypeViewController alloc] init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)updateFonts{
    NSLog(@"%@ has been executed", NSStringFromSelector(_cmd));
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
    
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // we only hide image view and disable camera button when iPhone landscape
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
        
    }else{
        self.imageView.hidden = NO;
        self.cameraButton.enabled =YES;
    }
}

// when orientation changed
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // do not produce a translated - for old iOS
    // before auto layout, iOS use auto resize, so we need disable auto resize to constraint to avoid conflict
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    // we prefer to make image view larger
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    
//    for (UIView *subview in self.view.subviews) {
//        if ([subview hasAmbiguousLayout]) {
//            // change the possible ambiguous solutions
//            [subview exerciseAmbiguityInLayout];
//        }
//    }
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    
    // save changes into item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    [[ItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (Item *item in [[ItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (instancetype)initForNewItem:(BOOL)isNew{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        // restoration id
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        // receive font change
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // unregister
    [defaultCenter removeObserver:self];
}

- (void)save:(id)sender{
    // presenting vc is the vc which present detail view, namely items vc
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
    NSLog(@"");
    
}

- (void)cancel:(id)sender{
    [[ItemStore sharedStore] removeItem:self.item];
    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSLog(@"an image has been selected");
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    // store in image store
    [[ImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    // dismiss the vc which is present modally
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.imagePickerPopover) {
        // when we dismiss manually, it will not send dismiss message to delegate
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    // if we record video, the video will save at temp file, so we need to save it to album
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
    if (mediaURL) {
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path])) {
            // save to album
            UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
            // delete temp file
            [[NSFileManager defaultManager] removeItemAtPath:[mediaURL path] error:nil];
        }
    }
}

- (IBAction)takePicture:(id)sender {
    // when we tap the camera button again when we has taped, we just cancel popover
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // check camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.mediaTypes = availableTypes;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePicker.mediaTypes = availableTypes;
    }
    
    
    
    imagePicker.delegate = self;
    
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)setItem:(Item *)item{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    // when back, store the item
    Item *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    
    int newValue = [self.valueField.text intValue];
    
    if (newValue != item.valueInDollars) {
        item.valueInDollars = newValue;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:NextItemValuePrefsKey];
        
    }
    
//    item.valueInDollars = [self.valueField.text intValue];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    Item *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    
    
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
        
    NSString *imageKey = self.item.itemKey;
    
    UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:imageKey];
    
    self.imageView.image = imageToDisplay;
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
//        typeLabel = @"None";
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    
//    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
    
    [self updateFonts];
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
