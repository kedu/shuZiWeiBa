//
//  YKWMenuViewController.m
//  Drawer
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "YKWMenuViewController.h"
#import "YKWShouCangViewController.h"//收藏
#import "YKWViewController.h"
#import "AppDelegate.h"
#import "CommunityViewController.h"
#import "YKWTabarViewController.h"
#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface YKWMenuViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *YKWtableView;

//头像
@property (nonatomic, strong) UIImageView *YKWimageUser;
//登录按钮
@property (nonatomic, strong) UIButton *loginbutton;
//用户名
@property (nonatomic, strong) UILabel *YKWname;
@property (nonatomic, strong) UIImagePickerController *imageViewPicker;
@end

@implementation YKWMenuViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //登录状态判断
    AVUser *currentUser = [AVUser currentUser];

    if (currentUser != nil) {
        NSString *current = [AVUser currentUser].username;
        self.YKWname.text = current;
        [self.loginbutton setTitle:@"注销" forState:(UIControlStateNormal)];
        // 允许用户使用应用
//        AVUser *user = [AVUser currentUser];
        AVFile *attachment = [currentUser objectForKey:@"HEADVIEW"];
        
        NSData *imageData = [attachment getData];
        if (imageData) {
            self.YKWimageUser.image = [UIImage imageWithData:imageData];
        }
        [self.loginbutton addTarget:self action:@selector(loginButtona) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
    }else {
        [self.loginbutton setTitle:@"登录" forState:(UIControlStateNormal)];
        self.YKWname.text = @"未登录";
        [self.loginbutton addTarget:self action:@selector(loginButtona) forControlEvents:(UIControlEventTouchUpInside)];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    //图像选择器
    _imageViewPicker = [[UIImagePickerController alloc]init];
    _imageViewPicker.delegate = self;
    //接收代理
    self.YKWtableView.delegate  =self;
    self.YKWtableView.dataSource = self;

    
}
- (void)creatView{

    //侧边栏头部视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [UIScreen mainScreen].bounds.size.height/5+64)];
    headerView.backgroundColor = [UIColor colorWithRed:0.502 green:0.502 blue:0.502 alpha:1.0];
    
    
    
    //头像的位置
    self.YKWimageUser = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-150 )/2-38, 122-58, 76, 76)];
    self.YKWimageUser.image = [UIImage imageNamed:@"1b-Article_inreader"];
    self.YKWimageUser.layer.masksToBounds = YES;
    self.YKWimageUser.layer.cornerRadius = 38;
    self.YKWimageUser.layer.borderWidth = 5;
    self.YKWimageUser.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    //点击设置头像
    self.YKWimageUser.userInteractionEnabled = YES;
    UITapGestureRecognizer *ImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapUserImageAction)];
    [self.YKWimageUser addGestureRecognizer:ImageTap];
    [headerView addSubview:self.YKWimageUser];
    self.YKWname = [[UILabel alloc]init];
    self.YKWname.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-150 )/2-38, CGRectGetMaxY(self.YKWimageUser.frame)+8, 76, 25);
    self.YKWname.textAlignment = 1;
    
    self.YKWname.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.YKWtableView addSubview:self.YKWname];

    self.YKWtableView.bounces = NO;
    
    //登录按钮
    self.loginbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginbutton.frame = CGRectMake(CGRectGetMaxX( self.YKWimageUser.frame)+10, CGRectGetMidY(self.YKWimageUser.frame)+10, 50, 30);
    
    
    [self.YKWtableView addSubview:self.loginbutton];
    //添加侧边栏tableView头部视图
    self.YKWtableView.tableHeaderView = headerView;
}
//头像点击事件
- (void)TapUserImageAction{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlertAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imageViewPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _imageViewPicker.allowsEditing = YES;
        [self presentViewController:_imageViewPicker animated:YES completion:nil];
    }];
    UIAlertAction *cameraAlertAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imageViewPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        _imageViewPicker.allowsEditing = YES;
        [self presentViewController:_imageViewPicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:photoAlertAction];
    [alert addAction:cameraAlertAction];
    [alert addAction:cancelAlertAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    // 由用户指定一个头像编辑
    UIImage *iamge = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.YKWimageUser.image = iamge;
    
    //存头像
    NSData *imageData = UIImagePNGRepresentation(iamge);
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    //[imageFile saveInBackground];
    
    AVUser *user = [AVUser currentUser];
    [user removeObjectForKey:@"HEADVIEW"];
    [user setObject:imageFile forKey:@"HEADVIEW"];
    [user saveInBackground];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   //4个按钮
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell  = [[ UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    // 侧边栏菜单按钮
    NSArray *array = @[@"首    页",@"收    藏",@"账    号",@"清除缓存"];
    cell.backgroundColor = [UIColor clearColor];
    for (int i = 0; i<array.count; i++) {
        if (indexPath.row == i) {
            cell.textLabel.text = array[i];
        }
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    }if (indexPath.row ==1) {
        YKWShouCangViewController *shou = [[YKWShouCangViewController alloc]init];
        // 设置模态样式
        shou.modalPresentationStyle = UIModalPresentationFullScreen;
        // 设置模态的动画效果
        shou.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:shou animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
       
        //登录状态判断
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser != nil) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
               NSString *abc = [NSString stringWithFormat:@"用户名为%@\n账号为%@",[AVUser currentUser].username,[AVUser currentUser].mobilePhoneNumber];
            UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"账号" message:abc preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okACtion = [UIAlertAction actionWithTitle:@"知道哦!" style:(UIAlertActionStyleCancel) handler:nil];
            [alertControll addAction:okACtion];
            [self presentViewController:alertControll animated:YES completion:nil];
           
            alertControll.message = abc;
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
           
            UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"账号" message:@"未登录 傻屌" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okACtion = [UIAlertAction actionWithTitle:@"知道哦!" style:(UIAlertActionStyleCancel) handler:nil];
            [alertControll addAction:okACtion];
            [self presentViewController:alertControll animated:YES completion:nil];
           
        }
       
        
       
       
    }
    if (indexPath.row == 3) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"清除缓存成功" preferredStyle:(UIAlertControllerStyleAlert)];
        

        UIAlertAction *okACtion = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControll addAction:okACtion];
        [self presentViewController:alertControll animated:YES completion:nil];
    }
    
    


}
- (void)loginButtona{
  AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        [AVUser logOut];
        NSLog(@"注销成功");
        self.YKWimageUser.image = [UIImage imageNamed:@"1b-Article_inreader"];
        [self.loginbutton setTitle:@"登录" forState:(UIControlStateNormal)];
        self.YKWname.text = @"未登录";
    }else{
        NSLog(@"跳转登录");
        LoginViewController *lo = [LoginViewController new];
        
        // 设置模态样式
        lo.modalPresentationStyle = UIModalPresentationFullScreen;
        // 设置模态的动画效果
        lo.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:lo animated:YES completion:^{
            
        }];
    }
  
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
