//
//  YHSegmentViewConstant.h
//  YHSegmentViewDemo
//
//  Created by wanyehua on 2018/7/1.
//  Copyright © 2018年 万叶华. All rights reserved.
//

#ifndef YHSegmentViewConstant_h
#define YHSegmentViewConstant_h

/**<< RGB颜色 <<*/
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
/**<< 十六进制颜色 <<*/
#define HEX_COLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

/**<< 头部segementView的高度 <<*/
#define YH_SegmentViewHeight 44.f

/**<< 最小Item之间的间距 <<*/
#define YH_MinItemSpace 20.f

/**<< 标题未被选中时的颜色 <<*/
#define YH_NormalColor [UIColor blackColor]

/**<< 指示杆高度 <<*/
#define YH_IndicateHeight 3.0f

/**<< 间隔宽度 <<*/
#define YH_Space_W 2.0f

/**<< 滑动时间 <<*/
#define YH_Duration .3f

/**<< segment背景颜色 <<*/
#define YH_SegmentBgColor [UIColor whiteColor]

/**<< segmentTintColor <<*/
#define YH_SegmentTintColor [UIColor orangeColor]

#endif /* YHSegmentViewConstant_h */
