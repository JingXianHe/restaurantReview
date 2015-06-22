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
@interface LogInViewController ()<UIAlertViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *indicatorContainer;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

- (IBAction)signIn:(id)sender;

@end

@implementation LogInViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    self.password.delegate = self;
    //create and configure the tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabEvent)];
    tapRecognizer.delegate =self;
    [self.view addGestureRecognizer:tapRecognizer];

}
#pragma tap event
-(void)tabEvent{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([PFUser currentUser]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注销账号" message:@"是否需要注销账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
    }
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

- (IBAction)signIn:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    spinner.center = self.indicatorContainer.center;
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSString *userName = self.username.text;
    NSString *password = self.password.text;
    [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
        [spinner stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (!error) {
            
            self.username.text= nil;
            self.password.text = nil;
            UIButton *btn = (UIButton *)sender;
            //self.navigationController.topViewController.title = [PFUser currentUser].username;
            btn.enabled = NO;
            
        }else{
            NSString *errorMsg = error.userInfo[@"error"];
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"警告" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            
        }
    }];

}

#pragma uialertViewDelegat
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [PFUser logOut];
        
        self.navigationController.topViewController.navigationItem.titleView = self.titleBtn;

    }else{
    

        self.signInBtn.enabled = false;
    }
}
#pragma textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end
