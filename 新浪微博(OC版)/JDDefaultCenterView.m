//
//  JDDefaultCenterView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/28.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDDefaultCenterView.h"

@interface JDDefaultCenterView ()

/**
 *  图表view：
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  提示文字label：
 */
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
/**
 *  转盘view：
 */
@property (weak, nonatomic) IBOutlet UIImageView *turntableImageView;

/**
 *  定时器：
 */
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation JDDefaultCenterView

+(instancetype)getDefaultCenter {
    return [[[NSBundle mainBundle] loadNibNamed:@"JDDefaultCenterView" owner:nil options:nil] lastObject];
}

+(instancetype)getDefaultCenterWithIconImageName:(NSString *)iconImageName andInfoText:(NSString *)infoText andIsTurntableHidden:(BOOL)turntableHidden {
    JDDefaultCenterView *defaultCenterView = [self getDefaultCenter];
    defaultCenterView.iconImageView.image = [UIImage imageNamed:iconImageName];
    defaultCenterView.infoLabel.text = infoText;
    defaultCenterView.turntableImageView.hidden = turntableHidden;
    
    return defaultCenterView;
}

/**<---------------------------------------------------------->*/

/**
 重写setter方法，为iconImageView、infoLabel赋值，并
 决定是否隐藏转盘。
 */

-(void)setTurntableHidden:(BOOL)turntableHidden {
    _turntableHidden = turntableHidden;
    self.turntableImageView.hidden = turntableHidden;
}

-(void)setIconImageName:(NSString *)iconImageName {
    _iconImageName = iconImageName;
    UIImage *iconImage = [UIImage imageNamed:iconImageName];
    self.iconImageView.image = iconImage;
}

-(void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    self.infoLabel.text = infoText;
}

/**<---------------------------------------------------------->*/

/**
 *  懒加载：
 *
 *  @return
 */
-(CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotate)];
    }
    return _link;
}

-(void)startRotate {
    // 创建定时器：
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopRotate {
    [self.link invalidate];
    self.link = nil;
}

/**
 *  旋转：
 */
-(void)rotate {
    self.turntableImageView.transform = CGAffineTransformRotate(self.turntableImageView.transform, M_PI/200);
}

/**<---------------------------------------------------------->*/

/**
 *  点击进去登录界面：
 *
 *  @param sender
 */
- (IBAction)clickToIntoLoginPage:(UIButton *)sender {
    // 执行代理：
    if ([self.delegate respondsToSelector:@selector(defaultCenterView:didClickLoginButton:)]) {
        [self.delegate defaultCenterView:self didClickLoginButton:sender];
    }
}

/**
 *  点击进入注册界面
 *
 *  @param sender
 */
- (IBAction)clickToIntoRegistPage:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(defaultCenterView:didClickRegistButton:)]) {
        [self.delegate defaultCenterView:self didClickRegistButton:sender];
    }
}

@end
