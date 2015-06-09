//
//  DetailParseViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-06-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "DetailParseViewController.h"
#import "cmtData.h"
#import <Parse/Parse.h>
#import "cellForComment.h"
#import "usersData.h"
#import "AppDelegate.h"

@interface DetailParseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSMutableArray *userData;
@property(strong, nonatomic)NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;

@end

@implementation DetailParseViewController

-(NSMutableArray *)comments{
    if (_comments == nil) {
        _comments = [[NSMutableArray alloc]init];
    }
    return _comments;
}

-(NSMutableArray *)userData{
    
    if (_userData == nil) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _userData = delegate.parseUserArray;
    }
    return _userData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sushiBlur"]];
    self.ContentTextView.editable = NO;
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTableView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    PFQuery *query = [[PFQuery alloc]initWithClassName:@"commentsForPost"];
    [query whereKey:@"postObId" containsString:self.postId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            
            for (PFObject *obj in objects) {
                cmtData *data = [[cmtData alloc]init];
                data.content = obj[@"content"];
                data.username = obj[@"username"];
                data.date = obj.createdAt;
                [self.comments addObject:data];
            }
            __weak typeof(self) weakSelf = self;
            dispatch_queue_t q = dispatch_get_main_queue();
            dispatch_async(q, ^{
                [weakSelf.commentTableView reloadData];

            });
        }
    }];
    
    self.profileImg.image = [self getProfileImg:[PFUser currentUser].username];
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2;
    self.profileImg.clipsToBounds = YES;
//    self.profileImg.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.profileImg.layer.borderWidth = 1.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftNav {
    NSLog(@"aa");
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


- (IBAction)rightNav {
    
//    MapViewController *map = [[MapViewController alloc]init];
//    self.mapViewController = map;
//    
//    map.title = self.TitleBar.title;
//    map.latitude =self.latitude;
//    map.longitude = self.longitude;
//    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    map.view.frame = CGRectMake(width, 0, width, height);
//    UIView *view = [[UIView alloc]init];
//    view.frame = CGRectMake(0, 0, width, height);
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:map.view];
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
//    
//    __weak UIView *bgView = view;
//    __weak MapViewController *bMap = map;
//    [UIView animateWithDuration:0.75 animations:^{
//        map.view.frame = CGRectMake(0, 0, width, height);
//    } completion:^(BOOL finished) {
//        [bgView removeFromSuperview];
//        [bMap setGeolocation];
//    }];
    
    
    
}

#pragma tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cmtData *data = self.comments[indexPath.row];
    cellForComment *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cellForComment" owner:nil options:nil] lastObject];
    }
    cell.profileImg.image = [self getProfileImg:data.username];
    cell.content.text = data.content;
    cell.author.text = data.username;
    NSDate *date1 = data.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];

    cell.timeline.text = [dateFormatter stringFromDate:date1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.commentTF resignFirstResponder];
}

#pragma keyboard respond
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        
        self.textViewConstant.constant = keyboardH;
        self.ImageViewHeight.constant = 0;
        
    }];
}
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.textViewConstant.constant = 0;
        self.ImageViewHeight.constant = 140;
        
    }];
}

//find profile image from global variables
-(UIImage *)getProfileImg:(NSString *)username{
    
    for (usersData *user in self.userData) {
        if ([user.username isEqualToString:username]) {
            return user.profileImg;
        }
    }
    return nil;
    
}
#pragma inner retrieve data from parse.com
-(void)getDataFromParse{
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"commentsForPost"];
    [query whereKey:@"postObId" containsString:self.postId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            
            for (PFObject *obj in objects) {
                cmtData *data = [[cmtData alloc]init];
                data.content = obj[@"content"];
                data.username = obj[@"username"];
                data.date = obj.createdAt;
                [self.comments addObject:data];
            }
            __weak typeof(self) weakSelf = self;
            dispatch_queue_t q = dispatch_get_main_queue();
            dispatch_async(q, ^{
                [weakSelf.commentTableView reloadData];
                
            });
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)send {
    
    PFObject *obj = [[PFObject alloc]initWithClassName:@"commentsForPost"];
    if (self.commentTF.text) {
        obj[@"content"] = self.commentTF.text;
        obj[@"username"]= [PFUser currentUser].username;
        obj[@"postObId"]= self.postId;
    }
    [self.commentTF resignFirstResponder];
    NSError *error = nil;
    if ([obj save:&error]) {
        PFQuery *obj = [[PFQuery alloc]initWithClassName:@"posts"];
        [obj whereKey:@"objectId" containsString:self.postId];
        [obj findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *obj in objects) {
                NSNumber *num = obj[@"comments"];
                int numNew = num.intValue +1;
                obj[@"comments"] = [NSNumber numberWithInt:numNew];
                dispatch_queue_t q = dispatch_get_main_queue();
                dispatch_async(q, ^{
                    [obj saveInBackground];
                    
                });
            }
        }];
        
        
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"成功" message:@"成功发布评论" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        self.commentTF.text = nil;
        [self getDataFromParse];
    }else{
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];

    }
}
@end
