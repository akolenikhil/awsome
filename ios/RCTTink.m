// RCTCalendarModule.m
#import "RCTTink.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import "Tink/Tink.h"
#import "Tink/TINKAllConfig.h"
#import "Tink/TINKConfig.h"
#import "Tink/TINKBinaryKeysetReader.h"
#import "Tink/TINKKeysetHandle+Cleartext.h"
#import <Tink/TINKAead.h>
#import <Tink/TINKBinaryKeysetReader.h>
#import <Tink/TINKKeysetHandle+Cleartext.h>
#import <Tink/TINKPublicKeySign.h>
#import <Tink/TINKKeysetHandle.h>
#import <Tink/TINKPublicKeySignFactory.h>


@implementation RCTTink

// To export a module named RCTCalendarModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createCalendarEvent:(NSString *)title location:(NSString *)location callback: (RCTResponseSenderBlock)callback)
{
  NSInteger eventId = 1;
  callback(@[@(eventId)]);
  
  RCTLogInfo(@"Pretending to create an event %@ at %@", title, location);
}


RCT_EXPORT_METHOD(getKeys:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
  //resolve(@"hello");
  
  // Do something
  NSError *error = nil;
  // Get a config instance that enables all Tink functionality.
  TINKAllConfig *config = [[TINKAllConfig alloc] initWithError:&error];
  if (!config || error) {
    NSLog(@"Failed to init tink config, error: %@", error);
    return;
  }
  
  // Register the configuration.
  if (![TINKConfig registerConfig:config error:&error]) {
    NSLog(@"Failed to register tink config, error: %@", error);
    return;
  }
  
  // Generate an AEAD key template for AES 128 GCM.
  TINKHybridKeyTemplate *hybridTpl = [[TINKHybridKeyTemplate alloc] initWithKeyTemplate:TINKEciesP256HkdfHmacSha256Aes128Gcm error:&error];
  if (!hybridTpl || error) {
    NSLog(@"Failed to generate tink AEAD key template, error: %@", error);
    return;
  }
  
  // Get a keyset handle from the key template.
  TINKKeysetHandle *hybridHandle = [[TINKKeysetHandle alloc] initWithKeyTemplate:hybridTpl error:&error];
  if (!hybridHandle || error) {
    NSLog(@"Failed to get keyset handle from key template, error: %@", error);
    return;
  }
  
  
  TINKKeysetHandle* hybridPublichandle = [TINKKeysetHandle publicKeysetHandleWithHandle:hybridHandle error:&error];
  if (!hybridPublichandle || error) {
    NSLog(@"Failed to get keyset publichandle handle from key template, error: %@", error);
    return;
  }
  
  // Use the keyset handle to get an AEAD primitive. You can use the primitive to encrypt/decrypt data.
  /*  id<TINKAead> hybridaead = [TINKAeadFactory primitiveWithKeysetHandle:hybridHandle error:&error];
   if (!hybridaead || error) {
   NSLog(@"Failed to get AEAD primitive, error: %@", error);
   return;
   }
   */
  
  //ECDSA_P256
  // Generate an AEAD key template for AES 128 GCM.
  TINKSignatureKeyTemplate * sign_Template = [[TINKSignatureKeyTemplate alloc] initWithKeyTemplate:TINKEcdsaP256 error:&error];
  if (!sign_Template || error) {
    NSLog(@"Failed to generate TINKSignatureKeyTemplate key template, error: %@", error);
    return;
  }
  TINKKeysetHandle *sign_Handle = [[TINKKeysetHandle alloc] initWithKeyTemplate:sign_Template error:&error];
  if (!sign_Handle || error) {
    NSLog(@"Failed to get keyset handle from key template, error: %@", error);
    return;
  }
  TINKKeysetHandle* sign_PublicHandle = [TINKKeysetHandle publicKeysetHandleWithHandle:sign_Handle error:&error];
  if (!sign_PublicHandle || error) {
    NSLog(@"Failed to get keyset publichandle handle from key template, error: %@", error);
    return;
  }
  
  /*     // Use the keyset handle to get an AEAD primitive. You can use the primitive to encrypt/decrypt data.
   id<TINKAead> signaead = [TINKAeadFactory primitiveWithKeysetHandle:sign_PublicHandle error:&error];
   if (!hybridaead || error) {
   NSLog(@"Failed to get AEAD primitive, error: %@", error);
   return;
   }
   */
  
  NSData * sign_hybridTemplateData = [hybridHandle serializedKeyset];
  NSString *str_sign_hybridTemplateData= [sign_hybridTemplateData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
  NSLog(@"Sign HybridTemplateData---%@",str_sign_hybridTemplateData);
  
  
  NSData * public_hybridTemplateData = [hybridPublichandle serializedKeyset];
  NSString *str_public_hybridTemplateData = [public_hybridTemplateData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
  NSLog(@"Public HybridTemplateDat---%@",str_public_hybridTemplateData);
  
  
  
  NSData * sign_signatureTemplateData = [sign_Handle serializedKeyset];
  NSString *str_sign_signatureTemplateData = [sign_signatureTemplateData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
  NSLog(@"Sign SignatureTemplateData---%@",str_sign_signatureTemplateData);
  
  
  NSData * public_signatureTemplateData = [sign_PublicHandle serializedKeyset];
  NSString *str_public_signatureTemplateData = [public_signatureTemplateData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
  NSLog(@"Public SignatureTemplateData---%@",str_public_signatureTemplateData);
  
  NSMutableDictionary *tinkDict = [[NSMutableDictionary alloc]init];
  [tinkDict setValue:str_sign_hybridTemplateData forKey:@"private_key"];
  [tinkDict setValue:str_public_hybridTemplateData forKey:@"public_key"];
  [tinkDict setValue:str_sign_signatureTemplateData forKey:@"sign_private_key"];
  [tinkDict setValue:str_public_signatureTemplateData forKey:@"sign_public_key"];
  // [tinkDict setValue:str_public_signatureTemplateData forKey:@"HEllo"];
  
  NSLog(@"Tink Dictionary --- \n%@",tinkDict);
  NSString *jsonOfKeys = [self GetJSON:tinkDict];
  NSLog(@"json = %@", jsonOfKeys);
  // RCT_CONVERTER(<#type#>, <#name#>, <#getter#>)
  resolve(tinkDict);
}

-(NSString*)GetJSON:(id)object
{
  NSError *writeError = nil;
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
  // return jsonData;
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  return jsonString;
}


RCT_EXPORT_METHOD(encryptHybrid:(NSString *)pt publickey:(NSString *)publickey :(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  NSError *error = nil;
  id<TINKHybridEncrypt> hybridEncrypt = [TINKHybridDecryptFactory primitiveWithKeysetHandle:publickey error:&error];
  if (!hybridEncrypt || error) {
    // handle error.
  }
  
}

RCT_EXPORT_METHOD(sign:(NSString*)pt privateKey:(NSString*)privateKey : (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  //-(void) sign:(NSString*)pt privateKey:(NSString*)privateKey{
  NSData *sig = [self sign1:[pt dataUsingEncoding:NSUTF8StringEncoding] privateKey:privateKey];
  @try {
    if(sig == nil){
      resolve(nil);
    }
    NSData * encryptedData = [[sig base64EncodedStringWithOptions:0] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *out2 = [[NSString alloc] initWithBytes:[encryptedData bytes] length:[encryptedData length] encoding:NSUTF8StringEncoding];
    //  NSLog(@"encryptedData---%@",out2);
    resolve(out2);
  } @catch (NSException *exception) {
    NSLog(@"sign Exception : %@",exception.description);
  }
  
}

//RCT_EXPORT_METHOD(sign1:(NSData*)data privateKey:(NSString*) privateKey){
-(NSData*) sign1:(NSData*)data privateKey:(NSString*)privateKey{
  //deserializeKey
  NSError * error = nil;
  @try {
    TINKKeysetHandle* ret = [self deserializeKey:privateKey];
    if(ret == nil){
      return nil;
    }
    id<TINKPublicKeySign> signer = [TINKPublicKeySignFactory primitiveWithKeysetHandle:ret error:&error];
    return [signer signatureForData:data error:&error];
  } @catch (NSException *exception) {
    NSLog(@"sign1 Exception : %@",exception.description);
  };
}


//RCT_EXPORT_METHOD(deserializeKey:(NSString*)str :(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){

- (TINKKeysetHandle*) deserializeKey:(NSString*)str{
  //  NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:str options:0];
  //  NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
  //  NSLog(@"%@", decodedString);
  NSError * error = nil;
  @try {
    NSData *keybytes = [[NSData alloc] initWithBase64EncodedString:str options:0];
    TINKKeysetReader* reader = [[TINKBinaryKeysetReader alloc] initWithSerializedKeyset:keybytes error:&error];
    
    TINKKeysetHandle *deserializeKey = [[TINKKeysetHandle alloc] initCleartextKeysetHandleWithKeysetReader:reader error:&error];
    return deserializeKey;
  } @catch (NSException *exception) {
    NSLog(@"deserializeKey Exception : %@",exception.description);
  }
  return nil;;
  
}


//-(void)verifySignature1:(NSString*)pt sig:(NSString*)sig pubkey:(NSString*)pubkey {
RCT_EXPORT_METHOD(verifySignature1:(NSString*)pt sig:(NSString*)sig pubkey:(NSString*)pubkey :(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
  NSData* sigbytes = nil;
  @try {
    sigbytes = [[NSData alloc] initWithBase64EncodedString:sig options:0];
    BOOL result = [self verifySignature:[pt dataUsingEncoding:NSUTF8StringEncoding] signature:sigbytes publickKey:pubkey];
    NSLog(@"result==%d",result);
    resolve([NSNumber numberWithBool:result]);
  } @catch (NSException *exception) {
    NSLog(@"verifySignature1 Exception : %@",exception.description);
  }
}

-(BOOL)verifySignature:(NSData*) data signature:(NSData*) signature publickKey:(NSString*) publicKey{
  NSError * error = nil;
  @try {
    TINKKeysetHandle* keysetHandle = [self deserializeKey:publicKey];
    if(keysetHandle == nil){
      return false;
    }
    TINKSignatureConfig *signatureConfig = [[TINKSignatureConfig alloc] initWithError:&error];
    if (!signatureConfig || error) {
      NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    }
    
    if (![TINKConfig registerConfig:signatureConfig error:&error]) {
      NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    }
    
    id<TINKPublicKeyVerify> verifier = [TINKPublicKeyVerifyFactory
                                        primitiveWithKeysetHandle:keysetHandle
                                        error:&error];
    if (!verifier || error) {
      NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    }
    BOOL result = [verifier verifySignature:signature forData:data error:&error];
    if (!result) {
      NSLog(@"Signature was not correct.");
      return false;
    }
    return true;
    
  } @catch (NSException *exception) {
    NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    NSLog(@"verifySignature Exception : %@",exception.description);
  }
}

// MARK : Generate Symmetric Key
//-(void) generateSymmetricKey{
RCT_EXPORT_METHOD(generateSymmetricKey:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
  @try {
    
    NSError *error = nil;
    TINKAeadConfig *aeadConfig = [[TINKAeadConfig alloc] initWithError:&error];
    if (!aeadConfig || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    if (![TINKConfig registerConfig:aeadConfig error:&error]) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    TINKAeadKeyTemplate *tpl = [[TINKAeadKeyTemplate alloc] initWithKeyTemplate:TINKAes128Gcm
                                                                          error:&error];
    if (!tpl || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    TINKKeysetHandle *handle = [[TINKKeysetHandle alloc] initWithKeyTemplate:tpl error:&error];
    if (!handle || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    NSString* strSerializeKey = [self serializeKey:handle];
    NSLog(@"generateSymmetricKey ---%@",strSerializeKey);
    resolve(strSerializeKey);
  } @catch (NSException *exception) {
    
  }
}

-(NSString*) serializeKey:(TINKKeysetHandle*)ksh{
  @try {
    
    NSData *data = [ksh serializedKeyset];
    NSData * encryptedData = [[data base64EncodedStringWithOptions:0] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *out2 = [[NSString alloc] initWithBytes:[encryptedData bytes] length:[encryptedData length] encoding:NSUTF8StringEncoding];
    // NSLog(@"serializeKey out2---%@",out2);
    return out2;
  } @catch (NSException *exception) {
    NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, exception.description);
  }
  
}


//-(void)encryptSymmetric1:(NSString*) pt key:(NSString*) key{
RCT_EXPORT_METHOD(encryptSymmetric1:(NSString*) pt key:(NSString*) key :(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
  NSString * strencryptSymmetric = [self encryptSymmetric:pt data:nil key:key];
  NSLog(@"encryptSymmetric1---%@",strencryptSymmetric);
  resolve(strencryptSymmetric);
  
}
-(NSString*)encryptSymmetric :(NSString*) pt data:(NSString*) data key:(NSString*) key{
  NSData *encbytes = [self encryptSymmetricCipherText:[pt dataUsingEncoding:NSUTF8StringEncoding] ad:((data==nil) ? nil:[data dataUsingEncoding:NSUTF8StringEncoding]) key:key];
  if(encbytes == nil){
    return nil;
  }
  NSData * encryptedData = [[encbytes base64EncodedStringWithOptions:0] dataUsingEncoding:NSUTF8StringEncoding];
  NSString *encryptSymmetricOutput = [[NSString alloc] initWithBytes:[encryptedData bytes] length:[encryptedData length] encoding:NSUTF8StringEncoding];
  return encryptSymmetricOutput;
  
}
-(NSData*) encryptSymmetricCipherText:(NSData*)plaintext ad:(NSData*)ad key:(NSString*)key{
  NSError *error = nil;
  @try {
    if(plaintext == nil || plaintext.length == 0){
      return nil;
    }
    TINKKeysetHandle* ksh = [self deserializeKey:key];
    if(ksh == nil){
      return nil;
    }
    
    TINKAeadConfig *aeadConfig = [[TINKAeadConfig alloc] initWithError:&error];
    if (!aeadConfig || error) {
      // handle error.
    }
    
    if (![TINKConfig registerConfig:aeadConfig error:&error]) {
      // handle error.
    }
    
    id<TINKAead> aead = [TINKAeadFactory primitiveWithKeysetHandle:ksh error:&error];
    if (!aead || error) {
      return nil;
    }
    NSData *ciphertext = [aead encrypt:plaintext withAdditionalData:ad error:&error];
    return ciphertext;
  } @catch (NSException *exception) {
    NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, exception.description);
  }
}

// MARK :- DecryptSymmetrickey
//-(void)decryptSymmetric1 :(NSString*) cipher key:(NSString*) key {
RCT_EXPORT_METHOD(decryptSymmetric1 :(NSString*) cipher key:(NSString*) key :(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject){
  NSString * strDecryptSymmetric = [self decryptSymmetric:cipher data:nil key:key];
  NSLog(@"strDecryptSymmetric---%@",strDecryptSymmetric);
  resolve(strDecryptSymmetric);
}
-(NSString*) decryptSymmetric:(NSString*)cipher data:(NSString*) data key:(NSString*) key {
  NSData *decbytes = [self decryptSymmetricCipherText:[[NSData alloc] initWithBase64EncodedString:cipher options:0] ad:((data==nil) ? nil:[data dataUsingEncoding:NSUTF8StringEncoding]) key:key];
  if(decbytes == nil){
    return nil;
  }
  NSString *decryptSymmetricOutput = [[NSString alloc] initWithBytes:[decbytes bytes] length:[decbytes length] encoding:NSUTF8StringEncoding];
  return decryptSymmetricOutput;
}

-(NSData*)decryptSymmetricCipherText:(NSData*) ciphertext ad:(NSData*) ad key:(NSString*) key {
  NSError *error = nil;
  @try {
    if(ciphertext == nil || ciphertext.length == 0){
      return nil;
    }
    TINKKeysetHandle* ksh = [self deserializeKey:key];
    if(ksh == nil){
      return nil;
    }
    
    TINKAeadConfig *aeadConfig = [[TINKAeadConfig alloc] initWithError:&error];
    if (!aeadConfig || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    if (![TINKConfig registerConfig:aeadConfig error:&error]) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    id<TINKAead> aead = [TINKAeadFactory primitiveWithKeysetHandle:ksh error:&error];
    if (!aead || error) {
      return nil;
    }
    
    NSData *decryptCiphertext = [aead decrypt:ciphertext withAdditionalData:ad error:&error];
    if (!decryptCiphertext || error) {
      NSLog(@"Failed to decrypt ciphertext, error: %@", error.debugDescription);
      return nil;
    }
    
    return decryptCiphertext;
  } @catch (NSException *exception) {
    NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, exception.description);
  }
}

// MARK : EncryptHybrid 1
//-(void)encryptHybrid1:(NSString*) pt key:(NSString*) key{
  RCT_EXPORT_METHOD(encryptHybrid1:(NSString*) pt key:(NSString*)key :(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject){
  NSString * strencryptHybrid = [self encryptHybrid:pt data:nil publickey:key];
  NSLog(@"encryptHybrid1---%@",strencryptHybrid);
    resolve(strencryptHybrid);
  
}
-(NSString*) encryptHybrid:(NSString*) pt data:(NSString*) data publickey:(NSString*) publickey{
  NSData *encbytes = [self encrypHybridCipherText:[pt dataUsingEncoding:NSUTF8StringEncoding] context:((data==nil) ? nil:[data dataUsingEncoding:NSUTF8StringEncoding]) publicKey:publickey];
  if(encbytes == nil){
    return nil;
  }
  NSData * encryptedData = [[encbytes base64EncodedStringWithOptions:0] dataUsingEncoding:NSUTF8StringEncoding];
  NSString *encryptHybridOutput = [[NSString alloc] initWithBytes:[encryptedData bytes] length:[encryptedData length] encoding:NSUTF8StringEncoding];
  return encryptHybridOutput;
}
-(NSData*) encrypHybridCipherText:(NSData*)plaintext context:(NSData*)context publicKey:(NSString*)publicKey{
  NSError *error = nil;
  @try {
    TINKKeysetHandle* ksh = [self deserializeKey:publicKey];
    if(ksh == nil){
      return nil;
    }
    
    TINKHybridConfig *hybridConfig = [[TINKHybridConfig alloc] initWithError:&error];
    if (!hybridConfig || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    if (![TINKConfig registerConfig:hybridConfig error:&error]) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    id<TINKHybridEncrypt> hybridEncrypt =
    [TINKHybridEncryptFactory primitiveWithKeysetHandle:ksh error:&error];
    if (!hybridEncrypt || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    NSData *ciphertext = [hybridEncrypt encrypt:plaintext withContextInfo:context
                                          error:&error];
    return ciphertext;
  } @catch (NSException *exception) {
    NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, exception.description);
  }
}


// MARK : DecryptHybrid1
//- (void) decryptHybrid1:(NSString*) cipher privatekey:(NSString*) privatekey{
RCT_EXPORT_METHOD( decryptHybrid1:(NSString*) cipher privatekey:(NSString*) privatekey :(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
  NSString * strDecryptHybrid1 = [self decryptHybrid:cipher data:nil privateKey:privatekey];
  NSLog(@"decryptHybrid1---%@",strDecryptHybrid1);
  resolve(strDecryptHybrid1);
}
-(NSString*) decryptHybrid:(NSString*)cipher data:(NSString*) data privateKey:(NSString*) privatekey{
  NSData *decbytes = [self decryptHybridCipherText:[[NSData alloc] initWithBase64EncodedString:cipher options:0] context:((data==nil) ? nil:[data dataUsingEncoding:NSUTF8StringEncoding]) privateKey:privatekey];
  if(decbytes == nil){
    return nil;
  }
  NSString *decryptHybridOutput = [[NSString alloc] initWithBytes:[decbytes bytes] length:[decbytes length] encoding:NSUTF8StringEncoding];
  return decryptHybridOutput;
}
- (NSData*)decryptHybridCipherText:(NSData*)ciphertext context:(NSData*)context privateKey:(NSString*)privateKey{
  NSError *error = nil;
  @try {
    TINKKeysetHandle* ksh = [self deserializeKey:privateKey];
    if(ksh == nil){
      return nil;
    }
    TINKHybridConfig *hybridConfig = [[TINKHybridConfig alloc] initWithError:&error];
    if (!hybridConfig || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    if (![TINKConfig registerConfig:hybridConfig error:&error]) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    
    id<TINKHybridDecrypt> hybridDecrypt =
    [TINKHybridDecryptFactory primitiveWithKeysetHandle:ksh error:&error];
    if (!hybridDecrypt || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    NSData *decryptHybridCiphertext = [hybridDecrypt decrypt:ciphertext withContextInfo:context error:&error];
    if (!decryptHybridCiphertext || error) {
      NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, error.description);
    }
    return decryptHybridCiphertext;
  } @catch (NSException *exception) {
    NSLog(@"%s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__, exception.description);
  }
}

@end
