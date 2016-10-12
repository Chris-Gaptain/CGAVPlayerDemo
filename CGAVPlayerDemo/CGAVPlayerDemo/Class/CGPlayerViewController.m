//
//  CGPlayerViewController.m
//  CGAVPlayerDemo
//
//  Created by Chris Gaptain on 16/10/9.
//  Copyright © 2016年 wolf. All rights reserved.
//

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define kPlayerHeight kMainScreenHeight-100

#import "CGPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QuickControl.h"

@interface CGPlayerViewController ()
{
    CMTime playTimeWhenEnterBackground;
}
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *pauseBtn;

@property (nonatomic, strong) UISlider *slider;

@end

@implementation CGPlayerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view.layer addSublayer:self.playerLayer];
    [self.view addSubview:self.pauseBtn];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.slider];
    [self addProgressObserver];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipViewAction:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:swipe];
}

#pragma mark - 手势滑动
- (void)swipViewAction:(UISwipeGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Began");
            break;
        
        case UIGestureRecognizerStateEnded:
            NSLog(@"Ended");
            break;
            
        case UIGestureRecognizerStateChanged:
            NSLog(@"Changed");
            break;
            
        default:
            break;
    }
}

#pragma mark - 点击按钮
- (void)pauseBtnAction:(UIButton *)sender {
    if (self.player.rate == 0) {
        [self.player play];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    } else if (self.player.rate == 1) {
        [self.player pause];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }
}

// 视频播放完成的通知
- (void)avPlayerDidFinishPlay:(NSNotification *)notification {
    NSLog(@"******视频播放完成******");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pauseBtn setTitle:@"开始" forState:UIControlStateNormal];
        [self.progressView setProgress:0 animated:NO];
        [self.slider setValue:0 animated:NO];
        [self.player seekToTime:kCMTimeZero];
    });
}

// 进入到后台的通知
- (void)appEnterBackground:(NSNotification *)notification {
    // 进入后台时记录当前播放时间
    playTimeWhenEnterBackground = self.player.currentTime;
    [self.player pause];
}

// 进入到前台的通知
- (void)appEnterForeground:(NSNotification *)notification {
    // 设置播放速率为正常速度，设置当前播放时间为进入后台时的时间
    [self.player seekToTime:playTimeWhenEnterBackground completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
}

// progress和slider每秒执行一次
-(void)addProgressObserver {
    
    __weak CGPlayerViewController *weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([weakSelf.item duration]);
        if (current) {
            [weakSelf.progressView setProgress:(current/total) animated:YES];
            [weakSelf.slider setValue:(current/total) animated:YES];
        }
        
    }];
}
#pragma mark - Getter
- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(5, 65, 250, 300);
        
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (!_player) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Audio" ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        self.item = [AVPlayerItem playerItemWithAsset:asset];
        _player = [AVPlayer playerWithPlayerItem:self.item];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avPlayerDidFinishPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return _player;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.playerLayer.frame)+20, kMainScreenWidth-10, 5)];
    }
    return _progressView;
}

- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithFrame:CGRectMake(25, CGRectGetMaxY(self.progressView.frame)+15, 30, 15) title:@"暂停" image:@"" target:self action:@selector(pauseBtnAction:)];
        _pauseBtn.backgroundColor = [UIColor redColor];
        [_pauseBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    return _pauseBtn;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.pauseBtn.frame)+20, kMainScreenWidth-20, 15)];
        _slider.backgroundColor = [UIColor redColor];
    }
    return _slider;
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
