//
//  WGFlowControlView.h
//  Pods-WGFlowControl_Example
//
//  WGFlowControlView封装了一些视图展示前,和消失后的控制代码
//  需要和WGFlowControlManager的子类配合使用
//
//  使用步骤:
//  1 创建一个WGFlowControlManager的子类实例:manager
//  2 创建一个WGFlowControlView的子类实例:view
//  3 调用[manager addView:view identifier:identifier],将view按照identifier分组,添加到manager的流程控制中
//  4 需要设置每个view的sortString,manager会根据sortString的大小将相同identifier的视图排序
//  5 manager会主动调用view的show方法来展示view,详情看show的注释
//  6 需要主动调用view的dismiss方法,来结束view的展示,内部会自动通过代理manager来展示下一个待展示的视图
//  7 可以通过实现view的willShowBlock,和didDismissedBlock在展示前,和展示结束后进行添加一些操作(例如指定父视图)
//
//  简单的说,设置view的sortString进行排序,添加到manager中,调用dismiss结束显示
//
//  Created by wanccao on 27/2/2019.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 视图dismiss的代理
 WGFlowControlManager在添加view时已处理
 */
@protocol WGFlowControlView <NSObject>
+ (void)viewDismissed;
@end

@interface WGFlowControlView : UIView
/**
 view在dismiss时的代理
 note: 不要设置
 因为[WGFlowControlManager addView:identifier:]内部已设置WGFlowControlManager为代理
 
 @param classObj 接收代理的类
 */
- (void)configDelegate:(Class<WGFlowControlView>)classObj;

/**
 用于view展示时设置一些操作
 note: 不要主动调用
 note: 一般不用重写show方法
 调用[WGFlowControlManager addView:identifier:]将view成功加入流程管理之后,
 WGFlowControlManager会根据每个view的sortString大小顺序,自动调用view的show方法,来展示view
 show方法内部会调用willShowBlock()获取返回的父视图,可以在willShowBlock()里面设置一些用于展示前的操作
 note: 重写show方法时,可以在view展示之前做一些操作,重写时需调用[super show]
 */
- (void)show;

/**
 note: 需要主动调用dismiss来结束view的展示
 内部会调用removeFromSuperview
    会调用didDismissedBlock(),
    会调用代理WGFlowControlManager的viewDismissed方法,来展示下一个界面
 */
- (void)dismiss;

/**
 用于设置每个view的展示顺序
 note: 需要设置
 [WGFlowControlManager addView:identifier:]时,相同的identifier的view,会根据sortString的大小顺序展示
 */
@property (nonatomic, copy) NSString *sortString;

/**
 用于view展示前,进行一些操作
 note: 需要设置
 @return UIView * 返回父视图,未返回则添加到window上
 */
@property (nonatomic, copy) UIView *(^willShowBlock)(void);

/**
 用于view消失前,进行一些操作
 note: 可以设置
 */
@property (nonatomic, copy) void (^didDismissedBlock)(void);
@end

NS_ASSUME_NONNULL_END
