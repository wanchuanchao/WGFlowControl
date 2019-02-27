//
//  WGFlowControlManager.h
//  Pods-WGFlowControl_Example
//
//  WGFlowControlManager用来管理待展示的视图的流程
//  和WGFlowControlView配合使用
//  功能逻辑:
//  通过设置identifier,将所有待展示的视图进行分组依次展示,每次只展示一个视图
//  一个组内的视图按照既定排序依次进行展示
//  不同组间展示顺序没有影响,一个组的视图全部展示完,再展示下个组的
//
//  使用步骤:
//  1 创建一个WGFlowControlManager的子类实例:manager
//  2 manager会给不同的identifier配置不同的group
//  3 调用[manager enterGroup:block identifier:identifier],在block内开启获取数据等操作,group 内部值+1
//  4 调用[manager showViews:]
//  5 调用[manager addView:identifier] ,添加待展示的WGFlowControlView的子类实例
//  6 调用[manager leaveGroup:identifier],group 内部值-1,group内部值置零后,会立即显示所有已添加的视图
//
//  注意事项:
//  以下都是identifier相同的情况
//  a 步骤3和步骤6,必须成对执行,可调用多次,所有的+1都通过-1置零之后,才会展示identifier对应的已添加的视图
//  b 3,4,6的执行线程必须一样,否则不会正常显示
//  c 4必须在至少一次3执行之后,才能执行,且只需执行一次,4和5,6的执行顺序没有约束
//  d 5的执行次数没有限制,但是在成对的3,6执行之后,group内部值会置零,此时,会立即展示已添加的视图,之后再执行5没有作用,视图不会添加成功,除非3,4再次执行
//
//  Created by wanccao on 27/2/2019.
//

#import <Foundation/Foundation.h>
#import "WGFlowControlView.h"
NS_ASSUME_NONNULL_BEGIN

@interface WGFlowControlManager : NSObject

/**
 获取identifier绑定的group,开始值+1操作

 @param block 在block中进行代码操作,例如获取数据
 @param identifier
 */
+ (void)enterGroup:(void (^)(void))block identifier:(NSString *)identifier;

/**
 获取identifier绑定的group,开始值-1操作

 @param identifier
 */
+ (void)leaveGroup:(NSString *)identifier;

/**
 添加待展示的view,按照identifier进行分组排序
 要在identifier绑定的group的值为零之前调用,也就是最后一个leaveGroup:之前调用
 @param view 待展示的view
 @param identifier
 */
+ (void)addView:(WGFlowControlView *)view identifier:(NSString *)identifier;\

/**
 开启展示已添加的,按照identifier绑定的view
 需要,至少有一次enterGroup:identifier:的调用
 @param identifier
 */
+ (void)showViews:(NSString *)identifier;

/**
 清除所有,已展示的view,和待展示的view,可用于用户退出时,清除用户数据
 */
+ (void)cleanAll;
@end

NS_ASSUME_NONNULL_END
