//
//  JDComposeController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/3.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDComposeController.h"
#import "JDTextView.h"
#import "JDAccountModel.h"
#import "JDTextToolsView.h"
#import "JDPhotoController.h"

@interface JDComposeController () <UITextViewDelegate>

/**
 *  输入框：
 */
@property (nonatomic, weak) JDTextView *textView;
/**
 *  自定义的文本工具条：
 */
@property (nonatomic, weak) JDTextToolsView *textTools;
/**
 *  键盘的弹出动画节奏：
 */
@property (nonatomic, assign) NSInteger kbCurve;
/**
 *  键盘的弹出时间：
 */
@property (nonatomic, assign) NSTimeInterval kbTime;
/**
 *  存放textView的容器：
 */
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
/**
 *  配图控制器：
 */
@property (nonatomic, strong) JDPhotoController *photoController;

@end

@implementation JDComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavItems];
    [self setupTextView];
    [self setupTextToolsView];
}

/**
 *  初始化导航栏按钮：
 */
-(void)setupNavItems {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCancelCompose:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送微博" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSendWeibo:)];
}

/**
 *  初始化输入框：
 */
-(void)setupTextView {
    // 初始化textView：
    JDTextView *textView = [[JDTextView alloc] init];
    textView.frame = self.inputContainer.frame;
    [self.inputContainer addSubview:textView];
    textView.placeholder = @"分享您感兴趣的内容......";
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    self.textView = textView;
    // 刚进入界面就弹出键盘：
    [textView becomeFirstResponder];
}

/**
 *  初始化输入工具条：
 */
-(void)setupTextToolsView {
    // 创建自定义工具条：
    CGFloat height = 48;
    JDTextToolsView *textTools = [[JDTextToolsView alloc] initWithFrame:CGRectMake(0, UIScreenSize.height - height, UIScreenSize.width, height)];
    [self.view addSubview:textTools];
    self.textTools = textTools;
    // 监听系统键盘弹出：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

/**
 *  工具条弹出：
 */
-(void)keyboardWillHidden:(NSNotification *)notification {
    JDLog(@"%s", __func__);
    [UIView animateWithDuration:self.kbTime delay:0 options:self.kbCurve animations:^{
        self.textTools.transform = CGAffineTransformIdentity;
    } completion:nil];
}

/**
 *  键盘即将弹出时调用：
 *
 *  @param notification
 */
-(void)keyboardWillShow:(NSNotification *)notification {
    JDLog(@"%s", __func__);
    // 取出键盘frame：
    CGRect kbFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    
    // 获取键盘弹出的动画时间：
    NSTimeInterval time = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.kbTime = time;
    // 获取键盘弹出动画节奏：
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.kbCurve = curve;
    // 动画弹出tools：
    [UIView animateWithDuration:time delay:0 options:curve animations:^{
        self.textTools.transform = CGAffineTransformMakeTranslation(0, -kbHeight);
    } completion:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 发送按钮默认不可点击：
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length > 0);
}

/**
 *  取消撰写微博：
 *
 *  @param item
 */
-(void)clickToCancelCompose:(UIBarButtonItem *)item {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送微博：
 *
 *  @param item
 */
-(void)clickToSendWeibo:(UIBarButtonItem *)item {
    JDLog(@"%s", __func__);
    // 判断发送的微博是否带有配图：
    if (self.photoController.photosArray.count > 0) {
        [self sendWeiboWithPhoto];
    } else {
        [self sendWeiboOnlyText];
    }
}

/**
 *  发送带有照片的微博：
 */
-(void)sendWeiboWithPhoto {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    parameters[@"access_token"] = account.access_token;
    parameters[@"status"] = self.textView.text;
    
#warning 图片是二进制数据，不能通过字典来传输。
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  上传图片文件：
         *
         *  @param NSData 二进制数据；
         *
         *  @return
         */
        UIImage *photo = [self.photoController.photosArray firstObject];
        NSData *photoData = UIImagePNGRepresentation(photo);
        [formData appendPartWithFileData:photoData name:@"pic" fileName:@"photo" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"<++++> 发送成功...");
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"<----> 发送失败...");
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

/**
 *  拿到目标控制器：
 *
 *  @param segue
 *  @param sender
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    JDLog(@"%@", segue.destinationViewController);
    self.photoController = segue.destinationViewController;
}

/**
 *  发送只有图片的微博：
 */
-(void)sendWeiboOnlyText {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    // 封装用户输入需要发送的文本内容：
    parameters[@"status"] = self.textView.text;
    
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"微博发送成功....");
        // 关闭发送界面：
        [self clickToCancelCompose:nil];
        // 弹窗提示发送成功：
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"<----> %@", error);
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

#pragma mark - UITextViewDelegate 

/**
 *  滚动textView时，关闭键盘：
 *
 *  @param scrollVie
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

/**
 *  文字变动时调用：
 *
 *  @param textView
 */
-(void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length > 0;
}

@end
