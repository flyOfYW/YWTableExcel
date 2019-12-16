//
//  YWTableExcelView.m
//  YWTableExcel_Example
//
//  Created by Mr.Yao on 2019/12/11.
//  Copyright © 2019 flyOfYW. All rights reserved.
//

#import "YWTableExcelView.h"
#import "YWTableExcelCell.h"
#import "YWTableExcelViewHeaderView.h"

@interface YWTableExcelView ()<UITableViewDelegate,UITableViewDataSource,
YWTableExcelCellDelegate>
{
    struct {
        unsigned section : 1;
        unsigned fixedCellForRowAtIndexPathForMode : 1;
        unsigned slideCellForRowAtIndexPathForMode : 1;
    } _dataSourceHas;
    struct {
        unsigned didSelectColumnAtIndexPath : 1;
        unsigned excelViewForHeaderInSectionMode : 1;
        unsigned viewForHeaderInSection : 1;
        unsigned heightForHeaderInSection : 1;
    } _delegateHas;
    NSMutableArray *_list;
    BOOL _isAddheadView;
    BOOL _isAddVerticalView;
    BOOL _isAddHorizontalView;
    NSLayoutConstraint *_top;
    NSLayoutConstraint *_bottom;
}
/**当前控制样式的mode*/
@property (nonatomic, strong) YWTableExcelViewMode *mode;
/** 内部通知的name */
@property (nonatomic, strong, readwrite) NSString *NotificationID;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YWTableExcelViewHeaderView *headView;
@property (nonatomic,   copy) NSArray <YWColumnMode *> *fixedColumnList;
@property (nonatomic,   copy) NSArray <YWColumnMode *> *slideColumnList;
@property (nonatomic, strong) YWExcelCellConfig *cellConfig;
@property (nonatomic, assign) CGFloat cellLastX;
@property (nonatomic, strong) YWTableExcelCell *excelCell;
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *horizontalView;
@property (nonatomic, strong) UIView *contentView;

@end


@implementation YWTableExcelView

- (void)reloadData{
    [self reloadHeadData];
    [self reloadContentData];
}
- (void)reloadHeadData{
    _fixedColumnList = [self getFixedColumn:0];
    _slideColumnList = [self getSlideColumn:0];
    [_headView reloadDataFixed:_fixedColumnList slide:_slideColumnList];
}
- (void)reloadContentData{
    [_tableView reloadData];
}
- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:scrollPosition];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self getSection];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getRowInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[YWTableExcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" fixed:_fixedColumnList slide:_slideColumnList cellConfig:_cellConfig];
        cell.selectionStyle = _selectionStyle == 0 ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
        cell.selection = _selectionStyle == 0 ? NO : YES;
        cell.delegate = self;
    }
    _excelCell = cell;
    __weak typeof(self)weakSelf = self;
    cell.collClick = ^(UITableViewCell *cell) {
        [weakSelf.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    };
    NSArray *fixedList = @[];
    NSArray *slideList = @[];
    if (_dataSourceHas.fixedCellForRowAtIndexPathForMode) {
        fixedList = [_dataSource tableExcelView:self fixedCellForRowAtIndexPath:indexPath];
    }
    if (_dataSourceHas.slideCellForRowAtIndexPathForMode) {
        slideList = [_dataSource tableExcelView:self slideCellForRowAtIndexPath:indexPath];
    }
    [cell reloadFixed:fixedList slide:slideList];
    fixedList = nil;
    slideList = nil;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_delegateHas.excelViewForHeaderInSectionMode) {
        YWTableExcelViewHeaderInSectionMode mode = [_delegate tableExcelView:self modeForHeaderInSection:section];
        if (mode == YWTableExcelViewHeaderInSectionModeCustom){
            if (_delegateHas.viewForHeaderInSection) {
                return [_delegate tableExcelView:self viewForHeaderInSection:section];
            }
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_delegateHas.excelViewForHeaderInSectionMode) {
        YWTableExcelViewHeaderInSectionMode mode = [_delegate tableExcelView:self modeForHeaderInSection:section];
        if (mode == YWTableExcelViewHeaderInSectionModeCustom){
            if (_delegateHas.heightForHeaderInSection) {
                return [_delegate tableExcelView:self heightForHeaderInSection:section];
            }
        }
    }
    return 0.0001f;
}
- (void)clickExcel:(UITableViewCell *)cell column:(NSInteger)column{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    indexPath.colunmn = column;
    if (_delegateHas.didSelectColumnAtIndexPath) {
        [_delegate tableExcelView:self didSelectColumnAtIndexPath:indexPath];
    }
}
//MARK: ----------- init -----------
- (instancetype)initWithFrame:(CGRect)frame withMode:(YWTableExcelViewMode *)mode{
    self = [super initWithFrame:frame];
    if (self) {
        _mode = mode;
        _list = @[].mutableCopy;
        _dividerColor = [UIColor redColor];
        _widthOrHeight = 1;
        [self prepareInit:mode];
    }
    return self;
}

