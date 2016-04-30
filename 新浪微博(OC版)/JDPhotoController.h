//
//  JDPhotoController.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/4.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPhotoController : UICollectionViewController

/**
 *  存放选择照片的数组：
 */
@property (nonatomic, strong, readonly) NSMutableArray *photosArray;

@end
