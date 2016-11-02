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
#import "Masonry.h"

@interface ViewController ()<UITableViewDataSource, UIAlertViewDelegate, UITableViewDelegate>

/** 手势解锁 */
@property(strong, nonatomic) DWGesturesLock *gesture;

/** Array */
@property(strong, nonatomic) NSMutableArray *array;

/** tableView */
@property (weak, nonatomic) UITableView *tableView;

@end

#ifndef __OPTIMIZE__
#define DLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    tableView.scrollEnabled = NO;
    
    tableView.delegate = self;
    
    self.tableView = tableView;
    
    tableView.tableFooterView = [[UIView alloc] init];
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UIControlStateNormal;
    
    UISwitch *switchs = [[UISwitch alloc] init];
    
    [self.array addObject:switchs];
    
    switchs.tag = (indexPath.row + 1) * 10;
    
    [switchs addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:switchs];
    
    [switchs mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(cell.mas_centerY);
        
        make.right.equalTo(cell.mas_right).offset(-15);
        
    }];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"手势解锁";
        
        switchs.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ges"];
        
    }
    
    if (indexPath.row == 1) {
        
        cell.textLabel.text = @"指纹解锁";
        
        switchs.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"fing"];
        
    }
    
    return cell;
    
}

- (void)switchClick:(UISwitch *)sender {
    
    if (sender.tag == 10) {
        
        if (!sender.on) {
            
            [self.gesture removeFromSuperview];
            
            DLog(@"取消手势解锁")
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ges"]) {
                
                [self loadGesture:YES fing:NO];
                
            }
            
        }else {
            
            for (UISwitch *switchs in self.array) {
                
                if (switchs.tag != sender.tag) {
                    
                    if (switchs.on == YES) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已开启指纹解锁,继续开启手势解锁将会关闭指纹解锁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续开启", nil];
                        
                        alert.tag = sender.tag;
                        
                        [alert show];
                        
                    }else {
                        
                        DLog(@"开启了手势解锁");
                        
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ges"]) {
                            
                            [self.gesture removeFromSuperview];
                            
                        }else {
                            
                            [self loadGesture:NO fing:NO];
                            
                        }
                    }
                }
            }
            
        }
        
    }else if (sender.tag == 20) {
        
        [self.gesture removeFromSuperview];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ges"]) {
            
            for (UISwitch *switchs in self.array) {
                
                if (switchs.tag == 10) {
                    
                    switchs.on = NO;
                    
                }
                
            }
            
        }
        
        if (!sender.on) {
            
            [DWFingerprintUNlock dw_initWithFingerprintUNlockPromptMsg:@"此操作需要认证您的身份" cancelMsg:@"取消" otherMsg:@"其它方式登录" otherClick:^(NSString *otherClick) {
                
                DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                
                [self sender:sender.tag ison:YES];
                
            } success:^(BOOL success) {
                
                [self sender:sender.tag ison:NO];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fing"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                DLog(@"取消指纹解锁")
                DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                
            } error:^(NSError *error) {
                
                [self sender:sender.tag ison:YES];
                DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                
            } errorMsg:^(NSString *errorMsg) {
                
                [self sender:sender.tag ison:YES];
                
                DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                
            }];
            
        }else {
            
            for (UISwitch *switchs in self.array) {
                
                if (switchs.tag != sender.tag) {
                    
                    if (switchs.on == YES) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已开启手势解锁,继续开启指纹解锁将会关闭手势解锁" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续开启", nil];
                        
                        alert.tag = sender.tag;
                        
                        [alert show];
                        
                    }else {
                        
                        [DWFingerprintUNlock dw_initWithFingerprintUNlockPromptMsg:@"此操作需要认证您的身份" cancelMsg:@"取消" otherMsg:@"其它方式登录" otherClick:^(NSString *otherClick) {
                            
                            DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                            
                            [self sender:sender.tag ison:NO];
                            
                        } success:^(BOOL success) {
                            
                            [self sender:sender.tag ison:YES];
                            
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fing"];
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                            DLog(@"开启了指纹解锁");
                            DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                            
                        } error:^(NSError *error) {
                            
                            [self sender:sender.tag ison:NO];
                            DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                            
                        } errorMsg:^(NSString *errorMsg) {
                            
                            [self sender:sender.tag ison:NO];
                            DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                            
                        }];
                        
                    }
                }
            }
            
        }
        
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10) {
        
        if (buttonIndex == 1) {
            
            [DWFingerprintUNlock dw_initWithFingerprintUNlockPromptMsg:@"此操作需要认证您的身份" cancelMsg:@"取消" otherMsg:@"其它方式登录" otherClick:^(NSString *otherClick) {
                
                DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                
                [self sender:alertView.tag ison:NO];
                
            } success:^(BOOL success) {
                
                for (UISwitch *switchs in self.array) {
                    
                    if (switchs.tag == alertView.tag) {
                        
                        [self loadGesture:NO fing:NO];
                        
                    }else {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fing"];
                        
                        switchs.on = NO;
                        
                    }
                    
                }
                
                DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                
            } error:^(NSError *error) {
                
                [self sender:alertView.tag ison:NO];
                DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                
            } errorMsg:^(NSString *errorMsg) {
                
                [self sender:alertView.tag ison:NO];
                DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                
            }];
            
        }else {
            
            [self sender:alertView.tag ison:NO];
            
        }
        
    }
    
    if(alertView.tag == 20) {
        
        if (buttonIndex == 1) {
            
            
            [self loadGesture:NO fing:YES];
            
            
        }else {
            
            [self sender:alertView.tag ison:NO];
            
        }
        
    }
    
}

