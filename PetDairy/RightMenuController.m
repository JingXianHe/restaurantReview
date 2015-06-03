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
#import "UIView+AutoLayout.h"
#import <Parse/Parse.h>



@interface RightMenuController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ScrollViewInnerBtnDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(strong,nonatomic)PostViewController *postViewController;
@property (weak, nonatomic) IBOutlet UIView *commentServiceView;
@property (weak, nonatomic) IBOutlet UIView *commentTrafficView;
@property (weak, nonatomic) IBOutlet UIView *commentTasteView;
@property(nonatomic, assign)CGFloat longitude;
@property(nonatomic, assign)CGFloat latitude;
//comment scores
@property(nonatomic, strong)NSNumber *tasteS;
@property(nonatomic, strong)NSNumber *serviceS;
@property(nonatomic, strong)NSNumber *suitableS;
//photoes for parse.com
@property(nonatomic,strong)NSMutableArray *photoes;
//decide public or private
@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;

//cllocation manager
@property (strong, nonatomic)CLLocationManager *mgr;
//for delete photoes
@property(strong, nonatomic)NSMutableArray *innerViews;
@property (weak, nonatomic) IBOutlet UIButton *titleTinkBtn;
- (IBAction)sendMsg;
@property (weak, nonatomic) IBOutlet UITextField *titleTextView;
- (IBAction)titleTintButton:(id)sender;

- (IBAction)post:(id)sender;
- (IBAction)camera;
- (IBAction)pickPhoto;
- (IBAction)deletePics:(id)sender;
- (IBAction)uploadGeo;
- (IBAction)inputTitle;

- (IBAction)switchPublic:(id)sender;

@property (weak, nonatomic) IBOutlet PhotoesView *photoCollections;
@property (strong, nonatomic)NSMutableArray *pfiles;


@end

@implementation RightMenuController

-(NSMutableArray *)pfiles{
    if (_pfiles == nil) {
        _pfiles = [[NSMutableArray alloc]init];
    }
    return _pfiles;
}

-(NSMutableArray *)photoes{
    if (_photoes == nil) {
        _photoes = [[NSMutableArray alloc]init];
    }
    return _photoes;
}

