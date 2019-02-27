# WGFlowControl

[![CI Status](https://img.shields.io/travis/wanccao/WGFlowControl.svg?style=flat)](https://travis-ci.org/wanccao/WGFlowControl)
[![Version](https://img.shields.io/cocoapods/v/WGFlowControl.svg?style=flat)](https://cocoapods.org/pods/WGFlowControl)
[![License](https://img.shields.io/cocoapods/l/WGFlowControl.svg?style=flat)](https://cocoapods.org/pods/WGFlowControl)
[![Platform](https://img.shields.io/cocoapods/p/WGFlowControl.svg?style=flat)](https://cocoapods.org/pods/WGFlowControl)

WGFlowControl旨在解决多视图展示冲突的问题

### WGFlowControlManager

WGFlowControlManager用来管理待展示的视图的流程
和WGFlowControlView配合使用
功能逻辑:
通过设置identifier,将所有待展示的视图进行分组依次展示,每次只展示一个视图
一个组内的视图按照既定排序依次进行展示
不同组间展示顺序没有影响,一个组的视图全部展示完,再展示下个组的

使用步骤:
1 创建一个WGFlowControlManager的子类实例:manager
2 manager会给不同的identifier配置不同的group
3 调用[manager enterGroup:block identifier:identifier],在block内开启获取数据等操作,group 内部值+1
4 调用[manager showViews:]
5 调用[manager addView:identifier] ,添加待展示的WGFlowControlView的子类实例
6 调用[manager leaveGroup:identifier],group 内部值-1,group内部值置零后,会立即显示所有已添加的视图

注意事项:
以下都是identifier相同的情况
a 步骤3和步骤6,必须成对执行,可调用多次,所有的+1都通过-1置零之后,才会展示identifier对应的已添加的视图
b 3,4,6的执行线程必须一样,否则不会正常显示
c 4必须在至少一次3执行之后,才能执行,且只需执行一次,4和5,6的执行顺序没有约束
d 5的执行次数没有限制,但是在成对的3,6执行之后,group内部值会置零,此时,会立即展示已添加的视图,之后再执行5没有作用,视图不会添加成功,除非3,4再次执行
### WGFlowControlView
WGFlowControlView封装了一些视图展示前,和消失后的控制代码
需要和WGFlowControlManager的子类配合使用

使用步骤:
1 创建一个WGFlowControlManager的子类实例:manager
2 创建一个WGFlowControlView的子类实例:view
3 调用[manager addView:view identifier:identifier],将view按照identifier分组,添加到manager的流程控制中
4 需要设置每个view的sortString,manager会根据sortString的大小将相同identifier的视图排序
5 manager会主动调用view的show方法来展示view,详情看show的注释
6 需要主动调用view的dismiss方法,来结束view的展示,内部会自动通过代理manager来展示下一个待展示的视图
7 可以通过实现view的willShowBlock,和didDismissedBlock在展示前,和展示结束后进行添加一些操作(例如指定父视图)

简单的说,设置view的sortString进行排序,添加到manager中,调用dismiss结束显示

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
