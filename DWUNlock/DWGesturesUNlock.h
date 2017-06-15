//
//  DWGesturesLock.h
//  DWUNlock
//
//  Created by dwang_sui on 2016/10/28.
//  Copyright © 2016年 dwang. All rights reserved.
//
/************************Github:https://github.com/dwanghello/DWUNlock******************/
/*****************************邮箱:dwang.hello@outlook.com*************************/
/*****************************QQ交流群:577506623**********************************/

#import <UIKit/UIKit.h>

@interface DWGesturesUNlock : UIView
/**************************Block************************/

/** 当设置密码时，此为设置成功,验证密码时，此为验证成功 */
typedef void (^gesturesSuccess)();
/**
 错误的回调

 @param choosePassword 用户选中的密码
 @param userSetPassword 用户设置的密码
 @param errorCount 错误的次数
 */
typedef void (^gesturesError)(NSString *choosePassword, NSString *userSetPassword, int errorCount);
@property(nonatomic, copy) gesturesSuccess successBlock;
@property(nonatomic, copy) gesturesError errorBlock;

/**
 设置首行密码按钮距上位置

 @param topMargin 间距／此方法需在初始化方法之前调用
 */
+ (void)dw_setGesturesTopMargin:(CGFloat)topMargin;

/**
 初始化手势密码视图

 @param frame frame
 @param successBlock 当设置密码时，此为设置成功,验证密码时，此为验证成功
 @param errorBlock 验证或设置密码错误
 @return self
 */
+ (instancetype)dw_gesturesViewWithFrame:(CGRect)frame successBlock:(gesturesSuccess)successBlock errorBlock:(gesturesError)errorBlock;

/** 删除首行密码按钮距上位置 */
+ (void)dw_removeGesturesTopMargin;

/** 删除手势密码 */
+ (void)dw_removeGesturesPassword;

/** 获取当前是否设置过手势密码 */
+ (BOOL)dw_validationGesturesUNlock;

/** 手势解锁背景(默认显示类似支付宝背景) */
@property (strong, nonatomic) UIImage           *bgImage;

/** 第一行距顶部间距 */
@property(nonatomic, assign) CGFloat            gesturesTopMargin;

/** 连接点默认图片 */
@property(strong, nonatomic) UIImage            *gesturesNormal;

/** 连接点被选中时的图片 */
@property(strong, nonatomic) UIImage            *gesturesSelected;

/** 密码正确时的图片 */
@property(strong, nonatomic) UIImage            *gesturesSuccessImage;

/** 密码错误时的图片 */
@property(strong, nonatomic) UIImage            *gesturesErrorImage;

/** 连接线颜色(默认白色) */
@property (strong, nonatomic) UIColor           *lineColor;

/** 连接线宽度(默认10/不建议修改) */
@property (assign, nonatomic) CGFloat            lineWidth;

/** 手势连接点尺寸(默认74/不建议修改) */
@property(assign, nonatomic) CGFloat             pointSize;

/** 连接线停留时间(默认2.0秒) */
@property(assign, nonatomic) double              lineTimer;

/** 密码最小长度(默认3) */
@property(assign, nonatomic) int                 minlength;

/** 画线完成后的截图 */
@property(strong, nonatomic) UIImage            *passwordImage;

@end
