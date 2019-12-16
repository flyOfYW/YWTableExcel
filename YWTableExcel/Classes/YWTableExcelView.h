//
//  YWTableExcelView.h
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/11.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTableExcelViewMode.h"
#import "UIView+Layout.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, YWTableExcelViewCellSelectionStyle) {
    YWTableExcelViewCellSelectionStyleStyleNone,
    YWTableExcelViewCellSelectionStyleGray
};

@class YWTableExcelView;
@protocol YWTableExcelViewDataSource<NSObject>
@required
///  组头或者表头（固定的列）
/// @param excelView YWTableExcelView
/// @param section 组
- (nullable NSArray <YWColumnMode *>*)tableExcelView:(YWTableExcelView *)excelView titleForFixedHeaderInSection:(NSInteger)section;
///  组头或者表头（可滑动的列）
/// @param excelView YWTableExcelView
/// @param section 组
- (nullable NSArray <YWColumnMode *>*)tableExcelView:(YWTableExcelView *)excelView titleForSlideHeaderInSection:(NSInteger)section;
/// 每组对应多少行
/// @param excelView YWTableExcelView
/// @param section 组
- (NSInteger)tableExcelView:(YWTableExcelView *)excelView numberOfRowsInSection:(NSInteger)section;

@optional
/// 组数
/// @param excelView YWTableExcelView
- (NSInteger)numberOfSectionsInTableExcelView:(YWTableExcelView *)excelView;
/// 返回数据对应数据源（固定的列）
/// @param excelView YWTableExcelView
/// @param indexPath indexPath
- (nullable NSArray <YWColumnMode *>*)tableExcelView:(YWTableExcelView *)excelView fixedCellForRowAtIndexPath:(NSIndexPath *)indexPath;
/// 返回数据对应数据源（可滑动的列）
/// @param excelView YWTableExcelView
/// @param indexPath indexPath
- (nullable NSArray <YWColumnMode *>*)tableExcelView:(YWTableExcelView *)excelView slideCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol YWTableExcelViewDelegate <NSObject>
@optional
/// 点击单元格的回调
/// @param tableView YWTableExcelView
/// @param indexPath indexPath(section-组|row-行|colunmn-列)
- (void)tableExcelView:(YWTableExcelView *)tableView didSelectColumnAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YWTableExcelView : UIView

/** 内部通知的name */
@property (nonatomic, strong, readonly) NSString *NotificationID;
/** 默认YWTableExcelViewCellSelectionStyleStyleNone */
@property (nonatomic, assign) YWTableExcelViewCellSelectionStyle selectionStyle;
/** 数据源的委托 */
@property (nonatomic, weak, nullable) id <YWTableExcelViewDataSource>dataSource;
/** 委托 */
@property (nonatomic, weak, nullable) id <YWTableExcelViewDelegate>delegate;
/**分割线的颜色*/
@property (nonatomic, strong) UIColor *dividerColor;
/**分割线的宽或者高*/
@property (nonatomic, assign) CGFloat widthOrHeight;
/**是否添加滑动区域分割线*/
@property (nonatomic, assign, getter=isAddSlidingAreaDivider) BOOL addverticalDivider;
/**是否添加滑动区域分割线*/
@property (nonatomic, assign, getter=isAddSlidingAreaDivider) BOOL addHorizontalDivider;



- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 构造方法
/// @param frame frame
/// @param mode mode
- (instancetype)initWithFrame:(CGRect)frame withMode:(YWTableExcelViewMode *)mode;
/// 刷新头部
- (void)reloadHeadData;
/// 刷新 内容部分
- (void)reloadContentData;
/// 刷新整个表
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
