//
//  AppDelegate.m
//  DWUNlockDemo
//
//  Created by 四海全球 on 2016/11/2.
//  Copyright © 2016年 四海全球. All rights reserved.
//

#import "AppDelegate.h"
#import "DWTouchIDUNlock.h"
#import "ViewController.h"

@interface AppDelegate ()
@property(nonatomic, strong) ViewController *mainvc;
@property(nonatomic, strong) UIViewController *touchIDVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.mainvc];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    __weak __typeof(self)weakSlef = self;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"] &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"endAppTime"]&&
        [[self getCurrentDate] integerValue] - [[[NSUserDefaults standardUserDefaults] objectForKey:@"endAppTime"] integerValue] > 5) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endAppTime"];
        [self.mainvc presentViewController:[[UINavigationController alloc] initWithRootViewController:self.touchIDVC] animated:YES completion:nil];
        [DWTouchIDUNlock dw_touchIDWithMsg:@"验证成功后直接进入首页" cancelTitle:nil otherTitle:nil enabled:YES touchIDAuthenticationSuccessBlock:^(BOOL success) {
            [weakSlef closeTouchID];
        } operatingrResultBlock:^(DWOperatingTouchIDResult operatingTouchIDResult, NSError *error, NSString *errorMsg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSlef.touchIDVC.view.backgroundColor = [UIColor orangeColor];
                weakSlef.touchIDVC.title = @"错了这么多次,手机不是偷的吧";
            });
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"非活动状态");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"进入后台");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"endAppTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"将要结束");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"endAppTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (ViewController *)mainvc {
    if (!_mainvc) {
        _mainvc = [ViewController new];
    }
    return _mainvc;
}

- (void)closeTouchID {
    [self.touchIDVC dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)touchIDVC {
    if (!_touchIDVC) {
        _touchIDVC = [UIViewController new];
        _touchIDVC.view.backgroundColor = [UIColor whiteColor];
        _touchIDVC.title = @"验证Touch ID中...";
        _touchIDVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeTouchID)];
    }
    return _touchIDVC;
}

@end
