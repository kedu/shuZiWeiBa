//
//  ZHNLeftSortViewController.m
//  BiJianYou
//
//  Created by Nirvana on 16/5/17.
//  Copyright © 2016年 南鑫林. All rights reserved.
//

#import "ZHNLeftSortViewController.h"
#import "ZHNUserLoginViewController.h"
#import "ZHNQrCodeViewController.h"









@interface ZHNLeftSortViewController ()<UITableViewDataSource, UITableViewDelegate>
//头像
@property (nonatomic, strong) UIButton *imageButton;
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//二维码
@property (nonatomic, strong) UIButton *binaryButton;
//个性签名图标
@property (nonatomic, strong) UIImageView *personImage;
//个性签名
@property (nonatomic, strong) UITextField *textFiled;
//设置
@property (nonatomic, strong) UIButton *setButton;
//登录
@property (nonatomic, strong) UIButton *LoginButton;



@end

#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define kMainPageDistance   90   //打开左侧窗时，中视图(右视图)露出的宽度
#define kNTColor ([UIColor colorWithRed: 60 / 255.0 green: 60 / 255.0 blue: 255 / 255.0 alpha: 0])

@implementation ZHNLeftSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    //添加背景图
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"back.jpg"];
    
    [self.view addSubview:image];
    
    __weak typeof(self) weakSelf = self;
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
        
    }];

    _imageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _imageButton.frame = CGRectMake(CGRectGetMinX(weakSelf.view.frame) + 30, CGRectGetMinY(weakSelf.view.frame) + 40, 50, 50);
    
        [_imageButton setImage:[UIImage imageNamed:@"im.jpg"] forState:(UIControlStateNormal)];
        _imageButton.layer.cornerRadius = 25;
        _imageButton.layer.masksToBounds = YES;
    [_imageButton addTarget:self action:@selector(imageButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [image addSubview:_imageButton];
    
    
    //添加名字
            _nameLabel = [[UILabel alloc]init];
            _nameLabel.text = @"未登录";
            [image addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
                make.top.equalTo(_imageButton.mas_top).offset(15);
    
                make.left.equalTo(_imageButton.mas_right).offset(KHorizontalSpace);
                make.width.equalTo(_imageButton.mas_width).offset(50);
          
            }];
    //二维码点击
    self.binaryButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.binaryButton.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame) + CGRectGetWidth(_nameLabel.frame) + 200, CGRectGetMinY(self.nameLabel.frame) + 50, self.imageButton.frame.size.width - 25, self.imageButton.frame.size.height - 25);
    [self.binaryButton setImage:[UIImage imageNamed:@"bri1.png"] forState:(UIControlStateNormal)];

    [self.binaryButton addTarget:self action:@selector(binaryButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [image addSubview:self.binaryButton];
    
    //个性签名标签
    self.personImage = [[UIImageView alloc]init];
    self.personImage.frame = CGRectMake(CGRectGetMinX(weakSelf.view.frame) + 30, CGRectGetMaxY(_imageButton.frame) + 20, 25, 25);
    self.personImage.image = [UIImage imageNamed:@"person.png"];
    [image addSubview:self.personImage];
    
   //个性签名
    image.userInteractionEnabled = YES;
    self.textFiled = [[UITextField alloc]init];
    self.textFiled.font = [UIFont systemFontOfSize:12.0f];
    self.textFiled.placeholder = @"个性签名";
    self.textFiled.layer.cornerRadius = 10;
    self.textFiled.backgroundColor = [UIColor clearColor];
    self.textFiled.frame = CGRectMake(_personImage.frame.origin.x + _personImage.frame.size.width,CGRectGetMaxY(_imageButton.frame) + 22, _personImage.frame.size.width + 130, 30);
    
    [image addSubview:self.textFiled];

    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.frame = CGRectMake(0, CGRectGetMaxY(self.textFiled.frame) + 10, kScreenWidth - kMainPageDistance, kScreenHeight - 230);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = kNTColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    self.setButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.setButton.frame = CGRectMake(CGRectGetMinX(tableView.frame) + 10, CGRectGetMaxY(tableView.frame) + 30, 30, 30);
    
    [self.setButton setImage:[UIImage imageNamed:@"set.png"] forState:(UIControlStateNormal)];
    [self.setButton addTarget:self action:@selector(setButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [image addSubview:self.setButton];
    
    self.LoginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.LoginButton.frame = CGRectMake(CGRectGetMaxX(self.setButton.frame) + 30, CGRectGetMidY(self.setButton.frame) - 15, 32, 32);
    [self.LoginButton setImage:[UIImage imageNamed:@"login.png"] forState:(UIControlStateNormal)];
    [self.LoginButton addTarget:self action:@selector(LoginButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [image addSubview:self.LoginButton];
    
    
    
}
//头像点击方法
- (void)imageButtonAction{
    NSLog(@"头像点击,跳转到个人中心");
    
    ZHNUserLoginViewController *loginVC = [[ZHNUserLoginViewController alloc]init];
    
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
  
    [self presentViewController:naviVC animated:YES completion:nil];
    
}
//二维码跳转
- (void)binaryButtonAction
{
    NSLog(@"二维码跳转");
    ZHNQrCodeViewController *qrCodeVC = [[ZHNQrCodeViewController alloc]init];
    
   UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:qrCodeVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
   
    
}
//设置跳转
- (void)setButtonAction{
    NSLog(@"跳转设置界面");
    
}
//登录页面跳转
- (void)LoginButtonAction{
    NSLog(@"登录跳转");
    
    ZHNUserLoginViewController *loginVC = [[ZHNUserLoginViewController alloc]init];
    
  UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
  
    [self presentViewController:naviVC animated:YES completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
//UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的收藏";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"数据2";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"清除缓存";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"数据4";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"数据5";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"数据6";
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"数据7";
    }

    
    
    return cell;
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
