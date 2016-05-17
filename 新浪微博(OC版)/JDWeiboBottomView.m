
//
//  JDWeiboBottomView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWeiboBottomView.h"
#import "JDUserModel.h"
#import "JDStatusModel.h"

@interface JDWeiboBottomView ()

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

@implementation JDWeiboBottomView

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    JDUserModel *user = status.user;
    [self setupBootomViewWithStatus:status user:user];
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
