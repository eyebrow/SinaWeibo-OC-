//
//  JDPhotoController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/15.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDPhotoController.h"
#import "JDPhotoCell.h"

// 一行4张照片：
#define kPhotosCountInRow 4.0

@interface JDPhotoController () <JDPhotoCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/**
 *  collectionView的布局：
 */
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation JDPhotoController

-(NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPhotoController];
}

-(void)setupPhotoController {
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewWillLayoutSubviews {
    CGFloat marginX = 10;
    CGFloat marginY = 10;
    CGFloat marginInset = 10;
    // x和y的间隙：
    self.flowLayout.minimumLineSpacing = marginX;
    self.flowLayout.minimumInteritemSpacing = marginY;
    // 设置全局间隙：
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, marginInset, 0, marginInset);
    // 设置itemSize：
    CGFloat width = (JDScreenWidth - (kPhotosCountInRow - 1) * marginX - marginInset * 2) / kPhotosCountInRow;
    CGFloat height = width;
    self.flowLayout.itemSize = CGSizeMake(width, height);
}

#pragma mark - UICollectionView dataSource.

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PHOTOCELL" forIndexPath:indexPath];
    cell.delegate = self;
    // 取出图片：
    if (self.photosArray.count == indexPath.item) {
        cell.photoImage = nil;
    } else {
        UIImage *photoImage = self.photosArray[indexPath.item];
        cell.photoImage = photoImage;
        cell.indexPath = indexPath;
    }
    return cell;
}

#pragma mark - JDPhotoCellDelegate.

-(void)photoCell:(JDPhotoCell *)photoCell didClickToDeletePhoto:(UIButton *)sender {
    JDLog(@"点击了删除照片按钮....");
    // 根据每个cell对应的indexPath的值：
    [self.photosArray removeObjectAtIndex:photoCell.indexPath.item];
    [self.collectionView reloadData];
}

-(void)photoCell:(JDPhotoCell *)photoCell didClickToChoosePhoto:(UIButton *)sender {
    JDLog(@"点击了选择照片按钮....");
    // 创建图片选择器：
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate.

// 从相册选择照片：
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    JDLog(@"选中了一张照片....");
    if (self.photosArray.count == 9) {
        return;
    }
    // 取出选中的照片：
    UIImage *photoImage = info[UIImagePickerControllerOriginalImage];
    [self.photosArray addObject:photoImage];
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 删除已选择的照片：
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
