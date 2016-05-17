
//
//  JDOriginalWeiboView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDOriginalWeiboView.h"

#define kMargin 8

@interface JDOriginalWeiboView ()

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

@end

@implementation JDOriginalWeiboView

-(void)awakeFromNib {
    // 原创微博正文最大的宽度：
    self.contentLabel.preferredMaxLayoutWidth = JDScreenWidth - kMargin * 2;
    [self.photosCollectionView setBackgroundColor:[UIColor clearColor]];
}

-(void)setStatus:(JDStatusModel *)status {
    [super setStatus:status];
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

@end
