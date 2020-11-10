//
//  ZJJShufflingFigureView.m
//  ZJJShufflingFigure
//
//  Created by 张锦江 on 2018/5/18.
//  Copyright © 2018年 xtayqria. All rights reserved.
//

#define SCROLL_OFFSET_X      self.scrollView.contentOffset.x
#define IMAGES_TAG           10000

#import "ZJJShufflingFigureView.h"

@interface ZJJShufflingFigureView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSTimer *moveTimer;
@property (nonatomic, assign) float viewWidth;
@property (nonatomic, assign) float viewHeight;

@end

@implementation ZJJShufflingFigureView

+ (instancetype)addShufflingFigureViewFrame:(CGRect)frame imagesArray:(NSArray<UIImage *> *)imagesArray {
    return [[self alloc] initWithFrame:frame withArray:imagesArray];
}

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray<UIImage *> *)imagesArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        [self addSubview:self.scrollView];
        [self reHandleImagesArray:imagesArray];
        [self addImagesOnScrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(50, _viewHeight-30, _viewWidth-100, 30)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        _pageControl.numberOfPages = _imageArray.count-2;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)reHandleImagesArray:(NSArray<UIImage *> *)imagesArray {
    [self.imageArray addObjectsFromArray:imagesArray];
    [self.imageArray insertObject:[imagesArray lastObject] atIndex:0];
    [self.imageArray addObject:[imagesArray firstObject]];
}

- (void)addImagesOnScrollView {
    for (NSInteger i = 0; i<self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewWidth*(i%_imageArray.count), 0, _viewWidth, _viewHeight)];
        imageView.image = _imageArray[i];
        imageView.userInteractionEnabled = YES;
        imageView.tag = IMAGES_TAG+i;
        [_scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
    }
    _scrollView.contentSize = CGSizeMake(_viewWidth*_imageArray.count, 0);
    _scrollView.contentOffset = CGPointMake(_viewWidth, 0);
}

#pragma mark - UIScrollView 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self closeTimer];
    if (SCROLL_OFFSET_X >= (_imageArray.count - 1)*_viewWidth) {
        [_scrollView setContentOffset:CGPointMake(_viewWidth, 0) animated:NO];
    } else if (SCROLL_OFFSET_X <= 0) {
        [_scrollView setContentOffset:CGPointMake(_viewWidth*(_imageArray.count-2), 0) animated:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self openTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (SCROLL_OFFSET_X/_viewWidth > 0) {
        _pageControl.currentPage = SCROLL_OFFSET_X/_viewWidth - 1;
    } else {
        _pageControl.currentPage = _imageArray.count - 3;
    }
    if (SCROLL_OFFSET_X == (_imageArray.count - 1)*_viewWidth) {
        _pageControl.currentPage = 0;
    }
}

- (void)openTimer {
    if (!_moveTimer) {
        self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(movePhoto) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_moveTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)closeTimer {
    int offset = SCROLL_OFFSET_X;
    int width = _viewWidth;
    int a = offset % width;
    if (a != 0) {
        int b = offset / width;
        [_scrollView setContentOffset:CGPointMake(width*(b+1), 0) animated:NO];
    }
    [self.moveTimer invalidate];
    self.moveTimer = nil;
}

- (void)movePhoto {
    NSLog(@"定时器还活着...");
    if (SCROLL_OFFSET_X >= (_imageArray.count - 1)*_viewWidth) {
        [_scrollView setContentOffset:CGPointMake(_viewWidth, 0) animated:NO];
        _pageControl.currentPage = 0;
    } else {
        float next_offset_x = SCROLL_OFFSET_X+_viewWidth;
        [_scrollView setContentOffset:CGPointMake(next_offset_x, 0) animated:YES];
        if (next_offset_x >= (_imageArray.count - 1)*_viewWidth) {
            _pageControl.currentPage = 0;
        } else {
            _pageControl.currentPage = next_offset_x/_viewWidth - 1;
        }
    }
}

- (void)tapClick:(UITapGestureRecognizer *)gesture {
    NSInteger sender_tag = gesture.view.tag;
    NSString *string = [NSString stringWithFormat:@""];
    if (sender_tag == _imageArray.count - 1 + IMAGES_TAG || sender_tag == IMAGES_TAG+1) {
        string = @"您点击了第1张图片";
    } else if (sender_tag == IMAGES_TAG || sender_tag == _imageArray.count - 2 + IMAGES_TAG) {
        string = @"您点击了最后1张图片";
    } else {
        string = [NSString stringWithFormat:@"您点击了第%ld张图片",sender_tag - IMAGES_TAG];
    }
    if (self.clickBlock) {
        self.clickBlock(string);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
