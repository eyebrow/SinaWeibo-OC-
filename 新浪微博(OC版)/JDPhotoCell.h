//
//  JDPhotoCell.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/4.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JDAddPhotoNotification @"addPhotoNotification"
#define JDDeletePhotoNotification @"deletePhotoNotification"

@interface JDPhotoCell : UICollectionViewCell

/**
 *  接收传入的照片：
 */
@property (nonatomic, strong) UIImage *photo;
/**
 *  接收collectionView的indexPath：
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
