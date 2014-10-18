//
//  KDViewController.m
//  BezierPathDemo
//
//  Created by ZhangYuanqing on 14-8-8.
//  Copyright (c) 2014年 KeyWandermen. All rights reserved.
//

#import "KDViewController.h"
#import "KDGraphicView.h"

@interface KDViewController ()

@property (nonatomic, retain) KDGraphicView *graphicView;
@property (nonatomic, retain) NSMutableArray *points;

@end

@implementation KDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.graphicView = [[KDGraphicView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:self.graphicView];
    self.graphicView.maxDot = 200;
    self.graphicView.minDot = 10;
    
    [self.view sendSubviewToBack:self.graphicView];
    
    self.points = [NSMutableArray arrayWithCapacity:0];
    [_points addObject:@(20)];
    [_points addObject:@(80)];
    [_points addObject:@(100)];
    [_points addObject:@(30)];
    [_points addObject:@(60)];
    [_points addObject:@(200)];
    [_points addObject:@(120)];
    self.graphicView.points = self.points;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawButtonPressed:(id)sender {
    
    if (self.valueField.text.length > 0) {
        CGFloat dot = self.valueField.text.floatValue;
        [_points addObject:@(dot)];
        self.valueField.text = @"";
        self.graphicView.points = self.points;
        [self.valueField resignFirstResponder];
    }
    
//    [self.valueField resignFirstResponder];
//    [self.graphicView reDraw];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self.valueField resignFirstResponder];
    return YES;
}



@end
