//
//  NavShareComTVC.m
//  PetDairy
//
//  Created by Tommy on 2015-05-23.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <Parse/Parse.h>
#import "NavShareComTVC.h"
#import "postData.h"
#import "cellForPost.h"
#import "AppDelegate.h"
#import "usersData.h"

@interface NavShareComTVC ()<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic)NSMutableArray *followings;
@property(strong, nonatomic)NSMutableArray *postData;
@property(strong, nonatomic)NSMutableArray *usersData;
@end

@implementation NavShareComTVC

-(NSMutableArray *)followings{
    if (_followings == nil) {
        _followings = [[NSMutableArray alloc]init];
    }
    return _followings;
}
-(NSMutableArray *)postData{
    if (_postData == nil) {
        _postData = [[NSMutableArray alloc]init];
    }
    return _postData;
}

-(NSMutableArray *)usersData{
    
    if (_usersData == nil) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _usersData = delegate.parseUserArray;
    }
    return _usersData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshData{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    spinner.center = self.tableView.center;
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"followers"];
    NSString *name =[PFUser currentUser].username;
    [query whereKey:@"follower" equalTo:name];
    
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *pfuser in objects) {
                NSString *name = pfuser[@"following"];
                [weakSelf.followings addObject:name];

            }
            
            PFQuery *query = [[PFQuery alloc]initWithClassName:@"posts"];
            [query whereKey:@"username" containedIn:self.followings];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (!error) {
                    for (PFObject *obj in objects) {
                        postData *data = [[postData alloc]init];
                        data.username = obj[@"username"];
                        data.objectId = obj[@"objectId"];
                        data.content = obj[@"content"];
                        data.title = obj[@"title"];
                        NSString *isImg = obj[@"isImage"];
                        data.isImage = isImg.intValue;
                        NSString *serviceC = obj[@"service"];
                        data.servicecmt = serviceC.intValue;
                        NSString *tasteP = obj[@"taste"];
                        data.tastecmt = tasteP.intValue;
                        NSString *satisC = obj[@"comfortable"];
                        data.satisfycmt = satisC.intValue;
                        data.postDate = obj[@"postDate"];
                        data.location = obj[@"location"];
                        [weakSelf.postData addObject:data];
                    }
                    
                    dispatch_queue_t q = dispatch_get_main_queue();
                    dispatch_async(q, ^{
                        [weakSelf.tableView reloadData];
                        [weakSelf styleVisibleCells];
                       
                        [spinner stopAnimating];
                        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
                    });
                }
 

            }];
            

            
        }
        
    }];

    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.postData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    postData *data = self.postData[indexPath.row];
    cellForPost *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForPost"];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cellForPost" owner:nil options:nil] lastObject];
    }
    
    
    cell.TitleTint.text = data.title;
    cell.timeTint.text = data.postDate;
//    if (!data.location) {
//        cell.mapIndicator.userInteractionEnabled = YES;
//    }else{
//        cell.mapIndicator.userInteractionEnabled = NO;
//    }
    cell.profileImg.image = [self getProfileImg:data.username];
    cell.tasteS.text = [self convertCommentP:data.tastecmt title:@"味道："];
    cell.serviceS.text = [self convertCommentP:data.servicecmt title:@"服务："];
    cell.satisfyS.text = [self convertCommentP:data.satisfycmt title:@"环境："];
    cell.commentLabel.text = [NSString stringWithFormat:@"评论数：%d", data.comments];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//find profile image from global variables
-(UIImage *)getProfileImg:(NSString *)username{
    
    for (usersData *user in self.usersData) {
        if ([user.username isEqualToString:username]) {
            return user.profileImg;
        }
    }
    return nil;
    
}
//inner method to judge comment points
-(NSString *)convertCommentP:(int)p title:(NSString *)title{
    if (p == 1) {
        
        return [title stringByAppendingString:@"很差"];
        
    }else if(p == 2){
        return [title stringByAppendingString:@"一般"];
    }else{
        return [title stringByAppendingString:@"满意"];
    }
}
//inner method set the visible cells style
-(void)styleVisibleCells{
    NSArray *indexes = [self.tableView visibleCells];
    for (int i =0; i < indexes.count; i++) {
        if (i == 0) {
            cellForPost *indexC = indexes[i];
            indexC.indicator.image = [UIImage imageNamed:@"promoboard_icon_mall"];
            indexC.indicator.backgroundColor = [UIColor whiteColor];
        }else{
            cellForPost *item = indexes[i];
            item.indicator.image = [UIImage imageNamed:@"default_indicator"];
            item.indicator.backgroundColor = [UIColor clearColor];
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self styleVisibleCells];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
