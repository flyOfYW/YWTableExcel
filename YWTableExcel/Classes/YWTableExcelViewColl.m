//
//  YWTableExcelViewColl.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/12.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWTableExcelViewColl.h"
#import "UIView+Layout.h"

@interface YWTableExcelViewColl ()

@end

@implementation YWTableExcelViewColl

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        YWDrawLabel *menuLabel = [YWDrawLabel new];
        menuLabel.font = [UIFont systemFontOfSize:15];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:menuLabel];
        _menuLabel = menuLabel;
        
        [_menuLabel addConstraint:NSLayoutAttributeLeft equalTo:self.contentView offset:0];
        [_menuLabel addConstraint:NSLayoutAttributeTop equalTo:self.contentView offset:0];
        [_menuLabel addConstraint:NSLayoutAttributeWidth equalTo:self.contentView offset:0];
        [_menuLabel addConstraint:NSLayoutAttributeBottom equalTo:self.contentView offset:0];
    }
    return self;
}

@end
