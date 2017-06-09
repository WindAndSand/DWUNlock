//
//  DWFingerprintUNlock.m
//  DWUNlock
//
//  Created by dwang_sui on 2016/10/23.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "DWTouchIDUNlock.h"
#import "DWDeviceModel.h"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation DWTouchIDUNlock

#pragma mark ---指纹解锁
+ (void)dw_touchIDWithMsg:(NSString *)msg
        cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitle:(NSString *)otherButtonTitle
        enabled:(BOOL)enabled
        successBlock:(void(^)(BOOL success))successBlock
        operatingrResultBlock:(void(^)(DWOperatingTouchIDResult operatingTouchIDResult,
                                   NSError *error,
                                   NSString *errorMsg))operatingrResultBlock {
    
    [self dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {
        context.localizedFallbackTitle = !otherButtonTitle?@"":otherButtonTitle;
        if(IOS_VERSION>=10) context.localizedCancelTitle = cancelButtonTitle;
        NSInteger policy2 = enabled?LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
        if (isSupport) {
            [context evaluatePolicy:policy2 localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        successBlock(success);
                        operatingrResultBlock(DWTouchIDResultTypeSuccess, error, @"TouchID 验证成功");
                    });
                    return;
                }else if (error) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                            operatingrResultBlock(DWTouchIDResultTypeFailed, error, @"TouchID 验证失败");
                            break;
                        case LAErrorUserCancel:
                            operatingrResultBlock(DWTouchIDResultTypeUserCancel, error, @"TouchID 被用户取消");
                            break;
                        case LAErrorSystemCancel:
                            operatingrResultBlock(DWTouchIDResultTypeSystemCancel, error, @"TouchID 被系统取消");
                            break;
                        case LAErrorAppCancel:
                            operatingrResultBlock(DWTouchIDResultTypeAppCancel, error, @"当前软件被挂起并取消了授权(如App进入了后台等)");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        case LAErrorInvalidContext:
                            operatingrResultBlock(DWTouchIDResultTypeAppCancel, error, @"当前软件被挂起并取消了授权(LAContext对象无效)");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        case LAErrorUserFallback:
                            operatingrResultBlock(DWTouchIDResultTypeInputPassword, error, @"手动输入密码");
                            break;
                        case LAErrorPasscodeNotSet:
                            operatingrResultBlock(DWTouchIDResultTypeInputPassword, error, @"TouchID 无法启动,因为用户没有设置密码");
                            break;
                        case LAErrorTouchIDNotEnrolled:
                            operatingrResultBlock(DWTouchIDResultTypeNotSet, error, @"TouchID 无法启动,因为用户没有设置TouchID");
                            break;
                        case LAErrorTouchIDNotAvailable:
                            operatingrResultBlock(DWTouchIDResultTypeNotAvailable, error, @"TouchID 无效");
                            break;
                        case LAErrorTouchIDLockout:
                            operatingrResultBlock(DWTouchIDResultTypeLockout, error, @"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        default:
                            operatingrResultBlock(DWTouchIDResultTyoeUnknown, error, @"未知情况");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                    }
                }
            }];
        }else {
            operatingrResultBlock(DWTouchIDResultTypeVersionNotSupport, error, [NSString stringWithFormat:@"此设备不支持TouchID:\n设备操作系统:%@\n设备系统版本号:%@\n设备型号:%@", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] systemName], [DWDeviceModel dwToolsDeviceModelName]]);
        }
    }];
}


#pragma mark - 判断设备是否支持指纹解锁
+ (BOOL)dw_validationTouchIDIsSupportWithBlock:(void(^)(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error))block {
    LAContext* context = [[LAContext alloc] init];
    context.maxBiometryFailures = @(3);//最大的错误次数,9.0后失效
    NSInteger policy = IOS_VERSION<9.0&&IOS_VERSION>=8.0?LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
    NSError *error = nil;
    BOOL isSupport = [context canEvaluatePolicy:policy error:&error];
    block(isSupport, context, policy, error);
    return isSupport;
}

@end
