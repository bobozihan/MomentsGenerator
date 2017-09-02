//
//  ZZMainViewController.m
//  MomentsGenerator
//
//  Created by Zark on 2017/9/1.
//  Copyright © 2017年 Zarky. All rights reserved.
//

#import "ZZMainViewController.h"
#import "ZZTableHeaderView.h"

@interface ZZMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *momentsTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

static CGFloat const kTableViewOffset = 108;
static CGFloat const kNaviBarHeight = 64;

@implementation ZZMainViewController

# pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBar];
    [self setupTableView];
    [self.view addSubview:self.momentsTableView];
    
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

- (void)setupTableView {
    [self.momentsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.momentsTableView.tableFooterView = [[UIView alloc] init];
    // headerView
    ZZTableHeaderView *headerView = [[ZZTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width + kTableViewOffset - kNaviBarHeight)];
    headerView.backgroundImage = [UIImage imageNamed:@"IMG_5653.JPG"];
    headerView.avatorImage = [UIImage imageNamed:@"avator.jpg"];
    self.momentsTableView.tableHeaderView = headerView;
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    
//}

# pragma mark - Setter & Getter

- (UITableView *)momentsTableView {
    if (!_momentsTableView) {
        _momentsTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kTableViewOffset, self.view.bounds.size.width, self.view.bounds.size.height + kTableViewOffset) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView;
        });
    }
    return _momentsTableView;
}

@end
