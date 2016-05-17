
//
//  JDHomeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDHomeController.h"
#import "JDScanCodeController.h"
#import "JDCustomTitleView.h"
#import "JDMenuContentController.h"
#import "JDWelcomeView.h"
#import "JDAccountModel.h"
#import "JDStatusModel.h"
#import "JDUserModel.h"
#import "JDWeiboCell.h"

// 获取用户信息的链接：
#define kUsersInfoURL @"https://api.weibo.com/2/users/show.json"
// 获取最新微博数据的链接：
#define kNewWeiboStatusesURL @"https://api.weibo.com/2/statuses/home_timeline.json"
// 获取更多微博数据的链接：
#define kMoreWeiboStatusesURL kNewWeiboStatusesURL

@interface JDHomeController () {
    UIWindow *_window;
    JDMenuContentController *_contentVC;
}

/**
 *  蒙板：
 */
@property (nonatomic, weak) UIButton *coverButton;
/**
 *  导航条的titleView：
 */
@property (nonatomic, weak) JDCustomTitleView *titleButton;
/**
 *  用于存放微博数据的数组：
 */
@property (nonatomic, strong) NSMutableArray *statusesArray;

@end

@implementation JDHomeController

-(NSMutableArray *)statusesArray {
    if (!_statusesArray) {
        _statusesArray = [NSMutableArray array];
    }
    return _statusesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

// wheelImageView开始旋转：
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.welcomView != nil) {
        [self.welcomView startRevolve];
    }
}

// wheelImageView停止：
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.welcomView != nil) {
        [self.welcomView stopRevolve];
    }
}

/**
 *  初始化导航栏：
 */
-(void)setupNavigationBar {
    // 去掉分割线：
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    // 设置导航条：
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:nil normalImageName:@"navigationbar_friendsearch" highlightedImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(clickToSearchFriends:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:nil normalImageName:@"navigationbar_pop" highlightedImageName:@"navigationbar_pop_highlighted" target:self action:@selector(clickToUseCamera:)];
    // 设置titleView：
    JDCustomTitleView *titleBtn = [[JDCustomTitleView alloc] init];
    [self.navigationItem setTitleView:titleBtn];
    [titleBtn addTarget:self action:@selector(clickToAlertMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton = titleBtn;
    
    // 设置游客欢迎界面：
    if (self.welcomView != nil) {
        self.welcomView.iconImageName = @"visitordiscover_feed_image_house";
        self.welcomView.infoText = @"当你关注一些人后，他们发布的最新消息会显示在这里。";
    } else {
        // 如果welcomeView == nil，则表明用户已经完成授权：
        // 加载用户信息：
        [self loadUserInfo];
        // 添加下拉刷新：
        [self addRefreshControl];
    }
}

/**
 *  初始化用户信息：
 */
-(void)loadUserInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    [manager GET:kUsersInfoURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"获取用户信息成功.... %@", responseObject);
        // 存储用户头像：
        NSString *lastIconURLStr = account.profile_image_url;
        NSString *currentIconUrlStr = responseObject[@"profile_image_url"];
        // 重新保存授权模型：
        if (lastIconURLStr != nil && ![lastIconURLStr isEqualToString:currentIconUrlStr]) {
            account.profile_image_url = currentIconUrlStr;
            [account svaeAccountToSandbox];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"设置用户信息出错.... %@", error);
    }];
}

-(void)addRefreshControl {
    // 添加下拉刷新：
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block：
        [self loadNewWeiboStatuses];
        [self.tableView.mj_header endRefreshing];
    }];
    // 添加上拉刷新：
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block：
        [self loadMoreWeiboStatuses];
        [self.tableView.mj_footer endRefreshing];
    }];
    // 自动刷新：
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  加载最新微博数据：
 */
-(void)loadNewWeiboStatuses {
    // 加载最新微博后隐藏新微博提示：
    self.tabBarItem.badgeValue = @"";
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    //
    if (self.statusesArray != nil) {
        parameters[@"since_id"] = [[self.statusesArray firstObject] idstr];
    }
    
    [manager GET:kNewWeiboStatusesURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"加载新微博数据成功.... %@", responseObject[@"statuses"]);
        // 字典数组转模型数组：
        NSArray *statusModelsArray = [JDStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // addObject是将一个数组本身作为元素添加到进去，而addObjectsFromArray是将一个数组中的元素一个一个取出来再加入另一个数组：
        //        [self.statusesArray addObjectsFromArray:statusModelsArray];
        [self.statusesArray insertObjects:statusModelsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statusModelsArray.count)]];
        JDLog(@"微博模型数组.... %@", statusModelsArray);
        // 刷新数据：
        [self.tableView reloadData];
        // 显示刷新了多少条数据：
        [self showNewWeiboStatusesCount:statusModelsArray.count];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"加载新微博数据失败.... %@", error);
    }];
}

/**
 *  显示刷新的微博数量：
 *
 *  @param statusesCount
 */
