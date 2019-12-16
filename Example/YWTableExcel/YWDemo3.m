//
//  YWDemo3.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/13.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWDemo3.h"
#import <YWTableExcel/YWTableExcelView.h>

@interface YWDemo3 ()<YWTableExcelViewDataSource,YWTableExcelViewDelegate>
@property (nonatomic, strong) YWTableExcelView *excelView;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *fixedColumnList;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *slideColumnList;
@property (nonatomic, strong) NSMutableArray  *fixedList;
@property (nonatomic, strong) NSMutableArray  *slideList;
@end

@implementation YWDemo3

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
    mode.sectionStyle = YWTableExcelViewSectionStyleGrouped;
    _excelView = [[YWTableExcelView alloc] initWithFrame:CGRectZero withMode:mode];
    _excelView.delegate = self;
    _excelView.dataSource = self;
    _excelView.addHorizontalDivider = YES;
    _excelView.dividerColor = [UIColor redColor];
    [self.view addSubview:_excelView];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"各个科目";
    _excelView.tableHeaderView = titleLabel;
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    footLabel.textColor = [UIColor redColor];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.text = @"表一";
    _excelView.tableFooterView = footLabel;
    
    _excelView.outsideBorderWidth = 1;
    _excelView.outsideBorder = [UIColor redColor];
    
    [_excelView addConstraint:NSLayoutAttributeLeft equalTo:self.view offset:10];
    [_excelView addConstraint:NSLayoutAttributeTop equalTo:self.view offset:80];
    [_excelView addConstraint:NSLayoutAttributeRight equalTo:self.view offset:-10];
    [_excelView addConstraint:NSLayoutAttributeBottom equalTo:self.view offset:-40];

}
- (NSInteger)numberOfSectionsInTableExcelView:(YWTableExcelView *)excelView{
    return 2;
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForFixedHeaderInSection:(NSInteger)section{
    return _fixedColumnList;
}
-(NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForSlideHeaderInSection:(NSInteger)section{
    return _slideColumnList;
}
- (NSInteger)tableExcelView:(YWTableExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView fixedCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _fixedList[indexPath.row];
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView slideCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _slideList[indexPath.row];
}
- (YWTableExcelViewHeaderInSectionMode)tableExcelView:(YWTableExcelView *)excelView modeForHeaderInSection:(NSInteger)section{
    return YWTableExcelViewHeaderInSectionModeCustom;
}
- (UIView *)tableExcelView:(YWTableExcelView *)excelView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionView = [UILabel new];
    sectionView.text = [NSString stringWithFormat:@" 学校五年%zi班成绩",section];
    sectionView.backgroundColor = [UIColor whiteColor];
    return sectionView;
}
- (CGFloat)tableExcelView:(YWTableExcelView *)excelView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
