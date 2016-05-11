//
//  JDWelcomeView.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDWelcomeView;

@protocol JDWelcomeViewDelegate <NSObject>

/**
 *  点击进入登录授权界面：
 *
 *  @param welcomeView
 *  @param loginButton
 */
-(void)loginWithWelcomeView:(JDWelcomeView *)welcomeView loginButton:(UIButton *)loginButton;

@end

@interface JDWelcomeView : UIView

/**
 *  图标图片名：
 */
@property (nonatomic, copy) NSString *iconImageName;
/**
 *  信息文字：
 */
@property (nonatomic, copy) NSString *infoText;
/**
 *  是否隐藏wheelImageView：
 */
@property (nonatomic, assign, getter=isWheelHidden) BOOL wheelHidden;
/**
 *  infoLable顶部的距离：
 */
@property (nonatomic, assign) CGFloat infoTop;
/**
 *  代理属性：
 */
@property (nonatomic, weak) id<JDWelcomeViewDelegate> delegate;

/**
 *  快速加载xib：
 *
 *  @return 
 */
+(instancetype)getWelcomeViewFromXib;

-(void)startRevolve;
-(void)stopRevolve;

@end
