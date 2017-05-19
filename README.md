[![CocoaPods](http://img.shields.io/cocoapods/v/DWUNlock.svg?style=flat)](http://cocoapods.org/?q=DWUNlock)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/DWUNlock.svg?style=flat)](http://cocoapods.org/?q=DWUNlock)&nbsp;
[![License](https://img.shields.io/cocoapods/l/DWUNlock.svg?style=flat)](http://cocoapods.org/pods/DWUNlock) 
[![GitHub stars](https://img.shields.io/github/stars/dwanghello/DWUNlock.svg)](https://github.com/asiosldh/DWUNlock/stargazers)

---
![logo](https://github.com/dwanghello/DWUNlock/blob/master/logo.png)

- version 1.0.2
- Cocoapods *pod 'DWUNlock', '~> 1.0.2'*

# 此项目使用Xcode8.1创建，低版本Xcode打开可能会无法使用
# 手势&amp;指纹解锁
### *如果感觉不错，请给个Star支持一下*
#### *使用中如果遇到什么问题可以联系我*
##### *[QQ:739814184|点击即可扫码添加](https://github.com/dwanghello/DWTransform/blob/master/QQ.png)* 
##### *[微信:ai739814184|点击即可扫码添加](https://github.com/dwanghello/DWTransform/blob/master/WeChat.png)*
##### *QQ群:577506623*
![QQ群](https://github.com/dwanghello/DWTransform/blob/master/QQ群.png)
##### *e-mail:dwang.hello@outlook.com*

---
## 准备工作
#### 将
    DWUNlock文件夹
    拖到项目中

---
#### 导入    
    LocalAuthentication.framework

    UIKit.framework

    QuartzCore.framework

---
## 开始使用
#### 在需要用到指纹解锁的地方引入头文件
    #import "DWFingerprintUNlock.h"
    
#### 直接使用类方调用/详细参数说明请到DWFingerprintUNlock.h文件中查看
    [DWFingerprintUNlock
     dw_initWithFingerprintUNlockPromptMsg:
     @"此操作需要认证您的身份"
      cancelMsg:@"取消"
       otherMsg:@"其它方式登录" 
       enabled:YES
       otherClick:^(NSString *otherClick) {
                
                DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                
            } 
            success:^(BOOL success) {
        DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                
            } 
            error:^(NSError *error) {
                DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                
            } 
            errorMsg:^(NSString *errorMsg) {
     DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                
            }];
            

#### 在需要用到手势解锁的地方引入头文件
    #import "DWGesturesLock.h"
    
#### 此处需使用对象方法/详细参数说明请到DWGesturesLock.h文件中查看
    //初始化
    DWGesturesLock *gestures = [[DWGesturesLock 
    alloc] init];
    
    //添加到当前视图
     [self.view addSubview:gestures];

    //完成手势绘制调用
    [gestures 
    dw_passwordSuccess:^(
    BOOL success, 
    NSString *password, 
    NSString *userPassword) {
    
    if(!userPassword && password.length >= 3) {
    
    DLog(@"密码设置成功")
    
    }
    
    if(success) {
    
    DLog(@"验证成功")
    
    }else {
    
    DLog(@"验证失败")
    
    }
    
    }];


