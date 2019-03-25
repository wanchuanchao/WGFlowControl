//
//  WGViewFlowManager.h
//  WGFlowControl_Example
//
//  Created by wanccao on 22/3/2019.
//  Copyright © 2019 wanccao. All rights reserved.
//

#import <WGFlowControl/WGViewFlow.h>
#import "WGViewFlowView.h"
FOUNDATION_EXTERN void WGVFMShowViews(void);
FOUNDATION_EXTERN void WGVFMHideViews(void);
FOUNDATION_EXTERN void WGVFMCleanAll(void);
FOUNDATION_EXTERN BOOL WGVFMHasShowed(void);
FOUNDATION_EXTERN void WGVFMAddGuideView(WGViewFlowViewType type);
FOUNDATION_EXTERN void WGVFMReset(void);
NS_ASSUME_NONNULL_BEGIN

@interface WGViewFlowManager : WGViewFlow

@end

NS_ASSUME_NONNULL_END
