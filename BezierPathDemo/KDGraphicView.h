//
//  KDGraphicView.h
//  BezierPathDemo
//
//  Created by ZhangYuanqing on 14-8-8.
//  Copyright (c) 2014年 KeyWandermen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 想要试用这个类，必须要先set最小值和最大值，然后再设置点s
 */

@interface KDGraphicView : UIView

@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, assign) CGFloat minDot;
@property (nonatomic, assign) CGFloat maxDot;

- (void)reDraw;

@end
