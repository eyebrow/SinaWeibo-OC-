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

// 间隙：
#define kMargin 8

@interface JDWeiboCell ()

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

@end

@implementation JDWeiboCell

-(void)awakeFromNib {
    // 原创微博正文最大的宽度：
    self.contentLabel.preferredMaxLayoutWidth = JDScreenWidth - kMargin * 2;
}

+(instancetype)getWeiboCellWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"WEIBOCELL";
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    return cell;
}

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    JDUserModel *user = status.user;
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
    self.iconImageView.contentMode = UIViewContentModeCenter;
    // cell高度：
    self.originalWeiboHeight.constant = [self.contentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + self.contentLabel.y + kMargin;
}

-(CGFloat)getCellHeightWithStatus:(JDStatusModel *)status {
    self.status = status;
    return self.originalWeiboHeight.constant + kMargin * 2;
}

@end
