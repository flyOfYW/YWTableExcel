//
//  YWDemo1.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/13.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWDemo1.h"
#import <YWTableExcel/YWTableExcelView.h>

@interface YWDemo1 ()<YWTableExcelViewDataSource,YWTableExcelViewDelegate>
@property (nonatomic, strong) YWTableExcelView *excelView;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *fixedColumnList;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *slideColumnList;
@property (nonatomic, strong) NSMutableArray  *fixedList;
@property (nonatomic, strong) NSMutableArray  *slideList;
@end

@implementation YWDemo1

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
            [cloumnList addObject:model1];
        }
        [_slideList addObject:cloumnList];
    }
    
    
    YWTableExcelViewMode *mode = [YWTableExcelViewMode new];
    mode.columnStyle = YWTableExcelViewColumnStyleText;
    _excelView = [[YWTableExcelView alloc] initWithFrame:CGRectZero withMode:mode];
    _excelView.delegate = self;
    _excelView.dataSource = self;
    _excelView.addverticalDivider = YES;
    _excelView.addHorizontalDivider = YES;
    _excelView.layer.borderWidth = 1;
    [self.view addSubview:_excelView];
    
    [_excelView addConstraint:NSLayoutAttributeLeft equalTo:self.view offset:10];
    [_excelView addConstraint:NSLayoutAttributeTop equalTo:self.view offset:80];
    [_excelView addConstraint:NSLayoutAttributeRight equalTo:self.view offset:-10];
    [_excelView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:240];


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
