import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class BalanceFetcher {

    public static double fetchBalance(String msisdn) {
        try {
            URL url = new URL("http://localhost:8080/IVR-Platform/api/users");
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
                    return user.getDouble("balance");
                }
            }

        } catch (Exception e) {
            System.err.println("Error fetching balance: " + e.getMessage());
        }
        return 0.00;
    }
}
