//
//  KDViewController.h
//  BezierPathDemo
//
//  Created by ZhangYuanqing on 14-8-8.
//  Copyright (c) 2014年 KeyWandermen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *drawButton;
@property (nonatomic, unsafe_unretained) IBOutlet UITextField *valueField;

- (IBAction)drawButtonPressed:(id)sender;

@end
