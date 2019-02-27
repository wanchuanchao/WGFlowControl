//
//  WGFlowControlManager.m
//  Pods-WGFlowControl_Example
//
//  Created by wanccao on 27/2/2019.
//

#import "WGFlowControlManager.h"
#import <objc/runtime.h>

NSString * const WGFlowControlManagerWaitingShowIdentifier = @"WGFlowControlManagerWaitingShowIdentifier";

static BOOL identifierIsNil(NSString *identifier){
    return !identifier || (identifier.length == 0);
}

@interface WGFlowControlManager ()

@end
@implementation WGFlowControlManager

+ (BOOL)judgeClass{
    BOOL isWGFlowControlManager = [[self class] isKindOfClass:[WGFlowControlManager class]];
    NSAssert(!isWGFlowControlManager, @"WGFlowControl error: cannot use WGFlowControlManager ,use subClass extend WGFlowControlManager");
    return isWGFlowControlManager;
}
+ (void)setGroup:(dispatch_group_t)group identifier:(NSString *)identifier{
    NSMutableDictionary *groupDic = objc_getAssociatedObject(self, @selector(setGroup:identifier:));
    if (!groupDic) {
        groupDic = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, @selector(setGroup:identifier:), groupDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (group) {
        [groupDic setObject:group forKey:identifier];
    }else{
        [groupDic removeObjectForKey:identifier];
    }
}
+ (dispatch_group_t)getGroup:(NSString *)identifier{
    NSMutableDictionary *groupDic = objc_getAssociatedObject(self, @selector(setGroup:identifier:));
    return groupDic[identifier];
}
+ (void)cleanGroups{
    NSMutableDictionary *groupDic = objc_getAssociatedObject(self, @selector(setGroup:identifier:));
    groupDic = nil;
}
+ (void)leaveGroup:(NSString *)identifier{
    if ([self judgeClass]) {
        return;
    }
    if (identifierIsNil(identifier)) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager leaveGroup:] identifier is nil");
        return;
    }
    dispatch_group_t group = [self getGroup:identifier];
    if (group) {
        dispatch_group_leave(group);
    }
}
+ (void)enterGroup:(void (^)(void))block identifier:(NSString *)identifier{
    if ([self judgeClass]) {
        return;
    }
    if (identifierIsNil(identifier)) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager enterGroup:identifier:] identifier is nil");
        return;
    }
    dispatch_group_t group = [self getGroup:identifier];
    if (!group) {
        group = dispatch_group_create();
        [self setGroup:group identifier:identifier];
    }
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(),^{
        if (block) {
            block();
        }else{
            dispatch_group_leave(group);
        }
    });
}
+ (void)setViews:(NSMutableArray <WGFlowControlView *> *)views identifier:(NSString *)identifier{
    NSMutableDictionary *viewsDic = objc_getAssociatedObject(self, @selector(setViews:identifier:));
    if (!viewsDic) {
        viewsDic = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, @selector(setViews:identifier:), viewsDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (views) {
        [viewsDic setObject:views forKey:identifier];
    }else{
        [viewsDic removeObjectForKey:identifier];
    }
}
+ (NSMutableArray <WGFlowControlView *> *)getViews:(NSString *)identifier{
    NSMutableDictionary *viewsDic = objc_getAssociatedObject(self, @selector(setViews:identifier:));
    return viewsDic[identifier];
}
+ (void)cleanViews{
    NSMutableDictionary *viewsDic = objc_getAssociatedObject(self, @selector(setViews:identifier:));
    viewsDic = nil;
}
+ (void)addView:(WGFlowControlView *)view identifier:(nonnull NSString *)identifier{
    if ([self judgeClass]) {
        return;
    }
    if (identifierIsNil(identifier)) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager addView:identifier:] identifier is nil");
        return;
    }
    if (!view) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager addView:identifier:] view is nil");
        return;
    }
    NSMutableArray <WGFlowControlView *> *views = [self getViews:identifier];
    if (views == nil) {
        views = [NSMutableArray arrayWithCapacity:1];
        [self setViews:views identifier:identifier];
    }
    __block BOOL contained = NO;
    [views enumerateObjectsUsingBlock:^(WGFlowControlView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.sortString isEqualToString:view.sortString]) {
            contained = YES;
            *stop = YES;
        }
    }];
    if (contained) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager addView:identifier:] view contained");
        return;
    }
    [view configDelegate:self];
    [views addObject:view];
}
+ (void)showViews:(NSString *)identifier{
    if ([self judgeClass]) {
        return;
    }
    if (identifierIsNil(identifier)) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager addView:identifier:] identifier is nil");
        return;
    }
    dispatch_group_t group = [self getGroup:identifier];
    dispatch_block_t block = dispatch_block_create(0, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setGroup:nil identifier:identifier];
            [self sortViews:identifier];
            NSMutableArray *views = [self getViews:identifier];
            [self addWaitingShowViews:views];
            [self setViews:nil identifier:identifier];
            [self showNextView];
        });
    });
    objc_setAssociatedObject(self, @selector(showViews:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (group) {
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0),block);
    }
}
+ (void)sortViews:(NSString *)identifier{
    NSMutableArray<WGFlowControlView *> *views = [self getViews:identifier];
    if (!views || views.count == 0) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager sortViews:] views is nil");
        return;
    }
    [views sortUsingComparator:^NSComparisonResult(WGFlowControlView *  _Nonnull obj1, WGFlowControlView *  _Nonnull obj2) {
        return [obj1.sortString compare:obj2.sortString];
    }];
}
+ (void)addWaitingShowViews:(NSMutableArray *)views{
    if (!views || views.count == 0) {
        NSLog(@"WGFlowControl error: [WGFlowControlManager addWaitingShowViews:] views is nil");
        return;
    }
    NSMutableArray<WGFlowControlView *> *waitViews = [self waitingShowViews];
    if (!waitViews) {
        waitViews = [NSMutableArray arrayWithCapacity:1];
        [self setViews:waitViews identifier:WGFlowControlManagerWaitingShowIdentifier];
    }
    [waitViews addObjectsFromArray:views];
}
+ (NSMutableArray <WGFlowControlView *> *)waitingShowViews{
    return [self getViews:WGFlowControlManagerWaitingShowIdentifier];
}
+ (void)showNextView{
    NSMutableArray<WGFlowControlView *> *views = [self waitingShowViews];
    if (!views || views.count == 0) {
        NSLog(@"WGFlowControl notice: [WGFlowControlManager showNextView] waitingShowViews.count:0");
        return;
    }
    WGFlowControlView *view = views.firstObject;
    if (!view.superview) {
        [view show];
    }
}
+ (void)viewDismissed{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray<WGFlowControlView *> *views = [self waitingShowViews];
        if (views.count) {
            [views removeObjectAtIndex:0];
        }
        [self showNextView];
    });
}
+ (void)cleanAll{
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_block_t block = objc_getAssociatedObject(self, @selector(showViews:));
        if (block) {
            dispatch_block_cancel(block);
        }
        [self cleanGroups];
        NSMutableArray<WGFlowControlView *> *waitViews = [self waitingShowViews];
        if (waitViews.count) {
            if (waitViews.firstObject.superview) {
                [waitViews.firstObject removeFromSuperview];
            }
        }
        [self cleanViews];
    });
}
@end
