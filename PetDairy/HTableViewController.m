//
//  HTableViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "HTableViewController.h"
#import "HCmtDataModal.h"
#import "HTableViewCell.h"
#import "cellWithPics.h"
#import "DetailViewController.h"
#import "DeTailImgView.h"
#import "UIView+Extension.h"

@interface HTableViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic)NSMutableArray *dataItems;
@property(strong, nonatomic)DetailViewController *popUpController;
@property(weak, nonatomic)DeTailImgView *selectedImg;
@end

@implementation HTableViewController
-(NSMutableArray *)dataItems{
    if (_dataItems == Nil) {
        _dataItems = [[NSMutableArray alloc]init];
    }
    return _dataItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sidebar_bg@2x.jpg"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}



-(void)refreshData{
    [self.dataItems removeAllObjects];
    sqlite3 *lib;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"privateForcomments.sqlite"];
    sqlite3_stmt *stmt = NULL;
    const char *cFile = fileName.UTF8String;
    int result = sqlite3_open(cFile, &lib);
    if (result == SQLITE_OK) {
 
        const char *sql = "select * from comments_test9";
        if (sqlite3_prepare_v2(lib, sql, -1, &stmt, NULL)== SQLITE_OK) {
            while (sqlite3_step(stmt)== SQLITE_ROW) {

                HCmtDataModal *item = [[HCmtDataModal alloc]init];
                item.idComent = sqlite3_column_int(stmt, 0);
                const char *titleT =sqlite3_column_blob(stmt, 1);
                if (titleT) {
                    NSString *titleText = [[NSString alloc]initWithUTF8String:titleT];
                    
                    item.title = titleText;
                }
                
                const char *cContent = sqlite3_column_blob(stmt, 2);
                if (cContent) {
                    item.content = [[NSString alloc]initWithUTF8String:cContent];
                }
                
                
                item.servicecmt = sqlite3_column_int(stmt, 3);
                item.tastecmt = sqlite3_column_int(stmt, 4);
                item.satisfycmt = sqlite3_column_int(stmt, 5);
                item.latitude = [[[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 6)] doubleValue];
                item.longitude = [[[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 7)] doubleValue];
                item.isImage = sqlite3_column_int(stmt, 8);
                
                item.datevalue = [[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 9)];
                

                [self.dataItems addObject:item];
                if (item.isImage == 1) {

                    sqlite3_stmt *stmt1 = NULL;
                    
                    NSString *sql1 = [NSString stringWithFormat:@"select image from comments_photo_test5 where comment_id = %d;", item.idComent];
                    if (sqlite3_prepare_v2(lib, sql1.UTF8String, -1, &stmt1, NULL)== SQLITE_OK) {

                        while (sqlite3_step(stmt1)== SQLITE_ROW) {
                        
                           NSString *imgdata = [[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt1, 0)];
                            NSString *getFile = [doc stringByAppendingPathComponent:imgdata];

                            UIImage *img = [UIImage imageWithContentsOfFile:getFile];
                            if (img) {
                                [item.imgCollections addObject:img];
                            }
                            

                        }
                    }
 
                }
                

            }
        }
        
    }
    

    
    [self.tableView reloadData];

    [self styleVisibleCells];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCmtDataModal *item = self.dataItems[indexPath.row];
    
    
        
        cellWithPics *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithPics"];
        if (cell == nil) {
            // 从xib中加载cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cellWithPics" owner:nil options:nil] lastObject];
        }
        cell.timeTint.text = [NSString stringWithFormat:@"%@", item.datevalue];
        cell.TitleTint.text = [[item.title stringByReplacingOccurrencesOfString:@"@" withString:@"'"] uppercaseString];
        cell.serviceS.text = [self convertCommentP:item.servicecmt title:@"服务："];
        cell.tasteS.text = [self convertCommentP:item.tastecmt title:@"味道："];
        cell.satisfyS.text = [self convertCommentP:item.satisfycmt title:@"环境："];
        cell.indicator.image = [UIImage imageNamed:@"default_indicator"];
        
        cell.content.text = item.content;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    
        
//        HTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellNormal"];
//        if (cell == nil) {
//            // 从xib中加载cell
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"cellNormal" owner:nil options:nil] lastObject];
//        }
//        cell.timeTint.text = [NSString stringWithFormat:@"%@", item.datevalue];
//        cell.TitleTint.text = [[item.title stringByReplacingOccurrencesOfString:@"@" withString:@"'"] uppercaseString];
//        cell.serviceS.text = [self convertCommentP:item.servicecmt title:@"服务："];
//        cell.tasteS.text = [self convertCommentP:item.tastecmt title:@"味道："];
//        cell.satisfyS.text = [self convertCommentP:item.satisfycmt title:@"环境："];
//        cell.indicator.image = [UIImage imageNamed:@"default_indicator"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;

        
   

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
        if (i == 2) {
            HTableViewCell *indexC = indexes[i];
            indexC.indicator.image = [UIImage imageNamed:@"promoboard_icon_mall"];
            indexC.indicator.backgroundColor = [UIColor whiteColor];
        }else{
            HTableViewCell *item = indexes[i];
            item.indicator.image = [UIImage imageNamed:@"default_indicator"];
            item.indicator.backgroundColor = [UIColor clearColor];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCmtDataModal *item = self.dataItems[indexPath.row];
    
    return 110.0;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self styleVisibleCells];
    
}

