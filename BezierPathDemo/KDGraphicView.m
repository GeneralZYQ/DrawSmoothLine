//
//  KDGraphicView.m
//  BezierPathDemo
//
//  Created by ZhangYuanqing on 14-8-8.
//  Copyright (c) 2014年 KeyWandermen. All rights reserved.
//

#import "KDGraphicView.h"

static CGFloat kLabelHeight = 15.0;
static CGFloat kLabelWidth = 100.0;

@interface KDGraphicView ()

@property (nonatomic, retain) UILabel *minDotLabel;
@property (nonatomic, retain) UILabel *maxDotLabel;

@property (nonatomic, retain) NSMutableArray *dots;

@property (nonatomic, retain) NSMutableArray *dotControls;

@end

@implementation KDGraphicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor yellowColor];
        self.points = [[NSMutableArray alloc] initWithCapacity:0];
        self.dots = [[NSMutableArray alloc] initWithCapacity:0];
        self.dotControls = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.maxDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth, kLabelHeight)];
        self.minDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - kLabelHeight, kLabelWidth, kLabelHeight)];
        self.maxDotLabel.font = [UIFont systemFontOfSize:13.0];
        self.minDotLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:self.maxDotLabel];
        [self addSubview:self.minDotLabel];
    }
    return self;
}

- (void)setPoints:(NSMutableArray *)points {
    
    _points = points;
    [self.dots removeAllObjects];
    
    //这里应该写有范围情况下
    for (int i = 0; i < points.count; i ++) {
        CGFloat value = (self.frame.size.height * ([_points[i] floatValue] - self.minDot)) / (self.maxDot - self.minDot);
        
        CGPoint point = CGPointMake((i) * self.frame.size.width / (self.points.count - 1),300 - value);
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        [self.dots addObject:pointValue];
    }
    
    [self setNeedsDisplay];
}

- (void)setMaxDot:(CGFloat)maxDot {
    _maxDot = maxDot;
    self.maxDotLabel.text = [NSString stringWithFormat:@"%.f", maxDot];
}

- (void)setMinDot:(CGFloat)minDot {
    _minDot = minDot;
    self.minDotLabel.text = [NSString stringWithFormat:@"%.f", minDot];
}

- (void)drawRect:(CGRect)rect {
    
    for (UIControl *control in self.dotControls) {
        [control removeFromSuperview];
    }
    [self.dotControls removeAllObjects];
    
    UIBezierPath *lineGraph = [UIBezierPath bezierPath];
    CGFloat py0 = [_points[0] floatValue];
    CGPoint p0 = CGPointMake(0, 0);
    p0.y = 300 - py0;
    [lineGraph moveToPoint:p0];
    
    NSMutableArray *points = [[self dots] mutableCopy];
    
    // Add control points to make the math make sense
    [points insertObject:points[0] atIndex:0];
    [points addObject:[points lastObject]];
    
    [lineGraph moveToPoint:[points[0] CGPointValue]];
    
    CGFloat kMellow = 10;
    
    for (NSUInteger index = 1; index < points.count - 2; index++)
    {
        
        CGPoint p0 = [(NSValue *)points[index - 1] CGPointValue];
        CGPoint p1 = [(NSValue *)points[index] CGPointValue];
        CGPoint p2 = [(NSValue *)points[index + 1] CGPointValue];
        CGPoint p3 = [(NSValue *)points[index + 2] CGPointValue];
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < kMellow; i++)
        {
            float t = (float) i * (1.0f / (float) kMellow);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [lineGraph addLineToPoint:pi];
        
        }
        
        UIControl *dotControl = [[UIControl alloc] initWithFrame:CGRectMake(p1.x - 2, p1.y - 2, 4, 4)];
        dotControl.layer.cornerRadius = 2;
        dotControl.backgroundColor = [UIColor orangeColor];
        [self addSubview:dotControl];
        [self.dotControls addObject:dotControl];
        [dotControl addTarget:self action:@selector(dotControlPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [lineGraph addLineToPoint:p2];
    }
    //add the last point of the points
    CGPoint lastPoint = [(NSValue *)points[points.count - 2] CGPointValue];
    UIControl *dotControl = [[UIControl alloc] initWithFrame:CGRectMake(lastPoint.x - 2, lastPoint.y - 2, 4, 4)];
    dotControl.layer.cornerRadius = 2;
    dotControl.backgroundColor = [UIColor orangeColor];
    [self addSubview:dotControl];
    [self.dotControls addObject:dotControl];
    [dotControl addTarget:self action:@selector(dotControlPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [lineGraph addLineToPoint:[(NSValue *)points[(points.count - 1)] CGPointValue]];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // linear fillment of the color.
    NSArray* simpleLinearGradientColors = [NSArray arrayWithObjects:
                                           (id)[UIColor orangeColor].CGColor,
                                           (id)[UIColor yellowColor].CGColor, nil];
    CGFloat simpleLinearGradientLocations[] = {0, 0.9};
    CGGradientRef simpleLinearGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)simpleLinearGradientColors, simpleLinearGradientLocations);
    
    [lineGraph addLineToPoint:CGPointMake(self.frame.size.width, 300)];
    [lineGraph addLineToPoint:CGPointMake(0, 300)];
    
    [lineGraph closePath];
    CGContextSaveGState(context);
    [lineGraph addClip];
    CGContextDrawLinearGradient(context, simpleLinearGradient, CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);
    CGContextRestoreGState(context);
    
//            [[UIColor blackColor] setStroke];
//            lineGraph.lineWidth = 1;
//            [lineGraph stroke];
    
    CGGradientRelease(simpleLinearGradient);
    CGColorSpaceRelease(colorSpace);
    
    [[UIColor blueColor] setFill];
    [[UIColor redColor] setStroke];
    lineGraph.lineCapStyle = kCGLineCapRound;
    lineGraph.lineJoinStyle = kCGLineJoinRound;
    lineGraph.flatness = 0.5;
    lineGraph.lineWidth = 2; // line width
    [lineGraph stroke];
}

- (void)reDraw {
    
    [self setNeedsDisplay];
}

- (void)dotControlPressed:(id)sender {
    
    UIControl *control = (UIControl *)sender;
    
    CGRect rect = control.frame;
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + rect.size.width + 2, rect.origin.y, 100, 15)];
    
    if (pointLabel.frame.origin.x + 100 > self.frame.size.width) {
        pointLabel.frame = CGRectMake(rect.origin.x + rect.size.width + 2 - 100, rect.origin.y, 100, 15);
    }
    pointLabel.backgroundColor = [UIColor clearColor];
    pointLabel.font = [UIFont systemFontOfSize:13.0];
    
    NSInteger index = [self.dotControls indexOfObject:control];
    CGPoint point = [(NSValue *)self.dots[index] CGPointValue];
    
    pointLabel.text = [NSString stringWithFormat:@"(%.1f, %.1f)", point.x, [self.points[index] floatValue]];
    pointLabel.alpha = 0;
    [self addSubview:pointLabel];
    
    [UIView animateWithDuration:1.5 animations:^(void) {
        pointLabel.alpha = 1;
        
    }completion:^(BOOL finished) {
       
        [UIView animateWithDuration:0.5 animations:^(void){
            
            pointLabel.alpha = 0;
            
        } completion:^(BOOL finished) {
            [pointLabel removeFromSuperview];
        }];
    }];
    
}

@end
