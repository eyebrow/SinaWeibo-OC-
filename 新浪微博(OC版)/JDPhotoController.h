//
//  JDPhotoController.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/15.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPhotoController : UICollectionViewController

/**
 *  用于保存选中的图片：
 */
@property (nonatomic, strong) NSMutableArray *photosArray;

@end