-(NSString *)content{
    if (_content == nil) {
        _content = @"";
    }
    return _content;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.postContentBtn.layer.cornerRadius = 23;
    commentView *commentServiceView = [[[NSBundle mainBundle] loadNibNamed:@"newCommentView" owner:nil options:nil] lastObject];
    
    [self.commentServiceView addSubview:commentServiceView];
    [commentServiceView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    commentView *cmtTrafficView = [[[NSBundle mainBundle] loadNibNamed:@"newCommentView" owner:nil options:nil] lastObject];
    
    
    [self.commentTrafficView addSubview:cmtTrafficView];
    [cmtTrafficView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    cmtTrafficView.TitleLabel.text = @"环境：";
    commentView *cmtTasteView = [[[NSBundle mainBundle] loadNibNamed:@"newCommentView" owner:nil options:nil] lastObject];
    
    [self.commentTasteView addSubview:cmtTasteView];
    //cmtTasteView.frame = self.commentTasteView.bounds;
    [cmtTasteView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    cmtTasteView.TitleLabel.text = @"味道：";
    //set up blur background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"restarauntBg-1"]];
    [self didShow];
    self.titleTinkBtn.layer.cornerRadius = 15;
    

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
    self.postViewController.textContent.text = self.content;

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
//title zone

- (IBAction)titleTintButton:(id)sender {
    [self.titleTextView resignFirstResponder];
    UIButton *btn = (UIButton *)sender;
    btn.enabled = false;
    [btn setTitle:@"餐厅名字:" forState:UIControlStateNormal];
    self.titleTinkBtn.backgroundColor = [UIColor clearColor];
}
- (IBAction)inputTitle {
    self.titleTinkBtn.enabled = YES;
    [self.titleTinkBtn setTitle:@"结束输入:" forState:UIControlStateNormal];
    self.titleTinkBtn.alpha = 1;
    self.titleTinkBtn.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)switchPublic:(id)sender {
    if (![PFUser currentUser]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请登录否则你的评论不能公开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        UISwitch *switch1 = (UISwitch *)sender;
        [switch1 setOn:YES animated:YES];
        
    }
}

//geolocation upload
- (IBAction)uploadGeo {

    self.mgr = [[CLLocationManager alloc]init];
    self.mgr.delegate = self;
    self.mgr.activityType = CLActivityTypeFitness;
    self.mgr.distanceFilter = 10;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.mgr requestAlwaysAuthorization];
    }else{
        [self.mgr startUpdatingLocation];
    }
    
}
#pragma mark - cllocationmanager delegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mgr startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    self.longitude = newLocation.coordinate.longitude;
    self.latitude = newLocation.coordinate.latitude;
    [self.mgr stopUpdatingLocation];
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

- (IBAction)sendMsg {
    
    if (self.titleTextView.text == nil) {
        return;
    }
    //retrieve comment value
    commentView *tmpS = (commentView *)[self.commentServiceView.subviews lastObject];
    int serviceP = tmpS.scores.intValue;
    commentView *tasteS = (commentView *)[self.commentTasteView.subviews lastObject];
    int tasteP = tasteS.scores.intValue;
    commentView *satisfyS = (commentView *)[self.commentTrafficView.subviews lastObject];
    int satisfyP = satisfyS.scores.intValue;
    NSMutableArray *picsCollection = [[NSMutableArray alloc]init];
    if (self.innerViews.count > 0) {
        //vacuum self.pfiles every time before use because it hard to know whenever the images finish uploading
        [self.pfiles removeAllObjects];
        //set up date data
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *dateT = [formatter stringFromDate:[NSDate date]];
        
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        int loop = 0;
        for (ScrollViewInnerBtn *item in self.innerViews) {
            NSString *file = [NSString stringWithFormat:@"%@%d.jpg",dateT,loop];
            NSString *fileName = [doc stringByAppendingPathComponent:file];
            NSData *imgData = UIImageJPEGRepresentation(item.InnerPhoto.image, 0.4);
            
            [self.photoes addObject:imgData];
            
            [imgData writeToFile:fileName atomically:YES];
            [picsCollection addObject:file];
            loop++;
        }
    }
    //set up sqlite
    sqlite3 *lib;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"privateForcomments.sqlite"];
    
    const char *cFile = fileName.UTF8String;
    int result = sqlite3_open(cFile, &lib);
    if (result == SQLITE_OK) {
        const char *sql = "create table if not exists comments_test9 (pid integer primary key autoincrement, title text, content text, servicecmt integer, tastecmt integer, satisfycmt integer, latitude double, longitude double, isimage boolean, datevalue varchar(50));";
        char *error = Nil;
        result = sqlite3_exec(lib, sql, Nil, Nil, &error);
        if (result == SQLITE_OK) {
            int index;
            if (self.innerViews.count > 0) {
                index = 1;
            }else{
                index = 0;
            }
            NSString *titleText = [self.titleTextView.text stringByReplacingOccurrencesOfString:@"'" withString:@"@"];
            NSString *contentText = [self.content stringByReplacingOccurrencesOfString:@"'" withString:@"@"];
            
            //set up date data
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateT = [formatter stringFromDate:[NSDate date]];
            
            
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO comments_test9(title, content, servicecmt, tastecmt, satisfycmt, latitude, longitude, isimage, datevalue) VALUES ('%@', '%@', %d, %d, %d, %f, %f, %d, '%@')",titleText,contentText, serviceP, tasteP, satisfyP, self.longitude, self.latitude, index, dateT];
            
            
            //save data to parse
            if (![self.publicSwitch isOn]) {
                PFObject *post = [[PFObject alloc]initWithClassName:@"posts"];
                post[@"name"] = [[PFUser currentUser] username];
                post[@"title"] = titleText;
                post[@"content"] = contentText;
                post[@"service"]= @(serviceP);
                post[@"taste"]= @(tasteP);
                post[@"comfortable"]= @(satisfyP);
                post[@"location"] = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
                post[@"postDate"] = dateT;
                post[@"isImage"] = [NSString stringWithFormat:@"%d",index];
                //PFObject *imgModal = [[PFObject alloc]initWithClassName:@"imgsForPost"];
                //__weak PFObject *weakPost = post;
                if (self.innerViews.count > 0) {
                    
                    for (int i = 0; i< self.photoes.count; i++) {
                        NSData *imgData = self.photoes[i];
                        NSString *name = picsCollection[i];
                        PFFile *file = [PFFile fileWithName:name data:imgData];
                        [self.pfiles addObject:file];

                    }
                }

                __weak typeof(self) weakSelf = self;
                
                [post saveEventually:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        for (int i =0; i<weakSelf.pfiles.count; i++) {
                            PFObject *img = [[PFObject alloc]initWithClassName:@"imgsForPost"];
                            img[@"postObId"] = post.objectId;
                            img[@"image"] = weakSelf.pfiles[i];
                            [img saveInBackground];
                            
                        }
                        
                    }
                }];
                
                
            }
  
            
            char *error = Nil;
            result = sqlite3_exec(lib, insert.UTF8String, Nil, Nil, &error);
            if (result == SQLITE_OK) {

               long long ID = sqlite3_last_insert_rowid(lib);
                int newID = (int)ID;
                
                
                const char *sql = "create table if not exists comments_photo_test5 (pid integer primary key autoincrement, comment_id integer, image blob);";
                char *error1 = Nil;
                result = sqlite3_exec(lib, sql, Nil, Nil, &error1);
                if (result == SQLITE_OK) {
                
                    self.titleTextView.text = @"";
                    tmpS.firstBtn.selected = false;
                    tmpS.secondBtn.selected = false;
                    tmpS.thirdBtn.selected = false;
                    tmpS.scores = 0;
                    tasteS.firstBtn.selected = false;
                    tasteS.secondBtn.selected = false;
                    tasteS.thirdBtn.selected = false;
                    tasteS.scores = 0;
                    satisfyS.firstBtn.selected = false;
                    satisfyS.secondBtn.selected = false;
                    satisfyS.thirdBtn.selected = false;
                    satisfyS.scores = 0;
                    self.postViewController.textContent.text = @"";
                    self.content = nil;
                    
                    
                    if (self.innerViews.count > 0) {
                         insert = @"INSERT INTO comments_photo_test5(comment_id, image) VALUES";
                        
                        for (int i =0; i < picsCollection.count; i++) {
                            if (i == 0) {
                                NSString *data = [NSString stringWithFormat:@" (%d, '%@')",newID,picsCollection[i]];
                                insert = [insert stringByAppendingString:data];
                            }else{
                                NSString *data1 = [NSString stringWithFormat:@",(%d, '%@')",newID,picsCollection[i]];
                                insert = [insert stringByAppendingString:data1];
                            }
                            
                        }
                        insert =[insert stringByAppendingString:@";"];
                            char *error = Nil;
                            result = sqlite3_exec(lib, insert.UTF8String, Nil, Nil, &error);
                            if (result == SQLITE_OK) {
                                //delete all photoes in scrollView
                                
                                for (ScrollViewInnerBtn *btn in self.innerViews) {
                                    [btn removeFromSuperview];
                                }
                                // 2.delete all pics in innerview
                                [self.innerViews removeAllObjects];
                                [self.photoes removeAllObjects];

                                [self.deleteBtn setTitle:@"删除图片" forState:UIControlStateNormal];
                                self.deleteBtn.enabled = NO;

                                
                            }else{
                                
                            }
                        
                    }

                }
 
            }
        }
        else if(result == SQLITE_ERROR){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"不能打开本地数据库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
@end
