import org.asteriskjava.fastagi.AgiServer;
import org.asteriskjava.fastagi.DefaultAgiServer;

public class IVRServer {
    public static void main(String[] args) {
        System.out.println("Starting AGI Server");
        AgiServer server = new DefaultAgiServer(new IVRScript());
        try {
            server.startup();
        } catch (Exception e) {
            System.err.println("Failed to start AGI server: " + e.getMessage());
        }
    }
}

