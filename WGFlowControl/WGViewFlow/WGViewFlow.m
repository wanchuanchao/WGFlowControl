//
//  WGViewFlow.m
//  WGFlowControl
//
//  Created by wanccao on 27/2/2019.
//

#import "WGViewFlow.h"
#import <objc/runtime.h>

static BOOL isNil(NSString *string){
    return !string || string.length == 0;
}

NSString * const WGFlowControlManagerWaitingShowIdentifier = @"WGFlowControlManagerWaitingShowIdentifier";

@implementation WGViewFlow

+ (BOOL)judgeClass{
    BOOL isClassWGViewFlow = [[self class] isKindOfClass:[WGViewFlow class]];
    NSAssert(!isClassWGViewFlow, @"WGViewFlowLog error: cannot use WGViewFlow ,use subClass extend WGFlowControlManager");
    return isClassWGViewFlow;
}
+ (void)setShowAble:(BOOL)showAble{
    NSLog(@"WGViewFlowLog %s",__func__);
    objc_setAssociatedObject(self, @selector(setShowAble:), @(showAble), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (BOOL)getShowAble{
    NSLog(@"WGViewFlowLog %s",__func__);
    NSNumber *showAble = objc_getAssociatedObject(self, @selector(setShowAble:));
    return showAble && [showAble boolValue];
}
+ (void)setAllViewDic:(NSMutableDictionary *)dic{
    NSLog(@"WGViewFlowLog %s",__func__);
    objc_setAssociatedObject(self, @selector(setAllViewDic:), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (NSMutableDictionary *)getAllViewDic{
    NSLog(@"WGViewFlowLog %s",__func__);
    return objc_getAssociatedObject(self, @selector(setAllViewDic:));
}
+ (NSMutableArray <UIView<WGViewFlowDelegate> *> *)getViews:(NSString *)identifier{
    NSLog(@"WGViewFlowLog %s",__func__);
    NSMutableDictionary *viewsDic = [self getAllViewDic];
    if (!viewsDic) {
        viewsDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [self setAllViewDic:viewsDic];
    }
    if (!viewsDic[identifier]) {
        viewsDic[identifier] = [NSMutableArray arrayWithCapacity:1];
    }
    return viewsDic[identifier];
}
+ (void)setNilViews:(NSString *)identifier{
    NSLog(@"WGViewFlowLog %s",__func__);
    NSMutableDictionary *viewsDic = [self getAllViewDic];
    [viewsDic removeObjectForKey:identifier];
}
+ (void)addView:(UIView<WGViewFlowDelegate> *)view error:(WGViewFlowError *)error{
    NSLog(@"WGViewFlowLog %s",__func__);
    if ([self judgeClass]) {
        return;
    }
    if (!view || ![view isKindOfClass:[UIView class]]) {
        *error = WGViewFlowError_nilView;
        NSLog(@"WGViewFlowLog WGViewFlowError_nilView");
        return;
    }
    if (![view conformsToProtocol:@protocol(WGViewFlowDelegate)]) {
        NSAssert(NO, @"WGViewFlowLog view没有遵循WGViewFlowDelegate");
        return;
    }
    if (![view respondsToSelector:@selector(WGViewFlowGroupIdentifier)]) {
        NSAssert(NO, @"WGViewFlowLog view没有实现WGViewFlowGroupIdentifier方法");
        return;
    }
    if (![view respondsToSelector:@selector(dismissBlock:)]) {
        NSAssert(NO, @"WGViewFlowLog view没有实现dismissBlock:方法");
        return;
    }
    NSString *groupIdentifier = [view WGViewFlowGroupIdentifier];
    if (isNil(groupIdentifier) || [groupIdentifier isEqualToString:WGFlowControlManagerWaitingShowIdentifier]) {
        *error = WGViewFlowError_nilGroupIdentifier;
        NSLog(@"WGViewFlowLog error: WGViewFlowError_nilGroupIdentifier");
        return;
    }
    NSLog(@"WGViewFlowLog view groupIdentifier %@",groupIdentifier);
    NSString *sortIdentifier;
    if ([view respondsToSelector:@selector(WGViewFlowSortIdentifier)]) {
        sortIdentifier = [view WGViewFlowSortIdentifier];
    }
    NSLog(@"WGViewFlowLog view sortIdentifier %@",sortIdentifier);
    NSInteger count = 1;
    if ([view respondsToSelector:@selector(WGViewFlowViewCounts)]) {
        count = [view WGViewFlowViewCounts];
    }
    if (count < 1) {
        *error = WGViewFlowError_nilCounts;
        NSLog(@"WGViewFlowLog error: WGViewFlowError_nilCounts");
        return;
    }
    count = (int)count;
    NSLog(@"WGViewFlowLog view count %ld",count);
    if (isNil(sortIdentifier) && count != 1) {
        *error = WGViewFlowError_nilSortIdentifier_counts;
        NSLog(@"WGViewFlowLog error: WGViewFlowError_nilSortIdentifier_counts");
        return;
    }
    BOOL needUpdate = NO;
    if ([view respondsToSelector:@selector(WGViewFlowNeedUpdate)]) {
        needUpdate = [view WGViewFlowNeedUpdate];
    }
    NSLog(@"WGViewFlowLog view needUpdate %d",needUpdate);
    //获取待展示的队列
    NSMutableArray<UIView<WGViewFlowDelegate> *> *waitViews = [self getViews:WGFlowControlManagerWaitingShowIdentifier];
    __block NSInteger idx = -1;
    [waitViews enumerateObjectsUsingBlock:^(UIView<WGViewFlowDelegate> *  _Nonnull obj, NSUInteger objIdx, BOOL * _Nonnull stop) {
        NSString *obj_identifier = [obj WGViewFlowGroupIdentifier];
        if ([obj_identifier isEqualToString:groupIdentifier]) {
            if (count == 1) {
                //只展示一个视图时,只判断groupIdentifier
                idx = objIdx;
                *stop = YES;
            }else{
               NSString *obj_sortIdentifier = [obj WGViewFlowSortIdentifier];
                if ([obj_sortIdentifier isEqualToString:sortIdentifier]) {
                    idx = objIdx;
                    *stop = YES;
                }
            }
        }
    }];
    //待展示已存在 && 不需要更新
    if (idx != -1 && !needUpdate) {
        NSLog(@"WGViewFlowLog waitViews 待展示已存在 && 不需要更新 return");
        return;
    }
    void (^block)(void) = ^(void){
        [self viewDismissed];
    };
    [view dismissBlock:block];
    if (idx != -1) {
        //待展示已存在 需要更新
        if (idx == 0 && waitViews.firstObject.superview) {
            //待更新的视图已在屏幕展示
            [waitViews.firstObject removeFromSuperview];
            waitViews[idx] = view;
            [self showViews];
            NSLog(@"WGViewFlowLog waitViews已存在 需要更新 视图已在屏幕展示 updated");
            return;
        }
        waitViews[idx] = view;
        NSLog(@"WGViewFlowLog waitViews已存在 需要更新 updated");
        return;
    }
    //待展示队列里没有相同的视图 && 只展示一个视图
    if (count == 1) {
        NSLog(@"WGViewFlowLog waitViews里没有相同的视图 && 只展示一个视图 added");
        [waitViews addObject:view];
        if ([self getShowAble]) {
            [self showViews];
        }
        return;
    }
    NSMutableArray <UIView<WGViewFlowDelegate> *> *views = [self getViews:groupIdentifier];
    [views enumerateObjectsUsingBlock:^(UIView<WGViewFlowDelegate> *  _Nonnull obj, NSUInteger objIdx, BOOL * _Nonnull stop) {
        NSString *obj_sortIdentifier = [obj WGViewFlowSortIdentifier];
        if ([obj_sortIdentifier isEqualToString:sortIdentifier]) {
            idx = objIdx;
            *stop = YES;
        }
    }];
    if (idx != -1 && !needUpdate) {
        NSLog(@"WGViewFlowLog  views队列已存在 不需要更新 return");
        return;
    }
    if (idx != -1) {
        //待展示已存在 需要更新
        views[idx] = view;
        NSLog(@"WGViewFlowLog  views队列已存在 需要更新 updated");
        return;
    }
    NSLog(@"WGViewFlowLog added");
    [views addObject:view];
    if (views.count >= count) {
        //相同组别的view个数,已满足进行展示的条件
        //进行排序
        NSLog(@"WGViewFlowLog 相同组别的view个数,已满足进行展示的条件 进行排序 waitViews add");
        [self sortViews:views];
        [waitViews addObjectsFromArray:views];
        [self setNilViews:groupIdentifier];
        if ([self getShowAble]) {
            [self showViews];
        }
    }
}
+ (void)sortViews:(NSMutableArray<UIView<WGViewFlowDelegate> *> *)views{
    NSLog(@"WGViewFlowLog %s",__func__);
    [views sortUsingComparator:^NSComparisonResult(UIView<WGViewFlowDelegate> *  _Nonnull obj1, UIView<WGViewFlowDelegate> *  _Nonnull obj2) {
        NSString *obj1_sortIdentifier = [obj1 WGViewFlowSortIdentifier];
        NSString *obj2_sortIdentifier = [obj2 WGViewFlowSortIdentifier];
        return [obj1_sortIdentifier compare:obj2_sortIdentifier];
    }];
}
+ (void)showViews{
    NSLog(@"WGViewFlowLog %s",__func__);
    if ([self judgeClass]) {
        return;
    }
    [self setShowAble:YES];
    NSMutableArray<UIView<WGViewFlowDelegate> *> *views = [self getViews:WGFlowControlManagerWaitingShowIdentifier];
    if (views.count == 0) {
        return;
    }
    UIView<WGViewFlowDelegate> *view = views.firstObject;
    if (!view.superview) {
        UIView *superView;
        if ([view respondsToSelector:@selector(WGViewFlowViewWillShow:)]) {
            BOOL stop;
            superView = [view WGViewFlowViewWillShow:&stop];
            if (stop) {
                [self viewDismissed];
                return;
            }
        }
        if (superView && [superView isKindOfClass:[UIView class]]) {
            [superView addSubview:view];
        }else{
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            [window addSubview:view];
        }
    }
}
+ (void)hideViews{
    NSLog(@"WGViewFlowLog %s",__func__);
    if ([self judgeClass]) {
        return;
    }
    [self setShowAble:NO];
    NSMutableArray<UIView<WGViewFlowDelegate> *> *waitViews = [self getViews:WGFlowControlManagerWaitingShowIdentifier];
    if (waitViews.count) {
        if (waitViews.firstObject.superview) {
            [waitViews.firstObject removeFromSuperview];
        }
    }
}
+ (void)viewDismissed{
    NSLog(@"WGViewFlowLog %s",__func__);
    NSMutableArray<UIView<WGViewFlowDelegate> *> *views = [self getViews:WGFlowControlManagerWaitingShowIdentifier];
    if (views.count) {
        [views removeObjectAtIndex:0];
    }
    if ([self getShowAble]) {
        [self showViews];
    }
}
+ (void)cleanViews{
    NSLog(@"WGViewFlowLog %s",__func__);
    [self hideViews];
    [self setAllViewDic:nil];
}
@end

