//
//  ThirdViewController.m
//  asda
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "ThirdViewController.h"
#import "OneCollectionViewCell.h"
#import "TwoCollectionViewCell.h"
//#import "searchViewController.h"
#import "WCSearchOKViewController.h"
#import "CommunityViewController.h"
#import "DetailsViewController.h"
#import "SenconDetailsViewController.h"
#import <AFNetworking.h>
#import "WC-ViewController.h"
#import "ViewController.h"
#import "URLheader.h"
#import "FirstTableViewCell.h"
#import "FirstModel.h"
#import "DetailTableViewCell.h"
#import "GY_ItemsViewController.h"
#import "URLheader.h"
#import "GY_wangceViewController.h"
#define kcollectionwidth self.view.frame.size.width / 4 - 20
#define ktwoWidth self.view.frame.size.width / 2 - 15

@interface ThirdViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *firstCollection;
@property (nonatomic, strong) UICollectionView *secondCollection;
@property (nonatomic,strong)UISearchBar *customSearchBar;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.tag = 101;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(action)];
    [self.navigationItem setHidesBackButton:YES];
    
    // collction的布局
    [self creatView];
    
    // searchBar的布局
    [self sarch];
    
}

- (void)searchButton{
    
}
// 跳转页面的方法
-(void)action{

    [_customSearchBar resignFirstResponder];
    
    

    // 如果要回到主页面  就移除sarchBar这个控件

    
    [self.navigationController popViewControllerAnimated:YES];
    //返回时隐藏搜索
        _customSearchBar.hidden = YES;
 


    
    
   

    

}


//  添加searchBar 到navigationController上  布局和添加的方法
-(void)sarch{

//     _customSearchBar = [[UISearchBar alloc]init];
    CGRect mainViewBounds = self.navigationController.view.bounds;
    _customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMinX(mainViewBounds), CGRectGetMinY(mainViewBounds) +25, self.navigationController.view.bounds.size.width-50, 40)];

    _customSearchBar.searchBarStyle = UISearchBarStyleMinimal ;
    _customSearchBar.delegate = self;
    _customSearchBar.showsCancelButton = YES;
    [self.navigationController.view addSubview: _customSearchBar];
    CGRect viewBounds = self.navigationController.view.bounds;
    [self.view setFrame:CGRectMake(CGRectGetMinX(viewBounds), CGRectGetMinY(viewBounds) + 40, CGRectGetWidth(viewBounds), CGRectGetHeight(viewBounds) - 128)];
    
    // 用空格将文字靠左
_customSearchBar.placeholder = @"搜索文章、帖子、用户";

    _customSearchBar.showsCancelButton = NO;
    [_customSearchBar setTranslucent:YES];
//    _customSearchBar.backgroundColor = [UIColor clearColor];

  
    
    
}

//  点击事件 释放第一响应者 移除键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 移除键盘
 [_customSearchBar resignFirstResponder];





}
//  点击搜索框是调用   searchBar点击
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    
    NSLog(@"这里是点击了输入框执行的方法");



}

// 没有编辑内容的时候回走此方法 会执行此方法
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    
    
    
    NSLog(@"这里是搜索完成执行的方法");
    
   
    
 
    
    
  

}



