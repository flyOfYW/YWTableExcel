//
//  YWTableExcelCell.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/12.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWTableExcelCell.h"
#import "YWTableExcelViewMode.h"
#import "UIView+Layout.h"
#import "YWTableExcelViewColl.h"

NSString *const YW_EXCEL_NOTIFI_KEY = @"YWCellOffX";;



@interface YWTableExcelCell ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    YWExcelCellConfig *_config;
    NSArray *_slideColumn;//原始数据，初始化UI
    NSArray *_fixedColumn;
    
    NSArray *_slideData;
    
    BOOL _canColumn;
    
    BOOL _isAllowedNotification;
    
    CGFloat _lastOffX;
}
@property (nonatomic, strong,readwrite) UICollectionView *collectionView;
@end

@implementation YWTableExcelCell
//MARK: ----------- public -----------
- (void)reloadFixed:(NSArray <YWColumnMode *>*)fixedColumn
              slide:(NSArray <YWColumnMode *>*)slideColumn{
    _slideData = slideColumn;
    _canColumn = YES;
    if (slideColumn.count == 0) {
        _canColumn = NO;
        _slideData = _slideColumn;
    }
    [_collectionView reloadData];
    for (int i = 0 ; i < _fixedColumn.count; i ++) {
        YWColumnMode *columnModel = fixedColumn[i];
        if (_config.columnStyle != YWTableExcelViewColumnStyleBtn) {
            UILabel *label = [self.contentView viewWithTag:100 + i];
            label.text = columnModel.text;
            label.mode = columnModel;
        }else{
            UIButton *btn = [self.contentView viewWithTag:100 + i];
            btn.mode = columnModel;
            [btn setTitle:columnModel.text forState:UIControlStateNormal];
            if (columnModel.selected) {
                btn.backgroundColor = columnModel.selectedBackgroundColor;
            }else{
                btn.backgroundColor = columnModel.backgroundColor;
            }
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        fixed:(NSArray <YWColumnMode *>*)fixedColumn
                        slide:(NSArray <YWColumnMode *>*)slideColumn
                   cellConfig:(YWExcelCellConfig *)config{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _config = config;
        _slideColumn = slideColumn;
        _fixedColumn = fixedColumn;
        [self prepareInitFixed:fixedColumn slide:slideColumn];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(scrollMove:)
                                                     name:_config.notifiKey object:nil];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _slideData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWTableExcelViewColl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YWTableExcelViewColl"
                                                                           forIndexPath:indexPath];
    cell.menuLabel.borderWidth = _config.columnBorderWidth;
    cell.menuLabel.borderColor = _config.columnBorderColor;
    if (indexPath.row < _slideData.count) {
        YWColumnMode *model = _slideData[indexPath.row];
        cell.menuLabel.textColor = model.textColor;
        if (_canColumn) {
            cell.menuLabel.text = model.text;
        }else{
            cell.menuLabel.text = @"";
        }
        if (model.selected) {
            cell.contentView.backgroundColor = model.selectedBackgroundColor;
        }else{
            cell.contentView.backgroundColor = model.backgroundColor;
        }
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _slideColumn.count) {
        YWColumnMode *model = _slideColumn[indexPath.row];
        CGFloat hi = collectionView.frame.size.height;
        return CGSizeMake(model.width, hi <= 5 ? _config.defalutHeight : hi);
    }
    YWColumnMode *model =  _slideColumn.firstObject;
    return CGSizeMake(model.width, _config.defalutHeight);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_config.columnStyle == YWTableExcelViewColumnStyleBtn) {
        if (indexPath.row < _slideData.count) {
            [_delegate clickExcel:self
       collectionViewForIndexPath:indexPath
                           column:indexPath.row + _fixedColumn.count];
        }
    }else if(_config.columnStyle == YWTableExcelViewLineStyleText){
        if (self.collClick) {
            self.collClick(self);
        }
    }
}
- (void)selectedItemAtIndexPath:(nullable NSIndexPath *)indexPath fixedItem:(NSInteger)column{
    if (indexPath == nil) {
        UIView *bView = [self.contentView viewWithTag:100 + column];
        bView.mode.selected = YES;
        bView.backgroundColor = bView.mode.selectedBackgroundColor;
        return;
    }
    if (indexPath.row < _slideData.count) {
        YWColumnMode *model = _slideData[indexPath.row];
        model.selected = YES;
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}
- (void)deselectItemAtIndexPath:(nullable NSIndexPath *)indexPath fixedItem:(NSInteger)column{
    if (indexPath == nil) {
        UIView *bView = [self.contentView viewWithTag:100 + column];
        bView.mode.selected = NO;
        bView.backgroundColor = bView.mode.backgroundColor;
        return;
    }
    if (indexPath.row < _slideData.count) {
        YWColumnMode *model = _slideData[indexPath.row];
        model.selected = NO;
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}
- (void)clickColumn:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    [_delegate clickExcel:self collectionViewForIndexPath:indexPath column:btn.tag - 100];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isAllowedNotification = NO;//
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isAllowedNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isAllowedNotification) {//是自身才发通知去tableView以及其他的cell
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:_config.notifiKey
                                                            object:self
                                                          userInfo:@{YW_EXCEL_NOTIFI_KEY:@(scrollView.contentOffset.x)}];
    }
    _isAllowedNotification = NO;
}
- (void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[YW_EXCEL_NOTIFI_KEY] floatValue];
    
    if (obj != self) {
        _isAllowedNotification = YES;
        if (_lastOffX != x) {
            [_collectionView setContentOffset:CGPointMake(x, 0) animated:NO];
        }
        _lastOffX = x;
    }else{
        _isAllowedNotification = NO;
    }
    obj = nil;
}

