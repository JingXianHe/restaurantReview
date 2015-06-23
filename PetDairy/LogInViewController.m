//
//  LogInViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-06-14.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "TitleButton.h"
#import "LeftMenu.h"
#import "UIViewController+TitleBtn.h"
#import "UIView+Alert.h"
@interface LogInViewController ()<UIAlertViewDelegate>
- (IBAction)signIn;
- (IBAction)logout;

@end

@implementation LogInViewController



- (void)viewDidLoad {
    [super viewDidLoad];

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

- (IBAction)signIn {
    if ([PFUser currentUser]) {
        [UIView alertWith:@"错误" message:@"不能重复登录，请先注销用户再登录"];
        return;
    }else{
        UIButton *btn = self.navigationController.titleBtn;
        [self titleClick];
    }
    
}

#pragma mark - title button click event
-(void)titleClick{
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.baidu.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    
    if (!data) {
        [UIView alertWith:@"错误" message:@"互联网不能连接，无法使用登录功能"];
        return;
    }
    
    
    PFUser *current = [PFUser currentUser];
    if (current) {
        
        return;
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"请输入用户名字和密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert show];
    }
    
}
#pragma uialertViewDelegat
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *userName = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
            if (!error) {
                
                self.navigationController.topViewController.navigationItem.titleView = self.titleBtn;
                [UIView alertWith:@"消息" message:@"成功登录"];
                [self.view setNeedsDisplay];
                self.navigationController.topViewController.navigationItem.titleView = self.titleBtn;
                
            }else{
                NSString *errorMsg = error.userInfo[@"error"];
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"警告" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
                
            }
        }];
    }
}


- (IBAction)logout {
    
    if ([PFUser currentUser]) {
        [PFUser logOut];
        self.navigationController.topViewController.navigationItem.titleView = self.titleBtn;
    }
}
#pragma UIViewControllver + alert implement method
-(void)refreshView{
    
}

@end
