//
//  WGViewFlowManager.m
//  WGFlowControl_Example
//
//  Created by wanccao on 22/3/2019.
//  Copyright © 2019 wanccao. All rights reserved.
//

#import "WGViewFlowManager.h"
void WGVFMShowViews(void){
    [WGViewFlowManager showViews];
}
void WGVFMHideViews(void){
    [WGViewFlowManager hideViews];
}
void WGVFMCleanAll(void){
    [WGViewFlowManager cleanViews];
}
BOOL WGVFMHasShowed(void){
    BOOL hasShowed = [[NSUserDefaults standardUserDefaults] objectForKey:WGViewFlowViewIdentifier] ? YES : NO;
    NSLog(@"WGViewFlowLog %s hasShowed %d",__func__,hasShowed);
    return hasShowed;
}
void WGVFMAddGuideView(WGViewFlowViewType type){
    UIView<WGViewFlowDelegate> *guideView = [WGViewFlowView viewWithType:type];
    WGViewFlowError error;
    [WGViewFlowManager addView:guideView error:&error];
}
void WGVFMReset(void){
    NSLog(@"WGViewFlowLog %s",__func__);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WGViewFlowViewIdentifier];
}
@implementation WGViewFlowManager

@end
