//
//  ViewController.m
//  watermarkCamera
//
//  Created by 胡礼节 on 16/1/6.
//  Copyright © 2016年 胡礼节. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
@interface ViewController (){
        UIImage *image1;
}

@end

@implementation ViewController
- (IBAction)takePicture:(id)sender {
    [self takePicture];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.watermarkType = @"picture";//选择添加图片水印还是文字水印

}

-(void)takePicture{
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    //获得相机模式下支持的媒体类型
//    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    BOOL canTakePicture = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
    }    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
//    imagePickerController.mediaTypes = [[[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil] autorelease];
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
 self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //添加水印

    if ([self.watermarkType isEqualToString:@"picture"]) {
        image1 = [UIImage imageNamed:@"xhr.jpg"];
        image1 = [self scaleToSize:image1 size:CGSizeMake(200, 120)];
        
    }else  if ([self.watermarkType isEqualToString:@"char"]){
      image1 = [self watermarkImg:@"43km" andImg:[UIImage imageNamed:@"alpha0.png"] ];
     
    }
    UIImageView *waterImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, imagePickerController.view.frame.size.height - 320, image1.size.width, image1.size.height)];
    waterImg.image = image1;
    [imagePickerController.view addSubview:waterImg];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    if ([self.watermarkType isEqualToString:@"picture"]) {
//    
//        
//        
//         image =[self addPrintImg:[UIImage imageNamed:@"xhr.jpg"]  toOriginImg:image];
//        
//    }else  if ([self.watermarkType isEqualToString:@"char"]){
//        image = [self watermarkImg:@"43KM" andImg:image];
//    }
    image = [self addPrintImg:image1 toOriginImg:image];
    [self.waterimageview setImage:image];
    self.waterimageview.contentMode = UIViewContentModeScaleAspectFit;

}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveMImage:(UIImage *)aImage

{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    //also be .jpg or another
    
    UIImage *image = aImage; // imageView is your image
    
    // Returns the data for the specified image in JPEG/PNG format.
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //UIImageJPEGRepresentation(image)
    
    [imageData writeToFile:savedImagePath atomically:NO];
    
}

-(UIImage *)watermarkImg:(NSString *)watermark andImg:(UIImage *)image{
    
    
    // 1.开启位图上下文
    // size:上下文的尺寸
    // opaque:不透明,总结:在上下文中一般都是设置不透明度,控件才是设置透明度
    // scale: 0表示不缩放
    
    image = [self scaleToSize:image size:CGSizeMake(400, 120)];

    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 绘制图片
    [image drawAtPoint:CGPointZero];
    
    // 绘制文字
    
    //
    
    UIColor * magentaColor = [UIColor redColor];
    
    UIFont * helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:130.0f];
    
    NSString * myString = watermark;
    
    [myString drawInRect:CGRectMake(0, 0, image.size.width    , 120)
          withAttributes:@{NSFontAttributeName: helveticaBold,
                           NSForegroundColorAttributeName: magentaColor
                           }];

    // 从上下文内容中生成一张图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    // 把图片写入到桌面
    
    // image -> NSData
    // 把图片生成一个png格式的二进制数据
    // png已经高清图片格式
    //    NSData *data = UIImagePNGRepresentation(image);
    // compressionQuality:图片质量
    
//    NSData *data = UIImageJPEGRepresentation(image, 0.00001);
    //    [data writeToFile:@"/Users/hulijie/Desktop/image.jpg" atomically:YES];
//    [self saveMImage:image];
//    [self.waterimageview setImage:image];
      return image;

}
/*print：添加的图片；Origin：原始图片；*/
- (UIImage *)addPrintImg:(UIImage *)print toOriginImg:(UIImage *)Origin
{
    
    //
//    print = [self scaleToSize:print size:CGSizeMake(100, 100)];
    
    
    //绘制位图的大小
    UIGraphicsBeginImageContext(Origin.size);
    
    //Draw Origin
    [Origin drawInRect:CGRectMake(0, 0, Origin.size.width, Origin.size.height)];
    
    //Draw print
    [print drawInRect:CGRectMake(0, Origin.size.height-print.size.height*2.5 -5, print.size.width*2.5, print.size.height*2.5)];
    
    
//    [print drawInRect:CGRectMake(100, Origin.size.height-300, print.size.width, print.size.height)];
    
    //返回的图形大小
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}



@end
