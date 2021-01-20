//
//  IAP_oclib.h
//  IAP_oclib
//
//  Created by MAC on 1/21/21.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
typedef void(^OnPurches_X)(NSString*);
@interface IAP_oclib : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest* productRequest;
    NSArray*validProducts;
}
@property(nonatomic, strong)OnPurches_X onrestoredcallback;
@property(nonatomic, strong)OnPurches_X onpurchesingcallback;
@property(nonatomic, strong)OnPurches_X onpurchesedcallback;
@property(nonatomic, strong)OnPurches_X onpurfailedcallback;
-(void)restoreproducts;
-(void)makepurchase:(NSString*)pid;

-(void)purchaseMyProduct:(SKProduct*)product;
@end
