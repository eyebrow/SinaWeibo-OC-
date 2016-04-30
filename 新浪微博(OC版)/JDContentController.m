//
//  JDContentController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/27.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDContentController.h"

@interface JDContentController ()

@end

@implementation JDContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"CONTENTCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    NSString *str = [NSString stringWithFormat:@"<--------------> %ld", indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

@end
