package perpustakaan.utilities;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class DateToEpoch {
    public static String DateToEpochMililiseconds(String dateString){
        String result = "";
        // Define the format string. 'z' for timezone abbreviation (WIB)
        // Note: For 'WIB', Java's SimpleDateFormat might not always correctly
        // infer the offset without explicitly setting the TimeZone.
        // It's safer to explicitly set the TimeZone for "WIB".
        String format = "EEE MMM dd HH:mm:ss zzz yyyy";

        SimpleDateFormat sdf = new SimpleDateFormat(format);
        // Explicitly set the TimeZone for WIB (Western Indonesian Time)
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Jakarta")); // Or "GMT+7"
        
        try {
            Date date = sdf.parse(dateString);
            long epochMillis = date.getTime(); // Epoch in milliseconds
            result = String.valueOf(epochMillis);
        } catch (ParseException e) {
            System.err.println("Error parsing date string: " + e.getMessage());
        }
        return result;
    }
}