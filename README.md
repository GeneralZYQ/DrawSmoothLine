DrawSmoothLine
==============

Chinese Version:

DrawSmoothLine 是一个简单的，API完善的可以用来绘制平滑曲线的控件。只需要为几个变量赋值即可完成对图像上下极值，平滑程度，点的控制，颜色控制等。并且可以点击查看每个点的具体坐标值。

如何工作：
-----------

在绘制过程中，会根据使用者所给出的值在相应的坐标摆放绘制点，并且使用平滑的曲线对这些点进行连接，从而得到最终的效果图。在效果图中，用户也可以手动点击每个点所在的位置来获取每个点的横坐标以及所代表值得大小。用户还可以控制是否渐变等。

示例:
------------

<img width =300 src = "" alt = "processing of draw"/><img width =300 src = "" alt = "tap a point"/>

使用方法:
-----------

1)在工程的相应位置添加控件

    self.graphicView = [[KDGraphicView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:self.graphicView];

2)为KDGraphicView控件添加最大和最小坐标值

    self.graphicView.maxDot = 200;
    self.graphicView.minDot = 10;

3)为KDGraphicView控件添加希望显示的数值，注意，所有数值应当以数组作为数据结构添加，数组中的每一个元素为```NSNumber```如：

    self.points = [NSMutableArray arrayWithCapacity:0];
    [_points addObject:@(20)];
    [_points addObject:@(80)];
    [_points addObject:@(100)];
    [_points addObject:@(30)];
    [_points addObject:@(60)];
    [_points addObject:@(200)];
    [_points addObject:@(120)];
    self.graphicView.points = self.points;
    
4)在本控件的 ```- (void)drawRect:(CGRect)rect;```方法中，可通过修改变量```kMellow```的值来修改连接曲线的点的"平滑程度"
    
在做好上面四步后，点击运行即可。

要求:
-------------

本工程使用ARC。如果您的工程为非ARC，在您的工程中标记本文件的编译标记为'-fobjc-arc'即可通过编译。

联系作者:
------------
邮箱:wazyq.cool@163.com

##欢迎大家提出意见和建议


