//
//  ViewController.m
//  LPAnimationCurve
//
//  Created by QFWangLP on 15/11/13.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "ViewController.h"
#import "LPPullToCurveFooter.h"
#import "LPPullToCurvcHeader.h"

static NSString *indentifire = @"cellIdentifire";
#define initialOffset 50.0
#define targetHeight 500.0

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UILabel *navTitle;
    UIView *bkView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentifire];
    [self.tableView layoutIfNeeded];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    bkView = [[UIView alloc] init];
    bkView.center = CGPointMake(self.view.center.x, 22);
    bkView.bounds = CGRectMake(0, 0, 300, 44);
    bkView.clipsToBounds = YES;
    [self.navigationController.navigationBar addSubview:bkView];
    
    navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 44+initialOffset, bkView.frame.size.width, 44)];
    navTitle.alpha = 0.0;
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor blackColor];
    navTitle.text = @"LeeFengHY";//@"LeeFengHY";
    [bkView addSubview:navTitle];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat transitionY = MIN(MAX(0, scrollView.contentOffset.y+64), 44+initialOffset+targetHeight);
    NSLog(@"transitionY is %f",transitionY);
    if (transitionY <= initialOffset) {
        navTitle.frame = CGRectMake(0, 44+initialOffset-transitionY,bkView.frame.size.width , 44);
    }else{
        
        CGFloat factor = MAX(0, MIN(1, (transitionY-initialOffset)/targetHeight));
        navTitle.frame = CGRectMake(0, 44-factor*44,bkView.frame.size.width , 44);
        navTitle.alpha = factor*factor*1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifire];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld条",(long)indexPath.row];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    LPPullToCurvcHeader *headerView = [[LPPullToCurvcHeader alloc] initWithAssociatedScrollView:self.tableView withNavigationBar:YES];
    
    __weak LPPullToCurvcHeader *weakHeaderView = headerView;
    //[headerView triggerPulling];
    
    [headerView addRefreshingBlock:^{
        //具体的操作
        //...2秒后自动停止刷新
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakHeaderView stopRefreshing];
            
        });
    }];
    
    LPPullToCurveFooter *footerView = [[LPPullToCurveFooter alloc] initWithAssociatedScrollView:self.tableView withNavigationBar:YES];
    
    __weak LPPullToCurveFooter *weakFooterView = footerView;
    
    [footerView addRefreshingBlock:^{
        //具体的操作
        //...
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakFooterView stopRefreshing];
            
        });
    }];
}
@end
