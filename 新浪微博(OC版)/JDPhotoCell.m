//
//  JDPhotoCell.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/4.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDPhotoCell.h"

@interface JDPhotoCell ()

/**
 *  显示相册中照片的按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
/**
 *  用于点击取消选中照片的按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation JDPhotoCell

/**
 *  点击从相册选择照片：
 *
 *  @param sender
 */
- (IBAction)clickToAddPhotoFromAlbum:(UIButton *)sender {
    JDLog(@"%s", __func__);
    // 发送添加通知：
    [[NSNotificationCenter defaultCenter] postNotificationName:JDAddPhotoNotification object:nil];
}

/**
 *  点击取消照片：
 *
 *  @param sender
 */
- (IBAction)clickToDeletePhoto:(UIButton *)sender {
    JDLog(@"%s", __func__);
    // 发送删除通知：
    [[NSNotificationCenter defaultCenter] postNotificationName:JDDeletePhotoNotification object:self];
}

-(void)setPhoto:(UIImage *)photo {
    _photo = photo;
    if (!photo) {
        self.deleteButton.hidden = YES;
        // 防止cell重用，重新设置cell上Button的背景图片：
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
    } else {
        self.deleteButton.hidden = NO;
        [self.photoButton setBackgroundImage:photo forState:UIControlStateNormal];
    }
}

@end
