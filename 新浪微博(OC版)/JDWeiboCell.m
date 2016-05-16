//
//  JDWeiboCell.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWeiboCell.h"
#import "JDUserModel.h"
#import "JDStatusModel.h"
#import "JDWeiboPhotoCell.h"

// 间隙：
#define kMargin 8

@interface JDWeiboCell () <UICollectionViewDataSource>

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
 *  存放转发微博的view：
 */
@property (weak, nonatomic) IBOutlet UIView *forwardView;
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
/**
 *  底部试图：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bootomViewHeight;
/**
 *  转发按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
/**
 *  评论按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
/**
 *  点赞按钮：
 */
@property (weak, nonatomic) IBOutlet UIButton *approveButton;


@end

@implementation JDWeiboCell

-(void)awakeFromNib {
    // 原创微博正文最大的宽度：
    self.contentLabel.preferredMaxLayoutWidth = JDScreenWidth - kMargin * 2;
    // 转发微博正文最大的宽度：
    self.forwardContentLabel.preferredMaxLayoutWidth = JDScreenWidth - kMargin * 2;
    [self.photosCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.forwardPhotoCollcectionView setBackgroundColor:[UIColor clearColor]];
    self.photosCollectionView.dataSource = self;
    self.forwardPhotoCollcectionView.dataSource = self;
    // cell不可点击：
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)getWeiboCellWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"WEIBOCELL";
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    return cell;
}

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    JDUserModel *user = status.user;
    
    // 非转发：
    self.isFroward = NO;
    [self setupOriginalWeiboTextWithStatus:status user:user];
    [self setupOriginalWeiboPhotoWithStatus:status user:user];
    
    // 判断是否有转发微博：
    if (status.retweeted_status) {
        self.isFroward = YES;
        self.forwardView.hidden = NO;
        [self setupForwardWeiboTextWithStatus:status user:user];
        [self setupForwardWeiboPhotoWithStatus:status user:user];
    } else {
        self.isFroward = NO;
        self.forwardViewHeight.constant = 0;
        self.forwardView.hidden = YES;
    }
    
    // 底部视图：
    [self setupBootomViewWithStatus:status user:user];
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

/**
 *  初始化底部视图：
 *
 *  @param user
 *  @param user
 */
-(void)setupBootomViewWithStatus:(JDStatusModel *)status user:(JDUserModel *)user {
    [self setButtonTitleWithCount:status.reposts_count normalTitle:@"转发" targetButton:self.forwardButton];
    [self setButtonTitleWithCount:status.comments_count normalTitle:@"评论" targetButton:self.reviewButton];
    [self setButtonTitleWithCount:status.attitudes_count normalTitle:@"赞" targetButton:self.approveButton];
}

-(void)setButtonTitleWithCount:(NSNumber *)count normalTitle:(NSString *)norTitle targetButton:(UIButton *)targetBtn {
    if (count.longLongValue > 0) {
        // 格式处理：
        NSString *title = nil;
        if (count.longLongValue > 10000) {
            double number = count.longLongValue / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", number];
            // 如果title中存在.0，则替换为空：
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        } else {
            title = [NSString stringWithFormat:@"%lld", count.longLongValue];
        }
        // 有转发：
        [targetBtn setTitle:title forState:UIControlStateNormal];
    } else {
        [targetBtn setTitle:norTitle forState:UIControlStateNormal];
    }
}

/**
 *  返回cell的高度：
 *
 *  @param status
 *
 *  @return 
 */
-(CGFloat)getCellHeightWithStatus:(JDStatusModel *)status {
    self.status = status;
    [self layoutIfNeeded];
    // 取出底部视图的高度：
    CGFloat bootomViewHeight = self.bootomViewHeight.constant;
    if (self.status.retweeted_status == nil) {
        // 没有转发：
        self.isFroward = NO;
        return self.originalWeiboHeight.constant + kMargin * 2 + bootomViewHeight;
    } else {
        self.isFroward = YES;
        return self.forwardView.y + self.forwardViewHeight.constant + kMargin * 2 + bootomViewHeight;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isFroward) {
        return self.status.retweeted_status.pic_urls.count;
    } else {
        return self.status.pic_urls.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEIBOPHOTOCELL" forIndexPath:indexPath];
    JDPhotoModel *photo = nil;
    if (self.isFroward) {
        photo = self.status.retweeted_status.pic_urls[indexPath.item];
    } else {
        photo = self.status.pic_urls[indexPath.item];
    }
    cell.photo = photo;
    return cell;
}

#pragma mark - 底部视图按钮的事件监听：

/**
 *  点击转发微博：
 *
 *  @param sender
 */
- (IBAction)clickToForward:(UIButton *)sender {
    JDLog(@"点击了转发微博....");
}

/**
 *  点击评论微博：
 *
 *  @param sender
 */
- (IBAction)clickToPublishReview:(UIButton *)sender {
    JDLog(@"点击了评论微博....");
}

/**
 *  点赞：
 *
 *  @param sender
 */
- (IBAction)clickToApprove:(UIButton *)sender {
    JDLog(@"点赞....");
}

@end
