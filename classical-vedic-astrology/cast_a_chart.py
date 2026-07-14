"""POSIX seam implementation for cast_a_chart.rish — pyswisseph / Swiss Ephemeris.

Canonical entry: rishi/bin/rishi run classical-vedic-astrology/cast_a_chart.rish
Hosted by: cast_a_chart_host.sh

Tropical zodiac signs carry each planet's dignity; sidereal Lahiri
longitudes carry the nakshatra and its pada; whole-sign houses rise
from the tropical ascendant. One clock, one sky, two lenses held
together with care.
"""
import swisseph as swe

# The birth moment, supplied by the person and honored verbatim.
YEAR, MONTH, DAY = 2004, 8, 7
LOCAL_H, LOCAL_M = 13, 11          # 1:11 PM, Indian Standard Time
TZ_OFFSET = 5.5                     # IST stands 5h30m ahead of UT
LAT, LON = 23.0333, 72.5833         # the birthplace, held as coordinates (23°02'N 72°35'E)

swe.set_sid_mode(swe.SIDM_LAHIRI)   # the Lahiri ayanamsa for the stars
FLAGS = swe.FLG_MOSEPH | swe.FLG_SPEED

ut_hour = LOCAL_H + LOCAL_M / 60.0 - TZ_OFFSET
jd = swe.julday(YEAR, MONTH, DAY, ut_hour)

SIGNS = ["Aries","Taurus","Gemini","Cancer","Leo","Virgo","Libra",
         "Scorpio","Sagittarius","Capricorn","Aquarius","Pisces"]
NAKS = ["Ashvini","Bharani","Krittika","Rohini","Mrigashirsha","Ardra",
        "Punarvasu","Pushya","Ashlesha","Magha","Purva Phalguni",
        "Uttara Phalguni","Hasta","Chitra","Swati","Vishakha","Anuradha",
        "Jyeshtha","Mula","Purva Ashadha","Uttara Ashadha","Shravana",
        "Dhanishtha","Shatabhisha","Purva Bhadrapada","Uttara Bhadrapada",
        "Revati"]

def dms(lon_in_sign):
    d = int(lon_in_sign); m = int(round((lon_in_sign - d) * 60))
    if m == 60: d, m = d + 1, 0
    return f"{d}°{m:02d}'"

def describe(name, trop, sid, asc_sign_index):
    sign_i = int(trop // 30)
    house = (sign_i - asc_sign_index) % 12 + 1
    nak_i = int(sid // (360/27))
    pada = int((sid % (360/27)) // (360/108)) + 1
    print(f"{name:9s} {SIGNS[sign_i]:12s} {dms(trop % 30):7s} "
          f"{NAKS[nak_i]:16s} pada {pada}  house {house}")

# The ascendant rises first, and the whole-sign wheel follows it.
cusps, ascmc = swe.houses_ex(jd, LAT, LON, b'W', FLAGS)
asc_trop = ascmc[0]
_, ascmc_sid = swe.houses_ex(jd, LAT, LON, b'W', FLAGS | swe.FLG_SIDEREAL)
asc_sid = ascmc_sid[0]
asc_sign = int(asc_trop // 30)
print(f"Ayanamsa (Lahiri): {dms(swe.get_ayanamsa_ut(jd) % 30)} "
      f"({swe.get_ayanamsa_ut(jd):.4f}°)")
describe("Asc", asc_trop, asc_sid, asc_sign)

BODIES = [("Sun", swe.SUN), ("Moon", swe.MOON), ("Mercury", swe.MERCURY),
          ("Venus", swe.VENUS), ("Mars", swe.MARS), ("Jupiter", swe.JUPITER),
          ("Saturn", swe.SATURN), ("Rahu", swe.TRUE_NODE)]
for name, body in BODIES:
    trop = swe.calc_ut(jd, body, FLAGS)[0][0]
    sid = swe.calc_ut(jd, body, FLAGS | swe.FLG_SIDEREAL)[0][0]
    describe(name, trop, sid, asc_sign)
    if name == "Rahu":  # Ketu stands ever opposite, whole and exact.
        describe("Ketu", (trop + 180) % 360, (sid + 180) % 360, asc_sign)
