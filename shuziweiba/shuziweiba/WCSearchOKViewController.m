//
//  WCSearchOKViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "WCSearchOKViewController.h"

@interface WCSearchOKViewController ()

@end

@implementation WCSearchOKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(action)];
    self.navigationItem.hidesBackButton = YES;
}
//  调回第一个页面的方法
-(void)action{
    
    //    ThirdViewController *thrid = [ThirdViewController new];
    [self.navigationController popViewControllerAnimated:YES];
    
}

    // Do any additional setup after loading the view from its nib.


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
