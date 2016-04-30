//
//  JDWelcomeController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/29.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWelcomeController.h"
#import "JDAccountModel.h"
#import "JDTabBarController.h"

@interface JDWelcomeController ()

/**
 *  头像的约束Y：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconConstraintsY;
/**
 *  欢迎文字：
 */
@property (weak, nonatomic) IBOutlet UILabel *welcomeText;
/**
 *  头像：
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation JDWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置头像：
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    // 头像圆形：
    self.iconImageView.layer.cornerRadius = 60;
    self.iconImageView.clipsToBounds = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1.8f animations:^{
        // 头像动画：
        self.iconConstraintsY.constant -= 160;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 文字淡出：
        [UIView animateWithDuration:1.5f animations:^{
            self.welcomeText.alpha = 1.0f;
        } completion:^(BOOL finished) {
            JDTabBarController *mainVC = [[JDTabBarController alloc] init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = mainVC;
        }];
    }];
}

@end
