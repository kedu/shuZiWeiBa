//
//  LoginViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "YKWMenuViewController.h"
#import "YKWViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (nonatomic, strong) NSString *currentuserName;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)loginButton:(id)sender {
//    self.currentuserName = [AVUser currentUser].username;
    [AVUser logInWithMobilePhoneNumberInBackground:self.nameLabel.text password:self.passWordLabel.text block:^(AVUser *user, NSError *error) {
        
        
        if (user != nil) {
//
            
//            self.newblcok(self.currentuserName);
            [self dismissViewControllerAnimated:YES completion:nil];

            NSLog(@"登录成功%@",user);
        } else {
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号不存在或者密码不正确" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            [alertcontroller addAction:okaction];
            [self presentViewController:alertcontroller animated:YES completion:^{
                
            }];

            
        }
        
    }];
}
//注册
- (IBAction)registerButton:(id)sender {
    NSLog(@"老子要注册");
    RegisterViewController *reg = [RegisterViewController new];
    __weak typeof(self) weakSelf = self;
    reg.block = ^(NSString *name,NSString *pass){
        weakSelf.nameLabel.text = name;
        weakSelf.passWordLabel.text = pass;
    };
    // 设置模态样式
    reg.modalPresentationStyle = UIModalPresentationFullScreen;
    // 设置模态的动画效果
    reg.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:reg animated:YES completion:^{
        
    }];
}
//返回按钮
- (IBAction)notLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
