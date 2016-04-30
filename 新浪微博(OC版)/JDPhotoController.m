//
//  JDPhotoController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/4.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDPhotoController.h"
#import "JDPhotoCell.h"

// 允许能够添加照片的总数：
#define kPhotosCount 9

@interface JDPhotoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSMutableArray *_photosArray;
}

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation JDPhotoController

static NSString * const reuseIdentifier = @"PHOTOCELL";

-(NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听通知：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPhoto) name:JDAddPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePhotoWithIndexPath:) name:JDDeletePhotoNotification object:nil];
}

/**
 *  添加照片：
 */
-(void)addPhoto {
    JDLog(@"%s", __func__);
    // 打开系统相册：
    UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
    imgPickerVC.delegate = self;
    [self presentViewController:imgPickerVC animated:YES completion:nil];
}

/**
 *  移除照片：
 */
-(void)deletePhotoWithIndexPath:(NSNotification *)notification {
    JDLog(@"%s", __func__);
    JDPhotoCell *cell = notification.object;
    [self.photosArray removeObjectAtIndex:cell.indexPath.item];
    [self.collectionView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillLayoutSubviews {
    // 设置间隙：
    self.flowLayout.minimumInteritemSpacing = 15;
    self.flowLayout.minimumLineSpacing = 15;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    // 设置item的size：
    CGFloat col = 4;
    CGFloat width = (UIScreenSize.width - (col + 1) * 15) / 4.0;
    CGFloat height = width;
    self.flowLayout.itemSize = CGSizeMake(width, height);
}

#pragma mark - collection view delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 取出Cell：
    JDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if (self.photosArray.count == indexPath.item) {
        cell.photo = nil;
    } else {
        cell.photo = self.photosArray[indexPath.item];
        cell.indexPath = indexPath;
    }
    
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

/**
 *  选中照片时调用：
 *
 *  @param picker
 *  @param info
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    JDLog(@"%@", info);
    // 取出选中的图片：
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self.photosArray addObject:photo];
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  取消选中时调用：
 *
 *  @param picker
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

@end
