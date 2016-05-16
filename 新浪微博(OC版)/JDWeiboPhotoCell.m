//
//  JDWeiboPhotoCell.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/16.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWeiboPhotoCell.h"
#import "JDPhotoModel.h"

@interface JDWeiboPhotoCell ()

/**
 *  图片：
 */
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
/**
 *  gif图标：
 */
@property (weak, nonatomic) IBOutlet UIImageView *gifIconImageView;

@end

@implementation JDWeiboPhotoCell

-(void)setPhoto:(JDPhotoModel *)photo {
    _photo = photo;
    // 设置图片：
    NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
    [self.photoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    // 是否显示gif图标：
    if ([url.absoluteString.lowercaseString hasSuffix:@".gif"]) {
        self.gifIconImageView.hidden = NO;
    } else {
        self.gifIconImageView.hidden = YES;
    }
}

@end
