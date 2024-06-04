import 'package:encrypt/encrypt.dart';
import 'package:finan_master_app/shared/infra/drivers/crypt/i_crypt_aes.dart';

class CryptAES implements ICryptAES {
  static const String _key = String.fromEnvironment('AES_KEY');
  static const String _iv = String.fromEnvironment('AES_IV');

  Encrypter get _encrypter => Encrypter(AES(Key.fromUtf8(_key)));

  @override
  String encrypt(String value) => _encrypter.encrypt(value, iv: IV.fromUtf8(_iv)).base64;

  @override
  String decrypt(String value) => _encrypter.decrypt(Encrypted.fromBase64(value), iv: IV.fromUtf8(_iv));
}
