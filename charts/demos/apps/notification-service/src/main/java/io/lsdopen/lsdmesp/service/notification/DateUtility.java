package io.lsdopen.lsdmesp.service.notification;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class DateUtility {
    private static final String TIME_ZONE_ID_SAST = "Africa/Johannesburg";
    private static final String DEFAULT_DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss";

    public static String getDateTimePattern() {
        return DEFAULT_DATE_TIME_PATTERN;
    }

    public static SimpleDateFormat getDateTimeFormatter() {
        return new SimpleDateFormat(getDateTimePattern());
    }

    public static TimeZone getSASTTimeZone() {
        return TimeZone.getTimeZone(TIME_ZONE_ID_SAST);
    }

    public static String toStringDateTimeSAST(Date d) {
        SimpleDateFormat sdf = getDateTimeFormatter();
        sdf.setTimeZone(getSASTTimeZone());
        return sdf.format(d);
    }

    public static Date toDateTimeSAST(String s) {
        try {
            SimpleDateFormat sdf = getDateTimeFormatter();
            sdf.setTimeZone(getSASTTimeZone());
            return sdf.parse(s);
        } catch (ParseException ex) {
            throw new IllegalArgumentException("Failed to parse date string:" + s, ex);
        }
    }
}
