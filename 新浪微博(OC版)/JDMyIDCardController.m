//
//  JDMyIDCardController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/26.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDMyIDCardController.h"

@interface JDMyIDCardController ()

/**
 *  显示二维码的容器：
 */
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@end

@implementation JDMyIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];

}

/**
 *  生成二维码数据并转换为图片：
 */
-(void)setupQRCodeImage {
    // 创建滤镜：
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 还原滤镜属性：
    [filter setDefaults];
    // 将二维码数据转换为二进制：
    NSData *data = [@"123" dataUsingEncoding:NSUTF8StringEncoding];
    // 赋值给滤镜：
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 生成图片：
    CIImage *image = [filter outputImage];
    UIImage *bgImg = [self createNonInterpolatedUIImageFormCIImage:image withSize:600];
    UIImage *iconImg = [UIImage imageNamed:@"icon"];
    self.QRCodeImageView.image = [self setupIconImageWithBackgroundImage:bgImg andIconImage:iconImg];
}

/**
 *  在二维码的中心绘制头像图标：
 *
 *  @param bgImgae
 *  @param iconImage
 */
-(UIImage *)setupIconImageWithBackgroundImage:(UIImage *)bgImgae andIconImage:(UIImage *)iconImage {
    UIGraphicsBeginImageContextWithOptions(bgImgae.size, YES, 0.0f);
    // 绘制背景：
    [bgImgae drawInRect:CGRectMake(0, 0, bgImgae.size.width, bgImgae.size.height)];
    // 绘制图表：
    CGFloat width = 60;
    CGFloat height = width;
    CGFloat x = (bgImgae.size.width - width) * 0.5;
    CGFloat y = (bgImgae.size.height - height) * 0.5;
    [iconImage drawInRect:CGRectMake(x, y, width, height)];
    // 取出图片：
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

/**<------------------------------------------------------------------>*/

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
