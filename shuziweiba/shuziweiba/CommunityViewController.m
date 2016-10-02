#import "CommunityViewController.h"
#import "secondCollectionViewCell.h"
#import <SJIniteScrollView.h>
#import <AFNetworking.h>
#import "ScorllViewModel.h"
#import "DetailViewController.h"
#import "GYDetailViewController.h"
#define kscrollheight self.view.frame.size.height / 5
#define kcollectionwidth self.view.frame.size.width / 2 - 15
#define kcollectionheight 50
#import <MBProgressHUD.h>
@interface CommunityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,SJIniteScrollViewDelegate>
@property (nonatomic, strong) SJIniteScrollView *scvc;
@property (nonatomic, strong) NSMutableArray *ImageDataArray;
@property (nonatomic, strong) NSMutableArray *ImageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIView *YKWheadview;
@end

@implementation CommunityViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    [self creatView];
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

- (void)creatView
{
     UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, kscrollheight+30)];

    [self.view addSubview:head];
    //初始化轮播图
    SJIniteScrollView *scvc = [[SJIniteScrollView alloc] init];
    [MBProgressHUD showHUDAddedTo:scvc animated:YES];
    //轮播图占位符
//    scvc.placeholderImage = [UIImage imageNamed:@"article_default_new"];
//    scvc.rollingTime = 2.0;
    
    scvc.delegate = self;
    scvc.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, kscrollheight);
    //轮播图属性
    self.scvc = scvc;
   
    [head addSubview:scvc];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(kcollectionwidth, kcollectionheight);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(head.frame), self.view.frame.size.width, self.view.frame.size.height - kscrollheight - 60) collectionViewLayout:flowLayout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:collection];
    
    [collection registerNib:[UINib nibWithNibName:@"secondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    
}
- (void)loadData
{
    [[AFHTTPSessionManager manager] GET:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=diydata&apikeys=DGTLECOM_APITEST1&bid=274&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [MBProgressHUD hideHUDForView:self.scvc animated:YES];
        self.ImageDataArray = [NSMutableArray array];
        self.ImageArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        NSDictionary *dictionary = responseObject[@"returnData"];
        NSDictionary *dict = [dictionary[@"blocklist"] objectForKey:@"274"] ;
        
        NSArray *array = [dict allKeys];
        for (int i = 0; i < array.count; i ++) {
            NSString *string = array[i];
            NSDictionary *dic = dict[string];
            ScorllViewModel *scorllModel = [[ScorllViewModel alloc] init];
            [scorllModel setValuesForKeysWithDictionary:dic];
            [self.ImageDataArray addObject:scorllModel.Id];
            [self.ImageArray setObject:scorllModel.pic_url atIndexedSubscript:i];
            [self.titleArray setObject:scorllModel.title atIndexedSubscript:i];
            _scvc.imagesUrl = self.ImageArray;
            _scvc.titles = self.titleArray;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    secondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *arr = @[@"尾巴主板", @"甩甩尾巴", @"尾巴认证", @"尾巴良品", @"纠结尾巴", @"站务交流"];
    cell.titLabel.text = arr[indexPath.row];
    cell.themeCount.text = @"主题:12556";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYDetailViewController *detailVC = [[GYDetailViewController alloc] init];
    switch (indexPath.row) {
        case 0:
            detailVC.fid = 2;
            break;
        case 1:
            detailVC.fid = 46;
            break;
        case 2:
            detailVC.fid = 36;
            break;
        case 3:
            detailVC.fid = 77;
            break;
        case 4:
            detailVC.fid = 49;
            break;
        case 5:
            detailVC.fid = 38;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}
//轮播点击方法
- (void)initeScrollView:(SJIniteScrollView *)scrollView didSelectItemIndex:(NSInteger)index{
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.string = self.ImageDataArray[index];
    //隐藏底部
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
