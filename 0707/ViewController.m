//
//  ViewController.m
//  0707
//
//  Created by spp on 16/7/7.
//  Copyright © 2016年 spp. All rights reserved.
//

#import "ViewController.h"
#import "SecVc.h"
@interface ViewController ()
@property(nonatomic,strong)UIButton *btn1;
@property(nonatomic,strong)UIButton *btn2;
@end

@implementation ViewController
{
    NSTimer *_timer;
    float _i;
    float _j;
    float _i1;
    float _j1;
    float _i2;
    float _j2;
    float _i3;
    float _j3;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self liangge];
    
    for (int i= 0; i<4; i++) {
        UIView *bgview1 = [[UIView alloc]init];
        if (i/2 == 0) {
            bgview1.frame = CGRectMake(20+i*120, 160, 100, 100);
        }else{
            bgview1.frame = CGRectMake(20+(i-2)*120, 280, 100, 100);
        }
        bgview1.backgroundColor = [UIColor greenColor];
        [self.view addSubview:bgview1];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor redColor];
        btn.layer.cornerRadius = 20;
        [btn addTarget:self action:@selector(haha) forControlEvents:UIControlEventTouchUpInside];
        [bgview1 addSubview:btn];
       
    }

    
    
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value1",@"1",@"value2",@"2",@"value3",@"3",@"value4",@"4",nil];
    [NSTimer scheduledTimerWithTimeInterval:0.02
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:myDictionary
                                    repeats:YES];
    
    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, 100, 100)];
    [self.btn1  addTarget:self action:@selector(yuyin) forControlEvents:UIControlEventTouchUpInside];
    self.btn1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.btn1];
}
-(void)yuyin
{
    [self presentViewController:[[SecVc alloc]init] animated:YES completion:nil];
}
-(void)liangge
{
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(140, 40, 100, 100)];
    bgview1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:bgview1];self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.btn1.backgroundColor = [UIColor redColor];
    [self.btn1 addTarget:self action:@selector(haha) forControlEvents:UIControlEventTouchUpInside];
    self.btn1.layer.cornerRadius = 20;
    [bgview1 addSubview:self.btn1];
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 40, 40)];
    self.btn2.backgroundColor = [UIColor redColor];
    [self.btn2 addTarget:self action:@selector(haha) forControlEvents:UIControlEventTouchUpInside];
    self.btn2.layer.cornerRadius = 20;
    [bgview1 addSubview:self.btn2];
}
- (void)onTimer:(NSTimer *)timer
{
    if ([[[timer userInfo]objectForKey:@"1"] isEqualToString:@"value1"]) {
        UIButton *btn = [self.view viewWithTag:100];
        CGPoint p = btn.center;
        if (p.x <=20.0) {
            _i = arc4random()%2/2.0;
        }
        if (p.x >=80.0) {
            _i = arc4random()%2/2.0;
            _i = -_i;
        }
        if (p.y >= 80.0) {
            _j = arc4random()%4/2.0;
            _j = -_j;
        }
        if (p.y <= 20.0) {
            _j = arc4random()%4/2.0;
        }
        btn.center = CGPointMake(p.x+_i, p.y+_j);
    }
    if ([[[timer userInfo]objectForKey:@"2"] isEqualToString:@"value2"]) {
        UIButton *btn = [self.view viewWithTag:101];
        CGPoint p = btn.center;
        if (p.x <=20.0) {
            _i1 = arc4random()%2/2.0;
        }
        if (p.x >=80.0) {
            _i1 = arc4random()%2/2.0;
            _i1 = -_i1;
        }
        if (p.y >= 80.0) {
            _j1 = arc4random()%4/2.0;
            _j1 = -_j1;
        }
        if (p.y <= 20.0) {
            _j1 = arc4random()%4/2.0;
        }
        btn.center = CGPointMake(p.x+_i1, p.y+_j1);
    }
    if ([[[timer userInfo]objectForKey:@"3"] isEqualToString:@"value3"]) {
        UIButton *btn = [self.view viewWithTag:102];
        CGPoint p = btn.center;
        if (p.x <=20.0) {
            _i2 = arc4random()%2/2.0;
        }
        if (p.x >=80.0) {
            _i2 = arc4random()%2/2.0;
            _i2 = -_i2;
        }
        if (p.y >= 80.0) {
            _j2 = arc4random()%4/2.0;
            _j2 = -_j2;
        }
        if (p.y <= 20.0) {
            _j2 = arc4random()%4/2.0;
        }
        btn.center = CGPointMake(p.x+_i2, p.y+_j2);
    }
    if ([[[timer userInfo]objectForKey:@"4"] isEqualToString:@"value4"]) {
        UIButton *btn = [self.view viewWithTag:103];
        CGPoint p = btn.center;
        if (p.x <=20.0) {
            _i3 = arc4random()%2/2.0;
        }
        if (p.x >=80.0) {
            _i3 = arc4random()%2/2.0;
            _i3 = -_i3;
        }
        if (p.y >= 80.0) {
            _j3 = arc4random()%4/2.0;
            _j3 = -_j3;
        }
        if (p.y <= 20.0) {
            _j3 = arc4random()%4/2.0;
        }
        btn.center = CGPointMake(p.x+_i3, p.y+_j3);
    }
}


-(void)haha
{
    NSLog(@"哈哈");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
