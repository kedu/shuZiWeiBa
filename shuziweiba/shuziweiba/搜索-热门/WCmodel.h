//
//  WCmodel.h
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCmodel : NSObject
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *summary; // 内容
@property (nonatomic, copy) NSString *pic_url; // 图片路径
@property (nonatomic, assign) NSInteger viewnum; // 浏览数
@end
