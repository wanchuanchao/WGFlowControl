//
//  WGViewController.m
//  WGFlowControl
//
//  Created by wanccao on 02/27/2019.
//  Copyright (c) 2019 wanccao. All rights reserved.
//

#import "WGViewController.h"

static NSString *const WGViewControllerTableViewReusableCellIdentifier = @"WGViewControllerTableViewReusableCellIdentifier";

@interface WGViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:([UIScreen mainScreen].bounds) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WGViewControllerTableViewReusableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:WGViewControllerTableViewReusableCellIdentifier];
    }
    return cell;
}


@end