- (DWGesturesLock *)gesture {
    
    if (!_gesture) {
        
        _gesture = [[DWGesturesLock alloc] init];
        
    }
    
    return _gesture;
}

- (void)loadGesture:(BOOL)remove fing:(BOOL)fing {
    
    DWGesturesLock *gestures = [[DWGesturesLock alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height / 3 * 2)];
    
    self.gesture = gestures;
    
    gestures.lineColor = [UIColor orangeColor];
    
    gestures.bgImage = [UIImage imageNamed:@"bg"];
    
    gestures.lineTimer = 0.85;
    
    [self.view addSubview:gestures];
    
    [gestures dw_passwordSuccess:^(BOOL success, NSString *password, NSString *userPassword) {
        
        DLog(@"%d--%@--%@", success, password, userPassword);
        
        DLog(@"%ld", password.length);
        
        if (fing) {
            
            if (success) {
                
                DLog(@"验证成功")
                
                [DWGesturesLock dw_removePassword];
                
                [self.gesture removeFromSuperview];
                
                for (UISwitch *switchs in self.array) {
                    
                    if (switchs.tag == 10) {
                        
                        switchs.on = NO;
                        
                    }else {
                        
                        [DWFingerprintUNlock dw_initWithFingerprintUNlockPromptMsg:@"此操作需要认证您的身份" cancelMsg:@"取消" otherMsg:@"其它方式登录" otherClick:^(NSString *otherClick) {
                            
                            DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                            
                        } success:^(BOOL success) {
                            
                            switchs.on = YES;
                            
                            DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                            
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fing"];
                            
                            
                        } error:^(NSError *error) {
                            
                            DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                            
                        } errorMsg:^(NSString *errorMsg) {
                            
                            DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                            
                        }];
                        
                    }
                }
                
            }else {
                
                DLog(@"验证失败");
            }
            
        }
        
        if (remove) {
            
            if (success) {
                
                [DWGesturesLock dw_removePassword];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ges"];
                
                [self.gesture removeFromSuperview];
                
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
                
            }
            
        }
        
        if (!remove && !fing) {
            
            DLog(@"%@", userPassword);
            
            if (password.length >= 3) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ges"];
                
                [self.gesture removeFromSuperview];
                
#warning 可设置截图
                //                UIImageView *image = [[UIImageView alloc] initWithImage:gestures.passwordImage];
                //
                //                image.frame = CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height / 3 * 2);
                //
                //                [self.view addSubview:image];
                
                
            }
        }
        
    }];
    
}


- (NSMutableArray *)array {
    
    if (!_array) {
        
        _array = [NSMutableArray array];
        
    }
    
    return _array;
}

- (void)sender:(NSInteger)tag ison:(BOOL)ison {
    
    for (UISwitch *switchs in self.array) {
        
        if (switchs.tag == tag) {
            
            switchs.on = ison;
            
        }
    }
    
}
@end
