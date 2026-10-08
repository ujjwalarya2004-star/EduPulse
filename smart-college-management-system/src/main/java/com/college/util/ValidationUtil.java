package com.college.util;

import java.util.regex.Pattern;

/**
 * Server-side input validation helper.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,15}$");

    private ValidationUtil() {}

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return isNotEmpty(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return isNotEmpty(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidMarks(double marks, double min, double max) {
        return marks >= min && marks <= max;
    }

    public static boolean isValidSemester(int semester) {
        return semester >= 1 && semester <= 8;
    }
}
