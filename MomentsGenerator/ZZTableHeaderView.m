//
//  ZZTableHeaderView.m
//  MomentsGenerator
//
//  Created by Zark on 2017/9/2.
//  Copyright © 2017年 Zarky. All rights reserved.
//

#import "ZZTableHeaderView.h"

@interface ZZTableHeaderView()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic ,strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *avatorLabel;
@end

static CGFloat kAvatorImageViewWidth = 74;
static CGFloat kAvatorImageViewRightPadding = 15;
static CGFloat kAvatorImageViewBottomPadding = 20;
static CGFloat kAvatorImageViewLeftPadding = 20;

@implementation ZZTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.avatorImageView];
    
    
    return self;
}

# pragma mark - Getters & Setters

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _backgroundImageView;
}

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = ({
            CGRect frame = CGRectMake(self.bounds.size.width - kAvatorImageViewWidth - kAvatorImageViewRightPadding, self.bounds.size.height - kAvatorImageViewWidth - kAvatorImageViewBottomPadding, kAvatorImageViewWidth, kAvatorImageViewWidth);
            UIImageView *avatorImageView = [[UIImageView alloc] initWithFrame:frame];
            avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
            avatorImageView.clipsToBounds = YES;
            avatorImageView;
        });
    }
    return _avatorImageView;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = _backgroundImage;
}

- (void)setAvatorImage:(UIImage *)avatorImage {
    _avatorImage = avatorImage;
    self.avatorImageView.image = _avatorImage;
}
@end
