//
//  GY_wangceTableViewCell.m
//  wantyou
//
//  Created by 郭亚 on 16/5/26.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "GY_wangceTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface GY_wangceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *prc_url;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *viewnum;



@end

@implementation GY_wangceTableViewCell

- (void)setModel:(GY_wangceModel *)model
{
    [self.prc_url sd_setImageWithURL:[NSURL URLWithString:model.pic_url]];
    self.title.text = model.title;
    self.summary.text = model.summary;
    self.viewnum.text = [NSString stringWithFormat:@"%@", @(model.viewnum).stringValue];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
