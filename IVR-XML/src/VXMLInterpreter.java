import org.asteriskjava.fastagi.AgiChannel;
import org.w3c.dom.*;

import javax.xml.parsers.*;
import java.io.*;
import java.util.*;
import org.json.JSONObject;

public class VXMLInterpreter {
    private final Document document;
    private final String lang;

    public static class Result {
        public String gotoTarget;

        public Result(String gotoTarget) {
            this.gotoTarget = gotoTarget;
        }
    }

    public static class GotoException extends RuntimeException {
        public final String target;

        public GotoException(String target) {
            this.target = target;
        }
    }

    public VXMLInterpreter(String filename) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder = factory.newDocumentBuilder();
        document = builder.parse(new File(filename));
        document.getDocumentElement().normalize();

        String langAttr = document.getDocumentElement().getAttribute("xml:lang");
        lang = (langAttr != null && langAttr.toLowerCase().startsWith("ar")) ? "ar" : "en";
    }

    public Result run(AgiChannel channel, String formId) throws Exception {
        Element form = getForm(formId);
        if (form == null) {
            System.err.println("Form not found: " + formId);
            return null;
        }

        Map<String, String> variables = new HashMap<>();

        NodeList fields = form.getElementsByTagName("field");
        for (int i = 0; i < fields.getLength(); i++) {
            Element field = (Element) fields.item(i);
            String fieldName = field.getAttribute("name");

            Element prompt = getFirstElementByTagName(field, "prompt");
            playPrompt(channel, prompt, variables);

            String userInput = channel.getData("beep", 1000, 11);
            System.out.println("Input for " + fieldName + ": " + userInput);
            variables.put(fieldName, userInput);

if ("msisdn".equals(fieldName)) {
    double balance = BalanceFetcher.fetchBalance(userInput);
    variables.put("balance", String.format("%.2f", balance));

String services = UserServicesFetcher.fetchActiveServices(userInput);
variables.put("services_list", services);

}


            Element filled = getFirstElementByTagName(field, "filled");
            if (filled != null) {
                try {
                    handleFilled(channel, filled, variables);
                } catch (GotoException ge) {
                    return new Result(ge.target);
                }
            }
        }

        NodeList blocks = form.getElementsByTagName("block");
        for (int i = 0; i < blocks.getLength(); i++) {
            Element block = (Element) blocks.item(i);
            NodeList children = block.getChildNodes();
            for (int j = 0; j < children.getLength(); j++) {
                Node child = children.item(j);
                if (child.getNodeType() == Node.ELEMENT_NODE) {
                    Element el = (Element) child;
                    switch (el.getTagName()) {
                        case "prompt":
                            playPrompt(channel, el, variables);
                            break;
                        case "goto":
                        case "submit":
                            return new Result(el.getAttribute("next"));
                    }
                }
            }
        }

        return null;
    }

    private void handleFilled(AgiChannel channel, Element filled, Map<String, String> variables) throws Exception {
        NodeList children = filled.getChildNodes();
        boolean matchedIf = false;

        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() != Node.ELEMENT_NODE) continue;

            Element el = (Element) child;
            String tag = el.getTagName();

            switch (tag) {
                case "if":
                    String cond = el.getAttribute("cond");
                    if (evaluateCondition(cond, variables)) {
                        matchedIf = true;
                        handleFilledChildren(channel, el, variables);
                        return;
                    }
                    break;
                case "else":
                    if (!matchedIf) {
                        handleFilledChildren(channel, el, variables);
                        return;
                    }
                    break;
                case "prompt":
                    playPrompt(channel, el, variables);
                    break;
                case "goto":
                    throw new GotoException(el.getAttribute("next"));
            }
        }
    }

    private void handleFilledChildren(AgiChannel channel, Element parent, Map<String, String> variables) throws Exception {
        NodeList children = parent.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                Element el = (Element) child;
                switch (el.getTagName()) {
                    case "prompt":
                        playPrompt(channel, el, variables);
                        break;
                    case "goto":
                        throw new GotoException(el.getAttribute("next"));
                }
            }
        }
    }

    private boolean evaluateCondition(String cond, Map<String, String> vars) {
        if (cond.contains("==")) {
            String[] parts = cond.split("==");
            String left = parts[0].trim();
            String right = parts[1].trim().replaceAll("['\"]", "");
            String val = vars.getOrDefault(left, "");
            return right.equals(val);
        }
        return false;
    }

    private void playPrompt(AgiChannel channel, Element prompt, Map<String, String> variables) throws Exception {
        if (prompt == null) return;

        NodeList children = prompt.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node node = children.item(i);
            if (node.getNodeType() == Node.TEXT_NODE) {
                String text = node.getTextContent().trim();
                if (!text.isEmpty()) {
                    String filename = text.toLowerCase().replaceAll("[^a-z0-9 ]", "").replaceAll("\\s+", "_");
                    System.out.println("Playing prompt text: " + text + " => ivr/" + filename);
                    channel.streamFile("ivr/" + filename);
                }
            } else if (node.getNodeType() == Node.ELEMENT_NODE) {
                Element el = (Element) node;
                if ("value".equals(el.getTagName()) && el.hasAttribute("expr")) {
                    String varName = el.getAttribute("expr");
                    String value = variables.getOrDefault(varName, "");
                    System.out.println("Speaking variable " + varName + ": " + value);

                    if ("msisdn".equals(varName)) {
                        sayDigits(channel, value);
                    } else if (value.matches("\\d+(\\.\\d+)?")) {
                        int number = (int) Double.parseDouble(value);
                        String[] parts = numberToAudioParts(number);
                        for (String part : parts) {
                            channel.exec("SayNumber", part);
                        }
                    } else {
			channel.exec("Festival", "\"" + value + "\"");

                    }
                }
            }
        }
    }

    private String[] numberToAudioParts(int number) {
        List<String> parts = new ArrayList<>();

        if (number >= 100) {
            int hundreds = (number / 100) * 100;
            parts.add(String.valueOf(hundreds));
            number %= 100;
        }

        if (number >= 20) {
            int tens = (number / 10) * 10;
            if (lang.equals("ar")) {
                int ones = number % 10;
                if (ones > 0) {
                    parts.add(String.valueOf(ones));
                }
                parts.add(String.valueOf(tens));
            } else {
                parts.add(String.valueOf(tens));
                number %= 10;
                if (number > 0) {
                    parts.add(String.valueOf(number));
                }
            }
        } else if (number > 0 || parts.isEmpty()) {
            parts.add(String.valueOf(number));
        }

        return parts.toArray(new String[0]);
    }

    private void sayDigits(AgiChannel channel, String digits) throws Exception {
        for (char digit : digits.toCharArray()) {
            if (Character.isDigit(digit)) {
                channel.streamFile("ivr/" + digit + "_" + lang);
            }
        }
    }

    private Element getForm(String formId) {
        NodeList forms = document.getElementsByTagNameNS("*", "form");
        for (int i = 0; i < forms.getLength(); i++) {
            Element form = (Element) forms.item(i);
            if (formId == null || formId.equals(form.getAttribute("id"))) {
                return form;
            }
        }
        return null;
    }

    private Element getFirstElementByTagName(Element parent, String tag) {
        NodeList children = parent.getElementsByTagNameNS("*", tag);
        return children.getLength() > 0 ? (Element) children.item(0) : null;
    }
}

