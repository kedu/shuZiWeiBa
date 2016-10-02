//
//  ViewController.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
//#import "WC-ItemModel.h"
//#import "GY_ItemsTableViewCell.h"
#import "FirstTableViewCell.h"
#import "FirstModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatview];
    [self loaddata];
}
-(void)creatview{

    self.tableview = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.tableview.dataSource =self;
    self.tableview.delegate = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableview];

    


}
-(void)loaddata{

    

[[AFHTTPSessionManager manager]GET:_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSDictionary *dictionary = responseObject[@"returnData"];
    NSDictionary *dict = dictionary[@"articlelist"];
    
    NSArray *arr = [dict allKeys];
    
    for (int i = 0; i<arr.count; i++) {
        
        NSString *string = arr[i];
        NSDictionary *dic = dict[string];
        FirstModel *model = [[FirstModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [self.dataArray addObject:model];
        
    }
    
    [self.tableview reloadData];
    
    
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"%@",error);
    
}];






}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FirstModel *model = self.dataArray[indexPath.row];
   
    cell.model = model;
    
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
