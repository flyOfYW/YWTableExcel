# YWTableExcel

[![CI Status](https://img.shields.io/travis/flyOfYW/YWTableExcel.svg?style=flat)](https://travis-ci.org/flyOfYW/YWTableExcel)
[![Version](https://img.shields.io/cocoapods/v/YWTableExcel.svg?style=flat)](https://cocoapods.org/pods/YWTableExcel)
[![License](https://img.shields.io/cocoapods/l/YWTableExcel.svg?style=flat)](https://cocoapods.org/pods/YWTableExcel)
[![Platform](https://img.shields.io/cocoapods/p/YWTableExcel.svg?style=flat)](https://cocoapods.org/pods/YWTableExcel)

## Example
   类似tableView的用法
```
   YWTableExcelViewMode *mode = [YWTableExcelViewMode new];
    mode.columnStyle = YWTableExcelViewColumnStyleText;//不需要点击模式
    YWTableExcelView *excelView = [[YWTableExcelView alloc] initWithFrame:CGRectZero withMode:mode];
    excelView.delegate = self;
    excelView.dataSource = self;
    [self.view addSubview:_excelView];
```

## Requirements

## Installation

YWTableExcel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YWTableExcel'
```

## Author

flyOfYW, 1498627884@qq.com

## License

YWTableExcel is available under the MIT license. See the LICENSE file for more info.
