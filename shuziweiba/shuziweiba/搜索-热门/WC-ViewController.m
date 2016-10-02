//
//  WC-ViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "WC-ViewController.h"
#import <AFNetworking.h>
//#import "WCmodel.h"
//#import "WC-TableViewCell.h"
#import "FirstModel.h"
#import "FirstTableViewCell.h"


@interface WC_ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableview;
@end

@implementation WC_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableview.dataSource =self;
    self.tableview.delegate=self;
    [self.tableview registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
      _dataArray = [NSMutableArray array];
     [self loadData];
}


-(void)loadData{

    
    NSString *str = self.url;
[[AFHTTPSessionManager manager]GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
  

    NSDictionary *dictionry = [responseObject objectForKey:@"returnData"];
    NSDictionary *dict = [dictionry objectForKey:@"blocklist"];
    NSDictionary *dict1 = dict[@"353"];
    NSArray *arr = [dict1 allKeys];
    
    for (int i = 0; i<arr.count; i++) {
        NSString *string = arr[i];
        NSDictionary *dic = [dict1 objectForKey:string];
//        NSDictionary *dic1 = [dict objectForKey:@"fields"];
    FirstModel  *model = [[FirstModel alloc]init];
        
//        model.viewnum = [[dic1 objectForKey:@"viewnum" ]integerValue];
        
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    
    [self.tableview reloadData];
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    NSLog(@"%@",error);
}];


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",_dataArray.count);
    return _dataArray.count;


}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FirstModel *model = _dataArray[indexPath.row];
//    NSLog(@"%@",model.title);
    cell.model = model;
    return cell;
    
    


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 270;


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
