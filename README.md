# WGFlowControl

[![CI Status](https://img.shields.io/travis/wanccao/WGFlowControl.svg?style=flat)](https://travis-ci.org/wanccao/WGFlowControl)
[![Version](https://img.shields.io/cocoapods/v/WGFlowControl.svg?style=flat)](https://cocoapods.org/pods/WGFlowControl)
[![License](https://img.shields.io/cocoapods/l/WGFlowControl.svg?style=flat)](https://cocoapods.org/pods/WGFlowControl)
[![Platform](https://img.shields.io/cocoapods/p/WGFlowControl.svg?style=flat)](https://cocoapods.org/pods/WGFlowControl)

WGFlowControl旨在解决多视图展示冲突的问题
> 由两部分组成
>
> WGViewFlowDelegate
>
> WGViewFlow

#### WGViewFlowDelegate
/**
WGViewFlow会根据设置的组别标志,将所有添加视图进行分组管理,相同组别的视图会统一展示
一个组别的默认展示一个视图,视图添加完成后,会立即进行展示
如需要统一展示多个视图,需要设置WGViewFlowViewCounts方法
@notice 禁止使用@"WGFlowControlManagerWaitingShowIdentifier"
@notice 相同的GroupIdentifier,WGViewFlowViewCounts返回的个数也要相同
@return 组别的标志
*/
- (NSString *)WGViewFlowGroupIdentifier;

/**
通过实现方法,获得dismissBlock,在视图消失时,主动调用dismissBlock,将继续自动展示下一个视图
@param dismissBlock 视图消失时,需要主动调用
*/
- (void)WGViewFlowDismissBlock:(void (^)(void))dismissBlock;

@optional

/**
负责视图的排序功能,相同的GroupIdentifier有效
GroupIdentifier组内仅有一个view时,不需要设置
多个view时,已添加的view都会有GroupIdentifier标志组别,相同的组的view会根据返回的SortIdentifier进行排序
排序规则[view1.SortIdentifier compare:view2.SortIdentifier]从小到大排序
@return SortIdentifier 排序标志 默认:nil
*/
- (NSString *)WGViewFlowSortIdentifier;

/**
限制同一GroupIdentifier的视图总个数.
默认 1 ,一个视图添加成功后,会立即进行展示
返回 > 1 时,添加的相同的GroupIdentifier的view个数 >= count时,会将相同的GroupIdentifier的view一起进行展示,并根据每个view的SortIdentifier进行排序
@return count 返回相同GroupIdentifier的视图的个数,默认 1
*/
- (NSInteger)WGViewFlowViewCounts;

/**
[WGViewFlow addView:error:]过程中,通过设置的BOOL返回值,控制是否更新已添加的标志相同的视图
WGViewFlowViewCounts返回1时,只判断WGViewFlowGroupIdentifier返回的标志,不会判断WGViewFlowSortIdentifier返回的排序标志
@return needUpdate 默认NO,不会更新已添加的相同的视图;YES,始终会替换最新的视图
*/
- (BOOL)WGViewFlowNeedUpdate;

/**
用于在展示视图之前做一些操作,设置stop可以判断跳过展示,返回用于展示该视图的父视图
@param stop 展示前判断,可设置跳过展示此视图 ,默认NO;
@return superView 返回视图的superView,默认:[UIApplication sharedApplication].delegate.window
*/
- (UIView *)WGViewFlowViewWillShow:(BOOL *)stop;

####  WGViewFlow
/**
添加待展示的view
@param view 待展示的view
*/
+ (void)addView:(UIView<WGViewFlowDelegate> *)view error:(WGViewFlowError *)error;

/**
展示待展示的视图
*/
+ (void)showViews;

/**
移除屏幕,并暂停展示
*/
+ (void)hideViews;

/**
清除所有,已展示的view,和待展示的view,可用于用户退出时,清除用户数据
*/
+ (void)cleanViews;


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

WGFlowControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WGFlowControl'
```

## Author

wanccao, wanchuanchao@zbj.com

## License

WGFlowControl is available under the MIT license. See the LICENSE file for more info.
