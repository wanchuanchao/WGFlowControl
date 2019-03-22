//
//  WGViewFlow.h
//  WGFlowControl
//
//  Created by wanccao on 21/3/2019.
//
//  WGViewFlow用来管理待展示的视图的流程
//
//  使用流程
//  创建view遵守WGViewFlowDelegate
//  建议使用WGViewFlow子类,不同的子类,相互独立
//  [WGViewFlow addView:error:]添加view自动展示
//
//  [WGViewFlow addView:error:]内部处理逻辑:
//  首先获取view实现的协议的GroupIdentifier,和SortIdentifier
//  WGViewFlow内部有两类队列:1,一个待展示队列 2,根据view的GroupIdentifier生成对应的队列
//  在两类队列中根据GroupIdentifier和SortIdentifier查找是否有相同的view,按照WGViewFlowNeedUpdate的设置判断是否更新(优先1队列)
//  通过WGViewFlowViewCounts获取view组内视图总个数count,当count=1时,直接在队列1中操作,不会生成第二类队列
//  当count>1时,等待所有的视图添加完毕,将整个队列排序后,放入待展示队列
//  调用showViews之后,待展示队列按照添加时间先后展示
//  view通过实现WGViewFlowViewWillShow:,设置stop判断是否跳过显示
//  view展示完成,通过实现- (void)dismissBlock:(void (^)(void))dismissBlock获得的dismissBlock,进行调用,展示下一个视图
//  调用hideViews时,移除屏幕暂停展示
//  调用cleanViews,移除屏幕,删除所有视图

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WGViewFlowError) {
    WGViewFlowError_nilView,                                         //添加的view不存在
    WGViewFlowError_nilGroupIdentifier,                              //无效或禁用的groupIdentifier
    WGViewFlowError_nilCounts,                                       //无效的count
    WGViewFlowError_nilSortIdentifier_counts,                        //多个view但是count 和 sortIdentifier 不符合规定
};

@protocol WGViewFlowDelegate <NSObject>

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
- (void)dismissBlock:(void (^)(void))dismissBlock;

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
@end

@interface WGViewFlow : NSObject
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
@end
NS_ASSUME_NONNULL_END
