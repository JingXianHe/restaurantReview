//
//  RegisterVC.h
//  PetDairy
//
//  Created by Tommy on 2015-05-26.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
- (IBAction)uploadImg;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UISwitch *genderSwitch;
- (IBAction)register;

@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *downView;

@end
