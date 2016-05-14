//
//  JDWelcomeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/13.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWelcomeController.h"
#import "JDTabBarController.h"
#import "UIImageView+WebCache.h"
#import "JDAccountModel.h"

@interface JDWelcomeController ()

/**
 *  文字：
 */
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
/**
 *  头像：
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  头像距离顶部的距离：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewTop;

@end

@implementation JDWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWelcomeController];
}

// 初始化WelcomeController：
-(void)setupWelcomeController {
    // 圆形头像：
    self.iconImageView.layer.cornerRadius = 50;
    self.iconImageView.clipsToBounds = YES;
    // 加载用户头像：
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    // 加载头像的第二种方法：
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:account.profile_image_url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (finished) {
            self.iconImageView.image = image;
        }
    }];
}

// 试图加载完成后调用：
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 头像移动到文字上面：
    [UIView animateWithDuration:2.0f animations:^{
        self.iconImageView.alpha = 1.0f;
        self.iconImageViewTop.constant -= 255;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.welcomeLabel.alpha = 1.0f;
        } completion:^(BOOL finished) {
            // 动画完成后进入主页：
            JDTabBarController *tabBarVC = [[JDTabBarController alloc] init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = tabBarVC;
        }];
    }];
}

@end
