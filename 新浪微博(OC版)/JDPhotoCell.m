//
//  JDPhotoCell.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/15.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDPhotoCell.h"

@interface JDPhotoCell ()

/**
 *  用于显示从相册选中的按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
/**
 *  点击删除照片的按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation JDPhotoCell

/**
 *  点击从相册选择照片：
 *
 *  @param sender
 */
- (IBAction)clickToChoosePhotoFromAlbum:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoCell:didClickToChoosePhoto:)]) {
        [self.delegate photoCell:self didClickToChoosePhoto:sender];
    }
}

/**
 *  点击删除已选择的photo：
 *
 *  @param sender 
 */
- (IBAction)clickToDeletePhoto:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoCell:didClickToDeletePhoto:)]) {
        [self.delegate photoCell:self didClickToDeletePhoto:sender];
    }
}

/**
 *  重写setter方法设置照片：
 *
 *  @param photoImage
 */
-(void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = photoImage;
    // 如果传入的照片为空，则不执行任何操作：
    if (photoImage == nil) {
        self.deleteButton.hidden = YES;
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
        return;
    }
    [self.photoButton setBackgroundImage:photoImage forState:UIControlStateNormal];
    self.deleteButton.hidden = NO;
}

@end
