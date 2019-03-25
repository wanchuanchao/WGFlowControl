//
//  WGViewFlowView.h
//  WGFlowControl_Example
//
//  Created by wanccao on 22/3/2019.
//  Copyright © 2019 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WGFlowControl/WGViewFlow.h>
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * const WGViewFlowViewIdentifier;

typedef NS_ENUM(NSUInteger, WGViewFlowViewType) {
    WGViewFlowViewTypeType1,
    WGViewFlowViewTypeType2,
    WGViewFlowViewTypeType3
};

@interface WGViewFlowView : UIView
+ (UIView <WGViewFlowDelegate> *)viewWithType:(WGViewFlowViewType)type;
@end

NS_ASSUME_NONNULL_END
