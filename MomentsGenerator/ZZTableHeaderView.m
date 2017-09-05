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

static CGFloat const kAvatorImageViewWidth = 74;
static CGFloat const kAvatorImageViewRightPadding = 15;
static CGFloat const kAvatorImageViewBottomPadding = 20;
//static CGFloat const kAvatorImageViewLeftPadding = 20;
static CGFloat const kAvatorStrokewidth = 0.5;
static CGFloat const kAvatorBorder = 3;


@implementation ZZTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.avatorImageView];
    
    
    return self;
}

# pragma mark - Private

- (UIImage *)getborderAvaterImage: (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.avatorImageView.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw border
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, kAvatorStrokewidth);
    CGContextAddRect(context, self.avatorImageView.bounds);
    CGContextDrawPath(context, kCGPathFillStroke);
    // draw image
    CGRect smallRect = CGRectMake(kAvatorBorder, kAvatorBorder, self.avatorImageView.bounds.size.width - 2 * kAvatorBorder, self.avatorImageView.bounds.size.height - 2 *  kAvatorBorder);
    [image drawInRect:smallRect];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
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
    self.avatorImageView.image = [self getborderAvaterImage:_avatorImage];
}
@end
