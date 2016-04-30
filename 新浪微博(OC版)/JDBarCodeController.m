//
//  JDBarCodeController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/25.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBarCodeController.h"
#import <AVFoundation/AVFoundation.h>

@interface JDBarCodeController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstraintsY;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;

@end

@implementation JDBarCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.tabBarItem.selectedImage = [UIImage getOriginalImgaeWithImageName:@"qrcode_tabbar_icon_barcode_highlighted"];
    [self.navigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(keepOnUpdating)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self scanningTheBarCode];
}

-(void)scanningTheBarCode {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
#warning 
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode,
                                     AVMetadataObjectTypeCode39Code,
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code,
                                     AVMetadataObjectTypeCode128Code,
                                     AVMetadataObjectTypePDF417Code,
                                     AVMetadataObjectTypeAztecCode,
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode]];
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    self.layer = layer;
    [session startRunning];
    self.session = session;
}

-(void)keepOnUpdating {
    self.ConstraintsY.constant += 5;
    if (self.ConstraintsY.constant >= 124) {
        self.ConstraintsY.constant = -124;
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    JDLog(@"%s", __func__);
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        [self.layer removeFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        NSString *values = obj.stringValue;
        JDLog(@"%@", values);
    }
}

@end
