//
//  ViewController.m
//  CGAVPlayerDemo
//
//  Created by Chris Gaptain on 16/10/9.
//  Copyright © 2016年 wolf. All rights reserved.
//

#import "ViewController.h"
#import "CGPlayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)pushAction:(id)sender {
    CGPlayerViewController *vc = [[CGPlayerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
