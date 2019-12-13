//
//  YWTableExcelViewMode.h
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/11.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YWTableExcelViewStyle) {
    /**整体表格滑动，上下、左右均可滑动（固定n列不滑动以及组头不滑动）*/
    YWTableExcelViewStyleDefalut = 0,
    /**整体表格滑动，上下、左右均可滑动（组头不滑动）*/
    YWTableExcelViewStylePlain,
};
typedef NS_ENUM(NSInteger, YWTableExcelViewColumnStyle) {
    YWTableExcelViewColumnStyleText = 0,//纯文本显示
    YWTableExcelViewColumnStyleBtn,//每个单元格均可点击
};

@interface YWColumnMode : NSObject
/** 标题*/
@property (nonatomic, copy) NSString *text;
/**列的宽度*/
@property (nonatomic, assign) CGFloat width;

@end

__attribute__((objc_subclassing_restricted))
@interface YWTableExcelViewMode : NSObject
///模式
@property (nonatomic,assign) YWTableExcelViewStyle style;
///列的显示模式
@property (nonatomic,assign) YWTableExcelViewColumnStyle columnStyle;
///默认头部的高度
@property (nonatomic,assign) CGFloat defalutHeight;

@end

__attribute__((objc_subclassing_restricted))
@interface YWExcelCellConfig : NSObject

@property (nonatomic,  copy) NSString *notifiKey;

@property (nonatomic,assign) YWTableExcelViewColumnStyle columnStyle;

@end


NS_ASSUME_NONNULL_END
