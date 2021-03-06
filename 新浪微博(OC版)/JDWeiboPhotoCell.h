//
//  JDWeiboPhotoCell.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/16.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDPhotoModel;

@interface JDWeiboPhotoCell : UICollectionViewCell

@property (nonatomic, strong) JDPhotoModel *photo;

/**
 *  获取当前cell上的图片：
 *
 *  @return 
 */
-(UIImage *)getImageFromCurrentCell;

-(UIImageView *)getImageViewFromCurrentCell;

@end
