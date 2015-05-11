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
#import "Header.h"
#import "LeftMenu.h"
#import "RightMenuController.h"
#import <Parse/Parse.h>

#define HMNavShowAnimDuration 0.25
#define HMCoverTag 100


// 是否为4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height >= 568.0)



@interface MainController ()<LeftMenuDelegate>
/**
 *  正在显示的导航控制器
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) UINavigationController *showingNavigationController;
@property(nonatomic, assign)int LeftMenuW;
@property(nonatomic, assign)int LeftMenuH;
@property(nonatomic, assign)int LeftMenuY;
@property(nonatomic, assign)int RightMenuX;
@property (nonatomic, strong) RightMenuController *rightMenuVc;
@property (nonatomic, weak) LeftMenu *leftMenu;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.imageView.bounds;
    [self.imageView addSubview:visualEffectView];
    if (FourInch) {
        self.LeftMenuW = 150;
        self.LeftMenuH = 400;
        self.LeftMenuY = 90;
        self.RightMenuX = 40;
    }else{
        self.LeftMenuW = 150;
        self.LeftMenuH = 300;
        self.LeftMenuY = 50;
        self.RightMenuX = 30;
    }
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
    RightMenuController *profile = [[RightMenuController alloc] init];
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
    vc.view.backgroundColor = [UIColor whiteColor];
    
    // 2.设置标题
    TitleButton *titleView = [[TitleButton alloc] init];
    titleView.title = title;
    vc.navigationItem.titleView = titleView;
    
    // 3.设置左右按钮
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"top_navigation_menuicon" target:self action:@selector(leftMenuClick)];
    vc.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"top_navigation_infoicon" target:self action:@selector(rightMenuClick)];
    
    // 4.包装一个导航控制器
    ProfileController *nav = [[ProfileController alloc] initWithRootViewController:vc];
    // 让newsNav成为self（MainViewController）的子控制器，能保证：self在，newsNav就在
    // 如果两个控制器互为父子关系，那么它们的view也应该互为父子关系
    [self addChildViewController:nav];
}

#pragma mark - 监听导航栏按钮点击
- (void)leftMenuClick
{
    self.leftMenu.hidden = NO;
    self.rightMenuVc.view.hidden = YES;
    
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        // 取出正在显示的导航控制器的view
        UIView *showingView = self.showingNavigationController.view;
        
        // 缩放比例
        CGFloat navH = [UIScreen mainScreen].bounds.size.height - 2 * self.LeftMenuY;
        CGFloat scale = navH / [UIScreen mainScreen].bounds.size.height;
        
        // 菜单左边的间距
        CGFloat leftMenuMargin = [UIScreen mainScreen].bounds.size.width * (1 - scale) * 0.5;
        CGFloat translateX = self.LeftMenuW - leftMenuMargin;
        
        CGFloat topMargin = [UIScreen mainScreen].bounds.size.height * (1 - scale) * 0.5;
        CGFloat translateY = self.LeftMenuY - topMargin;
        
        // 缩放
        CGAffineTransform scaleForm = CGAffineTransformMakeScale(scale, scale);
        // 平移
        CGAffineTransform translateForm = CGAffineTransformTranslate(scaleForm, translateX / scale, translateY / scale);
        
        showingView.transform = translateForm;
        
        // 添加一个遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.tag = HMCoverTag;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = showingView.bounds;
        [showingView addSubview:cover];
    }];
}
- (void)rightMenuClick
{
    self.leftMenu.hidden = YES;
    self.rightMenuVc.view.hidden = NO;
    
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        // 取出正在显示的导航控制器的view
        UIView *showingView = self.showingNavigationController.view;
        
        // 缩放比例
        CGFloat navH = [UIScreen mainScreen].bounds.size.height - 2 * self.LeftMenuY;
        CGFloat scale = navH / [UIScreen mainScreen].bounds.size.height;
        
        // 菜单左边的间距
        CGFloat leftMenuMargin = [UIScreen mainScreen].bounds.size.width * (1 - scale) * 0.5;
        CGFloat translateX = leftMenuMargin - self.rightMenuVc.view.width;
        
        CGFloat topMargin = [UIScreen mainScreen].bounds.size.height * (1 - scale) * 0.5;
        CGFloat translateY = self.LeftMenuY - topMargin;
        
        // 缩放
        CGAffineTransform scaleForm = CGAffineTransformMakeScale(1, 1);
        // 平移
        CGAffineTransform translateForm = CGAffineTransformTranslate(scaleForm, self.RightMenuX - self.view.width, 0);
        
        showingView.transform = translateForm;
        
        // 添加一个遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.tag = HMCoverTag;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = showingView.bounds;
        [showingView addSubview:cover];
    } completion:^(BOOL finished) {
        [self.rightMenuVc didShow];
    }];
}

/**
 *  添加左菜单
 */
- (void)setupLeftMenu
{
    LeftMenu *leftMenu = [[LeftMenu alloc] init];
    leftMenu.delegate = self;
    leftMenu.height = self.LeftMenuH;
    leftMenu.width = self.LeftMenuW;
    leftMenu.y = self.LeftMenuY;
    [self.view insertSubview:leftMenu atIndex:1];
    self.leftMenu = leftMenu;
}

- (void)coverClick:(UIView *)cover
{
    [UIView animateWithDuration:HMNavShowAnimDuration animations:^{
        self.showingNavigationController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

/**
 *  添加右菜单
 */
- (void)setupRightMenu
{
    RightMenuController *rightMenuVc = [[RightMenuController alloc] init];
    rightMenuVc.view.x = self.RightMenuX;
    rightMenuVc.view.width = self.view.width - self.RightMenuX;
    rightMenuVc.view.height = self.view.height;
    rightMenuVc.xOffet = self.RightMenuX;
    [self.view insertSubview:rightMenuVc.view atIndex:1];
    self.rightMenuVc = rightMenuVc;
}

#pragma mark - HMLeftMenuDelegate
- (void)leftMenu:(LeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex
{
    // 0.移除旧控制器的view
    UINavigationController *oldNav = self.childViewControllers[fromIndex];
    [oldNav.view removeFromSuperview];
    
    // 1.显示新控制器的view
    UINavigationController *newNav = self.childViewControllers[toIndex];
    [self.view addSubview:newNav.view];
    
    // 2.设置新控制的transform跟旧控制器一样
    newNav.view.transform = oldNav.view.transform;
    // 设置阴影
    newNav.view.layer.shadowColor = [UIColor blackColor].CGColor;
    newNav.view.layer.shadowOffset = CGSizeMake(-3, 0);
    newNav.view.layer.shadowOpacity = 0.2;
    
    // 一个导航控制器的view第一次显示到它的父控件上时，如果transform的缩放值被改了，上面的20高度当时是不会出来
    
    // 2.设置当前正在显示的控制器
    self.showingNavigationController = newNav;
    
    // 3.点击遮盖
    [self coverClick:[newNav.view viewWithTag:HMCoverTag]];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