- (void)prepareInit:(YWTableExcelViewMode *)mode{
    
    //以当前对象的指针地址为通知的名称，这样可以避免同一个界面，有多个YWExcelView的对象时，引起的通知混乱
    _NotificationID = [NSString stringWithFormat:@"%p",self];
    _cellConfig = [YWExcelCellConfig new];
    _cellConfig.columnStyle = mode.columnStyle;
    _cellConfig.notifiKey = _NotificationID;
    _cellConfig.columnBorderColor = mode.columnBorderColor;
    _cellConfig.columnBorderWidth = mode.columnBorderWidth;
    
    [self addSubview:self.contentView];
    [_contentView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
    [_contentView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
    _top = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [_contentView addLayoutConstraint:_top];
    _bottom = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [_contentView addLayoutConstraint:_bottom];
    
    [self createUIWithDefalut];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_NotificationID object:nil];
}

- (void)createUIWithDefalut{
    if (_mode.sectionStyle == YWTableExcelViewSectionStylePlain) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }else if (_mode.sectionStyle == YWTableExcelViewSectionStyleGrouped){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }else if (@available(iOS 13.0, *)) {
        if (_mode.sectionStyle == YWTableExcelViewSectionStyleInsetGrouped){
            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            //            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
        }
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headView = [[YWTableExcelViewHeaderView alloc] initWithReuseIdentifier:nil cellConfig:_cellConfig];
    _headView.contentView.backgroundColor = self.backgroundColor;
    [_contentView addSubview:_headView];
    _tableView.rowHeight = _mode.defalutHeight;
    _tableView.sectionFooterHeight = 0.000001f;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_contentView addSubview:_tableView];
    
    [_headView addConstraint:NSLayoutAttributeLeft equalTo:_contentView offset:0];
    [_headView addConstraint:NSLayoutAttributeRight equalTo:_contentView offset:0];
    [_headView addConstraint:NSLayoutAttributeTop equalTo:_contentView offset:0];
    [_headView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:_mode.defalutHeight];
    
    [_tableView addConstraint:NSLayoutAttributeLeft equalTo:_contentView offset:0];
    [_tableView addConstraint:NSLayoutAttributeRight equalTo:_contentView offset:0];
    [_tableView addConstraint:NSLayoutAttributeTop equalTo:_headView toAttribute:NSLayoutAttributeBottom offset:0];
    [_tableView addConstraint:NSLayoutAttributeBottom equalTo:_contentView offset:0];
    
}

- (void)createUIHeadViewWithDefalut{
    if (_isAddheadView) {
        return;
    }
    _fixedColumnList = [self getFixedColumn:0];
    _slideColumnList = [self getSlideColumn:0];
    [_headView setupViewWithFixed:_fixedColumnList slide:_slideColumnList];
    _isAddheadView = YES;
}

- (void)createUIHeadViewWithPlain{
    if (_isAddheadView) {
        return;
    }
    _fixedColumnList = @[];
    _slideColumnList = [self getSlideColumn:0];
    [_headView setupViewWithFixed:_fixedColumnList slide:_slideColumnList];
    _isAddheadView = YES;
}
- (void)addVerticalView{
    if (_isAddVerticalView) {
        return;
    }
    if (_fixedColumnList.count > 0 && _addverticalDivider) {
        CGFloat totalWidth = 0;
        for (YWColumnMode *model in _fixedColumnList) {
            totalWidth += model.width;
        }
        [_contentView addSubview:self.verticalView];
        [_contentView bringSubviewToFront:self.verticalView];
        [_verticalView addConstraint:NSLayoutAttributeLeft equalTo:_contentView offset:totalWidth - _widthOrHeight/2.0];
        [_verticalView addConstraint:NSLayoutAttributeWidth equalTo:nil offset:_widthOrHeight];
        [_verticalView addConstraint:NSLayoutAttributeTop equalTo:_headView offset:0];
        [_verticalView addConstraint:NSLayoutAttributeBottom equalTo:_contentView offset:0];
        _isAddVerticalView = YES;
    }
}
- (void)addHorizontalView{
    if (_isAddHorizontalView) {
        return;
    }
    if (!_addHorizontalDivider) {
        return;
    }
    [_contentView addSubview:self.horizontalView];
    [_contentView bringSubviewToFront:self.horizontalView];
    [_horizontalView addConstraint:NSLayoutAttributeLeft equalTo:_contentView offset:0];
    [_horizontalView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:_widthOrHeight];
    [_horizontalView addConstraint:NSLayoutAttributeTop equalTo:_headView offset:(_mode.defalutHeight - _widthOrHeight/2.0)];
    [_horizontalView addConstraint:NSLayoutAttributeRight equalTo:_contentView offset:0];
    _isAddHorizontalView = YES;
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.tableView]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_NotificationID object:self userInfo:@{YW_EXCEL_NOTIFI_KEY:@(self.cellLastX)}];
    }
}
-(void)scrollMove:(NSNotification*)notification{
    
    NSDictionary *noticeInfo = notification.userInfo;
    float x = [noticeInfo[YW_EXCEL_NOTIFI_KEY] floatValue];
    if (self.cellLastX != x) {//避免重复设置偏移量
        self.cellLastX = x;
    }
    
    noticeInfo = nil;
}

