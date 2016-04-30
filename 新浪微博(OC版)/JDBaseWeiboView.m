//
//  JDBaseWeiboView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBaseWeiboView.h"

@interface JDBaseWeiboView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation JDBaseWeiboView

#pragma mark - collection View delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.status.pic_urls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMAGECELL" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    // 设置在原创和转发情况下的照片数据：
    JDPhotoModel *photo = self.status.pic_urls[indexPath.item];
    cell.photo = photo;
    
    return cell;
}

// 监听点击事件：
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JDLog(@"%s", __func__);
    // 创建图片浏览器：
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 用于存放需要加入浏览器的图片：
    NSMutableArray *photosArray = [NSMutableArray array];
    // 遍历系统返还给用户的图片数据：
    for (int i = 0; i < self.status.pic_urls.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        JDPhotoModel *model = self.status.pic_urls[i];
        photo.url = [NSURL URLWithString:model.bmiddle_pic];
        // 取出cell中所有的photo对象：
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        JDImageCell *cell = (JDImageCell *)[collectionView cellForItemAtIndexPath:newIndexPath];
        photo.srcImageView = [cell getImageViewFromCell];
        [photosArray addObject:photo];
    }
    browser.photos = photosArray;
    // 设置当前选中的图片：
    browser.currentPhotoIndex = indexPath.item;
    [browser show];
}

@end