// 点击搜索按钮的回调方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  
    
    // 释放键盘
    [searchBar resignFirstResponder ];
    
    NSLog(@"搜索这里是点击搜索执行的方法- 键盘serch按钮");

    
     //  跳转到加载数据的controller
        WCSearchOKViewController *viewcontroller = [WCSearchOKViewController new];
 
    
    [self.navigationController pushViewController:viewcontroller animated:NO];


}
// 取消按钮的回调方法(暂时没用)
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    

    NSLog(@"取消");




}
// 搜索结果的回调按钮
-(void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{



    



}




- (void)creatView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat Frrame =  self.view.frame.size.width;
    flowLayout.itemSize = CGSizeMake(Frrame/4-15, 100);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 5);
    _firstCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 120) collectionViewLayout:flowLayout];
    _firstCollection.delegate = self;
    _firstCollection.dataSource = self;
    _firstCollection.showsVerticalScrollIndicator = NO;
    _firstCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_firstCollection];
    
    [_firstCollection registerNib:[UINib nibWithNibName:@"OneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    UICollectionViewFlowLayout *twoFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    twoFlowLayout.itemSize = CGSizeMake(ktwoWidth + 10, 40);
//    twoFlowLayout.minimumInteritemSpacing = 0;
    twoFlowLayout.minimumLineSpacing = 0;
    twoFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _secondCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstCollection.frame)+20, self.view.frame.size.width  , self.view.frame.size.height - CGRectGetHeight(_firstCollection.frame)) collectionViewLayout:twoFlowLayout];
    _secondCollection.delegate = self;
    _secondCollection.dataSource = self;
    _secondCollection.showsVerticalScrollIndicator = NO;
    _secondCollection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_secondCollection];
    
    [_secondCollection registerNib:[UINib nibWithNibName:@"TwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell_id"];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_firstCollection == collectionView) {
        return 4;
    } else {
    return 13;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_firstCollection == collectionView) {
        OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

        NSArray *arrimage = @[@"search_heat@2x.png",@"search_activity2@3x.png",@"search_apps@3x.png",@"search_news@3x.png"];
        cell.imageView.image = [UIImage imageNamed:arrimage[indexPath.row]];
        NSArray *arr = @[@"热门", @"活动", @"应用", @"咨询"];
        cell.label.text = arr[indexPath.row];
        return cell;
    } else {
       TwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_id" forIndexPath:indexPath];
        NSArray *array = @[@"    手机",@"    平板",@"    周边",@"    电脑",@"    视频",@"    影视",@"    数码",@"    摄影",@"    旅行",@"    生活",@"    文具",@"    玩物",@"    沙龙"];
        cell.label.textAlignment = NSTextAlignmentLeft;
        cell.label.text = array[indexPath.row];
     
        NSArray *arrayimage1 = @[@"category_phone_small@2x.png",@"category_ipad_small@2x.png",@"category_mouse_small@2x.png",@"category_notebook_small@2x.png",@"category_dgtle_logo_small@2x.png",@"category_speaker_small@2x.png",@"category_ipod_small@2x.png",@"category_camera_small@2x.png",@"category_flight_small@2x.png",@"category_home_small@2x.png",@"category_pen_small@2x.png",@"category_rocket_small@2x.png",@"search_activity@2x.png"];
        cell.imageView.image = [UIImage imageNamed:arrayimage1[indexPath.row]];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_firstCollection == collectionView) {
        if (indexPath.row == 0) {
            GY_wangceViewController *wangVC = [[GY_wangceViewController alloc] init];
            wangVC.url = REMEN_URL;
            [self.navigationController pushViewController:wangVC animated:YES];
            
        } else {
            GY_ItemsViewController *itemVC = [[GY_ItemsViewController alloc] init];
            if (indexPath.row == 1) {
                itemVC.url = HUODONG_URL;
            } else if (indexPath.row == 2) {
                itemVC.url = YINGYIN_URL;
            } else if (indexPath.row == 3) {
                itemVC.url = ZIXUN_URL;
            }
            [self.navigationController pushViewController:itemVC animated:YES];
        }
    } else {
        GY_ItemsViewController *itemVC = [[GY_ItemsViewController alloc] init];
        
        switch (indexPath.row) {
            case 0:
                itemVC.url = PHONE_URL;
                break;
            case 1:
                itemVC.url = PINGBAN_URL;
                break;
            case 2:
                itemVC.url = FUJIN_URL;
                break;
            case 3:
                itemVC.url = DIANNAO_URL;
                break;
            case 4:
                itemVC.url = SHIPIN_URL;
                break;
            case 5:
                itemVC.url = YINGYIN_URL;
                break;
            case 6:
                itemVC.url = SHUMA_URL;
                break;
            case 7:
                itemVC.url = SHEYING_URL;
                break;
            case 8:
                itemVC.url = LVXING_URL;
                break;
            case 9:
                itemVC.url = SHENGHUO_URL;
                break;
            case 10:
                itemVC.url = WENJU_URL;
                break;
            case 11:
                itemVC.url = WANWU_URL;
                break;
            case 12:
                itemVC.url = SHALONG_URL;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:itemVC animated:YES];
    }
    [_customSearchBar resignFirstResponder];
    _customSearchBar.hidden = YES;
