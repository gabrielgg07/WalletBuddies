import time
import requests
PORT_NUMBER = 35522
BASE_URL = f"http://127.0.0.1:{PORT_NUMBER}"




def main():

    print("Client Loading ...")
    time.sleep(5)

    print("Client Awake!")
    print("Test default endpoint")

    print(requests.get(f"{BASE_URL}/").json())
    print("Test URI endpoint")

    print(requests.get(f"{BASE_URL}/test/").json())
    print("Test 5 points")

    test_points = {
        "P1": (39.8294, -98.5796),
        "P2": (37.2312, -80.4240),
        "P3": (47.5915, -122.3326),
        "P4": (-32.1357, 12.1728),
        "P5": (39.02, -24.237),
    }

    for name, (lat, lon) in test_points.items():
        url = f"{BASE_URL}/distance?lat={lat}&lon={lon}"
        print(name, requests.get(url).json())

    PLACES = [
        "Whittemore Hall, Virginia Tech",
        "T-Mobile Park, Seattle, WA",
        "Wall Drug, South Dakota",
        "22925 Detour St., St. Clair Shores, MI, 48082",
        "Yorktown Battlefield, Yorktown, VA",
        "Best Chinese food in Nashville"
    ]

    for p in PLACES:
        start = time.time()
        r = requests.get("http://localhost:5000/getplacedist/", params={"place": p})
        end = time.time()
        print(p)
        print("Response:", r.text)
        print("Time:", round(end - start, 3), "seconds\n")

if __name__ == "__main__":
    main()
