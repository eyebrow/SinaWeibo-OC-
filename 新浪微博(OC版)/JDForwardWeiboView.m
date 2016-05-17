




//
//  JDForwardWeiboView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDForwardWeiboView.h"
#import "JDStatusModel.h"
#import "JDUserModel.h"
#import "JDWeiboPhotoCell.h"
#import "JDPhotoModel.h"

#define kMargin 8

@interface JDForwardWeiboView () <UICollectionViewDataSource>

/**
 *  @了谁：
 */
@property (weak, nonatomic) IBOutlet UILabel *forwardNameLabel;
/**
 *  转发微博内容：
 */
@property (weak, nonatomic) IBOutlet UILabel *forwardContentLabel;
/**
 *  转发微博容器的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardViewHeight;
/**
 *  展示转发微博照片的collectionView：
 */
@property (weak, nonatomic) IBOutlet UICollectionView *forwardPhotoCollcectionView;
/**
 *  展示转发微博照片的collectionView的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardPhotoCollectionViewHeight;
/**
 *  是否是转发：
 */
@property (nonatomic, assign) BOOL isFroward;

@end

@implementation JDForwardWeiboView

-(void)awakeFromNib {
    // 转发微博正文最大的宽度：
    self.forwardContentLabel.preferredMaxLayoutWidth = JDScreenWidth - kMargin * 2;
    [self.forwardPhotoCollcectionView setBackgroundColor:[UIColor clearColor]];
    self.forwardPhotoCollcectionView.dataSource = self;
}

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    JDUserModel *user = status.retweeted_status.user;
    [self setupForwardWeiboTextWithStatus:status user:user];
    [self setupForwardWeiboPhotoWithStatus:status user:user];
}

/**
 *  初始化转发微博的文字：
 *
 *  @param status
 *  @param user
 */
-(void)setupForwardWeiboTextWithStatus:(JDStatusModel *)status user:(JDUserModel *)user {
    // 判断微博是否有转发：
    self.forwardNameLabel.text = [NSString stringWithFormat:@"@%@", status.retweeted_status.user.name];
    self.forwardContentLabel.text = status.retweeted_status.text;
    self.forwardViewHeight.constant = [self.forwardContentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + self.forwardContentLabel.y + kMargin;
}

/**
 *  初始化转发微博的照片：
 *
 *  @param status
 *  @param user
 */
-(void)setupForwardWeiboPhotoWithStatus:(JDStatusModel *)status user:(JDUserModel *)user {
    NSInteger photosCount = status.retweeted_status.pic_urls.count;
    if (photosCount > 0) {
        NSInteger row = 0;
        if (photosCount %3 == 0) {
            row = photosCount / 3;
        } else {
            row = photosCount % 3;
        }
        
        CGFloat photoHeight = 80;
        CGFloat photoMargin = 10;
        CGFloat rowHeight = row * photoHeight + (row - 1) * photoMargin;
        self.forwardPhotoCollectionViewHeight.constant = rowHeight;
        [self.forwardPhotoCollcectionView reloadData];
        self.forwardViewHeight.constant += self.forwardPhotoCollectionViewHeight.constant + kMargin;
    } else {
        self.forwardPhotoCollectionViewHeight.constant = 0;
    }
}

-(void)setForwardHeight:(CGFloat)forwardHeight {
    _forwardHeight = forwardHeight;
    self.forwardViewHeight.constant = forwardHeight;
}

#pragma mark - UICollectionViewDataSource.

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.status.retweeted_status.pic_urls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEIBOPHOTOCELL" forIndexPath:indexPath];
    JDPhotoModel *photo = self.status.retweeted_status.pic_urls[indexPath.item];
    cell.photo = photo;
    return cell;
}

@end
