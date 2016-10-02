//
//  UIView+YKWxyz.m
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import "UIView+YKWxyz.h"

@implementation UIView (YKWxyz)
-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(CGFloat)x{
    return self.frame.origin.x;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(CGFloat)y{
    return self.frame.origin.y;
}
@end
