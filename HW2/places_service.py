import requests
import os

API_KEY = os.getenv("GOOGLE_API_KEY")

def get_lat_lon(place_name):
    url = f"https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
    params = {
        "input": place_name,
        "inputtype": "textquery",
        "fields": "geometry",
        "key": API_KEY
    }
    r = requests.get(url, params=params)
    data = r.json()
    if data["candidates"]:
        loc = data["candidates"][0]["geometry"]["location"]
        return loc["lat"], loc["lng"]
    else:
        raise ValueError("Place not found")
