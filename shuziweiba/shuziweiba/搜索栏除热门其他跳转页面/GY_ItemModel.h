//
//  GY_ItemModel.h
//  wantyou
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GY_ItemModel : NSObject

@property (nonatomic, copy) NSString *pic_url; // 照片路径
@property (nonatomic, copy) NSString *recommend_add;// 推荐
@property (nonatomic, assign) NSInteger commentnum; // 评论数
@property (nonatomic, copy) NSString *aid; // aid
@property (nonatomic, copy) NSString *uid; // uid
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *summary; // 介绍
@property (nonatomic, copy) NSString *author; // 发布者
@property (nonatomic, copy) NSString *pic; // 头像路径

@end
