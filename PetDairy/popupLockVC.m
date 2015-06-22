//
//  popupLockVC.m
//  PetDairy
//
//  Created by Tommy on 2015-06-20.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "popupLockVC.h"
#import "NJLockView.h"
#import "UIView+Alert.h"

@interface popupLockVC ()<NJLockViewDelegate>
@property (weak, nonatomic) IBOutlet NJLockView *lockView;

@end

@implementation popupLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lockView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)lockViewDidClick:(NJLockView *)lockView andPwd:(NSString *)pwd
{
 

    NSString *versionKey = @"GesturePassword";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    if ([pwd isEqualToString:lastVersion]) {
        // 显示主控制器（HMTabBarController）
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // 切换控制器不要用push和modal这样会保留这个动画控制器在内存
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [storyboard instantiateInitialViewController];
    }else{

        [UIView alertWith:@"错误" message:@"密码不符合，请重新输入"];
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
