//
//  ZJJShufflingFigureView.h
//  ZJJShufflingFigure
//
//  Created by 张锦江 on 2018/5/18.
//  Copyright © 2018年 xtayqria. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^gestureBlock)(NSString *);

@interface ZJJShufflingFigureView : UIView

+ (instancetype)addShufflingFigureViewFrame:(CGRect)frame imagesArray:(NSArray<UIImage *> *)imagesArray;

- (void)openTimer;

- (void)closeTimer;

@property (nonatomic, copy) gestureBlock clickBlock;

@end


