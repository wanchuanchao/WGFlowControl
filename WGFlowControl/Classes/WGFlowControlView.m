//
//  WGFlowControlView.m
//  Pods-WGFlowControl_Example
//
//  Created by wanccao on 27/2/2019.
//

#import "WGFlowControlView.h"

@interface WGFlowControlView ()
@property (nonatomic, weak) Class<WGFlowControlView> delegate;
@end
@implementation WGFlowControlView
- (void)configDelegate:(Class<WGFlowControlView>)classObj{
    self.delegate = classObj;
}
- (void)show{
    if (self.willShowBlock) {
        UIView *superView = self.willShowBlock();
        if (!superView) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            [window addSubview:self];
        }else{
            [superView addSubview:self];
        }
    }
}
- (void)dismiss{
    NSLog(@"dismiss");
    [self removeFromSuperview];
    if (self.didDismissedBlock) {
        self.didDismissedBlock();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewDismissed)]) {
        [self.delegate viewDismissed];
    }
}

@end
