//
//  JDHomeController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDHomeController.h"
#import "JDScanCodeController.h"
#import "JDTitleButton.h"
#import "JDContentController.h"
#import "JDMenuBar.h"
#import "JDAccountModel.h"
#import "JDStatusModel.h"
#import "JDUserModel.h"
#import "JDPhotoModel.h"
#import "JDWeiboCell.h"

@interface JDHomeController () <JDMenuBarDelegate> {
    JDMenuBar *_menuBar;
    JDContentController *_contentVC;
}

/**
 *  http管理对象：
 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
@property (nonatomic, weak) UIButton *coverBtn;
@property (nonatomic, weak) JDTitleButton *titleBtn;
/**
 *  里边存储所有微博的字典：
 */
@property (nonatomic, strong) NSMutableArray *statusesArray;

@end

@implementation JDHomeController

/**
 *  初始化微博数据数组：
 *
 *  @return
 */
-(NSMutableArray *)statusesArray {
    if (!_statusesArray) {
        _statusesArray = [NSMutableArray array];
    }
    return _statusesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 查找朋友：
    UIBarButtonItem *friendItem = [UIBarButtonItem crateBarButtonItemWithNormalImageName:@"navigationbar_friendsearch" andHighlightedImageName:@"navigationbar_friendsearch_highlighted" andTarget:self andAction:@selector(clickToSearchFriends:)];
    self.navigationItem.leftBarButtonItem = friendItem;
    // 扫码：
    UIBarButtonItem *scanItem = [UIBarButtonItem crateBarButtonItemWithNormalImageName:@"navigationbar_pop" andHighlightedImageName:@"navigationbar_pop_highlighted" andTarget:self andAction:@selector(clickToUseCameraToScanCode:)];
    self.navigationItem.rightBarButtonItem = scanItem;
    
    // 创建标题按钮：
    JDTitleButton *titleBtn = [[JDTitleButton alloc] init];
    self.navigationItem.titleView = titleBtn;
    [titleBtn addTarget:self action:@selector(clickToAlertMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn = titleBtn;
    
    if (self.defaultCenterView != nil) {
        self.defaultCenterView.iconImageName = @"visitordiscover_feed_image_smallicon";
        self.defaultCenterView.infoText = @"当你关注一些人后，他们发布的最新消息会显示在这里。";
        self.defaultCenterView.turntableHidden = NO;
    } else {
        // 加载用户信息：
        [self setupUserInfo];
        // 刷新：
        [self setupRefresh];
    }
}

/**
 *  初始化用户信息：
 */
-(void)setupUserInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    self.manager = manager;
    // 封装请求参数：
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    // 发送get请求：
    NSString *urlStr = @"https://api.weibo.com/2/users/show.json";
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        JDLog(@"<---> %@", responseObject);
        // 获取当前头像url：
        NSString *currentIconURL = responseObject[@"profile_image_url"];
        account.profile_image_url = responseObject[@"profile_image_url"];
        // 当前和从网络获取的如果一样则直接return，不一样则替换后重新存储：
        if ([currentIconURL isEqualToString:account.profile_image_url]) {
            return;
        }
        account.profile_image_url = currentIconURL;
        [account saveAccountInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"<+++> %@", error);
    }];
}

/**
 *  初始化下拉刷新功能：
 */
-(void)setupRefresh {
    // 集成下拉刷新：
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewWeiboData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWeiboData)];
}

/**
 *  加载最新微博数据：
 */
