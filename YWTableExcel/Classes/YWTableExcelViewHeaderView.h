//
//  YWTableExcelViewHeaderView.h
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/12.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWColumnMode;
@class YWExcelCellConfig;

NS_ASSUME_NONNULL_BEGIN

@interface YWTableExcelViewHeaderView : UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier NS_UNAVAILABLE;

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                             cellConfig:(YWExcelCellConfig *)config;

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                                  fixed:(NSArray <YWColumnMode *>*)fixedColumn
                                  slide:(NSArray <YWColumnMode *>*)slideColumn
                             cellConfig:(YWExcelCellConfig *)config;

- (void)setupViewWithFixed:(NSArray <YWColumnMode *>*)fixedColumn
                     slide:(NSArray <YWColumnMode *>*)slideColumn;

- (void)reloadDataFixed:(NSArray <YWColumnMode *>*)fixedColumn
                  slide:(NSArray <YWColumnMode *>*)slideColumn;

@end

NS_ASSUME_NONNULL_END