-(void)showNewWeiboStatusesCount:(NSInteger)statusesCount {
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, JDScreenWidth, 25)];
    // 有新微博才显示：
    if (statusesCount == 0) {
        countLabel.text = @"目前还没有新微博";
    } else {
        countLabel.text = [NSString stringWithFormat:@"刷新到%ld条新微博", statusesCount];
    }
    countLabel.font = [UIFont systemFontOfSize:14.0f];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [countLabel setBackgroundColor:[UIColor orangeColor]];
    [self.navigationController.view addSubview:countLabel];
    countLabel.alpha = 0.0;
    
    // 动画显示新微博数量：
    [UIView animateWithDuration:0.5f animations:^{
        countLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.5f animations:^{
                countLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                [countLabel removeFromSuperview];
            }];
        });
    }];
}

/**
 *  加载更多微博数据：
 */
-(void)loadMoreWeiboStatuses {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    // 取出数组的最后一个元素的ID：
    NSString *lastStatusesID = [[self.statusesArray lastObject] idstr];
    if (lastStatusesID != nil) {
        parameters[@"max_id"] = @([lastStatusesID longLongValue] - 1);
    }
    
    [manager GET:kMoreWeiboStatusesURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *statusModelsArray = [JDStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        [self.statusesArray addObjectsFromArray:statusModelsArray];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 *  点击弹出菜单条：
 *
 *  @param sender
 */
-(void)clickToAlertMenuBar:(UIButton *)sender {
    JDLog(@"点击了弹出菜单条....");
    // 按钮选中：
    sender.selected = YES;
    // 创建显示内容的view：
    _contentVC = [[JDMenuContentController alloc] init];
    // 创建菜单条：
    CGFloat width = 217;
    CGFloat height = 350;
    [self setupMenuBarWithTargetView:self.navigationController.navigationBar contentView:_contentVC.view width:width height:height];
}

/**
 *  初始化菜单条：
 *
 *  @param targetView  菜单条弹出后需要指向的view；
 *  @param contentView 菜单条中显示内容的view；
 *  @param height 菜单条的高度。
 */
-(void)setupMenuBarWithTargetView:(UIView *)targetView contentView:(UIView *)contentView width:(CGFloat)width height:(CGFloat)height {
    // 添加蒙板，实现点击屏幕除菜单条外的任意位置，收起菜单条的效果：
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:JDScreenBounds];
    [coverBtn setBackgroundColor:[UIColor clearColor]];
#warning UIWindow不要乱创建，能用.keyWindow获取的就尽量这么做。
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:coverBtn];
    
    // 菜单条的尺寸计算：
    CGFloat menuWidth = width;
    CGFloat menuHeight = height;
    CGFloat menuMargin = 9;
    CGFloat menuX = 0;
    CGFloat menuY = 0;
    // 菜单条中显示内容的tableView尺寸的计算：
    CGFloat contentMarginX = 20;
    CGFloat contentMarginY = 30;
    CGFloat contentWidth = menuWidth - contentMarginX;
    CGFloat contentHeight = menuHeight - contentMarginY;
    CGFloat contentX = contentMarginX * 0.5;
    CGFloat contentY = contentMarginY * 0.56;
    
    // 菜单条：
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
    menuImageView.frame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    menuImageView.userInteractionEnabled = YES;
    // 显示内容的view：
    contentView.frame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
    [menuImageView addSubview:contentView];
    
    // 后续操作：
    [coverBtn addSubview:menuImageView];
    [coverBtn addTarget:self action:@selector(clickToCloseMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    // 由于需要指向的目标view的superView可能和菜单条所在superView不是同一个，这也就意味着双方不在同一个坐标系中，此时就必须用到坐标系的转换：
    CGRect resultRect = [_window convertRect:targetView.frame fromView:targetView.superview];
    CGPoint resultPoint = [_window convertPoint:targetView.center fromView:targetView.superview];
    menuImageView.y = CGRectGetMaxY(resultRect) - menuMargin;
    menuImageView.centerX = resultPoint.x;
    self.coverButton = coverBtn;
}

/**
 *  点击收起菜单条：
 */
-(void)clickToCloseMenuBar:(UIButton *)sender {
    JDLog(@"点击了收起菜单条....");
    // 销毁window：
    self.titleButton.selected = NO;
    [self.coverButton removeFromSuperview];
    _window = nil;
    _contentVC = nil;
}

/**
 *  点击进入查找好友界面：
 *
 *  @param sender
 */
-(void)clickToSearchFriends:(UIButton *)sender {
    JDLog(@"点击了查找好友按钮....");
}

/**
 *  点击启动相机进入扫码界面：
 *
 *  @param sender
 */
-(void)clickToUseCamera:(UIButton *)sender {
    JDLog(@"点击了启动相机按钮....");
    // 从SB中加载控制器：
    UIStoryboard *scanSB = [UIStoryboard storyboardWithName:@"JDScanCodeController" bundle:nil];
    JDScanCodeController *scanVC = [scanSB instantiateInitialViewController];
    [self presentViewController:scanVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboCell *cell = [JDWeiboCell getWeiboCellWithTableView:tableView];
    JDStatusModel *status = self.statusesArray[indexPath.row];
    cell.status = status;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WEIBOCELL"];
    JDStatusModel *status = self.statusesArray[indexPath.row];
    return [cell getCellHeightWithStatus:status];
}

@end
