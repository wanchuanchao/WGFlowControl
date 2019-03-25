//
//  WGViewFlowView.m
//  WGFlowControl_Example
//
//  Created by wanccao on 22/3/2019.
//  Copyright © 2019 wanccao. All rights reserved.
//

#import "WGViewFlowView.h"

NSString * const WGViewFlowViewIdentifier = @"WGViewFlowViewIdentifier";

static NSString *sortString(WGViewFlowViewType type){
    NSDictionary *sortStrings = @{
                                  @(WGViewFlowViewTypeType1):@"11",
                                  @(WGViewFlowViewTypeType2):@"12",
                                  @(WGViewFlowViewTypeType3):@"13",
                                  };
    return sortStrings[@(type)];
}
static NSString *noticeString(WGViewFlowViewType type){
    NSDictionary *noticeString = @{
                                   @(WGViewFlowViewTypeType1):@"展示界面文本1",
                                   @(WGViewFlowViewTypeType2):@"展示界面文本2",
                                   @(WGViewFlowViewTypeType3):@"展示界面文本3",
                                   };
    return noticeString[@(type)];
}
static NSString *buttonTitle(WGViewFlowViewType type){
    NSDictionary *buttonTitles = @{
                                   @(WGViewFlowViewTypeType1):@"下一页",
                                   @(WGViewFlowViewTypeType2):@"下一页",
                                   @(WGViewFlowViewTypeType3):@"完成",
                                   };
    return buttonTitles[@(type)];
}
@interface WGViewFlowView ()<WGViewFlowDelegate>
@property (nonatomic, assign) WGViewFlowViewType type;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, copy) void (^dismissBlock)(void);
@end
@implementation WGViewFlowView
+ (UIView <WGViewFlowDelegate> *)viewWithType:(WGViewFlowViewType)type{
    WGViewFlowView *view = [[WGViewFlowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.type = type;
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setViews];
    }
    return self;
}
-(void)dismissBlock:(void (^)(void))dismissBlock{
    self.dismissBlock = dismissBlock;
}
-(BOOL)WGViewFlowNeedUpdate{
    return YES;
}
-(NSInteger)WGViewFlowViewCounts{
    return 3;
}
-(NSString *)WGViewFlowGroupIdentifier{
    return WGViewFlowViewIdentifier;
}
- (NSString *)WGViewFlowSortIdentifier{
    return sortString(self.type);
}
- (void)setViews{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.nextButton];
}
-(void)setType:(WGViewFlowViewType)type{
    _type = type;
    [self.nextButton setTitle:buttonTitle(type) forState:(UIControlStateNormal)];
    [self.nextButton setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    self.noticeLabel.text = noticeString(type);
    switch (type) {
        case WGViewFlowViewTypeType1:
        {
            
        }
            break;
        case WGViewFlowViewTypeType2:
        {
            self.noticeLabel.center = CGPointMake(CGRectGetMidX(self.noticeLabel.frame), CGRectGetMaxY(self.noticeLabel.frame)+20);
        }
            break;
        case WGViewFlowViewTypeType3:
        {
            self.noticeLabel.center = CGPointMake(CGRectGetMidX(self.noticeLabel.frame), CGRectGetMaxY(self.noticeLabel.frame)+40);
            [self.nextButton setBackgroundColor:UIColor.blueColor];
            [self.nextButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        }
            break;
    }
}
-(UILabel *)noticeLabel{
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0,150, [UIScreen mainScreen].bounds.size.width, 50))];
        _noticeLabel.backgroundColor = UIColor.yellowColor;
        _noticeLabel.font = [UIFont boldSystemFontOfSize:16];
        _noticeLabel.textColor = UIColor.redColor;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noticeLabel;
}
-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _nextButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, 40);
        _nextButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 500);
        [_nextButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_nextButton setBackgroundColor:UIColor.whiteColor];
        [_nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextButton;
}
- (void)nextButtonAction{
    NSLog(@"WGViewFlowLog %s",__func__);
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:WGViewFlowViewIdentifier];
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
@end
