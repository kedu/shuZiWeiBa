//
//  RegisterViewController.h
//  shuziweiba
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myBlock)(NSString *,NSString *);
@interface RegisterViewController : UIViewController
@property (nonatomic, copy) myBlock block;
@end