-(void)loadNewWeiboData {
    // 清空
    self.tabBarItem.badgeValue = @"";
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = [JDAccountModel getAccountInfo].access_token;
    // 取出数组中第一个元素的id：
    NSString *firstID = [[self.statusesArray firstObject] idstr];
    if (firstID) {
        parameters[@"since_id"] = firstID;
    }
    
    // 发送请求：
    [self.manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *statuses = responseObject[@"statuses"];
        NSArray *modelsArray = [JDStatusModel mj_objectArrayWithKeyValuesArray:statuses];
        [self.statusesArray addObjectsFromArray:modelsArray];
        // 在最前面插入新数据：
        NSRange range = NSMakeRange(0, modelsArray.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusesArray insertObjects:modelsArray atIndexes:indexSet];
        [self.tableView reloadData];
        // 刷新后隐藏刷新界面：
        [self.tableView.mj_header endRefreshing];
        
        // 显示刷新的数据数量：
        [self showNewWeiboDataCount:modelsArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"<----> %@", error);
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  根据刷新后微博数据的条数，显示在界面上：
 *
 *  @param statusesArray
 */
-(void)showNewWeiboDataCount:(NSArray *)modelsArray {
    CGFloat width = UIScreenSize.width;
    CGFloat height = 30;
    CGFloat x = 0;
    CGFloat y = 64 - height;
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [countLabel setBackgroundColor:[UIColor orangeColor]];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.view insertSubview:countLabel belowSubview:self.navigationController.navigationBar];
    
    if (modelsArray.count) {
        countLabel.text = [NSString stringWithFormat:@"更新到%ld条微博数据", modelsArray.count];
    } else {
        countLabel.text = [NSString stringWithFormat:@"目前没有新微博数据"];
    }
    
    // 动画弹出label：
    [UIView animateWithDuration:0.6f animations:^{
        countLabel.transform = CGAffineTransformMakeTranslation(0, height);
    } completion:^(BOOL finished) {
        // 延迟一秒执行：
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8f animations:^{
                countLabel.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [countLabel removeFromSuperview];
            }];
        });
    }];
}

/**
 *  上拉加载更多的数据：
 */
-(void)loadMoreWeiboData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = [JDAccountModel getAccountInfo].access_token;
    NSString *lastID = [[self.statusesArray lastObject] idstr];
    if (lastID) {
        parameters[@"max_id"] = @([lastID longLongValue] - 1);
    }
    
    [self.manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *statuses = responseObject[@"statuses"];
        NSArray *modelsArray = [JDStatusModel mj_objectArrayWithKeyValuesArray:statuses];
        [self.statusesArray addObjectsFromArray:modelsArray];
        [self.tableView reloadData];
        // 结束刷新：
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"%@", error);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 开始旋转：
    if (self.defaultCenterView != nil) {
        [self.defaultCenterView startRotate];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 停止旋转：
    if (self.defaultCenterView != nil) {
        [self.defaultCenterView stopRotate];
    }
}

-(void)dealloc {
    _menuBar = nil;
    _contentVC = nil;
}

/**
 *  点击弹出菜单条：
 *
 *  @param titleBtn
 */
-(void)clickToAlertMenuBar:(JDTitleButton *)titleBtn {
    titleBtn.selected = YES;
    // 创建contentView：
    CGFloat width = UIScreenSize.width * 0.5;
    CGFloat height = UIScreenSize.height * 0.5;
#warning 此处ContentController必须要有强引用，否则内容会立即消失。
    _contentVC = [[JDContentController alloc] init];
    _contentVC.view.frame = CGRectMake(0, 0, width, height);
    _menuBar = [[JDMenuBar alloc] init];
    _menuBar.delegate = self;
    [_menuBar putTheMenuBarToTargetView:titleBtn withContentView:_contentVC.view];
}

/**
 *  点击进入查找朋友界面：
 *
 *  @param btn
 */
-(void)clickToSearchFriends:(UIButton *)btn {
    JDLog(@"%s", __func__);
}

/**
 *  点击进入扫码界面：
 *
 *  @param btn
 */
-(void)clickToUseCameraToScanCode:(UIButton *)btn {
    // 弹出扫码窗口：
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"JDScanCodeController" bundle:nil];
    JDScanCodeController *scanCodeVC = [sb instantiateInitialViewController];
    [self presentViewController:scanCodeVC animated:YES completion:nil];
}

#pragma mark - JDMenuBarDelegate 

-(void)menuBardidCancel:(JDMenuBar *)menuBar {
    JDLog(@"%s", __func__);
    self.titleBtn.selected = NO;
}

-(void)menuBarDidCancel:(JDMenuBar *)menuBar {
    self.titleBtn.selected = NO;
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEIBOCELL" forIndexPath:indexPath];
    cell.status = self.statusesArray[indexPath.row];
    return cell;
}

/**
 *  根据cell的内容，返回cell的行高：
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEIBOCELL"];
    return [cell getCellRealHeightWithStatus:self.statusesArray[indexPath.row]] + 15;
}

@end
