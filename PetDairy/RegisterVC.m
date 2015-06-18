//
//  RegisterVC.m
//  PetDairy
//
//  Created by Tommy on 2015-05-26.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "RegisterVC.h"
#import <Parse/Parse.h>
#import "UIView+Extension.h"
#import "UIViewController+TitleBtn.h"

@interface RegisterVC ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)camera;


@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.upperView.backgroundColor = [UIColor colorWithRed:133/255.0 green:210/255.0 blue:197/255.0 alpha:1.0];
//    self.downView.backgroundColor = [UIColor colorWithRed:106/255.0 green:168/255.0 blue:158/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone4sCity"]];
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2;
    self.profileImg.clipsToBounds = YES;
     //create and configure the tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabEvent)];
    tapRecognizer.delegate =self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.password.secureTextEntry = YES;
    
}


#pragma tap event
-(void)tabEvent{
    [self.email resignFirstResponder];
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
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

- (IBAction)uploadImg {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    self.profileImg.image = image;
}

- (IBAction)register {
    
    UIView *view = [[UIView alloc]init];
    view.frame = self.view.frame;
    view.backgroundColor = [UIColor grayColor];
    view.userInteractionEnabled = YES;
    view.alpha = 0.8;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:view];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"User"];
    [query whereKey:@"username" containsString:self.username.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
        if (error == nil){

            if(objects.count == 1){

                [spinner stopAnimating];
                [view removeFromSuperview];
                
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"错误" message:@"名字已被注册，请填写新名字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [view show];
                
            }else{
                
                PFUser *user = [PFUser user];
                user.username = self.username.text;
                user.password = self.password.text;
                user.email = self.email.text;
                NSData *data = UIImageJPEGRepresentation(self.profileImg.image, 0.4);
                NSString *name = @"profile.jpg";
                user[@"profileImg"] = [ PFFile fileWithName:name data:data];
                user[@"postCount"] = [NSNumber numberWithInt:0];
                if([self.genderSwitch isOn]){
                    user[@"gender"]= [NSNumber numberWithInt:1];
                    
                }else{
                    user[@"gender"] = [NSNumber numberWithInt:0];
                }
                //__block UIActivityIndicatorView *blockSpin = spinner;
                
                dispatch_queue_t q = dispatch_get_main_queue();
                dispatch_async(q, ^{
                    [spinner stopAnimating];
                    [view removeFromSuperview];
                    NSError *error = nil;
                    if([user signUp:(&error)]){
                        
                        self.username.text = nil;
                        self.password.text = nil;
                        self.email.text = nil;
                        self.profileImg.image = [UIImage imageNamed:@"default_avatar"];
                        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"成功" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [view show];
                        
                    }else{
                        
                        UIAlertView *alertVIew = [[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertVIew show];
                        
                    }
                    
                });
                
 
//                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    [blockSpin stopAnimating];
//                    [view removeFromSuperview];
//                    if(error == nil){
//                        
//                        self.username.text = nil;
//                        self.password.text = nil;
//                        self.email.text = nil;
//                        self.profileImg.image = [UIImage imageNamed:@"default_avatar"];
//                        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"成功" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [view show];
//                        
//                    }else{
//                        UIAlertView *alertVIew = [[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alertVIew show];
//                    }
//
//                }];
                

            }

        }else{
            [spinner stopAnimating];
            [view removeFromSuperview];
            UIAlertView *alertVIew = [[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertVIew show];
            
        }
    
        
    }];
    
}
- (IBAction)camera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerCameraDeviceFront;
    ipc.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ipc animated:YES completion:nil];
}
@end
