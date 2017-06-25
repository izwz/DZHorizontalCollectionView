//
//  DZHorizontalCollectionView.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZHorizontalCollectionView.h"
#import "DZHorizontalCollectionViewCell.h"
#import "DZHorizontalCollectionViewFlowLayout.h"

static NSString * const cellIndentifier = @"cellIndentifier";


@interface DZHorizontalCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) DZHorizontalCollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSMutableArray *models;

@property (nonatomic,strong) NSMutableArray *infiniteModels;

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
    
    if (self.isInfinite) {
        if (!self.infiniteModels) {
            self.infiniteModels = [NSMutableArray array];
        }
        [self.infiniteModels removeAllObjects];
        [self.infiniteModels addObjectsFromArray:array];
        [self.infiniteModels addObjectsFromArray:array];
        [self.infiniteModels addObjectsFromArray:array];
    }
    
    [self.collectionView reloadData];
    [self.pageControl setNumberOfPages:array.count];
    
    if (self.isInfinite) {
        [self setCurrentIndex:0];
    }
}

- (void)registerViewClass:(Class)viewClass refreshMthod:(SEL)method {
    self.viewClass = viewClass;
    self.refreshMethod = method;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    [self setCurrentIndex:currentIndex animated:NO];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex animated:(BOOL)animated {
    if (_currentIndex != currentIndex || currentIndex == 0) {
        _currentIndex = currentIndex;
        self.pageControl.currentPage = currentIndex;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self selectIndexPath:indexPath animated:animated];
        if ([self.delegate respondsToSelector:@selector(dzCollectionView:didSelectItemAtIndex:)]) {
            [self.delegate dzCollectionView:self didSelectItemAtIndex:currentIndex];
        }
    }
}

- (void)selectIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    if (indexPath.row < self.models.count || indexPath.row > self.models.count * 2 - 1) {
        [self transferIndexPath:indexPath];
    }else{
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

- (void)transferIndexPath:(NSIndexPath *)indexPath {
    //ABCD
    //ABCD ABCD ABCD
    if (self.isInfinite) {
        // 0 ~ self.models.count - 1
        // self.models.count ~ self.models.count * 2 - 1
        // self.models.count * 2 ~ self.models.count * 3 - 1
        NSIndexPath *targetPath;
        if (indexPath.row >= 0 && indexPath.row <= self.models.count - 1) {
            targetPath = [NSIndexPath indexPathForRow:indexPath.row + self.models.count inSection:0];
        }else if (indexPath.row >= self.models.count * 2 && indexPath.row <= self.models.count * 3 - 1){
            targetPath = [NSIndexPath indexPathForRow:indexPath.row - self.models.count inSection:0];
        }else{
            targetPath = indexPath;
        }
        [self.collectionView scrollToItemAtIndexPath:targetPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)scrollViewDidStop:(UIScrollView *)scrollView {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *currentIndexPath;
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewCell *cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (CGRectContainsRect(visibleRect, cell.frame)) {
            currentIndexPath = indexPath;
            break;
        }
    }
    id currentModel = self.isInfinite ? self.infiniteModels[currentIndexPath.row] : self.models[currentIndexPath.row];
    NSInteger realIndex = [self.models indexOfObject:currentModel];
    [self setCurrentIndex:realIndex animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isInfinite ? self.infiniteModels.count : self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger viewTag = 99;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    id model = self.isInfinite ? self.infiniteModels[indexPath.row] : self.models[indexPath.row];
    UIView *view = [cell viewWithTag:viewTag];
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
