//
//  GYDetailModel.h
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYDetailModel : NSObject
@property (nonatomic, copy) NSString *tid; // id
@property (nonatomic, copy) NSString *author;  // 作者编号
@property (nonatomic, copy) NSString *subject; // 标题
@property (nonatomic, copy) NSString *dateline; // 时间
@property (nonatomic, assign) NSInteger replies; // 评论数
@end
