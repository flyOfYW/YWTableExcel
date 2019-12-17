# YWTableExcel

[![CI Status](https://img.shields.io/travis/flyOfYW/YWTableExcel.svg?style=flat)](https://travis-ci.org/flyOfYW/YWTableExcel)
[![Version](https://img.shields.io/cocoapods/v/YWTableExcel.svg?style=flat)](https://cocoapods.org/pods/YWTableExcel)
[![License](https://img.shields.io/cocoapods/l/YWTableExcel.svg?style=flat)](https://cocoapods.org/pods/YWTableExcel)
[![Platform](https://img.shields.io/cocoapods/p/YWTableExcel.svg?style=flat)](https://cocoapods.org/pods/YWTableExcel)

采用UITableView和UICollectionView嵌套使用来实现Excel、课程表、上下左右联动效果

简介
==============
- **1**: 纯文本显示
- **2**: 每一行支持选中
- **3**: 每一个单元格支持选中
- **4**: 支持分组
- **5**: 支持自定义表头和表尾
- **6**: 支持自定义组头
- **7**: 支持局部刷新


## 效果图

<img src="https://github.com/flyOfYW/YWTableExcel/blob/master/Example/YWTableExcel/image_re/WX20191217-134925%402x.png" width="400" height="343"><img src="https://github.com/flyOfYW/YWTableExcel/blob/master/Example/YWTableExcel/image_re/WX20191217-134944%402x.png" width="400" height="462">
<img src="https://github.com/flyOfYW/YWTableExcel/blob/master/Example/YWTableExcel/image_re/WX20191217-134959%402x.png" width="400" height="672">

## Example
```
- (void)viewDidLoad{
   YWTableExcelViewMode *mode = [YWTableExcelViewMode new];
    mode.columnStyle = YWTableExcelViewColumnStyleText;//不需要点击模式
    YWTableExcelView *excelView = [[YWTableExcelView alloc] initWithFrame:CGRectZero withMode:mode];
    excelView.delegate = self;
    excelView.dataSource = self;
    [self.view addSubview:_excelView];
}
///返回固定列表头的数据
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForFixedHeaderInSection:(NSInteger)section{
    return _fixedColumnList;
}
///返回可滑动列表头的数据
-(NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView titleForSlideHeaderInSection:(NSInteger)section{
    return _slideColumnList;
}
///行数
- (NSInteger)tableExcelView:(YWTableExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
///给每个单元格返回相应的数据model（固定列）
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView fixedCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _fixedList[indexPath.row];
}
///给每个单元格返回相应的数据model（可滑动列）
- (NSArray<YWColumnMode *> *)tableExcelView:(YWTableExcelView *)excelView slideCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _slideList[indexPath.row];
}
```

## Requirements

## Installation

YWTableExcel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

在Podfile中添加： source 'https://cdn.cocoapods.org/'

```ruby
pod 'YWTableExcel'
```

## Author

flyOfYW, 1498627884@qq.com

## License

YWTableExcel is available under the MIT license. See the LICENSE file for more info.
