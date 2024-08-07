import requests
import argparse

def translate_text(text, target='en'):
    url = "https://ftapi.pythonanywhere.com/translate"
    params = {
        'dl': target,
        'text': text
    }
    response = requests.get(url, params=params)
    if response.status_code == 200:
        try:
            return response.json()['destination-text']
        except ValueError:
            return "Error: Unable to parse response as JSON."
    else:
        return f"Error: Received status code {response.status_code}."

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Translate text using a translation API")
    parser.add_argument('text', type=str, help="Text to translate")
    parser.add_argument('target', type=str, help="Target language code")

    args = parser.parse_args()

    translated_text = translate_text(args.text, args.target)
    print(translated_text)
