
import 'dart:io';

class ClientCertificate implements IClientCertificate {

    static const MIN_KEY_SIZE_IN_BITS = 2048;
    static const DEFAULT_PKCS12_PASSWORD = "";
    final PrivateKey privateKey;
    List<X509Certificate> publicKeyCertificateChain;

    ClientCertificate
            (PrivateKey privateKey, List<X509Certificate> publicKeyCertificateChain) {
        if (privateKey == null) {
            throw new Exception("PrivateKey is null or empty");
        }

        this.privateKey = privateKey;

        if (privateKey is RSAPrivateKey) {
            if (((RSAPrivateKey) privateKey).getModulus().bitLength() < MIN_KEY_SIZE_IN_BITS) {
                throw new Exception(
                        "certificate key size must be at least " + MIN_KEY_SIZE_IN_BITS);
            }
        } else if ("sun.security.mscapi.RSAPrivateKey".contains(privateKey.getClass().getName()) ||
                "sun.security.mscapi.CPrivateKey".contains(privateKey.getClass().getName())) {
            try {
                Method method = privateKey.getClass().getMethod("length");
                method.setAccessible(true);
                if ((int) method.invoke(privateKey) < MIN_KEY_SIZE_IN_BITS) {
                    throw new Exception(
                            "certificate key size must be at least " + MIN_KEY_SIZE_IN_BITS);
                }
            } catch (ex) {
                throw new Exception("error accessing sun.security.mscapi.RSAPrivateKey length: "
                        + ex.getMessage());
            }
        } else {
            throw new Exception(
                    "certificate key must be an instance of java.security.interfaces.RSAPrivateKey or" +
                            " sun.security.mscapi.RSAPrivateKey");
        }

        this.publicKeyCertificateChain = publicKeyCertificateChain;
    }

   String publicCertificateHash() {
        return Base64.getEncoder().encodeToString(ClientCertificate
                    .getHash(publicKeyCertificateChain.get(0).getEncoded()));
    }

    List<String> getEncodedPublicKeyCertificateChain() {
        List<String> result = [];

        for (X509Certificate cert in publicKeyCertificateChain) {
            result.add(Base64.getEncoder().encodeToString(cert.getEncoded()));
        }
        return result;
    }

    static ClientCertificate create(InputStream pkcs12Certificate, String password) {
        // treat null password as default one - empty string
        if(password == null){
            password = DEFAULT_PKCS12_PASSWORD;
        }

        final KeyStore keystore = KeyStore.getInstance("PKCS12", "SunJSSE");
        keystore.load(pkcs12Certificate, password.toCharArray());

        final Enumeration<String> aliases = keystore.aliases();
        if (!aliases.hasMoreElements()) {
            throw new IllegalArgumentException("certificate not loaded from input stream");
        }
        String alias = aliases.nextElement();
        if (aliases.hasMoreElements()) {
            throw new IllegalArgumentException("more than one certificate alias found in input stream");
        }

        ArrayList<X509Certificate> publicKeyCertificateChain = new ArrayList<>();;
        PrivateKey privateKey = (PrivateKey) keystore.getKey(alias, password.toCharArray());

        X509Certificate publicKeyCertificate = (X509Certificate) keystore.getCertificate(alias);
        List<Certificate> chain = keystore.getCertificateChain(alias);

        if (chain != null && chain.length > 0) {
            for (Certificate c in chain) {
                publicKeyCertificateChain.add((X509Certificate) c);
            }
        }
        else{
            publicKeyCertificateChain.add(publicKeyCertificate);
        }

        return new ClientCertificate(privateKey, publicKeyCertificateChain);
    }

    static ClientCertificate create(final PrivateKey key, final X509Certificate publicKeyCertificate) {
        return new ClientCertificate(key, Arrays.asList(publicKeyCertificate));
    }

    static List<int> getHash(final List<int> inputBytes) {
        final MessageDigest md = MessageDigest.getInstance("SHA-1");
        md.update(inputBytes);
        return md.digest();
    }
}
