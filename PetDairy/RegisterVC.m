//
//  RegisterVC.m
//  PetDairy
//
//  Created by Tommy on 2015-05-26.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "RegisterVC.h"
#import <Parse/Parse.h>

@interface RegisterVC ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)camera;


@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.upperView.backgroundColor = [UIColor colorWithRed:133/255.0 green:210/255.0 blue:197/255.0 alpha:1.0];
    self.downView.backgroundColor = [UIColor colorWithRed:106/255.0 green:168/255.0 blue:158/255.0 alpha:1.0];
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2;
     //create and configure the tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabEvent)];
    tapRecognizer.delegate =self;
    [self.view addGestureRecognizer:tapRecognizer];
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
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:self.username.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
    
        if(objects == nil){
            PFUser *user = [PFUser init];
            user.username = self.username.text;
            user.password = self.password.text;
            user.email = self.email.text;
            NSData *data = UIImageJPEGRepresentation(self.profileImg.image, 0.4);
            NSString *name = @"profile.jpg";
            user[@"profileImg"] = [ PFFile fileWithName:name data:data];
            user[@"postCount"] = 0;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error == nil){
                    
                }else{
                    
                }
            }];
        }else{
            
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            
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
