//
//  ViewController.h
//  watermarkCamera
//
//  Created by 胡礼节 on 16/1/6.
//  Copyright © 2016年 胡礼节. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *waterimageview;
@property NSString* watermarkType;


@end

