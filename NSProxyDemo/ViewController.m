//
//  ViewController.m
//  NSProxyDemo
//
//  Created by 陈爱彬 on 15/3/5.
//  Copyright (c) 2015年 陈爱彬. All rights reserved.
//

#import "ViewController.h"
#import "AppProxy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //all call by AppProxy,but implements in different class
    [[AppProxy sharedProxy] doLoginThing];
    [[AppProxy sharedProxy] doMessageThing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
