//
//  SecVc.m
//  0707
//
//  Created by spp on 16/7/8.
//  Copyright © 2016年 spp. All rights reserved.
//

#import "SecVc.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "PopupView.h"
#import "AlertView.h"
#import "TTSConfig.h"
/*
 术语定义：
 demo中合成共包含两种工作方式：
 1.边合成边播放方式，简称通用合成；
 2.uri，只合成不播放方式，简称uir合成；
 以下demo中注释将采用简称。
 */
@interface SecVc ()<IFlySpeechSynthesizerDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UITextView *textView;
@end

@implementation SecVc

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIBarButtonItem *spaceBtnItem = [[ UIBarButtonItem alloc]     //键盘
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil action:nil];
    UIBarButtonItem *hideBtnItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@"隐藏" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(onKeyBoardDown:)];
    [hideBtnItem setTintColor:[UIColor whiteColor]];
    UIToolbar *toolbar = [[ UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    NSArray *array = [NSArray arrayWithObjects:spaceBtnItem,hideBtnItem, nil];
    [toolbar setItems:array];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
    _textView.inputAccessoryView = toolbar;
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_textView.layer setCornerRadius:7.0f];
    [self.view addSubview:_textView];
    
    CGFloat posY = self.textView.frame.origin.y+self.textView.frame.size.height/6;
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, posY, 0, 0) withParentView:self.view];
    
    _inidicateView =  [[AlertView alloc]initWithFrame:CGRectMake(100, posY, 0, 0)];
    _inidicateView.ParentView = self.view;
    [self.view addSubview:_inidicateView];
    [_inidicateView hide];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-60, self.view.frame.size.width-20, 40)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"语音" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(haha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
#pragma mark - 初始化uri合成的音频存放路径和播放器
    
    //     使用-(void)synthesize:(NSString *)text toUri:(NSString*)uri接口时， uri 需设置为保存音频的完整路径
    //     若uri设为nil,则默认的音频保存在library/cache下
    NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //uri合成路径设置
    _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
    //pcm播放器初始化
    _audioPlayer = [[PcmPlayer alloc] init];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initSynthesizer];
}
#pragma mark - 设置合成参数
- (void)initSynthesizer
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    
    NSDictionary* languageDic=@{@"Guli":@"text_uighur", //维语
                                @"XiaoYun":@"text_vietnam",//越南语
                                @"Abha":@"text_hindi",//印地语
                                @"Gabriela":@"text_spanish",//西班牙语
                                @"Allabent":@"text_russian",//俄语
                                @"Mariane":@"text_french"};//法语
    
    NSString* textNameKey=[languageDic valueForKey:instance.vcnName];
    NSString* textSample=nil;
    
    if(textNameKey && [textNameKey length]>0){
        textSample=NSLocalizedStringFromTable(textNameKey, @"tts/tts", nil);
    }else{
        textSample=NSLocalizedStringFromTable(@"text_chinese", @"tts/tts", nil);
    }
    
    [_textView setText:textSample];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.isViewDidDisappear = true;
    [_iFlySpeechSynthesizer stopSpeaking];
    [_audioPlayer stop];
    [_inidicateView hide];
    _iFlySpeechSynthesizer.delegate = nil;
    
}
/**
 隐藏键盘
 ****/
-(void)onKeyBoardDown:(id) sender
{
    [_textView resignFirstResponder];
}
-(void)haha
{
    if ([_textView.text isEqualToString:@""]) {
        [_popUpView showText:@"无效的文本信息"];
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    _synType = NomalType;
    
    self.hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    
    [_inidicateView setText: @"正在缓冲..."];
    [_inidicateView show];
    
    [_popUpView removeFromSuperview];
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    NSString* str= _textView.text;
    
    
    [_iFlySpeechSynthesizer startSpeaking:str];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}
#pragma mark - 合成回调 IFlySpeechSynthesizerDelegate

/**
 开始播放回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakBegin
{
    [_inidicateView hide];
    self.isCanceled = NO;
    if (_state  != Playing) {
        [_popUpView showText:@"开始播放"];
    }
    _state = Playing;
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
