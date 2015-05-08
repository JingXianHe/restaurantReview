//
//  RightMenuController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-05.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "RightMenuController.h"
#import "PostViewController.h"
#import "Header.h"


@interface RightMenuController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *masterName;
@property (weak, nonatomic) IBOutlet UILabel *petName;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property(strong,nonatomic)PostViewController *postViewController;
- (IBAction)post:(id)sender;


@end

@implementation RightMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.postButton.layer.cornerRadius = 23;
    
}

-(PostViewController *)postViewController{
    if (!_postViewController) {
        PostViewController *post = [[PostViewController alloc]init];
        
        //post.view.width = [UIScreen mainScreen].bounds.size.width;
        //post.view.height = [UIScreen mainScreen].bounds.size.height;

        _postViewController = post;
    }
    return _postViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didShow
{
    
    [UIView transitionWithView:self.iconView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.iconView.image = [UIImage imageNamed:@"user_defaultgift"];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.iconView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                self.iconView.image = [UIImage imageNamed:@"default_avatar"];
            } completion:nil];
        });
    }];
}


- (IBAction)post:(id)sender {

            self.postViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.postViewController.view];
    

   
    
}
@end
