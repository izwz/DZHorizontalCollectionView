//
//  DZHorizontalCollectionView.h
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZHorizontalCollectionView : UIView

@property (nonatomic,assign) CGFloat    margin;     /**< 左右边缘大小 */
@property (nonatomic,assign) CGFloat    spacing;    /**< cell间隔大小 */

@property (nonatomic,assign) CGFloat    itemWidth;  /**< cell间隔大小 */

- (instancetype)initWithFrame:(CGRect)frame customCell:(Class)cell;

- (void)reloadData:(NSArray *)data;

@end
