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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"手势&指纹解锁";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchType];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self fingerprintUNlock];
    }else {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[GesturesPasswordController alloc] init]] animated:YES completion:nil];
    }
}

- (UISwitch *)switchType {
    if (!_switchType) {
        _switchType = [[UISwitch alloc] init];
    }
    return _switchType;
}

@end
