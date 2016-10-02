//
//  GY_ItemsViewController.m
//  wantyou
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "GY_ItemsViewController.h"
#import "GY_ItemModel.h"
#import "GY_ItemsTableViewCell.h"
#import <AFNetworking.h>
#import "DetailViewController.h"
@interface GY_ItemsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GY_ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createView];
    
    [self loadData];
}


- (void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"GY_ItemsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 260;

    // 分割线
    self.tableView.separatorStyle = 0;
}

- (void)loadData
{
    [[AFHTTPSessionManager manager] GET:self.url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataArray = [NSMutableArray array];
        NSDictionary *dictionary = responseObject[@"returnData"];
        if (dictionary[@"articlelist"] == nil) {
            NSDictionary *dict = [dictionary[@"blocklist"] objectForKey:@"274"] ;
            NSArray *array = [dict allKeys];
            for (int i = 0; i < array.count; i ++) {
                //STRING  所有的key
                NSString *string = array[i];
                
                NSDictionary *dic = dict[string];
                GY_ItemModel *model = [[GY_ItemModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        } else {
        NSDictionary *dict = dictionary[@"articlelist"];
        NSArray *array = [dict allKeys];
        for (int i = 0; i < array.count; i ++) {
            NSString *string = array[i];
            NSDictionary *dic = dict[string];
            GY_ItemModel *model = [[GY_ItemModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        }
        [self.tableView reloadData];
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
    GY_ItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GY_ItemModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    cell.selectionStyle = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *de = [DetailViewController new];
    GY_ItemModel *model = self.dataArray[indexPath.row];
      de.string = model.aid;

    [self.navigationController pushViewController:de animated:YES];
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
