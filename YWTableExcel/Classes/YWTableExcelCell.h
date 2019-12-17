//
//  YWTableExcelCell.h
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/12.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWColumnMode;
@class YWExcelCellConfig;
@class YWTableExcelCell;
NS_ASSUME_NONNULL_BEGIN


UIKIT_EXTERN NSString *const YW_EXCEL_NOTIFI_KEY;


@protocol YWTableExcelCellDelegate <NSObject>

- (void)clickExcel:(YWTableExcelCell *)cell collectionViewForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)column;


@end

@interface YWTableExcelCell : UITableViewCell

@property (nonatomic,   weak, nullable) id <YWTableExcelCellDelegate>delegate;


@property (nonatomic,   copy, nullable)  void(^collClick)(UITableViewCell *cell);

@property (nonatomic, strong,readonly) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL selection;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        fixed:(NSArray <YWColumnMode *>*)fixedColumn
                        slide:(NSArray <YWColumnMode *>*)slideColumn
                   cellConfig:(YWExcelCellConfig *)config;
- (void)reloadFixed:(NSArray <YWColumnMode *>*)fixedColumn
              slide:(NSArray <YWColumnMode *>*)slideColumn;
- (void)selectedItemAtIndexPath:(nullable NSIndexPath *)indexPath fixedItem:(NSInteger)column;
- (void)deselectItemAtIndexPath:(nullable NSIndexPath *)indexPath fixedItem:(NSInteger)column;
@end

NS_ASSUME_NONNULL_END
