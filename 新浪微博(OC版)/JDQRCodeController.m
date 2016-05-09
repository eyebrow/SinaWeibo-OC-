
//
//  JDQRCodeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "JDMyIDCardController.h"

@interface JDQRCodeController () <AVCaptureMetadataOutputObjectsDelegate>

/**
 *  二维码扫描图片约束的Y值：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeConstraintY;
/**
 *
 */
@property (nonatomic, strong) CADisplayLink *link;
/**
 *  会话：
 */
@property (nonatomic, strong) AVCaptureSession *session;
/**
 *  显示摄像头预览的layer：
 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;

@end

@implementation JDQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRCodeController];
}

/**
 *  初始化JDQRCodeController：
 */
-(void)setupRCodeController {
    // 设置tabBarItem的属性：
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode"]];
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode_highlighted"] getOriginalImage]];
    [self.navigationController.tabBarController.tabBar setTintColor:[UIColor orangeColor]];
    // 循环播放扫描图片：
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(scanning)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

/**
 *  使用摄像头取景：
 */
-(void)usingCamera {
    // 获取输入设备：
#warning 获取输入设备必须用类方法defaultDeviceWithMediaType，而不能用init的方式，否则会报错。
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 根据输入设备创建输入对象：
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:NULL];
    
    // 创建输出对象：
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置输出对象的代理：
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 创建会话：
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 将输入和输出对象加入会话：
#warning 由于输入和输出不能同时添加，所以添加之前要判断是否已添加。
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session canAddOutput:output];
    }
    
    // 创建预览界面：
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = JDScreenBounds;
    // 置于最底部：
    [self.view.layer insertSublayer:layer atIndex:0];
    self.layer = layer;
    
    // 设置输出数据类型：
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
#warning 设置输出类型必须在将输入和输出对象加入会话之后才能设置，否则会报错。
    // 开始采集数据：
#warning 由于扫描二维码是一个长时间的操作，不能让session被立即释放掉，所以此时session应该有强引用。
    [session startRunning];
    self.session = session;
}

/**
 *  扫描过程执行的方法：
 */
-(void)scanning {
    // 修改扫描图片的y轴约束，实现动态扫描效果：
    self.QRCodeConstraintY.constant += 5;
    if (self.QRCodeConstraintY.constant >= 170) {
        self.QRCodeConstraintY.constant = -170;
    }
}

/**
 *  点击关闭扫码界面：
 *
 *  @param sender
 */
- (IBAction)clickToCloseScanCodePage:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击展示我的名片：
 *
 *  @param sender
 */
- (IBAction)clickToShowMyIDCard:(UIButton *)sender {
    JDMyIDCardController *IDCardVC = [[JDMyIDCardController alloc] init];
    [self.navigationController pushViewController:IDCardVC animated:YES];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate:

// 只要解析到了数据，就会调用此方法：
#warning 该方法的调用频率非常高，所以在扫描停止后应该停止扫描动画。
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 判断是否有数据：
    if (metadataObjects.count > 0) {
        // 停止扫描：
        [self.session stopRunning];
        // 移除预览界面：
        [self.layer removeFromSuperlayer];
        // 取出扫描的数据：
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        JDLog(@"%@", obj.stringValue);
        // 停止扫描动画：
        [self.link invalidate];
    }
}

@end
