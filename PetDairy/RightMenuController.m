//
//  RightMenuController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-05.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "RightMenuController.h"
#import "PostViewController.h"
#import "ScrollViewInnerBtn.h"
#import "Header.h"
#import "PhotoesView.h"
#import "commentView.h"


@interface RightMenuController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ScrollViewInnerBtnDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *masterName;
@property (weak, nonatomic) IBOutlet UILabel *petName;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(strong,nonatomic)PostViewController *postViewController;
@property (weak, nonatomic) IBOutlet UIView *commentServiceView;
@property (weak, nonatomic) IBOutlet UIView *commentTrafficView;
@property (weak, nonatomic) IBOutlet UIView *commentTasteView;
//for delete photoes
@property(strong, nonatomic)NSMutableArray *innerViews;

- (IBAction)post:(id)sender;
- (IBAction)camera;
- (IBAction)pickPhoto;
- (IBAction)deletePics:(id)sender;


@property (weak, nonatomic) IBOutlet PhotoesView *photoCollections;


@end

@implementation RightMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.postButton.layer.cornerRadius = 23;
    commentView *commentServiceView = [[[NSBundle mainBundle] loadNibNamed:@"newCommentView" owner:nil options:nil] lastObject];
    [self.commentServiceView addSubview:commentServiceView];
    commentServiceView.frame = self.commentServiceView.bounds;
    commentView *cmtTrafficView = [[[NSBundle mainBundle] loadNibNamed:@"newCommentView" owner:nil options:nil] lastObject];
    [self.commentTrafficView addSubview:cmtTrafficView];
    cmtTrafficView.frame = self.commentTrafficView.bounds;
    cmtTrafficView.TitleLabel.text = @"环境：";
    commentView *cmtTasteView = [[[NSBundle mainBundle] loadNibNamed:@"newCommentView" owner:nil options:nil] lastObject];
    [self.commentTasteView addSubview:cmtTasteView];
    cmtTasteView.frame = self.commentTasteView.bounds;
    cmtTasteView.TitleLabel.text = @"味道：";
    //set up blur background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pickc540c.jpg"]];
}


-(PostViewController *)postViewController{
    if (!_postViewController) {
        PostViewController *post = [[PostViewController alloc]init];
        _postViewController = post;
    }
    return _postViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma for innerScrollView Image Collection

-(NSMutableArray *)innerViews{
    if (!_innerViews) {
        _innerViews = [[NSMutableArray alloc]init];
    }
    return _innerViews;
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
    self.postViewController.rightMenuController = self;
    if (![self.postContentBtn.titleLabel.text isEqualToString:@"想写点什么...."]) {
        self.postViewController.textContent.text = self.postContentBtn.titleLabel.text;
    }

}

- (IBAction)camera {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ipc animated:YES completion:nil];

}

- (IBAction)pickPhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ipc animated:YES completion:nil];

}

- (IBAction)deletePics:(id)sender {

    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"删除图片"]) {
        for (ScrollViewInnerBtn *btnn in self.innerViews) {
            btnn.coverButton.hidden = NO;
        }
        [btn setTitle:@"完成删除" forState:UIControlStateNormal];
        
    }else{
        for (ScrollViewInnerBtn *btnn in self.innerViews) {
            btnn.coverButton.hidden = YES;
        }
        [btn setTitle:@"删除图片" forState:UIControlStateNormal];

    }

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    ScrollViewInnerBtn *view = [[[NSBundle mainBundle] loadNibNamed:@"scrollViewInnerButton" owner:nil options:nil] lastObject];
    view.InnerPhoto.image = image;
    view.delegate = self;
    
    // 2.添加图片到相册中
    [self.photoCollections addSubview:view];
    
    //3.Add to delete arrays
    [self.innerViews addObject:view];
    
    //4.check delete arrays status to disable or enable delete btn
    if (self.innerViews.count !=0) {
        self.deleteBtn.enabled = YES;
    }
}
#pragma delegate for scrollView Inner CoverButton
-(void)ScrollViewInnerBtnDeletePic:(ScrollViewInnerBtn *)btn{
    [self.innerViews removeObject:btn];
    if (self.innerViews.count ==0) {
        [self.deleteBtn setTitle:@"删除图片" forState:UIControlStateNormal];
        self.deleteBtn.enabled = NO;
    }
    
}
//#pragma oberver method
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"innerViews"]) {
//        NSLog(@"aa");
//    }
//}
//-(void)dealloc{
//    [self removeObserver:self forKeyPath:@"innerViews"];
//}
@end
