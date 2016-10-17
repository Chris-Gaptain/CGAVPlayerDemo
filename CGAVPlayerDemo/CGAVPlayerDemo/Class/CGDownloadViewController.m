//
//  CGDownloadViewController.m
//  CGAVPlayerDemo
//
//  Created by Chris Gaptain on 16/10/13.
//  Copyright © 2016年 wolf. All rights reserved.
//

#define kVideoURL @"http://www.bilibilijj.com/Files/DownLoad/10917081.mp4/www.bilibilijj.com.mp4?mp3=true"
//10917081
#import "CGDownloadViewController.h"
#import "CGNetworkQueue.h"

@interface CGDownloadViewController ()

@property (nonatomic, strong) UIButton *downloadBtn;

@property (nonatomic, strong) CGNetworkQueue *netQueue;

@end

@implementation CGDownloadViewController

- (CGNetworkQueue *)netQueue {
    if (!_netQueue) {
        _netQueue = [CGNetworkQueue sharedSingle];
    }
    return _netQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.downloadBtn];
    
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *destFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", @"10917081"]];
//    NSString *tempFilePath = [destFilePath stringByAppendingString:@".temp"];
//    NSLog(@"%@",cachePath);
//    NSLog(@"%@",destFilePath);
//    NSLog(@"%@",tempFilePath);

}

// 下载
- (void)downloadBtnAction:(UIButton *)sender {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *destFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", @"10917081"]];
    NSString *tempFilePath = [destFilePath stringByAppendingString:@".temp"];
    NSLog(@"%@",cachePath);
    NSLog(@"%@",destFilePath);
    NSLog(@"%@",tempFilePath);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:destFilePath]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该文件已下载" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kVideoURL]];
    // 设置下载完成后的路径
    request.downloadDestinationPath = destFilePath;
    // 设置下载过程中的临时路径
    request.temporaryFileDownloadPath = tempFilePath;
    // 后台下载
    request.shouldContinueWhenAppEntersBackground = YES;
    // 断点续传
    request.allowResumeForFileDownloads = YES;
    // 开始下载
    [self.netQueue addOperation:request];
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithFrame:CGRectMake(0, 100, kMainScreenWidth, 30) title:@"down" image:nil target:self action:@selector(downloadBtnAction:)];
        _downloadBtn.backgroundColor = [UIColor redColor];
    }
    return _downloadBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
