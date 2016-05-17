
//
//  JDOriginalWeiboView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDOriginalWeiboView.h"
#import "JDStatusModel.h"
#import "JDUserModel.h"
#import "JDWeiboPhotoCell.h"
#import "JDPhotoModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define kMargin 8

@interface JDOriginalWeiboView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    UIWindow *_window;
}

/**
 *  头像：
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  昵称：
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  会员图标：
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
/**
 *  时间：
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  来源：
 */
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
/**
 *  微博正文：
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  认证图标：
 */
@property (weak, nonatomic) IBOutlet UIImageView *verifyImageView;
/**
 *  存放以上控件的view的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalWeiboHeight;
/**
 *  微博照片容器的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHeight;
/**
 *  用于显示photo的collectionView：
 */
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
/**
 *  蒙板：
 */
@property (nonatomic, weak) UIButton *coverButton;

@end

@implementation JDOriginalWeiboView

-(void)awakeFromNib {
    // 原创微博正文最大的宽度：
    self.contentLabel.preferredMaxLayoutWidth = JDScreenWidth - kMargin * 2;
    [self.photosCollectionView setBackgroundColor:[UIColor clearColor]];
    self.photosCollectionView.dataSource = self;
    self.photosCollectionView.delegate = self;
}

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    JDUserModel *user = status.user;
    [self setupOriginalWeiboTextWithStatus:status user:user];
    [self setupOriginalWeiboPhotoWithStatus:status user:user];
}

/**
 *  初始化原创微博的文字：
 *
 *  @param status
 *  @param user
 */
-(void)setupOriginalWeiboTextWithStatus:(JDStatusModel *)status user:(JDUserModel *)user {
    // 头像：
#warning 此处加载图片一定要设置展位图，否则imageView的frame初始时为0，必须下拉一下tableView系统再帮你设置。
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    // 昵称：
    self.nameLabel.text = user.name;
    // 时间：
    self.timeLabel.text = status.created_at;
    // 来源：
    self.sourceLabel.text = status.source;
    // 正文：
    self.contentLabel.text = status.text;
    // 是否会员：
    if ([user isVip]) {
        // 设置会员图标：
        NSString *vipImageName = [NSString stringWithFormat:@"common_icon_membership_level%ld", user.mbrank.integerValue];
        self.vipImageView.image = [UIImage imageNamed:vipImageName];
        // 设置昵称颜色：
        [self.nameLabel setTextColor:[UIColor orangeColor]];
    } else {
        // 设置非会员图标：
        self.vipImageView.image = [UIImage imageNamed:@"common_icon_membership_expired"];
        // 还原颜色：
        [self.nameLabel setTextColor:[UIColor blackColor]];
    }
    // 认证类型：
    /**
     typedef NS_ENUM(NSInteger) {
     // 没有认证：
     JDUserVerifiedTypeNone = -1,
     // 黄v：
     JDUserVerifiedTypePersonal = 0,
     // 蓝v：
     JDUserVerifiedTypeEnterprice = 2,
     // 媒体：
     JDUserVerifiedTypeMedia = 3,
     // 网站：
     JDUserVerifiedTypeWebsite = 5,
     // 达人：
     JDUserVerifiedTypeDaRen = 220
     } JDUserVerifiedType;
     */
    self.verifyImageView.hidden = NO;
    switch (user.verified_type) {
        case JDUserVerifiedTypeNone:
            self.verifyImageView.hidden = YES;
            break;
        case JDUserVerifiedTypePersonal:
            self.verifyImageView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case JDUserVerifiedTypeEnterprice:
        case JDUserVerifiedTypeMedia:
        case JDUserVerifiedTypeWebsite:
            self.verifyImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case JDUserVerifiedTypeDaRen:
            self.verifyImageView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
        default:
            break;
    }
    
    self.iconImageView.contentMode = UIViewContentModeCenter;
    // cell高度：
    self.originalWeiboHeight.constant = [self.contentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + self.contentLabel.y + kMargin;
}

/**
 *  初始化原创微博的配图：
 *
 *  @param status
 *  @param user
 */
-(void)setupOriginalWeiboPhotoWithStatus:(JDStatusModel *)status user:(JDUserModel *)user {
    // 设置微博配图：
    NSInteger photosCount = status.pic_urls.count;
    if (photosCount > 0) {
        // 有配图：
        // 计算行数：
        NSInteger row = 0;
        if (photosCount % 3 == 0) {
            row = photosCount / 3;
        } else {
            row = photosCount % 3;
        }
        // 计算高度：
        CGFloat photoHeight = 80;
        CGFloat photoMargin = 10;
        CGFloat rowHeight = photoHeight * row + (row - 1) * photoMargin;
        self.photoCollectionViewHeight.constant = rowHeight;
        self.originalWeiboHeight.constant += self.photoCollectionViewHeight.constant + kMargin;
        [self.photosCollectionView reloadData];
    } else {
        // 没有配图：
        self.photoCollectionViewHeight.constant = 0;
    }
}

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
    /**
    _window = [UIApplication sharedApplication].keyWindow;
    // 添加蒙版：
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:JDScreenBounds];
    [coverBtn setBackgroundColor:[UIColor blackColor]];
    [_window addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(clickToClosePhotosBrowser:) forControlEvents:UIControlEventTouchUpInside];
    self.coverButton = coverBtn;
    // 添加imageView：
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, JDScreenWidth, JDScreenWidth)];
    [coverBtn addSubview:photoImageView];
    // 下载大图：
    // 取出模型：
    JDPhotoModel *photo = self.status.pic_urls[indexPath.item];
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:photo.bmiddle_pic] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    
    // 取出当前点击cell的照片：
    JDWeiboPhotoCell *cell = (JDWeiboPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *photoImage = [cell getImageFromCurrentCell];
    // 动画加载照片：
    CGFloat x = 0;
    CGFloat width = JDScreenWidth;
    CGFloat height =
     */
    
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

-(void)clickToClosePhotosBrowser:(UIButton *)sender {
    JDLog(@"退出照片浏览器....");
    [self.coverButton removeFromSuperview];
    _window = nil;
}

@end
