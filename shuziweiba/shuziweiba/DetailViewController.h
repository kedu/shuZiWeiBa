//
//  DetailViewController.h
//  iReader
//
//  Created by lkb on 16/8/10.
//  Copyright © 2016年 lkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *mwebView;

@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong) NSString *titleString;

@end
