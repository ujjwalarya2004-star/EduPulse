package com.college.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility for hashing and verifying passwords using SHA-256 with salts.
 * Avoids plain-text password storage.
 */
public class PasswordUtil {

    private PasswordUtil() {}

    /**
     * Generates a random cryptographic salt.
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /**
     * Hashes password with the provided salt.
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String input = salt + password;
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Verifies password against stored hash.
     */
    public static boolean verifyPassword(String inputPassword, String storedHash, String storedSalt) {
        if (inputPassword == null || storedHash == null || storedSalt == null) return false;
        String computedHash = hashPassword(inputPassword, storedSalt);
        return computedHash.equalsIgnoreCase(storedHash);
    }
}