//MARK: ----------- private -----------
- (void)prepareInitFixed:(NSArray <YWColumnMode *>*)fixedColumnList slide:(NSArray <YWColumnMode *>*)slideColumnList{
    UIView *currentLabel = nil;
    NSInteger index = 0;
    for (YWColumnMode *column in fixedColumnList) {
        UIView *titleLbl = nil;
        if (_config.columnStyle != YWTableExcelViewColumnStyleBtn) {
            YWDrawLabel *lbl = [YWDrawLabel new];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.textColor = column.textColor;
            lbl.tag = 100 + index;
            lbl.borderWidth = _config.columnBorderWidth;
            lbl.borderColor = _config.columnBorderColor;
            titleLbl = lbl;
        }else{
            YWDrawButton *btn = [YWDrawButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:column.textColor forState:UIControlStateNormal];
            btn.mode = column;
            btn.tag = 100 + index;
            [btn addTarget:self action:@selector(clickColumn:) forControlEvents:UIControlEventTouchUpInside];
            btn.borderWidth = _config.columnBorderWidth;
            btn.borderColor = _config.columnBorderColor;
            btn.backgroundColor = column.backgroundColor;
            titleLbl = btn;
        }
        [self.contentView addSubview:titleLbl];
        if (currentLabel == nil) {
            [titleLbl addConstraint:NSLayoutAttributeLeft equalTo:self.contentView offset:0];
            [titleLbl addConstraint:NSLayoutAttributeTop equalTo:self.contentView offset:0];
            [titleLbl addConstraint:NSLayoutAttributeWidth equalTo:nil offset:column.width];
            [titleLbl addConstraint:NSLayoutAttributeBottom equalTo:self.contentView offset:0];
        }else{
            [titleLbl addConstraint:NSLayoutAttributeLeft equalTo:currentLabel toAttribute:NSLayoutAttributeRight offset:0];
            [titleLbl addConstraint:NSLayoutAttributeTop equalTo:self.contentView offset:0];
            [titleLbl addConstraint:NSLayoutAttributeWidth equalTo:nil offset:column.width];
            [titleLbl addConstraint:NSLayoutAttributeBottom equalTo:self.contentView offset:0];
        }
        currentLabel = titleLbl;
        index += 1;
    }
    if (slideColumnList.count > 0) {
//        YWColumnMode *column = slideColumnList.firstObject;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        layout.itemSize = CGSizeMake(column.width, _config.defalutHeight);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = self.contentView.backgroundColor;
        [_collectionView registerClass:[YWTableExcelViewColl class] forCellWithReuseIdentifier:@"YWTableExcelViewColl"];
        [self.contentView addSubview:_collectionView];
        if (currentLabel == nil) {
            [_collectionView addConstraint:NSLayoutAttributeLeft equalTo:self.contentView offset:0];
        }else{
            [_collectionView addConstraint:NSLayoutAttributeLeft equalTo:currentLabel toAttribute:NSLayoutAttributeRight offset:0];
        }
        [_collectionView addConstraint:NSLayoutAttributeRight equalTo:self.contentView offset:0];
        [_collectionView addConstraint:NSLayoutAttributeTop equalTo:self.contentView offset:0];
        [_collectionView addConstraint:NSLayoutAttributeBottom equalTo:self.contentView offset:0];
    }
    if (_config.lineViewImage || _config.lineViewColor) {
        _lineView = [UIImageView new];
        _lineView.backgroundColor = _config.lineViewColor;
        _lineView.image = _config.lineViewImage;
        [self.contentView addSubview:_lineView];
        [_lineView addConstraint:NSLayoutAttributeLeft equalTo:self.contentView offset:0];
        [_lineView addConstraint:NSLayoutAttributeRight equalTo:self.contentView offset:1];
        [_lineView addConstraint:NSLayoutAttributeBottom equalTo:self.contentView offset:0];
        [_lineView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:_config.lineViewHeight == 0 ? 1:_config.lineViewHeight];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:_config.notifiKey
                                                  object:nil];
}
//多种手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
@end
