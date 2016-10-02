//
//  RegisterViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "RegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *newpassWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaLabel;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengmabutton;
@property (nonatomic, strong) NSTimer *ykwtimer;
@property (weak, nonatomic) IBOutlet UITextField *nichengLabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//验证码方法
- (IBAction)yanzhengma:(id)sender {
    

 
            [AVOSCloud requestSmsCodeWithPhoneNumber:self.nameLabel.text
                                             appName:@"科技尾巴"
                                           operation:@"短信验证"
                                          timeToLive:1
                                            callback:^(BOOL succeeded, NSError *error) {
                                                if (succeeded) {
                                                    [self receiveCheckNumButton];
    
                                                    NSLog(@"发送成功");
                                                    //弹窗
    
                                                }else{
                                                    NSLog(@"%@",error);
                                                }
                                            }];
 


}



//注册按钮
- (IBAction)registerButton:(UIButton *)sender {

      if (self.nichengLabel.text != nil || self.nameLabel.text != nil || self.passWordLabel.text != nil ||self.passWordLabel.text ==  self.newpassWordLabel.text) {
          AVUser *user = [[AVUser alloc] init];
          
          user.mobilePhoneNumber = self.nameLabel.text; // 手机号
          user.username = self.nichengLabel.text; // 昵称
          user.password = self.passWordLabel.text; // 密码
          [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              
              if (succeeded) {
                  
                  UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功!请记住用户密码" preferredStyle:(UIAlertControllerStyleAlert)];
                  
                  UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"点我登录" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                      
                      self.block(self.nameLabel.text,self.passWordLabel.text);
                      [self dismissViewControllerAnimated:YES completion:^{
                      }];
                      
                  }];
                  [alertcontroller addAction:okaction];
                  [self presentViewController:alertcontroller animated:YES completion:^{
                      
                  }];
                  NSLog(@"leanCloud注册成功");
                  
              }else{
                  NSLog(@"%@", error);
              }
              
          }];
    }else {
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码为空或者二次密码不相同" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                self.passWordLabel.text = @"";
                self.newpassWordLabel.text = @"";
                
            }];
            [alertcontroller addAction:okaction];
            [self presentViewController:alertcontroller animated:YES completion:^{
                
            }];
        }
    
    
}
- (void)receiveCheckNumButton{
    
    __block int timeout=60;//倒计时时间
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){//倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示根据自己需求设置
                
                [_yanzhengmabutton setTitle:@"重新获取"forState:UIControlStateNormal];
                
                _yanzhengmabutton.userInteractionEnabled =YES;
                
                // _yanzhengmabutton.backgroundColor = [UIColorpurpleColor];
                
            });
            
        }else{
            
            int seconds = timeout;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                _yanzhengmabutton.enabled = NO;
                //让按钮变为不可点击的灰色
                //                _yanzhengmabutton.backgroundColor = [UIColor grayColor];
                [_yanzhengmabutton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
                
                
                _yanzhengmabutton.userInteractionEnabled =NO;
                
                //设置界面的按钮显示根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [_yanzhengmabutton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime]forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}
- (IBAction)log:(id)sender {
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