- (NSArray <YWColumnMode *>*)getFixedColumn:(NSInteger)section{
    if (_dataSource) {
        return [_dataSource tableExcelView:self titleForFixedHeaderInSection:section];
    }
    return @[];
}
- (NSArray <YWColumnMode *>*)getSlideColumn:(NSInteger)section{
    if (_dataSource) {
        return [_dataSource tableExcelView:self titleForSlideHeaderInSection:section];
    }
    return @[];
}
- (NSInteger)getSection{
    if (_dataSource && _dataSourceHas.section) {
        return [_dataSource numberOfSectionsInTableExcelView:self];
    }
    return 1;
}
- (NSInteger)getRowInSection:(NSInteger)section{
    if (_dataSource) {
        return [_dataSource tableExcelView:self numberOfRowsInSection:section];
    }
    return 0;
}

//MARK:-------- getter && setter ---------------

- (void)setDataSource:(id<YWTableExcelViewDataSource>)dataSource{
    _dataSource = dataSource;
    _dataSourceHas.section = [dataSource respondsToSelector:@selector(numberOfSectionsInTableExcelView:)];
    _dataSourceHas.fixedCellForRowAtIndexPathForMode = [dataSource respondsToSelector:@selector(tableExcelView:fixedCellForRowAtIndexPath:)];
    _dataSourceHas.slideCellForRowAtIndexPathForMode = [dataSource respondsToSelector:@selector(tableExcelView:slideCellForRowAtIndexPath:)];
    [self createUIHeadViewWithDefalut];
    [self addVerticalView];
    [self addHorizontalView];
}
- (void)setDelegate:(id<YWTableExcelViewDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.didSelectColumnAtIndexPath = [delegate respondsToSelector:@selector(tableExcelView:didSelectColumnAtIndexPath:)];
    _delegateHas.excelViewForHeaderInSectionMode = [delegate respondsToSelector:@selector(tableExcelView:modeForHeaderInSection:)];
    _delegateHas.viewForHeaderInSection = [delegate respondsToSelector:@selector(tableExcelView:viewForHeaderInSection:)];
    _delegateHas.heightForHeaderInSection = [delegate respondsToSelector:@selector(tableExcelView:heightForHeaderInSection:)];
    
    
}
- (void)setAddverticalDivider:(BOOL)addverticalDivider{
    _addverticalDivider = addverticalDivider;
    [self addVerticalView];
}
- (void)setAddHorizontalDivider:(BOOL)addHorizontalDivider{
    _addHorizontalDivider = addHorizontalDivider;
    [self addHorizontalView];
}
- (void)setDividerColor:(UIColor *)dividerColor{
    _dividerColor = dividerColor;
    if (_addHorizontalDivider) {
        self.horizontalView.backgroundColor = dividerColor;
    }
    if (_addverticalDivider) {
        self.verticalView.backgroundColor = dividerColor;
    }
}
- (void)setOutsideBorder:(UIColor *)outsideBorder{
    _contentView.layer.borderColor = outsideBorder.CGColor;
}
- (void)setOutsideBorderWidth:(CGFloat)outsideBorderWidth{
    _contentView.layer.borderWidth = outsideBorderWidth;
}
- (void)setTableHeaderView:(UIView *)tableHeaderView{
    [_contentView.superview removeConstraint:_top];
    [_contentView addConstraint:NSLayoutAttributeTop equalTo:self offset:CGRectGetHeight(tableHeaderView.frame)];
    [self addSubview:tableHeaderView];
    [tableHeaderView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
    [tableHeaderView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
    [tableHeaderView addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
    [tableHeaderView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:CGRectGetHeight(tableHeaderView.frame)];
    [self setNeedsLayout];
}
- (void)setTableFooterView:(UIView *)tableFooterView{
    [_contentView.superview removeConstraint:_bottom];
    [_contentView addConstraint:NSLayoutAttributeBottom equalTo:self offset:-(CGRectGetHeight(tableFooterView.frame))];
    [self addSubview:tableFooterView];
    [tableFooterView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
    [tableFooterView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
    [tableFooterView addConstraint:NSLayoutAttributeBottom equalTo:self offset:0];
    [tableFooterView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:CGRectGetHeight(tableFooterView.frame)];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}
- (UIView *)verticalView{
    if (!_verticalView) {
        _verticalView = [UIView new];
        _verticalView.backgroundColor = _dividerColor;
    }
    return _verticalView;
}
- (UIView *)horizontalView{
    if (!_horizontalView) {
        _horizontalView = [UIView new];
        _horizontalView.backgroundColor = _dividerColor;
    }
    return _horizontalView;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_NotificationID object:nil];
}
@end
