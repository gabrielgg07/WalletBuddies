# app.py
# Author: Gabriel Gonzalez
# Date: 2025-10-09
# Description: Flask web service for ECE4574 HW2.
#   Includes HW1 endpoints and new /getplacedist/ feature using spherical trig + Google Places API.

from flask import Flask, jsonify, request
import math
import os
from distanceUtils import spherical_distance
from places_service import get_lat_lon

# --------------------------------------------------------------------
# Secret location (same as HW1)
# --------------------------------------------------------------------
SECRET_LAT = 37.2333
SECRET_LON = -115.8083
SECRET_LOC = "A"
PORT_NUMBER = 35522

app = Flask(__name__)

# --------------------------------------------------------------------
# HW1 endpoints
# --------------------------------------------------------------------
@app.get("/")
def describe_service():
    return {"msg": "Secret location service", "port": PORT_NUMBER}

@app.get("/test/")
def test():
    return {"msg": "All tests passed", "code": 0}

@app.get("/distance")
def get_distance():
    lat = request.args.get("lat", type=float)
    lon = request.args.get("lon", type=float)
    if lat is None or lon is None:
        return jsonify({"msg": "error", "value": "Missing lat or lon parameter"}), 400

    KM_PER_DEGREE = 111  
    dx = (lat - SECRET_LAT) * KM_PER_DEGREE
    dy = (lon - SECRET_LON) * KM_PER_DEGREE
    distance = math.sqrt(dx**2 + dy**2)
    return {"msg": "distance", "value": distance}

# --------------------------------------------------------------------
# NEW HW2 endpoint
# --------------------------------------------------------------------
@app.get("/getplacedist/")
def get_place_dist():

    place = request.args.get("place")
    if not place:
        return jsonify({"error": "Missing 'place' parameter"}), 400

    try:
        lat, lon = get_lat_lon(place)
        dist_km = spherical_distance(lat, lon, SECRET_LAT, SECRET_LON)
        return jsonify({
            "place": place,
            "lat": lat,
            "lon": lon,
            "distance_km": dist_km
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# --------------------------------------------------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT_NUMBER, debug=True)
