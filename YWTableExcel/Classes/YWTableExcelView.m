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
    } _delegateHas;
    NSMutableArray *_list;
    BOOL _isAddheadView;
    BOOL _isAddVerticalView;
    BOOL _isAddHorizontalView;
    
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

@end


@implementation YWTableExcelView

- (void)reloadData{
    [self reloadHeadData];
    [self reloadContentData];
}
- (void)reloadHeadData{
    if (_mode.style == YWTableExcelViewStyleDefalut) {
        _fixedColumnList = [self getFixedColumn:0];
        _slideColumnList = [self getSlideColumn:0];
        [_headView reloadDataFixed:_fixedColumnList slide:_slideColumnList];
    }else if (_mode.style == YWTableExcelViewStylePlain){
        _fixedColumnList = @[];
        _slideColumnList = [self getSlideColumn:0];
        [_headView reloadDataFixed:_fixedColumnList slide:_slideColumnList];
    }
}
- (void)reloadContentData{
    [_tableView reloadData];
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
    
    return cell;
}
- (void)clickExcel:(UITableViewCell *)cell column:(NSInteger)column{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    indexPath.colunmn = column;
    if (_delegateHas.didSelectColumnAtIndexPath) {
        [_delegate tableExcelView:self didSelectColumnAtIndexPath:indexPath];
    }
}
- (instancetype)initWithFrame:(CGRect)frame withMode:(YWTableExcelViewMode *)mode{
    self = [super initWithFrame:frame];
    if (self) {
        _mode = mode;
        _list = @[].mutableCopy;
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
    switch (mode.style) {
        case YWTableExcelViewStyleDefalut:
            [self createUIWithDefalut];
            break;
        case YWTableExcelViewStylePlain:
            [self createUIWithDefalut];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_NotificationID object:nil];
}

- (void)createUIWithDefalut{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headView = [[YWTableExcelViewHeaderView alloc] initWithReuseIdentifier:nil cellConfig:_cellConfig];
    [self addSubview:_headView];
    _tableView.rowHeight = _mode.defalutHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    [_headView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
    [_headView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
    [_headView addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
    [_headView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:_mode.defalutHeight];
    
    [_tableView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
    [_tableView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
    [_tableView addConstraint:NSLayoutAttributeTop equalTo:self offset:_mode.defalutHeight];
    [_tableView addConstraint:NSLayoutAttributeBottom equalTo:self offset:0];
    
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
        [self addSubview:self.verticalView];
        [self bringSubviewToFront:self.verticalView];
        [_verticalView addConstraint:NSLayoutAttributeLeft equalTo:self offset:totalWidth - 1];
        [_verticalView addConstraint:NSLayoutAttributeWidth equalTo:nil offset:2];
        [_verticalView addConstraint:NSLayoutAttributeTop equalTo:self offset:0];
        [_verticalView addConstraint:NSLayoutAttributeBottom equalTo:self offset:0];
        _isAddVerticalView = YES;
    }
}
- (void)addHorizontalView{
    if (_isAddHorizontalView) {
        return;
    }
    if (!_addverticalDivider) {
        return;
    }
    [self addSubview:self.horizontalView];
    [self bringSubviewToFront:self.horizontalView];
    [_horizontalView addConstraint:NSLayoutAttributeLeft equalTo:self offset:0];
    [_horizontalView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:2];
    [_horizontalView addConstraint:NSLayoutAttributeTop equalTo:self offset:(_mode.defalutHeight - 1)];
    [_horizontalView addConstraint:NSLayoutAttributeRight equalTo:self offset:0];
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
- (void)setDataSource:(id<YWTableExcelViewDataSource>)dataSource{
    _dataSource = dataSource;
    _dataSourceHas.section = [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)];
    _dataSourceHas.fixedCellForRowAtIndexPathForMode = [dataSource respondsToSelector:@selector(tableExcelView:fixedCellForRowAtIndexPath:)];
    _dataSourceHas.slideCellForRowAtIndexPathForMode = [dataSource respondsToSelector:@selector(tableExcelView:slideCellForRowAtIndexPath:)];
    switch (_mode.style) {
        case YWTableExcelViewStyleDefalut:
            [self createUIHeadViewWithDefalut];
            break;
        case YWTableExcelViewStylePlain:
            [self createUIHeadViewWithPlain];
            break;
        default:
            break;
    }
    [self addVerticalView];
    [self addHorizontalView];
}
- (void)setDelegate:(id<YWTableExcelViewDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.didSelectColumnAtIndexPath = [delegate respondsToSelector:@selector(tableExcelView:didSelectColumnAtIndexPath:)];
}
- (void)setAddverticalDivider:(BOOL)addverticalDivider{
    _addverticalDivider = addverticalDivider;
    [self addVerticalView];
}
- (void)setAddHorizontalDivider:(BOOL)addHorizontalDivider{
    _addHorizontalDivider = addHorizontalDivider;
    [self addHorizontalView];
}

- (UIView *)verticalView{
    if (!_verticalView) {
        _verticalView = [UIView new];
        _verticalView.backgroundColor = [UIColor redColor];
    }
    return _verticalView;
}
- (UIView *)horizontalView{
    if (!_horizontalView) {
        _horizontalView = [UIView new];
        _horizontalView.backgroundColor = [UIColor redColor];
    }
    return _horizontalView;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_NotificationID object:nil];
}
@end
