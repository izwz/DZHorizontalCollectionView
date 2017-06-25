//
//  DZHorizontalCollectionViewFlowLayout.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/23.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZHorizontalCollectionViewFlowLayout.h"
#import "DZHorizontalCollectionView.h"

@implementation DZHorizontalCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//实现大小变化的动画效果
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    DZHorizontalCollectionView *dzCollectionView = (DZHorizontalCollectionView *)self.collectionView.superview;
    NSArray *originArray = [super layoutAttributesForElementsInRect:rect];
    if (dzCollectionView.style == DZHorizontalCollectionViewStyleDefault) {
        return originArray;
    }else if (dzCollectionView.style == DZHorizontalCollectionViewStyleCoverflow){
        NSArray *array = [[NSArray alloc] initWithArray:originArray copyItems:YES];
        //可视rect
        CGRect visibleRect = CGRectZero;
        visibleRect.origin = self.collectionView.contentOffset;
        visibleRect.size = self.collectionView.bounds.size;
        
        for (UICollectionViewLayoutAttributes *attribute in array) {
            CGFloat activeDistance = 30; //激活距离，简单理解就是在这个移动距离内，不会有大小变化，必须超过这个距离才变化
            CGFloat distance = CGRectGetMidX(visibleRect) - attribute.center.x;
            if (ABS(distance) > activeDistance ) {
                CGFloat halfWidth = self.collectionView.bounds.size.width / 2;
                CGFloat minScale = dzCollectionView.minScale ?: 0.95;
                CGFloat deltaScale = 1 - minScale;
                CGFloat targetScale = 1 - deltaScale * ((ABS(distance) - activeDistance) / (halfWidth - activeDistance));
                attribute.transform = CGAffineTransformMakeScale(targetScale, targetScale);
            }
        }
        return array;
    }
    return originArray;
}

//用来实现滑动后自动让cell停在中间
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect cvBounds = self.collectionView.bounds;
    CGFloat halfWidth = cvBounds.size.width * 0.5f;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
    NSArray* attributesArray = [self layoutAttributesForElementsInRect:cvBounds];
    UICollectionViewLayoutAttributes* candidateAttributes;
    for (UICollectionViewLayoutAttributes* attributes in attributesArray) {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if(!candidateAttributes) {
            candidateAttributes = attributes;
            continue;
        }
        if (ABS(attributes.center.x - proposedContentOffsetCenterX) < ABS(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }
    return CGPointMake(candidateAttributes.center.x - halfWidth, proposedContentOffset.y);
}

@end
