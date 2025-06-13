import org.asteriskjava.fastagi.*;
import java.util.*;

public class IVRScript implements AgiScript {
    @Override
    public void service(AgiRequest request, AgiChannel channel) {
        try {
            channel.answer();
            String basePath = "VXML/";
            String currentFile = basePath + "menu.vxml";
            String currentForm = null;

            while (true) {
                System.out.println("Loading VXML file from: " + currentFile);
                VXMLInterpreter interpreter = new VXMLInterpreter(currentFile);
                VXMLInterpreter.Result result = interpreter.run(channel, currentForm);

                if (result == null || result.gotoTarget == null) {
                    break;
                }

                if (result.gotoTarget.startsWith("#")) {
                    // Internal form jump
                    currentForm = result.gotoTarget.substring(1);
                    continue;
                } else {
                    // External file jump
                    currentFile = basePath + result.gotoTarget;
                    currentForm = null;
                }
            }

            channel.hangup();
        } catch (Exception e) {
            System.err.println("AGI Script error: " + e.getMessage());
        }
    }
}

