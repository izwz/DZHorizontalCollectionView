//
//  DZHorizontalCollectionView.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZHorizontalCollectionView.h"
#import "DZHorizontalCollectionViewFlowLayout.h"

static NSString * const cellIndentifier = @"cellIndentifier";

static NSInteger const repeatCount = 1000;//


@interface DZHorizontalCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) DZHorizontalCollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSMutableArray *models;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) Class viewClass;

@property (nonatomic,assign) SEL refreshMethod;

@end

@implementation DZHorizontalCollectionView

#pragma mark - init 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    [self reloadData];
}

- (void)reloadData{
    NSArray *array;
    if ([self.dataSource respondsToSelector:@selector(contentViewForDzCollectionView:)]) {
        array = [self.dataSource contentModelsForDzCollectionView:self];
    }
    if (!self.models) {
        self.models = [NSMutableArray array];
    }
    [self.models removeAllObjects];
    [self.models addObjectsFromArray:array];
    
    [self.collectionView reloadData];
    [self.pageControl setNumberOfPages:array.count];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setCurrentIndex:0];
    });
}

- (void)registerViewClass:(Class)viewClass refreshMthod:(SEL)method {
    self.viewClass = viewClass;
    self.refreshMethod = method;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    [self setCurrentIndex:currentIndex animated:NO];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex animated:(BOOL)animated {
    if (currentIndex > self.models.count - 1 && self.models.count) {
        currentIndex = currentIndex % self.models.count;
    }
    
    NSIndexPath *currentIndexPath = [self currentIndexPath];
    NSIndexPath *targetIndexPath;
    
    if (!animated && self.isInfinite) {
        targetIndexPath = [NSIndexPath indexPathForRow:self.models.count * repeatCount / 2 + currentIndex inSection:0];
    }else{
        targetIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row - _currentIndex + currentIndex inSection:0];
    }
    if ((self.isInfinite && self.models.count > 1) || (!self.isInfinite && self.models.count)) {
        [self.collectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        [self setCurrentIndexAndPageControl:currentIndex];
    }
}

- (void)setCurrentIndexAndPageControl:(NSUInteger)currentIndex{
    if (_currentIndex != currentIndex || currentIndex == 0) {
        _currentIndex = currentIndex;
        self.pageControl.currentPage = currentIndex;
        if ([self.delegate respondsToSelector:@selector(dzCollectionView:didSelectItemAtIndex:)]) {
            [self.delegate dzCollectionView:self didSelectItemAtIndex:currentIndex];
        }
    }
}

- (NSIndexPath *)currentIndexPath{
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *currentIndexPath;
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    CGPoint centerPoint = CGPointMake(self.collectionView.bounds.size.width / 2 , self.collectionView.bounds.size.height / 2);
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewCell *cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
        CGRect cellFrameToCollectionView = cell.frame;
        cellFrameToCollectionView.origin.x = cell.frame.origin.x - self.collectionView.contentOffset.x;
        cellFrameToCollectionView.origin.y = cell.frame.origin.y - self.collectionView.contentOffset.y;
        if (CGRectContainsRect(visibleRect, cell.frame) && CGRectContainsPoint(cellFrameToCollectionView, centerPoint)) {
            currentIndexPath = indexPath;
            break;
        }
    }
    if (!currentIndexPath) {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return currentIndexPath;
}

- (void)scrollViewDidStop:(UIScrollView *)scrollView {
    NSIndexPath *currentIndexPath = [self currentIndexPath];
    NSInteger realIndex = 0;
    if (self.models.count) {
        realIndex = currentIndexPath.row % self.models.count;
    }
    [self setCurrentIndexAndPageControl:realIndex];
    if (self.isInfinite && (currentIndexPath.row == 0 || currentIndexPath.row == self.models.count * repeatCount  - 1 )) {
        [self setCurrentIndex:realIndex];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //self.models.count 为 1 时不可无限循环
    NSInteger count = (self.isInfinite && self.models.count > 1) ? self.models.count * repeatCount : self.models.count;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger viewTag = 99;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    NSInteger realIndex = 0;
    if (self.models.count) {
        realIndex = indexPath.row % self.models.count;
    }
    id model = self.models[realIndex];
    UIView *view = [cell.contentView viewWithTag:viewTag];
    if (!view) {
        if ([self.dataSource respondsToSelector:@selector(contentViewForDzCollectionView:)]) {
            view = [self.dataSource contentViewForDzCollectionView:self];
            view.tag = viewTag;
            [cell.contentView addSubview:view];
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([view respondsToSelector:self.refreshMethod]) {
        [view performSelector:self.refreshMethod withObject:model];
    }
#pragma clang diagnostic pop
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.itemWidth ?: [UIScreen mainScreen].bounds.size.width - self.margin * 2;
    CGFloat height = self.bounds.size.height;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.margin, 0, self.margin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.spacing;
}

#pragma mark - lazy laod

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    }
    return _collectionView;
}

- (DZHorizontalCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[DZHorizontalCollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}


- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 50, self.bounds.size.height - 30, 100, 30)];
    }
    return _pageControl;
}


@end