//
//    WC_ViewController *WCview = [WC_ViewController new];
//    self.wcurl  = [[NSString alloc]init];
//    WCview.url =  self.wcurl;
//    
//    if (_firstCollection == collectionView ) {
//    
//        if (indexPath.row ==0) {
//            _wcurl = REMEN_URL;
//        }else if (indexPath.row ==1){
//            
//            _wcurl = HUODONG_URL;
//        }else if(indexPath.row == 2){
//            
//            _wcurl = YINGYIN_URL;
//            
//        }else if(indexPath.row == 3){
//            
//            _wcurl = ZIXUN_URL;
//            
//            
//        }
//        [self.navigationController pushViewController:WCview animated:YES];
//        [_customSearchBar resignFirstResponder];
//        _customSearchBar.hidden = YES;
//        
//    }
//      else {
//    
//        switch (indexPath.row) {
//            case 0:
//                _wcurl = PHONE_URL;
//                break;
//            case 1:
//                 _wcurl= PINGBAN_URL;
//                break;
//            case 2:
//                _wcurl = FUJIN_URL;
//                break;
//            case 3:
//                _wcurl = DIANNAO_URL;
//                break;
//            case 4:
//                _wcurl = SHIPIN_URL;
//                break;
//            case 5:
//               _wcurl = YINGYIN_URL;
//                break;
//            case 6:
//                _wcurl = SHUMA_URL;
//                break;
//            case 7:
//               _wcurl = SHEYING_URL;
//                break;
//            case 8:
//                _wcurl = LVXING_URL;
//                break;
//            case 9:
//               _wcurl = SHENGHUO_URL;
//                break;
//            case 10:
//                _wcurl = WENJU_URL;
//                break;
//            case 11:
//               _wcurl = WANWU_URL;
//                break;
//            case 12:
//               _wcurl = SHALONG_URL;
//                break;
//            default:
//                break;
//        }
//
//        [self.navigationController pushViewController:WCview animated:YES];
//        [_customSearchBar resignFirstResponder];
//                    _customSearchBar.hidden = YES;
    
    
    
    }
//
//    WC_ViewController *WC= [WC_ViewController new];
//    SenconDetailsViewController *senconDetails = [SenconDetailsViewController new];
//    
////         ViewController *WCview = [ViewController new];
//    if (_firstCollection == collectionView) {
//        
//       
//      
//        if (indexPath.row == 0) {
//             WC.url = REMEN_URL;
//            [self.navigationController pushViewController:WC animated:YES];
//            [_customSearchBar resignFirstResponder];
//            _customSearchBar.hidden = YES;
//            
//        }
//        else{
//            if (indexPath.row == 1) {
//                WCview.url = HUODONG_URL;
//                
//            }else if (indexPath.row ==2 ){
//            
//                WCview.url = YINGYIN_URL;
//            
//            }else if(indexPath.row ==3){
//            
//                WCview.url = ZIXUN_URL;
//            
//            }
//      
//                
//            
//            
//                
//            }
//       [self.navigationController pushViewController:WCview animated:YES];
//        
//        
//        
//        
//        
//        else{
//            [self.navigationController pushViewController:senconDetails animated:YES];
//            [_customSearchBar resignFirstResponder];
//            _customSearchBar.hidden = YES;
//
//    
//    }
//
//    
//    }
    
    
 


// 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _customSearchBar.hidden = NO;
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
