//
//  ViewController.m
//  ZJJShufflingFigure
//
//  Created by 张锦江 on 2018/5/18.
//  Copyright © 2018年 xtayqria. All rights reserved.
//

#import "ViewController.h"
#import "ZJJShufflingFigureView.h"
#import "NullViewController.h"

@interface ViewController () {
    ZJJShufflingFigureView *_shufflingView;
}

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_shufflingView openTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_shufflingView closeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imagesArray = @[[UIImage imageNamed:@"0.jpg"],
                             [UIImage imageNamed:@"1.jpg"],
                             [UIImage imageNamed:@"2.jpg"],
                             [UIImage imageNamed:@"3.jpg"],
                             [UIImage imageNamed:@"4.jpg"],
                             [UIImage imageNamed:@"5.jpg"],
                             [UIImage imageNamed:@"6.jpg"]
                             ];
    _shufflingView = [ZJJShufflingFigureView addShufflingFigureViewFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) imagesArray:imagesArray];
    _shufflingView.clickBlock = ^(NSString *string) {
        NSLog(@"string=%@",string);
    };
    [self.view addSubview:_shufflingView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NullViewController *vc = [NullViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
