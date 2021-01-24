//
//  IAP_oclib.m
//  IAP_oclib
//
//  Created by MAC on 1/21/21.
//

#import "IAP_oclib.h"

@implementation IAP_oclib
-(void)restoreproducts{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:NULL];
}
-(void)makepurchase:(NSString*)pid{
    NSSet *productIdentifiers = [NSSet setWithObjects:pid, nil];
    productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:productIdentifiers];
    productRequest.delegate = self;
    [productRequest start];
}
-(void)purchaseMyProduct:(SKProduct *)product{
    if([SKPaymentQueue canMakePayments]){
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        printf("can not make purchase!");
    }
}
#pragma mark StoreKit Delegate
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing:
                printf("purchasing\n");
                self.onpurchesingcallback(transaction.payment.productIdentifier);
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchased : %@",transaction.payment.productIdentifier);
                self.onpurchesedcallback(transaction.payment.productIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"restored : %@",transaction.payment.productIdentifier);
                self.onrestoredcallback(transaction.payment.productIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                printf("Purchase failed");
                self.onpurfailedcallback(transaction.payment.productIdentifier);
                break;
            case SKPaymentTransactionStateDeferred:
                printf("Purchase failed");
                self.onpurfailedcallback(transaction.payment.productIdentifier);
                break;
            default:
                break;
        }
    }
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct*validProduct = nil;
    int count = [response.products count];
    if(count>0){
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"productIdentifier : %@", validProduct.productIdentifier);
        NSLog(@"price : %@", validProduct.price);
        [self purchaseMyProduct:[validProducts objectAtIndex:0]];
    }
    else{
        printf("no products to purchase");
    }
}
@end
