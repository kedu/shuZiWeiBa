//
//  GY_ItemsTableViewCell.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "GY_ItemsTableViewCell.h"
#import <UIImageView+WebCache.h>


@interface GY_ItemsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pic; // 头像路径
@property (weak, nonatomic) IBOutlet UIImageView *pic_url; // 图片路径
@property (weak, nonatomic) IBOutlet UILabel *author; // 发布者
@property (weak, nonatomic) IBOutlet UILabel *title; // 标题
@property (weak, nonatomic) IBOutlet UILabel *summary; // 详情
@property (weak, nonatomic) IBOutlet UILabel *recommend_add; // 赞
@property (weak, nonatomic) IBOutlet UILabel *commentnum; // 评论数

@end

@implementation GY_ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    self.pic.layer.masksToBounds = YES;
    self.pic.layer.cornerRadius = 22.5;
}

- (void)setModel:(GY_ItemModel *)model
{
    self.author.text = model.author;
    self.title.text = model.title;
    self.summary.text = model.summary;
    self.recommend_add.text = [NSString stringWithFormat:@"%@", model.recommend_add];
    self.commentnum.text = [NSString stringWithFormat:@"%@",@(model.commentnum).stringValue];
    [self.pic_url sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
