//
//  ZZMainViewController.m
//  MomentsGenerator
//
//  Created by Zark on 2017/9/1.
//  Copyright © 2017年 Zarky. All rights reserved.
//

#import "ZZMainViewController.h"
#import "ZZTableHeaderView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static CGFloat const kTableViewOffset = 108;
static CGFloat const kNaviBarHeight = 64;
static CGFloat const kRefreshImageInitialY = 40;
static CGFloat const kRefreshImageMaxY = 93;

@interface ZZMainViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isRefreshing;
    BOOL shouldRefresh;
}
@property (nonatomic, strong) UITableView *momentsTableView;
@property (nonatomic, strong) UIImageView *refreshImageView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation ZZMainViewController

# pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self.view addSubview:self.momentsTableView];
    [self.view addSubview:self.refreshImageView];
    
    isRefreshing = NO; shouldRefresh = NO;
    
    
    self.dataSourceArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private

- (void)setupNaviBar {
    self.title = @"朋友圈";
    // 拍照
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(handlePostAction)];
    self.navigationItem.rightBarButtonItem = postBtn;
    // Customize 返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn setTitle:@" 发现" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(handleBackAction) forControlEvents:UIControlEventTouchUpInside];
    // 返回按钮偏移
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = @[spacer, backBtnItem];
}

- (void)handleBackAction {
    [self.dataSourceArray addObject:[NSString stringWithFormat:@"%li", self.dataSourceArray.count+1]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.momentsTableView numberOfRowsInSection:0] inSection:0];
    [self.momentsTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.momentsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)handlePostAction {
    if (![self.momentsTableView numberOfRowsInSection:0]) {
        return;
    }
    [self.dataSourceArray removeLastObject];
    NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:[self.momentsTableView numberOfRowsInSection:0]-1 inSection:0];
    NSIndexPath *toIndexPath;
    if (!([self.momentsTableView numberOfRowsInSection:0] == 1)) {
        toIndexPath = [NSIndexPath indexPathForRow:[self.momentsTableView numberOfRowsInSection:0]-2 inSection:0];
    }
    [self.momentsTableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.momentsTableView scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

// 菊花旋转
- (void)startRotate: (CGFloat)start {
    if (![self.refreshImageView.layer animationForKey:@"refreshAnimation"]) {
        CABasicAnimation *refreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        refreshAnimation.duration = 1;
        refreshAnimation.fromValue = [NSNumber numberWithFloat:start];
        refreshAnimation.toValue = [NSNumber numberWithFloat:start + M_PI * 2];
        refreshAnimation.repeatCount = HUGE_VALF;
        refreshAnimation.fillMode = kCAFillModeForwards;
        [self.refreshImageView.layer addAnimation:refreshAnimation forKey:@"refreshAnimation"];
        [self doSomeThing];
        isRefreshing = YES;
    }
}

- (void)doSomeThing {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do some thing
        [NSThread sleepForTimeInterval:2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.refreshImageView.center = CGPointMake(self.refreshImageView.center.x, kRefreshImageInitialY);
            } completion:^(BOOL finished) {
                isRefreshing = NO;
                shouldRefresh = NO;
                [self.refreshImageView.layer removeAllAnimations];
            }];
        });
    });
}

# pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

# pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isRefreshing) return;
    CGFloat scrollY = scrollView.contentOffset.y;
    if (scrollY < 0) {
        CGFloat centerY = kRefreshImageInitialY + fabs(scrollY) - kNaviBarHeight;
        if (centerY < kRefreshImageMaxY) {
            self.refreshImageView.center = CGPointMake(self.refreshImageView.center.x, centerY);
            shouldRefresh = NO;
        } else {
            self.refreshImageView.center = CGPointMake(self.refreshImageView.center.x, kRefreshImageMaxY);
            shouldRefresh = YES;
        }
        CGFloat rotation = scrollY/15.0;
        self.refreshImageView.layer.affineTransform = CGAffineTransformMakeRotation(rotation);
//        self.refreshImageView.transform = CGAffineTransformMakeRotation(rotation);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat scrollY = scrollView.contentOffset.y;
    CGFloat rotation = scrollY/15.0;
    if (shouldRefresh) {
        [self startRotate:rotation];
    } else {
        self.refreshImageView.center = CGPointMake(self.refreshImageView.center.x, kRefreshImageInitialY);
    }
}

# pragma mark - Setter & Getter

- (UITableView *)momentsTableView {
    if (!_momentsTableView) {
        _momentsTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kTableViewOffset, SCREEN_WIDTH, SCREEN_HEIGHT + kTableViewOffset) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
            tableView.tableFooterView = [[UIView alloc] init];
            // headerView
            ZZTableHeaderView *headerView = [[ZZTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + kTableViewOffset - kNaviBarHeight)];
            headerView.backgroundImage = [UIImage imageNamed:@"IMG_5653.JPG"];
            headerView.avatorImage = [UIImage imageNamed:@"avator.jpg"];
            tableView.tableHeaderView = headerView;
            tableView;
        });
    }
    return _momentsTableView;
}

- (UIImageView *)refreshImageView {
    if (!_refreshImageView) {
        _refreshImageView = ({
            UIImage *refreshImage = [UIImage imageNamed:@"AlbumReflashIcon"];
            UIImageView *refreshView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, refreshImage.size.width, refreshImage.size.height)];
            refreshView.center = CGPointMake(refreshView.center.x, kRefreshImageInitialY);
            refreshView.image = refreshImage;
            refreshView;
        });
    }
    return _refreshImageView;
}

@end
