//
//  ZZRootNaviViewController.m
//  MomentsGenerator
//
//  Created by Zark on 2017/9/1.
//  Copyright © 2017年 Zarky. All rights reserved.
//

#import "ZZRootNaviViewController.h"

@interface ZZRootNaviViewController ()

@property (nonatomic, strong) UIView *blurBackView;

@end

@implementation ZZRootNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UINavigationBar *naviBar = [UINavigationBar appearance];
    naviBar.tintColor = [UIColor whiteColor];
    naviBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    naviBar.barStyle = UIBarStyleBlack;
    [naviBar insertSubview:self.blurBackView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 毛玻璃
- (UIView *)blurBackView
{
    if (_blurBackView == nil) {
        _blurBackView = [UIView new];
        _blurBackView.frame = CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64);
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
//        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:0x040012 alpha:0.76].CGColor,(__bridge id)[UIColor colorWithHex:0x040012 alpha:0.28].CGColor];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.99].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.88].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1.0);
        [_blurBackView.layer addSublayer:gradientLayer];
        _blurBackView.userInteractionEnabled = NO;
        _blurBackView.alpha = 0.5;
    }
    return _blurBackView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
