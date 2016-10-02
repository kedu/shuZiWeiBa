//
//  DetailTableViewCell.m
//  wantyou
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(GYDetailModel *)model
{
    self.authorLabel.text = model.author;
    self.subjectLabel.text = model.subject;
    self.repliesLabel.text = [NSString stringWithFormat:@"%@",@(model.replies)];
    self.datelineLabel.text = model.dateline;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
