//
//  GY_wangceViewController.m
//  wantyou
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "GY_wangceViewController.h"
#import <AFNetworking.h>
#import "GY_wangceModel.h"
#import "GY_wangceTableViewCell.h"

@interface GY_wangceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GY_wangceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"热门";
    [self createView];
    
    [self loadData];
}

- (void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"GY_wangceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 200;
    // 分割线
    self.tableView.separatorStyle = 0;
}


- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[AFHTTPSessionManager manager] GET:self.url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataArray = [NSMutableArray array];
        NSDictionary *dictionary = responseObject[@"returnData"];
        
        NSDictionary *dict = [dictionary[@"blocklist"] objectForKey:@"353"];
        NSArray *array = [dict allKeys];
        for (int i = 0 ; i < array.count; i ++) {
         NSString *string = array[i];
         NSDictionary *dic = dict[string];
         NSDictionary *dicc = [dic objectForKey:@"fields"];
        GY_wangceModel *model = [[GY_wangceModel alloc] init];

        model.viewnum = [dicc[@"viewnum"] integerValue];
        
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];

        }
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GY_wangceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GY_wangceModel *model = _dataArray[indexPath.row];
    
    [cell setModel:model];
    cell.selectionStyle = 0;
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
