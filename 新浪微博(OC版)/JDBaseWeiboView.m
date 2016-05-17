






//
//  JDBaseWeiboView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBaseWeiboView.h"

@interface JDBaseWeiboView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation JDBaseWeiboView

#pragma mark - UICollectionViewDataSource.

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.status.pic_urls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEIBOPHOTOCELL" forIndexPath:indexPath];
    JDPhotoModel *photo = self.status.pic_urls[indexPath.item];
    cell.photo = photo;
    return cell;
}

#pragma mark - UICollectionViewDelegate.

// collectionView的item被电击时调用：
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JDLog(@"点击了原创微博的配图....");
    // 创建图片浏览器：
    MJPhotoBrowser *browder = [[MJPhotoBrowser alloc] init];
    // 指定浏览器显示的内容：
    NSMutableArray *photosArray = [NSMutableArray array];
    for (int i = 0; i < self.status.pic_urls.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        JDPhotoModel *model = self.status.pic_urls[i];
        photo.url = [NSURL URLWithString:model.bmiddle_pic];
        JDLog(@"%@", photo.url);
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:i inSection:0];
        JDWeiboPhotoCell *cell = (JDWeiboPhotoCell *)[collectionView cellForItemAtIndexPath:indexP];
        photo.srcImageView = [cell getImageViewFromCurrentCell];
        [photosArray addObject:photo];
    }
    browder.photos = photosArray;
    browder.currentPhotoIndex = indexPath.item;
    [browder show];
}

@end
