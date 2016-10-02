//
//  GYDetailViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "GYDetailViewController.h"
#import <AFNetworking.h>
#import "GYDetailModel.h"
#import "DetailTableViewCell.h"
//#import "ContentViewController.h"
#import "GYContentViewController.h"
#import "DetailViewController.h"
@interface GYDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation GYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self createView];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 41) style:(UITableViewStyleGrouped)];
    
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 100;
}

- (void)loadData
{
    self.dataArray = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=forumdisplay&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&fid=%ld&inapi=yes&modules=forum&orderby=lastpost&page=1&perpage=30&platform=ios&swh=480x800&version=2.8", (long)self.fid];

    NSLog(@"%@",url);
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dictionary = responseObject[@"returnData"];
        weakSelf.title = [dictionary[@"forum"] objectForKey:@"name"];
        
        for (NSDictionary *dic in dictionary[@"threadlist"]) {
            GYDetailModel *model = [[GYDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    GYDetailModel *model = _dataArray[indexPath.row];

    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    GYContentViewController *contentVC = [[GYContentViewController alloc]init];
    GYDetailModel *model = _dataArray[indexPath.row];
    contentVC.tid = model.tid;
    NSLog(@"%@",model.tid);
    [self.navigationController pushViewController:contentVC animated:YES];
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
