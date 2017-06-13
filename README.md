[![CocoaPods](http://img.shields.io/cocoapods/v/DWUNlock.svg?style=flat)](http://cocoapods.org/?q=DWUNlock)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/DWUNlock.svg?style=flat)](http://cocoapods.org/?q=DWUNlock)&nbsp;
[![License](https://img.shields.io/cocoapods/l/DWUNlock.svg?style=flat)](http://cocoapods.org/pods/DWUNlock) 
[![GitHub stars](https://img.shields.io/github/stars/dwanghello/DWUNlock.svg)](https://github.com/asiosldh/DWUNlock/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/dwanghello/DWUNlock.svg)](https://github.com/asiosldh/DWUNlock/forkgazers)

---
![logo](https://github.com/dwanghello/DWUNlock/blob/master/logo.png)

- version
    - 1.0.3 *otherMsg传入nil，则只显示取消按钮，不会出现其他操作按钮*
    - 1.1.0 *简化指纹解锁Block回调结构*
    - 1.1.2 *增加验证设备是否支持指纹解锁*
    - 1.1.5 *全新改版,更加便捷*
- Cocopods
    - *pod 'DWUNlock', '~> 1.1.5'*
    - 无法search或search到不是最新的库:[解决方案](http://www.jianshu.com/p/1fc730b0edc7)
    

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
- 准备工作
    - 将<strong>DWUNlock文件夹</strong>拖到项目中
    - 导入以下框架
        - LocalAuthentication.framework
        - UIKit.framework
        - QuartzCore.framework

- 开始使用
    - 在需要用到指纹解锁的地方引入头文件
        - #import "DWTouchIDUNlock.h"
    - 直接使用类方调用/详细参数说明请到DWTouchIDUNlock.h文件中查看


            [DWTouchIDUNlock dw_touchIDWithMsg:@"这是一个指纹解锁的Demo"
            cancelTitle:@"点此取消" 
            otherTitle@"其它方式" 
            enabled:YES 
            touchIDAuthenticationSuccessBlock:^(BOOL success) {
            NSLog(@"验证成功");
            }operatingrResultBlock:^(DWOperatingTouchIDResult operatingTouchIDResult, NSError *error, NSString *errorMsg) {
            NSLog(@"错误码:%ld---系统Log:%@---中文Log:%@", operatingTouchIDResult, error, errorMsg);
            }];
            
    - 可以在使用指纹解锁前判断当前设备是否支持

            BOOL isSupport = [DWTouchIDUNlock dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, 
            LAContext *context, 
            NSInteger policy, 
            NSError *error) {}];

    - 在需要用到手势解锁的地方引入头文件
        - #import "DWGesturesUNlock.h"
    
    - 此处需使用对象方法/详细参数说明请到DWGesturesLock.h文件中查看
    
            //初始化
            DWGesturesUNlock *gestures = [[DWGesturesUNlock alloc] init];
            //添加到当前视图
            [self.view addSubview:gestures];
            //完成手势绘制调用
            [gestures dw_passwordSuccess:^(BOOL success, NSString *password, NSString *userPassword) {
                if(!userPassword && password.length >= 3) {
                    DLog(@"密码设置成功")
                }
                if(success) {
                DLog(@"验证成功")
                }else {
                    DLog(@"验证失败")
                }
                }];


