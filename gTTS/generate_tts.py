import sys
import os
import subprocess
import requests
import logging
from gtts import gTTS

# Setup logging to a file for debugging
logging.basicConfig(filename='/tmp/generate_tts.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

def generate_sound(service_name):
    if not service_name:
        logging.error("Service name is empty")
        print("❌ Service name is empty")
        return

    filename_base = service_name.lower().replace(" ", "_")
    asterisk_path = f"/var/lib/asterisk/sounds/ivr/{filename_base}.gsm"

    # Check if sound file already exists
    if os.path.exists(asterisk_path):
        logging.info(f"Sound file already exists: {asterisk_path}")
        print(f"ℹ️ Sound file already exists: {asterisk_path}")
        return

    mp3_path = f"/tmp/{filename_base}.mp3"
    gsm_path = f"/tmp/{filename_base}.gsm"

    try:
        # 1. Save MP3
        logging.info(f"Generating MP3 for {service_name}")
        tts = gTTS(service_name, lang='en')
        tts.save(mp3_path)
        logging.info(f"MP3 saved: {mp3_path}")
        print(f"✔ MP3 saved: {mp3_path}")

        # 2. Convert to GSM
        logging.info(f"Converting MP3 to GSM: {mp3_path} -> {gsm_path}")
        subprocess.run([
            "ffmpeg", "-y", "-i", mp3_path,
            "-ar", "8000", "-ac", "1", "-ab", "13k", "-f", "gsm", gsm_path
        ], check=True)
        logging.info(f"GSM created: {gsm_path}")
        print(f"🎧 GSM created: {gsm_path}")

        # 3. Move GSM to Asterisk sounds folder
        logging.info(f"Moving GSM to Asterisk folder: {gsm_path} -> {asterisk_path}")
        os.rename(gsm_path, asterisk_path)
        logging.info(f"Moved to Asterisk folder: {asterisk_path}")
        print(f"📂 Moved to Asterisk folder: {asterisk_path}")

        # 4. Call API to scan and store sound file metadata
        api_url = "http://localhost:8080/IVR-Platform/api/soundfiles/scan"
        logging.info(f"Calling API: {api_url}")
        try:
            response = requests.post(api_url)
            if response.status_code == 200:
                logging.info(f"API scan successful: {response.text}")
                print(f"✅ API scan successful: {response.text}")
            else:
                logging.warning(f"API scan failed with status {response.status_code}: {response.text}")
                print(f"⚠️ API scan failed with status {response.status_code}: {response.text}")
        except requests.RequestException as e:
            logging.error(f"Error calling API: {e}")
            print(f"❌ Error calling API: {e}")

        # 5. Remove MP3
        logging.info(f"Removing MP3: {mp3_path}")
        os.remove(mp3_path)
        logging.info(f"Removed MP3: {mp3_path}")
        print(f"🧹 Removed MP3: {mp3_path}")

    except Exception as e:
        logging.error(f"Error processing {service_name}: {e}")
        print(f"❌ Error processing {service_name}: {e}")
        raise

if __name__ == "__main__":
    if len(sys.argv) != 2:
        logging.error("Invalid arguments. Usage: python generate_tts.py <service_name>")
        print("Usage: python generate_tts.py <service_name>")
        sys.exit(1)

    service_name = sys.argv[1]
    generate_sound(service_name)

