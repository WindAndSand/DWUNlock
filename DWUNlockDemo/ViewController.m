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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"手势&指纹解锁";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchType];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 88) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

#pragma mark - 指纹解锁
- (void)fingerprintUNlock {
    [DWFingerprintUNlock dw_initWithFingerprintUNlockPromptMsg:self.switchType.isOn?@"这是一个指纹解锁的Demo，同时错误只显示取消按钮":@"这是一个指纹解锁的Demo，错误可以选择其它操作方式" cancelMsg:@"点此取消" otherMsg:self.switchType.isOn?nil:@"其它方式" enabled:YES otherClick:^(NSString *otherClick) {
        NSLog(@"%@", otherClick);
    } success:^(BOOL success) {
        if (success) {
            NSLog(@"验证成功");
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    } errorMsg:^(NSString *errorMsg) {
        NSLog(@"%@", errorMsg);
    }];
}

#pragma mark - 手势解锁
- (void)gesturesLock {
    DWGesturesLock *ges = [[DWGesturesLock alloc] initWithFrame:CGRectMake(0, 88+64, self.view.bounds.size.width, self.view.bounds.size.height-88-64)];
    [ges dw_passwordSuccess:^(BOOL success, NSString *password, NSString *userPassword) {
        NSLog(@"是否正确:%d---此次输入的密码:%@---用户设置的密码:%@", success, password, userPassword);
        if (success) {
            [ges removeFromSuperview];
        }
    }];
    NSLog(@"连续输入了%ld次", ges.inputCount);
    [self.view addSubview:ges];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
        cell.textLabel.text = indexPath.row==1?@"手势解锁":@"指纹解锁";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
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

@end
