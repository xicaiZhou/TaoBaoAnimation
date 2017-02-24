//
//  ViewController.m
//  TaoBaoAnimation
//
//  Created by 周希财 on 2017/2/24.
//  Copyright © 2017年 iOS_ZXC. All rights reserved.
//

#import "ViewController.h"
#import "ZXCAnimationViewController.h"
/*   选择颜色尺寸动画
 一、 设想构思
 根据功能需求，大体分为四个UI部分
 1.最底层的黑色模版（当主要view缩放的时候显示的黑色UI）
 2.真正显示的view（也是要缩放的view）
 3.加一个模版在真正显示的view上（黑色半透明）
 4.弹出的视图
 
 二、 主体思路
 1.将自己的view（ViewController的View）作为最底层的黑色模版。
 
 2.将ZXCAnimationViewController加到view上作为真正显示的View，缩小的也是ZXCAnimationViewController的View
 3.创建View模版，设置alpha为0.5，使真正显示的view变成模糊
 
 4.创建view（选择颜色尺寸等），注⚠️：因为此view需要用户交互，所以不要是用layer动画，因为layer动画都是假象，我们直接改变frame即可
 
 三、如果有Core Animation方面技术模糊，请参考https://github.com/xicaiZhou/Animation
 */


/*   添加购物车动画
 
 一、设想构思
 根据功能需求，大体分为三个部分
 1.移动
 2.旋转
 3.缩小
 
 二、使用Core Aniamtion的CAAnimationGroup
 
 三、如果有Core Animation方面技术模糊，请参考https://github.com/xicaiZhou/Animation
 
 */
@interface ViewController ()

@property (nonatomic, strong) ZXCAnimationViewController *animation;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UINavigationController *nvc;
@property (nonatomic, strong) UIImageView *image;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置底部的背景颜色 （第一层）
    [self first];
    // 设置AnimationVC的属性 （第二层）
    [self second];
    // 设置maskView (第三层)
    [self third];
    // 设置popVIew （第四层）
    [self fource];
}
- (void)first{
    
    self.view.backgroundColor = [UIColor blackColor];
    
}
- (void)second{
    
    self.animation = [[ZXCAnimationViewController alloc] init];
    self.animation.view.backgroundColor = [UIColor whiteColor];
    self.animation.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.animation.title = @"Animation";
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.animation];

    [self addChildViewController:self.nvc];
    [self.view addSubview:self.nvc.view];
    
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 40, 40);
    [right setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.animation.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    // 设置开始按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"加入购物车" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 30);
    [self.nvc.view addSubview:button];

}
- (void)add{

    
}
- (void)third{
    
    self.maskView = [[UIView alloc] initWithFrame:self.animation.view.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.maskView.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    
    [self.maskView addGestureRecognizer:tapGesture];
    [self.nvc.view addSubview:self.maskView];
}
- (void)fource{
    
    self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2)];
    self.popView.backgroundColor = [UIColor redColor];
    self.popView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.popView.layer.shadowOffset = CGSizeMake(3, 3);
    self.popView.layer.shadowOpacity = 0.8;
    self.popView.layer.shadowRadius = 5.0f;
    
    self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    self.image.frame = CGRectMake(0, 0, 100, 100);
    self.image.center = CGPointMake(70, 35);
    [self.popView addSubview:self.image];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"加入购物车" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, self.popView.frame.size.height - 30);
    [self.popView addSubview:button];
}
- (void)animation:(UIButton *)sender{
    
    UIImageView *im = [[UIImageView alloc] initWithImage:self.image.image];
    im.frame = self.image.frame;
    [self.image.superview addSubview:im];
    CGFloat pointy  = [UIScreen mainScreen].bounds.size.height / 2 + 20;
    CGFloat pointx = [UIScreen mainScreen].bounds.size.width - 120;
    [UIView animateWithDuration:1 animations:^{
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        //    平移
        CABasicAnimation *anim = [CABasicAnimation animation];
        anim.keyPath = @"transform.translation";
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(pointx, -pointy)];
        //    缩放
        CABasicAnimation *scaleAnim = [CABasicAnimation  animation];
        scaleAnim.keyPath = @"transform.scale";
        scaleAnim.toValue = @0;
        
        CABasicAnimation *ro = [CABasicAnimation animation];
        ro.keyPath = @"transform.rotation.z";
        ro.toValue = [NSNumber numberWithFloat:22 * M_PI];
        //    设置动画组属性
        group.animations = @[anim,scaleAnim,ro];
        group.repeatCount = 1;
        group.removedOnCompletion = NO;
       
        group.fillMode = kCAFillModeForwards;
        //    添加组动画
        [im.layer addAnimation:group forKey:nil];
    }];
}
// 点击动画开始
- (void)clickShow:(UIButton *)button
{
    // 开始的时候把popView加载到window上面去，类似于系统的actionSheet之类的弹窗
    [[UIApplication sharedApplication].windows[0] addSubview:self.popView];
    CGRect rec = self.popView.frame;
    rec.origin.y = self.view.bounds.size.height / 2;
    
    [UIView animateWithDuration:0.3 animations:^{
        // 先逆时针X轴旋转
        self.nvc.view.layer.transform = [self transform1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.nvc.view.layer.transform = [self transform2];
            self.maskView.alpha = 0.5;
            self.popView.frame = rec;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

// 动画关闭
- (void)close:(UIButton *)button
{
    CGRect rec = self.popView.frame;
    rec.origin.y = self.view.bounds.size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.popView.frame = rec;
        self.maskView.alpha = 0;
        self.nvc.view.layer.transform = [self transform1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.nvc.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            [self.popView removeFromSuperview];
            
        }];
        
    }];
    
}

- (CATransform3D)transform1{
    // 每次进来都进行初始化
    CATransform3D form1 = CATransform3DIdentity;
    form1.m34 = 1.0/-900;
    //缩小的效果
    form1 = CATransform3DScale(form1, 0.95, 0.95, 1);
    //x轴旋转
    form1 = CATransform3DRotate(form1, 5.0 * M_PI/180.0, 1, 0, 0);
    return form1;
    
}

- (CATransform3D)transform2{
    // 初始化
    CATransform3D form2 = CATransform3DIdentity;
    form2.m34 = [self transform1].m34;
    //向上平移
    form2 = CATransform3DTranslate(form2, 0, self.view.frame.size.height * (-0.08), 0);
    //再次缩小
    form2 = CATransform3DScale(form2, 0.8, 0.8, 1);
    return form2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
