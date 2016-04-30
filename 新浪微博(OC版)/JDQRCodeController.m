//
//  JDQRCodeController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/25.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "JDMyIDCardController.h"

@interface JDQRCodeController () <AVCaptureMetadataOutputObjectsDelegate>

/**
 *  扫描图片约束y：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstraintsY;
/**
 *  会话：
 */
@property (nonatomic, strong) AVCaptureSession *session;
/**
 *  预览界面：
 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;

@end

@implementation JDQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建tabBarItem图标和标题：
    self.navigationController.tabBarItem.selectedImage = [UIImage getOriginalImgaeWithImageName:@"qrcode_tabbar_icon_qrcode_highlighted"];
    [self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    
    // 反复执行扫描图片：
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(keepOnUpdating)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    // 扫描二维码：
    [self scanningTheQRCode];
}

/**
 *  扫描二维码的方法：
 */
-(void)scanningTheQRCode {
    // 获取输入设备：
#warning 获取输入设备，必须用defaultDeviceWithMediaType的方式获取。
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入对象：
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    // 创建输出对象：
#warning 因为输出不依赖于设备，所以可以直接创建。
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置输出代理：
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 创建会话并将输入/输出对象加入会话：
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
#warning 由于会话不可重复添加，所以在添加之前需要判断是否能够添加。
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    // 设置输出数据类型：
#warning 输出数据类型必须在输入对象添加后再设置，否则bug。
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    // 创建预览界面：
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    self.layer = layer;
    // 开始采集数据：
    [session startRunning];
#warning 会话必须要有强引用。
    self.session = session;
}

/**
 *  修改扫描图片的y轴的值：
 */
-(void)keepOnUpdating {
    /**
     每次y轴+5，超出扫码区域后(+170)，则重新回到初始位置(-170)重新执行：
     */
    self.ConstraintsY.constant += 5;
    if (self.ConstraintsY.constant >= 170) {
        self.ConstraintsY.constant = -170;
    }
}

/**
 *  点击可以查看我的二维码：
 *
 *  @param sender
 */
- (IBAction)clickToSeeMyIDCard:(UIButton *)sender {
    // 进入名片界面：
    JDMyIDCardController *IDCardVC = [[JDMyIDCardController alloc] init];
    [self.navigationController pushViewController:IDCardVC animated:YES];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

/**
 *  只要解析到了数据，就会调用此代理方法：
 *
 *  @param captureOutput   输出对象；
 *  @param metadataObjects 采集到的数据；
 *  @param connection
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    JDLog(@"%s", __func__);
    // 判断是否采集到了数据：
    if (metadataObjects.count > 0) {
        // 停止扫描操作：
        [self.session stopRunning];
        [self.layer removeFromSuperlayer];
        
        // 拿到数据：
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        NSString *values = obj.stringValue;
        JDLog(@"%@", values);
    }
}

@end
