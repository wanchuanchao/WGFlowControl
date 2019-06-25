//
//  WGViewController.m
//  WGFlowControl
//
//  Created by wanccao on 02/27/2019.
//  Copyright (c) 2019 wanccao. All rights reserved.
//

#import "WGViewController.h"
#import "WGViewFlowManager.h"
@implementation WGViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WGVFMShowViews();
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    WGVFMHideViews();
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button1.backgroundColor = UIColor.blueColor;
    [button1 setTitle:@"异步展示视图" forState:(UIControlStateNormal)];
    button1.frame = CGRectMake(100, 200, 200, 30);
    [button1 addTarget:self action:@selector(addViewAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button1];
    NSLog(@"test");
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button2.backgroundColor = UIColor.blueColor;
    [button2 setTitle:@"重置展示限制" forState:(UIControlStateNormal)];
    button2.frame = CGRectMake(100, 250, 200, 30);
    [button2 addTarget:self action:@selector(resetAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button3.backgroundColor = UIColor.redColor;
    [button3 setTitle:@"模拟viewWillAppear" forState:(UIControlStateNormal)];
    button3.frame = CGRectMake(100, 300, 200, 30);
    [button3 addTarget:self action:@selector(viewWillAppearAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button4.backgroundColor = UIColor.redColor;
    [button4 setTitle:@"模拟viewDidDisappear" forState:(UIControlStateNormal)];
    button4.frame = CGRectMake(100, 350, 200, 30);
    [button4 addTarget:self action:@selector(viewDidDisappearAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button5.backgroundColor = UIColor.redColor;
    [button5 setTitle:@"模拟loginout" forState:(UIControlStateNormal)];
    button5.frame = CGRectMake(100, 400, 200, 30);
    [button5 addTarget:self action:@selector(loginoutAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button5];
}

- (void)addViewAction{
    NSLog(@"WGViewFlowLog %s",__func__);
    if (WGVFMHasShowed()) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            WGVFMAddGuideView(WGViewFlowViewTypeType3);
        });
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            WGVFMAddGuideView(WGViewFlowViewTypeType1);
        });
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            WGVFMAddGuideView(WGViewFlowViewTypeType2);
        });
    });
}
- (void)resetAction{
    NSLog(@"WGViewFlowLog %s",__func__);
    //重置只显示一次的限制
    //可用于测试debug模式
    WGVFMReset();
}
- (void)viewWillAppearAction{
    NSLog(@"WGViewFlowLog %s",__func__);
    //模拟viewWillAppear
    WGVFMShowViews();
}
- (void)viewDidDisappearAction{
    NSLog(@"WGViewFlowLog %s",__func__);
    //模拟viewDidDisappear
    WGVFMHideViews();
}
- (void)loginoutAction{
    NSLog(@"WGViewFlowLog %s",__func__);
    //模拟用户退出
    WGVFMCleanAll();
}

@end
