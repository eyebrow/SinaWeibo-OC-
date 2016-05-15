//
//  JDPhotoCell.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/15.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDPhotoCell;

@protocol JDPhotoCellDelegate <NSObject>

/**
 *  执行代理，从相册选择照片：
 *
 *  @param photoCell
 *  @param sender
 */
-(void)photoCell:(JDPhotoCell *)photoCell didClickToChoosePhoto:(UIButton *)sender;
/**
 *  执行代理，删除选中的照片：
 *
 *  @param photoCell
 *  @param sender
 */
-(void)photoCell:(JDPhotoCell *)photoCell didClickToDeletePhoto:(UIButton *)sender;

@end

@interface JDPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *photoImage;
/**
 *  当前cell对应的索引：
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<JDPhotoCellDelegate> delegate;

@end
