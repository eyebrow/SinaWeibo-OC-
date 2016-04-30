//
//  JDWeiboToolsView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/7.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWeiboToolsView.h"
#import "JDStatusModel.h"

@interface JDWeiboToolsView ()

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
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
/**
 *  地步工具条高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weiboToolsHeight;

@end

@implementation JDWeiboToolsView

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    // 转发：
    [self setupWeiboToolsViewWithButton:self.forwardButton andNotifyCount:status.reposts_count andOriginalTitle:@"转发"];
    // 评论：
    [self setupWeiboToolsViewWithButton:self.reviewButton andNotifyCount:status.attitudes_count andOriginalTitle:@"评论"];
    // 点赞：
    [self setupWeiboToolsViewWithButton:self.praiseButton andNotifyCount:status.comments_count andOriginalTitle:@"赞"];
}

/**
 *  通过传入button对象和显示通知的数量，创建toolsView：
 *
 *  @param button
 *  @param count
 */
-(void)setupWeiboToolsViewWithButton:(UIButton *)button andNotifyCount:(NSNumber *)count andOriginalTitle:(NSString *)title {
    // 设置地步工具条的相关属性：
    if (count.longLongValue > 0) {
        // 有转发量：
        NSString *forwardTitle = nil;
        if (count.longLongValue > 100000) {
            double forwrads = count.longLongValue / 10000.0;
            forwardTitle = [NSString stringWithFormat:@"%0.1f万", forwrads];
            // 将字符串中的.0替换为空：
            forwardTitle = [forwardTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
        } else {
            forwardTitle = [count description];
        }
        [button setTitle:forwardTitle forState:UIControlStateNormal];
    } else {
        [button setTitle:title forState:UIControlStateNormal];
    }
}

/**
 *  点击转发微博：
 *
 *  @param sender
 */
- (IBAction)clickToForwardWeibo:(UIButton *)sender {
    JDLog(@"%s", __func__);
}

/**
 *  点击发表评论：
 *
 *  @param sender
 */
- (IBAction)clickToReview:(UIButton *)sender {
    JDLog(@"%s", __func__);
}

/**
 *  点击赞：
 *
 *  @param sender
 */
- (IBAction)clickToPraise:(UIButton *)sender {
    JDLog(@"%s", __func__);
}

@end
