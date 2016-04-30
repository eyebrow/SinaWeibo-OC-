
//
//  JDImageCell.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/6.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDImageCell.h"
#import "JDPhotoModel.h"

@interface JDImageCell ()

/**
 *  图片容器：
 */
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
/**
 *  显示图片的view：
 */
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
/**
 *  gif的view：
 */
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@end

@implementation JDImageCell

-(void)setPhoto:(JDPhotoModel *)photo {
    _photo = photo;
    NSURL *imageURL = [NSURL URLWithString:photo.thumbnail_pic];
    [self.photoImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    
    // 判断返回的URL中是否包含gif字样：
    BOOL reuslt = [imageURL.absoluteString.lowercaseString hasSuffix:@".gif"];
    // 判断是否现实gif图标：
    if (reuslt) {
        self.gifImageView.hidden = NO;
    } else {
        self.gifImageView.hidden = YES;
    }
}

/**
 *  返回当前cell中的图片对象：
 *
 *  @return
 */
-(UIImageView *)getImageViewFromCell {
    return self.photoImageView;
}

@end
