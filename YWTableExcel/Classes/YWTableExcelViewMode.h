//
//  YWTableExcelViewMode.h
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/11.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, YWTableExcelViewColumnStyle) {
    YWTableExcelViewColumnStyleText = 0,//纯文本显示
    YWTableExcelViewColumnStyleBtn,//每个单元格均可点击
};
typedef NS_ENUM(NSInteger, YWTableExcelViewSectionStyle) {
    YWTableExcelViewSectionStylePlain,          // regular table view
    YWTableExcelViewSectionStyleGrouped,        // sections are grouped together
    YWTableExcelViewSectionStyleInsetGrouped  API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos)  // 暂不支持
};

@interface YWColumnMode : NSObject
/** 标题*/
@property (nonatomic, copy,nullable) NSString *text;
/**列的宽度*/
@property (nonatomic, assign) CGFloat width;
/**背景颜色*/
@property (nonatomic, strong,nullable) UIColor *backgroundColor;
/**文字颜色*/
@property (nonatomic, strong) UIColor *textColor;


@end

__attribute__((objc_subclassing_restricted))
@interface YWTableExcelViewMode : NSObject
/**列的显示模式*/
@property (nonatomic,assign) YWTableExcelViewColumnStyle columnStyle;
/**默认头部的高度*/
@property (nonatomic,assign) CGFloat defalutHeight;
/**单元格的边框宽度，建议0.8*/
@property (nonatomic,assign) CGFloat columnBorderWidth;
/**单元格的边框颜色*/
@property (nonatomic,strong, nullable) UIColor *columnBorderColor;
/**组样式*/
@property (nonatomic,assign) YWTableExcelViewSectionStyle sectionStyle;


@end

__attribute__((objc_subclassing_restricted))
@interface YWExcelCellConfig : NSObject

@property (nonatomic,  copy) NSString *notifiKey;

@property (nonatomic,assign) YWTableExcelViewColumnStyle columnStyle;
/**单元格的边框宽度*/
@property (nonatomic,assign) CGFloat columnBorderWidth;
/**单元格的边框颜色*/
@property (nonatomic,strong,nullable) UIColor *columnBorderColor;

@end


NS_ASSUME_NONNULL_END