#pragma delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailCon = [[DetailViewController alloc]init];
    self.popUpController = detailCon;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    detailCon.view.frame = CGRectMake(0, height, width, height);
    HCmtDataModal *item = self.dataItems[indexPath.row];
    


    detailCon.TitleBar.title = [[item.title stringByReplacingOccurrencesOfString:@"@" withString:@"'"] uppercaseString];
    detailCon.leftCommentLabel.text = [self convertCommentP:item.servicecmt title:@"服务："];
    detailCon.MCommentLabel.text = [self convertCommentP:item.tastecmt title:@"味道："];
    detailCon.RCommentLabel.text = [self convertCommentP:item.satisfycmt title:@"环境："];
    detailCon.ContentTextView.text = item.content;
    //check geolocation available
    if (item.latitude && item.longitude) {
        detailCon.geoIndicator.enabled = NO;
    }else{
        detailCon.latitude = item.latitude;
        detailCon.longitude = item.longitude;
    }
//    }else if (item.latitude == 0.0){
//        detailCon.geoIndicator.enabled = NO;
//    }
    //parse imgs to pop up view
    if (item.isImage == 1) {
        for (UIImage *pic in item.imgCollections) {
            DeTailImgView *picView = [[DeTailImgView alloc]initWithImage:pic];
            // create and configure the tap gesture
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabEvent:)];
            tapRecognizer.delegate =self;
            [picView addGestureRecognizer:tapRecognizer];
            picView.userInteractionEnabled = YES;
            [detailCon.picsScrollView addSubview:picView];
        }
    }

    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, width, height);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:detailCon.view];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];

    __weak UIView *bgView = view;
    [UIView animateWithDuration:0.75 animations:^{
        detailCon.view.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];

}
- (void)tabEvent:(UITapGestureRecognizer *)tapRecognizer
{
    self.selectedImg = (DeTailImgView *)tapRecognizer.view;
    //create a cover
    UIView *cover = [[UIView alloc]init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor lightGrayColor];
    cover.userInteractionEnabled = YES;
    
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOver:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    UIImageView *displayImgView = [[UIImageView alloc]init];
    displayImgView.image = self.selectedImg.image;
    displayImgView.contentMode = UIViewContentModeScaleAspectFill;
    displayImgView.frame = self.selectedImg.frame;
    [cover addSubview:displayImgView];
    [cover convertRect:displayImgView.frame fromView:self.selectedImg];
    displayImgView.y += [[self.selectedImg superview] superview].y;
    
    [UIView animateWithDuration:0.25 animations:^{
        displayImgView.frame = CGRectMake(0, cover.height*0.2, cover.width, cover.height*0.6);
    }];
    
    
    
    
    
    
}
-(void)tapOver:(UITapGestureRecognizer *)tapRecognizer{
    
    UIView *cover = tapRecognizer.view;
    UIImageView *temp = [cover.subviews lastObject];

    [UIView animateWithDuration:0.25 animations:^{
        temp.frame = self.selectedImg.frame;
        temp.y += [[self.selectedImg superview] superview].y;
    } completion:^(BOOL finished) {
        [tapRecognizer.view removeFromSuperview];
        self.selectedImg = nil;
    }];
    
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
