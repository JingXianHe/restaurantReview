//
//  DetailViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "DetailViewController.h"
#import "MapViewController.h"
#import "UIView+Alert.h"

@interface DetailViewController ()
@property(strong, nonatomic)MapViewController *mapViewController;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ContentTextView.editable = NO;
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
    if ([self checkInternetConnection]==false) {
        [UIView alertWith:@"错误" message:@"互联网不可用，不能使用地图功能！"];
        return;
    }
    MapViewController *map = [[MapViewController alloc]init];
    self.mapViewController = map;
    
    map.title = self.TitleBar.title;
    map.latitude =self.latitude;
    map.longitude = self.longitude;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    map.view.frame = CGRectMake(width, 0, width, height);
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, width, height);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:map.view];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
    
    __weak UIView *bgView = view;
    __weak MapViewController *bMap = map;
    [UIView animateWithDuration:0.75 animations:^{
        map.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [bMap setGeolocation];
    }];

    
}
-(BOOL)checkInternetConnection{

    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.baidu.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        return true;
    else
        return false;
}

@end
