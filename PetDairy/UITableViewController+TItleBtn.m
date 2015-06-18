//
//  UITableViewController+TItleBtn.m
//  PetDairy
//
//  Created by Tommy on 2015-06-15.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "UITableViewController+TItleBtn.h"
#import <Parse/Parse.h>
#import "UIView+Extension.h"
@implementation UITableViewController (TItleBtn)
-(void)setTitleBtn:(UIButton *)titleBtn{
    self.titleBtn = titleBtn;
}
-(UIButton *)titleBtn{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.userInteractionEnabled = YES;
    [btn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    PFUser *current = [PFUser currentUser];
    if (current) {
        [btn setTitle:current.username forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
    
    
    btn.height = 48;
    btn.width = 150;
    
    
    return btn;
}
#pragma mark - title button click event
-(void)titleClick{
    PFUser *current = [PFUser currentUser];
    if (current) {
        
        return;
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"请输入用户名字和密码，如果新用户请点击注册按钮" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"注册", nil];
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
                [self.view setNeedsDisplay];
            }else{
                NSString *errorMsg = error.userInfo[@"error"];
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"警告" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
                
            }
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.topViewController.navigationItem.titleView = self.titleBtn;
}

@end
