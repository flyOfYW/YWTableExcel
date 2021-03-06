//
//  YWDemo4.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2020/11/23.
//  Copyright © 2020 flyOfYW. All rights reserved.
//

#import "YWDemo4.h"
#import <YWTableExcel/YWTableExcelView.h>
#import "YWCusCell.h"

@interface YWDemo4 ()<YWTableExcelViewDataSource,YWTableExcelViewDelegate>
@property (nonatomic, strong) YWTableExcelView *excelView;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *fixedColumnList;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *slideColumnList;
@property (nonatomic, strong) NSMutableArray  *fixedList;
@property (nonatomic, strong) NSMutableArray  *slideList;
@end

@implementation YWDemo4

- (void)viewDidLoad{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view, typically from a nib.
    NSArray *arr = @[@"固定1",@"固定2"];
    _fixedColumnList = [NSMutableArray new];
    for (NSString *ts in arr) {
        YWColumnMode *model1 = [YWColumnMode new];
        model1.text = ts;
        model1.width = 60;
        [self.fixedColumnList addObject:model1];
    }
    
    NSArray *arr1 = @[@"语文",@"数学",@"物理",@"化学",@"生物",@"英语",@"政治"];
    _slideColumnList = [NSMutableArray new];
    for (NSString *ts in arr1) {
        YWColumnMode *model1 = [YWColumnMode new];
        model1.text = ts;
        model1.width = 100;
        [self.slideColumnList addObject:model1];
    }
    _fixedList = @[].mutableCopy;
    for (int j = 0; j < 20; j ++) {
        NSMutableArray *cloumnList = @[].mutableCopy;
        for (int i = 0; i < 2; i ++) {
            YWColumnMode *model1 = [YWColumnMode new];
            model1.text = [NSString stringWithFormat:@"%d行%d列",j,i];
            model1.selectedBackgroundColor = [UIColor redColor];
            [cloumnList addObject:model1];
        }
        [_fixedList addObject:cloumnList];
    }
    
    _slideList = @[].mutableCopy;
    for (int j = 0; j < 20; j ++) {
        NSMutableArray *cloumnList = @[].mutableCopy;
        for (int i = 2; i < 9; i ++) {
            YWColumnMode *model1 = [YWColumnMode new];
            model1.text = [NSString stringWithFormat:@"%d行%d列",j,i];
            model1.selectedBackgroundColor = [UIColor redColor];
            [cloumnList addObject:model1];
        }
        [_slideList addObject:cloumnList];
    }
    
    
    YWTableExcelViewMode *mode = [YWTableExcelViewMode new];
    mode.columnStyle = YWTableExcelViewLineStyleText;
    mode.lineColor = [UIColor redColor];
    
    _excelView = [[YWTableExcelView alloc] initWithFrame:CGRectZero withMode:mode];
    _excelView.delegate = self;
    _excelView.dataSource = self;
    _excelView.addverticalDivider = YES;
    _excelView.addHorizontalDivider = YES;
    _excelView.dividerColor = [UIColor redColor];
    _excelView.layer.borderWidth = 1;
    [_excelView registerClass:[YWCusCell class]];
    [self.view addSubview:_excelView];
            
    [_excelView addConstraint:NSLayoutAttributeLeft equalTo:self.view offset:10];
    [_excelView addConstraint:NSLayoutAttributeTop equalTo:self.view offset:100];
    [_excelView addConstraint:NSLayoutAttributeRight equalTo:self.view offset:-10];
    [_excelView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:300];

    //默认选中第一行
    [_excelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForFixedHeaderInSection:(NSInteger)section{
    return _fixedColumnList;
}
-(NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForSlideHeaderInSection:(NSInteger)section{
    return _slideColumnList;
}
- (NSInteger)tableExcelView:(YWTableExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView fixedCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _fixedList[indexPath.row];
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView slideCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _slideList[indexPath.row];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
