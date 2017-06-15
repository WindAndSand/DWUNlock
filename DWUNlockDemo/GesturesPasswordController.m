//
//  GesturesPasswordController.m
//  DWUNlockDemo
//
//  Created by dwang_sui on 2017/6/15.
//  Copyright © 2017年 四海全球. All rights reserved.
//

#import "GesturesPasswordController.h"
#import "DWGesturesUNlock.h"

@interface GesturesPasswordController ()
@property(nonatomic, strong) UISwitch *switchType;
@property(nonatomic, strong) DWGesturesUNlock *gestureView;
@end

@implementation GesturesPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手势密码";
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"清除手势密码" style:UIBarButtonItemStylePlain target:self action:@selector(removeGesturesPassword)], [[UIBarButtonItem alloc] initWithCustomView:self.switchType]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [self loadGestures];
}



- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeGesturesPassword {
    [DWGesturesUNlock dw_removeGesturesPassword];
}

- (void)topMarginChange {
    [self.gestureView removeFromSuperview];
    if (self.switchType.isOn) {
            [DWGesturesUNlock dw_setGesturesTopMargin:100];
    }else {
        [DWGesturesUNlock dw_removeGesturesTopMargin];
    }
    [self loadGestures];
}

- (void)loadGestures {
    DWGesturesUNlock *gesturesView = [DWGesturesUNlock dw_gesturesViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) successBlock:^{
        NSLog(@"验证或设置密码成功");
    } errorBlock:^(NSString *choosePassword, NSString *userSetPassword, int errorCount) {
        NSLog(@"用户选中的密码:%@\n用户设置的密码或错误信息:%@\n连续错误次数:%d", choosePassword, userSetPassword, errorCount);
    }];
    self.gestureView = gesturesView;
    [self.view addSubview:gesturesView];
}

- (UISwitch *)switchType {
    if (!_switchType) {
        _switchType = [[UISwitch alloc] init];
        [_switchType addTarget:self action:@selector(topMarginChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchType;
}


@end
