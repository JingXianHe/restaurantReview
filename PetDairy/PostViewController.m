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

    [self.view removeFromSuperview];
}

- (IBAction)commit {
    self.rightMenuController.postContentBtn.titleLabel.text = self.textContent.text;
    [self.view removeFromSuperview];
}
@end
