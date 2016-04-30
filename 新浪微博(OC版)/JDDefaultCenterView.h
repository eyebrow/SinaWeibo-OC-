//
//  JDDefaultCenterView.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/28.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDDefaultCenterView;

@protocol JDDefaultCenterViewDelegate <NSObject>

/**
 *  登录按钮被点击时调用：
 *
 *  @param defaultCenterView
 *  @param loginBtn
 */
-(void)defaultCenterView:(JDDefaultCenterView *)defaultCenterView didClickLoginButton:(UIButton *)loginBtn;
/**
 *  注册按钮被点击时调用：
 *
 *  @param defaultCenterView
 *  @param registBtn
 */
-(void)defaultCenterView:(JDDefaultCenterView *)defaultCenterView didClickRegistButton:(UIButton *)registBtn;

@end

@interface JDDefaultCenterView : UIView

/**
 *  用于接收icon图片名：
 */
@property (nonatomic, copy) NSString *iconImageName;
/**
 *  用于接收infoLabel的文字：
 */
@property (nonatomic, copy) NSString *infoText;
/**
 *  隐藏转盘：
 */
@property (nonatomic, assign) BOOL turntableHidden;
/**
 *  代理：
 */
@property (nonatomic, weak) id<JDDefaultCenterViewDelegate> delegate;

/**
 *  快速加载xib：
 *
 *  @return 
 */
+(instancetype)getDefaultCenter;
/**
 *  快速加载xib(需要替换参数时调用)：
 *
 *  @param iconImageName
 *  @param infoText
 *  @param turntableHidden
 *
 *  @return
 */
+(instancetype)getDefaultCenterWithIconImageName:(NSString *)iconImageName andInfoText:(NSString *)infoText andIsTurntableHidden:(BOOL)turntableHidden;

/**
 *  转盘开始/停止转动：
 */
-(void)startRotate;
-(void)stopRotate;

@end
