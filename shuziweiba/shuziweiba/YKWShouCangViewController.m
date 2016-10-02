//
//  YKWShouCangViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "YKWShouCangViewController.h"

@interface YKWShouCangViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;

@end

@implementation YKWShouCangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";

    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)shoucangBack:(id)sender {
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
