//
//  JDImageCell.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/6.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDPhotoModel;

@interface JDImageCell : UICollectionViewCell

/**
 *  微博配图的URL：
 */
@property (nonatomic, strong) JDPhotoModel *photo;

-(UIImageView *)getImageViewFromCell;

@end
