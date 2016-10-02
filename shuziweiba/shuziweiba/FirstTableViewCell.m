//
//  FirstTableViewCell.m
//  数字尾巴model
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface FirstTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ykwImageHeigth;

@end
@implementation FirstTableViewCell


- (void)awakeFromNib {
    self.touxiangImage.layer.masksToBounds = YES;
    self.touxiangImage.layer.cornerRadius = 15;
    self.ykwImageHeigth.constant = [UIScreen mainScreen].bounds.size.height/5-10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(FirstModel *)model{
    _model = model;
    
    self.nameLabel.text = model.username;

    [self.imageBig sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    [self.touxiangImage sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    self.titleLabel.text = model.title;
    self.Labeltext.text = model.summary;
    
    
}
@end
