import org.json.JSONArray;
import org.json.JSONObject;
import org.asteriskjava.fastagi.AgiChannel;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
public class UserServicesFetcher {

    public static String fetchActiveServices(String msisdn) {
        List<String> activeServices = new ArrayList<>();
        try {
            URL url = new URL("http://localhost:8080/IVR-Platform/api/user-info");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder responseBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                responseBuilder.append(line);
            }
            reader.close();

            JSONArray users = new JSONArray(responseBuilder.toString());
            for (int i = 0; i < users.length(); i++) {
                JSONObject user = users.getJSONObject(i);
                if (msisdn.equals(user.getString("msisdn"))) {
                    JSONArray services = user.getJSONArray("services");
                    for (int j = 0; j < services.length(); j++) {
                        JSONObject service = services.getJSONObject(j);
                        if ("Active".equalsIgnoreCase(service.getString("activationStatus")) &&
                            "Basic IVR".equalsIgnoreCase(service.getString("serviceName"))) {
                            activeServices.add(service.getString("serviceName"));
                        }
                    }
                    break;
                }
            }

        } catch (Exception e) {
            System.err.println("Error fetching services: " + e.getMessage());
        }

        return activeServices.isEmpty() ? "no" : String.join(" ", activeServices);
    }

    public static void speakActiveServices(AgiChannel channel, String msisdn) throws Exception {
        String services = fetchActiveServices(msisdn);
        if ("no".equals(services)) {
            // Play a prompt indicating no services (use a generic phrase)
            channel.exec("SayAlpha", "no services");
        } else {
            // Split the services string into individual words for pronunciation
            String[] serviceWords = services.split("\\s+");
            for (String word : serviceWords) {
                // Use SayAlpha for each word to approximate pronunciation
                // Note: This is a fallback; TTS would be better
                channel.exec("SayAlpha", word);
            }
        }
    }
}
