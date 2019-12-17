//
//  YWTableExcelViewMode.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/11.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWTableExcelViewMode.h"


@implementation YWTableExcelViewMode
- (instancetype)init{
    self = [super init];
    if (self) {
        _defalutHeight = 40;
    }
    return self;
}
@end

@implementation YWColumnMode
- (instancetype)init{
    self = [super init];
    if (self) {
        _textColor = [UIColor darkGrayColor];
        _selectedBackgroundColor = [UIColor systemGrayColor];
    }
    return self;
}
@end
@implementation YWExcelCellConfig

@end
