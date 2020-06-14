//
//  ItemCell.m
//  Homepwner
//
//  Created by nuko on 2020/6/11.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ItemCell.h"
@interface ItemCell()
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end



@implementation ItemCell

- (void)updateInterfaceForDynamicTypeSize{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{
            UIContentSizeCategoryExtraSmall : @40,
            UIContentSizeCategorySmall : @40,
            UIContentSizeCategoryMedium : @40,
            UIContentSizeCategoryLarge : @40,
            UIContentSizeCategoryExtraLarge : @45,
            UIContentSizeCategoryExtraExtraLarge : @55,
            UIContentSizeCategoryExtraExtraExtraLarge : @65
        };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
//    self.imageViewWidthConstraint.constant = imageSize.floatValue;

}



- (IBAction)showImage:(id)sender{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

// when an object is unarchived from nib file
- (void)awakeFromNib {
//    [super awakeFromNib];
    // Initialization code
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    NSLog(@"thumbnail view %@", self.thumbnailView);
    
    if (self.thumbnailView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        NSLog(@"thumbnail view %@", self.thumbnailView);
        
        [self.thumbnailView addConstraint:constraint];
    }
    
}

- (void)dealloc{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
