//
//  DetailTableViewCell.h
//  wantyou
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDetailModel.h"

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelineLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *repliesLabel;



- (void)setModel:(GYDetailModel *)model;

@end
