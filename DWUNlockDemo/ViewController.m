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
#import "DWUNlock.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UISwitch *switchType;

@property(nonatomic, strong) DWGesturesUNlock *ges;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"手势&指纹解锁";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchType];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除手势密码" style:UIBarButtonItemStylePlain target:self action:@selector(removeGes)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 88) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88+64, self.view.bounds.size.width, self.view.bounds.size.height-88-64)];
    bgImage.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgImage];
}

- (void)removeGes {
    [DWGesturesUNlock dw_removePassword];
    NSLog(@"清除了手势密码");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手势解锁Demo" message:@"清除手势密码成功" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
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

#pragma mark - 手势解锁
- (void)gesturesLock {
     __weak __typeof(self)weakSelf = self;
    [self.ges dw_passwordSuccess:^(BOOL success, NSString *password, NSString *userPassword) {
        NSLog(@"是否正确:%d---此次输入的密码:%@---用户设置的密码:%@", success, password, userPassword);
        if (success) {
            [weakSelf.ges removeFromSuperview];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手势解锁Demo" message:@"验证成功" preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手势解锁Demo" message:[NSString stringWithFormat:@"此次输入的密码:%@\n用户设置的密码:%@\n连续输入的次数:%ld", password, userPassword,weakSelf.ges.inputCount] preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
        }
    }];
    NSLog(@"连续输入了%ld次", self.ges.inputCount);
    [self.view addSubview:self.ges];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self fingerprintUNlock];
    }else {
        [self gesturesLock];
    }
}

- (UISwitch *)switchType {
    if (!_switchType) {
        _switchType = [[UISwitch alloc] init];
    }
    return _switchType;
}

- (DWGesturesUNlock *)ges {
    if (!_ges) {
        _ges = [[DWGesturesUNlock alloc] initWithFrame:CGRectMake(0, 88+64, self.view.bounds.size.width, self.view.bounds.size.height-88-64)];
    }
    return _ges;
}

@end
