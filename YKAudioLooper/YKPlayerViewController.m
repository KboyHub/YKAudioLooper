//
//  YKPlayerViewController.m
//  YKAudioLooper
//
//  Created by 闫康 on 2018/5/22.
//  Copyright © 2018年 闫康. All rights reserved.
//

#import "YKPlayerViewController.h"
#import "YKControlKnob.h"
#import "YKPlayerController.h"

@interface YKPlayerViewController () <YKPlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *playLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet YKControlKnob *rateKnob;
@property (strong, nonatomic) IBOutletCollection(YKControlKnob) NSArray *panKnob;


@property (strong, nonatomic) IBOutletCollection(YKOrangeControlKnob) NSArray *volumeKnob;

@property (nonatomic,strong)YKPlayerController *playerController;

@end

@implementation YKPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playerController = [[YKPlayerController alloc]init];
    self.playerController.delegate = self;
    self.rateKnob.minimumValue = 0.5f;
    self.rateKnob.maximumValue = 1.5f;
    self.rateKnob.value = 1.0f;
    self.rateKnob.defaultValue = 1.0f;
    
    // Panning L = -1, C = 0, R = 1
    for (YKControlKnob *knob in self.panKnob) {
        knob.minimumValue = -1.0f;
        knob.maximumValue = 1.0f;
        knob.value = 0.0f;
        knob.defaultValue = 0.0f;
    }
    
    // Volume Ranges from 0..1
    for (YKControlKnob *knob in self.volumeKnob) {
        knob.minimumValue = 0.0f;
        knob.maximumValue = 1.0f;
        knob.value = 1.0f;
        knob.defaultValue = 1.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonClicked:(UIButton *)sender {
    if (!self.playerController.isPlaying) {
        [self.playerController play];
        self.playLabel.text = NSLocalizedString(@"Stop", nil);
    }else{
        [self.playerController stop];
        self.playLabel.text = NSLocalizedString(@"Play", nil);
    }
    self.playButton.selected = !self.playButton.selected;
    
}

- (IBAction)adjustRate:(YKControlKnob *)sender {
    [self.playerController adjustPlayRate:sender.value];
}


- (IBAction)adjustPan:(YKControlKnob *)pan {
    [self.playerController adjustPlayPan:pan.value forPlayerAtIndex:pan.tag];
}

- (IBAction)adjustVolume:(YKControlKnob *)volume {
    [self.playerController adjustPlayVolume:volume.value forPlayerAtIndex:volume.tag];
}

- (void)playbackBegin{
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        self.playButton.selected = YES;
        self.playLabel.text = NSLocalizedString(@"Stop", nil);
    });
    
}

- (void)playbackStopped {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playButton.selected = NO;
        self.playLabel.text = NSLocalizedString(@"Play", nil);
    });
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
