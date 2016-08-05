//
//  ViewController.m
//
//  Created by anchen on 16/1/18.
//  Copyright © 2016年 anchen. All rights reserved.
//

#import "ViewController.h"
#import "ACLocation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *begButton = [UIButton buttonWithType:0];
    begButton.frame = CGRectMake(0, 0, 100, 44);
    [begButton setBackgroundColor:[UIColor greenColor]];
    [begButton setTitle:@"开启定位" forState:0];
    [self.view addSubview:begButton];
    [begButton addTarget:self action:@selector(beginLocation) forControlEvents:UIControlEventTouchUpInside];
    begButton.center = CGPointMake(self.view.center.x, self.view.center.y-40);
    
    begButton = [UIButton buttonWithType:0];
    begButton.frame = CGRectMake(0, 0, 100, 44);
    [begButton setBackgroundColor:[UIColor redColor]];
    [begButton setTitle:@"关闭定位" forState:0];
    [self.view addSubview:begButton];
    [begButton addTarget:self action:@selector(endLocation) forControlEvents:UIControlEventTouchUpInside];
    begButton.center = CGPointMake(self.view.center.x, self.view.center.y+40);
}

- (void)endLocation{

    [[ACLocation shareInstance] endUpdateLocation];

}

- (void)beginLocation{

    [[ACLocation shareInstance] beginUpdateLocation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
