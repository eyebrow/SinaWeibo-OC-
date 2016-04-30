//
//  JDOriginalWeiboView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/7.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDOriginalWeiboView.h"
#import "JDUserModel.h"

#define kImagesColum 3
#define kImageHeight 90
#define kImageMargin 5

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
 *  来源：
 */
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
/**
 *  vipLogo：
 */
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
/**
 *  发送时间：
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  内容：
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  原创微博高度的约束：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalConstHeight;
/**
 *  认证图标：
 */
@property (weak, nonatomic) IBOutlet UIImageView *verifiedImageView;
/**
 *  显示微博配图的collectionView：
 */
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
/**
 *  配图容器的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesConsHeight;

@property (nonatomic, weak) UIButton *coverButton;
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, weak) UIImageView *bigImageView;

@end

@implementation JDOriginalWeiboView

-(void)awakeFromNib {
    // 设置微博正文最大的宽度：
    self.contentLabel.preferredMaxLayoutWidth = UIScreenSize.width - 10;
}

-(void)setStatus:(JDStatusModel *)status {
    [super setStatus:status];
    [self setupOriginalWeiboWithStatus:self.status];
}

/**
 *  初始化原创微博的数据：
 *
 *  @param status
 */
-(void)setupOriginalWeiboWithStatus:(JDStatusModel *)status {
    // 头像：
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    // 昵称：
    self.nameLabel.text = status.user.name;
    // 会员图标：
    if ([status.user isVip]) {
        self.vipImageView.hidden = NO;
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%d", status.user.mbrank.intValue];
        self.vipImageView.image = [UIImage imageNamed:imageName];
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.vipImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    // 认证图标：
#warning 为了提升代码的可读性，此处应该使用枚举：
    self.verifiedImageView.hidden = NO;
    switch (status.user.verified_type) {
        case JDUserVerifiedSelf:
            // 个人认证：
            self.verifiedImageView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case JDUSerVerifiedMeida:
        case JDUSerVerifiedEnterprise:
        case JDUSerVerifiedWebsite:
            // 企业认证：
            self.verifiedImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case JDUserVerifiedExpert:
            //微博达人：
            self.verifiedImageView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
        default:
            // 没有认证：
            self.verifiedImageView.hidden = YES;
            break;
    }
    
    // 时间：
    self.timeLabel.text = status.created_at;
    // 来源：
    self.sourceLabel.text = status.source;
    // 正文：
    self.contentLabel.text = status.text;
    // 高度：
    CGFloat contentHeight = [self.contentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.originalConstHeight.constant = self.contentLabel.y + contentHeight;
    
    // 设置配图：
    NSInteger imgsCount = status.pic_urls.count;
    if (imgsCount > 0) {
        // 有配图：
        NSInteger row = 0;
        if (imgsCount % kImagesColum == 0) {
            row = imgsCount / kImagesColum;
        } else {
            row = imgsCount / kImagesColum + 1;
        }
        // 计算高度：
        CGFloat imgsHeight = row * kImageHeight + (row - 1) * kImageMargin;
        self.imagesConsHeight.constant = imgsHeight;
        // 刷新显示配图区域：
        [self.imagesCollectionView reloadData];
        // 修改微博高度，在纯文本微博高度的基础上加上图片的高度：
        self.originalConstHeight.constant += self.imagesConsHeight.constant + 15;
    } else {
        // 没有配图则不计算高度：
        self.imagesConsHeight.constant = 0;
    }
}

/**-------------------------------------------------------------------------------*/

/**
 *  点击取消图片浏览：
 */
/**
-(void)clickToCancelImagesBrowse:(UIButton *)coverBtn {
    JDLog(@"%s", __func__);
    [UIView animateWithDuration:0.5f animations:^{
        self.bigImageView.frame = self.lastFrame;
    } completion:^(BOOL finished) {
        // 移除蒙板：
        [self.coverButton removeFromSuperview];
        _window = nil;
    }];
}

-(void)test {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:UIScreenBounds];
    [coverBtn setBackgroundColor:[UIColor blackColor]];
    [coverBtn addTarget:self action:@selector(clickToCancelImagesBrowse:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:coverBtn];
    
    // 创建新的图片容器：
    UIImageView *newImageView = [[UIImageView alloc] init];
    [coverBtn addSubview:newImageView];
    
    // 拿到当前点击的cell：
    JDImageCell *cell = (JDImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 取出cell中的imageview：
    UIImageView *cellImageView = [cell getImageViewFromCell];
    JDPhotoModel *photo = self.status.pic_urls[indexPath.item];
    [newImageView sd_setImageWithURL:[NSURL URLWithString:photo.bmiddle_pic] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    // 坐标系转换：
    CGRect tempRect = [cell convertRect:cellImageView.frame toView:coverBtn];
    newImageView.frame = tempRect;
    self.lastFrame = tempRect;
    
    // 动画放大图片：
    [UIView animateWithDuration:1.0f animations:^{
        CGRect tempFrame = newImageView.frame;
        tempFrame.origin.x = 0;
        tempFrame.size.width = UIScreenSize.width;
        tempFrame.size.height = tempFrame.size.height * (tempFrame.size.width / tempFrame.size.height);
        tempFrame.origin.y = (UIScreenSize.height - tempFrame.size.height) * 0.5;
        newImageView.frame = tempFrame;
    }];
    
    _window = window;
    self.coverButton = coverBtn;
    self.bigImageView = newImageView;
}
*/

@end
