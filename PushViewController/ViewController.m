//
//  ViewController.m
//  PushViewController
//
//  Created by 远方 on 2017/5/19.
//  Copyright © 2018年 远方. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)ThreeViewController:(UIViewController *)soureViewController {
    [ViewControllerManager pushViewController:soureViewController targetViewController:@"DetailViewController"];
}

- (void)ThreeDetailViewController:(UIViewController *)soureViewController withParameters:(id)parameters {
    [ViewControllerManager pushViewController:soureViewController targetViewController:@"DetailViewController" withParameters:parameters isProperty:YES block:^(id object) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
