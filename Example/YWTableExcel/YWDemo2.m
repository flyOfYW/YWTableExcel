//
//  YWDemo2.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/13.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWDemo2.h"
#import <YWTableExcel/YWTableExcelView.h>

@interface YWDemo2 ()<YWTableExcelViewDataSource,YWTableExcelViewDelegate>
@property (nonatomic, strong) YWTableExcelView *excelView;
@property (nonatomic, strong) NSMutableArray <YWColumnMode *> *slideColumnList;
@property (nonatomic, strong) NSMutableArray  *slideList;
@end

@implementation YWDemo2

- (void)viewDidLoad{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];


    
    NSArray *arr1 = @[@"语文",@"数学",@"物理",@"化学",@"生物",@"英语",@"政治"];
    _slideColumnList = [NSMutableArray new];
    for (NSString *ts in arr1) {
        YWColumnMode *model1 = [YWColumnMode new];
        model1.text = ts;
        model1.width = 100;
        [self.slideColumnList addObject:model1];
    }

    _slideList = @[].mutableCopy;
    for (int j = 0; j < 20; j ++) {
        NSMutableArray *cloumnList = @[].mutableCopy;
        for (int i = 0; i < 7; i ++) {
            YWColumnMode *model1 = [YWColumnMode new];
            model1.text = [NSString stringWithFormat:@"%d行%d列",j,i];
            [cloumnList addObject:model1];
        }
        [_slideList addObject:cloumnList];
    }
    
    
    YWTableExcelViewMode *mode = [YWTableExcelViewMode new];
    mode.columnStyle = YWTableExcelViewColumnStyleBtn;
    mode.style = YWTableExcelViewStylePlain;
    
    _excelView = [[YWTableExcelView alloc] initWithFrame:CGRectMake(10, 80, CGRectGetWidth(self.view.frame) - 20, 200) withMode:mode];
    _excelView.delegate = self;
    _excelView.dataSource = self;
    _excelView.layer.borderWidth = 1;
    [self.view addSubview:_excelView];
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForFixedHeaderInSection:(NSInteger)section{
    return @[];
}
-(NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForSlideHeaderInSection:(NSInteger)section{
    return _slideColumnList;
}
- (NSInteger)tableExcelView:(YWTableExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView fixedCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView slideCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _slideList[indexPath.row];
}
- (void)tableExcelView:(YWTableExcelView *)tableView didSelectColumnAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%zi组第%zi行第%zi列",indexPath.section,indexPath.row,indexPath.colunmn);
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
