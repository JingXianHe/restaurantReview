//
//  DetailParseViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-06-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "DetailParseViewController.h"
#import "cmtData.h"

@interface DetailParseViewController ()<UITableViewDataSource>
@property(strong, nonatomic)NSMutableArray *userData;
@property(strong, nonatomic)NSMutableArray *comments;

@end

@implementation DetailParseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"suShi.jpg"]];
    self.ContentTextView.editable = NO;
    self.commentTableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftNav {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.imageView.image = data.profileImg;
    cell.textLabel.text = data.content;
    cell.accessibilityLabel = data.username;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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
@end
