import requests
from gtts import gTTS
import os
import subprocess

url = "http://localhost:8080/IVR-Platform/api/services"
response = requests.get(url)

try:
    data = response.json()
    print("✅ Data loaded from API")
except Exception as e:
    print("❌ Error loading JSON:", e)
    exit()

services_done = set()

for item in data:
    service_name = item.get("serviceName", "")
    print(f"🔍 Found service: {service_name}")

    if service_name and service_name not in services_done:
        services_done.add(service_name)

        filename_base = service_name.lower().replace(" ", "_")
        mp3_path = f"/home/toni/Music/{filename_base}.mp3"
        gsm_path = f"/home/toni/Music/{filename_base}.gsm"
        asterisk_path = f"/var/lib/asterisk/sounds/ivr/{filename_base}.gsm"

        try:
            # 1. Save MP3
            tts = gTTS(service_name, lang='en')
            tts.save(mp3_path)
            print(f"✔ MP3 saved: {mp3_path}")

            # 2. Convert to GSM
            subprocess.run([
                "ffmpeg", "-y", "-i", mp3_path,
                "-ar", "8000", "-ac", "1", "-ab", "13k", "-f", "gsm", gsm_path
            ], check=True)
            print(f"🎧 GSM created: {gsm_path}")

            # 3. Move GSM to Asterisk sounds folder
            subprocess.run(["sudo", "mv", gsm_path, asterisk_path])
            print(f"📂 Moved to Asterisk folder: {asterisk_path}")

            # 4. Remove MP3
            os.remove(mp3_path)
            print(f"🧹 Removed MP3: {mp3_path}")

        except Exception as e:
            print(f"❌ Error in processing {service_name}: {e}")

