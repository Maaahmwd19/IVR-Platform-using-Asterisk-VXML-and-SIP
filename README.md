# IVR Platform using Asterisk, SIP, and VXML  
📞 Developed by ITI Telecom Application Development Track – Intake 45

## 🔍 Project Overview
This project demonstrates an end-to-end **Interactive Voice Response (IVR)** system. It connects users through a SIP client application to an Asterisk backend, interprets dialed shortcodes, and plays dynamic **VXML** scripts based on user interaction. It also includes a web-based dashboard for statistics and history tracking.

## 🎯 Key Features
- **SIP Integration**: Users connect via a SIP client and dial predefined shortcodes.
- **Dynamic Voice Flows**: Based on the shortcode, a corresponding VXML script is played using Asterisk plugins.
- **Digit Collection**: The system collects user input via DTMF using Asterisk’s AGI.
- **Web Dashboard**: View call statistics and interaction history.
- **Modular Architecture**: Separation of backend logic, voice flow logic, and web frontend.

## 🧰 Tech Stack
- **Backend**: Asterisk PBX with custom AGI plugins (Java)
- **Voice Logic**: VXML 2.0 ([W3C VoiceXML 2.0 Spec](https://www.w3.org/TR/voicexml20/))
- **Web Application**: Java Servlet-based web UI
- **Database**: PostgreSQL for logging call events and user history
- **SIP**: Softphone clients like Linphone or Zoiper for call testing

## 🏗️ System Architecture
1. **SIP Client** → Connects to Asterisk via SIP and dials shortcode  
2. **Asterisk AGI Plugin** → Matches shortcode to VXML script  
3. **VXML Execution** → Asterisk plays the script, collects digits  
4. **PostgreSQL DB** → Logs call interactions and results  
5. **Web Dashboard** → Displays stats and user history

## 📚 Learning Resources
- **Asterisk**: Configuration, dialplans, and AGI scripting
- **VoiceXML 2.0**: W3C standard for voice applications ([VoiceXML Spec](https://www.w3.org/TR/voicexml20/))
- **SIP Protocol**: Session Initiation Protocol basics
- **Java XML APIs**: Java libraries for parsing and manipulating XML

## 👥 Contributors
This project was developed and presented by **[ Sara Yousrei , Toni Emad , Mahmoud Ibrahim , Passant Abo Soad , and Rawan Ezzat ]**  
As part of our graduation from the **ITI Telecom Application Development Track – Intake 45**.

---

