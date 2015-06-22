//
//  GestureLockViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-06-19.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "GestureLockViewController.h"
#import "NJLockView.h"
#import "UIView+Alert.h"

@interface GestureLockViewController ()<NJLockViewDelegate>
@property (weak, nonatomic) IBOutlet NJLockView *lockView;
@property(copy, nonatomic)NSString *firstPwd;
@property(copy, nonatomic)NSString *secPwd;

@end

@implementation GestureLockViewController

-(void)setFirstPwd:(NSString *)firstPwd{
    _firstPwd = firstPwd;
    if (firstPwd != nil) {
        [UIView alertWith:@"提示" message:@"请输入第二次密码"];
    }
    
}
-(void)setSecPwd:(NSString *)secPwd{
    if ([secPwd isEqualToString:self.firstPwd]) {
            NSString *versionKey = @"GesturePassword";
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:secPwd forKey:versionKey];
            [defaults synchronize];
        self.firstPwd = nil;
        [UIView alertWith:@"成功" message:@"已经设置手势密码"];
    }else{
        self.firstPwd = nil;
        [UIView alertWith:@"错误" message:@"两次密码不符请重新输入"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lockView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.firstPwd == nil) {
        [UIView alertWith:@"提示" message:@"请第一次输入密码"];
    }else{
        if (self.secPwd == nil) {
            [UIView alertWith:@"提示" message:@"请第二次输入密码"];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lockViewDidClick:(NJLockView *)lockView andPwd:(NSString *)pwd
{
//    NSLog(@"NJViewController %@", pwd);
//    NSString *versionKey = @"GesturePassword";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *lastVersion = [defaults objectForKey:versionKey];
//    
//    [defaults setObject:pwd forKey:versionKey];
//    [defaults synchronize];
    
    if (self.firstPwd == nil) {
        self.firstPwd = pwd;
    }else{
        if (self.secPwd == nil) {
            self.secPwd = pwd;
        }
    }
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
