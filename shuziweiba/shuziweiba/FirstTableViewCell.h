//
//  FirstTableViewCell.h
//  数字尾巴model
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstModel.h"
@interface FirstTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageBig;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *Labeltext;

@property (nonatomic , strong)FirstModel *model;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end
