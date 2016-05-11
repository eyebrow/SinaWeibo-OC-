//
//  JDWelcomeView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWelcomeView.h"

@interface JDWelcomeView ()

/**
 *  最外侧的轮子view：
 */
@property (weak, nonatomic) IBOutlet UIImageView *wheelImageView;
/**
 *  中间的iconView：
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  显示文字信息：
 */
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
/**
 *  infoLabel y轴的约束：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLabelTop;
/**
 *  定时器：
 */
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation JDWelcomeView

+(instancetype)getWelcomeViewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:@"JDWelcomeView" owner:nil options:nil] lastObject];
}

/**
 *  点击进入授权登录页面：
 *
 *  @param sender
 */
- (IBAction)clickToLogin:(UIButton *)sender {
    JDLog(@"点击了登录按钮....");
}

/**
 *  点击进入注册页面：
 *
 *  @param sender
 */
- (IBAction)clickToRegister:(UIButton *)sender {
    JDLog(@"点击了注册按钮....");
}

/**----------重写setter方法，为属性赋值：------------*/

-(void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    self.infoLabel.text = infoText;
}

-(void)setIconImageName:(NSString *)iconImageName {
    _iconImageName = iconImageName;
    self.iconImageView.image = [UIImage imageNamed:iconImageName];
}

-(void)setWheelHidden:(BOOL)wheelHidden {
    _wheelHidden = wheelHidden;
    self.wheelImageView.hidden = wheelHidden;
}

-(void)setInfoTop:(CGFloat)infoTop {
    _infoTop = infoTop;
    self.infoLabelTop.constant = infoTop;
}

/**------------wheelImageView旋转：---------------*/

-(void)startRevolve {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(revole)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

-(void)stopRevolve {
    [self.link invalidate];
    self.link = nil;
}

/**
 *  旋转：
 */
-(void)revole {
    self.wheelImageView.transform = CGAffineTransformRotate(self.wheelImageView.transform, M_PI / 250);
}

@end
