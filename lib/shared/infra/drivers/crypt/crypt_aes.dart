import 'package:encrypt/encrypt.dart';
import 'package:finan_master_app/shared/classes/env.dart';
import 'package:finan_master_app/shared/infra/drivers/crypt/i_crypt_aes.dart';

class CryptAES implements ICryptAES {
  Encrypter get _encrypter => Encrypter(AES(Key.fromUtf8(Env.aesKey)));

  @override
  String encrypt(String value) => _encrypter.encrypt(value, iv: IV.fromUtf8(Env.aesIv)).base64;

  @override
  String decrypt(String value) => _encrypter.decrypt(Encrypted.fromBase64(value), iv: IV.fromUtf8(Env.aesIv));
}
