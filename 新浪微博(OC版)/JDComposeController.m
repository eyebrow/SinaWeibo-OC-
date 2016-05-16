//
//  JDComposeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDComposeController.h"
#import "JDComposeTextView.h"
#import "JDAccountModel.h"
#import "JDComposeToolsBar.h"
#import "JDPhotoController.h"

#define kStatusesUpdateURL @"https://api.weibo.com/2/statuses/update.json"
#define kStatusesUploadURL @"https://upload.api.weibo.com/2/statuses/upload.json"

@interface JDComposeController () <UITextViewDelegate>

/**
 *  自定义的textView：
 */
@property (nonatomic, weak) JDComposeTextView *textView;
@property (nonatomic, weak) JDComposeToolsBar *toolsBar;
/**
 *  用于存放textView的view：
 */
@property (weak, nonatomic) IBOutlet UIView *textViewContainerView;

@property (nonatomic, strong) JDPhotoController *photoVC;

@end

@implementation JDComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComposeController];
}

/**
 *  初始化：
 */
-(void)setupComposeController {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCloseComposePage:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(clickToConfirmSend:)];
    
    // 添加自定义textView：
    JDComposeTextView *textView = [[JDComposeTextView alloc] initWithFrame:self.textViewContainerView.frame];
    // 设置提示文字：
    textView.placeholderText = @"请输入您想要发送的微博内容......";
    // 设置滚动：
    textView.delegate = self;
    // 直接进入编辑状态：
    [textView becomeFirstResponder];
    [self.textViewContainerView addSubview:textView];
    self.textView = textView;
    
    // 添加toolsBar：
    CGFloat width = JDScreenWidth;
    CGFloat height = 30;
    CGFloat x = 0;
    CGFloat y = JDScreenHeight - height;
    JDComposeToolsBar *toolsBar = [[JDComposeToolsBar alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:toolsBar];
    // 监听键盘弹出和收起，动态改变键盘toolsBar的位置：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.toolsBar = toolsBar;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  键盘弹出时调用的方法：
 */
-(void)keyboardWillShow:(NSNotification *)sender {
    // 取出键盘的高度：
    CGRect kbFrame = [sender.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    // toolsBar随着键盘一同弹出：
    [UIView animateWithDuration:0.25 animations:^{
        self.toolsBar.y = JDScreenHeight - kbHeight - self.toolsBar.height;
    }];
}

/**
 *  键盘收起时调用的方法：
 */
-(void)keyboardWillHide:(NSNotification *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.toolsBar.y = JDScreenHeight - self.toolsBar.height;
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.textView.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

/**
 *  点击关闭撰写微博页面：
 *
 *  @param sender
 */
-(void)clickToCloseComposePage:(UIBarButtonItem *)sender {
    JDLog(@"点击了关闭撰写微博界面的按钮....");
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击确认发送一条新微博：
 *
 *  @param sender
 */
-(void)clickToConfirmSend:(UIBarButtonItem *)sender {
    JDLog(@"点击了确认发送一条新微博的按钮....");
    // 如果选择照片的控制器中有照片，则发送带照片的微博：
//    JDLog(@"------------- %ld", self.photoVC.photosArray.count);
    if (self.photoVC.photosArray.count > 0) {
        [self sendNewStatusWithImage];
    } else {
        [self sendNewStatusOnlyText];
    }
}

/**
 *  发送带图片的微博
 */
-(void)sendNewStatusWithImage {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"status"] = self.textView.text;
#warning 二进制数据不能通过字典来传输。
//    parameters[@"pic"] = [self.photoVC.photosArray firstObject];
    
    [manager POST:kStatusesUploadURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 取出图片：
        UIImage *photoImage = [self.photoVC.photosArray firstObject];
//        JDLog(@"----------------- %@", photoImage);
        NSData *photoData = UIImagePNGRepresentation(photoImage);
//        JDLog(@"+++++++++++++++++ %@", photoData);
        // 上传图片文件：
        [formData appendPartWithFileData:photoData name:@"pic" fileName:@"photo" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.view endEditing:YES];
        JDLog(@"发送带图片的微博成功....");
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self clickToCloseComposePage:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"发送带图片的微博失败.... %@", error);
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

/**
 *  发送纯文本微博：
 */
-(void)sendNewStatusOnlyText {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"status"] = self.textView.text;
    
    [SVProgressHUD show];
    [manager POST:kStatusesUpdateURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"发送微博成功.... %@", responseObject);
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self clickToCloseComposePage:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"发送微博失败.... %@", error);
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
    [SVProgressHUD dismiss];
}

// 利用segue拦截控制器切换：
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.photoVC = segue.destinationViewController;
}

#pragma mark - UITextViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

-(void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length > 0;
}

@end
