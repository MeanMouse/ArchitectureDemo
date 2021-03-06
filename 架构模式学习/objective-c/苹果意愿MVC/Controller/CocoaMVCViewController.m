//
//  CocoaMVCViewController.m
//  架构模式学习
//
//  Created by mo2323 on 2018/11/12.
//  Copyright © 2018年 com.developer.meanmouse. All rights reserved.
//

#import "CocoaMVCViewController.h"
#import "CocoaMVCAnimalDetailView.h"
#import "CocoaMVCAnimal.h"

@interface CocoaMVCViewController ()
/** @brief promptLabel */
@property (nonatomic,strong) UILabel *promptLabel;
/** @brief view */
@property (nonatomic,strong) CocoaMVCAnimalDetailView *detailView;
/** @brief model */
@property (nonatomic,strong) CocoaMVCAnimal *dog;

@end

@implementation CocoaMVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initModel];
    [self initView];
}

- (void)initView
{
    _detailView = [[CocoaMVCAnimalDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3.f, 150)];
    _detailView.backgroundColor = [UIColor lightGrayColor];
    _detailView.center = self.view.center;
    
    _detailView.nameLabel.text = _dog.name;
    _detailView.bloodVolumeLabel.text = [NSString stringWithFormat:@"血量：%0.2f", _dog.bloodVolume];
    _detailView.defensesLabel.text = [NSString stringWithFormat:@"防御：%0.2f", _dog.defenses];
    _detailView.aggressivityLabel.text = [NSString stringWithFormat:@"攻击：%0.2f", _dog.aggressivity];
    
    [self.view addSubview:_detailView];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _detailView.frame.origin.y - 50, self.view.frame.size.width - 60, 20)];
    _promptLabel.backgroundColor = [UIColor clearColor];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.numberOfLines = 0;
    _promptLabel.hidden = YES;
    [self.view addSubview:_promptLabel];
    
    UIButton *attackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attackButton.frame = CGRectMake(( self.view.frame.size.width - 120 ) / 2.f, CGRectGetMaxY(_detailView.frame) + 30, 120, 35);
    [attackButton setTitle:[NSString stringWithFormat:@"攻击%@",_dog.name] forState:UIControlStateNormal];
    [attackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [attackButton setBackgroundColor:[UIColor redColor]];
    [attackButton addTarget:self action:@selector(attackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attackButton];
}

- (void)initModel
{
    _dog = [[CocoaMVCAnimal alloc] init];
    _dog.name = @"蠢狗";
    _dog.bloodVolume = 50;
    _dog.aggressivity = 0;
    _dog.defenses = 5;
}

- (void)attackButtonAction:(UIButton *)sender
{
    CGFloat reduceValue = random() % 15;
    CGFloat bloodReduceValue = reduceValue - _dog.defenses;
    if (bloodReduceValue <= 0) {
        
        [self showPromptText:@"无效攻击！" isError:YES];
        return;
    }
    if (_dog.bloodVolume > bloodReduceValue) {
        
        self.dog.bloodVolume = _dog.bloodVolume -bloodReduceValue;
        _detailView.bloodVolumeLabel.text = [NSString stringWithFormat:@"血量：%0.2f", _dog.bloodVolume];
        [self showPromptText:[NSString stringWithFormat:@"%@受到%0.2f伤害", _dog.name, bloodReduceValue] isError:NO];
    } else {
        
        self.dog.bloodVolume = 0;
        _detailView.bloodVolumeLabel.text = @"血量：0";
        [self showPromptText:@"蠢狗死了" isError:YES];
        sender.enabled = NO;
        sender.backgroundColor = [UIColor lightGrayColor];
    }
}


- (void)showPromptText:(NSString *)text isError:(BOOL)isError
{
    _promptLabel.textColor = (isError) ? [UIColor redColor] : [UIColor greenColor];
    _promptLabel.text = text;
    _promptLabel.hidden = NO;
    __weak CocoaMVCViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.promptLabel.hidden = YES;
    });
}

@end
