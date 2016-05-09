//
//  JDMyIDCardController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDMyIDCardController.h"
#import <CoreImage/CoreImage.h>

@interface JDMyIDCardController ()

/**
 *  显示二维码头像：
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation JDMyIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupQRCodeImage];
}

-(void)setupQRCodeImage {
    // 创建滤镜：
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 还原滤镜的默认属性：
    [filter setDefaults];
    // 二维码数据转换为二进制：
    NSData *data = [@"灌篮高手郭敬明" dataUsingEncoding:NSUTF8StringEncoding];
    // 给滤镜设置数据：
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 生成高清图片：
    UIImage *QRCodeImage = [UIImage createNonInterpolatedUIImageFormCIImage:[filter outputImage] withSize:600];
    // 添加头像：
    UIImage *finalImage = [self drawUpIconImage:[UIImage imageNamed:@"icon"] intoBackgroundImage:QRCodeImage];
    self.iconImageView.image = finalImage;
}

/**
 *  往一张图片中绘制另一张图片：
 *
 *  @param iconImage 绘制的图片；
 *  @param bgImage   作为背景的图片。
 */
-(UIImage *)drawUpIconImage:(UIImage *)iconImage intoBackgroundImage:(UIImage *)bgImage {
    UIGraphicsBeginImageContextWithOptions(bgImage.size, YES, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    CGFloat width = 180;
    CGFloat height = width;
    CGFloat x = (bgImage.size.width - width) * 0.5;
    CGFloat y = (bgImage.size.height - height) * 0.5;
    [iconImage drawInRect:CGRectMake(x, y, width, height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

@end
