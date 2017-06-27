//
//  ViewController.m
//  DWUNlock
//
//  Created by dwang_sui on 2016/10/23.
//  Copyright © 2016年 dwang. All rights reserved.
//
/*****************************Github:https://github.com/dwanghello/DWUNlock******************************/
/*************Code Data:http://www.codedata.cn/cdetail/Objective-C/Demo/1478099529339492********/
/*****************************邮箱:dwang.hello@outlook.com***********************************************/
/*****************************QQ:739814184**************************************************************/
/*****************************QQ交流群:577506623*********************************************************/
/*****************************codedata官方群:157937068***************************************************/


#import "ViewController.h"
#import "GesturesPasswordController.h"
#import "DWTouchIDUNlock.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UISwitch *switchType;

@property(nonatomic, strong) UISwitch *openAppTouchID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"手势&指纹解锁";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchType];
    if ([DWTouchIDUNlock dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {}]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.openAppTouchID];
    }
    NSLog(@"设备是否支持Touch ID:%d", [DWTouchIDUNlock dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {}]);
    
    [self loadTableView];
}

- (void)loadTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88+64, self.view.bounds.size.width, self.view.bounds.size.height-88-64)];
    bgImage.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgImage];
}

#pragma mark - 指纹解锁
- (void)fingerprintUNlock {
     __weak __typeof(self)weakSelf = self;
    [DWTouchIDUNlock dw_touchIDWithMsg:self.switchType.isOn?@"这是一个指纹解锁的Demo，同时错误只显示取消按钮":@"这是一个指纹解锁的Demo，错误可以选择其它操作方式" cancelTitle:@"点此取消" otherTitle:self.switchType.isOn?nil:@"其它方式" enabled:!self.switchType.isOn touchIDAuthenticationSuccessBlock:^(BOOL success) {
        NSLog(@"验证成功");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"指纹解锁Demo" message:@"验证成功" preferredStyle:UIAlertControllerStyleAlert];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }operatingrResultBlock:^(DWOperatingTouchIDResult operatingTouchIDResult, NSError *error, NSString *errorMsg) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"指纹解锁Demo" message:[NSString stringWithFormat:@"错误码:%ld---系统Log:%@---中文Log:%@", operatingTouchIDResult, error, errorMsg] preferredStyle:UIAlertControllerStyleAlert];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        NSLog(@"错误码:%ld---系统Log:%@---中文Log:%@", operatingTouchIDResult, error, errorMsg);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DWTouchIDUNlock dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {
        NSLog(@"%d", isSupport);
    }]?2:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = indexPath.row==0?@"手势解锁":@"指纹解锁";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self fingerprintUNlock];
    }else {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[GesturesPasswordController alloc] init]] animated:YES completion:nil];
    }
}

- (void)openAppTouchIDValueChange:(UISwitch *)sender {
    if (sender.isOn) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"打开此开关后，退出此Demo五秒后需要验证指纹才能进入关闭界面" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"touchID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            sender.on = NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"touchID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (UISwitch *)switchType {
    if (!_switchType) {
        _switchType = [[UISwitch alloc] init];
    }
    return _switchType;
}

- (UISwitch *)openAppTouchID {
    if (!_openAppTouchID) {
        _openAppTouchID = [[UISwitch alloc] init];
        [_openAppTouchID addTarget:self action:@selector(openAppTouchIDValueChange:) forControlEvents:UIControlEventValueChanged];
        _openAppTouchID.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"];
    }
    return _openAppTouchID;
}

@end
