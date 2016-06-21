//
//  ViewController.m
//  UserSwiftTest
//
//  Created by 冯剑锋 on 16/6/21.
//  Copyright © 2016年 冯剑锋. All rights reserved.
//

#import "ViewController.h"
#import "UserSwiftTest-Swift.h"

@interface ViewController ()<MunePopViewOptionClick>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MunePopView * view = [[MunePopView alloc]initWithFrame:CGRectMake(0, 0, 45, 45) optionsCenterArr:@[@[@(-40),@(-35)], @[@(0),@(-45)], @[@(40),@(-35)]]];
    view.center = self.view.center;
    view.centerButton.backgroundColor = [UIColor greenColor];
    view.delegate = self;
    [self.view addSubview:view];
}

-(void)munePopViewOptionClick:(NSInteger)count{
    NSLog(@"%d",count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
