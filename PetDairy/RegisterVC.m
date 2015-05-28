//
//  RegisterVC.m
//  PetDairy
//
//  Created by Tommy on 2015-05-26.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@property (weak, nonatomic) IBOutlet UIView *upperView;

@property (weak, nonatomic) IBOutlet UIView *downView;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.upperView.backgroundColor = [UIColor colorWithRed:133/255.0 green:210/255.0 blue:197/255.0 alpha:1.0];
    self.downView.backgroundColor = [UIColor colorWithRed:106/255.0 green:168/255.0 blue:158/255.0 alpha:1.0];
    
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
