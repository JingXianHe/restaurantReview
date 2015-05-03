//
//  MainController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "MainController.h"
#import "ProfileController.h"
#import "HTableViewController.h"
#import "TitleButton.h"
#define HMNavShowAnimDuration 0.25
#define HMCoverTag 100
#define HMLeftMenuW 150
#define HMLeftMenuH 300
#define HMLeftMenuY 50

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.创建子控制器
    [self setupAllChildVcs];
    
    // 2.添加左菜单
    [self setupLeftMenu];
    
    // 3.添加右菜单
    [self setupRightMenu];
}

-(void)setupAllChildVcs{
    // 1.新闻控制器
    ProfileController *profile = [[ProfileController alloc] init];
    [self setupVc:profile title:@"新闻"];
}

/**
 *  初始化一个控制器
 *
 *  @param vc      需要初始化的控制器
 *  @param title   控制器的标题
 */
- (void)setupVc:(UIViewController *)vc title:(NSString *)title
{
    // 1.设置背景色
    vc.view.backgroundColor = [UIColor redColor];
    
    // 2.设置标题
    TitleButton *titleView = [[TitleButton alloc] init];
    titleView.title = title;
    vc.navigationItem.titleView = titleView;
    
    // 3.设置左右按钮
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"top_navigation_menuicon" target:self action:@selector(leftMenuClick)];
    vc.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"top_navigation_infoicon" target:self action:@selector(rightMenuClick)];
    
    // 4.包装一个导航控制器
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:vc];
    // 让newsNav成为self（HMMainViewController）的子控制器，能保证：self在，newsNav就在
    // 如果两个控制器互为父子关系，那么它们的view也应该互为父子关系
    [self addChildViewController:nav];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
