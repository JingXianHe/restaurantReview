//
//  PostViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-07.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "PostViewController.h"
#import "RightMenuController.h"
@interface PostViewController ()
- (IBAction)cancel;
- (IBAction)commit;


@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.textView becomeFirstResponder];
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


- (IBAction)cancel {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIView *view = [[UIView alloc]init];
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75 animations:^{
        weakSelf.view.frame = CGRectMake(0, height, width, height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [weakSelf.view removeFromSuperview];
    }];

}

- (IBAction)commit {
    self.rightMenuController.content = self.textContent.text;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIView *view = [[UIView alloc]init];
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75 animations:^{
        weakSelf.view.frame = CGRectMake(0, height, width, height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [weakSelf.view removeFromSuperview];
    }];
}
@end
